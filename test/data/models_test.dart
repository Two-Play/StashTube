import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/models/scene.dart';

void main() {
  group('Scene.fromJson', () {
    test('parses a full findScenes entry', () {
      final scene = Scene.fromJson({
        'id': '42',
        'title': 'Sunset',
        'details': 'A long description',
        'date': '2023-05-01',
        'created_at': '2024-01-02T10:00:00Z',
        'rating100': 80,
        'play_count': 3,
        'o_counter': 1,
        'resume_time': 120.5,
        'files': [
          {'basename': 'sunset.mp4', 'duration': 754.2, 'width': 1920, 'height': 1080},
        ],
        'paths': {'screenshot': 'http://s/screenshot', 'preview': 'http://s/preview', 'stream': 'http://s/stream'},
        'studio': {'id': '7', 'name': 'Studio A', 'image_path': 'http://s/studio'},
        'performers': [
          {'id': '1', 'name': 'Alice', 'image_path': 'http://s/p1', 'country': 'DE', 'favorite': true},
        ],
        'tags': [
          {'id': '3', 'name': 'Outdoor'},
        ],
      });

      expect(scene.id, '42');
      expect(scene.title, 'Sunset');
      expect(scene.date, DateTime(2023, 5, 1));
      expect(scene.duration, 754.2);
      expect(scene.height, 1080);
      expect(scene.streamUrl, 'http://s/stream');
      expect(scene.studio?.name, 'Studio A');
      expect(scene.performers.single.favorite, isTrue);
      expect(scene.tags.single.name, 'Outdoor');
      expect(scene.playCount, 3);
      expect(scene.resumeTime, 120.5);
    });

    test('tolerates missing and null fields', () {
      final scene = Scene.fromJson({
        'id': '1',
        'title': null,
        'files': [
          {'basename': 'clip.mkv', 'duration': null},
        ],
        'paths': null,
        'studio': null,
        'performers': null,
      });

      expect(scene.title, 'clip.mkv', reason: 'falls back to the file name');
      expect(scene.duration, 0);
      expect(scene.studio, isNull);
      expect(scene.performers, isEmpty);
      expect(scene.streamUrl, isNull);
      expect(scene.displayDate, isNull);
    });

    test('falls back to a placeholder title without files', () {
      expect(Scene.fromJson({'id': '1', 'title': ''}).title, 'Untitled scene');
    });
  });

  group('Performer', () {
    test('parses scene_count and computes age', () {
      final p = Performer.fromJson({'id': '5', 'name': 'Bob', 'birthdate': '1990-06-15', 'scene_count': 12});
      expect(p.sceneCount, 12);
      expect(p.ageAt(DateTime(2024, 6, 14)), 33);
      expect(p.ageAt(DateTime(2024, 6, 15)), 34);
    });
  });

  group('SceneQuery', () {
    test('equal queries are equal (used as provider family keys)', () {
      expect(SceneQuery(performerId: '1'), SceneQuery(performerId: '1'));
      expect(SceneQuery(performerId: '1').hashCode, SceneQuery(performerId: '1').hashCode);
    });

    test('random sort uses a seed so pages are stable', () {
      final q = SceneQuery(sort: SceneSort.random, seed: 99);
      expect(q.sortField, 'random_99');
      expect(SceneQuery(sort: SceneSort.random).seed, isNot(0));
    });

    test('choosing a sort again reshuffles', () {
      final q = SceneQuery(sort: SceneSort.random, seed: 1);
      expect(q.copyWith(sort: SceneSort.random).seed, isNot(1));
    });

    test('builds filters for home shelves', () {
      expect(SceneQuery(inProgressOnly: true).toSceneFilter(), {
        'resume_time': {'value': 0, 'modifier': 'GREATER_THAN'},
      });
      expect(SceneQuery(favoritePerformersOnly: true).toSceneFilter(), {'performer_favorite': true});
      expect(SceneQuery(inProgressOnly: true), isNot(SceneQuery()));
    });

    test('builds scene filters for channels', () {
      expect(SceneQuery().toSceneFilter(), isNull);
      expect(SceneQuery(studioId: '7').toSceneFilter(), {
        'studios': {
          'value': ['7'],
          'modifier': 'INCLUDES',
          'depth': 0,
        },
      });
    });
  });
}
