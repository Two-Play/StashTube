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

  static ThemeData _build(Brightness brightness, Color accent) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    ).copyWith(
      primary: accent,
      // Light accents (amber, ...) need dark text on top of them.
      onPrimary: ThemeData.estimateBrightnessForColor(accent) == Brightness.dark ? Colors.white : Colors.black,
      surface: isDark ? const Color(0xFF0F0F0F) : Colors.white,
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
