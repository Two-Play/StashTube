import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

void main() {
  for (final MapEntry(key: name, value: accent) in accentColors.entries) {
    for (final brightness in Brightness.values) {
      test('$name in $brightness mode is readable', () {
        final scheme = (brightness == Brightness.light ? AppTheme.light(accent) : AppTheme.dark(accent)).colorScheme;
        // Accent text/icons (links, tags, progress) on the page background.
        expect(_contrast(scheme.primary, scheme.surface), greaterThanOrEqualTo(4.5),
            reason: 'primary on surface');
        // Labels of filled accent buttons: white wherever it reads well
        // (the dark mode can't give 4.5:1 against both the page and white).
        expect(_contrast(scheme.onPrimary, scheme.primary), greaterThanOrEqualTo(4),
            reason: 'onPrimary on primary');
        expect(scheme.onPrimary, Colors.white, reason: 'white labels');
      });
    }
  }

  for (final brightness in Brightness.values) {
    test('rating stars in $brightness mode stand out from the surface', () {
      final theme = brightness == Brightness.light ? AppTheme.light(stashTubeBlue) : AppTheme.dark(stashTubeBlue);
      final rating = theme.extension<AppColors>()!.rating;
      // Non-text contrast (WCAG 1.4.11): icons need 3:1.
      expect(_contrast(rating, theme.colorScheme.surface), greaterThanOrEqualTo(3));
      if (brightness == Brightness.dark) expect(rating, Colors.amber.shade600);
    });
  }

  for (final brightness in Brightness.values) {
    final theme = brightness == Brightness.light ? AppTheme.light(stashTubeBlue) : AppTheme.dark(stashTubeBlue);
    final colors = theme.extension<AppColors>()!;

    test('badge text in $brightness mode is readable', () {
      // The badge sits on a thumbnail of any color: check against the badge
      // alone (its own contrast) and composited over a white frame (worst case).
      expect(_contrast(colors.onBadge, colors.badgeBackground), greaterThanOrEqualTo(4.5));
      final overWhite = Color.alphaBlend(colors.badgeBackground, Colors.white);
      expect(_contrast(colors.onBadge, overWhite), greaterThanOrEqualTo(4.5));
    });

    test('video scrims in $brightness mode are sane', () {
      for (final (name, scrim) in [
        ('videoScrim', colors.videoScrim),
        ('videoScrimSoft', colors.videoScrimSoft),
        ('videoDim', colors.videoDim),
      ]) {
        // Black with partial opacity: dark, but never hiding the video.
        expect((scrim.r, scrim.g, scrim.b), (0.0, 0.0, 0.0), reason: '$name is black');
        expect(scrim.a, inExclusiveRange(0.2, 0.9), reason: '$name is translucent');
      }
      // Ordered from strongest to lightest.
      expect(colors.videoScrim.a, greaterThan(colors.videoScrimSoft.a));
      expect(colors.videoScrimSoft.a, greaterThan(colors.videoDim.a));
      // White text at the scrim's dark end stays readable even over white.
      expect(_contrast(Colors.white, Color.alphaBlend(colors.videoScrim, Colors.white)), greaterThanOrEqualTo(4.5));
    });
  }

  test('AppColors lerps every color', () {
    final light = AppTheme.light(stashTubeBlue).extension<AppColors>()!;
    final custom = light.copyWith(badgeBackground: Colors.red, videoScrim: Colors.blue);
    expect(light.lerp(custom, 1).badgeBackground, isSameColorAs(Colors.red));
    expect(light.lerp(custom, 1).videoScrim, isSameColorAs(Colors.blue));
    expect(light.lerp(custom, 0).badgeBackground, isSameColorAs(light.badgeBackground));
  });
}
