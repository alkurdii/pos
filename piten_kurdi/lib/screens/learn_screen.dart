import 'package:flutter/material.dart';

import '../letters.dart';
import '../progress.dart';
import '../theme.dart';
import '../widgets/sound.dart';

/// Shows one big letter at a time, with a picture word and its forms,
/// and the whole alphabet as a grid underneath.
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key, required this.progress});
  final Progress progress;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late final PageController _pages = PageController(initialPage: widget.progress.current);
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _pages.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    final target = (i + kurdishLetters.length) % kurdishLetters.length;
    final distance = (target - widget.progress.current).abs();
    if (distance == 1 && !MediaQuery.of(context).disableAnimations) {
      _pages.animateToPage(target, duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    } else {
      _pages.jumpToPage(target);
    }
  }

  void _openFromGrid(int i) {
    _goTo(i);
    _scroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ListenableBuilder(
      listenable: widget.progress,
      builder: (context, _) {
        final i = widget.progress.current;
        final letter = kurdishLetters[i];
        final learned = widget.progress.isLearned(i);
        return ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _Slate(
              pages: _pages,
              progress: widget.progress,
              letter: letter,
              learned: learned,
              onPrev: () => _goTo(i - 1),
              onNext: () => _goTo(i + 1),
            ),
            const SizedBox(height: 28),
            _GridHeader(learnedCount: widget.progress.learned.length),
            const SizedBox(height: 6),
            Text('ل سەر هەر پیتەکێ بدە دا مەزن ببیت.', style: TextStyle(color: p.muted, fontSize: 15)),
            const SizedBox(height: 12),
            _LetterGrid(progress: widget.progress, onTap: _openFromGrid),
            const SizedBox(height: 28),
            Text(
              'چ موزیک د ناڤ ڤی ئەپی دا نینە. تەنێ دەنگێ پیتان هەیە.',
              textAlign: TextAlign.center,
              style: TextStyle(color: p.muted, fontSize: 15),
            ),
          ],
        );
      },
    );
  }
}

class _Slate extends StatelessWidget {
  const _Slate({
    required this.pages,
    required this.progress,
    required this.letter,
    required this.learned,
    required this.onPrev,
    required this.onNext,
  });

  final PageController pages;
  final Progress progress;
  final KurdishLetter letter;
  final bool learned;
  final VoidCallback onPrev, onNext;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final count = kurdishLetters.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: p.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The big letter. Swipe sideways to move between letters.
          Container(
            height: 300,
            decoration: BoxDecoration(color: p.greenSoft, borderRadius: BorderRadius.circular(22)),
            child: Stack(
              children: [
                PageView.builder(
                  controller: pages,
                  itemCount: count,
                  onPageChanged: (i) => progress.current = i,
                  itemBuilder: (context, i) => Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        kurdishLetters[i].char,
                        key: ValueKey('big-$i'),
                        style: letterStyle(190, p.green),
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 12,
                  start: 16,
                  child: Text(
                    'پیتا ${kurdishDigits(progress.current + 1)} ژ ${kurdishDigits(count)}',
                    style: TextStyle(color: p.muted, fontSize: 15),
                  ),
                ),
                PositionedDirectional(
                  bottom: 12,
                  end: 12,
                  child: PlaySoundButton(letter: letter, size: 64),
                ),
                if (learned)
                  PositionedDirectional(
                    top: 12,
                    end: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(color: p.sun, borderRadius: BorderRadius.circular(99)),
                      child: const Text(
                        'فێربووی ✓',
                        style: TextStyle(color: Color(0xFF2A1F00), fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _Label('نموونە'),
          Row(
            children: [
              ExcludeSemantics(child: Text(letter.picture, style: const TextStyle(fontSize: 56))),
              const SizedBox(width: 16),
              Flexible(child: HighlightedWord(letter: letter, size: 52)),
              const SizedBox(width: 10),
              PlaySoundButton(letter: letter, size: 48, word: true),
            ],
          ),
          const SizedBox(height: 14),
          _Label('شێوەیێن پیتێ د ناڤ پەیڤێ دا'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [for (final f in formsOf(letter)) _FormChip(form: f)],
          ),
          if (!letter.joinsNext) ...[
            const SizedBox(height: 8),
            Text('ئەڤ پیتە ب پیتا پشتی خۆ ڤە نالکیت.', style: TextStyle(color: p.muted, fontSize: 15)),
          ],
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: 'ب لاتینی: ',
              style: TextStyle(color: p.muted, fontSize: 15),
              children: [
                TextSpan(
                  text: '\u2066${letter.latin}\u2069',
                  style: TextStyle(color: p.ink, fontWeight: FontWeight.w700, fontFamily: 'Roboto', fontSize: 17),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _BigButton(label: '→ پێشتر', onPressed: onPrev),
              const SizedBox(width: 10),
              Expanded(child: _BigButton(label: 'پاشتر ←', onPressed: onNext, primary: true)),
            ],
          ),
          const SizedBox(height: 10),
          _BigButton(
            key: const ValueKey('learned-toggle'),
            label: learned ? '✓ فێربووی' : 'من ئەڤ پیتە فێربوو',
            onPressed: () => progress.toggleLearned(progress.current),
            highlighted: learned,
          ),
        ],
      ),
    );
  }
}

/// The example word, with the letter being learned in the sun colour.
class HighlightedWord extends StatelessWidget {
  const HighlightedWord({super.key, required this.letter, required this.size});
  final KurdishLetter letter;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final w = letter.word;
    final at = letter.indexInWord;
    final base = letterStyle(size, p.ink);
    final spans = at < 0
        ? [TextSpan(text: w)]
        : [
            TextSpan(text: w.substring(0, at)),
            TextSpan(text: letter.char, style: TextStyle(color: p.sun)),
            TextSpan(text: w.substring(at + letter.char.length)),
          ];
    return Text.rich(
      TextSpan(style: base, children: spans),
      semanticsLabel: w,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text, style: TextStyle(color: context.palette.muted, fontSize: 14)),
      );
}

class _FormChip extends StatelessWidget {
  const _FormChip({required this.form});
  final LetterForm form;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      constraints: const BoxConstraints(minWidth: 72),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(border: Border.all(color: p.line), borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(form.text, style: letterStyle(36, p.ink)),
          Text(form.label, style: TextStyle(color: p.muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  const _BigButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.highlighted = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary, highlighted;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final style = ButtonStyle(
      enableFeedback: false, // no click sounds
      minimumSize: const WidgetStatePropertyAll(Size(0, 58)),
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontFamily: uiFont, fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
    if (primary) {
      return FilledButton(
        onPressed: onPressed,
        style: style.copyWith(
          backgroundColor: WidgetStatePropertyAll(p.green),
          foregroundColor: WidgetStatePropertyAll(p.onGreen),
        ),
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: style.copyWith(
        backgroundColor: WidgetStatePropertyAll(highlighted ? p.sunSoft : p.surface),
        foregroundColor: WidgetStatePropertyAll(p.ink),
        side: WidgetStatePropertyAll(BorderSide(color: highlighted ? p.sun : p.line, width: 2)),
      ),
      child: Text(label),
    );
  }
}

class _GridHeader extends StatelessWidget {
  const _GridHeader({required this.learnedCount});
  final int learnedCount;
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final total = kurdishLetters.length;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 8,
      children: [
        const Text('هەمی پیت', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'فێربووی: ${kurdishDigits(learnedCount)} ژ ${kurdishDigits(total)}',
              style: TextStyle(color: p.muted, fontSize: 15),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: learnedCount / total,
                  minHeight: 10,
                  color: p.sun,
                  backgroundColor: p.line,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LetterGrid extends StatelessWidget {
  const _LetterGrid({required this.progress, required this.onTap});
  final Progress progress;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 92,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: kurdishLetters.length,
      itemBuilder: (context, i) {
        final current = i == progress.current;
        final done = progress.isLearned(i);
        return Material(
          color: current ? p.greenSoft : p.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: current ? p.green : p.line, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: ValueKey('cell-$i'),
            enableFeedback: false,
            onTap: () => onTap(i),
            child: Stack(
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      kurdishLetters[i].char,
                      style: letterStyle(46, current ? p.green : p.ink).copyWith(height: 1.3),
                    ),
                  ),
                ),
                if (done)
                  PositionedDirectional(
                    top: 4,
                    end: 8,
                    child: Text('✓', style: TextStyle(color: p.sun, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
