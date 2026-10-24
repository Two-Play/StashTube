import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/marker.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/features/library/galleries_tab.dart';
import 'package:stash_app_mobile/features/library/markers_tab.dart';

import '../../helpers.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget tile) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [...testServer, sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: SizedBox(width: 220, height: 260, child: tile)),
          ),
        ),
      ),
    );
  }

  testWidgets('a marker tile is read as one button', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const MarkerTile(
        marker: Marker(
          id: '1',
          title: 'Intro',
          seconds: 65,
          tag: Tag(id: '2', name: 'Opening'),
          scene: Scene(id: '3', title: 'My scene'),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Intro, My scene, Marker at 1 minute 5 seconds, Opening'), findsOneWidget);
    expect(find.bySemanticsLabel('1:05'), findsNothing);
    expect(find.bySemanticsLabel('#Opening'), findsNothing);
    handle.dispose();
  });

  testWidgets('a gallery tile is read as one button', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const GalleryTile(
        gallery: Gallery(id: '1', title: 'Trip', imageCount: 12),
      ),
    );
    expect(find.bySemanticsLabel('Trip, 12 images, Unknown studio'), findsOneWidget);
    expect(find.bySemanticsLabel('12'), findsNothing);
    handle.dispose();
  });
}
