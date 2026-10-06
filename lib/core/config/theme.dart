import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'server_config.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final name = ref.watch(sharedPreferencesProvider).getString(_key);
    return ThemeMode.values.firstWhere((m) => m.name == name, orElse: () => ThemeMode.system);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_key, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// WCAG contrast ratio between two colors (1–21).
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

/// [color] with its lightness moved away from [background] (lighter on dark
/// backgrounds, darker on light ones) until the contrast reaches [minimum].
Color ensureContrast(Color color, Color background, {double minimum = 4.5}) {
  final lighten = background.computeLuminance() < 0.5;
  var hsl = HSLColor.fromColor(color);
  while (contrastRatio(hsl.toColor(), background) < minimum) {
    final next = (hsl.lightness + (lighten ? 0.01 : -0.01)).clamp(0.0, 1.0);
    if (next == hsl.lightness) break; // reached black or white
    hsl = hsl.withLightness(next);
  }
  return hsl.toColor();
}

/// White or black, whichever is easier to read on [color].
Color readableOn(Color color) =>
    contrastRatio(Colors.white, color) >= contrastRatio(Colors.black, color) ? Colors.white : Colors.black;

/// Accent colors offered in the settings; the first one is the default.
const accentColors = <String, Color>{
  'Red': Color(0xFFE53935),
  'Pink': Color(0xFFD81B60),
  'Purple': Color(0xFF8E24AA),
  'Indigo': Color(0xFF3949AB),
  'Blue': Color(0xFF1E88E5),
  'Teal': Color(0xFF00897B),
  'Green': Color(0xFF43A047),
  'Orange': Color(0xFFF4511E),
  'Amber': Color(0xFFFFB300),
};

class AccentColorNotifier extends Notifier<Color> {
  static const _key = 'accent_color';

  @override
  Color build() {
    final value = ref.watch(sharedPreferencesProvider).getInt(_key);
    return value == null ? accentColors.values.first : Color(value);
  }

  Future<void> set(Color color) async {
    state = color;
    await ref.read(sharedPreferencesProvider).setInt(_key, color.toARGB32());
  }
}

final accentColorProvider = NotifierProvider<AccentColorNotifier, Color>(AccentColorNotifier.new);

/// YouTube-like look: neutral surfaces with a user-selectable accent (red by default).
abstract final class AppTheme {
  static ThemeData light(Color accent) => _build(Brightness.light, accent);
  static ThemeData dark(Color accent) => _build(Brightness.dark, accent);

  static WidgetStateColor _onChip(ColorScheme scheme) => WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? scheme.surface : scheme.onSurface,
      );

  static Color surfaceFor(Brightness brightness) =>
      brightness == Brightness.dark ? const Color(0xFF0F0F0F) : Colors.white;

  /// The accent as shown in [brightness] mode: same hue, lightened on dark
  /// or darkened on light surfaces until it is readable there (WCAG AA).
  static Color accentFor(Color accent, Brightness brightness) => ensureContrast(accent, surfaceFor(brightness));

  static ThemeData _build(Brightness brightness, Color accent) {
    final primary = accentFor(accent, brightness);
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    ).copyWith(
      primary: primary,
      onPrimary: readableOn(primary),
      surface: surfaceFor(brightness),
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.surfaceContainerHighest,
        height: 64,
      ),
      chipTheme: ChipThemeData(
        showCheckmark: false,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.onSurface,
        // Selected chips are inverted (YouTube style), so their label needs
        // the surface color to stay readable. (Icons don't resolve states:
        // chips with avatars set their icon color themselves.)
        labelStyle: TextStyle(color: _onChip(scheme), fontWeight: FontWeight.w500),
      ),
    );
  }
}
