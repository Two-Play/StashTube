import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/scene_filter.dart';
import 'package:stash_app_mobile/data/models/tag.dart';
import '../fixtures.dart';

void main() {
  const a = Tag(id: '1', name: 'Outdoor');
  const b = Tag(id: '2', name: 'Beach');

  test('Tag reads image and scene count', () {
    final tag = tagFrom({'id': '5', 'name': 'Sunset', 'image_path': 'http://s/t', 'scene_count': 12});
    expect(tag.imageUrl, 'http://s/t');
    expect(tag.sceneCount, 12);
  });

  test('empty filter adds no criteria', () {
    expect(SceneFilter.none.toCriteria(), isEmpty);
    expect(SceneFilter.none.isEmpty, isTrue);
    expect(SceneQuery().toSceneFilter(), isNull);
  });

  test('maps every option to SceneFilterType', () {
    const filter = SceneFilter(
      tags: [a, b],
      minStars: 4,
      duration: DurationFilter.medium,
      resolution: ResolutionFilter.fullHd,
    );
    expect(filter.activeCount, 4);
    expect(filter.toCriteria(), {
      'tags': {
        'value': ['1', '2'],
        'modifier': 'INCLUDES_ALL',
        'depth': 0,
      },
      'rating100': {'value': 79, 'modifier': 'GREATER_THAN'},
      'duration': {'value': 600, 'value2': 1800, 'modifier': 'BETWEEN'},
      'resolution': {'value': 'STANDARD_HD', 'modifier': 'GREATER_THAN'},
    });
  });

  test('combines with channel filters and a saved filter', () {
    final query = SceneQuery(
      performerId: '9',
      filter: const SceneFilter(tags: [a], savedFilter: {'organized': true}),
    );
    final criteria = query.toSceneFilter()!;
    expect(criteria.keys, containsAll(['performers', 'tags', 'organized']));
  });

  test('value equality (tags compared by id), used for provider keys', () {
    expect(const SceneFilter(tags: [a]), const SceneFilter(tags: [Tag(id: '1', name: '')]));
    expect(const SceneFilter(tags: [a]).hashCode, const SceneFilter(tags: [Tag(id: '1', name: '')]).hashCode);
    expect(const SceneFilter(minStars: 3), isNot(const SceneFilter(minStars: 4)));
    expect(SceneQuery(filter: const SceneFilter(minStars: 3)), SceneQuery(filter: const SceneFilter(minStars: 3)));
  });

  test('copyWith keeps or clears the saved filter', () {
    const saved = SceneFilter(savedFilter: {'organized': true}, minStars: 2);
    expect(saved.copyWith(minStars: 5).savedFilter, isNotNull);
    expect(saved.copyWith(clearSavedFilter: true).savedFilter, isNull);
  });
}
