import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// How a PIN is stored: never the PIN, only a slow, salted hash of it.
///
/// Current format: `pbkdf2-sha256$<iterations>$<salt>$<hash>` (salt and
/// hash base64). A 4–6 digit PIN has at most a million values, so a fast
/// hash could be tried out offline in seconds if the stored value leaked
/// (rooted or jailbroken device); PBKDF2 makes every guess cost
/// [defaultIterations] HMAC rounds. Versions before it stored
/// `<salt>:<hex SHA-256 of "salt:pin">` ([legacyHashPin]); such a value is
/// still accepted and replaced by the current format at the next correct
/// PIN (see `AppLockSettingsNotifier.verify`).
@immutable
class StoredPin {
  const StoredPin._(this.salt, this.hash, this.rounds);

  static const _prefix = 'pbkdf2-sha256';

  /// Rounds for new hashes. Every stored value keeps its own count, so this
  /// can be raised later without breaking existing PINs.
  static const defaultIterations = 60000;

  /// Rounds used by [create]; tests lower it.
  @visibleForTesting
  static int iterations = defaultIterations;

  final String salt;
  final String hash;

  /// PBKDF2 rounds; null for the legacy SHA-256 format.
  final int? rounds;

  /// Whether this is the old fast hash, to be replaced after the next
  /// correct PIN.
  bool get isLegacy => rounds == null;

  /// Parses a stored value; null when it is neither format.
  static StoredPin? parse(String? stored) {
    if (stored == null) return null;
    if (stored.startsWith('$_prefix\$')) {
      final parts = stored.split('\$');
      final rounds = parts.length == 4 ? int.tryParse(parts[1]) : null;
      if (rounds == null || rounds <= 0 || parts[2].isEmpty || parts[3].isEmpty) return null;
      return StoredPin._(parts[2], parts[3], rounds);
    }
    final separator = stored.indexOf(':');
    if (separator <= 0 || separator == stored.length - 1) return null;
    return StoredPin._(stored.substring(0, separator), stored.substring(separator + 1), null);
  }

  /// The legacy format, e.g. from the preferences of older versions.
  static StoredPin legacy(String salt, String hash) => StoredPin._(salt, hash, null);

  /// A new hash of [pin] with a random salt, in the current format.
  static Future<StoredPin> create(String pin) async {
    final random = Random.secure();
    final salt = base64Encode(List<int>.generate(16, (_) => random.nextInt(256)));
    final rounds = iterations;
    final hash = base64Encode(await _derive(pin, salt, rounds));
    return StoredPin._(salt, hash, rounds);
  }

  /// Whether [pin] matches, compared in constant time.
  Future<bool> matches(String pin) async {
    final rounds = this.rounds;
    if (rounds == null) return _equal(utf8.encode(legacyHashPin(pin, salt)), utf8.encode(hash));
    final List<int> expected;
    try {
      expected = base64Decode(hash);
    } on FormatException {
      return false;
    }
    return _equal(await _derive(pin, salt, rounds), expected);
  }

  /// The value to store.
  String encode() => isLegacy ? '$salt:$hash' : '$_prefix\$$rounds\$$salt\$$hash';

  /// Off the UI thread: [defaultIterations] rounds take a noticeable moment.
  static Future<Uint8List> _derive(String pin, String salt, int rounds) {
    if (rounds < 20000) return Future.value(pbkdf2Sha256(utf8.encode(pin), utf8.encode(salt), rounds));
    return Isolate.run(() => pbkdf2Sha256(utf8.encode(pin), utf8.encode(salt), rounds));
  }

  static bool _equal(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}

/// The hash of versions before PBKDF2: salted SHA-256. Only for checking
/// PINs stored by them.
String legacyHashPin(String pin, String salt) => sha256.convert(utf8.encode('$salt:$pin')).toString();

/// PBKDF2 with HMAC-SHA256 (RFC 8018), one 32-byte block.
Uint8List pbkdf2Sha256(List<int> password, List<int> salt, int iterations) {
  final hmac = Hmac(sha256, password);
  var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
  final result = Uint8List.fromList(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac.convert(u).bytes;
    for (var j = 0; j < result.length; j++) {
      result[j] ^= u[j];
    }
  }
  return result;
}
