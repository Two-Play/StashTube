import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';

void main() {
  late List<Map<String, dynamic>> sent;

  StashRepository repo(Map<String, dynamic> data) {
    sent = [];
    return StashRepository(GraphQLClient(
      cache: GraphQLCache(),
      link: Link.function((request, [forward]) {
        sent.add(request.variables);
        return Stream.value(Response(data: data, response: const {}));
      }),
    ));
  }

  // A real server includes __typename, which the client's cache requires.
  const tagsData = {
    '__typename': 'Query',
    'findTags': {
      '__typename': 'FindTagsResultType',
      'count': 2,
      'tags': [
        {'__typename': 'Tag', 'id': '1', 'name': 'Outdoor', 'image_path': null, 'scene_count': 40},
        {'__typename': 'Tag', 'id': '2', 'name': 'Beach', 'image_path': null, 'scene_count': 7},
      ],
    },
  };

  test('discover lists only tags with scenes, most used first', () async {
    final result = await repo(tagsData).findTags(const TagQuery());
    expect(result.items.map((t) => t.name), ['Outdoor', 'Beach']);
    expect(sent.single['filter'], containsPair('sort', 'scenes_count'));
    expect(sent.single['filter'], containsPair('direction', 'DESC'));
    expect(sent.single['tag_filter'], {
      'scene_count': {'value': 0, 'modifier': 'GREATER_THAN'},
    });
  });

  test('searching tags includes unused ones', () async {
    await repo(tagsData).findTags(const TagQuery(search: 'out', sort: TagSort.name));
    expect(sent.single['tag_filter'], isNull);
    expect(sent.single['filter'], containsPair('q', 'out'));
    expect(sent.single['filter'], containsPair('direction', 'ASC'));
  });
}
