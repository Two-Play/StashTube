import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/saved_filter.dart';
import '../fixtures.dart';

void main() {
  test('converts the web UI criterion format to SceneFilterType', () {
    final result = convertSavedSceneFilter({
      'tags': {
        'modifier': 'INCLUDES_ALL',
        'value': {
          'items': [
            {'id': '1', 'label': 'Outdoor'},
            {'id': '2', 'label': 'Beach'},
          ],
          'excluded': [
            {'id': '3', 'label': 'Rain'},
          ],
          'depth': 0,
        },
      },
      'rating100': {
        'modifier': 'GREATER_THAN',
        'value': {'value': 60, 'value2': null},
      },
      'duration': {
        'modifier': 'BETWEEN',
        'value': {'value': 600, 'value2': 1800},
      },
      'performers': {
        'modifier': 'INCLUDES',
        'value': [
          {'id': '9', 'label': 'Alice'},
        ],
      },
      'organized': {'modifier': 'EQUALS', 'value': 'true'},
      'resolution': {'modifier': 'GREATER_THAN', 'value': '1080p'},
      'title': {'modifier': 'INCLUDES', 'value': 'sunset'},
      'studios': {'modifier': 'IS_NULL', 'value': null},
    });

    expect(result.unsupported, isEmpty);
    expect(result.filter, {
      'tags': {
        'value': ['1', '2'],
        'excludes': ['3'],
        'modifier': 'INCLUDES_ALL',
        'depth': 0,
      },
      'rating100': {'value': 60, 'modifier': 'GREATER_THAN'},
      'duration': {'value': 600, 'value2': 1800, 'modifier': 'BETWEEN'},
      'performers': {
        'value': ['9'],
        'modifier': 'INCLUDES',
      },
      'organized': true,
      'resolution': {'value': 'FULL_HD', 'modifier': 'GREATER_THAN'},
      'title': {'value': 'sunset', 'modifier': 'INCLUDES'},
      'studios': {'value': <String>[], 'modifier': 'IS_NULL'},
    });
  });

  test('reports criteria it cannot convert instead of sending them', () {
    final result = convertSavedSceneFilter({
      'phash_distance': {'modifier': 'EQUALS', 'value': {'unknown': true}},
      'broken': 'not a criterion',
    });
    expect(result.filter, isEmpty);
    expect(result.unsupported, ['phash_distance', 'broken']);
  });

  test('IS_NULL gets a value of the criterion\'s type; criteria the schema rejects are reported', () {
    final result = convertSavedSceneFilter({
      'rating100': {'modifier': 'IS_NULL', 'value': null},
      'title': {'modifier': 'NOT_NULL', 'value': null},
      'organized': {'modifier': 'EQUALS', 'value': 'maybe'},
      'not_in_schema': {'modifier': 'EQUALS', 'value': 'x'},
    });
    expect(result.filter, {
      'rating100': {'value': 0, 'modifier': 'IS_NULL'},
      'title': {'value': '', 'modifier': 'NOT_NULL'},
    });
    expect(result.unsupported, ['organized', 'not_in_schema']);
  });

  test('SavedFilter reads name, search and sort', () {
    final filter = savedFilterFrom({
      'id': '4',
      'name': 'Best of',
      'find_filter': {'q': 'beach', 'sort': 'rating', 'direction': 'DESC'},
      'object_filter': {
        'rating100': {
          'modifier': 'GREATER_THAN',
          'value': {'value': 80},
        },
      },
    });
    expect(filter.name, 'Best of');
    expect(filter.search, 'beach');
    expect(filter.sort, 'rating');
    expect(filter.direction, 'DESC');
    expect(filter.sceneFilter.keys, ['rating100']);
  });
}
