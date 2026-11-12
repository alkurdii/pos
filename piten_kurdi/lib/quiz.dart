import 'dart:math';

import 'letters.dart';

/// One quiz question: a picture word and four letters to pick from.
class QuizQuestion {
  const QuizQuestion(this.letter, this.choices);
  final KurdishLetter letter;
  final List<String> choices;
}

/// Picks questions and keeps the score. Pure Dart so it is easy to test.
class Quiz {
  Quiz({Random? random, List<KurdishLetter> letters = kurdishLetters})
      : _random = random ?? Random(),
        _letters = letters,
        pool = letters.where((l) => l.startsWord).toList();

  final Random _random;
  final List<KurdishLetter> _letters;

  /// Only words that start with their letter make a fair question.
  final List<KurdishLetter> pool;

  int asked = 0;
  int rightFirstTry = 0;
  KurdishLetter? _last;

  QuizQuestion next() {
    KurdishLetter pick;
    do {
      pick = pool[_random.nextInt(pool.length)];
    } while (pool.length > 1 && identical(pick, _last));
    _last = pick;
    return QuizQuestion(pick, choicesFor(pick));
  }

  /// The right letter, up to two letters that look like it, then random ones.
  List<String> choicesFor(KurdishLetter target) {
    final picks = <String>[target.char];
    for (final group in lookalikeGroups) {
      if (group.contains(target.char)) {
        final others = group.where((c) => c != target.char).toList()
          ..shuffle(_random);
        picks.addAll(others.take(2));
      }
    }
    final rest = _letters.map((l) => l.char).where((c) => !picks.contains(c)).toList()
      ..shuffle(_random);
    while (picks.length < 4) {
      picks.add(rest.removeLast());
    }
    return picks..shuffle(_random);
  }

  /// Records a finished question. [firstTry] is true when no wrong answer came first.
  void finish({required bool firstTry}) {
    asked++;
    if (firstTry) rightFirstTry++;
  }
}
