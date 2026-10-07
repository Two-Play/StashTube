import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/home/home_page.dart';
import 'package:stash_app_mobile/features/shorts/shorts_shelf.dart';

import '../helpers.dart';

/// 30 scenes for every list, portrait ones for the shorts.
class _Repo implements StashRepository {
  @override
  Future<PageResult<Scene>> findScenes(SceneQuery query, {int page = 1, int perPage = 24}) async {
    final shorts = query.filter.portraitOnly;
    return PageResult(
      items: page > 1
          ? const []
          : [
              for (var i = 0; i < (shorts ? 6 : 30); i++)
                Scene(id: '${shorts ? 's' : 'v'}$i', title: '${shorts ? 'Short' : 'Video'} $i', streamUrl: 'http://s/$i'),
            ],
      totalCount: shorts ? 6 : 30,
    );
  }

  @override
  Future<List<SavedFilter>> savedSceneFilters() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
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
      child: const MaterialApp(home: HomePage()),
    ));
    await tester.pumpAndSettle();
  }

  double barOffset(WidgetTester tester) => tester.widget<AnimatedSlide>(find.byType(AnimatedSlide)).offset.dy;

  testWidgets('the app bar hides while scrolling down and comes back when scrolling up', (tester) async {
    await pumpHome(tester);
    expect(barOffset(tester), 0);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(barOffset(tester), -1);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(barOffset(tester), 0);
    // Not part of the list, so a tap reaches its buttons.
    expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.search)).onPressed, isNotNull);
  });

  testWidgets('shows four shorts on the home page', (tester) async {
    await pumpHome(tester);
    expect(find.byType(ShortsShelf), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      expect(find.text('Short $i'), findsOneWidget);
    }
    expect(find.text('Short 4'), findsNothing);
  });
}
