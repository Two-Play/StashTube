import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'server_config.dart';

/// How strong the app's haptic feedback is (settings).
enum HapticLevel { off, light, normal }

/// The app's haptic feedback, following [HapticLevel]: "light" plays only
/// the noticeable feedback ([medium], [heavy], [error]), "normal" also the
/// small taps ([selection], [light]). Use these instead of [HapticFeedback].
abstract final class Haptics {
  /// Set by [hapticLevelProvider].
  static HapticLevel level = HapticLevel.normal;

  /// A choice changed: tabs, chips, steps while scrubbing. Normal only.
  static void selection() {
    if (level == HapticLevel.normal) unawaited(HapticFeedback.selectionClick());
  }

  /// A small action: play/pause, a switch. Normal only.
  static void light() {
    if (level == HapticLevel.normal) unawaited(HapticFeedback.lightImpact());
  }

  /// A noticeable action: a favorite, the O-counter, a refresh.
  static void medium() => _important(HapticFeedback.mediumImpact);

  /// A strong action: a long press opening a menu, unlocking.
  static void heavy() => _important(HapticFeedback.heavyImpact);

  /// Something failed: a wrong PIN, a failed login.
  static void error() => _important(HapticFeedback.vibrate);

  static void _important(Future<void> Function() play) {
    if (level != HapticLevel.off) unawaited(play());
  }
}

/// [onChanged] of a switch, checkbox or chip, with a light tap first.
ValueChanged<T>? withHaptic<T>(ValueChanged<T>? onChanged) => onChanged == null
    ? null
    : (value) {
        Haptics.light();
        onChanged(value);
      };

/// Chosen in the settings, stored for all servers; applied to [Haptics].
class HapticLevelNotifier extends Notifier<HapticLevel> {
  static const _key = 'haptics';

  @override
  HapticLevel build() {
    final SharedPreferences prefs;
    try {
      prefs = ref.watch(sharedPreferencesProvider);
    } catch (_) {
      // Tests of single widgets don't provide preferences.
      return Haptics.level = HapticLevel.normal;
    }
    return Haptics.level = HapticLevel.values.asNameMap()[prefs.getString(_key)] ?? HapticLevel.normal;
  }

  Future<void> set(HapticLevel level) async {
    state = Haptics.level = level;
    // A sample of the new strength.
    Haptics.medium();
    await ref.read(sharedPreferencesProvider).setString(_key, level.name);
  }
}

final hapticLevelProvider = NotifierProvider<HapticLevelNotifier, HapticLevel>(HapticLevelNotifier.new);
