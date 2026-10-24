import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'design_tokens.dart';
import 'server_config.dart';

export 'design_tokens.dart';

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

/// White on [color] unless that is clearly hard to read (below 4:1, e.g.
/// on amber), else black. White wins even where black has a little more
/// contrast: black labels on a mid-tone accent look muddy.
Color readableOn(Color color) =>
    contrastRatio(Colors.white, color) >= 4 || contrastRatio(Colors.white, color) >= contrastRatio(Colors.black, color)
        ? Colors.white
        : Colors.black;

/// StashTube's own blue, the color of the cards in its icon and logo.
const stashTubeBlue = Color(0xFF3A8DFF);

/// Accent colors offered in the settings; the first one is the default.
const accentColors = <String, Color>{
  'StashTube': stashTubeBlue,
  'Red': Color(0xFFE53935),
  'Pink': Color(0xFFD81B60),
  'Purple': Color(0xFF8E24AA),
  'Indigo': Color(0xFF3949AB),
  'Teal': Color(0xFF00897B),
  'Green': Color(0xFF43A047),
  'Orange': Color(0xFFF4511E),
  'Amber': Color(0xFFFFB300),
};

class AccentColorNotifier extends Notifier<Color> {
  static const _key = 'accent_color';

  /// Former blues that became [stashTubeBlue]: the default in Stash's colors,
  /// and "Blue", which looked almost the same.
  static const _formerBlues = {0xFF137CBD, 0xFF1E88E5};

  @override
  Color build() {
    final value = ref.watch(sharedPreferencesProvider).getInt(_key);
    if (value == null || _formerBlues.contains(value)) return accentColors.values.first;
    return Color(value);
  }

  Future<void> set(Color color) async {
    state = color;
    await ref.read(sharedPreferencesProvider).setInt(_key, color.toARGB32());
  }
}

final accentColorProvider = NotifierProvider<AccentColorNotifier, Color>(AccentColorNotifier.new);

/// App colors outside the [ColorScheme], registered in [AppTheme]. Read
/// them with `AppColors.of(context)`.
///
/// The video colors are the same in both modes: video and images are dark
/// whatever the theme, and the text over them is always white.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.rating,
    this.videoScrim = Colors.black87,
    this.videoScrimSoft = Colors.black54,
    this.videoDim = Colors.black38,
    this.badgeBackground = const Color(0xCC000000),
    this.onBadge = Colors.white,
  });

  /// Filled rating stars on the page background: amber, darkened in light
  /// mode until it reaches 3:1 against the surface (WCAG non-text contrast).
  final Color rating;

  /// Behind white text over video or images: the dark end of gradients
  /// (titles over shorts and images) and the casting panel.
  final Color videoScrim;

  /// Lighter scrim: pills and labels over video (2× speed, scrub time) and
  /// the gradient behind the shorts' top bar.
  final Color videoScrimSoft;

  /// Dims the whole video while the player's controls show.
  final Color videoDim;

  /// Duration, resolution and count badges on thumbnails.
  final Color badgeBackground;

  /// Text and icons on [badgeBackground].
  final Color onBadge;

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? AppColors.forBrightness(Theme.of(context).brightness);

  static AppColors forBrightness(Brightness brightness) => AppColors(
        rating: brightness == Brightness.dark
            ? Colors.amber.shade600
            : ensureContrast(Colors.amber.shade600, AppTheme.surfaceFor(brightness), minimum: 3),
      );

  @override
  AppColors copyWith({
    Color? rating,
    Color? videoScrim,
    Color? videoScrimSoft,
    Color? videoDim,
    Color? badgeBackground,
    Color? onBadge,
  }) =>
      AppColors(
        rating: rating ?? this.rating,
        videoScrim: videoScrim ?? this.videoScrim,
        videoScrimSoft: videoScrimSoft ?? this.videoScrimSoft,
        videoDim: videoDim ?? this.videoDim,
        badgeBackground: badgeBackground ?? this.badgeBackground,
        onBadge: onBadge ?? this.onBadge,
      );

  @override
  AppColors lerp(AppColors? other, double t) => other == null
      ? this
      : AppColors(
          rating: Color.lerp(rating, other.rating, t)!,
          videoScrim: Color.lerp(videoScrim, other.videoScrim, t)!,
          videoScrimSoft: Color.lerp(videoScrimSoft, other.videoScrimSoft, t)!,
          videoDim: Color.lerp(videoDim, other.videoDim, t)!,
          badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
          onBadge: Color.lerp(onBadge, other.onBadge, t)!,
        );
}

/// YouTube-like look: neutral surfaces with a user-selectable accent
/// (StashTube's blue by default).
///
/// Component rules: widgets pick the component by its role and leave the
/// styling to this theme (no per-widget shapes, colors or densities).
/// - Filters: `FilterChip` / `ChoiceChip` (selected chips are inverted).
/// - Actions: `FilledButton.tonal` (or `FilledButton` for the one main
///   action), pill-shaped; `ActionChip` only inside a row of chips.
/// - Navigation: `ListTile`s, or avatar chips/tiles leading to a channel.
/// - Destructive: `colorScheme.error` and always a confirmation first.
/// - Choices between a few modes: `SegmentedButton`.
/// - Tap targets stay at least 48 dp: no `VisualDensity.compact` or shrunk
///   tap targets on primary actions.
/// Sizes, spacing and radii come from `design_tokens.dart`, colors from the
/// [ColorScheme] and [AppColors], text from the `textTheme`.
abstract final class AppTheme {
  static ThemeData light(Color accent) => _build(Brightness.light, accent);
  static ThemeData dark(Color accent) => _build(Brightness.dark, accent);

  static WidgetStateColor _onChip(ColorScheme scheme) => WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? scheme.surface : scheme.onSurface,
      );

  static Color surfaceFor(Brightness brightness, [Color? accent]) => switch (brightness) {
        Brightness.dark => const Color(0xFF0F0F0F),
        Brightness.light => Colors.white,
      };

  /// The accent as shown in [brightness] mode: same hue, lightened on dark
  /// or darkened on light surfaces until it is readable there (WCAG AA).
  /// On dark surfaces a light accent is also darkened, as far as it stays
  /// readable there, so the white labels of filled buttons read well too.
  static Color accentFor(Color accent, Brightness brightness) {
    final surface = surfaceFor(brightness, accent);
    final readable = ensureContrast(accent, surface);
    if (brightness == Brightness.light) return readable;
    var hsl = HSLColor.fromColor(readable);
    while (contrastRatio(Colors.white, hsl.toColor()) < 4.5) {
      final darker = hsl.withLightness((hsl.lightness - 0.01).clamp(0.0, 1.0));
      if (contrastRatio(darker.toColor(), surface) < 4.5) break;
      hsl = darker;
    }
    return hsl.toColor();
  }

  static ThemeData _build(Brightness brightness, Color accent) {
    final primary = accentFor(accent, brightness);
    final surface = surfaceFor(brightness, accent);
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    ).copyWith(
      primary: primary,
      onPrimary: readableOn(primary),
      surface: surface,
    );

    const pill = StadiumBorder();
    const padded = MaterialTapTargetSize.padded;

    return ThemeData(
      colorScheme: scheme,
      extensions: [AppColors.forBrightness(brightness)],
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.chip))),
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.onSurface,
        // Selected chips are inverted (YouTube style), so their label needs
        // the surface color to stay readable. (Icons don't resolve states:
        // chips with avatars set their icon color themselves.)
        labelStyle: TextStyle(color: _onChip(scheme), fontWeight: FontWeight.w500),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(shape: pill, tapTargetSize: padded)),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: pill, tapTargetSize: padded)),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(shape: pill, tapTargetSize: padded),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet))),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.thumbnailBorder),
      ),
      cardTheme: const CardThemeData(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
      ),
    );
  }
}
