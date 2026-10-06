import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

class _DetailsRepository implements StashRepository {
  int loads = 0;

  @override
  Future<SceneDetails> findSceneDetails(String sceneId) async {
    loads++;
    return const SceneDetails();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // testWidgets for its fake clock.
  testWidgets('scene details stay cached for a while without listeners', (tester) async {
    final repo = _DetailsRepository();
    final c = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo)]);

    Future<void> listenOnce() async {
      final sub = c.listen(sceneDetailsProvider('1'), (_, _) {});
      await tester.pump();
      sub.close();
      await tester.pump();
    }

    await listenOnce();
    await tester.pump(const Duration(minutes: 4));
    await listenOnce(); // e.g. the player expanded again
    expect(repo.loads, 1);

    await tester.pump(const Duration(minutes: 6));
    await listenOnce();
    expect(repo.loads, 2);
    c.dispose(); // also cancels the cache timer
  });
}
