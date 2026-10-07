import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'refs.graphql.dart';

class Fragment$GalleryFields {
  Fragment$GalleryFields({
    required this.id,
    this.title,
    this.date,
    this.details,
    required this.image_count,
    required this.paths,
    required this.files,
    this.folder,
    this.studio,
    required this.performers,
    this.$__typename = 'Gallery',
  });

  factory Fragment$GalleryFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$date = json['date'];
    final l$details = json['details'];
    final l$image_count = json['image_count'];
    final l$paths = json['paths'];
    final l$files = json['files'];
    final l$folder = json['folder'];
    final l$studio = json['studio'];
    final l$performers = json['performers'];
    final l$$__typename = json['__typename'];
    return Fragment$GalleryFields(
      id: (l$id as String),
      title: (l$title as String?),
      date: (l$date as String?),
      details: (l$details as String?),
      image_count: (l$image_count as int),
      paths: Fragment$GalleryFields$paths.fromJson(
        (l$paths as Map<String, dynamic>),
      ),
      files: (l$files as List<dynamic>)
          .map(
            (e) => Fragment$GalleryFields$files.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      folder: l$folder == null
          ? null
          : Fragment$GalleryFields$folder.fromJson(
              (l$folder as Map<String, dynamic>),
            ),
      studio: l$studio == null
          ? null
          : Fragment$StudioRef.fromJson((l$studio as Map<String, dynamic>)),
      performers: (l$performers as List<dynamic>)
          .map(
            (e) => Fragment$PerformerRef.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? title;

  final String? date;

  final String? details;

  final int image_count;

  final Fragment$GalleryFields$paths paths;

  final List<Fragment$GalleryFields$files> files;

  final Fragment$GalleryFields$folder? folder;

  final Fragment$StudioRef? studio;

  final List<Fragment$PerformerRef> performers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$date = date;
    _resultData['date'] = l$date;
    final l$details = details;
    _resultData['details'] = l$details;
    final l$image_count = image_count;
    _resultData['image_count'] = l$image_count;
    final l$paths = paths;
    _resultData['paths'] = l$paths.toJson();
    final l$files = files;
    _resultData['files'] = l$files.map((e) => e.toJson()).toList();
    final l$folder = folder;
    _resultData['folder'] = l$folder?.toJson();
    final l$studio = studio;
    _resultData['studio'] = l$studio?.toJson();
    final l$performers = performers;
    _resultData['performers'] = l$performers.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$date = date;
    final l$details = details;
    final l$image_count = image_count;
    final l$paths = paths;
    final l$files = files;
    final l$folder = folder;
    final l$studio = studio;
    final l$performers = performers;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$date,
      l$details,
      l$image_count,
      l$paths,
      Object.hashAll(l$files.map((v) => v)),
      l$folder,
      l$studio,
      Object.hashAll(l$performers.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$GalleryFields || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (l$date != lOther$date) {
      return false;
    }
    final l$details = details;
    final lOther$details = other.details;
    if (l$details != lOther$details) {
      return false;
    }
    final l$image_count = image_count;
    final lOther$image_count = other.image_count;
    if (l$image_count != lOther$image_count) {
      return false;
    }
    final l$paths = paths;
    final lOther$paths = other.paths;
    if (l$paths != lOther$paths) {
      return false;
    }
    final l$files = files;
    final lOther$files = other.files;
    if (l$files.length != lOther$files.length) {
      return false;
    }
    for (int i = 0; i < l$files.length; i++) {
      final l$files$entry = l$files[i];
      final lOther$files$entry = lOther$files[i];
      if (l$files$entry != lOther$files$entry) {
        return false;
      }
    }
    final l$folder = folder;
    final lOther$folder = other.folder;
    if (l$folder != lOther$folder) {
      return false;
    }
    final l$studio = studio;
    final lOther$studio = other.studio;
    if (l$studio != lOther$studio) {
      return false;
    }
    final l$performers = performers;
    final lOther$performers = other.performers;
    if (l$performers.length != lOther$performers.length) {
      return false;
    }
    for (int i = 0; i < l$performers.length; i++) {
      final l$performers$entry = l$performers[i];
      final lOther$performers$entry = lOther$performers[i];
      if (l$performers$entry != lOther$performers$entry) {
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

const fragmentDefinitionGalleryFields = FragmentDefinitionNode(
  name: NameNode(value: 'GalleryFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Gallery'), isNonNull: false),
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
        name: NameNode(value: 'title'),
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
        name: NameNode(value: 'details'),
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
        name: NameNode(value: 'paths'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'cover'),
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
        name: NameNode(value: 'files'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'basename'),
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
        name: NameNode(value: 'folder'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'path'),
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
        name: NameNode(value: 'performers'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'PerformerRef'),
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
const documentNodeFragmentGalleryFields = DocumentNode(
  definitions: [
    fragmentDefinitionGalleryFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
  ],
);

extension ClientExtension$Fragment$GalleryFields on graphql.GraphQLClient {
  void writeFragment$GalleryFields({
    required Fragment$GalleryFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'GalleryFields',
        document: documentNodeFragmentGalleryFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$GalleryFields? readFragment$GalleryFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'GalleryFields',
          document: documentNodeFragmentGalleryFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$GalleryFields.fromJson(result);
  }
}

class Fragment$GalleryFields$paths {
  Fragment$GalleryFields$paths({
    required this.cover,
    this.$__typename = 'GalleryPathsType',
  });

  factory Fragment$GalleryFields$paths.fromJson(Map<String, dynamic> json) {
    final l$cover = json['cover'];
    final l$$__typename = json['__typename'];
    return Fragment$GalleryFields$paths(
      cover: (l$cover as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String cover;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cover = cover;
    _resultData['cover'] = l$cover;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cover = cover;
    final l$$__typename = $__typename;
    return Object.hashAll([l$cover, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$GalleryFields$paths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$cover = cover;
    final lOther$cover = other.cover;
    if (l$cover != lOther$cover) {
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

class Fragment$GalleryFields$files {
  Fragment$GalleryFields$files({
    required this.basename,
    this.$__typename = 'GalleryFile',
  });

  factory Fragment$GalleryFields$files.fromJson(Map<String, dynamic> json) {
    final l$basename = json['basename'];
    final l$$__typename = json['__typename'];
    return Fragment$GalleryFields$files(
      basename: (l$basename as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String basename;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$basename = basename;
    _resultData['basename'] = l$basename;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$basename = basename;
    final l$$__typename = $__typename;
    return Object.hashAll([l$basename, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$GalleryFields$files ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$basename = basename;
    final lOther$basename = other.basename;
    if (l$basename != lOther$basename) {
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

class Fragment$GalleryFields$folder {
  Fragment$GalleryFields$folder({
    required this.path,
    this.$__typename = 'Folder',
  });

  factory Fragment$GalleryFields$folder.fromJson(Map<String, dynamic> json) {
    final l$path = json['path'];
    final l$$__typename = json['__typename'];
    return Fragment$GalleryFields$folder(
      path: (l$path as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$$__typename = $__typename;
    return Object.hashAll([l$path, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$GalleryFields$folder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
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

class Variables$Query$FindGalleries {
  factory Variables$Query$FindGalleries({Input$FindFilterType? filter}) =>
      Variables$Query$FindGalleries._({if (filter != null) r'filter': filter});

  Variables$Query$FindGalleries._(this._$data);

  factory Variables$Query$FindGalleries.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$FindFilterType.fromJson((l$filter as Map<String, dynamic>));
    }
    return Variables$Query$FindGalleries._(result$data);
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
    if (other is! Variables$Query$FindGalleries ||
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

class Query$FindGalleries {
  Query$FindGalleries({
    required this.findGalleries,
    this.$__typename = 'Query',
  });

  factory Query$FindGalleries.fromJson(Map<String, dynamic> json) {
    final l$findGalleries = json['findGalleries'];
    final l$$__typename = json['__typename'];
    return Query$FindGalleries(
      findGalleries: Query$FindGalleries$findGalleries.fromJson(
        (l$findGalleries as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindGalleries$findGalleries findGalleries;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findGalleries = findGalleries;
    _resultData['findGalleries'] = l$findGalleries.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findGalleries = findGalleries;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findGalleries, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindGalleries || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findGalleries = findGalleries;
    final lOther$findGalleries = other.findGalleries;
    if (l$findGalleries != lOther$findGalleries) {
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

const documentNodeQueryFindGalleries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindGalleries'),
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
            name: NameNode(value: 'findGalleries'),
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
                  name: NameNode(value: 'galleries'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'GalleryFields'),
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
    fragmentDefinitionGalleryFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
  ],
);
Query$FindGalleries _parserFn$Query$FindGalleries(Map<String, dynamic> data) =>
    Query$FindGalleries.fromJson(data);
typedef OnQueryComplete$Query$FindGalleries = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindGalleries?,
);

class Options$Query$FindGalleries
    extends graphql.QueryOptions<Query$FindGalleries> {
  Options$Query$FindGalleries({
    String? operationName,
    Variables$Query$FindGalleries? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGalleries? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindGalleries? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindGalleries',
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
                 data == null ? null : _parserFn$Query$FindGalleries(data),
               ),
         onError: onError,
         document: documentNodeQueryFindGalleries,
         parserFn: _parserFn$Query$FindGalleries,
       );

  final OnQueryComplete$Query$FindGalleries? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindGalleries
    extends graphql.WatchQueryOptions<Query$FindGalleries> {
  WatchOptions$Query$FindGalleries({
    String? operationName,
    Variables$Query$FindGalleries? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGalleries? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindGalleries',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindGalleries,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindGalleries,
       );
}

class FetchMoreOptions$Query$FindGalleries extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindGalleries({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindGalleries? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindGalleries,
       );
}

extension ClientExtension$Query$FindGalleries on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindGalleries>> query$FindGalleries([
    Options$Query$FindGalleries? options,
  ]) async => await this.query(options ?? Options$Query$FindGalleries());

  graphql.ObservableQuery<Query$FindGalleries> watchQuery$FindGalleries([
    WatchOptions$Query$FindGalleries? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindGalleries());

  void writeQuery$FindGalleries({
    required Query$FindGalleries data,
    Variables$Query$FindGalleries? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindGalleries),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindGalleries? readQuery$FindGalleries({
    Variables$Query$FindGalleries? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindGalleries),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindGalleries.fromJson(result);
  }
}

class Query$FindGalleries$findGalleries {
  Query$FindGalleries$findGalleries({
    required this.count,
    required this.galleries,
    this.$__typename = 'FindGalleriesResultType',
  });

  factory Query$FindGalleries$findGalleries.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$count = json['count'];
    final l$galleries = json['galleries'];
    final l$$__typename = json['__typename'];
    return Query$FindGalleries$findGalleries(
      count: (l$count as int),
      galleries: (l$galleries as List<dynamic>)
          .map(
            (e) => Fragment$GalleryFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final List<Fragment$GalleryFields> galleries;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$galleries = galleries;
    _resultData['galleries'] = l$galleries.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$galleries = galleries;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$count,
      Object.hashAll(l$galleries.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindGalleries$findGalleries ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
      return false;
    }
    final l$galleries = galleries;
    final lOther$galleries = other.galleries;
    if (l$galleries.length != lOther$galleries.length) {
      return false;
    }
    for (int i = 0; i < l$galleries.length; i++) {
      final l$galleries$entry = l$galleries[i];
      final lOther$galleries$entry = lOther$galleries[i];
      if (l$galleries$entry != lOther$galleries$entry) {
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

class Variables$Query$FindGallery {
  factory Variables$Query$FindGallery({required String id}) =>
      Variables$Query$FindGallery._({r'id': id});

  Variables$Query$FindGallery._(this._$data);

  factory Variables$Query$FindGallery.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$FindGallery._(result$data);
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
    if (other is! Variables$Query$FindGallery ||
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

class Query$FindGallery {
  Query$FindGallery({this.findGallery, this.$__typename = 'Query'});

  factory Query$FindGallery.fromJson(Map<String, dynamic> json) {
    final l$findGallery = json['findGallery'];
    final l$$__typename = json['__typename'];
    return Query$FindGallery(
      findGallery: l$findGallery == null
          ? null
          : Fragment$GalleryFields.fromJson(
              (l$findGallery as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$GalleryFields? findGallery;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findGallery = findGallery;
    _resultData['findGallery'] = l$findGallery?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findGallery = findGallery;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findGallery, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindGallery || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findGallery = findGallery;
    final lOther$findGallery = other.findGallery;
    if (l$findGallery != lOther$findGallery) {
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

const documentNodeQueryFindGallery = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindGallery'),
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
            name: NameNode(value: 'findGallery'),
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
                  name: NameNode(value: 'GalleryFields'),
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
    fragmentDefinitionGalleryFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
  ],
);
Query$FindGallery _parserFn$Query$FindGallery(Map<String, dynamic> data) =>
    Query$FindGallery.fromJson(data);
typedef OnQueryComplete$Query$FindGallery = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindGallery?,
);

class Options$Query$FindGallery
    extends graphql.QueryOptions<Query$FindGallery> {
  Options$Query$FindGallery({
    String? operationName,
    required Variables$Query$FindGallery variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGallery? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindGallery? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindGallery',
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
                 data == null ? null : _parserFn$Query$FindGallery(data),
               ),
         onError: onError,
         document: documentNodeQueryFindGallery,
         parserFn: _parserFn$Query$FindGallery,
       );

  final OnQueryComplete$Query$FindGallery? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindGallery
    extends graphql.WatchQueryOptions<Query$FindGallery> {
  WatchOptions$Query$FindGallery({
    String? operationName,
    required Variables$Query$FindGallery variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindGallery? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindGallery',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindGallery,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindGallery,
       );
}

class FetchMoreOptions$Query$FindGallery extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindGallery({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$FindGallery variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryFindGallery,
       );
}

extension ClientExtension$Query$FindGallery on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindGallery>> query$FindGallery(
    Options$Query$FindGallery options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$FindGallery> watchQuery$FindGallery(
    WatchOptions$Query$FindGallery options,
  ) => this.watchQuery(options);

  void writeQuery$FindGallery({
    required Query$FindGallery data,
    required Variables$Query$FindGallery variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindGallery),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindGallery? readQuery$FindGallery({
    required Variables$Query$FindGallery variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindGallery),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindGallery.fromJson(result);
  }
}

class Variables$Query$GalleryUrls {
  factory Variables$Query$GalleryUrls({required String id}) =>
      Variables$Query$GalleryUrls._({r'id': id});

  Variables$Query$GalleryUrls._(this._$data);

  factory Variables$Query$GalleryUrls.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$GalleryUrls._(result$data);
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
    if (other is! Variables$Query$GalleryUrls ||
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

class Query$GalleryUrls {
  Query$GalleryUrls({this.findGallery, this.$__typename = 'Query'});

  factory Query$GalleryUrls.fromJson(Map<String, dynamic> json) {
    final l$findGallery = json['findGallery'];
    final l$$__typename = json['__typename'];
    return Query$GalleryUrls(
      findGallery: l$findGallery == null
          ? null
          : Query$GalleryUrls$findGallery.fromJson(
              (l$findGallery as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GalleryUrls$findGallery? findGallery;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findGallery = findGallery;
    _resultData['findGallery'] = l$findGallery?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findGallery = findGallery;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findGallery, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GalleryUrls || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findGallery = findGallery;
    final lOther$findGallery = other.findGallery;
    if (l$findGallery != lOther$findGallery) {
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

const documentNodeQueryGalleryUrls = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GalleryUrls'),
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
            name: NameNode(value: 'findGallery'),
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
                  name: NameNode(value: 'urls'),
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
Query$GalleryUrls _parserFn$Query$GalleryUrls(Map<String, dynamic> data) =>
    Query$GalleryUrls.fromJson(data);
typedef OnQueryComplete$Query$GalleryUrls = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$GalleryUrls?,
);

class Options$Query$GalleryUrls
    extends graphql.QueryOptions<Query$GalleryUrls> {
  Options$Query$GalleryUrls({
    String? operationName,
    required Variables$Query$GalleryUrls variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GalleryUrls? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GalleryUrls? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'GalleryUrls',
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
                 data == null ? null : _parserFn$Query$GalleryUrls(data),
               ),
         onError: onError,
         document: documentNodeQueryGalleryUrls,
         parserFn: _parserFn$Query$GalleryUrls,
       );

  final OnQueryComplete$Query$GalleryUrls? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$GalleryUrls
    extends graphql.WatchQueryOptions<Query$GalleryUrls> {
  WatchOptions$Query$GalleryUrls({
    String? operationName,
    required Variables$Query$GalleryUrls variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GalleryUrls? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'GalleryUrls',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryGalleryUrls,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$GalleryUrls,
       );
}

class FetchMoreOptions$Query$GalleryUrls extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GalleryUrls({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GalleryUrls variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryGalleryUrls,
       );
}

extension ClientExtension$Query$GalleryUrls on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GalleryUrls>> query$GalleryUrls(
    Options$Query$GalleryUrls options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$GalleryUrls> watchQuery$GalleryUrls(
    WatchOptions$Query$GalleryUrls options,
  ) => this.watchQuery(options);

  void writeQuery$GalleryUrls({
    required Query$GalleryUrls data,
    required Variables$Query$GalleryUrls variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryGalleryUrls),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$GalleryUrls? readQuery$GalleryUrls({
    required Variables$Query$GalleryUrls variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryGalleryUrls),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$GalleryUrls.fromJson(result);
  }
}

class Query$GalleryUrls$findGallery {
  Query$GalleryUrls$findGallery({
    required this.id,
    required this.urls,
    this.$__typename = 'Gallery',
  });

  factory Query$GalleryUrls$findGallery.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$urls = json['urls'];
    final l$$__typename = json['__typename'];
    return Query$GalleryUrls$findGallery(
      id: (l$id as String),
      urls: (l$urls as List<dynamic>).map((e) => (e as String)).toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<String> urls;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$urls = urls;
    _resultData['urls'] = l$urls.map((e) => e).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$urls = urls;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$urls.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GalleryUrls$findGallery ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$urls = urls;
    final lOther$urls = other.urls;
    if (l$urls.length != lOther$urls.length) {
      return false;
    }
    for (int i = 0; i < l$urls.length; i++) {
      final l$urls$entry = l$urls[i];
      final lOther$urls$entry = lOther$urls[i];
      if (l$urls$entry != lOther$urls$entry) {
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

class Variables$Mutation$GalleryEdit {
  factory Variables$Mutation$GalleryEdit({
    required Input$GalleryUpdateInput input,
  }) => Variables$Mutation$GalleryEdit._({r'input': input});

  Variables$Mutation$GalleryEdit._(this._$data);

  factory Variables$Mutation$GalleryEdit.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$GalleryUpdateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$GalleryEdit._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$GalleryUpdateInput get input =>
      (_$data['input'] as Input$GalleryUpdateInput);

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
    if (other is! Variables$Mutation$GalleryEdit ||
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

class Mutation$GalleryEdit {
  Mutation$GalleryEdit({this.galleryUpdate, this.$__typename = 'Mutation'});

  factory Mutation$GalleryEdit.fromJson(Map<String, dynamic> json) {
    final l$galleryUpdate = json['galleryUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$GalleryEdit(
      galleryUpdate: l$galleryUpdate == null
          ? null
          : Fragment$GalleryFields.fromJson(
              (l$galleryUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$GalleryFields? galleryUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$galleryUpdate = galleryUpdate;
    _resultData['galleryUpdate'] = l$galleryUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$galleryUpdate = galleryUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$galleryUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$GalleryEdit || runtimeType != other.runtimeType) {
      return false;
    }
    final l$galleryUpdate = galleryUpdate;
    final lOther$galleryUpdate = other.galleryUpdate;
    if (l$galleryUpdate != lOther$galleryUpdate) {
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

const documentNodeMutationGalleryEdit = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'GalleryEdit'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'GalleryUpdateInput'),
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
            name: NameNode(value: 'galleryUpdate'),
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
                  name: NameNode(value: 'GalleryFields'),
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
    fragmentDefinitionGalleryFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
  ],
);
Mutation$GalleryEdit _parserFn$Mutation$GalleryEdit(
  Map<String, dynamic> data,
) => Mutation$GalleryEdit.fromJson(data);
typedef OnMutationCompleted$Mutation$GalleryEdit = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$GalleryEdit?,
);

class Options$Mutation$GalleryEdit
    extends graphql.MutationOptions<Mutation$GalleryEdit> {
  Options$Mutation$GalleryEdit({
    String? operationName,
    required Variables$Mutation$GalleryEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$GalleryEdit? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$GalleryEdit? onCompleted,
    graphql.OnMutationUpdate<Mutation$GalleryEdit>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'GalleryEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$GalleryEdit(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationGalleryEdit,
         parserFn: _parserFn$Mutation$GalleryEdit,
       );

  final OnMutationCompleted$Mutation$GalleryEdit? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$GalleryEdit
    extends graphql.WatchQueryOptions<Mutation$GalleryEdit> {
  WatchOptions$Mutation$GalleryEdit({
    String? operationName,
    required Variables$Mutation$GalleryEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$GalleryEdit? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'GalleryEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationGalleryEdit,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$GalleryEdit,
       );
}

extension ClientExtension$Mutation$GalleryEdit on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$GalleryEdit>> mutate$GalleryEdit(
    Options$Mutation$GalleryEdit options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$GalleryEdit> watchMutation$GalleryEdit(
    WatchOptions$Mutation$GalleryEdit options,
  ) => this.watchMutation(options);
}
