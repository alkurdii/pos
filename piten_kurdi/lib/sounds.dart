import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// The YouTube video about the Kurdish alphabet the learner can watch:
/// "پیتێن كوردی / حروف الكردي / kurdish alphabet" by Helat Abdullah Sharafani.
const String alphabetVideoUrl = 'https://www.youtube.com/watch?v=MvKsM_omhKs';

/// Asset path (under `assets/`) of the recording for the letter at [index].
/// Each recording is the letter's example word, said by a native Kurmanji speaker.
String soundAsset(int index) => 'sounds/l${index.toString().padLeft(2, '0')}.mp3';

/// Plays letter recordings, one at a time. Works without internet.
class LetterSounds {
  LetterSounds._();

  static AudioPlayer? _player;

  /// The letter whose recording is playing, or null.
  static final ValueNotifier<int?> playing = ValueNotifier(null);

  static Future<void> play(int index) async {
    try {
      final player = _player ??= _create();
      await player.stop();
      playing.value = index;
      await player.play(AssetSource(soundAsset(index)));
    } catch (_) {
      playing.value = null;
    }
  }

  static AudioPlayer _create() {
    final p = AudioPlayer();
    p.onPlayerComplete.listen((_) => playing.value = null);
    return p;
  }
}
