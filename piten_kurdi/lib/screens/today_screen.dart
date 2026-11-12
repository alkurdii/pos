import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../letters.dart';
import '../plan.dart';
import '../theme.dart';
import '../widgets/ring.dart';
import 'practice_screen.dart';

/// Today's work: the new letters (100 times each) and the review letters (25 times each).
/// Built to be used mostly by pictures, rings and big letters, not by reading.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = AppScope.of(context).plan;
    final p = context.palette;
    return ListenableBuilder(
      listenable: plan,
      builder: (context, _) {
        final (done, total) = plan.todayTotals;
        final fresh = plan.todayNew;
        final review = plan.todayReview;
        final allKnown = plan.onlyReview && review.isEmpty;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: p.line),
              ),
              child: Row(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(color: p.green, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_rounded, color: p.onGreen, size: 20),
                        Text(
                          kurdishDigits(plan.day),
                          key: const ValueKey('day-number'),
                          style: TextStyle(color: p.onGreen, fontSize: 34, fontWeight: FontWeight.w700, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.onlyReview ? 'ڕۆژا ${kurdishDigits(plan.day)} · تەنێ دووبارەکرن' : 'ڕۆژا ${kurdishDigits(plan.day)} ژ ${kurdishDigits(StudyPlan.letterDays)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: total == 0 ? 1 : done / total,
                            minHeight: 14,
                            color: plan.todayDone ? p.green : p.sun,
                            backgroundColor: p.line,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${kurdishDigits(done)} ژ ${kurdishDigits(total)} جاران',
                          style: TextStyle(color: p.muted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (allKnown)
              _DoneCard(
                icon: Icons.emoji_events_rounded,
                title: 'هەمی پیت ب باشی دزانی!',
                text: 'پیلانا پیتان ب دوماهی هات. پاشێ دەست ب برگەیان بکە.',
              )
            else if (plan.todayDone)
              _DoneCard(
                icon: Icons.check_circle_rounded,
                title: 'ئەڤرۆ تەمام بوو ✓',
                text: plan.onlyReview ? 'سوبەهی دووبارەکرن بەردەوام دبیت.' : 'سوبەهی پیتێن نوو دێ ڤەبن.',
              ),
            if (fresh.isNotEmpty) ...[
              _SectionTitle(icon: Icons.auto_awesome_rounded, text: 'پیتێن نوو · هەر ئێک ${kurdishDigits(StudyPlan.newReps)} جار'),
              const SizedBox(height: 10),
              _LetterTiles(letters: fresh, big: true),
              const SizedBox(height: 22),
            ],
            if (review.isNotEmpty) ...[
              _SectionTitle(icon: Icons.replay_rounded, text: 'دووبارەکرن · هەر ئێک ${kurdishDigits(StudyPlan.reviewReps)} جار'),
              const SizedBox(height: 10),
              _LetterTiles(letters: review, big: false),
            ],
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: context.palette.green, size: 26),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700))),
        ],
      );
}

class _DoneCard extends StatelessWidget {
  const _DoneCard({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title, text;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: p.greenSoft, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          Icon(icon, color: p.green, size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: p.green, fontSize: 21, fontWeight: FontWeight.w700)),
                Text(text, style: TextStyle(color: p.ink, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LetterTiles extends StatelessWidget {
  const _LetterTiles({required this.letters, required this.big});
  final List<int> letters;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final plan = AppScope.of(context).plan;
    final p = context.palette;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: big ? 180 : 116,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: big ? 0.82 : 0.8,
      ),
      itemCount: letters.length,
      itemBuilder: (context, n) {
        final i = letters[n];
        final done = plan.isDone(i);
        return Material(
          color: done ? p.greenSoft : p.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: done ? p.green : p.line, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: ValueKey('today-$i'),
            enableFeedback: false,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => PracticeScreen(letterIndex: i)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FittedBox(
                      child: Text(kurdishLetters[i].char, style: letterStyle(big ? 80 : 52, done ? p.green : p.ink).copyWith(height: 1.3)),
                    ),
                  ),
                  CountRing(count: plan.count(i), target: plan.target(i), size: big ? 64 : 46),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
