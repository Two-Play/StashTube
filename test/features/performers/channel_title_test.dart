import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/performers/performer_page.dart';

import '../../helpers.dart';

class _Repo implements StashRepository {
  @override
  Future<Performer> findPerformer(String id) async => Performer(id: id, name: 'Alice');

  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    if (query.filter.portraitOnly || page > 1) return const PageResult(items: [], totalCount: 0);
    return PageResult(
      items: [for (var i = 0; i < 30; i++) Scene(id: '$i', title: 'Video $i', streamUrl: 'http://s/$i')],
      totalCount: 30,
    );
  }

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('the app bar shows the name only once the header scrolled away (CH-1)', (tester) async {
    final prefs = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      return SharedPreferences.getInstance();
    }))!;
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(_Repo()),
      ],
      child: const MaterialApp(home: PerformerPage(performerId: '1')),
    ));
    await tester.pumpAndSettle();

    double titleOpacity() => tester
        .widget<AnimatedOpacity>(find.descendant(of: find.byType(AppBar), matching: find.byType(AnimatedOpacity)))
        .opacity;

    expect(find.text('Alice'), findsNWidgets(2), reason: 'app bar and header');
    expect(titleOpacity(), 0, reason: 'the header shows the name at the top');
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget, reason: 'the actions stay');

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(titleOpacity(), 1);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 600));
    await tester.pumpAndSettle();
    expect(titleOpacity(), 0, reason: 'hidden again back at the top');
  });
}
