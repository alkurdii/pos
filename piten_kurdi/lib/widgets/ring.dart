import 'package:flutter/material.dart';

import '../letters.dart';
import '../theme.dart';

/// A round progress ring with the count inside, e.g. ٤٧ / ١٠٠.
/// The ring fills up so progress can be seen without reading numbers.
class CountRing extends StatelessWidget {
  const CountRing({
    super.key,
    required this.count,
    required this.target,
    this.size = 72,
    this.child,
  });

  final int count;
  final int target;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final done = target > 0 && count >= target;
    final value = target == 0 ? 0.0 : (count / target).clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: size * 0.09,
            color: done ? p.green : p.sun,
            backgroundColor: p.line,
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: child ??
                (done
                    ? Icon(Icons.check_rounded, color: p.green, size: size * 0.55)
                    : FittedBox(
                        child: Padding(
                          padding: EdgeInsets.all(size * 0.18),
                          child: Text(
                            kurdishDigits(count),
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: size * 0.3, color: p.ink),
                          ),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}
