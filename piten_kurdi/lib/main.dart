import 'package:flutter/material.dart';

import 'letters.dart';
import 'progress.dart';
import 'screens/learn_screen.dart';
import 'screens/quiz_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progress = await Progress.load(kurdishLetters.length);
  runApp(PitenKurdiApp(progress: progress));
}

class PitenKurdiApp extends StatelessWidget {
  const PitenKurdiApp({super.key, required this.progress});
  final Progress progress;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'پیتێن کوردی',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Palette.light, Brightness.light),
      darkTheme: buildTheme(Palette.dark, Brightness.dark),
      // Kurdish is written right to left.
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      home: HomeShell(progress: progress),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.progress});
  final Progress progress;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  bool _quizOpened = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'پیتێن کوردی ',
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, height: 1.4),
                          children: [TextSpan(text: '☀', style: TextStyle(color: p.sun))],
                        ),
                      ),
                      Text(
                        'ب ساناهی فێری ${kurdishDigits(kurdishLetters.length)} پیتێن ئەلفوبێیا کوردی ببە',
                        style: TextStyle(color: p.muted, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _tab,
                    children: [
                      LearnScreen(progress: widget.progress),
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
          if (i == 1) _quizOpened = true;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'فێربوون'),
          NavigationDestination(icon: Icon(Icons.extension_outlined), selectedIcon: Icon(Icons.extension), label: 'تاقیکرن'),
        ],
      ),
    );
  }
}
