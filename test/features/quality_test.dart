import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/features/player/player_controls.dart';
import 'package:stash_app_mobile/features/player/player_providers.dart';

const _details = SceneDetails(streams: [
  SceneStream(url: 'http://s/direct', label: 'Direct stream'),
  SceneStream(url: 'http://s/hls', label: 'HLS 720p', mimeType: 'application/vnd.apple.mpegurl'),
]);

Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    sceneDetailsProvider('1').overrideWith((ref) async => _details),
  ]);
}

void main() {
  test('preferred stream is persisted and can be reset', () async {
    final container = await _container();
    addTearDown(container.dispose);
    expect(container.read(preferredStreamProvider), isNull);

    await container.read(preferredStreamProvider.notifier).set('HLS 720p');
    expect(container.read(sharedPreferencesProvider).getString('preferred_stream'), 'HLS 720p');

    final reloaded = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(container.read(sharedPreferencesProvider)),
    ]);
    addTearDown(reloaded.dispose);
    expect(reloaded.read(preferredStreamProvider), 'HLS 720p');

    await container.read(preferredStreamProvider.notifier).set(null);
    expect(container.read(sharedPreferencesProvider).getString('preferred_stream'), isNull);
  });

  testWidgets('quality sheet lists streams and marks the current one', (tester) async {
    final container = await _container();
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showQualitySheet(context, '1'),
            child: const Text('open'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Direct stream'), findsOneWidget);
    expect(find.text('HLS 720p'), findsOneWidget);
    expect(find.text('Adaptive streaming'), findsOneWidget);

    Finder checkIn(String label) =>
        find.descendant(of: find.widgetWithText(ListTile, label), matching: find.byIcon(Icons.check));
    expect(checkIn('Direct stream'), findsOneWidget, reason: 'direct file plays by default');
    expect(checkIn('HLS 720p'), findsNothing);

    container.read(currentStreamProvider.notifier).set(_details.streams[1]);
    await tester.pump();
    expect(checkIn('Direct stream'), findsNothing);
    expect(checkIn('HLS 720p'), findsOneWidget);
  });
}
