import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'letters.dart';

/// The daily study plan:
/// - 4 new letters a day, each repeated 100 times.
/// - Every letter from earlier days is reviewed 25 times a day,
///   until it is marked as known well.
/// - The next day opens on the next calendar day, once today's work is done.
class StudyPlan {
  static const int newPerDay = 4;
  static const int newReps = 100;
  static const int reviewReps = 25;

  static int get letterDays => (kurdishLetters.length / newPerDay).ceil();

  /// Letter indexes that are new on [day] (day 1 is the first day).
  static List<int> newOn(int day) {
    if (day < 1) return const [];
    final from = (day - 1) * newPerDay;
    if (from >= kurdishLetters.length) return const [];
    final to = (from + newPerDay).clamp(0, kurdishLetters.length);
    return [for (var i = from; i < to; i++) i];
  }

  /// Letter indexes introduced on days before [day].
  static List<int> introducedBefore(int day) {
    final n = ((day - 1) * newPerDay).clamp(0, kurdishLetters.length);
    return [for (var i = 0; i < n; i++) i];
  }
}

String dateKey(DateTime t) =>
    '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';

/// Where the learner is in the plan. Saved on the device.
class PlanState extends ChangeNotifier {
  PlanState._(this._prefs, this._now, this._day, this._dayStarted, this._counts, this._known);

  static const _kDay = 'plan.day';
  static const _kStarted = 'plan.started';
  static const _kCounts = 'plan.counts';
  static const _kKnown = 'plan.known';

  final SharedPreferences? _prefs;
  final DateTime Function() _now;
  int _day;
  String _dayStarted;
  final Map<int, int> _counts;
  final Set<int> _known;

  static Future<PlanState> load({DateTime Function()? now}) async {
    final clock = now ?? DateTime.now;
    try {
      final prefs = await SharedPreferences.getInstance();
      final counts = <int, int>{};
      final raw = prefs.getString(_kCounts);
      if (raw != null) {
        (jsonDecode(raw) as Map<String, dynamic>).forEach((k, v) {
          final i = int.tryParse(k);
          if (i != null && v is int) counts[i] = v;
        });
      }
      final known = (prefs.getStringList(_kKnown) ?? const []).map(int.tryParse).whereType<int>().toSet();
      final state = PlanState._(
        prefs,
        clock,
        (prefs.getInt(_kDay) ?? 1).clamp(1, 999),
        prefs.getString(_kStarted) ?? dateKey(clock()),
        counts,
        known,
      );
      state.checkNewDay();
      state._save();
      return state;
    } catch (_) {
      return PlanState._(null, clock, 1, dateKey(clock()), {}, {});
    }
  }

  @visibleForTesting
  factory PlanState.inMemory({DateTime Function()? now}) {
    final clock = now ?? DateTime.now;
    return PlanState._(null, clock, 1, dateKey(clock()), {}, {});
  }

  int get day => _day;
  bool isKnown(int letter) => _known.contains(letter);
  Set<int> get known => Set.unmodifiable(_known);

  /// After the last letter day, only review remains.
  bool get onlyReview => _day > StudyPlan.letterDays;

  List<int> get todayNew => StudyPlan.newOn(_day);

  List<int> get todayReview => [
        for (final i in StudyPlan.introducedBefore(_day))
          if (!_known.contains(i)) i,
      ];

  /// How many times [letter] should be repeated today, or 0 if it is not part of today.
  int target(int letter) {
    if (todayNew.contains(letter)) return StudyPlan.newReps;
    if (todayReview.contains(letter)) return StudyPlan.reviewReps;
    return 0;
  }

  int count(int letter) => _counts[letter] ?? 0;

  bool isDone(int letter) {
    final t = target(letter);
    return t > 0 && count(letter) >= t;
  }

  bool get todayDone => [...todayNew, ...todayReview].every(isDone);

  /// Total repetitions done and needed today, for the progress bar.
  (int done, int total) get todayTotals {
    var done = 0, total = 0;
    for (final i in [...todayNew, ...todayReview]) {
      final t = target(i);
      total += t;
      done += count(i).clamp(0, t);
    }
    return (done, total);
  }

  void add(int letter, [int by = 1]) {
    final t = target(letter);
    if (t == 0) return;
    final next = (count(letter) + by).clamp(0, t);
    if (next == count(letter)) return;
    _counts[letter] = next;
    _save();
    notifyListeners();
  }

  void toggleKnown(int letter) {
    if (!_known.remove(letter)) _known.add(letter);
    _save();
    notifyListeners();
  }

  /// Opens the next day when today's work is done and the calendar day has changed.
  /// Returns true when a new day was opened.
  bool checkNewDay() {
    final today = dateKey(_now());
    if (today == _dayStarted || !todayDone) return false;
    if (onlyReview && todayReview.isEmpty) return false; // everything is known
    _day++;
    _dayStarted = today;
    _counts.clear();
    _save();
    notifyListeners();
    return true;
  }

  /// For the helper: jump to a day (for example to restart or skip ahead).
  void setDay(int day) {
    _day = day.clamp(1, StudyPlan.letterDays + 1);
    _dayStarted = dateKey(_now());
    _counts.clear();
    _save();
    notifyListeners();
  }

  void _save() {
    final p = _prefs;
    if (p == null) return;
    p.setInt(_kDay, _day);
    p.setString(_kStarted, _dayStarted);
    p.setString(_kCounts, jsonEncode(_counts.map((k, v) => MapEntry('$k', v))));
    p.setStringList(_kKnown, _known.map((e) => '$e').toList());
  }
}
