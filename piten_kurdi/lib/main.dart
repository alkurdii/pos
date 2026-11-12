import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'letters.dart';
import 'plan.dart';
import 'progress.dart';
import 'screens/helper_screens.dart';
import 'screens/learn_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/today_screen.dart';
import 'sounds.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progress = await Progress.load(kurdishLetters.length);
  final plan = await PlanState.load();
  final sounds = await SoundBank.load();
  runApp(PitenKurdiApp(progress: progress, plan: plan, sounds: sounds));
}

class PitenKurdiApp extends StatelessWidget {
  const PitenKurdiApp({super.key, required this.progress, required this.plan, required this.sounds});
  final Progress progress;
  final PlanState plan;
  final SoundBank sounds;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      progress: progress,
      plan: plan,
      sounds: sounds,
      child: MaterialApp(
        title: 'پیتێن کوردی',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Palette.light, Brightness.light),
        darkTheme: buildTheme(Palette.dark, Brightness.dark),
        // Kurdish is written right to left.
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
        home: const HomeShell(),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int _tab = 0;
  bool _quizOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Open the next day when the app comes back the next morning.
    if (state == AppLifecycleState.resumed) AppScope.of(context).plan.checkNewDay();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final progress = AppScope.of(context).progress;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'پیتێن کوردی ',
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.4),
                                  children: [TextSpan(text: '☀', style: TextStyle(color: p.sun))],
                                ),
                              ),
                              Text(
                                'ب ساناهی فێری ${kurdishDigits(kurdishLetters.length)} پیتێن ئەلفوبێیا کوردی ببە',
                                style: TextStyle(color: p.muted, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('helper'),
                        tooltip: 'بۆ هاریکاری',
                        iconSize: 30,
                        color: p.muted,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const HelperScreen()),
                        ),
                        icon: const Icon(Icons.settings_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _tab,
                    children: [
                      const TodayScreen(),
                      LearnScreen(progress: progress),
                      // Built the first time the quiz tab opens.
                      _quizOpened ? const QuizScreen() : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() {
          _tab = i;
          if (i == 2) _quizOpened = true;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'ئەڤرۆ'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'هەمی پیت'),
          NavigationDestination(icon: Icon(Icons.extension_outlined), selectedIcon: Icon(Icons.extension), label: 'تاقیکرن'),
        ],
      ),
    );
  }
}
