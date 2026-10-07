import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'refs.graphql.dart';

class Variables$Query$FindTags {
  factory Variables$Query$FindTags({
    Input$FindFilterType? filter,
    Input$TagFilterType? tag_filter,
  }) => Variables$Query$FindTags._({
    if (filter != null) r'filter': filter,
    if (tag_filter != null) r'tag_filter': tag_filter,
  });

  Variables$Query$FindTags._(this._$data);

  factory Variables$Query$FindTags.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$FindFilterType.fromJson((l$filter as Map<String, dynamic>));
    }
    if (data.containsKey('tag_filter')) {
      final l$tag_filter = data['tag_filter'];
      result$data['tag_filter'] = l$tag_filter == null
          ? null
          : Input$TagFilterType.fromJson(
              (l$tag_filter as Map<String, dynamic>),
            );
    }
    return Variables$Query$FindTags._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$FindFilterType? get filter =>
      (_$data['filter'] as Input$FindFilterType?);

  Input$TagFilterType? get tag_filter =>
      (_$data['tag_filter'] as Input$TagFilterType?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    if (_$data.containsKey('tag_filter')) {
      final l$tag_filter = tag_filter;
      result$data['tag_filter'] = l$tag_filter?.toJson();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$FindTags ||
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
    final l$tag_filter = tag_filter;
    final lOther$tag_filter = other.tag_filter;
    if (_$data.containsKey('tag_filter') !=
        other._$data.containsKey('tag_filter')) {
      return false;
    }
    if (l$tag_filter != lOther$tag_filter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$filter = filter;
    final l$tag_filter = tag_filter;
    return Object.hashAll([
      _$data.containsKey('filter') ? l$filter : const {},
      _$data.containsKey('tag_filter') ? l$tag_filter : const {},
    ]);
  }
}

class Query$FindTags {
  Query$FindTags({required this.findTags, this.$__typename = 'Query'});

  factory Query$FindTags.fromJson(Map<String, dynamic> json) {
    final l$findTags = json['findTags'];
    final l$$__typename = json['__typename'];
    return Query$FindTags(
      findTags: Query$FindTags$findTags.fromJson(
        (l$findTags as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindTags$findTags findTags;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findTags = findTags;
    _resultData['findTags'] = l$findTags.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findTags = findTags;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findTags, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindTags || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findTags = findTags;
    final lOther$findTags = other.findTags;
    if (l$findTags != lOther$findTags) {
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

const documentNodeQueryFindTags = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindTags'),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tag_filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'TagFilterType'),
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
            name: NameNode(value: 'findTags'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: VariableNode(name: NameNode(value: 'filter')),
              ),
              ArgumentNode(
                name: NameNode(value: 'tag_filter'),
                value: VariableNode(name: NameNode(value: 'tag_filter')),
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
                  name: NameNode(value: 'tags'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'TagFields'),
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
    fragmentDefinitionTagFields,
  ],
);
Query$FindTags _parserFn$Query$FindTags(Map<String, dynamic> data) =>
    Query$FindTags.fromJson(data);
typedef OnQueryComplete$Query$FindTags = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindTags?,
);

class Options$Query$FindTags extends graphql.QueryOptions<Query$FindTags> {
  Options$Query$FindTags({
    String? operationName,
    Variables$Query$FindTags? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindTags? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindTags? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindTags',
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
                 data == null ? null : _parserFn$Query$FindTags(data),
               ),
         onError: onError,
         document: documentNodeQueryFindTags,
         parserFn: _parserFn$Query$FindTags,
       );

  final OnQueryComplete$Query$FindTags? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindTags
    extends graphql.WatchQueryOptions<Query$FindTags> {
  WatchOptions$Query$FindTags({
    String? operationName,
    Variables$Query$FindTags? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindTags? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindTags',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindTags,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindTags,
       );
}

class FetchMoreOptions$Query$FindTags extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindTags({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindTags? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindTags,
       );
}

extension ClientExtension$Query$FindTags on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindTags>> query$FindTags([
    Options$Query$FindTags? options,
  ]) async => await this.query(options ?? Options$Query$FindTags());

  graphql.ObservableQuery<Query$FindTags> watchQuery$FindTags([
    WatchOptions$Query$FindTags? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindTags());

  void writeQuery$FindTags({
    required Query$FindTags data,
    Variables$Query$FindTags? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindTags),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindTags? readQuery$FindTags({
    Variables$Query$FindTags? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindTags),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindTags.fromJson(result);
  }
}

class Query$FindTags$findTags {
  Query$FindTags$findTags({
    required this.count,
    required this.tags,
    this.$__typename = 'FindTagsResultType',
  });

  factory Query$FindTags$findTags.fromJson(Map<String, dynamic> json) {
    final l$count = json['count'];
    final l$tags = json['tags'];
    final l$$__typename = json['__typename'];
    return Query$FindTags$findTags(
      count: (l$count as int),
      tags: (l$tags as List<dynamic>)
          .map((e) => Fragment$TagFields.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final List<Fragment$TagFields> tags;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$tags = tags;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$count,
      Object.hashAll(l$tags.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindTags$findTags || runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (l$tags.length != lOther$tags.length) {
      return false;
    }
    for (int i = 0; i < l$tags.length; i++) {
      final l$tags$entry = l$tags[i];
      final lOther$tags$entry = lOther$tags[i];
      if (l$tags$entry != lOther$tags$entry) {
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

class Variables$Query$FindTag {
  factory Variables$Query$FindTag({required String id}) =>
      Variables$Query$FindTag._({r'id': id});

  Variables$Query$FindTag._(this._$data);

  factory Variables$Query$FindTag.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$FindTag._(result$data);
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
    if (other is! Variables$Query$FindTag || runtimeType != other.runtimeType) {
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

class Query$FindTag {
  Query$FindTag({this.findTag, this.$__typename = 'Query'});

  factory Query$FindTag.fromJson(Map<String, dynamic> json) {
    final l$findTag = json['findTag'];
    final l$$__typename = json['__typename'];
    return Query$FindTag(
      findTag: l$findTag == null
          ? null
          : Query$FindTag$findTag.fromJson((l$findTag as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindTag$findTag? findTag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findTag = findTag;
    _resultData['findTag'] = l$findTag?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findTag = findTag;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findTag, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindTag || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findTag = findTag;
    final lOther$findTag = other.findTag;
    if (l$findTag != lOther$findTag) {
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

const documentNodeQueryFindTag = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindTag'),
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
            name: NameNode(value: 'findTag'),
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
                  name: NameNode(value: 'TagFields'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'description'),
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
    fragmentDefinitionTagFields,
  ],
);
Query$FindTag _parserFn$Query$FindTag(Map<String, dynamic> data) =>
    Query$FindTag.fromJson(data);
typedef OnQueryComplete$Query$FindTag = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindTag?,
);

class Options$Query$FindTag extends graphql.QueryOptions<Query$FindTag> {
  Options$Query$FindTag({
    String? operationName,
    required Variables$Query$FindTag variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindTag? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindTag? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindTag',
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
                 data == null ? null : _parserFn$Query$FindTag(data),
               ),
         onError: onError,
         document: documentNodeQueryFindTag,
         parserFn: _parserFn$Query$FindTag,
       );

  final OnQueryComplete$Query$FindTag? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindTag
    extends graphql.WatchQueryOptions<Query$FindTag> {
  WatchOptions$Query$FindTag({
    String? operationName,
    required Variables$Query$FindTag variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindTag? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindTag',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindTag,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindTag,
       );
}

class FetchMoreOptions$Query$FindTag extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindTag({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$FindTag variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryFindTag,
       );
}

extension ClientExtension$Query$FindTag on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindTag>> query$FindTag(
    Options$Query$FindTag options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$FindTag> watchQuery$FindTag(
    WatchOptions$Query$FindTag options,
  ) => this.watchQuery(options);

  void writeQuery$FindTag({
    required Query$FindTag data,
    required Variables$Query$FindTag variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindTag),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindTag? readQuery$FindTag({
    required Variables$Query$FindTag variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindTag),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindTag.fromJson(result);
  }
}

class Query$FindTag$findTag implements Fragment$TagFields {
  Query$FindTag$findTag({
    required this.id,
    required this.name,
    this.image_path,
    required this.scene_count,
    this.$__typename = 'Tag',
    this.description,
  });

  factory Query$FindTag$findTag.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$image_path = json['image_path'];
    final l$scene_count = json['scene_count'];
    final l$$__typename = json['__typename'];
    final l$description = json['description'];
    return Query$FindTag$findTag(
      id: (l$id as String),
      name: (l$name as String),
      image_path: (l$image_path as String?),
      scene_count: (l$scene_count as int),
      $__typename: (l$$__typename as String),
      description: (l$description as String?),
    );
  }

  final String id;

  final String name;

  final String? image_path;

  final int scene_count;

  final String $__typename;

  final String? description;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$description = description;
    _resultData['description'] = l$description;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$image_path = image_path;
    final l$scene_count = scene_count;
    final l$$__typename = $__typename;
    final l$description = description;
    return Object.hashAll([
      l$id,
      l$name,
      l$image_path,
      l$scene_count,
      l$$__typename,
      l$description,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindTag$findTag || runtimeType != other.runtimeType) {
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
    final l$image_path = image_path;
    final lOther$image_path = other.image_path;
    if (l$image_path != lOther$image_path) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$TagCreate {
  factory Variables$Mutation$TagCreate({required String name}) =>
      Variables$Mutation$TagCreate._({r'name': name});

  Variables$Mutation$TagCreate._(this._$data);

  factory Variables$Mutation$TagCreate.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    return Variables$Mutation$TagCreate._(result$data);
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
    if (other is! Variables$Mutation$TagCreate ||
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

class Mutation$TagCreate {
  Mutation$TagCreate({this.tagCreate, this.$__typename = 'Mutation'});

  factory Mutation$TagCreate.fromJson(Map<String, dynamic> json) {
    final l$tagCreate = json['tagCreate'];
    final l$$__typename = json['__typename'];
    return Mutation$TagCreate(
      tagCreate: l$tagCreate == null
          ? null
          : Fragment$TagFields.fromJson((l$tagCreate as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$TagFields? tagCreate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$tagCreate = tagCreate;
    _resultData['tagCreate'] = l$tagCreate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$tagCreate = tagCreate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$tagCreate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$TagCreate || runtimeType != other.runtimeType) {
      return false;
    }
    final l$tagCreate = tagCreate;
    final lOther$tagCreate = other.tagCreate;
    if (l$tagCreate != lOther$tagCreate) {
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

const documentNodeMutationTagCreate = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'TagCreate'),
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
            name: NameNode(value: 'tagCreate'),
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
                  name: NameNode(value: 'TagFields'),
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
    fragmentDefinitionTagFields,
  ],
);
Mutation$TagCreate _parserFn$Mutation$TagCreate(Map<String, dynamic> data) =>
    Mutation$TagCreate.fromJson(data);
typedef OnMutationCompleted$Mutation$TagCreate = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$TagCreate?,
);

class Options$Mutation$TagCreate
    extends graphql.MutationOptions<Mutation$TagCreate> {
  Options$Mutation$TagCreate({
    String? operationName,
    required Variables$Mutation$TagCreate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$TagCreate? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$TagCreate? onCompleted,
    graphql.OnMutationUpdate<Mutation$TagCreate>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'TagCreate',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$TagCreate(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationTagCreate,
         parserFn: _parserFn$Mutation$TagCreate,
       );

  final OnMutationCompleted$Mutation$TagCreate? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$TagCreate
    extends graphql.WatchQueryOptions<Mutation$TagCreate> {
  WatchOptions$Mutation$TagCreate({
    String? operationName,
    required Variables$Mutation$TagCreate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$TagCreate? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'TagCreate',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationTagCreate,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$TagCreate,
       );
}

extension ClientExtension$Mutation$TagCreate on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$TagCreate>> mutate$TagCreate(
    Options$Mutation$TagCreate options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$TagCreate> watchMutation$TagCreate(
    WatchOptions$Mutation$TagCreate options,
  ) => this.watchMutation(options);
}

class Variables$Mutation$TagEdit {
  factory Variables$Mutation$TagEdit({required Input$TagUpdateInput input}) =>
      Variables$Mutation$TagEdit._({r'input': input});

  Variables$Mutation$TagEdit._(this._$data);

  factory Variables$Mutation$TagEdit.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$TagUpdateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$TagEdit._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$TagUpdateInput get input => (_$data['input'] as Input$TagUpdateInput);

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
    if (other is! Variables$Mutation$TagEdit ||
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

class Mutation$TagEdit {
  Mutation$TagEdit({this.tagUpdate, this.$__typename = 'Mutation'});

  factory Mutation$TagEdit.fromJson(Map<String, dynamic> json) {
    final l$tagUpdate = json['tagUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$TagEdit(
      tagUpdate: l$tagUpdate == null
          ? null
          : Mutation$TagEdit$tagUpdate.fromJson(
              (l$tagUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$TagEdit$tagUpdate? tagUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$tagUpdate = tagUpdate;
    _resultData['tagUpdate'] = l$tagUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$tagUpdate = tagUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$tagUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$TagEdit || runtimeType != other.runtimeType) {
      return false;
    }
    final l$tagUpdate = tagUpdate;
    final lOther$tagUpdate = other.tagUpdate;
    if (l$tagUpdate != lOther$tagUpdate) {
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

const documentNodeMutationTagEdit = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'TagEdit'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'TagUpdateInput'),
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
            name: NameNode(value: 'tagUpdate'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'TagFields'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'description'),
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
    fragmentDefinitionTagFields,
  ],
);
Mutation$TagEdit _parserFn$Mutation$TagEdit(Map<String, dynamic> data) =>
    Mutation$TagEdit.fromJson(data);
typedef OnMutationCompleted$Mutation$TagEdit = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$TagEdit?,
);

class Options$Mutation$TagEdit
    extends graphql.MutationOptions<Mutation$TagEdit> {
  Options$Mutation$TagEdit({
    String? operationName,
    required Variables$Mutation$TagEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$TagEdit? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$TagEdit? onCompleted,
    graphql.OnMutationUpdate<Mutation$TagEdit>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'TagEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$TagEdit(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationTagEdit,
         parserFn: _parserFn$Mutation$TagEdit,
       );

  final OnMutationCompleted$Mutation$TagEdit? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$TagEdit
    extends graphql.WatchQueryOptions<Mutation$TagEdit> {
  WatchOptions$Mutation$TagEdit({
    String? operationName,
    required Variables$Mutation$TagEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$TagEdit? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'TagEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationTagEdit,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$TagEdit,
       );
}

extension ClientExtension$Mutation$TagEdit on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$TagEdit>> mutate$TagEdit(
    Options$Mutation$TagEdit options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$TagEdit> watchMutation$TagEdit(
    WatchOptions$Mutation$TagEdit options,
  ) => this.watchMutation(options);
}

class Mutation$TagEdit$tagUpdate implements Fragment$TagFields {
  Mutation$TagEdit$tagUpdate({
    required this.id,
    required this.name,
    this.image_path,
    required this.scene_count,
    this.$__typename = 'Tag',
    this.description,
  });

  factory Mutation$TagEdit$tagUpdate.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$image_path = json['image_path'];
    final l$scene_count = json['scene_count'];
    final l$$__typename = json['__typename'];
    final l$description = json['description'];
    return Mutation$TagEdit$tagUpdate(
      id: (l$id as String),
      name: (l$name as String),
      image_path: (l$image_path as String?),
      scene_count: (l$scene_count as int),
      $__typename: (l$$__typename as String),
      description: (l$description as String?),
    );
  }

  final String id;

  final String name;

  final String? image_path;

  final int scene_count;

  final String $__typename;

  final String? description;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$description = description;
    _resultData['description'] = l$description;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$image_path = image_path;
    final l$scene_count = scene_count;
    final l$$__typename = $__typename;
    final l$description = description;
    return Object.hashAll([
      l$id,
      l$name,
      l$image_path,
      l$scene_count,
      l$$__typename,
      l$description,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$TagEdit$tagUpdate ||
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
    final l$image_path = image_path;
    final lOther$image_path = other.image_path;
    if (l$image_path != lOther$image_path) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    return true;
  }
}
