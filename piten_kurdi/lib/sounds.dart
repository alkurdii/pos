import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'letters.dart';

/// The YouTube video the letter sounds come from:
/// "پیتێن كوردی / حروف الكردي / kurdish alphabet" by Helat Abdullah Sharafani.
const String soundVideoId = 'MvKsM_omhKs';
const String soundVideoUrl = 'https://www.youtube.com/watch?v=$soundVideoId';

/// Built-in start times (seconds) for each letter in [soundVideoId].
/// Empty until someone marks them; marks made in the app are saved on the device.
const Map<String, double> defaultSoundStarts = {};

/// Sound clips longer than this are cut short.
const double maxClipSeconds = 4;
const double defaultClipSeconds = 3;

/// A part of the video: where a letter's sound starts and ends.
class SoundClip {
  const SoundClip(this.start, this.end);
  final double start;
  final double end;
}

/// Remembers where in the video each letter is said.
class SoundBank extends ChangeNotifier {
  SoundBank._(this._prefs, this._starts);

  static const _kStarts = 'sound.starts';
  final SharedPreferences? _prefs;
  final Map<String, double> _starts;

  static Future<SoundBank> load() async {
    final starts = Map<String, double>.of(defaultSoundStarts);
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kStarts);
      if (raw != null) {
        (jsonDecode(raw) as Map<String, dynamic>).forEach((k, v) {
          if (v is num) starts[k] = v.toDouble();
        });
      }
      return SoundBank._(prefs, starts);
    } catch (_) {
      return SoundBank._(null, starts);
    }
  }

  @visibleForTesting
  factory SoundBank.inMemory([Map<String, double> starts = const {}]) =>
      SoundBank._(null, Map.of(starts));

  bool has(String letter) => _starts.containsKey(letter);
  double? startOf(String letter) => _starts[letter];
  int get markedCount => kurdishLetters.where((l) => has(l.char)).length;

  /// The clip for [letter]: from its start to the next marked start, at most [maxClipSeconds].
  SoundClip? clipFor(String letter) {
    final start = _starts[letter];
    if (start == null) return null;
    double? next;
    for (final s in _starts.values) {
      if (s > start + 0.2 && (next == null || s < next)) next = s;
    }
    final end = next == null
        ? start + defaultClipSeconds
        : (next < start + maxClipSeconds ? next : start + maxClipSeconds);
    return SoundClip(start, end);
  }

  void mark(String letter, double seconds) {
    _starts[letter] = double.parse(seconds.clamp(0, 36000).toStringAsFixed(1));
    _save();
    notifyListeners();
  }

  void nudge(String letter, double by) {
    final s = _starts[letter];
    if (s == null) return;
    mark(letter, s + by);
  }

  void clear(String letter) {
    if (_starts.remove(letter) != null) {
      _save();
      notifyListeners();
    }
  }

  /// A short text with all marks, to send to the developer so they can be built in.
  String exportText() {
    final b = StringBuffer('$soundVideoUrl\n');
    for (final l in kurdishLetters) {
      final s = _starts[l.char];
      if (s != null) b.writeln('${l.char} = ${s.toStringAsFixed(1)}');
    }
    return b.toString();
  }

  void _save() {
    _prefs?.setString(_kStarts, jsonEncode(_starts));
  }
}

/// Formats seconds as m:ss.s
String clockText(double s) {
  final m = s ~/ 60;
  final rest = s - m * 60;
  return '$m:${rest.toStringAsFixed(1).padLeft(4, '0')}';
}
