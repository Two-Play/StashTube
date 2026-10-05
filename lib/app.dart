import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/server_config.dart';
import 'core/config/theme.dart';
import 'features/auth/login_page.dart';
import 'features/shell/app_shell.dart';

class StashApp extends ConsumerWidget {
  const StashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(serverConfigProvider);

    return MaterialApp(
      title: 'Stash',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      // Keyed by server so all per-server state is rebuilt after switching.
      home: config == null ? const LoginPage() : AppShell(key: ValueKey(config.baseUrl)),
    );
  }
}
