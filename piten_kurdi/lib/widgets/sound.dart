import 'package:flutter/material.dart';

import '../letters.dart';
import '../sounds.dart';
import '../theme.dart';

/// A big speaker button. It plays the letter's example word, said by a native speaker.
class PlaySoundButton extends StatelessWidget {
  const PlaySoundButton({super.key, required this.letter, this.size = 64});
  final KurdishLetter letter;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final index = kurdishLetters.indexOf(letter);
    return ValueListenableBuilder<int?>(
      valueListenable: LetterSounds.playing,
      builder: (context, playing, _) {
        final on = playing == index;
        return Semantics(
          button: true,
          label: 'گوهـ بدە ${letter.word}',
          child: SizedBox.square(
            dimension: size,
            child: IconButton.filled(
              key: ValueKey('play-${letter.char}'),
              enableFeedback: false,
              iconSize: size * 0.5,
              style: IconButton.styleFrom(
                backgroundColor: on ? p.green : p.sun,
                foregroundColor: on ? p.onGreen : const Color(0xFF2A1F00),
              ),
              onPressed: () => LetterSounds.play(index),
              icon: Icon(on ? Icons.graphic_eq_rounded : Icons.volume_up_rounded),
            ),
          ),
        );
      },
    );
  }
}
