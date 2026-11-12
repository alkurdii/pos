import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piten_kurdi/app_scope.dart';
import 'package:piten_kurdi/letters.dart';
import 'package:piten_kurdi/plan.dart';
import 'package:piten_kurdi/progress.dart';
import 'package:piten_kurdi/screens/practice_screen.dart';
import 'package:piten_kurdi/screens/today_screen.dart';
import 'package:piten_kurdi/sound_credits.dart';
import 'package:piten_kurdi/sounds.dart';
import 'package:piten_kurdi/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void finishToday(PlanState plan) {
  for (final i in [...plan.todayNew, ...plan.todayReview]) {
    plan.add(i, plan.target(i));
  }
}

void main() {
  group('StudyPlan', () {
    test('4 new letters a day over 9 days covers all 34 letters once', () {
      expect(StudyPlan.letterDays, 9);
      final all = [for (var d = 1; d <= 9; d++) ...StudyPlan.newOn(d)];
      expect(all, List.generate(34, (i) => i));
      expect(StudyPlan.newOn(1).map((i) => kurdishLetters[i].char), ['ئ', 'ا', 'ب', 'پ']);
      expect(StudyPlan.newOn(9).length, 2);
      expect(StudyPlan.newOn(10), isEmpty);
    });

    test('review is every letter from earlier days', () {
      expect(StudyPlan.introducedBefore(1), isEmpty);
      expect(StudyPlan.introducedBefore(3), [0, 1, 2, 3, 4, 5, 6, 7]);
      expect(StudyPlan.introducedBefore(20).length, 34);
    });
  });

  group('PlanState', () {
    test('targets: 100 for new letters, 25 for review, 0 otherwise', () {
      var now = DateTime(2026, 11, 12, 9);
      final plan = PlanState.inMemory(now: () => now);
      expect(plan.target(0), 100);
      expect(plan.target(4), 0);
      finishToday(plan);
      now = DateTime(2026, 11, 13, 9);
      expect(plan.checkNewDay(), isTrue);
      expect(plan.day, 2);
      expect(plan.target(4), 100);
      expect(plan.target(0), 25);
      expect(plan.todayReview, [0, 1, 2, 3]);
    });

    test('counts stop at the target and can go back by one', () {
      final plan = PlanState.inMemory();
      plan.add(0, 150);
      expect(plan.count(0), 100);
      expect(plan.isDone(0), isTrue);
      plan.add(0, -1);
      expect(plan.count(0), 99);
      plan.add(10); // not part of today
      expect(plan.count(10), 0);
    });

    test('the next day opens only on a new calendar day and only when today is done', () {
      var now = DateTime(2026, 11, 12, 9);
      final plan = PlanState.inMemory(now: () => now);
      finishToday(plan);
      expect(plan.checkNewDay(), isFalse, reason: 'same calendar day');
      now = DateTime(2026, 11, 13, 9);
      final notDone = PlanState.inMemory(now: () => DateTime(2026, 11, 12));
      expect(notDone.checkNewDay(), isFalse);
      expect(plan.checkNewDay(), isTrue);
      expect(plan.count(0), 0, reason: 'counts reset for the new day');
    });

    test('unfinished work stays on the same day', () {
      var now = DateTime(2026, 11, 12, 9);
      final plan = PlanState.inMemory(now: () => now);
      plan.add(0, 40);
      now = DateTime(2026, 11, 14, 9);
      expect(plan.checkNewDay(), isFalse);
      expect(plan.day, 1);
      expect(plan.count(0), 40);
    });

    test('letters marked as known leave the review', () {
      final plan = PlanState.inMemory()..setDay(3);
      expect(plan.todayReview.length, 8);
      plan.toggleKnown(1);
      expect(plan.todayReview, isNot(contains(1)));
      expect(plan.target(1), 0);
    });

    test('after day 9 only review remains, until everything is known', () {
      final plan = PlanState.inMemory()..setDay(10);
      expect(plan.onlyReview, isTrue);
      expect(plan.todayNew, isEmpty);
      expect(plan.todayReview.length, 34);
    });

    test('state is saved and loaded back', () async {
      SharedPreferences.setMockInitialValues({});
      final now = DateTime(2026, 11, 12);
      final a = await PlanState.load(now: () => now);
      a.setDay(2);
      a.add(5, 30);
      a.toggleKnown(0);
      final b = await PlanState.load(now: () => now);
      expect(b.day, 2);
      expect(b.count(5), 30);
      expect(b.isKnown(0), isTrue);
    });
  });

  test('every letter has a sound file and a credit', () {
    for (var i = 0; i < kurdishLetters.length; i++) {
      expect(File('assets/${letterSoundAsset(i)}').existsSync(), isTrue, reason: letterSoundAsset(i));
      expect(File('assets/${wordSoundAsset(i)}').existsSync(), isTrue, reason: wordSoundAsset(i));
    }
    expect(soundCredits.length, kurdishLetters.length);
  });

  Widget app(PlanState plan, Widget home) => AppScope(
        progress: Progress.inMemory(),
        plan: plan,
        child: MaterialApp(
          theme: buildTheme(Palette.light, Brightness.light),
          home: Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: home)),
        ),
      );

  testWidgets('today shows day 1 with its 4 new letters; tapping counts up', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final plan = PlanState.inMemory();
    await tester.pumpWidget(app(plan, const TodayScreen()));
    expect(find.byKey(const ValueKey('day-number')), findsOneWidget);
    for (final i in [0, 1, 2, 3]) {
      expect(find.byKey(ValueKey('today-$i')), findsOneWidget);
    }

    await tester.tap(find.byKey(const ValueKey('today-2')));
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);

    for (var n = 0; n < 3; n++) {
      await tester.tap(find.byKey(const ValueKey('tap-count')));
      await tester.pump();
    }
    expect(plan.count(2), 3);
    expect(find.text('٣ / ١٠٠'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('undo')));
    await tester.pump();
    expect(plan.count(2), 2);

    plan.add(2, 200);
    await tester.pump();
    expect(find.byKey(const ValueKey('next-letter')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('next-letter')));
    await tester.pumpAndSettle();
    expect(find.text('٠ / ١٠٠'), findsOneWidget);
  });
}
