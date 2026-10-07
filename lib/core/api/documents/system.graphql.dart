import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Query$SystemStatus {
  Query$SystemStatus({required this.systemStatus, this.$__typename = 'Query'});

  factory Query$SystemStatus.fromJson(Map<String, dynamic> json) {
    final l$systemStatus = json['systemStatus'];
    final l$$__typename = json['__typename'];
    return Query$SystemStatus(
      systemStatus: Query$SystemStatus$systemStatus.fromJson(
        (l$systemStatus as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$SystemStatus$systemStatus systemStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$systemStatus = systemStatus;
    _resultData['systemStatus'] = l$systemStatus.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$systemStatus = systemStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([l$systemStatus, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SystemStatus || runtimeType != other.runtimeType) {
      return false;
    }
    final l$systemStatus = systemStatus;
    final lOther$systemStatus = other.systemStatus;
    if (l$systemStatus != lOther$systemStatus) {
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

const documentNodeQuerySystemStatus = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SystemStatus'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'systemStatus'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'status'),
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
Query$SystemStatus _parserFn$Query$SystemStatus(Map<String, dynamic> data) =>
    Query$SystemStatus.fromJson(data);
typedef OnQueryComplete$Query$SystemStatus = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$SystemStatus?,
);

class Options$Query$SystemStatus
    extends graphql.QueryOptions<Query$SystemStatus> {
  Options$Query$SystemStatus({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SystemStatus? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$SystemStatus? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         operationName: operationName ?? 'SystemStatus',
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
                 data == null ? null : _parserFn$Query$SystemStatus(data),
               ),
         onError: onError,
         document: documentNodeQuerySystemStatus,
         parserFn: _parserFn$Query$SystemStatus,
       );

  final OnQueryComplete$Query$SystemStatus? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$SystemStatus
    extends graphql.WatchQueryOptions<Query$SystemStatus> {
  WatchOptions$Query$SystemStatus({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SystemStatus? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName ?? 'SystemStatus',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerySystemStatus,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$SystemStatus,
       );
}

class FetchMoreOptions$Query$SystemStatus extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$SystemStatus({
    required graphql.UpdateQuery updateQuery,
  }) : super(updateQuery: updateQuery, document: documentNodeQuerySystemStatus);
}

extension ClientExtension$Query$SystemStatus on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$SystemStatus>> query$SystemStatus([
    Options$Query$SystemStatus? options,
  ]) async => await this.query(options ?? Options$Query$SystemStatus());

  graphql.ObservableQuery<Query$SystemStatus> watchQuery$SystemStatus([
    WatchOptions$Query$SystemStatus? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$SystemStatus());

  void writeQuery$SystemStatus({
    required Query$SystemStatus data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySystemStatus),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$SystemStatus? readQuery$SystemStatus({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySystemStatus),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$SystemStatus.fromJson(result);
  }
}

class Query$SystemStatus$systemStatus {
  Query$SystemStatus$systemStatus({
    required this.status,
    this.$__typename = 'SystemStatus',
  });

  factory Query$SystemStatus$systemStatus.fromJson(Map<String, dynamic> json) {
    final l$status = json['status'];
    final l$$__typename = json['__typename'];
    return Query$SystemStatus$systemStatus(
      status: fromJson$Enum$SystemStatusEnum((l$status as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$SystemStatusEnum status;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$status = status;
    _resultData['status'] = toJson$Enum$SystemStatusEnum(l$status);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$status = status;
    final l$$__typename = $__typename;
    return Object.hashAll([l$status, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SystemStatus$systemStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
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

class Query$Version {
  Query$Version({required this.version, this.$__typename = 'Query'});

  factory Query$Version.fromJson(Map<String, dynamic> json) {
    final l$version = json['version'];
    final l$$__typename = json['__typename'];
    return Query$Version(
      version: Query$Version$version.fromJson(
        (l$version as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Version$version version;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$version = version;
    _resultData['version'] = l$version.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$version = version;
    final l$$__typename = $__typename;
    return Object.hashAll([l$version, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Version || runtimeType != other.runtimeType) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
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

const documentNodeQueryVersion = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Version'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'version'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'version'),
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
Query$Version _parserFn$Query$Version(Map<String, dynamic> data) =>
    Query$Version.fromJson(data);
typedef OnQueryComplete$Query$Version = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Version?,
);

class Options$Query$Version extends graphql.QueryOptions<Query$Version> {
  Options$Query$Version({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Version? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Version? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         operationName: operationName ?? 'Version',
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
                 data == null ? null : _parserFn$Query$Version(data),
               ),
         onError: onError,
         document: documentNodeQueryVersion,
         parserFn: _parserFn$Query$Version,
       );

  final OnQueryComplete$Query$Version? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$Version
    extends graphql.WatchQueryOptions<Query$Version> {
  WatchOptions$Query$Version({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Version? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName ?? 'Version',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryVersion,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$Version,
       );
}

class FetchMoreOptions$Query$Version extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Version({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryVersion);
}

extension ClientExtension$Query$Version on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Version>> query$Version([
    Options$Query$Version? options,
  ]) async => await this.query(options ?? Options$Query$Version());

  graphql.ObservableQuery<Query$Version> watchQuery$Version([
    WatchOptions$Query$Version? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$Version());

  void writeQuery$Version({
    required Query$Version data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryVersion),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$Version? readQuery$Version({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryVersion),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Version.fromJson(result);
  }
}

class Query$Version$version {
  Query$Version$version({this.version, this.$__typename = 'Version'});

  factory Query$Version$version.fromJson(Map<String, dynamic> json) {
    final l$version = json['version'];
    final l$$__typename = json['__typename'];
    return Query$Version$version(
      version: (l$version as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? version;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$version = version;
    _resultData['version'] = l$version;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$version = version;
    final l$$__typename = $__typename;
    return Object.hashAll([l$version, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Version$version || runtimeType != other.runtimeType) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
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

class Query$Stats {
  Query$Stats({required this.stats, this.$__typename = 'Query'});

  factory Query$Stats.fromJson(Map<String, dynamic> json) {
    final l$stats = json['stats'];
    final l$$__typename = json['__typename'];
    return Query$Stats(
      stats: Query$Stats$stats.fromJson((l$stats as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Stats$stats stats;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$stats = stats;
    _resultData['stats'] = l$stats.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$stats = stats;
    final l$$__typename = $__typename;
    return Object.hashAll([l$stats, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Stats || runtimeType != other.runtimeType) {
      return false;
    }
    final l$stats = stats;
    final lOther$stats = other.stats;
    if (l$stats != lOther$stats) {
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

const documentNodeQueryStats = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Stats'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'stats'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'scene_count'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'scenes_size'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'scenes_duration'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'image_count'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'images_size'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'gallery_count'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'performer_count'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'studio_count'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'tag_count'),
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
Query$Stats _parserFn$Query$Stats(Map<String, dynamic> data) =>
    Query$Stats.fromJson(data);
typedef OnQueryComplete$Query$Stats = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Stats?,
);

class Options$Query$Stats extends graphql.QueryOptions<Query$Stats> {
  Options$Query$Stats({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Stats? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Stats? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         operationName: operationName ?? 'Stats',
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
                 data == null ? null : _parserFn$Query$Stats(data),
               ),
         onError: onError,
         document: documentNodeQueryStats,
         parserFn: _parserFn$Query$Stats,
       );

  final OnQueryComplete$Query$Stats? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$Stats extends graphql.WatchQueryOptions<Query$Stats> {
  WatchOptions$Query$Stats({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Stats? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName ?? 'Stats',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryStats,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$Stats,
       );
}

class FetchMoreOptions$Query$Stats extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Stats({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryStats);
}

extension ClientExtension$Query$Stats on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Stats>> query$Stats([
    Options$Query$Stats? options,
  ]) async => await this.query(options ?? Options$Query$Stats());

  graphql.ObservableQuery<Query$Stats> watchQuery$Stats([
    WatchOptions$Query$Stats? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$Stats());

  void writeQuery$Stats({required Query$Stats data, bool broadcast = true}) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryStats),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$Stats? readQuery$Stats({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryStats),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Stats.fromJson(result);
  }
}

class Query$Stats$stats {
  Query$Stats$stats({
    required this.scene_count,
    required this.scenes_size,
    required this.scenes_duration,
    required this.image_count,
    required this.images_size,
    required this.gallery_count,
    required this.performer_count,
    required this.studio_count,
    required this.tag_count,
    this.$__typename = 'StatsResultType',
  });

  factory Query$Stats$stats.fromJson(Map<String, dynamic> json) {
    final l$scene_count = json['scene_count'];
    final l$scenes_size = json['scenes_size'];
    final l$scenes_duration = json['scenes_duration'];
    final l$image_count = json['image_count'];
    final l$images_size = json['images_size'];
    final l$gallery_count = json['gallery_count'];
    final l$performer_count = json['performer_count'];
    final l$studio_count = json['studio_count'];
    final l$tag_count = json['tag_count'];
    final l$$__typename = json['__typename'];
    return Query$Stats$stats(
      scene_count: (l$scene_count as int),
      scenes_size: (l$scenes_size as num).toDouble(),
      scenes_duration: (l$scenes_duration as num).toDouble(),
      image_count: (l$image_count as int),
      images_size: (l$images_size as num).toDouble(),
      gallery_count: (l$gallery_count as int),
      performer_count: (l$performer_count as int),
      studio_count: (l$studio_count as int),
      tag_count: (l$tag_count as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int scene_count;

  final double scenes_size;

  final double scenes_duration;

  final int image_count;

  final double images_size;

  final int gallery_count;

  final int performer_count;

  final int studio_count;

  final int tag_count;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$scenes_size = scenes_size;
    _resultData['scenes_size'] = l$scenes_size;
    final l$scenes_duration = scenes_duration;
    _resultData['scenes_duration'] = l$scenes_duration;
    final l$image_count = image_count;
    _resultData['image_count'] = l$image_count;
    final l$images_size = images_size;
    _resultData['images_size'] = l$images_size;
    final l$gallery_count = gallery_count;
    _resultData['gallery_count'] = l$gallery_count;
    final l$performer_count = performer_count;
    _resultData['performer_count'] = l$performer_count;
    final l$studio_count = studio_count;
    _resultData['studio_count'] = l$studio_count;
    final l$tag_count = tag_count;
    _resultData['tag_count'] = l$tag_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scene_count = scene_count;
    final l$scenes_size = scenes_size;
    final l$scenes_duration = scenes_duration;
    final l$image_count = image_count;
    final l$images_size = images_size;
    final l$gallery_count = gallery_count;
    final l$performer_count = performer_count;
    final l$studio_count = studio_count;
    final l$tag_count = tag_count;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$scene_count,
      l$scenes_size,
      l$scenes_duration,
      l$image_count,
      l$images_size,
      l$gallery_count,
      l$performer_count,
      l$studio_count,
      l$tag_count,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Stats$stats || runtimeType != other.runtimeType) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    final l$scenes_size = scenes_size;
    final lOther$scenes_size = other.scenes_size;
    if (l$scenes_size != lOther$scenes_size) {
      return false;
    }
    final l$scenes_duration = scenes_duration;
    final lOther$scenes_duration = other.scenes_duration;
    if (l$scenes_duration != lOther$scenes_duration) {
      return false;
    }
    final l$image_count = image_count;
    final lOther$image_count = other.image_count;
    if (l$image_count != lOther$image_count) {
      return false;
    }
    final l$images_size = images_size;
    final lOther$images_size = other.images_size;
    if (l$images_size != lOther$images_size) {
      return false;
    }
    final l$gallery_count = gallery_count;
    final lOther$gallery_count = other.gallery_count;
    if (l$gallery_count != lOther$gallery_count) {
      return false;
    }
    final l$performer_count = performer_count;
    final lOther$performer_count = other.performer_count;
    if (l$performer_count != lOther$performer_count) {
      return false;
    }
    final l$studio_count = studio_count;
    final lOther$studio_count = other.studio_count;
    if (l$studio_count != lOther$studio_count) {
      return false;
    }
    final l$tag_count = tag_count;
    final lOther$tag_count = other.tag_count;
    if (l$tag_count != lOther$tag_count) {
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

class Query$ActivityStats {
  Query$ActivityStats({required this.stats, this.$__typename = 'Query'});

  factory Query$ActivityStats.fromJson(Map<String, dynamic> json) {
    final l$stats = json['stats'];
    final l$$__typename = json['__typename'];
    return Query$ActivityStats(
      stats: Query$ActivityStats$stats.fromJson(
        (l$stats as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$ActivityStats$stats stats;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$stats = stats;
    _resultData['stats'] = l$stats.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$stats = stats;
    final l$$__typename = $__typename;
    return Object.hashAll([l$stats, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ActivityStats || runtimeType != other.runtimeType) {
      return false;
    }
    final l$stats = stats;
    final lOther$stats = other.stats;
    if (l$stats != lOther$stats) {
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

const documentNodeQueryActivityStats = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'ActivityStats'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'stats'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'total_play_count'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'total_play_duration'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'scenes_played'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'total_o_count'),
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
Query$ActivityStats _parserFn$Query$ActivityStats(Map<String, dynamic> data) =>
    Query$ActivityStats.fromJson(data);
typedef OnQueryComplete$Query$ActivityStats = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$ActivityStats?,
);

class Options$Query$ActivityStats
    extends graphql.QueryOptions<Query$ActivityStats> {
  Options$Query$ActivityStats({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$ActivityStats? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$ActivityStats? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         operationName: operationName ?? 'ActivityStats',
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
                 data == null ? null : _parserFn$Query$ActivityStats(data),
               ),
         onError: onError,
         document: documentNodeQueryActivityStats,
         parserFn: _parserFn$Query$ActivityStats,
       );

  final OnQueryComplete$Query$ActivityStats? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$ActivityStats
    extends graphql.WatchQueryOptions<Query$ActivityStats> {
  WatchOptions$Query$ActivityStats({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$ActivityStats? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName ?? 'ActivityStats',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryActivityStats,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$ActivityStats,
       );
}

class FetchMoreOptions$Query$ActivityStats extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$ActivityStats({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQueryActivityStats,
       );
}

extension ClientExtension$Query$ActivityStats on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$ActivityStats>> query$ActivityStats([
    Options$Query$ActivityStats? options,
  ]) async => await this.query(options ?? Options$Query$ActivityStats());

  graphql.ObservableQuery<Query$ActivityStats> watchQuery$ActivityStats([
    WatchOptions$Query$ActivityStats? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$ActivityStats());

  void writeQuery$ActivityStats({
    required Query$ActivityStats data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryActivityStats),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$ActivityStats? readQuery$ActivityStats({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryActivityStats),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$ActivityStats.fromJson(result);
  }
}

class Query$ActivityStats$stats {
  Query$ActivityStats$stats({
    required this.total_play_count,
    required this.total_play_duration,
    required this.scenes_played,
    required this.total_o_count,
    this.$__typename = 'StatsResultType',
  });

  factory Query$ActivityStats$stats.fromJson(Map<String, dynamic> json) {
    final l$total_play_count = json['total_play_count'];
    final l$total_play_duration = json['total_play_duration'];
    final l$scenes_played = json['scenes_played'];
    final l$total_o_count = json['total_o_count'];
    final l$$__typename = json['__typename'];
    return Query$ActivityStats$stats(
      total_play_count: (l$total_play_count as int),
      total_play_duration: (l$total_play_duration as num).toDouble(),
      scenes_played: (l$scenes_played as int),
      total_o_count: (l$total_o_count as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int total_play_count;

  final double total_play_duration;

  final int scenes_played;

  final int total_o_count;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$total_play_count = total_play_count;
    _resultData['total_play_count'] = l$total_play_count;
    final l$total_play_duration = total_play_duration;
    _resultData['total_play_duration'] = l$total_play_duration;
    final l$scenes_played = scenes_played;
    _resultData['scenes_played'] = l$scenes_played;
    final l$total_o_count = total_o_count;
    _resultData['total_o_count'] = l$total_o_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$total_play_count = total_play_count;
    final l$total_play_duration = total_play_duration;
    final l$scenes_played = scenes_played;
    final l$total_o_count = total_o_count;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$total_play_count,
      l$total_play_duration,
      l$scenes_played,
      l$total_o_count,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$ActivityStats$stats ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$total_play_count = total_play_count;
    final lOther$total_play_count = other.total_play_count;
    if (l$total_play_count != lOther$total_play_count) {
      return false;
    }
    final l$total_play_duration = total_play_duration;
    final lOther$total_play_duration = other.total_play_duration;
    if (l$total_play_duration != lOther$total_play_duration) {
      return false;
    }
    final l$scenes_played = scenes_played;
    final lOther$scenes_played = other.scenes_played;
    if (l$scenes_played != lOther$scenes_played) {
      return false;
    }
    final l$total_o_count = total_o_count;
    final lOther$total_o_count = other.total_o_count;
    if (l$total_o_count != lOther$total_o_count) {
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

class Query$SavedSceneFilters {
  Query$SavedSceneFilters({
    required this.findSavedFilters,
    this.$__typename = 'Query',
  });

  factory Query$SavedSceneFilters.fromJson(Map<String, dynamic> json) {
    final l$findSavedFilters = json['findSavedFilters'];
    final l$$__typename = json['__typename'];
    return Query$SavedSceneFilters(
      findSavedFilters: (l$findSavedFilters as List<dynamic>)
          .map(
            (e) => Query$SavedSceneFilters$findSavedFilters.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$SavedSceneFilters$findSavedFilters> findSavedFilters;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findSavedFilters = findSavedFilters;
    _resultData['findSavedFilters'] = l$findSavedFilters
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findSavedFilters = findSavedFilters;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$findSavedFilters.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SavedSceneFilters || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findSavedFilters = findSavedFilters;
    final lOther$findSavedFilters = other.findSavedFilters;
    if (l$findSavedFilters.length != lOther$findSavedFilters.length) {
      return false;
    }
    for (int i = 0; i < l$findSavedFilters.length; i++) {
      final l$findSavedFilters$entry = l$findSavedFilters[i];
      final lOther$findSavedFilters$entry = lOther$findSavedFilters[i];
      if (l$findSavedFilters$entry != lOther$findSavedFilters$entry) {
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

const documentNodeQuerySavedSceneFilters = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SavedSceneFilters'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'findSavedFilters'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'mode'),
                value: EnumValueNode(name: NameNode(value: 'SCENES')),
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
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'find_filter'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'q'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'sort'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'direction'),
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
                  name: NameNode(value: 'object_filter'),
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
Query$SavedSceneFilters _parserFn$Query$SavedSceneFilters(
  Map<String, dynamic> data,
) => Query$SavedSceneFilters.fromJson(data);
typedef OnQueryComplete$Query$SavedSceneFilters = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$SavedSceneFilters?,
);

class Options$Query$SavedSceneFilters
    extends graphql.QueryOptions<Query$SavedSceneFilters> {
  Options$Query$SavedSceneFilters({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SavedSceneFilters? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$SavedSceneFilters? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         operationName: operationName ?? 'SavedSceneFilters',
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
                 data == null ? null : _parserFn$Query$SavedSceneFilters(data),
               ),
         onError: onError,
         document: documentNodeQuerySavedSceneFilters,
         parserFn: _parserFn$Query$SavedSceneFilters,
       );

  final OnQueryComplete$Query$SavedSceneFilters? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$SavedSceneFilters
    extends graphql.WatchQueryOptions<Query$SavedSceneFilters> {
  WatchOptions$Query$SavedSceneFilters({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SavedSceneFilters? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName ?? 'SavedSceneFilters',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerySavedSceneFilters,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$SavedSceneFilters,
       );
}

class FetchMoreOptions$Query$SavedSceneFilters
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$SavedSceneFilters({
    required graphql.UpdateQuery updateQuery,
  }) : super(
         updateQuery: updateQuery,
         document: documentNodeQuerySavedSceneFilters,
       );
}

extension ClientExtension$Query$SavedSceneFilters on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$SavedSceneFilters>> query$SavedSceneFilters([
    Options$Query$SavedSceneFilters? options,
  ]) async => await this.query(options ?? Options$Query$SavedSceneFilters());

  graphql.ObservableQuery<Query$SavedSceneFilters>
  watchQuery$SavedSceneFilters([
    WatchOptions$Query$SavedSceneFilters? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$SavedSceneFilters());

  void writeQuery$SavedSceneFilters({
    required Query$SavedSceneFilters data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQuerySavedSceneFilters,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$SavedSceneFilters? readQuery$SavedSceneFilters({
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQuerySavedSceneFilters,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$SavedSceneFilters.fromJson(result);
  }
}

class Query$SavedSceneFilters$findSavedFilters {
  Query$SavedSceneFilters$findSavedFilters({
    required this.id,
    required this.name,
    this.find_filter,
    this.object_filter,
    this.$__typename = 'SavedFilter',
  });

  factory Query$SavedSceneFilters$findSavedFilters.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$find_filter = json['find_filter'];
    final l$object_filter = json['object_filter'];
    final l$$__typename = json['__typename'];
    return Query$SavedSceneFilters$findSavedFilters(
      id: (l$id as String),
      name: (l$name as String),
      find_filter: l$find_filter == null
          ? null
          : Query$SavedSceneFilters$findSavedFilters$find_filter.fromJson(
              (l$find_filter as Map<String, dynamic>),
            ),
      object_filter: (l$object_filter as Map<String, dynamic>?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Query$SavedSceneFilters$findSavedFilters$find_filter? find_filter;

  final Map<String, dynamic>? object_filter;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$find_filter = find_filter;
    _resultData['find_filter'] = l$find_filter?.toJson();
    final l$object_filter = object_filter;
    _resultData['object_filter'] = l$object_filter;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$find_filter = find_filter;
    final l$object_filter = object_filter;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$find_filter,
      l$object_filter,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SavedSceneFilters$findSavedFilters ||
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
    final l$find_filter = find_filter;
    final lOther$find_filter = other.find_filter;
    if (l$find_filter != lOther$find_filter) {
      return false;
    }
    final l$object_filter = object_filter;
    final lOther$object_filter = other.object_filter;
    if (l$object_filter != lOther$object_filter) {
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

class Query$SavedSceneFilters$findSavedFilters$find_filter {
  Query$SavedSceneFilters$findSavedFilters$find_filter({
    this.q,
    this.sort,
    this.direction,
    this.$__typename = 'SavedFindFilterType',
  });

  factory Query$SavedSceneFilters$findSavedFilters$find_filter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$q = json['q'];
    final l$sort = json['sort'];
    final l$direction = json['direction'];
    final l$$__typename = json['__typename'];
    return Query$SavedSceneFilters$findSavedFilters$find_filter(
      q: (l$q as String?),
      sort: (l$sort as String?),
      direction: l$direction == null
          ? null
          : fromJson$Enum$SortDirectionEnum((l$direction as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String? q;

  final String? sort;

  final Enum$SortDirectionEnum? direction;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$q = q;
    _resultData['q'] = l$q;
    final l$sort = sort;
    _resultData['sort'] = l$sort;
    final l$direction = direction;
    _resultData['direction'] = l$direction == null
        ? null
        : toJson$Enum$SortDirectionEnum(l$direction);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$q = q;
    final l$sort = sort;
    final l$direction = direction;
    final l$$__typename = $__typename;
    return Object.hashAll([l$q, l$sort, l$direction, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$SavedSceneFilters$findSavedFilters$find_filter ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$q = q;
    final lOther$q = other.q;
    if (l$q != lOther$q) {
      return false;
    }
    final l$sort = sort;
    final lOther$sort = other.sort;
    if (l$sort != lOther$sort) {
      return false;
    }
    final l$direction = direction;
    final lOther$direction = other.direction;
    if (l$direction != lOther$direction) {
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
