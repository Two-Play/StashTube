import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';
import 'package:stash_app_mobile/features/shorts/shorts_feed.dart';
import 'package:stash_app_mobile/features/shorts/shorts_page.dart';
import 'package:stash_app_mobile/widgets/status_views.dart';

import '../helpers.dart';
import 'fake_player.dart';

class _EmptyFeed extends ShortsFeedNotifier {
  @override
  ShortsFeedState build() => const ShortsFeedState(hasMore: false);
}

void main() {
  testWidgets('without shorts the empty view is centered on the screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      ...testServer,
      sharedPreferencesProvider.overrideWithValue(prefs),
      playerProvider.overrideWithValue(FakePlayer()),
      shortsFeedProvider.overrideWith(_EmptyFeed.new),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: ShortsPage()),
    ));
    await tester.pump();

    final screen = tester.getRect(find.byType(ShortsPage));
    final empty = tester.getRect(find.byType(EmptyView));
    expect(empty.center.dx, moreOrLessEquals(screen.center.dx, epsilon: 1));
    expect(empty.center.dy, moreOrLessEquals(screen.center.dy, epsilon: 1));
    expect(tester.takeException(), isNull);

    // The page resets its providers after it is gone, so remove it first.
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const SizedBox()));
    await tester.pump();
  });
}
