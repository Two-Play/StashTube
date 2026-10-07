import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secrets of the saved servers (API keys, passwords; 2.5) in the Keychain
/// (iOS) or the Keystore-encrypted storage (Android) instead of plain
/// SharedPreferences.
///
/// Loaded once before `runApp` and then read synchronously, like the
/// preferences, so the server config can still be built without waiting;
/// writes go to the cache at once and to the platform storage in the
/// background.
abstract interface class SecretStore {
  String? read(String key);
  Future<void> write(String key, String? value);

  /// Deletes every secret whose key passes [test], e.g. a removed server's.
  Future<void> deleteWhere(bool Function(String key) test);
}

class SecureSecretStore implements SecretStore {
  SecureSecretStore._(this._storage, this._cache);

  static Future<SecureSecretStore> load() async {
    const storage = FlutterSecureStorage();
    Map<String, String> values;
    try {
      values = await storage.readAll();
    } catch (e) {
      // Unreadable (e.g. a restored Android backup): start empty, the user
      // enters the key again.
      debugPrint('Secure storage unreadable: $e');
      values = {};
    }
    return SecureSecretStore._(storage, values);
  }

  final FlutterSecureStorage _storage;
  final Map<String, String> _cache;

  @override
  String? read(String key) => _cache[key];

  @override
  Future<void> write(String key, String? value) async {
    if (_cache[key] == value) return;
    if (value == null) {
      _cache.remove(key);
      await _storage.delete(key: key);
    } else {
      _cache[key] = value;
      await _storage.write(key: key, value: value);
    }
  }

  @override
  Future<void> deleteWhere(bool Function(String key) test) async {
    for (final key in _cache.keys.where(test).toList()) {
      await write(key, null);
    }
  }
}

/// In memory only: the default in tests, which don't override
/// [secretStoreProvider].
class MemorySecretStore implements SecretStore {
  MemorySecretStore([Map<String, String>? values]) : values = {...?values};

  final Map<String, String> values;

  @override
  String? read(String key) => values[key];

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> deleteWhere(bool Function(String key) test) async => values.removeWhere((key, _) => test(key));
}

/// Overridden in `main()` with the [SecureSecretStore] loaded before `runApp`.
final secretStoreProvider = Provider<SecretStore>((ref) => MemorySecretStore());
