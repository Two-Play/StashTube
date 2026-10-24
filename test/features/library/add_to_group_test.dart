import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/data/models/group.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/add_to_group.dart';

import '../../fixtures.dart';
import '../../helpers.dart';

const _scene = Scene(id: 's1', title: 'Beach day', streamUrl: 'http://s/1');

class _Repo implements StashRepository {
  _Repo(this.groups, this.member);

  final List<Group> groups;
  final Set<String> member;
  final calls = <String>[];
  bool fail = false;

  @override
  Future<PageResult<Group>> findGroups(GroupQuery query, {int page = 1, int perPage = 24}) async {
    final term = query.search?.toLowerCase();
    final items = [
      for (final g in groups)
        if (term == null || g.name.toLowerCase().contains(term)) g,
    ];
    return PageResult(items: items, totalCount: items.length);
  }

  @override
  Future<List<SceneGroupEntry>> sceneGroups(String sceneId) async => [
    for (final id in member) (groupId: id, sceneIndex: 1),
  ];

  @override
  Future<void> addSceneToGroup(String sceneId, String groupId) async {
    calls.add('add $sceneId $groupId');
    if (fail) throw const StashApiException('boom', kind: StashErrorKind.notSaved);
    member.add(groupId);
  }

  @override
  Future<void> removeSceneFromGroup(String sceneId, String groupId) async {
    calls.add('remove $sceneId $groupId');
    member.remove(groupId);
  }

  @override
  Future<Group> createGroup(String name) async {
    calls.add('create $name');
    final group = Group(id: 'n${groups.length}', name: name);
    groups.add(group);
    return group;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// The posters shimmer while loading: pump a while instead of settling.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _open(WidgetTester tester, _Repo repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [...testServer, stashRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showAddToGroupSheet(context, _scene),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await _settle(tester);
}

bool? _checked(WidgetTester tester, String groupId) =>
    tester.widget<CheckboxListTile>(find.byKey(ValueKey('group-$groupId'))).value;

void main() {
  group('sheet', () {
    testWidgets('shows which groups the scene is in and adds or removes it', (tester) async {
      final repo = _Repo([const Group(id: '1', name: 'Alpha', sceneCount: 3), const Group(id: '2', name: 'Beta')], {
        '1',
      });
      await _open(tester, repo);

      expect(find.text('Add to group'), findsOneWidget);
      expect(_checked(tester, '1'), isTrue);
      expect(_checked(tester, '2'), isFalse);
      // Few groups: no search field.
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.text('Beta'));
      await _settle(tester);
      expect(repo.calls, ['add s1 2']);
      expect(_checked(tester, '2'), isTrue);
      expect(find.text('Added to Beta'), findsOneWidget);
      expect(find.text('1 scene'), findsOneWidget);

      await tester.tap(find.text('Alpha'));
      await _settle(tester);
      expect(repo.calls.last, 'remove s1 1');
      expect(_checked(tester, '1'), isFalse);
      expect(find.text('Removed from Alpha'), findsOneWidget);
      expect(find.text('2 scenes'), findsOneWidget);
    });

    testWidgets('a failed change is undone and reported', (tester) async {
      final repo = _Repo([const Group(id: '2', name: 'Beta')], {})..fail = true;
      await _open(tester, repo);

      await tester.tap(find.text('Beta'));
      await _settle(tester);
      expect(repo.calls, ['add s1 2']);
      expect(_checked(tester, '2'), isFalse);
      expect(find.textContaining("Couldn't change the group"), findsOneWidget);
    });

    testWidgets('creates a new group with the scene', (tester) async {
      final repo = _Repo([const Group(id: '1', name: 'Alpha')], {});
      await _open(tester, repo);

      await tester.tap(find.text('New group'));
      await tester.pumpAndSettle();
      final create = find.widgetWithText(FilledButton, 'Create');
      expect(tester.widget<FilledButton>(create).onPressed, isNull);
      await tester.enterText(find.byType(TextField), '  Road trip ');
      await tester.pump();
      await tester.tap(create);
      await _settle(tester);

      expect(repo.calls, ['create Road trip', 'add s1 n1']);
      expect(find.text('Added to Road trip'), findsOneWidget);
      expect(find.text('Road trip'), findsOneWidget);
      expect(_checked(tester, 'n1'), isTrue);
    });

    testWidgets('many groups get a search field', (tester) async {
      final repo = _Repo([for (var i = 0; i < 10; i++) Group(id: '$i', name: 'Group $i')], {});
      await _open(tester, repo);

      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), '7');
      await tester.pump(const Duration(milliseconds: 400));
      await _settle(tester);
      expect(find.text('Group 7'), findsOneWidget);
      expect(find.text('Group 3'), findsNothing);
    });
  });

  group('repository', () {
    late List<Request> sent;

    StashRepository repo(Map<String, Map<String, dynamic>> dataByOperation) {
      sent = [];
      return StashRepository(
        GraphQLClient(
          cache: GraphQLCache(),
          defaultPolicies: DefaultPolicies(query: Policies(fetch: FetchPolicy.networkOnly)),
          link: Link.function((request, [forward]) {
            sent.add(request);
            final name = request.operation.operationName!;
            final root = name == 'SceneSetGroups' || name == 'GroupCreate' ? 'Mutation' : 'Query';
            return Stream.value(Response(data: {'__typename': root, ...?dataByOperation[name]}, response: const {}));
          }),
        ),
      );
    }

    Map<String, dynamic> entry(String groupId, int? index) => {
      '__typename': 'SceneGroup',
      'group': {'__typename': 'Group', 'id': groupId},
      'scene_index': index,
    };

    Map<String, dynamic> variables(String operation) =>
        jsonDecode(jsonEncode(sent.lastWhere((r) => r.operation.operationName == operation).variables))
            as Map<String, dynamic>;

    test('adding appends after the group\'s last scene and keeps the other groups', () async {
      final r = repo({
        'SceneGroups': {
          'findScene': {
            '__typename': 'Scene',
            'id': 's1',
            'groups': [entry('7', 2), entry('8', null)],
          },
        },
        'LastGroupScene': {
          'findScenes': {
            '__typename': 'FindScenesResultType',
            'scenes': [
              {
                '__typename': 'Scene',
                'id': 's9',
                'groups': [entry('7', 1), entry('9', 4)],
              },
            ],
          },
        },
        'SceneSetGroups': {
          'sceneUpdate': {'__typename': 'Scene', 'id': 's1', 'groups': <Object>[]},
        },
      });

      await r.addSceneToGroup('s1', '9');
      expect(variables('LastGroupScene'), {'group_id': '9'});
      expect(variables('SceneSetGroups'), {
        'id': 's1',
        'groups': [
          {'group_id': '7', 'scene_index': 2},
          {'group_id': '8'},
          {'group_id': '9', 'scene_index': 5},
        ],
      });

      await r.removeSceneFromGroup('s1', '7');
      expect(variables('SceneSetGroups'), {
        'id': 's1',
        'groups': [
          {'group_id': '8'},
        ],
      });

      // Already in it: nothing to save.
      final count = sent.length;
      await r.addSceneToGroup('s1', '7');
      expect(sent.skip(count).map((r) => r.operation.operationName), ['SceneGroups']);
    });

    test('an empty group starts at 1; new groups are created by name', () async {
      final r = repo({
        'LastGroupScene': {
          'findScenes': {'__typename': 'FindScenesResultType', 'scenes': <Object>[]},
        },
        'GroupCreate': {
          'groupCreate': groupJson({'id': '12', 'name': 'Road trip'}),
        },
      });
      expect(await r.nextGroupIndex('3'), 1);
      final created = await r.createGroup('Road trip');
      expect([created.id, created.name], ['12', 'Road trip']);
      expect(variables('GroupCreate'), {'name': 'Road trip'});
    });
  });
}
