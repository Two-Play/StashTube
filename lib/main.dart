import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/image_cache.dart';
import 'core/config/secret_store.dart';
import 'core/config/server_config.dart';
import 'data/repositories/stash_repository.dart';
import 'features/security/app_lock_gate.dart';
import 'features/settings/about.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final secrets = await SecureSecretStore.load();
  // Before runApp, so it handles "back" before the app's navigators do.
  WidgetsBinding.instance.addObserver(lockBackGuard);

  registerAppLicenses();
  runApp(ProviderScope(
    retry: stashRetry,
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secretStoreProvider.overrideWithValue(secrets),
      clearImageCacheProvider.overrideWithValue(clearDeviceImageCache),
    ],
    child: const StashApp(),
  ));
}
