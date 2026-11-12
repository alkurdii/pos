import 'package:flutter/material.dart';

/// Colours taken from the Kurdish flag, softened for reading.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.bg,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.green,
    required this.greenSoft,
    required this.sun,
    required this.sunSoft,
    required this.red,
    required this.redSoft,
    required this.onGreen,
  });

  final Color bg, surface, ink, muted, line, green, greenSoft, sun, sunSoft, red, redSoft, onGreen;

  static const light = Palette(
    bg: Color(0xFFF3F6F1),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF17301F),
    muted: Color(0xFF5B6F60),
    line: Color(0xFFD5E0D4),
    green: Color(0xFF1F7A3F),
    greenSoft: Color(0xFFE1F0E4),
    sun: Color(0xFFE9A400),
    sunSoft: Color(0xFFFFF3CF),
    red: Color(0xFFC4302B),
    redSoft: Color(0xFFFBE3E1),
    onGreen: Color(0xFFFFFFFF),
  );

  static const dark = Palette(
    bg: Color(0xFF101A13),
    surface: Color(0xFF182419),
    ink: Color(0xFFEAF2EA),
    muted: Color(0xFFA3B5A6),
    line: Color(0xFF2B3B2E),
    green: Color(0xFF5CC283),
    greenSoft: Color(0xFF1D3624),
    sun: Color(0xFFF5C33B),
    sunSoft: Color(0xFF3A3014),
    red: Color(0xFFF07A73),
    redSoft: Color(0xFF3D1D1B),
    onGreen: Color(0xFF0C1A10),
  );

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) =>
      other is Palette && t >= 0.5 ? other : this;
}

extension PaletteOf on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}

const String letterFont = 'NotoNaskhArabic';
const String uiFont = 'NotoSansArabic';

ThemeData buildTheme(Palette p, Brightness brightness) {
  final base = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    fontFamily: uiFont,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.green,
      brightness: brightness,
      primary: p.green,
      onPrimary: p.onGreen,
      surface: p.surface,
      onSurface: p.ink,
    ),
    scaffoldBackgroundColor: p.bg,
    extensions: [p],
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: p.ink, displayColor: p.ink),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.surface,
      indicatorColor: p.greenSoft,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontFamily: uiFont, fontSize: 15, fontWeight: FontWeight.w700, color: p.ink),
      ),
    ),
  );
}

/// Style for the big letters themselves.
TextStyle letterStyle(double size, Color color) => TextStyle(
      fontFamily: letterFont,
      fontWeight: FontWeight.w700,
      fontSize: size,
      color: color,
      height: 1.5,
    );
