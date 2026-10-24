import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'refs.graphql.dart';

class Fragment$StudioFields implements Fragment$StudioRef {
  Fragment$StudioFields({
    required this.id,
    required this.name,
    this.image_path,
    this.$__typename = 'Studio',
    this.url,
    required this.scene_count,
    this.parent_studio,
  });

  factory Fragment$StudioFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$image_path = json['image_path'];
    final l$$__typename = json['__typename'];
    final l$url = json['url'];
    final l$scene_count = json['scene_count'];
    final l$parent_studio = json['parent_studio'];
    return Fragment$StudioFields(
      id: (l$id as String),
      name: (l$name as String),
      image_path: (l$image_path as String?),
      $__typename: (l$$__typename as String),
      url: (l$url as String?),
      scene_count: (l$scene_count as int),
      parent_studio: l$parent_studio == null
          ? null
          : Fragment$StudioRef.fromJson(
              (l$parent_studio as Map<String, dynamic>),
            ),
    );
  }

  final String id;

  final String name;

  final String? image_path;

  final String $__typename;

  @Deprecated('Use urls')
  final String? url;

  final int scene_count;

  final Fragment$StudioRef? parent_studio;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$parent_studio = parent_studio;
    _resultData['parent_studio'] = l$parent_studio?.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$image_path = image_path;
    final l$$__typename = $__typename;
    final l$url = url;
    final l$scene_count = scene_count;
    final l$parent_studio = parent_studio;
    return Object.hashAll([
      l$id,
      l$name,
      l$image_path,
      l$$__typename,
      l$url,
      l$scene_count,
      l$parent_studio,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$StudioFields || runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    final l$parent_studio = parent_studio;
    final lOther$parent_studio = other.parent_studio;
    if (l$parent_studio != lOther$parent_studio) {
      return false;
    }
    return true;
  }
}

const fragmentDefinitionStudioFields = FragmentDefinitionNode(
  name: NameNode(value: 'StudioFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Studio'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FragmentSpreadNode(
        name: NameNode(value: 'StudioRef'),
        directives: [],
      ),
      FieldNode(
        name: NameNode(value: 'url'),
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
        name: NameNode(value: 'parent_studio'),
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
const documentNodeFragmentStudioFields = DocumentNode(
  definitions: [fragmentDefinitionStudioFields, fragmentDefinitionStudioRef],
);

extension ClientExtension$Fragment$StudioFields on graphql.GraphQLClient {
  void writeFragment$StudioFields({
    required Fragment$StudioFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'StudioFields',
        document: documentNodeFragmentStudioFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$StudioFields? readFragment$StudioFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'StudioFields',
          document: documentNodeFragmentStudioFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$StudioFields.fromJson(result);
  }
}

class Fragment$StudioDetails
    implements Fragment$StudioFields, Fragment$StudioRef {
  Fragment$StudioDetails({
    required this.id,
    required this.name,
    this.image_path,
    this.$__typename = 'Studio',
    this.url,
    required this.scene_count,
    this.parent_studio,
    this.details,
    required this.child_studios,
  });

  factory Fragment$StudioDetails.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$image_path = json['image_path'];
    final l$$__typename = json['__typename'];
    final l$url = json['url'];
    final l$scene_count = json['scene_count'];
    final l$parent_studio = json['parent_studio'];
    final l$details = json['details'];
    final l$child_studios = json['child_studios'];
    return Fragment$StudioDetails(
      id: (l$id as String),
      name: (l$name as String),
      image_path: (l$image_path as String?),
      $__typename: (l$$__typename as String),
      url: (l$url as String?),
      scene_count: (l$scene_count as int),
      parent_studio: l$parent_studio == null
          ? null
          : Fragment$StudioRef.fromJson(
              (l$parent_studio as Map<String, dynamic>),
            ),
      details: (l$details as String?),
      child_studios: (l$child_studios as List<dynamic>)
          .map(
            (e) => Fragment$StudioDetails$child_studios.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String name;

  final String? image_path;

  final String $__typename;

  @Deprecated('Use urls')
  final String? url;

  final int scene_count;

  final Fragment$StudioRef? parent_studio;

  final String? details;

  final List<Fragment$StudioDetails$child_studios> child_studios;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$parent_studio = parent_studio;
    _resultData['parent_studio'] = l$parent_studio?.toJson();
    final l$details = details;
    _resultData['details'] = l$details;
    final l$child_studios = child_studios;
    _resultData['child_studios'] = l$child_studios
        .map((e) => e.toJson())
        .toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$image_path = image_path;
    final l$$__typename = $__typename;
    final l$url = url;
    final l$scene_count = scene_count;
    final l$parent_studio = parent_studio;
    final l$details = details;
    final l$child_studios = child_studios;
    return Object.hashAll([
      l$id,
      l$name,
      l$image_path,
      l$$__typename,
      l$url,
      l$scene_count,
      l$parent_studio,
      l$details,
      Object.hashAll(l$child_studios.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$StudioDetails || runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    final l$parent_studio = parent_studio;
    final lOther$parent_studio = other.parent_studio;
    if (l$parent_studio != lOther$parent_studio) {
      return false;
    }
    final l$details = details;
    final lOther$details = other.details;
    if (l$details != lOther$details) {
      return false;
    }
    final l$child_studios = child_studios;
    final lOther$child_studios = other.child_studios;
    if (l$child_studios.length != lOther$child_studios.length) {
      return false;
    }
    for (int i = 0; i < l$child_studios.length; i++) {
      final l$child_studios$entry = l$child_studios[i];
      final lOther$child_studios$entry = lOther$child_studios[i];
      if (l$child_studios$entry != lOther$child_studios$entry) {
        return false;
      }
    }
    return true;
  }
}

const fragmentDefinitionStudioDetails = FragmentDefinitionNode(
  name: NameNode(value: 'StudioDetails'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Studio'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FragmentSpreadNode(
        name: NameNode(value: 'StudioFields'),
        directives: [],
      ),
      FieldNode(
        name: NameNode(value: 'details'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'child_studios'),
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
              name: NameNode(value: 'scene_count'),
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
);
const documentNodeFragmentStudioDetails = DocumentNode(
  definitions: [
    fragmentDefinitionStudioDetails,
    fragmentDefinitionStudioFields,
    fragmentDefinitionStudioRef,
  ],
);

extension ClientExtension$Fragment$StudioDetails on graphql.GraphQLClient {
  void writeFragment$StudioDetails({
    required Fragment$StudioDetails data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'StudioDetails',
        document: documentNodeFragmentStudioDetails,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$StudioDetails? readFragment$StudioDetails({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'StudioDetails',
          document: documentNodeFragmentStudioDetails,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$StudioDetails.fromJson(result);
  }
}

class Fragment$StudioDetails$child_studios implements Fragment$StudioRef {
  Fragment$StudioDetails$child_studios({
    required this.id,
    required this.name,
    this.image_path,
    this.$__typename = 'Studio',
    required this.scene_count,
  });

  factory Fragment$StudioDetails$child_studios.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$image_path = json['image_path'];
    final l$$__typename = json['__typename'];
    final l$scene_count = json['scene_count'];
    return Fragment$StudioDetails$child_studios(
      id: (l$id as String),
      name: (l$name as String),
      image_path: (l$image_path as String?),
      $__typename: (l$$__typename as String),
      scene_count: (l$scene_count as int),
    );
  }

  final String id;

  final String name;

  final String? image_path;

  final String $__typename;

  final int scene_count;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$image_path = image_path;
    final l$$__typename = $__typename;
    final l$scene_count = scene_count;
    return Object.hashAll([
      l$id,
      l$name,
      l$image_path,
      l$$__typename,
      l$scene_count,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$StudioDetails$child_studios ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$scene_count = scene_count;
    final lOther$scene_count = other.scene_count;
    if (l$scene_count != lOther$scene_count) {
      return false;
    }
    return true;
  }
}

class Variables$Query$FindStudios {
  factory Variables$Query$FindStudios({Input$FindFilterType? filter}) =>
      Variables$Query$FindStudios._({if (filter != null) r'filter': filter});

  Variables$Query$FindStudios._(this._$data);

  factory Variables$Query$FindStudios.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$FindFilterType.fromJson((l$filter as Map<String, dynamic>));
    }
    return Variables$Query$FindStudios._(result$data);
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
    if (other is! Variables$Query$FindStudios ||
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

class Query$FindStudios {
  Query$FindStudios({required this.findStudios, this.$__typename = 'Query'});

  factory Query$FindStudios.fromJson(Map<String, dynamic> json) {
    final l$findStudios = json['findStudios'];
    final l$$__typename = json['__typename'];
    return Query$FindStudios(
      findStudios: Query$FindStudios$findStudios.fromJson(
        (l$findStudios as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindStudios$findStudios findStudios;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findStudios = findStudios;
    _resultData['findStudios'] = l$findStudios.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findStudios = findStudios;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findStudios, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindStudios || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findStudios = findStudios;
    final lOther$findStudios = other.findStudios;
    if (l$findStudios != lOther$findStudios) {
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

const documentNodeQueryFindStudios = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindStudios'),
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
            name: NameNode(value: 'findStudios'),
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
                  name: NameNode(value: 'studios'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'StudioFields'),
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
    fragmentDefinitionStudioFields,
    fragmentDefinitionStudioRef,
  ],
);
Query$FindStudios _parserFn$Query$FindStudios(Map<String, dynamic> data) =>
    Query$FindStudios.fromJson(data);
typedef OnQueryComplete$Query$FindStudios = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindStudios?,
);

class Options$Query$FindStudios
    extends graphql.QueryOptions<Query$FindStudios> {
  Options$Query$FindStudios({
    String? operationName,
    Variables$Query$FindStudios? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindStudios? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindStudios? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindStudios',
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
                 data == null ? null : _parserFn$Query$FindStudios(data),
               ),
         onError: onError,
         document: documentNodeQueryFindStudios,
         parserFn: _parserFn$Query$FindStudios,
       );

  final OnQueryComplete$Query$FindStudios? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindStudios
    extends graphql.WatchQueryOptions<Query$FindStudios> {
  WatchOptions$Query$FindStudios({
    String? operationName,
    Variables$Query$FindStudios? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindStudios? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindStudios',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindStudios,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindStudios,
       );
}

class FetchMoreOptions$Query$FindStudios extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindStudios({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindStudios? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindStudios,
       );
}

extension ClientExtension$Query$FindStudios on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindStudios>> query$FindStudios([
    Options$Query$FindStudios? options,
  ]) async => await this.query(options ?? Options$Query$FindStudios());

  graphql.ObservableQuery<Query$FindStudios> watchQuery$FindStudios([
    WatchOptions$Query$FindStudios? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindStudios());

  void writeQuery$FindStudios({
    required Query$FindStudios data,
    Variables$Query$FindStudios? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindStudios),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindStudios? readQuery$FindStudios({
    Variables$Query$FindStudios? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindStudios),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindStudios.fromJson(result);
  }
}

class Query$FindStudios$findStudios {
  Query$FindStudios$findStudios({
    required this.count,
    required this.studios,
    this.$__typename = 'FindStudiosResultType',
  });

  factory Query$FindStudios$findStudios.fromJson(Map<String, dynamic> json) {
    final l$count = json['count'];
    final l$studios = json['studios'];
    final l$$__typename = json['__typename'];
    return Query$FindStudios$findStudios(
      count: (l$count as int),
      studios: (l$studios as List<dynamic>)
          .map(
            (e) => Fragment$StudioFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final List<Fragment$StudioFields> studios;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$studios = studios;
    _resultData['studios'] = l$studios.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$studios = studios;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$count,
      Object.hashAll(l$studios.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindStudios$findStudios ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
      return false;
    }
    final l$studios = studios;
    final lOther$studios = other.studios;
    if (l$studios.length != lOther$studios.length) {
      return false;
    }
    for (int i = 0; i < l$studios.length; i++) {
      final l$studios$entry = l$studios[i];
      final lOther$studios$entry = lOther$studios[i];
      if (l$studios$entry != lOther$studios$entry) {
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

class Variables$Query$FindStudio {
  factory Variables$Query$FindStudio({required String id}) =>
      Variables$Query$FindStudio._({r'id': id});

  Variables$Query$FindStudio._(this._$data);

  factory Variables$Query$FindStudio.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$FindStudio._(result$data);
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
    if (other is! Variables$Query$FindStudio ||
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

class Query$FindStudio {
  Query$FindStudio({this.findStudio, this.$__typename = 'Query'});

  factory Query$FindStudio.fromJson(Map<String, dynamic> json) {
    final l$findStudio = json['findStudio'];
    final l$$__typename = json['__typename'];
    return Query$FindStudio(
      findStudio: l$findStudio == null
          ? null
          : Fragment$StudioDetails.fromJson(
              (l$findStudio as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$StudioDetails? findStudio;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findStudio = findStudio;
    _resultData['findStudio'] = l$findStudio?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findStudio = findStudio;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findStudio, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindStudio || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findStudio = findStudio;
    final lOther$findStudio = other.findStudio;
    if (l$findStudio != lOther$findStudio) {
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

const documentNodeQueryFindStudio = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindStudio'),
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
            name: NameNode(value: 'findStudio'),
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
                  name: NameNode(value: 'StudioDetails'),
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
    fragmentDefinitionStudioDetails,
    fragmentDefinitionStudioFields,
    fragmentDefinitionStudioRef,
  ],
);
Query$FindStudio _parserFn$Query$FindStudio(Map<String, dynamic> data) =>
    Query$FindStudio.fromJson(data);
typedef OnQueryComplete$Query$FindStudio = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindStudio?,
);

class Options$Query$FindStudio extends graphql.QueryOptions<Query$FindStudio> {
  Options$Query$FindStudio({
    String? operationName,
    required Variables$Query$FindStudio variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindStudio? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindStudio? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindStudio',
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
                 data == null ? null : _parserFn$Query$FindStudio(data),
               ),
         onError: onError,
         document: documentNodeQueryFindStudio,
         parserFn: _parserFn$Query$FindStudio,
       );

  final OnQueryComplete$Query$FindStudio? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindStudio
    extends graphql.WatchQueryOptions<Query$FindStudio> {
  WatchOptions$Query$FindStudio({
    String? operationName,
    required Variables$Query$FindStudio variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindStudio? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindStudio',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindStudio,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindStudio,
       );
}

class FetchMoreOptions$Query$FindStudio extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindStudio({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$FindStudio variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryFindStudio,
       );
}

extension ClientExtension$Query$FindStudio on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindStudio>> query$FindStudio(
    Options$Query$FindStudio options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$FindStudio> watchQuery$FindStudio(
    WatchOptions$Query$FindStudio options,
  ) => this.watchQuery(options);

  void writeQuery$FindStudio({
    required Query$FindStudio data,
    required Variables$Query$FindStudio variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindStudio),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindStudio? readQuery$FindStudio({
    required Variables$Query$FindStudio variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindStudio),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindStudio.fromJson(result);
  }
}

class Variables$Query$StudioMediaCounts {
  factory Variables$Query$StudioMediaCounts({required String id}) =>
      Variables$Query$StudioMediaCounts._({r'id': id});

  Variables$Query$StudioMediaCounts._(this._$data);

  factory Variables$Query$StudioMediaCounts.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$StudioMediaCounts._(result$data);
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
    if (other is! Variables$Query$StudioMediaCounts ||
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

class Query$StudioMediaCounts {
  Query$StudioMediaCounts({this.findStudio, this.$__typename = 'Query'});

  factory Query$StudioMediaCounts.fromJson(Map<String, dynamic> json) {
    final l$findStudio = json['findStudio'];
    final l$$__typename = json['__typename'];
    return Query$StudioMediaCounts(
      findStudio: l$findStudio == null
          ? null
          : Query$StudioMediaCounts$findStudio.fromJson(
              (l$findStudio as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$StudioMediaCounts$findStudio? findStudio;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findStudio = findStudio;
    _resultData['findStudio'] = l$findStudio?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findStudio = findStudio;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findStudio, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$StudioMediaCounts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findStudio = findStudio;
    final lOther$findStudio = other.findStudio;
    if (l$findStudio != lOther$findStudio) {
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

const documentNodeQueryStudioMediaCounts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'StudioMediaCounts'),
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
            name: NameNode(value: 'findStudio'),
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
                  name: NameNode(value: 'image_count'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'depth'),
                      value: IntValueNode(value: '-1'),
                    ),
                  ],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'gallery_count'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'depth'),
                      value: IntValueNode(value: '-1'),
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
Query$StudioMediaCounts _parserFn$Query$StudioMediaCounts(
  Map<String, dynamic> data,
) => Query$StudioMediaCounts.fromJson(data);
typedef OnQueryComplete$Query$StudioMediaCounts = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$StudioMediaCounts?,
);

class Options$Query$StudioMediaCounts
    extends graphql.QueryOptions<Query$StudioMediaCounts> {
  Options$Query$StudioMediaCounts({
    String? operationName,
    required Variables$Query$StudioMediaCounts variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$StudioMediaCounts? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$StudioMediaCounts? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'StudioMediaCounts',
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
                 data == null ? null : _parserFn$Query$StudioMediaCounts(data),
               ),
         onError: onError,
         document: documentNodeQueryStudioMediaCounts,
         parserFn: _parserFn$Query$StudioMediaCounts,
       );

  final OnQueryComplete$Query$StudioMediaCounts? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$StudioMediaCounts
    extends graphql.WatchQueryOptions<Query$StudioMediaCounts> {
  WatchOptions$Query$StudioMediaCounts({
    String? operationName,
    required Variables$Query$StudioMediaCounts variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$StudioMediaCounts? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'StudioMediaCounts',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryStudioMediaCounts,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$StudioMediaCounts,
       );
}

class FetchMoreOptions$Query$StudioMediaCounts
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$StudioMediaCounts({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$StudioMediaCounts variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryStudioMediaCounts,
       );
}

extension ClientExtension$Query$StudioMediaCounts on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$StudioMediaCounts>> query$StudioMediaCounts(
    Options$Query$StudioMediaCounts options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$StudioMediaCounts> watchQuery$StudioMediaCounts(
    WatchOptions$Query$StudioMediaCounts options,
  ) => this.watchQuery(options);

  void writeQuery$StudioMediaCounts({
    required Query$StudioMediaCounts data,
    required Variables$Query$StudioMediaCounts variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryStudioMediaCounts,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$StudioMediaCounts? readQuery$StudioMediaCounts({
    required Variables$Query$StudioMediaCounts variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryStudioMediaCounts,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$StudioMediaCounts.fromJson(result);
  }
}

class Query$StudioMediaCounts$findStudio {
  Query$StudioMediaCounts$findStudio({
    required this.id,
    required this.image_count,
    required this.gallery_count,
    this.$__typename = 'Studio',
  });

  factory Query$StudioMediaCounts$findStudio.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$image_count = json['image_count'];
    final l$gallery_count = json['gallery_count'];
    final l$$__typename = json['__typename'];
    return Query$StudioMediaCounts$findStudio(
      id: (l$id as String),
      image_count: (l$image_count as int),
      gallery_count: (l$gallery_count as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int image_count;

  final int gallery_count;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$image_count = image_count;
    _resultData['image_count'] = l$image_count;
    final l$gallery_count = gallery_count;
    _resultData['gallery_count'] = l$gallery_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$image_count = image_count;
    final l$gallery_count = gallery_count;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$image_count,
      l$gallery_count,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$StudioMediaCounts$findStudio ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$image_count = image_count;
    final lOther$image_count = other.image_count;
    if (l$image_count != lOther$image_count) {
      return false;
    }
    final l$gallery_count = gallery_count;
    final lOther$gallery_count = other.gallery_count;
    if (l$gallery_count != lOther$gallery_count) {
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

class Variables$Mutation$StudioEdit {
  factory Variables$Mutation$StudioEdit({
    required Input$StudioUpdateInput input,
  }) => Variables$Mutation$StudioEdit._({r'input': input});

  Variables$Mutation$StudioEdit._(this._$data);

  factory Variables$Mutation$StudioEdit.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$StudioUpdateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$StudioEdit._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$StudioUpdateInput get input =>
      (_$data['input'] as Input$StudioUpdateInput);

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
    if (other is! Variables$Mutation$StudioEdit ||
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

class Mutation$StudioEdit {
  Mutation$StudioEdit({this.studioUpdate, this.$__typename = 'Mutation'});

  factory Mutation$StudioEdit.fromJson(Map<String, dynamic> json) {
    final l$studioUpdate = json['studioUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$StudioEdit(
      studioUpdate: l$studioUpdate == null
          ? null
          : Fragment$StudioDetails.fromJson(
              (l$studioUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$StudioDetails? studioUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$studioUpdate = studioUpdate;
    _resultData['studioUpdate'] = l$studioUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$studioUpdate = studioUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$studioUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$StudioEdit || runtimeType != other.runtimeType) {
      return false;
    }
    final l$studioUpdate = studioUpdate;
    final lOther$studioUpdate = other.studioUpdate;
    if (l$studioUpdate != lOther$studioUpdate) {
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

const documentNodeMutationStudioEdit = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'StudioEdit'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'StudioUpdateInput'),
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
            name: NameNode(value: 'studioUpdate'),
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
                  name: NameNode(value: 'StudioDetails'),
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
    fragmentDefinitionStudioDetails,
    fragmentDefinitionStudioFields,
    fragmentDefinitionStudioRef,
  ],
);
Mutation$StudioEdit _parserFn$Mutation$StudioEdit(Map<String, dynamic> data) =>
    Mutation$StudioEdit.fromJson(data);
typedef OnMutationCompleted$Mutation$StudioEdit = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$StudioEdit?,
);

class Options$Mutation$StudioEdit
    extends graphql.MutationOptions<Mutation$StudioEdit> {
  Options$Mutation$StudioEdit({
    String? operationName,
    required Variables$Mutation$StudioEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$StudioEdit? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$StudioEdit? onCompleted,
    graphql.OnMutationUpdate<Mutation$StudioEdit>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'StudioEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$StudioEdit(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationStudioEdit,
         parserFn: _parserFn$Mutation$StudioEdit,
       );

  final OnMutationCompleted$Mutation$StudioEdit? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$StudioEdit
    extends graphql.WatchQueryOptions<Mutation$StudioEdit> {
  WatchOptions$Mutation$StudioEdit({
    String? operationName,
    required Variables$Mutation$StudioEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$StudioEdit? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'StudioEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationStudioEdit,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$StudioEdit,
       );
}

extension ClientExtension$Mutation$StudioEdit on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$StudioEdit>> mutate$StudioEdit(
    Options$Mutation$StudioEdit options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$StudioEdit> watchMutation$StudioEdit(
    WatchOptions$Mutation$StudioEdit options,
  ) => this.watchMutation(options);
}
