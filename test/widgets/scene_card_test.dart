import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/features/settings/scene_card_config.dart';
import 'package:stash_app_mobile/l10n/l10n.dart';
import 'package:stash_app_mobile/widgets/scene_card.dart';

import '../helpers.dart';

void main() {
  testWidgets('SceneCard shows title, channel, duration and resolution', (tester) async {
    const scene = Scene(
      id: '1',
      title: 'My scene',
      duration: 125,
      height: 1080,
      performers: [Performer(id: '9', name: 'Alice')],
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [...testServer],
      child: const MaterialApp(home: Scaffold(body: SingleChildScrollView(child: SceneCard(scene: scene)))),
    ));

    expect(find.text('My scene'), findsOneWidget);
    expect(find.text('Alice • No plays'), findsOneWidget);
    expect(find.text('2:05'), findsOneWidget);
    expect(find.text('1080p'), findsOneWidget);
  });

  testWidgets('shows a progress bar only for partially watched scenes', (tester) async {
    Future<void> pump(Scene scene) => tester.pumpWidget(ProviderScope(
          overrides: [...testServer],
          child: MaterialApp(home: Scaffold(body: SceneThumbnail(scene: scene))),
        ));

    await pump(const Scene(id: '1', title: 'A', duration: 100));
    expect(find.byType(LinearProgressIndicator), findsNothing);

    await pump(const Scene(id: '2', title: 'B', duration: 100, resumeTime: 25));
    final bar = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
    expect(bar.value, 0.25);
  });

  group('card settings', () {
    const scene = Scene(
      id: '1',
      title: 'My scene',
      playCount: 12,
      rating100: 80,
      studio: Studio(id: '3', name: 'Studio X'),
      performers: [Performer(id: '9', name: 'Alice'), Performer(id: '10', name: 'Bea')],
    );

    Future<void> pump(WidgetTester tester, SceneCardConfig config) => tester.pumpWidget(ProviderScope(
          overrides: [...testServerOnly, sceneCardConfigProvider.overrideWith(() => _Fixed(config))],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: Column(children: [SceneCard(scene: scene), SceneListTile(scene: scene)])),
            ),
          ),
        ));

    testWidgets('show the studio, plays and stars by default', (tester) async {
      await pump(tester, const SceneCardConfig());
      expect(find.text('Studio X • 12 plays • ★ 4'), findsOneWidget);
      expect(find.text('12 plays • ★ 4'), findsOneWidget, reason: 'list tile meta line');
    });

    testWidgets('can name the performers instead', (tester) async {
      await pump(tester, const SceneCardConfig(channel: CardChannel.performers));
      expect(find.text('Alice, Bea • 12 plays • ★ 4'), findsOneWidget);
    });

    testWidgets('fall back to the studio without performers', (tester) async {
      expect(
        SceneChannel(lookupAppLocalizations(const Locale('en')), const Scene(id: '2', title: 'x', studio: Studio(id: '3', name: 'S')),
                CardChannel.performers)
            .name,
        'S',
      );
    });

    testWidgets('can hide plays and rating', (tester) async {
      await pump(tester, const SceneCardConfig(showPlays: false, showRating: false));
      expect(find.text('Studio X'), findsNWidgets(2));
      expect(find.textContaining('plays'), findsNothing);
      expect(find.textContaining('★'), findsNothing);
    });
  });
}

class _Fixed extends SceneCardConfigNotifier {
  _Fixed(this.config);

  final SceneCardConfig config;

  @override
  SceneCardConfig build() => config;
}
