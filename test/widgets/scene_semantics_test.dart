import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/studio.dart';
import 'package:stash_app_mobile/l10n/l10n.dart';
import 'package:stash_app_mobile/widgets/performer_tile.dart';
import 'package:stash_app_mobile/widgets/scene_card.dart';

import '../helpers.dart';

void main() {
  const scene = Scene(
    id: '1',
    title: 'My scene',
    duration: 725,
    height: 1080,
    playCount: 3,
    rating100: 80,
    resumeTime: 290,
    studio: Studio(id: '3', name: 'Studio X'),
    performers: [Performer(id: '9', name: 'Alice')],
  );

  Future<void> pump(WidgetTester tester, Widget child) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [...testServer, sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: child)),
        ),
      ),
    );
  }

  test('spoken durations', () {
    final l = lookupAppLocalizations(const Locale('en'));
    expect(spokenDuration(l, 725), '12 minutes 5 seconds');
    expect(spokenDuration(l, 3600), '1 hour');
    expect(spokenDuration(l, 3661), '1 hour 1 minute 1 second');
    expect(spokenDuration(l, 0), '0 seconds');
    expect(spokenDuration(lookupAppLocalizations(const Locale('de')), 125), '2 Minuten 5 Sekunden');
  });

  const gridLabel = 'My scene, Studio X, 12 minutes 5 seconds, 3 plays, 4 stars, 40% watched';

  testWidgets('a grid tile is one button with the whole label, its ⋮ a button of its own', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const SizedBox(width: 200, height: 230, child: SceneGridTile(scene: scene)));

    final tile = tester.getSemantics(find.byType(TileSemantics));
    expect(tile, isSemantics(label: gridLabel, isButton: true, hasTapAction: true, hasLongPressAction: true));
    final children = <SemanticsNode>[];
    tile.visitChildren((child) {
      children.add(child);
      return true;
    });
    expect(children, hasLength(1));
    expect(children.single, isSemantics(tooltip: 'More options', isButton: true, hasTapAction: true));
    // The badges and texts are not read on their own.
    expect(find.bySemanticsLabel('12:05'), findsNothing);
    expect(find.bySemanticsLabel('My scene'), findsNothing);
    handle.dispose();
  });

  testWidgets('every scene tile shows the ⋮', (tester) async {
    await pump(
      tester,
      const Column(
        children: [
          SceneCard(scene: scene),
          SceneListTile(scene: scene),
          SizedBox(width: 200, height: 230, child: SceneGridTile(scene: scene)),
        ],
      ),
    );
    expect(find.byType(SceneMenuButton), findsNWidgets(3));

    await tester.ensureVisible(find.byType(SceneMenuButton).last);
    await tester.tap(find.byType(SceneMenuButton).last);
    await tester.pumpAndSettle();
    expect(find.text('Play'), findsOneWidget, reason: 'the scene menu opened');
  });

  testWidgets('the card label adds resolution and date, the channel is a button', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const SceneCard(scene: scene));
    expect(
      find.bySemanticsLabel('My scene, Studio X, 12 minutes 5 seconds, 1080p, 3 plays, 4 stars, 40% watched'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Go to Studio X'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('a performer tile reads name and scene count once', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const SizedBox(
        width: 160,
        height: 260,
        child: PerformerTile(
          performer: Performer(id: '9', name: 'Alice', sceneCount: 2),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Alice, 2 scenes'), findsOneWidget);
    expect(find.bySemanticsLabel('Alice'), findsNothing);
    handle.dispose();
  });
}
