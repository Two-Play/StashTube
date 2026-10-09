import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/marker.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/markers_tab.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/shell/nav_bar_config.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';
import 'package:stash_app_mobile/widgets/animated_previews.dart';
import 'package:stash_app_mobile/widgets/stash_image.dart';

import '../helpers.dart';

const _scene = Scene(id: 's1', title: 'Beach day', streamUrl: 'http://s/1');

class _Repo implements StashRepository {
  final queries = <MarkerQuery>[];

  @override
  Future<PageResult<Marker>> findMarkers(MarkerQuery query, {int page = 1, int perPage = 24}) async {
    queries.add(query);
    return const PageResult(
      items: [
        Marker(
          id: 'm1',
          title: 'Sunset',
          seconds: 83,
          tag: Tag(id: 't1', name: 'Outdoor'),
          scene: _scene,
          screenshotUrl: 'http://s/m1/screenshot',
          previewUrl: 'http://s/m1/preview',
        ),
        Marker(id: 'm2', title: 'Outdoor', seconds: 5, tag: Tag(id: 't1', name: 'Outdoor'), scene: _scene),
      ],
      totalCount: 2,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Playing extends NowPlayingNotifier {
  final played = <(String, double?)>[];

  @override
  Scene? build() => null;

  @override
  void play(Scene scene, {double? at}) => played.add((scene.id, at));
}

/// The image placeholders shimmer forever: pump a while instead of settling.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('lists the markers and plays a scene from its marker', (tester) async {
    final repo = _Repo();
    final playing = _Playing();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        stashRepositoryProvider.overrideWithValue(repo),
        nowPlayingProvider.overrideWith(() => playing),
      ],
      child: const MaterialApp(home: Scaffold(body: MarkersTab())),
    ));
    await settle(tester);

    expect(find.text('2 markers'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('1:23'), findsOneWidget, reason: 'the time of the marker');
    expect(find.text('#Outdoor'), findsOneWidget, reason: 'only where the title is not the tag');
    expect(repo.queries.single.sort, MarkerSort.recentlyAdded);

    await tester.tap(find.text('Sunset'));
    expect(playing.played, [('s1', 83.0)]);

    await tester.tap(find.text('A–Z'));
    await settle(tester);
    expect(repo.queries.last.sort, MarkerSort.title);
    expect(repo.queries.last.direction, 'ASC');
  });

  test('a random order keeps its seed while scrolling', () {
    final query = MarkerQuery(sort: MarkerSort.random);
    expect(query.sortField, startsWith('random_'));
    expect(MarkerQuery(sort: MarkerSort.random, seed: query.seed), query);
    expect(MarkerQuery().sortField, 'created_at');
  });

  test('the markers tab starts hidden in the bar', () {
    expect(NavBarConfig.standard.isVisible(AppTab.markers), isFalse);
  });

  testWidgets('marker tiles loop their preview over the still, unless switched off', (tester) async {
    Future<List<String?>> urls({required bool previews}) async {
      await tester.pumpWidget(ProviderScope(
        key: UniqueKey(),
        overrides: [
          ...testServer,
          stashRepositoryProvider.overrideWithValue(_Repo()),
          animatedPreviewsProvider.overrideWithBuild((ref, notifier) => previews),
        ],
        child: const MaterialApp(home: Scaffold(body: MarkersTab())),
      ));
      await settle(tester);
      final tile = find.byType(MarkerTile).first;
      return [
        for (final image in tester.widgetList<StashImage>(find.descendant(of: tile, matching: find.byType(StashImage))))
          image.url,
      ];
    }

    expect(await urls(previews: true), ['http://s/m1/preview', 'http://s/m1/screenshot']);
    expect(await urls(previews: false), ['http://s/m1/screenshot']);
  });
}
