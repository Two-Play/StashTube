import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/gallery.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/providers.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/galleries_tab.dart';
import 'package:stash_app_mobile/features/library/gallery_page.dart';

import '../helpers.dart';

class _NoImages implements StashRepository {
  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async =>
      const PageResult(items: [], totalCount: 0);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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

  test('ImageQuery combines search, filter and gallery', () {
    final q = ImageQuery(galleryId: '3', filter: const SceneFilter(tags: [Tag(id: '7', name: 'beach')], minStars: 4));
    expect(q.toImageFilter(), {
      'tags': {
        'value': ['7'],
        'modifier': 'INCLUDES_ALL',
        'depth': 0,
      },
      'rating100': {'value': 79, 'modifier': 'GREATER_THAN'},
      'galleries': {
        'value': ['3'],
        'modifier': 'INCLUDES',
      },
    });
    final searched = q.copyWith(search: 'sunset');
    expect(searched.search, 'sunset');
    expect(searched.galleryId, '3');
    expect(searched, isNot(q));
    expect(searched.copyWith(clearSearch: true), q);
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
    expect(find.text('Unknown studio'), findsOneWidget);
  });

  testWidgets('the gallery page says when studio and performers are unknown', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        ...testServer,
        stashRepositoryProvider.overrideWithValue(_NoImages()),
        galleryProvider('1').overrideWith((ref) async => const Gallery(id: '1', title: 'Holiday')),
      ],
      child: const MaterialApp(home: GalleryPage(galleryId: '1')),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Unknown studio'), findsOneWidget);
    expect(find.text('Unknown performer'), findsOneWidget);
  });
}
