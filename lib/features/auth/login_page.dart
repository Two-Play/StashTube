import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/server_config.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/stash_logo.dart';
import '../settings/theme_welcome.dart';

/// Connects the app to a Stash server (URL, optional name, and an API key
/// or a username and password, 2.7).
/// Lists saved servers to pick from (2.6). Pushed from the settings with
/// [addServer] to save another server, or with [edit] to change a saved
/// one (2.7).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.addServer = false, this.edit});

  final bool addServer;
  final ServerProfile? edit;

  bool get _pushed => addServer || edit != null;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _connecting = false;
  bool _obscureKey = true;
  bool _obscurePassword = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final edit = widget.edit;
    if (edit != null) {
      _nameController.text = edit.name;
      _urlController.text = edit.baseUrl;
      _apiKeyController.text = edit.apiKey ?? '';
      _usernameController.text = edit.username ?? '';
      _passwordController.text = edit.password ?? '';
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (!_formKey.currentState!.validate()) return;
    final apiKey = _apiKeyController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final config = ServerConfig(
      baseUrl: ServerConfig.normalizeUrl(_urlController.text)!,
      apiKey: apiKey.isEmpty ? null : apiKey,
      username: username.isEmpty ? null : username,
      password: password.isEmpty ? null : password,
    );

    setState(() {
      _connecting = true;
      _error = null;
    });
    try {
      await StashRepository.verifyServer(config);
      final servers = ref.read(serverProfilesProvider.notifier);
      final edit = widget.edit;
      if (edit != null) {
        await servers.update(edit.id, config, name: _nameController.text);
      } else {
        // The first login asks for a theme once the shell is there.
        if (ref.read(serverProfilesProvider).profiles.isEmpty) await ref.read(themeWelcomeProvider.notifier).request();
        // Activating the server swaps the app to its shell (see StashApp).
        await servers.add(config, name: _nameController.text);
      }
      if (mounted && widget._pushed) Navigator.of(context).pop();
    } catch (e) {
      Haptics.error();
      if (mounted) setState(() => _error = errorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.edit != null;
    final saved = widget._pushed ? const <ServerProfile>[] : ref.watch(serverProfilesProvider).profiles;
    return Scaffold(
      appBar: widget._pushed
          ? AppBar(title: Text(editing ? context.l10n.editServer : context.l10n.addServer))
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!widget._pushed) ...[
                      const Center(child: StashLogo(size: 72, background: StashLogo.tile)),
                      const SizedBox(height: 12),
                      Text(context.l10n.connectToStash, textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                    ],
                    const SizedBox(height: 8),
                    if (!editing)
                      Text(
                        context.l10n.loginIntro,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    if (saved.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(context.l10n.savedServers, style: theme.textTheme.titleSmall),
                      for (final server in saved)
                        Card(
                          margin: const EdgeInsets.only(top: 8),
                          child: ListTile(
                            leading: const Icon(Icons.dns_outlined),
                            title: Text(server.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(server.baseUrl, maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => ref.read(serverProfilesProvider.notifier).activate(server.id),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(context.l10n.orAddAnotherServer, style: theme.textTheme.titleSmall),
                    ],
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: context.l10n.nameOptional,
                        hintText: context.l10n.nameHint,
                        prefixIcon: const Icon(Icons.label_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.url],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: context.l10n.serverUrl,
                        prefixIcon: const Icon(Icons.dns_outlined),
                      ),
                      validator: (v) => ServerConfig.normalizeUrl(v ?? '') == null ? context.l10n.serverUrlInvalid : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _apiKeyController,
                      obscureText: _obscureKey,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: context.l10n.apiKeyOptional,
                        helperText: context.l10n.apiKeyHelper,
                        helperMaxLines: 2,
                        prefixIcon: const Icon(Icons.key_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureKey ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscureKey = !_obscureKey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(context.l10n.orSignIn, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.orSignInHint,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _usernameController,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: context.l10n.username,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty != _passwordController.text.isEmpty
                          ? context.l10n.loginIncomplete
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _connect(),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: context.l10n.password,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _connecting ? null : _connect,
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      child: _connecting
                          ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(editing ? context.l10n.save : context.l10n.connect),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
