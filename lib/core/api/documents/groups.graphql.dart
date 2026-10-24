import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'refs.graphql.dart';

class Fragment$GroupFields {
  Fragment$GroupFields({
    required this.id,
    required this.name,
    this.date,
    this.duration,
    this.front_image_path,
    required this.scene_count,
    this.studio,
    this.$__typename = 'Group',
  });

  factory Fragment$GroupFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$date = json['date'];
    final l$duration = json['duration'];
    final l$front_image_path = json['front_image_path'];
    final l$scene_count = json['scene_count'];
    final l$studio = json['studio'];
    final l$$__typename = json['__typename'];
    return Fragment$GroupFields(
      id: (l$id as String),
      name: (l$name as String),
      date: (l$date as String?),
      duration: (l$duration as int?),
      front_image_path: (l$front_image_path as String?),
      scene_count: (l$scene_count as int),
      studio: l$studio == null
          ? null
          : Fragment$StudioRef.fromJson((l$studio as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String? date;

  final int? duration;

  final String? front_image_path;

  final int scene_count;

  final Fragment$StudioRef? studio;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$date = date;
    _resultData['date'] = l$date;
    final l$duration = duration;
    _resultData['duration'] = l$duration;
    final l$front_image_path = front_image_path;
    _resultData['front_image_path'] = l$front_image_path;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$studio = studio;
    _resultData['studio'] = l$studio?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$date = date;
    final l$duration = duration;
    final l$front_image_path = front_image_path;
    final l$scene_count = scene_count;
    final l$studio = studio;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$date,
      l$duration,
      l$front_image_path,
      l$scene_count,
      l$studio,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$GroupFields || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (l$date != lOther$date) {
      return false;
    }
    final l$duration = duration;
    final lOther$duration = other.duration;
    if (l$duration != lOther$duration) {
      return false;
    }
    final l$front_image_path = front_image_path;
    final lOther$front_image_path = other.front_image_path;
    if (l$front_image_path != lOther$front_image_path) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    final l$studio = studio;
    final lOther$studio = other.studio;
    if (l$studio != lOther$studio) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const fragmentDefinitionGroupFields = FragmentDefinitionNode(
  name: NameNode(value: 'GroupFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Group'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'id'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'name'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'date'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'duration'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'front_image_path'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'scene_count'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'studio'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'StudioRef'),
              directives: [],
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentGroupFields = DocumentNode(
  definitions: [fragmentDefinitionGroupFields, fragmentDefinitionStudioRef],
);

extension ClientExtension$Fragment$GroupFields on graphql.GraphQLClient {
  void writeFragment$GroupFields({
    required Fragment$GroupFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'GroupFields',
        document: documentNodeFragmentGroupFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$GroupFields? readFragment$GroupFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'GroupFields',
          document: documentNodeFragmentGroupFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$GroupFields.fromJson(result);
  }
}

class Fragment$SceneGroupRef {
  Fragment$SceneGroupRef({
    required this.group,
    this.scene_index,
    this.$__typename = 'SceneGroup',
  });

  factory Fragment$SceneGroupRef.fromJson(Map<String, dynamic> json) {
    final l$group = json['group'];
    final l$scene_index = json['scene_index'];
    final l$$__typename = json['__typename'];
    return Fragment$SceneGroupRef(
      group: Fragment$SceneGroupRef$group.fromJson(
        (l$group as Map<String, dynamic>),
      ),
      scene_index: (l$scene_index as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$SceneGroupRef$group group;

  final int? scene_index;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$group = group;
    _resultData['group'] = l$group.toJson();
    final l$scene_index = scene_index;
    _resultData['scene_index'] = l$scene_index;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$group = group;
    final l$scene_index = scene_index;
    final l$$__typename = $__typename;
    return Object.hashAll([l$group, l$scene_index, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SceneGroupRef || runtimeType != other.runtimeType) {
      return false;
    }
    final l$group = group;
    final lOther$group = other.group;
    if (l$group != lOther$group) {
      return false;
    }
    final l$scene_index = scene_index;
    final lOther$scene_index = other.scene_index;
    if (l$scene_index != lOther$scene_index) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const fragmentDefinitionSceneGroupRef = FragmentDefinitionNode(
  name: NameNode(value: 'SceneGroupRef'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SceneGroup'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'group'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'scene_index'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentSceneGroupRef = DocumentNode(
  definitions: [fragmentDefinitionSceneGroupRef],
);

extension ClientExtension$Fragment$SceneGroupRef on graphql.GraphQLClient {
  void writeFragment$SceneGroupRef({
    required Fragment$SceneGroupRef data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'SceneGroupRef',
        document: documentNodeFragmentSceneGroupRef,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$SceneGroupRef? readFragment$SceneGroupRef({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'SceneGroupRef',
          document: documentNodeFragmentSceneGroupRef,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$SceneGroupRef.fromJson(result);
  }
}

class Fragment$SceneGroupRef$group {
  Fragment$SceneGroupRef$group({required this.id, this.$__typename = 'Group'});

  factory Fragment$SceneGroupRef$group.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Fragment$SceneGroupRef$group(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SceneGroupRef$group ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Variables$Query$FindGroups {
  factory Variables$Query$FindGroups({Input$FindFilterType? filter}) =>
      Variables$Query$FindGroups._({if (filter != null) r'filter': filter});

  Variables$Query$FindGroups._(this._$data);

  factory Variables$Query$FindGroups.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$FindFilterType.fromJson((l$filter as Map<String, dynamic>));
    }
    return Variables$Query$FindGroups._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$FindFilterType? get filter =>
      (_$data['filter'] as Input$FindFilterType?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$FindGroups ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$filter = filter;
    final lOther$filter = other.filter;
    if (_$data.containsKey('filter') != other._$data.containsKey('filter')) {
      return false;
    }
    if (l$filter != lOther$filter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$filter = filter;
    return Object.hashAll([_$data.containsKey('filter') ? l$filter : const {}]);
  }
}

class Query$FindGroups {
  Query$FindGroups({required this.findGroups, this.$__typename = 'Query'});

  factory Query$FindGroups.fromJson(Map<String, dynamic> json) {
    final l$findGroups = json['findGroups'];
    final l$$__typename = json['__typename'];
    return Query$FindGroups(
      findGroups: Query$FindGroups$findGroups.fromJson(
        (l$findGroups as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindGroups$findGroups findGroups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findGroups = findGroups;
    _resultData['findGroups'] = l$findGroups.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findGroups = findGroups;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findGroups, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindGroups || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findGroups = findGroups;
    final lOther$findGroups = other.findGroups;
    if (l$findGroups != lOther$findGroups) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeQueryFindGroups = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindGroups'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'FindFilterType'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'findGroups'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: VariableNode(name: NameNode(value: 'filter')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'count'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'groups'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'GroupFields'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionGroupFields,
    fragmentDefinitionStudioRef,
  ],
);
Query$FindGroups _parserFn$Query$FindGroups(Map<String, dynamic> data) =>
    Query$FindGroups.fromJson(data);
typedef OnQueryComplete$Query$FindGroups = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindGroups?,
);

class Options$Query$FindGroups extends graphql.QueryOptions<Query$FindGroups> {
  Options$Query$FindGroups({
    String? operationName,
    Variables$Query$FindGroups? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGroups? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindGroups? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindGroups',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null ? null : _parserFn$Query$FindGroups(data),
               ),
         onError: onError,
         document: documentNodeQueryFindGroups,
         parserFn: _parserFn$Query$FindGroups,
       );

  final OnQueryComplete$Query$FindGroups? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindGroups
    extends graphql.WatchQueryOptions<Query$FindGroups> {
  WatchOptions$Query$FindGroups({
    String? operationName,
    Variables$Query$FindGroups? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGroups? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindGroups',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindGroups,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindGroups,
       );
}

class FetchMoreOptions$Query$FindGroups extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindGroups({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindGroups? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindGroups,
       );
}

extension ClientExtension$Query$FindGroups on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindGroups>> query$FindGroups([
    Options$Query$FindGroups? options,
  ]) async => await this.query(options ?? Options$Query$FindGroups());

  graphql.ObservableQuery<Query$FindGroups> watchQuery$FindGroups([
    WatchOptions$Query$FindGroups? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindGroups());

  void writeQuery$FindGroups({
    required Query$FindGroups data,
    Variables$Query$FindGroups? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindGroups),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindGroups? readQuery$FindGroups({
    Variables$Query$FindGroups? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindGroups),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindGroups.fromJson(result);
  }
}

class Query$FindGroups$findGroups {
  Query$FindGroups$findGroups({
    required this.count,
    required this.groups,
    this.$__typename = 'FindGroupsResultType',
  });

  factory Query$FindGroups$findGroups.fromJson(Map<String, dynamic> json) {
    final l$count = json['count'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Query$FindGroups$findGroups(
      count: (l$count as int),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$GroupFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final List<Fragment$GroupFields> groups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$groups = groups;
    _resultData['groups'] = l$groups.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$groups = groups;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$count,
      Object.hashAll(l$groups.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindGroups$findGroups ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (l$groups.length != lOther$groups.length) {
      return false;
    }
    for (int i = 0; i < l$groups.length; i++) {
      final l$groups$entry = l$groups[i];
      final lOther$groups$entry = lOther$groups[i];
      if (l$groups$entry != lOther$groups$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Variables$Query$FindGroup {
  factory Variables$Query$FindGroup({required String id}) =>
      Variables$Query$FindGroup._({r'id': id});

  Variables$Query$FindGroup._(this._$data);

  factory Variables$Query$FindGroup.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$FindGroup._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$FindGroup ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

class Query$FindGroup {
  Query$FindGroup({this.findGroup, this.$__typename = 'Query'});

  factory Query$FindGroup.fromJson(Map<String, dynamic> json) {
    final l$findGroup = json['findGroup'];
    final l$$__typename = json['__typename'];
    return Query$FindGroup(
      findGroup: l$findGroup == null
          ? null
          : Query$FindGroup$findGroup.fromJson(
              (l$findGroup as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindGroup$findGroup? findGroup;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findGroup = findGroup;
    _resultData['findGroup'] = l$findGroup?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findGroup = findGroup;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findGroup, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindGroup || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findGroup = findGroup;
    final lOther$findGroup = other.findGroup;
    if (l$findGroup != lOther$findGroup) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeQueryFindGroup = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindGroup'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'findGroup'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'GroupFields'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'synopsis'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionGroupFields,
    fragmentDefinitionStudioRef,
  ],
);
Query$FindGroup _parserFn$Query$FindGroup(Map<String, dynamic> data) =>
    Query$FindGroup.fromJson(data);
typedef OnQueryComplete$Query$FindGroup = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindGroup?,
);

class Options$Query$FindGroup extends graphql.QueryOptions<Query$FindGroup> {
  Options$Query$FindGroup({
    String? operationName,
    required Variables$Query$FindGroup variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGroup? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindGroup? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindGroup',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null ? null : _parserFn$Query$FindGroup(data),
               ),
         onError: onError,
         document: documentNodeQueryFindGroup,
         parserFn: _parserFn$Query$FindGroup,
       );

  final OnQueryComplete$Query$FindGroup? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindGroup
    extends graphql.WatchQueryOptions<Query$FindGroup> {
  WatchOptions$Query$FindGroup({
    String? operationName,
    required Variables$Query$FindGroup variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGroup? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindGroup',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindGroup,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindGroup,
       );
}

class FetchMoreOptions$Query$FindGroup extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindGroup({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$FindGroup variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryFindGroup,
       );
}

extension ClientExtension$Query$FindGroup on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindGroup>> query$FindGroup(
    Options$Query$FindGroup options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$FindGroup> watchQuery$FindGroup(
    WatchOptions$Query$FindGroup options,
  ) => this.watchQuery(options);

  void writeQuery$FindGroup({
    required Query$FindGroup data,
    required Variables$Query$FindGroup variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindGroup),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindGroup? readQuery$FindGroup({
    required Variables$Query$FindGroup variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindGroup),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindGroup.fromJson(result);
  }
}

class Query$FindGroup$findGroup implements Fragment$GroupFields {
  Query$FindGroup$findGroup({
    required this.id,
    required this.name,
    this.date,
    this.duration,
    this.front_image_path,
    required this.scene_count,
    this.studio,
    this.$__typename = 'Group',
    this.synopsis,
  });

  factory Query$FindGroup$findGroup.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$date = json['date'];
    final l$duration = json['duration'];
    final l$front_image_path = json['front_image_path'];
    final l$scene_count = json['scene_count'];
    final l$studio = json['studio'];
    final l$$__typename = json['__typename'];
    final l$synopsis = json['synopsis'];
    return Query$FindGroup$findGroup(
      id: (l$id as String),
      name: (l$name as String),
      date: (l$date as String?),
      duration: (l$duration as int?),
      front_image_path: (l$front_image_path as String?),
      scene_count: (l$scene_count as int),
      studio: l$studio == null
          ? null
          : Fragment$StudioRef.fromJson((l$studio as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
      synopsis: (l$synopsis as String?),
    );
  }

  final String id;

  final String name;

  final String? date;

  final int? duration;

  final String? front_image_path;

  final int scene_count;

  final Fragment$StudioRef? studio;

  final String $__typename;

  final String? synopsis;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$date = date;
    _resultData['date'] = l$date;
    final l$duration = duration;
    _resultData['duration'] = l$duration;
    final l$front_image_path = front_image_path;
    _resultData['front_image_path'] = l$front_image_path;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$studio = studio;
    _resultData['studio'] = l$studio?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$synopsis = synopsis;
    _resultData['synopsis'] = l$synopsis;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$date = date;
    final l$duration = duration;
    final l$front_image_path = front_image_path;
    final l$scene_count = scene_count;
    final l$studio = studio;
    final l$$__typename = $__typename;
    final l$synopsis = synopsis;
    return Object.hashAll([
      l$id,
      l$name,
      l$date,
      l$duration,
      l$front_image_path,
      l$scene_count,
      l$studio,
      l$$__typename,
      l$synopsis,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindGroup$findGroup ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (l$date != lOther$date) {
      return false;
    }
    final l$duration = duration;
    final lOther$duration = other.duration;
    if (l$duration != lOther$duration) {
      return false;
    }
    final l$front_image_path = front_image_path;
    final lOther$front_image_path = other.front_image_path;
    if (l$front_image_path != lOther$front_image_path) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    final l$studio = studio;
    final lOther$studio = other.studio;
    if (l$studio != lOther$studio) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$synopsis = synopsis;
    final lOther$synopsis = other.synopsis;
    if (l$synopsis != lOther$synopsis) {
      return false;
    }
    return true;
  }
}

class Variables$Query$SceneGroups {
  factory Variables$Query$SceneGroups({required String id}) =>
      Variables$Query$SceneGroups._({r'id': id});

  Variables$Query$SceneGroups._(this._$data);

  factory Variables$Query$SceneGroups.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$SceneGroups._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SceneGroups ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

class Query$SceneGroups {
  Query$SceneGroups({this.findScene, this.$__typename = 'Query'});

  factory Query$SceneGroups.fromJson(Map<String, dynamic> json) {
    final l$findScene = json['findScene'];
    final l$$__typename = json['__typename'];
    return Query$SceneGroups(
      findScene: l$findScene == null
          ? null
          : Query$SceneGroups$findScene.fromJson(
              (l$findScene as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$SceneGroups$findScene? findScene;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findScene = findScene;
    _resultData['findScene'] = l$findScene?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findScene = findScene;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findScene, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SceneGroups || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findScene = findScene;
    final lOther$findScene = other.findScene;
    if (l$findScene != lOther$findScene) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeQuerySceneGroups = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SceneGroups'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'findScene'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'groups'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'SceneGroupRef'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionSceneGroupRef,
  ],
);
Query$SceneGroups _parserFn$Query$SceneGroups(Map<String, dynamic> data) =>
    Query$SceneGroups.fromJson(data);
typedef OnQueryComplete$Query$SceneGroups = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$SceneGroups?,
);

class Options$Query$SceneGroups
    extends graphql.QueryOptions<Query$SceneGroups> {
  Options$Query$SceneGroups({
    String? operationName,
    required Variables$Query$SceneGroups variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneGroups? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$SceneGroups? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneGroups',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null ? null : _parserFn$Query$SceneGroups(data),
               ),
         onError: onError,
         document: documentNodeQuerySceneGroups,
         parserFn: _parserFn$Query$SceneGroups,
       );

  final OnQueryComplete$Query$SceneGroups? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$SceneGroups
    extends graphql.WatchQueryOptions<Query$SceneGroups> {
  WatchOptions$Query$SceneGroups({
    String? operationName,
    required Variables$Query$SceneGroups variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneGroups? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneGroups',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerySceneGroups,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$SceneGroups,
       );
}

class FetchMoreOptions$Query$SceneGroups extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$SceneGroups({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$SceneGroups variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySceneGroups,
       );
}

extension ClientExtension$Query$SceneGroups on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$SceneGroups>> query$SceneGroups(
    Options$Query$SceneGroups options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$SceneGroups> watchQuery$SceneGroups(
    WatchOptions$Query$SceneGroups options,
  ) => this.watchQuery(options);

  void writeQuery$SceneGroups({
    required Query$SceneGroups data,
    required Variables$Query$SceneGroups variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySceneGroups),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$SceneGroups? readQuery$SceneGroups({
    required Variables$Query$SceneGroups variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySceneGroups),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$SceneGroups.fromJson(result);
  }
}

class Query$SceneGroups$findScene {
  Query$SceneGroups$findScene({
    required this.id,
    required this.groups,
    this.$__typename = 'Scene',
  });

  factory Query$SceneGroups$findScene.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Query$SceneGroups$findScene(
      id: (l$id as String),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$SceneGroupRef.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$SceneGroupRef> groups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$groups = groups;
    _resultData['groups'] = l$groups.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$groups = groups;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$groups.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SceneGroups$findScene ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (l$groups.length != lOther$groups.length) {
      return false;
    }
    for (int i = 0; i < l$groups.length; i++) {
      final l$groups$entry = l$groups[i];
      final lOther$groups$entry = lOther$groups[i];
      if (l$groups$entry != lOther$groups$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Variables$Query$LastGroupScene {
  factory Variables$Query$LastGroupScene({required String group_id}) =>
      Variables$Query$LastGroupScene._({r'group_id': group_id});

  Variables$Query$LastGroupScene._(this._$data);

  factory Variables$Query$LastGroupScene.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$group_id = data['group_id'];
    result$data['group_id'] = (l$group_id as String);
    return Variables$Query$LastGroupScene._(result$data);
  }

  Map<String, dynamic> _$data;

  String get group_id => (_$data['group_id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$group_id = group_id;
    result$data['group_id'] = l$group_id;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$LastGroupScene ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$group_id = group_id;
    final lOther$group_id = other.group_id;
    if (l$group_id != lOther$group_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$group_id = group_id;
    return Object.hashAll([l$group_id]);
  }
}

class Query$LastGroupScene {
  Query$LastGroupScene({required this.findScenes, this.$__typename = 'Query'});

  factory Query$LastGroupScene.fromJson(Map<String, dynamic> json) {
    final l$findScenes = json['findScenes'];
    final l$$__typename = json['__typename'];
    return Query$LastGroupScene(
      findScenes: Query$LastGroupScene$findScenes.fromJson(
        (l$findScenes as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$LastGroupScene$findScenes findScenes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findScenes = findScenes;
    _resultData['findScenes'] = l$findScenes.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findScenes = findScenes;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findScenes, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LastGroupScene || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findScenes = findScenes;
    final lOther$findScenes = other.findScenes;
    if (l$findScenes != lOther$findScenes) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeQueryLastGroupScene = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'LastGroupScene'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'group_id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'findScenes'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'scene_filter'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'groups'),
                      value: ObjectValueNode(
                        fields: [
                          ObjectFieldNode(
                            name: NameNode(value: 'value'),
                            value: ListValueNode(
                              values: [
                                VariableNode(name: NameNode(value: 'group_id')),
                              ],
                            ),
                          ),
                          ObjectFieldNode(
                            name: NameNode(value: 'modifier'),
                            value: EnumValueNode(
                              name: NameNode(value: 'INCLUDES'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'sort'),
                      value: StringValueNode(
                        value: 'group_scene_number',
                        isBlock: false,
                      ),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'direction'),
                      value: EnumValueNode(name: NameNode(value: 'DESC')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'per_page'),
                      value: IntValueNode(value: '1'),
                    ),
                  ],
                ),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'scenes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'groups'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'SceneGroupRef'),
                              directives: [],
                            ),
                            FieldNode(
                              name: NameNode(value: '__typename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                          ],
                        ),
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionSceneGroupRef,
  ],
);
Query$LastGroupScene _parserFn$Query$LastGroupScene(
  Map<String, dynamic> data,
) => Query$LastGroupScene.fromJson(data);
typedef OnQueryComplete$Query$LastGroupScene = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$LastGroupScene?,
);

class Options$Query$LastGroupScene
    extends graphql.QueryOptions<Query$LastGroupScene> {
  Options$Query$LastGroupScene({
    String? operationName,
    required Variables$Query$LastGroupScene variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$LastGroupScene? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$LastGroupScene? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'LastGroupScene',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null ? null : _parserFn$Query$LastGroupScene(data),
               ),
         onError: onError,
         document: documentNodeQueryLastGroupScene,
         parserFn: _parserFn$Query$LastGroupScene,
       );

  final OnQueryComplete$Query$LastGroupScene? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$LastGroupScene
    extends graphql.WatchQueryOptions<Query$LastGroupScene> {
  WatchOptions$Query$LastGroupScene({
    String? operationName,
    required Variables$Query$LastGroupScene variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$LastGroupScene? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'LastGroupScene',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryLastGroupScene,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$LastGroupScene,
       );
}

class FetchMoreOptions$Query$LastGroupScene extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$LastGroupScene({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$LastGroupScene variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryLastGroupScene,
       );
}

extension ClientExtension$Query$LastGroupScene on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$LastGroupScene>> query$LastGroupScene(
    Options$Query$LastGroupScene options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$LastGroupScene> watchQuery$LastGroupScene(
    WatchOptions$Query$LastGroupScene options,
  ) => this.watchQuery(options);

  void writeQuery$LastGroupScene({
    required Query$LastGroupScene data,
    required Variables$Query$LastGroupScene variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryLastGroupScene),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$LastGroupScene? readQuery$LastGroupScene({
    required Variables$Query$LastGroupScene variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryLastGroupScene),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$LastGroupScene.fromJson(result);
  }
}

class Query$LastGroupScene$findScenes {
  Query$LastGroupScene$findScenes({
    required this.scenes,
    this.$__typename = 'FindScenesResultType',
  });

  factory Query$LastGroupScene$findScenes.fromJson(Map<String, dynamic> json) {
    final l$scenes = json['scenes'];
    final l$$__typename = json['__typename'];
    return Query$LastGroupScene$findScenes(
      scenes: (l$scenes as List<dynamic>)
          .map(
            (e) => Query$LastGroupScene$findScenes$scenes.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$LastGroupScene$findScenes$scenes> scenes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scenes = scenes;
    _resultData['scenes'] = l$scenes.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scenes = scenes;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$scenes.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LastGroupScene$findScenes ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scenes = scenes;
    final lOther$scenes = other.scenes;
    if (l$scenes.length != lOther$scenes.length) {
      return false;
    }
    for (int i = 0; i < l$scenes.length; i++) {
      final l$scenes$entry = l$scenes[i];
      final lOther$scenes$entry = lOther$scenes[i];
      if (l$scenes$entry != lOther$scenes$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Query$LastGroupScene$findScenes$scenes {
  Query$LastGroupScene$findScenes$scenes({
    required this.id,
    required this.groups,
    this.$__typename = 'Scene',
  });

  factory Query$LastGroupScene$findScenes$scenes.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Query$LastGroupScene$findScenes$scenes(
      id: (l$id as String),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$SceneGroupRef.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$SceneGroupRef> groups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$groups = groups;
    _resultData['groups'] = l$groups.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$groups = groups;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$groups.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$LastGroupScene$findScenes$scenes ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (l$groups.length != lOther$groups.length) {
      return false;
    }
    for (int i = 0; i < l$groups.length; i++) {
      final l$groups$entry = l$groups[i];
      final lOther$groups$entry = lOther$groups[i];
      if (l$groups$entry != lOther$groups$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$SceneSetGroups {
  factory Variables$Mutation$SceneSetGroups({
    required String id,
    List<Input$SceneGroupInput>? groups,
  }) => Variables$Mutation$SceneSetGroups._({
    r'id': id,
    if (groups != null) r'groups': groups,
  });

  Variables$Mutation$SceneSetGroups._(this._$data);

  factory Variables$Mutation$SceneSetGroups.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('groups')) {
      final l$groups = data['groups'];
      result$data['groups'] = (l$groups as List<dynamic>?)
          ?.map(
            (e) => Input$SceneGroupInput.fromJson((e as Map<String, dynamic>)),
          )
          .toList();
    }
    return Variables$Mutation$SceneSetGroups._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  List<Input$SceneGroupInput>? get groups =>
      (_$data['groups'] as List<Input$SceneGroupInput>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('groups')) {
      final l$groups = groups;
      result$data['groups'] = l$groups?.map((e) => e.toJson()).toList();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SceneSetGroups ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (_$data.containsKey('groups') != other._$data.containsKey('groups')) {
      return false;
    }
    if (l$groups != null && lOther$groups != null) {
      if (l$groups.length != lOther$groups.length) {
        return false;
      }
      for (int i = 0; i < l$groups.length; i++) {
        final l$groups$entry = l$groups[i];
        final lOther$groups$entry = lOther$groups[i];
        if (l$groups$entry != lOther$groups$entry) {
          return false;
        }
      }
    } else if (l$groups != lOther$groups) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$groups = groups;
    return Object.hashAll([
      l$id,
      _$data.containsKey('groups')
          ? l$groups == null
                ? null
                : Object.hashAll(l$groups.map((v) => v))
          : const {},
    ]);
  }
}

class Mutation$SceneSetGroups {
  Mutation$SceneSetGroups({this.sceneUpdate, this.$__typename = 'Mutation'});

  factory Mutation$SceneSetGroups.fromJson(Map<String, dynamic> json) {
    final l$sceneUpdate = json['sceneUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneSetGroups(
      sceneUpdate: l$sceneUpdate == null
          ? null
          : Mutation$SceneSetGroups$sceneUpdate.fromJson(
              (l$sceneUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SceneSetGroups$sceneUpdate? sceneUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneUpdate = sceneUpdate;
    _resultData['sceneUpdate'] = l$sceneUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneUpdate = sceneUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneSetGroups || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneUpdate = sceneUpdate;
    final lOther$sceneUpdate = other.sceneUpdate;
    if (l$sceneUpdate != lOther$sceneUpdate) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeMutationSceneSetGroups = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneSetGroups'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'groups')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'SceneGroupInput'),
              isNonNull: true,
            ),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sceneUpdate'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'id'),
                      value: VariableNode(name: NameNode(value: 'id')),
                    ),
                    ObjectFieldNode(
                      name: NameNode(value: 'groups'),
                      value: VariableNode(name: NameNode(value: 'groups')),
                    ),
                  ],
                ),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'groups'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'SceneGroupRef'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionSceneGroupRef,
  ],
);
Mutation$SceneSetGroups _parserFn$Mutation$SceneSetGroups(
  Map<String, dynamic> data,
) => Mutation$SceneSetGroups.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneSetGroups = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SceneSetGroups?,
);

class Options$Mutation$SceneSetGroups
    extends graphql.MutationOptions<Mutation$SceneSetGroups> {
  Options$Mutation$SceneSetGroups({
    String? operationName,
    required Variables$Mutation$SceneSetGroups variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSetGroups? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneSetGroups? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneSetGroups>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSetGroups',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$SceneSetGroups(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneSetGroups,
         parserFn: _parserFn$Mutation$SceneSetGroups,
       );

  final OnMutationCompleted$Mutation$SceneSetGroups? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneSetGroups
    extends graphql.WatchQueryOptions<Mutation$SceneSetGroups> {
  WatchOptions$Mutation$SceneSetGroups({
    String? operationName,
    required Variables$Mutation$SceneSetGroups variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSetGroups? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSetGroups',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneSetGroups,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneSetGroups,
       );
}

extension ClientExtension$Mutation$SceneSetGroups on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneSetGroups>> mutate$SceneSetGroups(
    Options$Mutation$SceneSetGroups options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneSetGroups> watchMutation$SceneSetGroups(
    WatchOptions$Mutation$SceneSetGroups options,
  ) => this.watchMutation(options);
}

class Mutation$SceneSetGroups$sceneUpdate {
  Mutation$SceneSetGroups$sceneUpdate({
    required this.id,
    required this.groups,
    this.$__typename = 'Scene',
  });

  factory Mutation$SceneSetGroups$sceneUpdate.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneSetGroups$sceneUpdate(
      id: (l$id as String),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$SceneGroupRef.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$SceneGroupRef> groups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$groups = groups;
    _resultData['groups'] = l$groups.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$groups = groups;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$groups.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneSetGroups$sceneUpdate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (l$groups.length != lOther$groups.length) {
      return false;
    }
    for (int i = 0; i < l$groups.length; i++) {
      final l$groups$entry = l$groups[i];
      final lOther$groups$entry = lOther$groups[i];
      if (l$groups$entry != lOther$groups$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$GroupCreate {
  factory Variables$Mutation$GroupCreate({required String name}) =>
      Variables$Mutation$GroupCreate._({r'name': name});

  Variables$Mutation$GroupCreate._(this._$data);

  factory Variables$Mutation$GroupCreate.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    return Variables$Mutation$GroupCreate._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$GroupCreate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    return Object.hashAll([l$name]);
  }
}

class Mutation$GroupCreate {
  Mutation$GroupCreate({this.groupCreate, this.$__typename = 'Mutation'});

  factory Mutation$GroupCreate.fromJson(Map<String, dynamic> json) {
    final l$groupCreate = json['groupCreate'];
    final l$$__typename = json['__typename'];
    return Mutation$GroupCreate(
      groupCreate: l$groupCreate == null
          ? null
          : Fragment$GroupFields.fromJson(
              (l$groupCreate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$GroupFields? groupCreate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$groupCreate = groupCreate;
    _resultData['groupCreate'] = l$groupCreate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$groupCreate = groupCreate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$groupCreate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$GroupCreate || runtimeType != other.runtimeType) {
      return false;
    }
    final l$groupCreate = groupCreate;
    final lOther$groupCreate = other.groupCreate;
    if (l$groupCreate != lOther$groupCreate) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

const documentNodeMutationGroupCreate = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'GroupCreate'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'name')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'groupCreate'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'name'),
                      value: VariableNode(name: NameNode(value: 'name')),
                    ),
                  ],
                ),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'GroupFields'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionGroupFields,
    fragmentDefinitionStudioRef,
  ],
);
Mutation$GroupCreate _parserFn$Mutation$GroupCreate(
  Map<String, dynamic> data,
) => Mutation$GroupCreate.fromJson(data);
typedef OnMutationCompleted$Mutation$GroupCreate = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$GroupCreate?,
);

class Options$Mutation$GroupCreate
    extends graphql.MutationOptions<Mutation$GroupCreate> {
  Options$Mutation$GroupCreate({
    String? operationName,
    required Variables$Mutation$GroupCreate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$GroupCreate? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$GroupCreate? onCompleted,
    graphql.OnMutationUpdate<Mutation$GroupCreate>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'GroupCreate',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$GroupCreate(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationGroupCreate,
         parserFn: _parserFn$Mutation$GroupCreate,
       );

  final OnMutationCompleted$Mutation$GroupCreate? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$GroupCreate
    extends graphql.WatchQueryOptions<Mutation$GroupCreate> {
  WatchOptions$Mutation$GroupCreate({
    String? operationName,
    required Variables$Mutation$GroupCreate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$GroupCreate? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'GroupCreate',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationGroupCreate,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$GroupCreate,
       );
}

extension ClientExtension$Mutation$GroupCreate on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$GroupCreate>> mutate$GroupCreate(
    Options$Mutation$GroupCreate options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$GroupCreate> watchMutation$GroupCreate(
    WatchOptions$Mutation$GroupCreate options,
  ) => this.watchMutation(options);
}
