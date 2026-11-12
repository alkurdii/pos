import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piten_kurdi/letters.dart';
import 'package:piten_kurdi/main.dart';
import 'package:piten_kurdi/progress.dart';
import 'package:piten_kurdi/quiz.dart';
import 'package:piten_kurdi/screens/quiz_screen.dart';
import 'package:piten_kurdi/theme.dart';

Widget wrap(Widget child) => MaterialApp(
      theme: buildTheme(Palette.light, Brightness.light),
      home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: child)),
    );

void main() {
  group('letters', () {
    test('there are 34 letters and none repeat', () {
      expect(kurdishLetters.length, 34);
      expect(kurdishLetters.map((l) => l.char).toSet().length, 34);
    });

    test('every example word contains its letter', () {
      for (final l in kurdishLetters) {
        expect(l.indexInWord, greaterThanOrEqualTo(0), reason: '${l.char} not in ${l.word}');
      }
    });

    test('lookalike groups only use real letters', () {
      final chars = kurdishLetters.map((l) => l.char).toSet();
      for (final g in lookalikeGroups) {
        expect(chars.containsAll(g), isTrue, reason: '$g');
      }
    });

    test('forms: joining letters have 4, others 2', () {
      expect(formsOf(kurdishLetters.firstWhere((l) => l.char == 'ب')).map((f) => f.text), ['ب', 'بـ', 'ـبـ', 'ـب']);
      expect(formsOf(kurdishLetters.firstWhere((l) => l.char == 'د')).map((f) => f.text), ['د', 'ـد']);
    });

    test('Kurdish digits', () {
      expect(kurdishDigits(34), '٣٤');
      expect(kurdishDigits(0), '٠');
    });
  });

  group('quiz', () {
    test('questions only use words that start with their letter', () {
      final quiz = Quiz(random: Random(1));
      for (var n = 0; n < 200; n++) {
        final q = quiz.next();
        expect(q.letter.word.startsWith(q.letter.char), isTrue);
        expect(q.choices.length, 4);
        expect(q.choices.toSet().length, 4);
        expect(q.choices, contains(q.letter.char));
      }
    });

    test('never asks the same word twice in a row', () {
      final quiz = Quiz(random: Random(7));
      var last = quiz.next().letter;
      for (var n = 0; n < 100; n++) {
        final now = quiz.next().letter;
        expect(identical(now, last), isFalse);
        last = now;
      }
    });

    test('choices include lookalike letters', () {
      final quiz = Quiz(random: Random(3));
      final be = kurdishLetters.firstWhere((l) => l.char == 'ب');
      final choices = quiz.choicesFor(be);
      expect(choices, containsAll(['ب', 'پ', 'ت']));
    });

    test('score counts only first-try answers', () {
      final quiz = Quiz(random: Random(1))
        ..finish(firstTry: true)
        ..finish(firstTry: false);
      expect(quiz.asked, 2);
      expect(quiz.rightFirstTry, 1);
    });
  });

  testWidgets('learn: next, grid tap and "learned" toggle', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final progress = Progress.inMemory();
    await tester.pumpWidget(PitenKurdiApp(progress: progress));
    expect(find.byKey(const ValueKey('big-0')), findsOneWidget);

    await tester.tap(find.text('پاشتر ←'));
    await tester.pumpAndSettle();
    expect(progress.current, 1);
    expect(find.byKey(const ValueKey('big-1')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('cell-3')));
    await tester.pumpAndSettle();
    expect(progress.current, 3);

    await tester.tap(find.byKey(const ValueKey('learned-toggle')));
    await tester.pumpAndSettle();
    expect(progress.isLearned(3), isTrue);
    expect(find.text('فێربووی ✓'), findsOneWidget);
  });

  testWidgets('quiz: wrong answer, then right answer, then next', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final quiz = Quiz(random: Random(5));
    await tester.pumpWidget(wrap(QuizScreen(quiz: quiz)));

    final word = tester.widget<Text>(find.byKey(const ValueKey('quiz-word'))).data!;
    final right = kurdishLetters.firstWhere((l) => l.word == word).char;
    final shown = kurdishLetters
        .map((l) => l.char)
        .where((c) => find.byKey(ValueKey('option-$c')).evaluate().isNotEmpty)
        .toList();
    expect(shown.length, 4);
    expect(shown, contains(right));
    final wrong = shown.firstWhere((c) => c != right);

    await tester.tap(find.byKey(ValueKey('option-$wrong')));
    await tester.pump();
    expect(find.text('نە، جارەکا دی هەول بدە'), findsOneWidget);

    await tester.tap(find.byKey(ValueKey('option-$right')));
    await tester.pump();
    expect(find.text('ئافەرین! دروستە 👏'), findsOneWidget);
    expect(quiz.asked, 1);
    expect(quiz.rightFirstTry, 0);

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pump();
    expect(find.byKey(const ValueKey('quiz-next')), findsNothing);
  });
}
