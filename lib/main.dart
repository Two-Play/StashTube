import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/config/server_config.dart';
import 'data/repositories/stash_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    retry: stashRetry,
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const StashApp(),
  ));
}
