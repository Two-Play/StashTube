import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/server_config.dart';
import 'core/config/theme.dart';
import 'features/auth/login_page.dart';
import 'features/security/app_lock_gate.dart';
import 'features/shell/app_shell.dart';

class StashApp extends ConsumerWidget {
  const StashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(serverConfigProvider);
    final accent = ref.watch(accentColorProvider);

    return MaterialApp(
      title: 'Stash',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(accent),
      darkTheme: AppTheme.dark(accent),
      themeMode: ref.watch(themeModeProvider),
      builder: (context, child) => AppLockGate(child: child ?? const SizedBox.shrink()),
      // Keyed by server so all per-server state is rebuilt after switching.
      home: config == null ? const LoginPage() : AppShell(key: ValueKey(config.baseUrl)),
    );
  }
}
