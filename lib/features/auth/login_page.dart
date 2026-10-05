import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../data/repositories/stash_repository.dart';

/// Connects the app to a Stash server (URL + optional API key).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  bool _connecting = false;
  bool _obscureKey = true;
  String? _error;

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
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
      // Switching the config swaps the app to the shell (see StashApp).
      await ref.read(serverConfigProvider.notifier).save(config);
    } catch (e) {
      HapticFeedback.vibrate();
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                    Icon(Icons.play_circle_fill, size: 72, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text('Connect to Stash', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the address of your Stash server, e.g. http://192.168.1.10:9999',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.url],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Server URL',
                        prefixIcon: Icon(Icons.dns_outlined),
                      ),
                      validator: (v) => ServerConfig.normalizeUrl(v ?? '') == null ? 'Enter a valid http(s) URL' : null,
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
                        labelText: 'API key (optional)',
                        helperText: 'Required if your server has a password. Stash → Settings → Security.',
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
                          : const Text('Connect'),
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
