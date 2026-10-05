import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/studio.dart';

void main() {
  test('Studio.fromJson reads parent and sub-studios', () {
    final studio = Studio.fromJson({
      'id': '2',
      'name': 'Label',
      'scene_count': 10,
      'parent_studio': {'id': '1', 'name': 'Network', 'image_path': 'http://s/1'},
      'child_studios': [
        {'id': '3', 'name': 'Sub A', 'scene_count': 4},
        {'id': '4', 'name': 'Sub B', 'scene_count': 6},
      ],
    });
    expect(studio.parent?.name, 'Network');
    expect(studio.parent?.imageUrl, 'http://s/1');
    expect(studio.children.map((c) => c.name), ['Sub A', 'Sub B']);
    expect(studio.children.last.sceneCount, 6);

    final plain = Studio.fromJson({'id': '9', 'name': 'Indie', 'parent_studio': null});
    expect(plain.parent, isNull);
    expect(plain.children, isEmpty);
  });

  test('scene filter includes sub-studios at any depth when asked', () {
    Map<String, dynamic> studios(SceneQuery q) => q.toSceneFilter()!['studios'] as Map<String, dynamic>;
    expect(studios(SceneQuery(studioId: '1'))['depth'], 0);
    expect(studios(SceneQuery(studioId: '1', includeSubStudios: true))['depth'], -1);
    expect(SceneQuery(studioId: '1'), isNot(SceneQuery(studioId: '1', includeSubStudios: true)));
  });

  test('changing a filter keeps the chosen sort', () {
    final q = SceneQuery(studioId: '1', sort: SceneSort.topRated);
    final toggled = SceneQuery(studioId: '1', includeSubStudios: true).copyWith(sort: q.sort);
    expect(toggled.sort, SceneSort.topRated);
    expect(toggled.includeSubStudios, isTrue);
  });
}
