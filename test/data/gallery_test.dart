import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/features/library/galleries_tab.dart';

void main() {
  group('Gallery.fromJson', () {
    test('parses fields', () {
      final g = Gallery.fromJson({
        'id': '3',
        'title': 'Holiday',
        'date': '2023-07-01',
        'image_count': 42,
        'paths': {'cover': 'http://s/cover'},
        'studio': {'id': '1', 'name': 'Studio'},
        'performers': [
          {'id': '2', 'name': 'Alice'},
        ],
      });
      expect(g.title, 'Holiday');
      expect(g.imageCount, 42);
      expect(g.coverUrl, 'http://s/cover');
      expect(g.studio?.name, 'Studio');
      expect(g.performers.single.name, 'Alice');
    });

    test('falls back to the zip name, then the folder name', () {
      expect(
        Gallery.fromJson({'id': '1', 'title': null, 'files': [{'basename': 'set.zip'}]}).title,
        'set.zip',
      );
      expect(Gallery.fromJson({'id': '1', 'folder': {'path': '/media/photos/Trip 2024/'}}).title, 'Trip 2024');
      expect(Gallery.fromJson({'id': '1', 'folder': {'path': r'C:\pics\Beach'}}).title, 'Beach');
      expect(Gallery.fromJson({'id': '1'}).title, 'Gallery');
    });
  });

  test('ImageQuery filters by gallery and sorts files ascending', () {
    final q = ImageQuery(sort: ImageSort.path, galleryId: '3');
    expect(q.toImageFilter(), {
      'galleries': {
        'value': ['3'],
        'modifier': 'INCLUDES',
      },
    });
    expect(q.direction, 'ASC');
    expect(ImageQuery().toImageFilter(), isNull);
    expect(q, isNot(ImageQuery(sort: ImageSort.path)));
  });

  testWidgets('GalleryTile shows title, image count and studio', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 280,
            child: GalleryTile(
              gallery: Gallery(id: '1', title: 'Holiday', imageCount: 1234, date: null),
            ),
          ),
        ),
      ),
    ));
    expect(find.text('Holiday'), findsOneWidget);
    expect(find.text('1,234'), findsOneWidget);
  });
}
