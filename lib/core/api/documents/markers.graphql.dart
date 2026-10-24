import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Variables$Query$SceneMarkerCount {
  factory Variables$Query$SceneMarkerCount({
    Input$SceneMarkerFilterType? scene_marker_filter,
  }) => Variables$Query$SceneMarkerCount._({
    if (scene_marker_filter != null)
      r'scene_marker_filter': scene_marker_filter,
  });

  Variables$Query$SceneMarkerCount._(this._$data);

  factory Variables$Query$SceneMarkerCount.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('scene_marker_filter')) {
      final l$scene_marker_filter = data['scene_marker_filter'];
      result$data['scene_marker_filter'] = l$scene_marker_filter == null
          ? null
          : Input$SceneMarkerFilterType.fromJson(
              (l$scene_marker_filter as Map<String, dynamic>),
            );
    }
    return Variables$Query$SceneMarkerCount._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$SceneMarkerFilterType? get scene_marker_filter =>
      (_$data['scene_marker_filter'] as Input$SceneMarkerFilterType?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('scene_marker_filter')) {
      final l$scene_marker_filter = scene_marker_filter;
      result$data['scene_marker_filter'] = l$scene_marker_filter?.toJson();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$SceneMarkerCount ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scene_marker_filter = scene_marker_filter;
    final lOther$scene_marker_filter = other.scene_marker_filter;
    if (_$data.containsKey('scene_marker_filter') !=
        other._$data.containsKey('scene_marker_filter')) {
      return false;
    }
    if (l$scene_marker_filter != lOther$scene_marker_filter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scene_marker_filter = scene_marker_filter;
    return Object.hashAll([
      _$data.containsKey('scene_marker_filter')
          ? l$scene_marker_filter
          : const {},
    ]);
  }
}

class Query$SceneMarkerCount {
  Query$SceneMarkerCount({
    required this.findSceneMarkers,
    this.$__typename = 'Query',
  });

  factory Query$SceneMarkerCount.fromJson(Map<String, dynamic> json) {
    final l$findSceneMarkers = json['findSceneMarkers'];
    final l$$__typename = json['__typename'];
    return Query$SceneMarkerCount(
      findSceneMarkers: Query$SceneMarkerCount$findSceneMarkers.fromJson(
        (l$findSceneMarkers as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$SceneMarkerCount$findSceneMarkers findSceneMarkers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findSceneMarkers = findSceneMarkers;
    _resultData['findSceneMarkers'] = l$findSceneMarkers.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findSceneMarkers = findSceneMarkers;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findSceneMarkers, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SceneMarkerCount || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findSceneMarkers = findSceneMarkers;
    final lOther$findSceneMarkers = other.findSceneMarkers;
    if (l$findSceneMarkers != lOther$findSceneMarkers) {
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

const documentNodeQuerySceneMarkerCount = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SceneMarkerCount'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'scene_marker_filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'SceneMarkerFilterType'),
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
            name: NameNode(value: 'findSceneMarkers'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'per_page'),
                      value: IntValueNode(value: '1'),
                    ),
                  ],
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'scene_marker_filter'),
                value: VariableNode(
                  name: NameNode(value: 'scene_marker_filter'),
                ),
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
  ],
);
Query$SceneMarkerCount _parserFn$Query$SceneMarkerCount(
  Map<String, dynamic> data,
) => Query$SceneMarkerCount.fromJson(data);
typedef OnQueryComplete$Query$SceneMarkerCount = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$SceneMarkerCount?,
);

class Options$Query$SceneMarkerCount
    extends graphql.QueryOptions<Query$SceneMarkerCount> {
  Options$Query$SceneMarkerCount({
    String? operationName,
    Variables$Query$SceneMarkerCount? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneMarkerCount? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$SceneMarkerCount? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'SceneMarkerCount',
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
                 data == null ? null : _parserFn$Query$SceneMarkerCount(data),
               ),
         onError: onError,
         document: documentNodeQuerySceneMarkerCount,
         parserFn: _parserFn$Query$SceneMarkerCount,
       );

  final OnQueryComplete$Query$SceneMarkerCount? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$SceneMarkerCount
    extends graphql.WatchQueryOptions<Query$SceneMarkerCount> {
  WatchOptions$Query$SceneMarkerCount({
    String? operationName,
    Variables$Query$SceneMarkerCount? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneMarkerCount? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'SceneMarkerCount',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerySceneMarkerCount,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$SceneMarkerCount,
       );
}

class FetchMoreOptions$Query$SceneMarkerCount extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$SceneMarkerCount({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$SceneMarkerCount? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQuerySceneMarkerCount,
       );
}

extension ClientExtension$Query$SceneMarkerCount on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$SceneMarkerCount>> query$SceneMarkerCount([
    Options$Query$SceneMarkerCount? options,
  ]) async => await this.query(options ?? Options$Query$SceneMarkerCount());

  graphql.ObservableQuery<Query$SceneMarkerCount> watchQuery$SceneMarkerCount([
    WatchOptions$Query$SceneMarkerCount? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$SceneMarkerCount());

  void writeQuery$SceneMarkerCount({
    required Query$SceneMarkerCount data,
    Variables$Query$SceneMarkerCount? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySceneMarkerCount),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$SceneMarkerCount? readQuery$SceneMarkerCount({
    Variables$Query$SceneMarkerCount? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQuerySceneMarkerCount,
        ),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$SceneMarkerCount.fromJson(result);
  }
}

class Query$SceneMarkerCount$findSceneMarkers {
  Query$SceneMarkerCount$findSceneMarkers({
    required this.count,
    this.$__typename = 'FindSceneMarkersResultType',
  });

  factory Query$SceneMarkerCount$findSceneMarkers.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$count = json['count'];
    final l$$__typename = json['__typename'];
    return Query$SceneMarkerCount$findSceneMarkers(
      count: (l$count as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$$__typename = $__typename;
    return Object.hashAll([l$count, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SceneMarkerCount$findSceneMarkers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
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
