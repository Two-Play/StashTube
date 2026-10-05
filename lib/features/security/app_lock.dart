import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

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
  static const _salt = 'lock_pin_salt';
  static const _hash = 'lock_pin_hash';

  @override
  AppLockSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppLockSettings(
      // Only "enabled" when a PIN exists, so a half-set-up lock can't lock out.
      enabled: (prefs.getBool(_enabled) ?? false) && prefs.getString(_hash) != null,
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
    await prefs.setString(_salt, salt);
    await prefs.setString(_hash, hashPin(pin, salt));
    await prefs.setInt(_pinLength, pin.length);
    await prefs.setBool(_enabled, true);
    state = state.copyWith(enabled: true, pinLength: pin.length);
  }

  Future<void> disable() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_hash);
    await prefs.remove(_salt);
    await prefs.setBool(_enabled, false);
    await prefs.setBool(_biometrics, false);
    state = state.copyWith(enabled: false, biometrics: false);
  }

  bool verify(String pin) {
    final prefs = ref.read(sharedPreferencesProvider);
    final salt = prefs.getString(_salt);
    final hash = prefs.getString(_hash);
    return salt != null && hash != null && hashPin(pin, salt) == hash;
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

/// Whether the lock screen is showing. Locked at start when the lock is on;
/// locks again after [AppLockSettings.lockAfter] in the background.
class AppLockStateNotifier extends Notifier<bool> {
  DateTime? _backgroundedAt;

  /// Injectable clock for tests.
  @visibleForTesting
  DateTime Function() now = DateTime.now;

  @override
  bool build() => ref.read(appLockSettingsProvider).enabled;

  void appHidden() {
    if (ref.read(appLockSettingsProvider).enabled) _backgroundedAt ??= now();
  }

  void appShown() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    final settings = ref.read(appLockSettingsProvider);
    if (!settings.enabled || since == null) return;
    if (now().difference(since) >= settings.lockAfter) state = true;
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

/// Android: FLAG_SECURE hides the app in the recents screen (and blocks
/// screenshots). iOS has no equivalent; the privacy cover handles it there.
class SecureWindow {
  static const _channel = MethodChannel('stash/privacy');

  static Future<void> set(bool secure) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('setSecure', secure);
    } on MissingPluginException {
      // Not available (tests, other platforms).
    }
  }
}
