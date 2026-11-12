import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_scope.dart';
import '../letters.dart';
import '../plan.dart';
import '../sound_credits.dart';
import '../sounds.dart';
import '../theme.dart';

/// Screens for the person helping the learner (someone who can read).
class HelperScreen extends StatelessWidget {
  const HelperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return _Page(
      title: 'بۆ هاریکاری',
      children: [
        Text(
          'ئەڤ بەشە بۆ وی کەسێیە یێ هاریکاریا فێرخوازی دکەت.',
          style: TextStyle(color: p.muted, fontSize: 16),
        ),
        const SizedBox(height: 12),
        _Tile(
          icon: Icons.smart_display_rounded,
          title: 'ڤیدیۆیا پیتان ل یوتیوبێ',
          subtitle: 'Helat Abdullah Sharafani',
          onTap: () => launchUrl(Uri.parse(alphabetVideoUrl), mode: LaunchMode.externalApplication),
        ),
        const SizedBox(height: 10),
        _Tile(
          icon: Icons.event_note_rounded,
          title: 'پلانا ڕۆژانە',
          subtitle: '${kurdishDigits(StudyPlan.newPerDay)} پیتێن نوو ڕۆژانە · ${kurdishDigits(StudyPlan.letterDays)} ڕۆژ',
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const PlanScreen())),
        ),
        const SizedBox(height: 10),
        _Tile(
          icon: Icons.record_voice_over_rounded,
          title: 'دەنگ ژ کیڤە هاتینە',
          subtitle: 'Wikimedia Commons · Lingua Libre',
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SoundCreditsScreen())),
        ),
      ],
    );
  }
}

/// The whole plan, day by day, with the rules. The helper can move to another day.
class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = AppScope.of(context).plan;
    final p = context.palette;
    return ListenableBuilder(
      listenable: plan,
      builder: (context, _) => _Page(
        title: 'پلانا ڕۆژانە',
        children: [
          _Rules(),
          const SizedBox(height: 18),
          for (var d = 1; d <= StudyPlan.letterDays; d++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: d == plan.day ? p.greenSoft : p.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: d == plan.day ? p.green : p.line, width: 2),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  enableFeedback: false,
                  onTap: d == plan.day ? null : () => _confirmDay(context, d),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 92,
                          child: Text('ڕۆژا ${kurdishDigits(d)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        ),
                        Expanded(
                          child: Text(
                            StudyPlan.newOn(d).map((i) => kurdishLetters[i].char).join('   '),
                            style: letterStyle(34, d < plan.day ? p.muted : p.ink).copyWith(height: 1.4),
                          ),
                        ),
                        Text(
                          '${kurdishDigits(StudyPlan.introducedBefore(d).length)} 🔁',
                          style: TextStyle(color: p.muted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'پشتی ڕۆژا ${kurdishDigits(StudyPlan.letterDays)}: تەنێ دووبارەکرن، هەتا هەمی پیت ⭐ ببن. 🔁 = ژمارا پیتێن کەڤن بۆ دووبارەکرنێ.',
              style: TextStyle(color: p.muted, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDay(BuildContext context, int d) async {
    final plan = AppScope.of(context).plan;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('بچیە ڕۆژا ${kurdishDigits(d)}؟'),
          content: const Text('ژمارێن ئەڤرۆ دێ ژ نوو دەست پێکەن.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('نە')),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('بەلێ')),
          ],
        ),
      ),
    );
    if (ok == true) plan.setDay(d);
  }
}

class _Rules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget rule(IconData icon, String text) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: p.green, size: 24),
              const SizedBox(width: 10),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
            ],
          ),
        );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: p.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('یاسایێن پلانێ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          rule(Icons.auto_awesome_rounded,
              'هەر ڕۆژ ${kurdishDigits(StudyPlan.newPerDay)} پیتێن نوو. هەر پیتەکێ ${kurdishDigits(StudyPlan.newReps)} جاران بێژە یان بنڤیسە.'),
          rule(Icons.replay_rounded,
              'هەمی پیتێن ڕۆژێن بەری نوکە، هەر ئێک ${kurdishDigits(StudyPlan.reviewReps)} جاران دووبارە بکە.'),
          rule(Icons.star_rounded, 'دەمێ پیتەک ب باشی هاتە زانین، ⭐ لێ بدە. ئیدی ناچیتە د دووبارەکرنێ دا.'),
          rule(Icons.volume_up_rounded, 'ل سەر پیتێ بدە: دەنگێ پیتێ دهێت. ل سەر پەیڤێ بدە: دەنگێ پەیڤێ دهێت.'),
          rule(Icons.touch_app_rounded, 'هەر جارەکێ ل سەر پیتا مەزن بدە: دەنگێ وێ دهێت، تو ژی بێژە، و ئەلقە پڕ دبیت.'),
          rule(Icons.calendar_today_rounded,
              'ڕۆژا دی سوبەهی ڤەدبیت، ب مەرجەکێ کارێ ئەڤرۆ تەمام ببیت. ئەگەر تەمام نەبیت، سوبەهی ل سەر هەمان ڕۆژێ بەردەوام بە.'),
        ],
      ),
    );
  }
}

/// Who recorded each sound, and under which licence.
class SoundCreditsScreen extends StatelessWidget {
  const SoundCreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return _Page(
      title: 'دەنگ ژ کیڤە هاتینە',
      children: [
        Text(
          'دەنگێن پەیڤان ژ Wikimedia Commons (Lingua Libre) نە، ب دەنگێ ئاخفتنڤانێن کورمانجی. '
          'Recordings: Wikimedia Commons / Lingua Libre.',
          style: TextStyle(color: p.muted, fontSize: 15),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < kurdishLetters.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text(kurdishLetters[i].char, style: letterStyle(30, p.green).copyWith(height: 1.3)),
            title: Text('${kurdishLetters[i].word} · ${soundCredits[i].word}'),
            subtitle: Text(
              '${soundCredits[i].speaker} · ${soundCredits[i].license}',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
            ),
            trailing: const Icon(Icons.open_in_new_rounded, size: 20),
            onTap: () => launchUrl(Uri.parse(soundCredits[i].page)),
          ),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: p.bg,
          surfaceTintColor: Colors.transparent,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          leading: IconButton(
            tooltip: 'زڤڕین',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 32), children: children),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Material(
      color: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: p.line)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: p.green, size: 36),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: TextStyle(color: p.muted)),
        trailing: const Icon(Icons.chevron_left_rounded),
        onTap: onTap,
      ),
    );
  }
}
