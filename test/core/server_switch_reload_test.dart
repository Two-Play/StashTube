import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

/// A fake server whose scenes and performers are named after its URL.
class FakeServerRepository implements StashRepository {
  FakeServerRepository(this.url);

  final String url;

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async =>
      PageResult(items: [Scene(id: '1', title: 'scene from $url')], totalCount: 1);

  @override
  Future<PageResult<Performer>> findPerformers(PerformerQuery query, {int page = 1, int perPage = 24}) async =>
      PageResult(items: [Performer(id: '1', name: 'performer from $url')], totalCount: 1);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('lists reload from the new server after switching', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      stashRepositoryProvider.overrideWith((ref) => FakeServerRepository(ref.watch(serverConfigProvider)!.baseUrl)),
    ]);
    addTearDown(c.dispose);
    final servers = c.read(serverProfilesProvider.notifier);
    final a = await servers.add(const ServerConfig(baseUrl: 'http://a'));
    await servers.add(const ServerConfig(baseUrl: 'http://b'));
    await servers.activate(a.id);

    // Like the UI: lists stay subscribed while the server changes.
    final scenes = sceneListProvider(SceneQuery());
    final performers = performerListProvider(PerformerQuery());
    c.listen(scenes, (_, _) {});
    c.listen(performers, (_, _) {});
    expect((await c.read(scenes.future)).items.single.title, 'scene from http://a');

    await servers.activate(c.read(serverProfilesProvider).profiles.last.id);
    expect((await c.read(scenes.future)).items.single.title, 'scene from http://b');
    expect((await c.read(performers.future)).items.single.name, 'performer from http://b');
  });
}
