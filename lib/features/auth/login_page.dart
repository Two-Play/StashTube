import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';

/// Connects the app to a Stash server (URL + optional API key and name).
/// Lists saved servers to pick from (2.6). Pushed from the settings with
/// [addServer] to save another server.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.addServer = false});

  final bool addServer;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _nameController = TextEditingController();
  bool _connecting = false;
  bool _obscureKey = true;
  String? _error;

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (!_formKey.currentState!.validate()) return;
    final apiKey = _apiKeyController.text.trim();
    final config = ServerConfig(
      baseUrl: ServerConfig.normalizeUrl(_urlController.text)!,
      apiKey: apiKey.isEmpty ? null : apiKey,
    );

    setState(() {
      _connecting = true;
      _error = null;
    });
    try {
      await StashRepository.verifyServer(config);
      // Activating the server swaps the app to its shell (see StashApp).
      await ref.read(serverProfilesProvider.notifier).add(config, name: _nameController.text);
      if (mounted && widget.addServer) Navigator.of(context).pop();
    } catch (e) {
      HapticFeedback.vibrate();
      if (mounted) setState(() => _error = errorText(context.l10n, e));
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saved = widget.addServer ? const <ServerProfile>[] : ref.watch(serverProfilesProvider).profiles;
    return Scaffold(
      appBar: widget.addServer ? AppBar(title: Text(context.l10n.addServer)) : null,
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
                    if (!widget.addServer) ...[
                      Icon(Icons.play_circle_fill, size: 72, color: theme.colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(context.l10n.connectToStash, textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                    ],
                    const SizedBox(height: 8),
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
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _connect(),
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
                          : Text(context.l10n.connect),
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
