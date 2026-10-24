import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Fragment$JobFields {
  Fragment$JobFields({
    required this.id,
    required this.status,
    required this.description,
    this.subTasks,
    this.progress,
    this.error,
    this.$__typename = 'Job',
  });

  factory Fragment$JobFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$description = json['description'];
    final l$subTasks = json['subTasks'];
    final l$progress = json['progress'];
    final l$error = json['error'];
    final l$$__typename = json['__typename'];
    return Fragment$JobFields(
      id: (l$id as String),
      status: fromJson$Enum$JobStatus((l$status as String)),
      description: (l$description as String),
      subTasks: (l$subTasks as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList(),
      progress: (l$progress as num?)?.toDouble(),
      error: (l$error as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$JobStatus status;

  final String description;

  final List<String>? subTasks;

  final double? progress;

  final String? error;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$JobStatus(l$status);
    final l$description = description;
    _resultData['description'] = l$description;
    final l$subTasks = subTasks;
    _resultData['subTasks'] = l$subTasks?.map((e) => e).toList();
    final l$progress = progress;
    _resultData['progress'] = l$progress;
    final l$error = error;
    _resultData['error'] = l$error;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$description = description;
    final l$subTasks = subTasks;
    final l$progress = progress;
    final l$error = error;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$description,
      l$subTasks == null ? null : Object.hashAll(l$subTasks.map((v) => v)),
      l$progress,
      l$error,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$JobFields || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$subTasks = subTasks;
    final lOther$subTasks = other.subTasks;
    if (l$subTasks != null && lOther$subTasks != null) {
      if (l$subTasks.length != lOther$subTasks.length) {
        return false;
      }
      for (int i = 0; i < l$subTasks.length; i++) {
        final l$subTasks$entry = l$subTasks[i];
        final lOther$subTasks$entry = lOther$subTasks[i];
        if (l$subTasks$entry != lOther$subTasks$entry) {
          return false;
        }
      }
    } else if (l$subTasks != lOther$subTasks) {
      return false;
    }
    final l$progress = progress;
    final lOther$progress = other.progress;
    if (l$progress != lOther$progress) {
      return false;
    }
    final l$error = error;
    final lOther$error = other.error;
    if (l$error != lOther$error) {
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

const fragmentDefinitionJobFields = FragmentDefinitionNode(
  name: NameNode(value: 'JobFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Job'), isNonNull: false),
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
        name: NameNode(value: 'status'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'description'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'subTasks'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'progress'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'error'),
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
const documentNodeFragmentJobFields = DocumentNode(
  definitions: [fragmentDefinitionJobFields],
);

extension ClientExtension$Fragment$JobFields on graphql.GraphQLClient {
  void writeFragment$JobFields({
    required Fragment$JobFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'JobFields',
        document: documentNodeFragmentJobFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$JobFields? readFragment$JobFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'JobFields',
          document: documentNodeFragmentJobFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$JobFields.fromJson(result);
  }
}

class Query$JobQueue {
  Query$JobQueue({this.jobQueue, this.$__typename = 'Query'});

  factory Query$JobQueue.fromJson(Map<String, dynamic> json) {
    final l$jobQueue = json['jobQueue'];
    final l$$__typename = json['__typename'];
    return Query$JobQueue(
      jobQueue: (l$jobQueue as List<dynamic>?)
          ?.map((e) => Fragment$JobFields.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$JobFields>? jobQueue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$jobQueue = jobQueue;
    _resultData['jobQueue'] = l$jobQueue?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$jobQueue = jobQueue;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$jobQueue == null ? null : Object.hashAll(l$jobQueue.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$JobQueue || runtimeType != other.runtimeType) {
      return false;
    }
    final l$jobQueue = jobQueue;
    final lOther$jobQueue = other.jobQueue;
    if (l$jobQueue != null && lOther$jobQueue != null) {
      if (l$jobQueue.length != lOther$jobQueue.length) {
        return false;
      }
      for (int i = 0; i < l$jobQueue.length; i++) {
        final l$jobQueue$entry = l$jobQueue[i];
        final lOther$jobQueue$entry = lOther$jobQueue[i];
        if (l$jobQueue$entry != lOther$jobQueue$entry) {
          return false;
        }
      }
    } else if (l$jobQueue != lOther$jobQueue) {
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

const documentNodeQueryJobQueue = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'JobQueue'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'jobQueue'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'JobFields'),
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
    fragmentDefinitionJobFields,
  ],
);
Query$JobQueue _parserFn$Query$JobQueue(Map<String, dynamic> data) =>
    Query$JobQueue.fromJson(data);
typedef OnQueryComplete$Query$JobQueue = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$JobQueue?,
);

class Options$Query$JobQueue extends graphql.QueryOptions<Query$JobQueue> {
  Options$Query$JobQueue({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$JobQueue? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$JobQueue? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         operationName: operationName ?? 'JobQueue',
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
                 data == null ? null : _parserFn$Query$JobQueue(data),
               ),
         onError: onError,
         document: documentNodeQueryJobQueue,
         parserFn: _parserFn$Query$JobQueue,
       );

  final OnQueryComplete$Query$JobQueue? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$JobQueue
    extends graphql.WatchQueryOptions<Query$JobQueue> {
  WatchOptions$Query$JobQueue({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$JobQueue? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName ?? 'JobQueue',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryJobQueue,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$JobQueue,
       );
}

class FetchMoreOptions$Query$JobQueue extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$JobQueue({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryJobQueue);
}

extension ClientExtension$Query$JobQueue on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$JobQueue>> query$JobQueue([
    Options$Query$JobQueue? options,
  ]) async => await this.query(options ?? Options$Query$JobQueue());

  graphql.ObservableQuery<Query$JobQueue> watchQuery$JobQueue([
    WatchOptions$Query$JobQueue? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$JobQueue());

  void writeQuery$JobQueue({
    required Query$JobQueue data,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryJobQueue),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$JobQueue? readQuery$JobQueue({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryJobQueue),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$JobQueue.fromJson(result);
  }
}

class Variables$Mutation$StopJob {
  factory Variables$Mutation$StopJob({required String job_id}) =>
      Variables$Mutation$StopJob._({r'job_id': job_id});

  Variables$Mutation$StopJob._(this._$data);

  factory Variables$Mutation$StopJob.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$job_id = data['job_id'];
    result$data['job_id'] = (l$job_id as String);
    return Variables$Mutation$StopJob._(result$data);
  }

  Map<String, dynamic> _$data;

  String get job_id => (_$data['job_id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$job_id = job_id;
    result$data['job_id'] = l$job_id;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$StopJob ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$job_id = job_id;
    final lOther$job_id = other.job_id;
    if (l$job_id != lOther$job_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$job_id = job_id;
    return Object.hashAll([l$job_id]);
  }
}

class Mutation$StopJob {
  Mutation$StopJob({required this.stopJob, this.$__typename = 'Mutation'});

  factory Mutation$StopJob.fromJson(Map<String, dynamic> json) {
    final l$stopJob = json['stopJob'];
    final l$$__typename = json['__typename'];
    return Mutation$StopJob(
      stopJob: (l$stopJob as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool stopJob;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$stopJob = stopJob;
    _resultData['stopJob'] = l$stopJob;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$stopJob = stopJob;
    final l$$__typename = $__typename;
    return Object.hashAll([l$stopJob, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$StopJob || runtimeType != other.runtimeType) {
      return false;
    }
    final l$stopJob = stopJob;
    final lOther$stopJob = other.stopJob;
    if (l$stopJob != lOther$stopJob) {
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

const documentNodeMutationStopJob = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'StopJob'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'job_id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'stopJob'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'job_id'),
                value: VariableNode(name: NameNode(value: 'job_id')),
              ),
            ],
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
  ],
);
Mutation$StopJob _parserFn$Mutation$StopJob(Map<String, dynamic> data) =>
    Mutation$StopJob.fromJson(data);
typedef OnMutationCompleted$Mutation$StopJob = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$StopJob?,
);

class Options$Mutation$StopJob
    extends graphql.MutationOptions<Mutation$StopJob> {
  Options$Mutation$StopJob({
    String? operationName,
    required Variables$Mutation$StopJob variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$StopJob? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$StopJob? onCompleted,
    graphql.OnMutationUpdate<Mutation$StopJob>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'StopJob',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$StopJob(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationStopJob,
         parserFn: _parserFn$Mutation$StopJob,
       );

  final OnMutationCompleted$Mutation$StopJob? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$StopJob
    extends graphql.WatchQueryOptions<Mutation$StopJob> {
  WatchOptions$Mutation$StopJob({
    String? operationName,
    required Variables$Mutation$StopJob variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$StopJob? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'StopJob',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationStopJob,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$StopJob,
       );
}

extension ClientExtension$Mutation$StopJob on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$StopJob>> mutate$StopJob(
    Options$Mutation$StopJob options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$StopJob> watchMutation$StopJob(
    WatchOptions$Mutation$StopJob options,
  ) => this.watchMutation(options);
}

class Variables$Mutation$MetadataScan {
  factory Variables$Mutation$MetadataScan({
    required Input$ScanMetadataInput input,
  }) => Variables$Mutation$MetadataScan._({r'input': input});

  Variables$Mutation$MetadataScan._(this._$data);

  factory Variables$Mutation$MetadataScan.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$ScanMetadataInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$MetadataScan._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ScanMetadataInput get input =>
      (_$data['input'] as Input$ScanMetadataInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$MetadataScan ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

class Mutation$MetadataScan {
  Mutation$MetadataScan({
    required this.metadataScan,
    this.$__typename = 'Mutation',
  });

  factory Mutation$MetadataScan.fromJson(Map<String, dynamic> json) {
    final l$metadataScan = json['metadataScan'];
    final l$$__typename = json['__typename'];
    return Mutation$MetadataScan(
      metadataScan: (l$metadataScan as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String metadataScan;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$metadataScan = metadataScan;
    _resultData['metadataScan'] = l$metadataScan;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$metadataScan = metadataScan;
    final l$$__typename = $__typename;
    return Object.hashAll([l$metadataScan, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$MetadataScan || runtimeType != other.runtimeType) {
      return false;
    }
    final l$metadataScan = metadataScan;
    final lOther$metadataScan = other.metadataScan;
    if (l$metadataScan != lOther$metadataScan) {
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

const documentNodeMutationMetadataScan = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'MetadataScan'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'ScanMetadataInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'metadataScan'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
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
  ],
);
Mutation$MetadataScan _parserFn$Mutation$MetadataScan(
  Map<String, dynamic> data,
) => Mutation$MetadataScan.fromJson(data);
typedef OnMutationCompleted$Mutation$MetadataScan = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$MetadataScan?,
);

class Options$Mutation$MetadataScan
    extends graphql.MutationOptions<Mutation$MetadataScan> {
  Options$Mutation$MetadataScan({
    String? operationName,
    required Variables$Mutation$MetadataScan variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataScan? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$MetadataScan? onCompleted,
    graphql.OnMutationUpdate<Mutation$MetadataScan>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataScan',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$MetadataScan(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationMetadataScan,
         parserFn: _parserFn$Mutation$MetadataScan,
       );

  final OnMutationCompleted$Mutation$MetadataScan? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$MetadataScan
    extends graphql.WatchQueryOptions<Mutation$MetadataScan> {
  WatchOptions$Mutation$MetadataScan({
    String? operationName,
    required Variables$Mutation$MetadataScan variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataScan? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataScan',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationMetadataScan,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$MetadataScan,
       );
}

extension ClientExtension$Mutation$MetadataScan on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$MetadataScan>> mutate$MetadataScan(
    Options$Mutation$MetadataScan options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$MetadataScan> watchMutation$MetadataScan(
    WatchOptions$Mutation$MetadataScan options,
  ) => this.watchMutation(options);
}

class Variables$Mutation$MetadataGenerate {
  factory Variables$Mutation$MetadataGenerate({
    required Input$GenerateMetadataInput input,
  }) => Variables$Mutation$MetadataGenerate._({r'input': input});

  Variables$Mutation$MetadataGenerate._(this._$data);

  factory Variables$Mutation$MetadataGenerate.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$GenerateMetadataInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$MetadataGenerate._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$GenerateMetadataInput get input =>
      (_$data['input'] as Input$GenerateMetadataInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$MetadataGenerate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

class Mutation$MetadataGenerate {
  Mutation$MetadataGenerate({
    required this.metadataGenerate,
    this.$__typename = 'Mutation',
  });

  factory Mutation$MetadataGenerate.fromJson(Map<String, dynamic> json) {
    final l$metadataGenerate = json['metadataGenerate'];
    final l$$__typename = json['__typename'];
    return Mutation$MetadataGenerate(
      metadataGenerate: (l$metadataGenerate as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String metadataGenerate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$metadataGenerate = metadataGenerate;
    _resultData['metadataGenerate'] = l$metadataGenerate;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$metadataGenerate = metadataGenerate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$metadataGenerate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$MetadataGenerate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$metadataGenerate = metadataGenerate;
    final lOther$metadataGenerate = other.metadataGenerate;
    if (l$metadataGenerate != lOther$metadataGenerate) {
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

const documentNodeMutationMetadataGenerate = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'MetadataGenerate'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'GenerateMetadataInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'metadataGenerate'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
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
  ],
);
Mutation$MetadataGenerate _parserFn$Mutation$MetadataGenerate(
  Map<String, dynamic> data,
) => Mutation$MetadataGenerate.fromJson(data);
typedef OnMutationCompleted$Mutation$MetadataGenerate = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$MetadataGenerate?,
);

class Options$Mutation$MetadataGenerate
    extends graphql.MutationOptions<Mutation$MetadataGenerate> {
  Options$Mutation$MetadataGenerate({
    String? operationName,
    required Variables$Mutation$MetadataGenerate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataGenerate? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$MetadataGenerate? onCompleted,
    graphql.OnMutationUpdate<Mutation$MetadataGenerate>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataGenerate',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null
                     ? null
                     : _parserFn$Mutation$MetadataGenerate(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationMetadataGenerate,
         parserFn: _parserFn$Mutation$MetadataGenerate,
       );

  final OnMutationCompleted$Mutation$MetadataGenerate? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$MetadataGenerate
    extends graphql.WatchQueryOptions<Mutation$MetadataGenerate> {
  WatchOptions$Mutation$MetadataGenerate({
    String? operationName,
    required Variables$Mutation$MetadataGenerate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataGenerate? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataGenerate',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationMetadataGenerate,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$MetadataGenerate,
       );
}

extension ClientExtension$Mutation$MetadataGenerate on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$MetadataGenerate>>
  mutate$MetadataGenerate(Options$Mutation$MetadataGenerate options) async =>
      await this.mutate(options);

  graphql.ObservableQuery<Mutation$MetadataGenerate>
  watchMutation$MetadataGenerate(
    WatchOptions$Mutation$MetadataGenerate options,
  ) => this.watchMutation(options);
}

class Variables$Mutation$MetadataAutoTag {
  factory Variables$Mutation$MetadataAutoTag({
    required Input$AutoTagMetadataInput input,
  }) => Variables$Mutation$MetadataAutoTag._({r'input': input});

  Variables$Mutation$MetadataAutoTag._(this._$data);

  factory Variables$Mutation$MetadataAutoTag.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$AutoTagMetadataInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$MetadataAutoTag._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$AutoTagMetadataInput get input =>
      (_$data['input'] as Input$AutoTagMetadataInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$MetadataAutoTag ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

class Mutation$MetadataAutoTag {
  Mutation$MetadataAutoTag({
    required this.metadataAutoTag,
    this.$__typename = 'Mutation',
  });

  factory Mutation$MetadataAutoTag.fromJson(Map<String, dynamic> json) {
    final l$metadataAutoTag = json['metadataAutoTag'];
    final l$$__typename = json['__typename'];
    return Mutation$MetadataAutoTag(
      metadataAutoTag: (l$metadataAutoTag as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String metadataAutoTag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$metadataAutoTag = metadataAutoTag;
    _resultData['metadataAutoTag'] = l$metadataAutoTag;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$metadataAutoTag = metadataAutoTag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$metadataAutoTag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$MetadataAutoTag ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$metadataAutoTag = metadataAutoTag;
    final lOther$metadataAutoTag = other.metadataAutoTag;
    if (l$metadataAutoTag != lOther$metadataAutoTag) {
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

const documentNodeMutationMetadataAutoTag = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'MetadataAutoTag'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'AutoTagMetadataInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'metadataAutoTag'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
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
  ],
);
Mutation$MetadataAutoTag _parserFn$Mutation$MetadataAutoTag(
  Map<String, dynamic> data,
) => Mutation$MetadataAutoTag.fromJson(data);
typedef OnMutationCompleted$Mutation$MetadataAutoTag = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$MetadataAutoTag?,
);

class Options$Mutation$MetadataAutoTag
    extends graphql.MutationOptions<Mutation$MetadataAutoTag> {
  Options$Mutation$MetadataAutoTag({
    String? operationName,
    required Variables$Mutation$MetadataAutoTag variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataAutoTag? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$MetadataAutoTag? onCompleted,
    graphql.OnMutationUpdate<Mutation$MetadataAutoTag>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataAutoTag',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$MetadataAutoTag(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationMetadataAutoTag,
         parserFn: _parserFn$Mutation$MetadataAutoTag,
       );

  final OnMutationCompleted$Mutation$MetadataAutoTag? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$MetadataAutoTag
    extends graphql.WatchQueryOptions<Mutation$MetadataAutoTag> {
  WatchOptions$Mutation$MetadataAutoTag({
    String? operationName,
    required Variables$Mutation$MetadataAutoTag variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataAutoTag? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataAutoTag',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationMetadataAutoTag,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$MetadataAutoTag,
       );
}

extension ClientExtension$Mutation$MetadataAutoTag on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$MetadataAutoTag>> mutate$MetadataAutoTag(
    Options$Mutation$MetadataAutoTag options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$MetadataAutoTag>
  watchMutation$MetadataAutoTag(
    WatchOptions$Mutation$MetadataAutoTag options,
  ) => this.watchMutation(options);
}

class Variables$Mutation$MetadataClean {
  factory Variables$Mutation$MetadataClean({
    required Input$CleanMetadataInput input,
  }) => Variables$Mutation$MetadataClean._({r'input': input});

  Variables$Mutation$MetadataClean._(this._$data);

  factory Variables$Mutation$MetadataClean.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$CleanMetadataInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$MetadataClean._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CleanMetadataInput get input =>
      (_$data['input'] as Input$CleanMetadataInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$MetadataClean ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

class Mutation$MetadataClean {
  Mutation$MetadataClean({
    required this.metadataClean,
    this.$__typename = 'Mutation',
  });

  factory Mutation$MetadataClean.fromJson(Map<String, dynamic> json) {
    final l$metadataClean = json['metadataClean'];
    final l$$__typename = json['__typename'];
    return Mutation$MetadataClean(
      metadataClean: (l$metadataClean as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String metadataClean;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$metadataClean = metadataClean;
    _resultData['metadataClean'] = l$metadataClean;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$metadataClean = metadataClean;
    final l$$__typename = $__typename;
    return Object.hashAll([l$metadataClean, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$MetadataClean || runtimeType != other.runtimeType) {
      return false;
    }
    final l$metadataClean = metadataClean;
    final lOther$metadataClean = other.metadataClean;
    if (l$metadataClean != lOther$metadataClean) {
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

const documentNodeMutationMetadataClean = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'MetadataClean'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'CleanMetadataInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'metadataClean'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
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
  ],
);
Mutation$MetadataClean _parserFn$Mutation$MetadataClean(
  Map<String, dynamic> data,
) => Mutation$MetadataClean.fromJson(data);
typedef OnMutationCompleted$Mutation$MetadataClean = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$MetadataClean?,
);

class Options$Mutation$MetadataClean
    extends graphql.MutationOptions<Mutation$MetadataClean> {
  Options$Mutation$MetadataClean({
    String? operationName,
    required Variables$Mutation$MetadataClean variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataClean? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$MetadataClean? onCompleted,
    graphql.OnMutationUpdate<Mutation$MetadataClean>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataClean',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$MetadataClean(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationMetadataClean,
         parserFn: _parserFn$Mutation$MetadataClean,
       );

  final OnMutationCompleted$Mutation$MetadataClean? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$MetadataClean
    extends graphql.WatchQueryOptions<Mutation$MetadataClean> {
  WatchOptions$Mutation$MetadataClean({
    String? operationName,
    required Variables$Mutation$MetadataClean variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$MetadataClean? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'MetadataClean',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationMetadataClean,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$MetadataClean,
       );
}

extension ClientExtension$Mutation$MetadataClean on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$MetadataClean>> mutate$MetadataClean(
    Options$Mutation$MetadataClean options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$MetadataClean> watchMutation$MetadataClean(
    WatchOptions$Mutation$MetadataClean options,
  ) => this.watchMutation(options);
}
