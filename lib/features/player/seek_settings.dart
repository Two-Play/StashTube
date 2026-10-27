import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/server_config.dart';

/// How double taps on the player's sides seek (Settings → Playback →
/// "Double-tap to seek"); per device, for all servers.
class SeekSettings {
  const SeekSettings({this.enabled = true, this.step = defaultStep, this.cumulative = true});

  static const defaultStep = Duration(seconds: 5);

  /// The steps offered in the settings.
  static const steps = [Duration(seconds: 5), Duration(seconds: 10), Duration(seconds: 15), Duration(seconds: 30)];

  /// Off: a double tap is no gesture, and a single tap toggles the controls
  /// without waiting for a possible second tap.
  final bool enabled;

  /// The jump of a double tap.
  final Duration step;

  /// "Keep tapping to skip further" growing faster: see [total].
  final bool cumulative;

  /// The total jump after [taps] taps of a seek sequence (the double tap
  /// counts as the first).
  ///
  /// Cumulative: `step` for the first, then `2 × step × (taps − 1)`, so 5 s
  /// gives today's 5, 10, 20, 30, 40 s and 10 s gives 10, 20, 40, 60, 80 s:
  /// a short first jump, then larger strides for long skips.
  ///
  /// Otherwise every further tap adds one step (5, 10, 15, 20 s), like
  /// YouTube, whose setting is only the step and adds it per tap.
  Duration total(int taps) {
    if (taps <= 1) return step;
    return cumulative ? step * (2 * (taps - 1)) : step * taps;
  }

  SeekSettings copyWith({bool? enabled, Duration? step, bool? cumulative}) => SeekSettings(
        enabled: enabled ?? this.enabled,
        step: step ?? this.step,
        cumulative: cumulative ?? this.cumulative,
      );

  @override
  bool operator ==(Object other) =>
      other is SeekSettings && other.enabled == enabled && other.step == step && other.cumulative == cumulative;

  @override
  int get hashCode => Object.hash(enabled, step, cumulative);
}

class SeekSettingsNotifier extends Notifier<SeekSettings> {
  static const _enabledKey = 'seek_double_tap';
  static const _stepKey = 'seek_step_seconds';
  static const _cumulativeKey = 'seek_cumulative';

  @override
  SeekSettings build() {
    final SharedPreferences prefs;
    try {
      prefs = ref.watch(sharedPreferencesProvider);
    } catch (_) {
      // Tests of single widgets don't provide preferences.
      return const SeekSettings();
    }
    final seconds = prefs.getInt(_stepKey);
    return SeekSettings(
      enabled: prefs.getBool(_enabledKey) ?? true,
      step: seconds != null && seconds > 0 ? Duration(seconds: seconds) : SeekSettings.defaultStep,
      cumulative: prefs.getBool(_cumulativeKey) ?? true,
    );
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await ref.read(sharedPreferencesProvider).setBool(_enabledKey, enabled);
  }

  Future<void> setStep(Duration step) async {
    state = state.copyWith(step: step);
    await ref.read(sharedPreferencesProvider).setInt(_stepKey, step.inSeconds);
  }

  Future<void> setCumulative(bool cumulative) async {
    state = state.copyWith(cumulative: cumulative);
    await ref.read(sharedPreferencesProvider).setBool(_cumulativeKey, cumulative);
  }
}

final seekSettingsProvider = NotifierProvider<SeekSettingsNotifier, SeekSettings>(SeekSettingsNotifier.new);
