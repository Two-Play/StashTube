import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/tag.dart';

import '../fixtures.dart';

void main() {
  group('SceneQuery.tagId (the tag page)', () {
    test('requires the tag', () {
      expect(SceneQuery(tagId: 't1').toSceneFilter(), {
        'tags': {'value': ['t1'], 'modifier': 'INCLUDES_ALL', 'depth': 0},
      });
    });

    test('adds it to the filter sheet\'s tags, which then can\'t remove it', () {
      final query = SceneQuery(tagId: 't1', filter: const SceneFilter(tags: [Tag(id: 't2', name: 'B')], minStars: 3));
      final criteria = query.toSceneFilter()!;
      expect(criteria['tags'], {'value': ['t2', 't1'], 'modifier': 'INCLUDES_ALL', 'depth': 0});
      expect(criteria['rating100'], isNotNull);
    });

    test('with "any of" tags it goes under AND, so both hold', () {
      final query = SceneQuery(
        tagId: 't1',
        filter: const SceneFilter(tags: [Tag(id: 't2', name: 'B'), Tag(id: 't3', name: 'C')], anyTag: true),
      );
      final criteria = query.toSceneFilter()!;
      expect((criteria['tags'] as Map)['modifier'], 'INCLUDES');
      expect(criteria['AND'], {
        'tags': {'value': ['t1'], 'modifier': 'INCLUDES_ALL', 'depth': 0},
      });
    });

    test('is part of the equality', () {
      expect(SceneQuery(tagId: 't1'), SceneQuery(tagId: 't1'));
      expect(SceneQuery(tagId: 't1') == SceneQuery(tagId: 't2'), isFalse);
      expect(SceneQuery(tagId: 't1').copyWith(sort: SceneSort.newest).tagId, 't1');
    });
  });

  test('a video file among the images is a video (#64)', () {
    expect(imageFrom().isVideo, isFalse);
    final clip = imageFrom({
      'visual_files': [
        {'__typename': 'VideoFile', 'duration': 12.5, 'width': 1920, 'height': 1080},
      ],
    });
    expect(clip.isVideo, isTrue);
    expect(clip.videoDuration, 12.5);
    expect(clip.aspect, 1920 / 1080);
    final still = imageFrom({
      'visual_files': [
        {'__typename': 'ImageFile'},
      ],
    });
    expect(still.isVideo, isFalse);
  });
}
