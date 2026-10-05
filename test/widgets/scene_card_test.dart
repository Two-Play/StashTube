import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/widgets/scene_card.dart';

void main() {
  testWidgets('SceneCard shows title, channel, duration and resolution', (tester) async {
    const scene = Scene(
      id: '1',
      title: 'My scene',
      duration: 125,
      height: 1080,
      performers: [Performer(id: '9', name: 'Alice')],
    );

    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: Scaffold(body: SingleChildScrollView(child: SceneCard(scene: scene)))),
    ));

    expect(find.text('My scene'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('2:05'), findsOneWidget);
    expect(find.text('1080p'), findsOneWidget);
  });

  testWidgets('shows a progress bar only for partially watched scenes', (tester) async {
    Future<void> pump(Scene scene) => tester.pumpWidget(ProviderScope(
          child: MaterialApp(home: Scaffold(body: SceneThumbnail(scene: scene))),
        ));

    await pump(const Scene(id: '1', title: 'A', duration: 100));
    expect(find.byType(LinearProgressIndicator), findsNothing);

    await pump(const Scene(id: '2', title: 'B', duration: 100, resumeTime: 25));
    final bar = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
    expect(bar.value, 0.25);
  });
}
