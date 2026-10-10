import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/config/secret_store.dart';
import '../../core/config/server_config.dart';

/// App lock (11.1) and app switcher privacy (11.2) settings.
@immutable
class AppLockSettings {
  const AppLockSettings({
    this.enabled = false,
    this.biometrics = false,
    this.lockAfter = Duration.zero,
    this.hideInSwitcher = false,
    this.pinLength = 4,
  });

  final bool enabled;
  final bool biometrics;

  /// How long the app may be in the background before it locks again.
  final Duration lockAfter;
  final bool hideInSwitcher;
  final int pinLength;

  /// Whether the app is hidden in the app switcher and covered while
  /// inactive: always with the lock on, else by [hideInSwitcher].
  bool get hidesApp => enabled || hideInSwitcher;

  AppLockSettings copyWith({bool? enabled, bool? biometrics, Duration? lockAfter, bool? hideInSwitcher, int? pinLength}) =>
      AppLockSettings(
        enabled: enabled ?? this.enabled,
        biometrics: biometrics ?? this.biometrics,
        lockAfter: lockAfter ?? this.lockAfter,
        hideInSwitcher: hideInSwitcher ?? this.hideInSwitcher,
        pinLength: pinLength ?? this.pinLength,
      );
}

/// Salted SHA-256 of a PIN; the PIN itself is never stored.
String hashPin(String pin, String salt) => sha256.convert(utf8.encode('$salt:$pin')).toString();

class AppLockSettingsNotifier extends Notifier<AppLockSettings> {
  static const _enabled = 'lock_enabled';
  static const _biometrics = 'lock_biometrics';
  static const _lockAfter = 'lock_after_seconds';
  static const _hide = 'lock_hide_in_switcher';
  static const _pinLength = 'lock_pin_length';

  /// `<salt>:<hash>` in the [SecretStore]: one value, so changing the PIN
  /// can't leave a new salt with the old hash.
  static const _pin = 'lock_pin';
  // Where versions before the secret store kept them (SharedPreferences).
  static const _legacySalt = 'lock_pin_salt';
  static const _legacyHash = 'lock_pin_hash';

  /// Salt and hash of the PIN, or null when none is set.
  ({String salt, String hash})? _storedPin() {
    final stored = ref.read(secretStoreProvider).read(_pin);
    final separator = stored?.indexOf(':') ?? -1;
    if (stored != null && separator > 0) {
      return (salt: stored.substring(0, separator), hash: stored.substring(separator + 1));
    }
    final prefs = ref.read(sharedPreferencesProvider);
    final salt = prefs.getString(_legacySalt);
    final hash = prefs.getString(_legacyHash);
    return salt == null || hash == null ? null : (salt: salt, hash: hash);
  }

  @override
  AppLockSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final secrets = ref.watch(secretStoreProvider);
    final pin = _storedPin();
    if (pin != null && secrets.read(_pin) == null) {
      // Move a PIN of an older version out of SharedPreferences.
      secrets.write(_pin, '${pin.salt}:${pin.hash}').then((_) async {
        await prefs.remove(_legacySalt);
        await prefs.remove(_legacyHash);
      });
    }
    return AppLockSettings(
      // Only "enabled" when a PIN exists, so a half-set-up lock can't lock out.
      enabled: (prefs.getBool(_enabled) ?? false) && pin != null,
      biometrics: prefs.getBool(_biometrics) ?? false,
      lockAfter: Duration(seconds: prefs.getInt(_lockAfter) ?? 0),
      hideInSwitcher: prefs.getBool(_hide) ?? false,
      pinLength: prefs.getInt(_pinLength) ?? 4,
    );
  }

  /// Turns the lock on with a new PIN (also used to change the PIN).
  Future<void> enable(String pin) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final random = Random.secure();
    final salt = base64Encode(List<int>.generate(16, (_) => random.nextInt(256)));
    await ref.read(secretStoreProvider).write(_pin, '$salt:${hashPin(pin, salt)}');
    await prefs.remove(_legacySalt);
    await prefs.remove(_legacyHash);
    await prefs.setInt(_pinLength, pin.length);
    await prefs.setBool(_enabled, true);
    if (!ref.mounted) return;
    ref.read(pinThrottleProvider.notifier).reset();
    state = state.copyWith(enabled: true, pinLength: pin.length);
  }

  Future<void> disable() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await ref.read(secretStoreProvider).write(_pin, null);
    await prefs.remove(_legacyHash);
    await prefs.remove(_legacySalt);
    await prefs.setBool(_enabled, false);
    await prefs.setBool(_biometrics, false);
    if (!ref.mounted) return;
    state = state.copyWith(enabled: false, biometrics: false);
  }

  /// Checks [pin]. Wrong PINs count towards [PinThrottle]; while it blocks,
  /// every PIN is rejected.
  bool verify(String pin) {
    final throttle = ref.read(pinThrottleProvider.notifier);
    if (throttle.remaining() > Duration.zero) return false;
    final stored = _storedPin();
    final ok = stored != null && hashPin(pin, stored.salt) == stored.hash;
    if (ok) {
      throttle.reset();
    } else {
      throttle.recordFailure();
    }
    return ok;
  }

  Future<void> setBiometrics(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(_biometrics, value);
    state = state.copyWith(biometrics: value);
  }

  Future<void> setLockAfter(Duration value) async {
    await ref.read(sharedPreferencesProvider).setInt(_lockAfter, value.inSeconds);
    state = state.copyWith(lockAfter: value);
  }

  Future<void> setHideInSwitcher(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(_hide, value);
    state = state.copyWith(hideInSwitcher: value);
  }
}

final appLockSettingsProvider =
    NotifierProvider<AppLockSettingsNotifier, AppLockSettings>(AppLockSettingsNotifier.new);

/// Wrong PIN entries in a row. After [freeAttempts] of them, each further
/// one blocks the PIN pad for a growing time, so a 4-digit PIN can't simply
/// be tried out. Stored on the device: restarting the app doesn't reset it.
@immutable
class PinThrottle {
  const PinThrottle({this.failures = 0, this.blockedUntil});

  static const freeAttempts = 5;
  static const _delays = [
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 5),
    Duration(minutes: 15),
    Duration(hours: 1),
  ];

  final int failures;
  final DateTime? blockedUntil;

  /// How long the PIN pad is blocked after [failures] wrong entries in a row.
  static Duration delayAfter(int failures) =>
      failures < freeAttempts ? Duration.zero : _delays[(failures - freeAttempts).clamp(0, _delays.length - 1)];
}

class PinThrottleNotifier extends Notifier<PinThrottle> {
  static const _failures = 'lock_failed_attempts';
  static const _blockedUntil = 'lock_blocked_until';

  /// Injectable clock for tests.
  @visibleForTesting
  DateTime Function() now = DateTime.now;

  @override
  PinThrottle build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final until = prefs.getInt(_blockedUntil);
    return PinThrottle(
      failures: prefs.getInt(_failures) ?? 0,
      blockedUntil: until == null ? null : DateTime.fromMillisecondsSinceEpoch(until),
    );
  }

  /// Time left until the PIN may be tried again; zero when not blocked.
  Duration remaining() {
    final until = state.blockedUntil;
    if (until == null) return Duration.zero;
    final left = until.difference(now());
    if (left <= Duration.zero) return Duration.zero;
    // Never longer than the delay itself, e.g. after the clock was set back.
    final delay = PinThrottle.delayAfter(state.failures);
    return left > delay ? delay : left;
  }

  void recordFailure() {
    final failures = state.failures + 1;
    final delay = PinThrottle.delayAfter(failures);
    final until = delay == Duration.zero ? null : now().add(delay);
    state = PinThrottle(failures: failures, blockedUntil: until);
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setInt(_failures, failures);
    if (until == null) {
      prefs.remove(_blockedUntil);
    } else {
      prefs.setInt(_blockedUntil, until.millisecondsSinceEpoch);
    }
  }

  /// After a successful unlock.
  void reset() {
    if (state.failures == 0 && state.blockedUntil == null) return;
    state = const PinThrottle();
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.remove(_failures);
    prefs.remove(_blockedUntil);
  }
}

final pinThrottleProvider = NotifierProvider<PinThrottleNotifier, PinThrottle>(PinThrottleNotifier.new);

/// Whether the lock screen is showing. Locked at start when the lock is on;
/// locks again after [AppLockSettings.lockAfter] in the background. With no
/// delay it locks as the app is hidden, so neither the app switcher nor the
/// way back shows the content.
class AppLockStateNotifier extends Notifier<bool> {
  DateTime? _backgroundedAt;

  /// Injectable clock for tests.
  @visibleForTesting
  DateTime Function() now = DateTime.now;

  @override
  bool build() => ref.read(appLockSettingsProvider).enabled;

  void appHidden() {
    final settings = ref.read(appLockSettingsProvider);
    if (!settings.enabled) return;
    _backgroundedAt ??= now();
    if (settings.lockAfter == Duration.zero) state = true;
  }

  void appShown() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    final settings = ref.read(appLockSettingsProvider);
    if (!settings.enabled || since == null) return;
    final away = now().difference(since);
    // A negative time means the clock was set back: lock as well.
    if (away.isNegative || away >= settings.lockAfter) state = true;
  }

  void unlock() => state = false;
}

final appLockedProvider = NotifierProvider<AppLockStateNotifier, bool>(AppLockStateNotifier.new);

/// Biometric unlock behind an interface (tests use a fake).
abstract interface class BiometricAuth {
  Future<bool> isAvailable();
  Future<bool> authenticate(String reason);
}

class LocalBiometricAuth implements BiometricAuth {
  final _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true, // was `stickyAuth`
      );
    } on LocalAuthException {
      // Cancelled, locked out, not enrolled, ...: the PIN pad stays.
      return false;
    } on PlatformException {
      return false;
    }
  }
}

final biometricAuthProvider = Provider<BiometricAuth>((ref) => LocalBiometricAuth());

/// The native side of hiding the app (`stash/privacy`).
///
/// Android: FLAG_SECURE hides the app in the recents screen (and blocks
/// screenshots). iOS: a native cover goes over the app as soon as it
/// resigns active (locking the phone, the app switcher), when
/// [AppLockSettings.hidesApp]. Flutter can't draw
/// its own cover in time there: the app is in the background before the
/// next frame, so its last frame, with the content, would show on return
/// until the lock screen is drawn. The cover stays until [uncover], once
/// Flutter has drawn again.
class SecureWindow {
  static const _channel = MethodChannel('stash/privacy');

  /// Android only: iOS reads the setting itself when the app resigns
  /// active (a message sent at startup could arrive before its handler).
  static Future<void> set(bool secure) =>
      _invoke(defaultTargetPlatform == TargetPlatform.android ? 'setSecure' : null, secure);

  /// iOS: removes the native cover once Flutter has drawn a frame again.
  static Future<void> uncover() => _invoke(defaultTargetPlatform == TargetPlatform.iOS ? 'uncover' : null);

  static Future<void> _invoke(String? method, [Object? arguments]) async {
    if (method == null) return;
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } on MissingPluginException {
      // Not available (tests, other platforms).
    }
  }
}
