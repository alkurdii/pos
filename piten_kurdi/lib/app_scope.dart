import 'package:flutter/widgets.dart';

import 'plan.dart';
import 'progress.dart';
import 'sounds.dart';

/// Gives every screen access to the saved app state.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.progress,
    required this.plan,
    required this.sounds,
    required super.child,
  });

  final Progress progress;
  final PlanState plan;
  final SoundBank sounds;

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  @override
  bool updateShouldNotify(AppScope old) =>
      progress != old.progress || plan != old.plan || sounds != old.sounds;
}
