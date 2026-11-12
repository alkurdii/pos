import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_scope.dart';
import '../letters.dart';
import '../theme.dart';
import '../widgets/ring.dart';
import '../widgets/sound.dart';
import 'learn_screen.dart' show HighlightedWord;

/// Repeat one letter: say it (or write it), then tap the big letter. One tap = one time.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key, required this.letterIndex});
  final int letterIndex;

  @override
  Widget build(BuildContext context) {
    final plan = AppScope.of(context).plan;
    final p = context.palette;
    final letter = kurdishLetters[letterIndex];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: p.bg,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            iconSize: 32,
            tooltip: 'زڤڕین',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ),
        body: ListenableBuilder(
          listenable: plan,
          builder: (context, _) {
            final count = plan.count(letterIndex);
            final target = plan.target(letterIndex);
            final done = plan.isDone(letterIndex);
            final isReview = plan.todayReview.contains(letterIndex);
            final next = _nextUnfinished(plan.todayNew, plan.todayReview, plan.isDone);
            return SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      // Count: ring + digits.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountRing(count: count, target: target, size: 96),
                          const SizedBox(width: 16),
                          Text(
                            '${kurdishDigits(count)} / ${kurdishDigits(target)}',
                            key: const ValueKey('practice-count'),
                            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: done ? p.green : p.ink),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // The big letter is the button. One tap = one repetition.
                      Semantics(
                        button: true,
                        label: 'جارەکێ زێدە بکە',
                        child: Material(
                          color: done ? p.greenSoft : p.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                            side: BorderSide(color: done ? p.green : p.sun, width: 4),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            key: const ValueKey('tap-count'),
                            enableFeedback: false,
                            onTap: done
                                ? null
                                : () {
                                    HapticFeedback.lightImpact();
                                    plan.add(letterIndex);
                                    if (plan.isDone(letterIndex)) HapticFeedback.heavyImpact();
                                  },
                            child: SizedBox(
                              height: 320,
                              child: Stack(
                                children: [
                                  Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(letter.char, style: letterStyle(220, done ? p.green : p.ink).copyWith(height: 1.35)),
                                    ),
                                  ),
                                  PositionedDirectional(
                                    bottom: 14,
                                    end: 18,
                                    child: Icon(
                                      done ? Icons.check_circle_rounded : Icons.touch_app_rounded,
                                      size: 48,
                                      color: done ? p.green : p.sun,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PlaySoundButton(letter: letter, size: 80),
                          _CircleButton(
                            key: const ValueKey('undo'),
                            icon: Icons.remove_rounded,
                            label: 'جارەکێ کێم بکە',
                            onTap: count > 0 ? () => plan.add(letterIndex, -1) : null,
                          ),
                          if (isReview)
                            _CircleButton(
                              key: const ValueKey('known'),
                              icon: plan.isKnown(letterIndex) ? Icons.star_rounded : Icons.star_outline_rounded,
                              label: 'ئەڤ پیتە ب باشی دزانم',
                              color: plan.isKnown(letterIndex) ? p.sun : null,
                              onTap: () => plan.toggleKnown(letterIndex),
                            ),
                        ],
                      ),
                      if (isReview) ...[
                        const SizedBox(height: 6),
                        Text(
                          '⭐ = ئەڤ پیتە ب باشی دزانم، ئیدی د دووبارەکرنێ دا نینە',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: p.muted, fontSize: 14),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ExcludeSemantics(child: Text(letter.picture, style: const TextStyle(fontSize: 48))),
                          const SizedBox(width: 14),
                          Flexible(child: HighlightedWord(letter: letter, size: 44)),
                          const SizedBox(width: 10),
                          PlaySoundButton(letter: letter, size: 48, word: true),
                        ],
                      ),
                      if (done && next != null) ...[
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          key: const ValueKey('next-letter'),
                          style: FilledButton.styleFrom(
                            enableFeedback: false,
                            backgroundColor: p.green,
                            foregroundColor: p.onGreen,
                            minimumSize: const Size.fromHeight(72),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(builder: (_) => PracticeScreen(letterIndex: next)),
                          ),
                          icon: const Icon(Icons.arrow_back_rounded, size: 34),
                          label: Text(kurdishLetters[next].char, style: letterStyle(40, p.onGreen).copyWith(height: 1.2)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int? _nextUnfinished(List<int> fresh, List<int> review, bool Function(int) isDone) {
    final all = [...fresh, ...review];
    final at = all.indexOf(letterIndex);
    for (var k = 1; k <= all.length; k++) {
      final i = all[(at + k) % all.length];
      if (i != letterIndex && !isDone(i)) return i;
    }
    return null;
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({super.key, required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Tooltip(
      message: label,
      child: SizedBox.square(
        dimension: 80,
        child: IconButton.outlined(
          enableFeedback: false,
          iconSize: 40,
          style: IconButton.styleFrom(
            side: BorderSide(color: color ?? p.line, width: 2),
            backgroundColor: color?.withValues(alpha: 0.18) ?? p.surface,
            foregroundColor: color ?? p.ink,
          ),
          onPressed: onTap,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
