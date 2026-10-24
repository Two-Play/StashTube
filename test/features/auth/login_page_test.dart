import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/secret_store.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/auth/login_page.dart';
import 'package:stash_app_mobile/widgets/app_logo.dart';

/// The two-step login (ONB-1): the address first, credentials only when
/// the server asks for them.
void main() {
  /// Every config the login tried.
  late List<ServerConfig> tried;

  /// A server at `nas:9999`; with [needsAuth] it accepts only the API key
  /// `key` or the login `me`/`secret`.
  Future<ProviderContainer> pumpLogin(
    WidgetTester tester, {
    required bool needsAuth,
    bool addServer = false,
    bool localNetworkDenied = false,
  }) async {
    tried = [];
    Future<void> verify(ServerConfig config) async {
      tried.add(config);
      if (localNetworkDenied && config.baseUrl == 'http://nas') {
        throw const StashApiException('No route to host', isNetworkError: true, kind: StashErrorKind.localNetworkDenied);
      }
      if (config.baseUrl != 'http://nas:9999' || localNetworkDenied) {
        throw const StashApiException('unreachable', isNetworkError: true, kind: StashErrorKind.unreachable);
      }
      if (!needsAuth) return;
      final authorized = config.apiKey == 'key' || (config.username == 'me' && config.password == 'secret');
      if (!authorized) throw const StashApiException('no', kind: StashErrorKind.unauthorized);
    }

    final c = await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      return ProviderContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        secretStoreProvider.overrideWithValue(MemorySecretStore()),
        serverVerifierProvider.overrideWithValue(verify),
      ]);
    });
    addTearDown(c!.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: c, child: MaterialApp(home: LoginPage(addServer: addServer))));
    return c;
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  Future<void> connect(WidgetTester tester, {String? name}) async {
    await tester.enterText(find.widgetWithText(TextFormField, 'Server URL'), 'nas');
    if (name != null) await tester.enterText(find.widgetWithText(TextFormField, 'Name (optional)'), name);
    await tapText(tester, 'Connect');
  }

  testWidgets('step 1 shows only address and name; a server without a login is saved right away', (tester) async {
    final c = await pumpLogin(tester, needsAuth: false);
    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text('Connect to Stash'), findsOneWidget);
    expect(find.textContaining('Enter the address of your Stash server'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Server URL'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Name (optional)'), findsOneWidget);
    expect(find.text('Try the demo'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2), reason: 'no key or login fields yet');

    await connect(tester);
    final active = c.read(serverProfilesProvider).active!;
    expect(active.baseUrl, 'http://nas:9999');
    expect(active.name, 'nas:9999', reason: 'the default name');
    expect(active.apiKey, isNull);
    expect(tried.first, const ServerConfig(baseUrl: 'http://nas:9999'));
  });

  testWidgets('the name from step 1 is saved for a server without a login', (tester) async {
    final c = await pumpLogin(tester, needsAuth: false);
    await connect(tester, name: 'Home');
    final active = c.read(serverProfilesProvider).active!;
    expect(active.baseUrl, 'http://nas:9999');
    expect(active.name, 'Home');
  });

  testWidgets('adding a server shows the logo, a heading and the intro', (tester) async {
    final c = await pumpLogin(tester, needsAuth: false, addServer: true);
    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text('Add a server'), findsOneWidget);
    expect(find.textContaining('Enter the address of your Stash server'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Name (optional)'), findsOneWidget);
    expect(find.text('Try the demo'), findsNothing);

    await connect(tester, name: 'NAS');
    expect(c.read(serverProfilesProvider).active!.name, 'NAS');
  });

  testWidgets('a server that asks for a login opens step 2; signs in with the API key', (tester) async {
    final c = await pumpLogin(tester, needsAuth: true);
    await connect(tester, name: 'Home');
    expect(c.read(serverProfilesProvider).profiles, isEmpty);
    expect(find.text('This server needs a login'), findsOneWidget);
    expect(find.text('Home · nas'), findsOneWidget, reason: 'the server being signed in to');
    expect(find.widgetWithText(TextFormField, 'Name (optional)'), findsNothing, reason: 'asked in step 1');
    expect(find.byWidgetPredicate((w) => w is SegmentedButton), findsOneWidget);
    expect(find.textContaining('Settings → Security'), findsOneWidget);
    expect(find.text('Try the demo'), findsNothing);

    await tapText(tester, 'Sign in');
    expect(find.text('Enter the API key.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'API key'), 'wrong');
    await tapText(tester, 'Sign in');
    expect(find.text('Not authorized – check the API key or login.'), findsOneWidget);
    expect(c.read(serverProfilesProvider).profiles, isEmpty);

    await tester.enterText(find.widgetWithText(TextFormField, 'API key'), 'key');
    await tapText(tester, 'Sign in');
    final active = c.read(serverProfilesProvider).active!;
    expect(active.apiKey, 'key');
    expect(active.username, isNull);
    expect(active.name, 'Home');
  });

  testWidgets('step 2 signs in with username and password', (tester) async {
    final c = await pumpLogin(tester, needsAuth: true);
    await connect(tester);
    expect(find.text('nas'), findsOneWidget, reason: 'without a name, the host');
    await tapText(tester, 'Username & password');
    expect(find.widgetWithText(TextFormField, 'API key'), findsNothing);

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'me');
    await tapText(tester, 'Sign in');
    expect(find.text('Enter username and password.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'secret');
    await tapText(tester, 'Sign in');
    final active = c.read(serverProfilesProvider).active!;
    expect(active.username, 'me');
    expect(active.password, 'secret');
    expect(active.apiKey, isNull);
    expect(tried.last.usesSession, isTrue);
  });

  testWidgets('back from step 2 returns to the address', (tester) async {
    await pumpLogin(tester, needsAuth: true);
    await connect(tester);
    await tester.tap(find.byTooltip('Change address'));
    await tester.pumpAndSettle();
    expect(find.text('This server needs a login'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'nas'), findsOneWidget, reason: 'the address stays');
    expect(find.text('Connect'), findsOneWidget);
  });

  testWidgets('a blocked local network (iOS) says where to allow it', (tester) async {
    final c = await pumpLogin(tester, needsAuth: false, localNetworkDenied: true);
    await connect(tester);
    expect(find.textContaining('Settings → Privacy & Security → Local Network → StashTube'), findsOneWidget,
        reason: 'preferred over the other address just being unreachable');
    expect(c.read(serverProfilesProvider).profiles, isEmpty);
  });
}
