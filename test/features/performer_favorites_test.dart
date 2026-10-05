import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/performers/favorite_button.dart';
import 'package:stash_app_mobile/features/performers/performer_favorites.dart';

class FakeRepository implements StashRepository {
  final calls = <(String, bool)>[];
  Completer<void>? gate;
  bool fail = false;

  @override
  Future<void> setPerformerFavorite(String performerId, bool favorite) async {
    calls.add((performerId, favorite));
    await gate?.future;
    if (fail) throw const StashApiException('denied');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const alice = Performer(id: '1', name: 'Alice');
  late FakeRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = FakeRepository();
    container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo)]);
  });
  tearDown(() => container.dispose());

  bool? favoriteOf(String id) => container.read(performerFavoritesProvider)[id];

  test('updates optimistically and saves the new value', () async {
    repo.gate = Completer();
    final future = container.read(performerFavoritesProvider.notifier).toggle(alice);
    expect(favoriteOf('1'), isTrue, reason: 'visible before the server answered');

    repo.gate!.complete();
    await future;
    expect(repo.calls, [('1', true)]);
    expect(favoriteOf('1'), isTrue);

    await container.read(performerFavoritesProvider.notifier).toggle(alice);
    expect(repo.calls.last, ('1', false), reason: 'toggles from the session state, not the stale model');
    expect(favoriteOf('1'), isFalse);
  });

  test('reverts and rethrows when saving fails', () async {
    repo.fail = true;
    await expectLater(
      container.read(performerFavoritesProvider.notifier).toggle(alice),
      throwsA(isA<StashApiException>()),
    );
    expect(favoriteOf('1'), isFalse);
  });

  test('ignores taps while a change is being saved', () async {
    repo.gate = Completer();
    final notifier = container.read(performerFavoritesProvider.notifier);
    final first = notifier.toggle(alice);
    await notifier.toggle(alice);
    repo.gate!.complete();
    await first;
    expect(repo.calls, hasLength(1));
    expect(favoriteOf('1'), isTrue);
  });

  testWidgets('FavoriteButton switches label and shows errors', (tester) async {
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: Scaffold(body: FavoriteButton(performer: alice))),
    ));
    expect(find.text('Favorite'), findsOneWidget);

    await tester.tap(find.text('Favorite'));
    await tester.pumpAndSettle();
    expect(find.text('Favorited'), findsOneWidget);

    repo.fail = true;
    await tester.tap(find.text('Favorited'));
    await tester.pumpAndSettle();
    expect(find.text('Favorited'), findsOneWidget, reason: 'reverted');
    expect(find.textContaining('Couldn\'t update favorite'), findsOneWidget);
  });
}
