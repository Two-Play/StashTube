import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/auth/login_page.dart';
import 'package:stash_app_mobile/features/library/watch_later.dart';
import 'package:stash_app_mobile/features/player/scene_edits.dart';

void main() {
  late SharedPreferences prefs;

  Future<ProviderContainer> containerWith(Map<String, Object> initial) async {
    SharedPreferences.setMockInitialValues(initial);
    prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    return c;
  }

  test('migrates a single-server login into the first profile', () async {
    final c = await containerWith({'url': 'http://192.168.1.5:9999', 'api_key': 'k'});
    final state = c.read(serverProfilesProvider);
    expect(state.profiles.single.name, '192.168.1.5:9999');
    expect(state.active?.apiKey, 'k');
    expect(c.read(serverConfigProvider), const ServerConfig(baseUrl: 'http://192.168.1.5:9999', apiKey: 'k'));
    await pumpEventQueue();
    expect(prefs.getString('url'), isNull, reason: 'legacy keys are removed after migrating');
    expect(prefs.getString('server_profiles'), isNotNull);
  });

  test('add, switch, rename, remove', () async {
    final c = await containerWith({});
    final servers = c.read(serverProfilesProvider.notifier);
    expect(c.read(serverConfigProvider), isNull);

    final home = await servers.add(const ServerConfig(baseUrl: 'http://home:9999'), name: 'Home');
    final nas = await servers.add(const ServerConfig(baseUrl: 'https://nas.example', apiKey: 'secret'));
    expect(c.read(serverProfilesProvider).profiles.map((p) => p.name), ['Home', 'nas.example']);
    expect(c.read(serverProfilesProvider).activeId, nas.id, reason: 'a new server becomes active');

    // The same URL again updates that server instead of adding a duplicate.
    await servers.add(const ServerConfig(baseUrl: 'http://home:9999', apiKey: 'new'));
    expect(c.read(serverProfilesProvider).profiles, hasLength(2));
    expect(c.read(serverConfigProvider)?.apiKey, 'new');

    await servers.rename(home.id, 'Living room');
    await servers.activate(nas.id);
    expect(c.read(serverProfilesProvider).active?.name, 'nas.example');

    await servers.remove(nas.id);
    expect(c.read(serverProfilesProvider).profiles.single.name, 'Living room');
    expect(c.read(serverConfigProvider), isNull, reason: 'removing the active server leaves server choice');
  });

  test('editing a server changes URL and API key but keeps its id and data', () async {
    final c = await containerWith({});
    final servers = c.read(serverProfilesProvider.notifier);
    final home = await servers.add(const ServerConfig(baseUrl: 'http://old:9999', apiKey: 'k'), name: 'Home');
    await c.read(watchLaterProvider.notifier).toggle('7');

    await servers.update(home.id, const ServerConfig(baseUrl: 'http://new:9999'), name: 'NAS');
    final edited = c.read(serverProfilesProvider).active!;
    expect(edited.id, home.id);
    expect(edited.name, 'NAS');
    expect(c.read(serverConfigProvider), const ServerConfig(baseUrl: 'http://new:9999'));
    expect(c.read(watchLaterProvider), ['7']);
  });

  test('saved servers survive a restart', () async {
    final c = await containerWith({});
    await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://a:1', apiKey: 'k'), name: 'A');

    final restarted = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(restarted.dispose);
    expect(restarted.read(serverProfilesProvider).active?.name, 'A');
    expect(restarted.read(serverConfigProvider)?.apiKey, 'k');
  });

  test('watch later is kept per server and removed with the server', () async {
    final c = await containerWith({});
    final servers = c.read(serverProfilesProvider.notifier);
    final a = await servers.add(const ServerConfig(baseUrl: 'http://a:1'));
    await c.read(watchLaterProvider.notifier).toggle('scene-on-a');
    final b = await servers.add(const ServerConfig(baseUrl: 'http://b:1'));
    expect(c.read(watchLaterProvider), isEmpty, reason: 'server B has its own list');

    await servers.activate(a.id);
    expect(c.read(watchLaterProvider), ['scene-on-a']);

    await servers.remove(a.id);
    expect(prefs.getStringList('watch_later:${a.id}'), isNull);
    await servers.activate(b.id);
    expect(c.read(watchLaterProvider), isEmpty);
  });

  test('switching servers drops cached edits of the old server', () async {
    final c = await containerWith({});
    final servers = c.read(serverProfilesProvider.notifier);
    await servers.add(const ServerConfig(baseUrl: 'http://a:1'));
    c.listen(sceneEditsProvider, (_, _) {});
    // A cached edit for a scene of server A, then switch to server B.
    c.read(sceneEditsProvider.notifier).state = {'s1': const SceneEdit(oCounter: 5)};
    await servers.add(const ServerConfig(baseUrl: 'http://b:1'));
    expect(c.read(sceneEditsProvider), isEmpty);
  });

  test('ServerConfig has value equality', () {
    expect(const ServerConfig(baseUrl: 'http://a', apiKey: 'k'), const ServerConfig(baseUrl: 'http://a', apiKey: 'k'));
    expect(const ServerConfig(baseUrl: 'http://a'), isNot(const ServerConfig(baseUrl: 'http://a', apiKey: 'k')));
  });

  testWidgets('login page lists saved servers; tapping one switches to it', (tester) async {
    final c = await tester.runAsync(() async {
      final c = await containerWith({});
      final servers = c.read(serverProfilesProvider.notifier);
      final home = await servers.add(const ServerConfig(baseUrl: 'http://home:9999'), name: 'Home');
      await servers.add(const ServerConfig(baseUrl: 'http://nas:9999'), name: 'NAS');
      await servers.deactivate();
      return (c, home.id);
    });
    await tester.pumpWidget(UncontrolledProviderScope(container: c!.$1, child: const MaterialApp(home: LoginPage())));
    expect(find.text('Saved servers'), findsOneWidget);
    expect(find.text('NAS'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pump();
    expect(c.$1.read(serverProfilesProvider).activeId, c.$2);
  });
}
