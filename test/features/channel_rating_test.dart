import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/channel/channel_rating.dart';

import '../helpers.dart';

class _Repository implements StashRepository {
  final saved = <(String, String, int?)>[];
  bool fail = false;

  /// What [studioRating] answers; null = a server without studio ratings.
  ({int? rating100})? studio = (rating100: 60);

  @override
  Future<void> setPerformerRating(String performerId, int? rating100) async {
    saved.add(('performer', performerId, rating100));
    if (fail) throw const StashApiException('denied');
  }

  @override
  Future<void> setStudioRating(String studioId, int? rating100) async {
    saved.add(('studio', studioId, rating100));
    if (fail) throw const StashApiException('denied');
  }

  @override
  Future<({int? rating100})?> studioRating(String studioId) async => studio;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const alice = Performer(id: '1', name: 'Alice', rating100: 40);
  late _Repository repo;
  late ProviderContainer container;

  setUp(() {
    repo = _Repository();
    container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo), ...testServer]);
  });
  tearDown(() => container.dispose());

  int? starsIn(ChannelKind kind, String id) => container.read(channelRatingsProvider)[ChannelRatingsNotifier.key(kind, id)];

  test('stars from Stash ratings', () {
    expect([starsOf(null), starsOf(0), starsOf(20), starsOf(50), starsOf(100)], [0, 0, 1, 3, 5]);
  });

  test('rating saves stars × 20; zero removes it', () async {
    final ratings = container.read(channelRatingsProvider.notifier);
    await ratings.rate(ChannelKind.performer, '1', 4, current: 2);
    await ratings.rate(ChannelKind.studio, '7', 0, current: 3);
    expect(repo.saved, [('performer', '1', 80), ('studio', '7', null)]);
    expect(starsIn(ChannelKind.performer, '1'), 4);
    expect(starsIn(ChannelKind.studio, '7'), 0);
  });

  test('a rejected rating goes back and rethrows', () async {
    repo.fail = true;
    await expectLater(
      container.read(channelRatingsProvider.notifier).rate(ChannelKind.performer, '1', 5, current: 2),
      throwsA(isA<StashApiException>()),
    );
    expect(starsIn(ChannelKind.performer, '1'), 2);
  });

  Future<void> pumpButtons(WidgetTester tester) => tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => Column(
                children: [
                  ChannelRatingButton(
                    key: const Key('performer'),
                    kind: ChannelKind.performer,
                    id: alice.id,
                    stars: (ref) => effectivePerformerStars(ref, alice),
                  ),
                  if (effectiveStudioStars(ref, '7') != null)
                    ChannelRatingButton(
                      key: const Key('studio'),
                      kind: ChannelKind.studio,
                      id: '7',
                      stars: (ref) => effectiveStudioStars(ref, '7') ?? 0,
                    ),
                ],
              ),
            ),
          ),
        ),
      ));

  testWidgets('the button shows the stars and rates through the sheet', (tester) async {
    await pumpButtons(tester);
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byKey(const Key('performer')), matching: find.text('2')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('studio')), matching: find.text('3')), findsOneWidget);

    await tester.tap(find.byKey(const Key('performer')));
    await tester.pumpAndSettle();
    expect(find.text('Rate this performer'), findsOneWidget);
    await tester.tap(find.byTooltip('Rate 5 stars'));
    await tester.pumpAndSettle();
    expect(repo.saved.last, ('performer', '1', 100));
    expect(find.descendant(of: find.byKey(const Key('performer')), matching: find.text('5')), findsOneWidget);
  });

  testWidgets('no studio stars on servers without studio ratings', (tester) async {
    repo.studio = null;
    await pumpButtons(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('studio')), findsNothing);
    expect(find.byKey(const Key('performer')), findsOneWidget);
  });
}
