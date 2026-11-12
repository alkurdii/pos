import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// The YouTube video about the Kurdish alphabet the learner can watch:
/// "پیتێن كوردی / حروف الكردي / kurdish alphabet" by Helat Abdullah Sharafani.
const String alphabetVideoUrl = 'https://www.youtube.com/watch?v=MvKsM_omhKs';

/// Asset path (under `assets/`) of the letter itself being said (بێ، پێ، تێ …).
String letterSoundAsset(int index) => 'sounds/n${index.toString().padLeft(2, '0')}.mp3';

/// Asset path (under `assets/`) of the letter's example word (ئاگر، دار …).
String wordSoundAsset(int index) => 'sounds/l${index.toString().padLeft(2, '0')}.mp3';

/// Plays letter recordings, one at a time. Works without internet.
class LetterSounds {
  LetterSounds._();

  static AudioPlayer? _player;

  /// What is playing: `n03` for the letter at 3, `l03` for its word, or null.
  static final ValueNotifier<String?> playing = ValueNotifier(null);

  static String key(int index, {bool word = false}) => '${word ? 'l' : 'n'}$index';

  /// Says the letter at [index], or its example word when [word] is true.
  static Future<void> play(int index, {bool word = false}) async {
    try {
      final player = _player ??= _create();
      await player.stop();
      playing.value = key(index, word: word);
      await player.play(AssetSource(word ? wordSoundAsset(index) : letterSoundAsset(index)));
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
