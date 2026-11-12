import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../app_scope.dart';
import '../letters.dart';
import '../plan.dart';
import '../sounds.dart';
import '../theme.dart';

/// Screens for the person helping the learner (someone who can read).
class HelperScreen extends StatelessWidget {
  const HelperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final sounds = AppScope.of(context).sounds;
    return _Page(
      title: 'بۆ هاریکاری',
      children: [
        Text(
          'ئەڤ بەشە بۆ وی کەسێیە یێ هاریکاریا فێرخوازی دکەت.',
          style: TextStyle(color: p.muted, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ListenableBuilder(
          listenable: sounds,
          builder: (context, _) => _Tile(
            icon: Icons.smart_display_rounded,
            title: 'دەنگێن پیتان ژ یوتیوبێ',
            subtitle: 'دیارکری: ${kurdishDigits(sounds.markedCount)} ژ ${kurdishDigits(kurdishLetters.length)} پیتان',
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SoundSetupScreen())),
          ),
        ),
        const SizedBox(height: 10),
        _Tile(
          icon: Icons.event_note_rounded,
          title: 'پلانا ڕۆژانە',
          subtitle: '${kurdishDigits(StudyPlan.newPerDay)} پیتێن نوو ڕۆژانە · ${kurdishDigits(StudyPlan.letterDays)} ڕۆژ',
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const PlanScreen())),
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
          rule(Icons.volume_up_rounded, 'بەری دووبارەکرنێ، گوهـ ل دەنگێ پیتێ بدە 🔊 و پاشان ب دەنگێ خۆ بێژە.'),
          rule(Icons.touch_app_rounded, 'هەر جارەکێ ل سەر پیتا مەزن بدە. ئەلقە پڕ دبیت.'),
          rule(Icons.calendar_today_rounded,
              'ڕۆژا دی سوبەهی ڤەدبیت، ب مەرجەکێ کارێ ئەڤرۆ تەمام ببیت. ئەگەر تەمام نەبیت، سوبەهی ل سەر هەمان ڕۆژێ بەردەوام بە.'),
        ],
      ),
    );
  }
}

/// The helper plays the YouTube video and taps each letter when it is said,
/// so the app knows where every letter's sound is.
class SoundSetupScreen extends StatefulWidget {
  const SoundSetupScreen({super.key});

  @override
  State<SoundSetupScreen> createState() => _SoundSetupScreenState();
}

class _SoundSetupScreenState extends State<SoundSetupScreen> {
  late final YoutubePlayerController _yt = YoutubePlayerController.fromVideoId(
    videoId: soundVideoId,
    params: const YoutubePlayerParams(showFullscreenButton: false, strictRelatedVideos: true),
  );
  Timer? _stop;

  @override
  void dispose() {
    _stop?.cancel();
    _yt.close();
    super.dispose();
  }

  Future<void> _mark(SoundBank sounds, String letter) async {
    // People tap a moment after they hear the letter, so step back a little.
    final t = await _yt.currentTime;
    sounds.mark(letter, (t - 0.4).clamp(0, double.infinity));
  }

  Future<void> _preview(SoundBank sounds, String letter) async {
    final clip = sounds.clipFor(letter);
    if (clip == null) return;
    _stop?.cancel();
    await _yt.seekTo(seconds: clip.start, allowSeekAhead: true);
    await _yt.playVideo();
    _stop = Timer(Duration(milliseconds: ((clip.end - clip.start) * 1000).round()), _yt.pauseVideo);
  }

  void _edit(SoundBank sounds, KurdishLetter l) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (c) => Directionality(
        textDirection: TextDirection.rtl,
        child: ListenableBuilder(
          listenable: sounds,
          builder: (c, _) {
            final s = sounds.startOf(l.char);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.char, style: letterStyle(72, context.palette.green).copyWith(height: 1.3)),
                  Text(s == null ? 'نەهاتیە دیارکرن' : 'دەستپێک: ${clockText(s)}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: s == null ? null : () => _preview(sounds, l.char),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('گوهـ بدێ'),
                      ),
                      OutlinedButton(onPressed: s == null ? null : () => sounds.nudge(l.char, -0.5), child: const Text('− ٠.٥ چرکە')),
                      OutlinedButton(onPressed: s == null ? null : () => sounds.nudge(l.char, 0.5), child: const Text('+ ٠.٥ چرکە')),
                      TextButton.icon(
                        onPressed: s == null
                            ? null
                            : () {
                                sounds.clear(l.char);
                                Navigator.pop(c);
                              },
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('ژێبرن'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sounds = AppScope.of(context).sounds;
    final p = context.palette;
    return _Page(
      title: 'دەنگێن پیتان ژ یوتیوبێ',
      children: [
        Text(
          '١. ڤیدیۆیێ لێ بدە.\n'
          '٢. دەمێ گوهـ ل پیتەکێ دبی، ل خوارێ ل سەر وێ پیتێ بدە.\n'
          '٣. بۆ گوهـدانێ یان راستکرنێ، دەستێ خۆ ل سەر پیتێ بهێلە.',
          style: const TextStyle(fontSize: 16, height: 1.8),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: YoutubePlayer(controller: _yt, autoFullScreen: false, enableFullScreenOnVerticalDrag: false),
        ),
        const SizedBox(height: 6),
        Text('ڤیدیۆ: Helat Abdullah Sharafani — پیتێن كوردی', style: TextStyle(color: p.muted, fontSize: 13)),
        const SizedBox(height: 12),
        ListenableBuilder(
          listenable: sounds,
          builder: (context, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'دیارکری: ${kurdishDigits(sounds.markedCount)} ژ ${kurdishDigits(kurdishLetters.length)}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: sounds.markedCount == 0
                        ? null
                        : () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await Clipboard.setData(ClipboardData(text: sounds.exportText()));
                            messenger.showSnackBar(const SnackBar(content: Text('کۆپی بوو')));
                          },
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('کۆپیکرن'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 92,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: kurdishLetters.length,
                itemBuilder: (context, i) {
                  final l = kurdishLetters[i];
                  final s = sounds.startOf(l.char);
                  return Material(
                    color: s != null ? p.greenSoft : p.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: s != null ? p.green : p.line, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      key: ValueKey('mark-${l.char}'),
                      enableFeedback: false,
                      onTap: () => _mark(sounds, l.char),
                      onLongPress: () => _edit(sounds, l),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(child: Text(l.char, style: letterStyle(40, p.ink).copyWith(height: 1.3))),
                          Text(
                            s == null ? '—' : clockText(s),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(color: p.muted, fontSize: 12, fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
