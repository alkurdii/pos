import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers which letter is open and which letters are learned, on this device.
class Progress extends ChangeNotifier {
  Progress._(this._prefs, this._current, this._learned);

  static const _kCurrent = 'current';
  static const _kLearned = 'learned';

  final SharedPreferences? _prefs;
  int _current;
  final Set<int> _learned;

  static Future<Progress> load(int letterCount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var current = prefs.getInt(_kCurrent) ?? 0;
      if (current < 0 || current >= letterCount) current = 0;
      final learned = (prefs.getStringList(_kLearned) ?? const [])
          .map(int.tryParse)
          .whereType<int>()
          .where((i) => i >= 0 && i < letterCount)
          .toSet();
      return Progress._(prefs, current, learned);
    } catch (_) {
      // Storage is a convenience; the app still works without it.
      return Progress._(null, 0, <int>{});
    }
  }

  /// For tests: progress that is not saved anywhere.
  @visibleForTesting
  factory Progress.inMemory() => Progress._(null, 0, <int>{});

  int get current => _current;
  Set<int> get learned => Set.unmodifiable(_learned);
  bool isLearned(int i) => _learned.contains(i);

  set current(int i) {
    if (i == _current) return;
    _current = i;
    _prefs?.setInt(_kCurrent, i);
    notifyListeners();
  }

  void toggleLearned(int i) {
    if (!_learned.remove(i)) _learned.add(i);
    _prefs?.setStringList(_kLearned, _learned.map((e) => '$e').toList());
    notifyListeners();
  }
}
