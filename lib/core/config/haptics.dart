import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'server_config.dart';

/// How strong the app's haptic feedback is (settings).
enum HapticLevel { off, light, normal }

/// The app's haptic feedback, following [HapticLevel]: off, one step
/// lighter, or as named. Use these instead of [HapticFeedback].
abstract final class Haptics {
  /// Set by [hapticLevelProvider].
  static HapticLevel level = HapticLevel.normal;

  /// A choice changed: tabs, chips, steps while scrubbing.
  static void selection() {
    if (level != HapticLevel.off) unawaited(HapticFeedback.selectionClick());
  }

  /// A small action: play/pause, a toggle.
  static void light() => _play(HapticFeedback.selectionClick, HapticFeedback.lightImpact);

  /// A noticeable action: a favorite, the O-counter, a refresh.
  static void medium() => _play(HapticFeedback.lightImpact, HapticFeedback.mediumImpact);

  /// A strong action: a long press opening a menu, unlocking.
  static void heavy() => _play(HapticFeedback.mediumImpact, HapticFeedback.heavyImpact);

  /// Something failed: a wrong PIN, a failed login.
  static void error() => _play(HapticFeedback.mediumImpact, HapticFeedback.vibrate);

  static void _play(Future<void> Function() light, Future<void> Function() normal) {
    switch (level) {
      case HapticLevel.off:
        return;
      case HapticLevel.light:
        unawaited(light());
      case HapticLevel.normal:
        unawaited(normal());
    }
  }
}

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
