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
        // Text on filled accent buttons.
        expect(_contrast(scheme.onPrimary, scheme.primary), greaterThanOrEqualTo(4.5),
            reason: 'onPrimary on primary');
      });
    }
  }

  for (final brightness in Brightness.values) {
    test('the Stash theme adds its brown, readable in $brightness mode', () {
      final scheme =
          (brightness == Brightness.light ? AppTheme.light(stashBlue) : AppTheme.dark(stashBlue)).colorScheme;
      expect(scheme.secondary.toARGB32(), isNot(scheme.primary.toARGB32()));
      expect(_contrast(scheme.secondary, scheme.surface), greaterThanOrEqualTo(4.5));
      expect(HSLColor.fromColor(scheme.secondary).hue, closeTo(HSLColor.fromColor(stashBrown).hue, 3));
      if (brightness == Brightness.dark) expect(scheme.surface, const Color(0xFF202B33));
    });
  }
}
