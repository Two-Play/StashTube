import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/utils/format.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/stats.dart';

void main() {
  test('ImageItem.fromJson', () {
    final image = ImageItem.fromJson({
      'id': '7',
      'title': null,
      'date': '2024-02-03',
      'paths': {'thumbnail': 'http://s/thumb', 'image': 'http://s/full'},
      'studio': {'id': '1', 'name': 'Studio'},
      'performers': [
        {'id': '2', 'name': 'Alice'},
      ],
    });
    expect(image.title, 'Image');
    expect(image.thumbnailUrl, 'http://s/thumb');
    expect(image.imageUrl, 'http://s/full');
    expect(image.studio?.name, 'Studio');
    expect(image.performers.single.name, 'Alice');
    expect(image.date, DateTime(2024, 2, 3));
  });

  test('ImageQuery equality and random seed', () {
    expect(ImageQuery(), ImageQuery());
    expect(ImageQuery(sort: ImageSort.random, seed: 5).sortField, 'random_5');
    expect(ImageQuery(sort: ImageSort.title).direction, 'ASC');
  });

  test('stats parsing', () {
    final library = LibraryStats.fromJson({
      'scene_count': 12,
      'scenes_size': 1.5e9,
      'scenes_duration': 7200.0,
      'image_count': 3,
    });
    expect(library.sceneCount, 12);
    expect(library.scenesSize, 1.5e9);
    expect(library.galleryCount, 0);

    final activity = ActivityStats.fromJson({'total_play_count': 4, 'total_play_duration': 90.5});
    expect(activity.playCount, 4);
    expect(activity.playDuration, 90.5);
  });

  test('formatBytes', () {
    expect(formatBytes(0), '0 B');
    expect(formatBytes(1536), '1.5 KB');
    expect(formatBytes(1.5 * 1024 * 1024 * 1024), '1.5 GB');
    expect(formatBytes(250 * 1024 * 1024), '250 MB');
  });

  test('formatLongDuration', () {
    expect(formatLongDuration(59), '0m');
    expect(formatLongDuration(3 * 3600 + 5 * 60), '3h 5m');
    expect(formatLongDuration(2 * 86400 + 4 * 3600), '2d 4h');
  });

  test('formatNumber', () {
    expect(formatNumber(0), '0');
    expect(formatNumber(999), '999');
    expect(formatNumber(1234567), '1,234,567');
    expect(formatNumber(-1200), '-1,200');
  });
}
