import 'package:flutter/material.dart';

import '../letters.dart';
import '../quiz.dart';
import '../theme.dart';

/// Shows a picture word and asks which letter it starts with.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.quiz});

  /// Pass a quiz with a fixed random seed in tests.
  final Quiz? quiz;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final Quiz _quiz = widget.quiz ?? Quiz();
  late QuizQuestion _q = _quiz.next();
  final Set<String> _wrong = {};
  bool _solved = false;

  void _answer(String c) {
    if (_solved || _wrong.contains(c)) return;
    setState(() {
      if (c == _q.letter.char) {
        _solved = true;
        _quiz.finish(firstTry: _wrong.isEmpty);
      } else {
        _wrong.add(c);
      }
    });
  }

  void _next() => setState(() {
        _q = _quiz.next();
        _wrong.clear();
        _solved = false;
      });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final number = _quiz.asked + (_solved ? 0 : 1);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: p.line),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('پسیار ${kurdishDigits(number)}', style: TextStyle(color: p.muted, fontSize: 15)),
                  Text(
                    'دروست ژ جارا ئێکێ: ${kurdishDigits(_quiz.rightFirstTry)} ژ ${kurdishDigits(_quiz.asked)}',
                    key: const ValueKey('score'),
                    style: TextStyle(color: p.muted, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ExcludeSemantics(child: Text(_q.letter.picture, style: const TextStyle(fontSize: 96))),
              Text(_q.letter.word, key: const ValueKey('quiz-word'), style: letterStyle(64, p.ink)),
              const SizedBox(height: 4),
              const Text(
                'ئەڤ پەیڤە ب کیژ پیتێ دەست پێدکەت؟',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, box) {
                  final columns = box.maxWidth >= 520 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [for (final c in _q.choices) _option(c)],
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 36,
                child: _solved
                    ? Text('ئافەرین! دروستە 👏',
                        style: TextStyle(color: p.green, fontSize: 21, fontWeight: FontWeight.w700))
                    : _wrong.isNotEmpty
                        ? Text('نە، جارەکا دی هەول بدە',
                            style: TextStyle(color: p.red, fontSize: 21, fontWeight: FontWeight.w700))
                        : null,
              ),
              if (_solved) ...[
                const SizedBox(height: 8),
                FilledButton(
                  key: const ValueKey('quiz-next'),
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                    enableFeedback: false,
                    backgroundColor: p.green,
                    foregroundColor: p.onGreen,
                    minimumSize: const Size(200, 58),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontFamily: uiFont, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('پسیارا دی ←'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _option(String c) {
    final p = context.palette;
    final isRight = _solved && c == _q.letter.char;
    final isWrong = _wrong.contains(c);
    final bg = isRight ? p.greenSoft : (isWrong ? p.redSoft : p.bg);
    final fg = isRight ? p.green : (isWrong ? p.red : p.ink);
    final border = isRight ? p.green : (isWrong ? p.red : p.line);
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: border, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('option-$c'),
        enableFeedback: false,
        onTap: (_solved || isWrong) ? null : () => _answer(c),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(c, style: letterStyle(60, fg).copyWith(height: 1.3)),
          ),
        ),
      ),
    );
  }
}
