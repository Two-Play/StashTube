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
