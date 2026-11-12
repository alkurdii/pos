import 'package:flutter/material.dart';

import '../letters.dart';
import '../sounds.dart';
import '../theme.dart';

/// A speaker button. It says the letter, or the example word when [word] is true.
class PlaySoundButton extends StatelessWidget {
  const PlaySoundButton({super.key, required this.letter, this.size = 64, this.word = false});
  final KurdishLetter letter;
  final double size;
  final bool word;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final index = kurdishLetters.indexOf(letter);
    return ValueListenableBuilder<String?>(
      valueListenable: LetterSounds.playing,
      builder: (context, playing, _) {
        final on = playing == LetterSounds.key(index, word: word);
        return Semantics(
          button: true,
          label: word ? 'گوهـ بدە ${letter.word}' : 'گوهـ بدە پیتا ${letter.char}',
          child: SizedBox.square(
            dimension: size,
            child: IconButton.filled(
              key: ValueKey('${word ? 'word' : 'play'}-${letter.char}'),
              enableFeedback: false,
              iconSize: size * 0.5,
              style: IconButton.styleFrom(
                backgroundColor: on ? p.green : (word ? p.sunSoft : p.sun),
                foregroundColor: on ? p.onGreen : (word ? p.ink : const Color(0xFF2A1F00)),
              ),
              onPressed: () => LetterSounds.play(index, word: word),
              icon: Icon(on ? Icons.graphic_eq_rounded : Icons.volume_up_rounded),
            ),
          ),
        );
      },
    );
  }
}
