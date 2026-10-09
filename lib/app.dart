import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/locale.dart';
import 'core/config/server_config.dart';
import 'core/config/theme.dart';
import 'features/auth/login_page.dart';
import 'features/pip/pip.dart';
import 'features/security/app_lock_gate.dart';
import 'features/shell/app_shell.dart';
import 'l10n/l10n.dart';

class StashApp extends ConsumerWidget {
  const StashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(serverProfilesProvider).active;
    final accent = ref.watch(accentColorProvider);

    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      locale: ref.watch(appLocaleProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(accent),
      darkTheme: AppTheme.dark(accent),
      themeMode: ref.watch(themeModeProvider),
      builder: (context, child) => AppLockGate(child: PipScope(child: child ?? const SizedBox.shrink())),
      // Keyed by server so all per-server state is rebuilt after switching.
      home: server == null ? const LoginPage() : AppShell(key: ValueKey(server.id)),
    );
  }
}
