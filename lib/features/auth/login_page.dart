import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/design_tokens.dart';
import '../../core/config/haptics.dart';
import '../../core/config/server_config.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/app_logo.dart';
import '../demo/demo_server.dart';
import '../settings/theme_welcome.dart';

/// Checks that a config reaches a working Stash server (see [findServer]);
/// replaceable in tests.
final serverVerifierProvider = Provider<Future<void> Function(ServerConfig)>(
  (ref) => StashRepository.verifyServer,
);

/// How the credentials step signs in.
enum _AuthMethod { apiKey, password }

/// Connects the app to a Stash server in two steps (ONB-1): the address
/// and an optional name first, and only when the server asks for it
/// (401/403) an API key or a username and password (2.7).
/// Lists saved servers to pick from (2.6). Pushed from the settings with
/// [addServer] to save another server, or with [edit] to change a saved
/// one (2.7), which shows address and sign-in together.
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
  _AuthMethod _method = _AuthMethod.apiKey;

  /// The addresses that asked for a login: set, the credentials step shows.
  List<String>? _authUrls;

  /// The address the user already agreed to reach over plain HTTP.
  String? _insecureConfirmed;
  String? _error;

  bool get _editing => widget.edit != null;

  bool get _credentialsStep => _authUrls != null;

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
      if (edit.username != null && (edit.apiKey ?? '').isEmpty) _method = _AuthMethod.password;
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

  /// Plain HTTP over the internet: asks once per address.
  Future<bool> _allowUnencrypted(ServerConfig config) async {
    if (!config.isUnencryptedOverInternet || _insecureConfirmed == config.baseUrl) return true;
    final ok = await _confirmUnencrypted(config);
    if (ok) _insecureConfirmed = config.baseUrl;
    return ok;
  }

  /// Step 1: tries the address without credentials. A server without a
  /// login is saved right away; one that asks for it opens step 2.
  Future<void> _connect() async {
    if (!_formKey.currentState!.validate()) return;
    final urls = ServerConfig.candidateUrls(_urlController.text);
    final candidates = [for (final url in urls) ServerConfig(baseUrl: url)];
    if (candidates.isNotEmpty && !await _allowUnencrypted(candidates.first)) return;
    if (!mounted) return;

    await _run(() async {
      try {
        await _save(await findServer(candidates, verify: ref.read(serverVerifierProvider)));
      } on StashApiException catch (e) {
        if (e.kind != StashErrorKind.unauthorized) rethrow;
        if (mounted) setState(() => _authUrls = urls);
      }
    });
  }

  /// Step 2 (and saving an edited server): connects with the credentials.
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final apiKey = _apiKeyController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final useKey = _method == _AuthMethod.apiKey;
    ServerConfig configFor(String url) => ServerConfig(
          baseUrl: url,
          apiKey: useKey && apiKey.isNotEmpty ? apiKey : null,
          username: !useKey && username.isNotEmpty ? username : null,
          password: !useKey && password.isNotEmpty ? password : null,
        );

    final urls = _editing ? ServerConfig.candidateUrls(_urlController.text) : _authUrls!;
    final candidates = urls.map(configFor).toList();
    if (candidates.isNotEmpty && !await _allowUnencrypted(candidates.first)) return;
    if (!mounted) return;

    await _run(() async => _save(await findServer(candidates, verify: ref.read(serverVerifierProvider))));
  }

  /// Runs [action] with the progress indicator, showing its error.
  Future<void> _run(Future<void> Function() action) async {
    final l = context.l10n;
    setState(() {
      _connecting = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      Haptics.error();
      if (mounted) setState(() => _error = errorText(l, e));
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  Future<void> _save(ServerConfig config) async {
    final servers = ref.read(serverProfilesProvider.notifier);
    final edit = widget.edit;
    if (edit != null) {
      await servers.update(edit.id, config, name: _nameController.text);
    } else {
      // The first login asks for a theme once the shell is there.
      if (ref.read(serverProfilesProvider).profiles.isEmpty) {
        await ref.read(themeWelcomeProvider.notifier).request();
      }
      // Activating the server swaps the app to its shell (see StashApp).
      await servers.add(config, name: _nameController.text);
    }
    if (mounted && widget._pushed) Navigator.of(context).pop();
  }

  /// Back from the credentials step to the address.
  void _changeAddress() {
    Haptics.selection();
    setState(() {
      _authUrls = null;
      _error = null;
    });
  }

  /// Opens the built-in demo (sample library, no server needed).
  Future<void> _tryDemo() async {
    final l = context.l10n;
    await _run(() async {
      await DemoServer.instance.start();
      final servers = ref.read(serverProfilesProvider.notifier);
      if (ref.read(serverProfilesProvider).profiles.isEmpty) {
        await ref.read(themeWelcomeProvider.notifier).request();
      }
      await servers.add(const ServerConfig(baseUrl: ServerConfig.demoUrl), name: l.demoServerName);
    });
  }

  /// Plain HTTP over the internet sends the API key or password in the
  /// clear: ask first.
  Future<bool> _confirmUnencrypted(ServerConfig config) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.lock_open_outlined),
          title: Text(context.l10n.insecureConnectionTitle),
          content: Text(context.l10n.insecureConnectionBody(Uri.parse(config.baseUrl).host)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.cancel)),
            TextButton(onPressed: () => Navigator.pop(context, true), child: Text(context.l10n.connectAnyway)),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      // Back from the credentials step returns to the address.
      canPop: !_credentialsStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _credentialsStep) _changeAddress();
      },
      child: Scaffold(
        // Adding a server has the heading in the page, like the first login.
        appBar: _editing ? AppBar(title: Text(context.l10n.editServer)) : (widget.addServer ? AppBar() : null),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
              child: ConstrainedBox(
                // Landscape and tablets: a readable column, not full width.
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!_editing) ...[
                          const Center(child: AppLogo(size: 72, background: AppLogo.tile)),
                          const SizedBox(height: AppSpacing.l),
                          Text(
                            widget.addServer ? context.l10n.addServerTitle : context.l10n.connectToStash,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.topCenter,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween(
                                  begin: Offset(child.key == const ValueKey('credentials') ? 0.15 : -0.15, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            ),
                            layoutBuilder: (current, previous) => Stack(
                              alignment: Alignment.topCenter,
                              children: [...previous, ?current],
                            ),
                            child: _editing
                                ? KeyedSubtree(key: const ValueKey('edit'), child: _credentials(theme))
                                : _credentialsStep
                                    ? KeyedSubtree(key: const ValueKey('credentials'), child: _credentials(theme))
                                    : KeyedSubtree(key: const ValueKey('address'), child: _address(theme)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The address; the name field follows it in both forms.
  Widget _urlField() => TextFormField(
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
      );

  /// The optional name; empty keeps the default (the address).
  Widget _nameField({required VoidCallback onSubmitted}) => TextFormField(
        controller: _nameController,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => onSubmitted(),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: context.l10n.nameOptional,
          hintText: context.l10n.nameHint,
          prefixIcon: const Icon(Icons.label_outline),
        ),
      );

  Widget _errorAndButton(ThemeData theme, {required String label, required VoidCallback onPressed}) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _connecting ? null : onPressed,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: _connecting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(label),
          ),
        ],
      );

  /// Step 1: the address and name, saved servers and the demo.
  Widget _address(ThemeData theme) {
    final saved = widget._pushed ? const <ServerProfile>[] : ref.watch(serverProfilesProvider).profiles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.s),
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
        const SizedBox(height: AppSpacing.xl),
        _urlField(),
        const SizedBox(height: AppSpacing.l),
        _nameField(onSubmitted: _connect),
        _errorAndButton(theme, label: context.l10n.connect, onPressed: _connect),
        if (!widget._pushed) ...[
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: _connecting ? null : _tryDemo,
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.play_circle_outline),
            label: Text(context.l10n.tryDemo),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tryDemoHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  /// Step 2: API key or username and password (the name was asked in
  /// step 1 and shows under the title). Editing a saved server shows
  /// address, name and sign-in together.
  Widget _credentials(ThemeData theme) {
    final l = context.l10n;
    final useKey = _method == _AuthMethod.apiKey;
    final urls = _authUrls;
    final host = urls != null && urls.isNotEmpty ? Uri.parse(urls.first).host : null;
    final name = _nameController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        if (_editing) ...[
          _urlField(),
          const SizedBox(height: AppSpacing.l),
          _nameField(onSubmitted: _signIn),
        ] else ...[
          Row(
            children: [
              IconButton(
                onPressed: _connecting ? null : _changeAddress,
                tooltip: l.changeServerAddress,
                icon: const BackButtonIcon(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.loginAuthTitle, style: theme.textTheme.titleMedium),
                    if (host != null)
                      Text(
                        name.isEmpty ? host : l.loginAuthServer(name, host),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.loginAuthIntro,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: 24),
        SegmentedButton<_AuthMethod>(
          segments: [
            ButtonSegment(value: _AuthMethod.apiKey, icon: const Icon(Icons.key_outlined), label: Text(l.apiKey)),
            ButtonSegment(
              value: _AuthMethod.password,
              icon: const Icon(Icons.person_outline),
              label: Text(l.loginMethodPassword),
            ),
          ],
          selected: {_method},
          onSelectionChanged: _connecting
              ? null
              : (selected) {
                  Haptics.selection();
                  setState(() {
                    _method = selected.first;
                    _error = null;
                  });
                },
        ),
        const SizedBox(height: 16),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: useKey
              ? TextFormField(
                  key: const ValueKey('apiKey'),
                  controller: _apiKeyController,
                  autofocus: !_editing,
                  obscureText: _obscureKey,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _signIn(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: _editing ? l.apiKeyOptional : l.apiKey,
                    helperText: l.apiKeyWhere,
                    helperMaxLines: 3,
                    prefixIcon: const Icon(Icons.key_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureKey ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscureKey = !_obscureKey),
                    ),
                  ),
                  // Editing, an empty key means a server without a login.
                  validator: (v) => !_editing && (v ?? '').trim().isEmpty ? l.apiKeyRequired : null,
                )
              : Column(
                  key: const ValueKey('password'),
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      autofocus: !_editing,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l.username,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty || _passwordController.text.isEmpty
                          ? l.loginIncomplete
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
                      onFieldSubmitted: (_) => _signIn(),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l.password,
                        helperText: l.signInWithPasswordHint,
                        helperMaxLines: 2,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        _errorAndButton(theme, label: _editing ? l.save : l.signIn, onPressed: _signIn),
      ],
    );
  }
}

/// The first of [candidates] (the same server with and without Stash's
/// default port) that answers as a Stash server. All are tried, since
/// something else may answer on one of them (e.g. a proxy). If none works,
/// the error of one that reached a server (e.g. a wrong API key) is shown
/// rather than failing to connect, or else a blocked local network; [verify] is replaceable for tests.
Future<ServerConfig> findServer(
  List<ServerConfig> candidates, {
  Future<void> Function(ServerConfig) verify = StashRepository.verifyServer,
}) async {
  final errors = <(Object, StackTrace)>[];
  for (final config in candidates) {
    try {
      await verify(config);
      return config;
    } catch (e, stack) {
      errors.add((e, stack));
    }
  }
  if (errors.isEmpty) throw StateError('No address to try');
  // Then a blocked local network (iOS), which says what to do about it.
  bool kind(Object e, bool Function(StashApiException) test) => e is StashApiException && test(e);
  final (error, stack) = errors.firstWhere(
    (e) => kind(e.$1, (e) => !e.isNetworkError),
    orElse: () => errors.firstWhere(
      (e) => kind(e.$1, (e) => e.kind == StashErrorKind.localNetworkDenied),
      orElse: () => errors.first,
    ),
  );
  Error.throwWithStackTrace(error, stack);
}
