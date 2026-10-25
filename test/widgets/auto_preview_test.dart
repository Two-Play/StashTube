import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/widgets/animated_previews.dart';
import 'package:stash_app_mobile/widgets/auto_preview.dart';
import 'package:stash_app_mobile/widgets/stash_image.dart';

import '../helpers.dart';

void main() {
  Future<void> pumpList(
    WidgetTester tester, {
    bool previews = true,
    bool firstHasPreview = true,
    Duration delay = FeedPreviewDelayNotifier.standard,
    List<Override> overrides = const [],
  }) =>
      tester.pumpWidget(ProviderScope(
        overrides: [
          ...testServer,
          feedPreviewsProvider.overrideWithBuild((ref, notifier) => previews),
          // The WebP: a video preview would need the native player.
          previewSourceProvider.overrideWithBuild((ref, notifier) => PreviewSource.animatedImage),
          ...overrides,
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AutoPreviewScope(
              delay: delay,
              child: ListView(
                children: [
                  for (var i = 0; i < 20; i++)
                    SizedBox(
                      height: 200,
                      child: AutoPreview(
                        url: i == 0 && !firstHasPreview ? null : 'http://s/$i.webp',
                        child: Text('still $i'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ));

  List<String?> playing(WidgetTester tester) =>
      [for (final image in tester.widgetList<StashImage>(find.byType(StashImage))) image.url];

  testWidgets('the first fully shown video plays after 0.5 s by default', (tester) async {
    await pumpList(tester);
    await tester.pump(const Duration(milliseconds: 400));
    expect(playing(tester), isEmpty, reason: 'not right away');
    await tester.pump(const Duration(milliseconds: 200));
    expect(playing(tester), ['http://s/0.webp']);
  });

  testWidgets('the delay follows the setting', (tester) async {
    await pumpList(tester, delay: const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 2900));
    expect(playing(tester), isEmpty);
    await tester.pump(const Duration(milliseconds: 200));
    expect(playing(tester), ['http://s/0.webp']);
  });

  test('lists and markers are switched separately; the delay is stored', () async {
    SharedPreferences.setMockInitialValues({'animated_previews': false});
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    expect([c.read(feedPreviewsProvider), c.read(markerPreviewsProvider)], [false, false],
        reason: 'both take over the earlier shared setting');

    await c.read(markerPreviewsProvider.notifier).set(true);
    expect([c.read(feedPreviewsProvider), c.read(markerPreviewsProvider)], [false, true]);

    expect(c.read(feedPreviewDelayProvider), const Duration(milliseconds: 500));
    await c.read(feedPreviewDelayProvider.notifier).set(const Duration(seconds: 3));
    expect(prefs.getInt('feed_preview_delay_ms'), 3000);
  });

  testWidgets('scrolling stops it; the new first one plays once it rests', (tester) async {
    await pumpList(tester);
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), ['http://s/0.webp']);

    // Half of tile 1 scrolls out: tile 2 is the first fully shown one.
    final gesture = await tester.startGesture(tester.getCenter(find.byType(ListView)));
    await gesture.moveBy(const Offset(0, -300));
    await tester.pump();
    expect(playing(tester), isEmpty);
    await gesture.up();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), ['http://s/2.webp']);
  });

  testWidgets('videos without a preview are skipped', (tester) async {
    await pumpList(tester, firstHasPreview: false);
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), ['http://s/1.webp']);
  });

  testWidgets('nothing plays with previews switched off', (tester) async {
    await pumpList(tester, previews: false);
    await tester.pump(const Duration(seconds: 3));
    expect(playing(tester), isEmpty);
    expect(find.text('still 0'), findsOneWidget);
  });

  group('only on Wi-Fi (PERF-1)', () {
    List<Override> on(List<ConnectivityResult> connections, {bool wifiOnly = true}) => [
          previewsWifiOnlyProvider.overrideWithBuild((ref, notifier) => wifiOnly),
          connectivityProvider.overrideWith((ref) => Stream.value(connections)),
        ];

    testWidgets('no previews on mobile data', (tester) async {
      await pumpList(tester, overrides: on([ConnectivityResult.mobile]));
      await tester.pump(const Duration(seconds: 1));
      expect(playing(tester), isEmpty);
    });

    for (final connections in [
      [ConnectivityResult.wifi, ConnectivityResult.vpn],
      [ConnectivityResult.ethernet],
    ]) {
      testWidgets('previews on $connections', (tester) async {
        await pumpList(tester, overrides: on(connections));
        await tester.pump(const Duration(seconds: 1));
        expect(playing(tester), ['http://s/0.webp']);
      });
    }

    testWidgets('by default they play on mobile data too, without asking for the connection', (tester) async {
      var asked = false;
      await pumpList(tester, overrides: [
        connectivityProvider.overrideWith((ref) {
          asked = true;
          return Stream.value([ConnectivityResult.mobile]);
        }),
      ]);
      await tester.pump(const Duration(seconds: 1));
      expect(playing(tester), ['http://s/0.webp']);
      expect(asked, isFalse);
    });

    test('previews play the MP4 by default; a stored choice wins', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
      addTearDown(c.dispose);
      expect(c.read(previewSourceProvider), PreviewSource.video);
      await c.read(previewSourceProvider.notifier).set(PreviewSource.animatedImage);
      expect(prefs.getString('preview_source'), 'animatedImage');
    });

    test('the setting is stored, off by default', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
      addTearDown(c.dispose);
      expect(c.read(previewsWifiOnlyProvider), isFalse);
      await c.read(previewsWifiOnlyProvider.notifier).set(true);
      expect(prefs.getBool('previews_wifi_only'), isTrue);
    });
  });
}
