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

class Variables$Query$SceneMarkerEnds {
  factory Variables$Query$SceneMarkerEnds({required String id}) =>
      Variables$Query$SceneMarkerEnds._({r'id': id});

  Variables$Query$SceneMarkerEnds._(this._$data);

  factory Variables$Query$SceneMarkerEnds.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$SceneMarkerEnds._(result$data);
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
    if (other is! Variables$Query$SceneMarkerEnds ||
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

class Query$SceneMarkerEnds {
  Query$SceneMarkerEnds({this.findScene, this.$__typename = 'Query'});

  factory Query$SceneMarkerEnds.fromJson(Map<String, dynamic> json) {
    final l$findScene = json['findScene'];
    final l$$__typename = json['__typename'];
    return Query$SceneMarkerEnds(
      findScene: l$findScene == null
          ? null
          : Query$SceneMarkerEnds$findScene.fromJson(
              (l$findScene as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$SceneMarkerEnds$findScene? findScene;

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
    if (other is! Query$SceneMarkerEnds || runtimeType != other.runtimeType) {
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

const documentNodeQuerySceneMarkerEnds = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SceneMarkerEnds'),
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
                  name: NameNode(value: 'scene_markers'),
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
                        name: NameNode(value: 'end_seconds'),
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
Query$SceneMarkerEnds _parserFn$Query$SceneMarkerEnds(
  Map<String, dynamic> data,
) => Query$SceneMarkerEnds.fromJson(data);
typedef OnQueryComplete$Query$SceneMarkerEnds = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$SceneMarkerEnds?,
);

class Options$Query$SceneMarkerEnds
    extends graphql.QueryOptions<Query$SceneMarkerEnds> {
  Options$Query$SceneMarkerEnds({
    String? operationName,
    required Variables$Query$SceneMarkerEnds variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneMarkerEnds? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$SceneMarkerEnds? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneMarkerEnds',
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
                 data == null ? null : _parserFn$Query$SceneMarkerEnds(data),
               ),
         onError: onError,
         document: documentNodeQuerySceneMarkerEnds,
         parserFn: _parserFn$Query$SceneMarkerEnds,
       );

  final OnQueryComplete$Query$SceneMarkerEnds? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$SceneMarkerEnds
    extends graphql.WatchQueryOptions<Query$SceneMarkerEnds> {
  WatchOptions$Query$SceneMarkerEnds({
    String? operationName,
    required Variables$Query$SceneMarkerEnds variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneMarkerEnds? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneMarkerEnds',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerySceneMarkerEnds,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$SceneMarkerEnds,
       );
}

class FetchMoreOptions$Query$SceneMarkerEnds extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$SceneMarkerEnds({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$SceneMarkerEnds variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySceneMarkerEnds,
       );
}

extension ClientExtension$Query$SceneMarkerEnds on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$SceneMarkerEnds>> query$SceneMarkerEnds(
    Options$Query$SceneMarkerEnds options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$SceneMarkerEnds> watchQuery$SceneMarkerEnds(
    WatchOptions$Query$SceneMarkerEnds options,
  ) => this.watchQuery(options);

  void writeQuery$SceneMarkerEnds({
    required Query$SceneMarkerEnds data,
    required Variables$Query$SceneMarkerEnds variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySceneMarkerEnds),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$SceneMarkerEnds? readQuery$SceneMarkerEnds({
    required Variables$Query$SceneMarkerEnds variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQuerySceneMarkerEnds,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$SceneMarkerEnds.fromJson(result);
  }
}

class Query$SceneMarkerEnds$findScene {
  Query$SceneMarkerEnds$findScene({
    required this.id,
    required this.scene_markers,
    this.$__typename = 'Scene',
  });

  factory Query$SceneMarkerEnds$findScene.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$scene_markers = json['scene_markers'];
    final l$$__typename = json['__typename'];
    return Query$SceneMarkerEnds$findScene(
      id: (l$id as String),
      scene_markers: (l$scene_markers as List<dynamic>)
          .map(
            (e) => Query$SceneMarkerEnds$findScene$scene_markers.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$SceneMarkerEnds$findScene$scene_markers> scene_markers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$scene_markers = scene_markers;
    _resultData['scene_markers'] = l$scene_markers
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$scene_markers = scene_markers;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$scene_markers.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SceneMarkerEnds$findScene ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$scene_markers = scene_markers;
    final lOther$scene_markers = other.scene_markers;
    if (l$scene_markers.length != lOther$scene_markers.length) {
      return false;
    }
    for (int i = 0; i < l$scene_markers.length; i++) {
      final l$scene_markers$entry = l$scene_markers[i];
      final lOther$scene_markers$entry = lOther$scene_markers[i];
      if (l$scene_markers$entry != lOther$scene_markers$entry) {
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

class Query$SceneMarkerEnds$findScene$scene_markers {
  Query$SceneMarkerEnds$findScene$scene_markers({
    required this.id,
    this.end_seconds,
    this.$__typename = 'SceneMarker',
  });

  factory Query$SceneMarkerEnds$findScene$scene_markers.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$end_seconds = json['end_seconds'];
    final l$$__typename = json['__typename'];
    return Query$SceneMarkerEnds$findScene$scene_markers(
      id: (l$id as String),
      end_seconds: (l$end_seconds as num?)?.toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final double? end_seconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$end_seconds = end_seconds;
    _resultData['end_seconds'] = l$end_seconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$end_seconds = end_seconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$end_seconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SceneMarkerEnds$findScene$scene_markers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$end_seconds = end_seconds;
    final lOther$end_seconds = other.end_seconds;
    if (l$end_seconds != lOther$end_seconds) {
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

class Variables$Query$MarkerEnds {
  factory Variables$Query$MarkerEnds({List<String>? ids}) =>
      Variables$Query$MarkerEnds._({if (ids != null) r'ids': ids});

  Variables$Query$MarkerEnds._(this._$data);

  factory Variables$Query$MarkerEnds.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] = (l$ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Variables$Query$MarkerEnds._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get ids => (_$data['ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('ids')) {
      final l$ids = ids;
      result$data['ids'] = l$ids?.map((e) => e).toList();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$MarkerEnds ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$ids = ids;
    final lOther$ids = other.ids;
    if (_$data.containsKey('ids') != other._$data.containsKey('ids')) {
      return false;
    }
    if (l$ids != null && lOther$ids != null) {
      if (l$ids.length != lOther$ids.length) {
        return false;
      }
      for (int i = 0; i < l$ids.length; i++) {
        final l$ids$entry = l$ids[i];
        final lOther$ids$entry = lOther$ids[i];
        if (l$ids$entry != lOther$ids$entry) {
          return false;
        }
      }
    } else if (l$ids != lOther$ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ids = ids;
    return Object.hashAll([
      _$data.containsKey('ids')
          ? l$ids == null
                ? null
                : Object.hashAll(l$ids.map((v) => v))
          : const {},
    ]);
  }
}

class Query$MarkerEnds {
  Query$MarkerEnds({
    required this.findSceneMarkers,
    this.$__typename = 'Query',
  });

  factory Query$MarkerEnds.fromJson(Map<String, dynamic> json) {
    final l$findSceneMarkers = json['findSceneMarkers'];
    final l$$__typename = json['__typename'];
    return Query$MarkerEnds(
      findSceneMarkers: Query$MarkerEnds$findSceneMarkers.fromJson(
        (l$findSceneMarkers as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$MarkerEnds$findSceneMarkers findSceneMarkers;

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
    if (other is! Query$MarkerEnds || runtimeType != other.runtimeType) {
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

const documentNodeQueryMarkerEnds = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'MarkerEnds'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'ids')),
          type: ListTypeNode(
            type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
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
                name: NameNode(value: 'ids'),
                value: VariableNode(name: NameNode(value: 'ids')),
              ),
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: ObjectValueNode(
                  fields: [
                    ObjectFieldNode(
                      name: NameNode(value: 'per_page'),
                      value: IntValueNode(value: '-1'),
                    ),
                  ],
                ),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'scene_markers'),
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
                        name: NameNode(value: 'end_seconds'),
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
Query$MarkerEnds _parserFn$Query$MarkerEnds(Map<String, dynamic> data) =>
    Query$MarkerEnds.fromJson(data);
typedef OnQueryComplete$Query$MarkerEnds = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$MarkerEnds?,
);

class Options$Query$MarkerEnds extends graphql.QueryOptions<Query$MarkerEnds> {
  Options$Query$MarkerEnds({
    String? operationName,
    Variables$Query$MarkerEnds? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$MarkerEnds? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$MarkerEnds? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'MarkerEnds',
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
                 data == null ? null : _parserFn$Query$MarkerEnds(data),
               ),
         onError: onError,
         document: documentNodeQueryMarkerEnds,
         parserFn: _parserFn$Query$MarkerEnds,
       );

  final OnQueryComplete$Query$MarkerEnds? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$MarkerEnds
    extends graphql.WatchQueryOptions<Query$MarkerEnds> {
  WatchOptions$Query$MarkerEnds({
    String? operationName,
    Variables$Query$MarkerEnds? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$MarkerEnds? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'MarkerEnds',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryMarkerEnds,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$MarkerEnds,
       );
}

class FetchMoreOptions$Query$MarkerEnds extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$MarkerEnds({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$MarkerEnds? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryMarkerEnds,
       );
}

extension ClientExtension$Query$MarkerEnds on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$MarkerEnds>> query$MarkerEnds([
    Options$Query$MarkerEnds? options,
  ]) async => await this.query(options ?? Options$Query$MarkerEnds());

  graphql.ObservableQuery<Query$MarkerEnds> watchQuery$MarkerEnds([
    WatchOptions$Query$MarkerEnds? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$MarkerEnds());

  void writeQuery$MarkerEnds({
    required Query$MarkerEnds data,
    Variables$Query$MarkerEnds? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryMarkerEnds),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$MarkerEnds? readQuery$MarkerEnds({
    Variables$Query$MarkerEnds? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryMarkerEnds),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$MarkerEnds.fromJson(result);
  }
}

class Query$MarkerEnds$findSceneMarkers {
  Query$MarkerEnds$findSceneMarkers({
    required this.scene_markers,
    this.$__typename = 'FindSceneMarkersResultType',
  });

  factory Query$MarkerEnds$findSceneMarkers.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$scene_markers = json['scene_markers'];
    final l$$__typename = json['__typename'];
    return Query$MarkerEnds$findSceneMarkers(
      scene_markers: (l$scene_markers as List<dynamic>)
          .map(
            (e) => Query$MarkerEnds$findSceneMarkers$scene_markers.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$MarkerEnds$findSceneMarkers$scene_markers> scene_markers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scene_markers = scene_markers;
    _resultData['scene_markers'] = l$scene_markers
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scene_markers = scene_markers;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$scene_markers.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MarkerEnds$findSceneMarkers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scene_markers = scene_markers;
    final lOther$scene_markers = other.scene_markers;
    if (l$scene_markers.length != lOther$scene_markers.length) {
      return false;
    }
    for (int i = 0; i < l$scene_markers.length; i++) {
      final l$scene_markers$entry = l$scene_markers[i];
      final lOther$scene_markers$entry = lOther$scene_markers[i];
      if (l$scene_markers$entry != lOther$scene_markers$entry) {
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

class Query$MarkerEnds$findSceneMarkers$scene_markers {
  Query$MarkerEnds$findSceneMarkers$scene_markers({
    required this.id,
    this.end_seconds,
    this.$__typename = 'SceneMarker',
  });

  factory Query$MarkerEnds$findSceneMarkers$scene_markers.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$end_seconds = json['end_seconds'];
    final l$$__typename = json['__typename'];
    return Query$MarkerEnds$findSceneMarkers$scene_markers(
      id: (l$id as String),
      end_seconds: (l$end_seconds as num?)?.toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final double? end_seconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$end_seconds = end_seconds;
    _resultData['end_seconds'] = l$end_seconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$end_seconds = end_seconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$end_seconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$MarkerEnds$findSceneMarkers$scene_markers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$end_seconds = end_seconds;
    final lOther$end_seconds = other.end_seconds;
    if (l$end_seconds != lOther$end_seconds) {
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
