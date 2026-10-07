import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Fragment$PerformerFields {
  Fragment$PerformerFields({
    required this.id,
    required this.name,
    this.disambiguation,
    this.image_path,
    this.country,
    this.birthdate,
    this.gender,
    required this.favorite,
    this.rating100,
    required this.scene_count,
    this.$__typename = 'Performer',
  });

  factory Fragment$PerformerFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$disambiguation = json['disambiguation'];
    final l$image_path = json['image_path'];
    final l$country = json['country'];
    final l$birthdate = json['birthdate'];
    final l$gender = json['gender'];
    final l$favorite = json['favorite'];
    final l$rating100 = json['rating100'];
    final l$scene_count = json['scene_count'];
    final l$$__typename = json['__typename'];
    return Fragment$PerformerFields(
      id: (l$id as String),
      name: (l$name as String),
      disambiguation: (l$disambiguation as String?),
      image_path: (l$image_path as String?),
      country: (l$country as String?),
      birthdate: (l$birthdate as String?),
      gender: l$gender == null
          ? null
          : fromJson$Enum$GenderEnum((l$gender as String)),
      favorite: (l$favorite as bool),
      rating100: (l$rating100 as int?),
      scene_count: (l$scene_count as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String? disambiguation;

  final String? image_path;

  final String? country;

  final String? birthdate;

  final Enum$GenderEnum? gender;

  final bool favorite;

  final int? rating100;

  final int scene_count;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$disambiguation = disambiguation;
    _resultData['disambiguation'] = l$disambiguation;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$country = country;
    _resultData['country'] = l$country;
    final l$birthdate = birthdate;
    _resultData['birthdate'] = l$birthdate;
    final l$gender = gender;
    _resultData['gender'] = l$gender == null
        ? null
        : toJson$Enum$GenderEnum(l$gender);
    final l$favorite = favorite;
    _resultData['favorite'] = l$favorite;
    final l$rating100 = rating100;
    _resultData['rating100'] = l$rating100;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$disambiguation = disambiguation;
    final l$image_path = image_path;
    final l$country = country;
    final l$birthdate = birthdate;
    final l$gender = gender;
    final l$favorite = favorite;
    final l$rating100 = rating100;
    final l$scene_count = scene_count;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$disambiguation,
      l$image_path,
      l$country,
      l$birthdate,
      l$gender,
      l$favorite,
      l$rating100,
      l$scene_count,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$PerformerFields ||
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
    final l$disambiguation = disambiguation;
    final lOther$disambiguation = other.disambiguation;
    if (l$disambiguation != lOther$disambiguation) {
      return false;
    }
    final l$image_path = image_path;
    final lOther$image_path = other.image_path;
    if (l$image_path != lOther$image_path) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$birthdate = birthdate;
    final lOther$birthdate = other.birthdate;
    if (l$birthdate != lOther$birthdate) {
      return false;
    }
    final l$gender = gender;
    final lOther$gender = other.gender;
    if (l$gender != lOther$gender) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (l$favorite != lOther$favorite) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (l$rating100 != lOther$rating100) {
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
    return true;
  }
}

const fragmentDefinitionPerformerFields = FragmentDefinitionNode(
  name: NameNode(value: 'PerformerFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Performer'), isNonNull: false),
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
        name: NameNode(value: 'disambiguation'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'image_path'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'country'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'birthdate'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'gender'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'favorite'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'rating100'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentPerformerFields = DocumentNode(
  definitions: [fragmentDefinitionPerformerFields],
);

extension ClientExtension$Fragment$PerformerFields on graphql.GraphQLClient {
  void writeFragment$PerformerFields({
    required Fragment$PerformerFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'PerformerFields',
        document: documentNodeFragmentPerformerFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$PerformerFields? readFragment$PerformerFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'PerformerFields',
          document: documentNodeFragmentPerformerFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$PerformerFields.fromJson(result);
  }
}

class Variables$Query$FindPerformers {
  factory Variables$Query$FindPerformers({
    Input$FindFilterType? filter,
    Input$PerformerFilterType? performer_filter,
  }) => Variables$Query$FindPerformers._({
    if (filter != null) r'filter': filter,
    if (performer_filter != null) r'performer_filter': performer_filter,
  });

  Variables$Query$FindPerformers._(this._$data);

  factory Variables$Query$FindPerformers.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$FindFilterType.fromJson((l$filter as Map<String, dynamic>));
    }
    if (data.containsKey('performer_filter')) {
      final l$performer_filter = data['performer_filter'];
      result$data['performer_filter'] = l$performer_filter == null
          ? null
          : Input$PerformerFilterType.fromJson(
              (l$performer_filter as Map<String, dynamic>),
            );
    }
    return Variables$Query$FindPerformers._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$FindFilterType? get filter =>
      (_$data['filter'] as Input$FindFilterType?);

  Input$PerformerFilterType? get performer_filter =>
      (_$data['performer_filter'] as Input$PerformerFilterType?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    if (_$data.containsKey('performer_filter')) {
      final l$performer_filter = performer_filter;
      result$data['performer_filter'] = l$performer_filter?.toJson();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$FindPerformers ||
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
    final l$performer_filter = performer_filter;
    final lOther$performer_filter = other.performer_filter;
    if (_$data.containsKey('performer_filter') !=
        other._$data.containsKey('performer_filter')) {
      return false;
    }
    if (l$performer_filter != lOther$performer_filter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$filter = filter;
    final l$performer_filter = performer_filter;
    return Object.hashAll([
      _$data.containsKey('filter') ? l$filter : const {},
      _$data.containsKey('performer_filter') ? l$performer_filter : const {},
    ]);
  }
}

class Query$FindPerformers {
  Query$FindPerformers({
    required this.findPerformers,
    this.$__typename = 'Query',
  });

  factory Query$FindPerformers.fromJson(Map<String, dynamic> json) {
    final l$findPerformers = json['findPerformers'];
    final l$$__typename = json['__typename'];
    return Query$FindPerformers(
      findPerformers: Query$FindPerformers$findPerformers.fromJson(
        (l$findPerformers as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindPerformers$findPerformers findPerformers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findPerformers = findPerformers;
    _resultData['findPerformers'] = l$findPerformers.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findPerformers = findPerformers;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findPerformers, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindPerformers || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findPerformers = findPerformers;
    final lOther$findPerformers = other.findPerformers;
    if (l$findPerformers != lOther$findPerformers) {
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

const documentNodeQueryFindPerformers = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindPerformers'),
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
          variable: VariableNode(name: NameNode(value: 'performer_filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'PerformerFilterType'),
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
            name: NameNode(value: 'findPerformers'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: VariableNode(name: NameNode(value: 'filter')),
              ),
              ArgumentNode(
                name: NameNode(value: 'performer_filter'),
                value: VariableNode(name: NameNode(value: 'performer_filter')),
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
                  name: NameNode(value: 'performers'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'PerformerFields'),
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
    fragmentDefinitionPerformerFields,
  ],
);
Query$FindPerformers _parserFn$Query$FindPerformers(
  Map<String, dynamic> data,
) => Query$FindPerformers.fromJson(data);
typedef OnQueryComplete$Query$FindPerformers = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindPerformers?,
);

class Options$Query$FindPerformers
    extends graphql.QueryOptions<Query$FindPerformers> {
  Options$Query$FindPerformers({
    String? operationName,
    Variables$Query$FindPerformers? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindPerformers? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindPerformers? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindPerformers',
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
                 data == null ? null : _parserFn$Query$FindPerformers(data),
               ),
         onError: onError,
         document: documentNodeQueryFindPerformers,
         parserFn: _parserFn$Query$FindPerformers,
       );

  final OnQueryComplete$Query$FindPerformers? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindPerformers
    extends graphql.WatchQueryOptions<Query$FindPerformers> {
  WatchOptions$Query$FindPerformers({
    String? operationName,
    Variables$Query$FindPerformers? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindPerformers? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindPerformers',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindPerformers,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindPerformers,
       );
}

class FetchMoreOptions$Query$FindPerformers extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindPerformers({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindPerformers? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindPerformers,
       );
}

extension ClientExtension$Query$FindPerformers on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindPerformers>> query$FindPerformers([
    Options$Query$FindPerformers? options,
  ]) async => await this.query(options ?? Options$Query$FindPerformers());

  graphql.ObservableQuery<Query$FindPerformers> watchQuery$FindPerformers([
    WatchOptions$Query$FindPerformers? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindPerformers());

  void writeQuery$FindPerformers({
    required Query$FindPerformers data,
    Variables$Query$FindPerformers? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindPerformers),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindPerformers? readQuery$FindPerformers({
    Variables$Query$FindPerformers? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindPerformers),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindPerformers.fromJson(result);
  }
}

class Query$FindPerformers$findPerformers {
  Query$FindPerformers$findPerformers({
    required this.count,
    required this.performers,
    this.$__typename = 'FindPerformersResultType',
  });

  factory Query$FindPerformers$findPerformers.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$count = json['count'];
    final l$performers = json['performers'];
    final l$$__typename = json['__typename'];
    return Query$FindPerformers$findPerformers(
      count: (l$count as int),
      performers: (l$performers as List<dynamic>)
          .map(
            (e) =>
                Fragment$PerformerFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final List<Fragment$PerformerFields> performers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$performers = performers;
    _resultData['performers'] = l$performers.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$performers = performers;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$count,
      Object.hashAll(l$performers.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindPerformers$findPerformers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
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

class Variables$Query$FindPerformer {
  factory Variables$Query$FindPerformer({required String id}) =>
      Variables$Query$FindPerformer._({r'id': id});

  Variables$Query$FindPerformer._(this._$data);

  factory Variables$Query$FindPerformer.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$FindPerformer._(result$data);
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
    if (other is! Variables$Query$FindPerformer ||
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

class Query$FindPerformer {
  Query$FindPerformer({this.findPerformer, this.$__typename = 'Query'});

  factory Query$FindPerformer.fromJson(Map<String, dynamic> json) {
    final l$findPerformer = json['findPerformer'];
    final l$$__typename = json['__typename'];
    return Query$FindPerformer(
      findPerformer: l$findPerformer == null
          ? null
          : Query$FindPerformer$findPerformer.fromJson(
              (l$findPerformer as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindPerformer$findPerformer? findPerformer;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findPerformer = findPerformer;
    _resultData['findPerformer'] = l$findPerformer?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findPerformer = findPerformer;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findPerformer, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindPerformer || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findPerformer = findPerformer;
    final lOther$findPerformer = other.findPerformer;
    if (l$findPerformer != lOther$findPerformer) {
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

const documentNodeQueryFindPerformer = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindPerformer'),
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
            name: NameNode(value: 'findPerformer'),
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
                  name: NameNode(value: 'PerformerFields'),
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
    fragmentDefinitionPerformerFields,
  ],
);
Query$FindPerformer _parserFn$Query$FindPerformer(Map<String, dynamic> data) =>
    Query$FindPerformer.fromJson(data);
typedef OnQueryComplete$Query$FindPerformer = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindPerformer?,
);

class Options$Query$FindPerformer
    extends graphql.QueryOptions<Query$FindPerformer> {
  Options$Query$FindPerformer({
    String? operationName,
    required Variables$Query$FindPerformer variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindPerformer? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindPerformer? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindPerformer',
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
                 data == null ? null : _parserFn$Query$FindPerformer(data),
               ),
         onError: onError,
         document: documentNodeQueryFindPerformer,
         parserFn: _parserFn$Query$FindPerformer,
       );

  final OnQueryComplete$Query$FindPerformer? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindPerformer
    extends graphql.WatchQueryOptions<Query$FindPerformer> {
  WatchOptions$Query$FindPerformer({
    String? operationName,
    required Variables$Query$FindPerformer variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindPerformer? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindPerformer',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindPerformer,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindPerformer,
       );
}

class FetchMoreOptions$Query$FindPerformer extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindPerformer({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$FindPerformer variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryFindPerformer,
       );
}

extension ClientExtension$Query$FindPerformer on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindPerformer>> query$FindPerformer(
    Options$Query$FindPerformer options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$FindPerformer> watchQuery$FindPerformer(
    WatchOptions$Query$FindPerformer options,
  ) => this.watchQuery(options);

  void writeQuery$FindPerformer({
    required Query$FindPerformer data,
    required Variables$Query$FindPerformer variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindPerformer),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindPerformer? readQuery$FindPerformer({
    required Variables$Query$FindPerformer variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindPerformer),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindPerformer.fromJson(result);
  }
}

class Query$FindPerformer$findPerformer implements Fragment$PerformerFields {
  Query$FindPerformer$findPerformer({
    required this.id,
    required this.name,
    this.disambiguation,
    this.image_path,
    this.country,
    this.birthdate,
    this.gender,
    required this.favorite,
    this.rating100,
    required this.scene_count,
    this.$__typename = 'Performer',
    this.details,
  });

  factory Query$FindPerformer$findPerformer.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$disambiguation = json['disambiguation'];
    final l$image_path = json['image_path'];
    final l$country = json['country'];
    final l$birthdate = json['birthdate'];
    final l$gender = json['gender'];
    final l$favorite = json['favorite'];
    final l$rating100 = json['rating100'];
    final l$scene_count = json['scene_count'];
    final l$$__typename = json['__typename'];
    final l$details = json['details'];
    return Query$FindPerformer$findPerformer(
      id: (l$id as String),
      name: (l$name as String),
      disambiguation: (l$disambiguation as String?),
      image_path: (l$image_path as String?),
      country: (l$country as String?),
      birthdate: (l$birthdate as String?),
      gender: l$gender == null
          ? null
          : fromJson$Enum$GenderEnum((l$gender as String)),
      favorite: (l$favorite as bool),
      rating100: (l$rating100 as int?),
      scene_count: (l$scene_count as int),
      $__typename: (l$$__typename as String),
      details: (l$details as String?),
    );
  }

  final String id;

  final String name;

  final String? disambiguation;

  final String? image_path;

  final String? country;

  final String? birthdate;

  final Enum$GenderEnum? gender;

  final bool favorite;

  final int? rating100;

  final int scene_count;

  final String $__typename;

  final String? details;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$disambiguation = disambiguation;
    _resultData['disambiguation'] = l$disambiguation;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$country = country;
    _resultData['country'] = l$country;
    final l$birthdate = birthdate;
    _resultData['birthdate'] = l$birthdate;
    final l$gender = gender;
    _resultData['gender'] = l$gender == null
        ? null
        : toJson$Enum$GenderEnum(l$gender);
    final l$favorite = favorite;
    _resultData['favorite'] = l$favorite;
    final l$rating100 = rating100;
    _resultData['rating100'] = l$rating100;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$details = details;
    _resultData['details'] = l$details;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$disambiguation = disambiguation;
    final l$image_path = image_path;
    final l$country = country;
    final l$birthdate = birthdate;
    final l$gender = gender;
    final l$favorite = favorite;
    final l$rating100 = rating100;
    final l$scene_count = scene_count;
    final l$$__typename = $__typename;
    final l$details = details;
    return Object.hashAll([
      l$id,
      l$name,
      l$disambiguation,
      l$image_path,
      l$country,
      l$birthdate,
      l$gender,
      l$favorite,
      l$rating100,
      l$scene_count,
      l$$__typename,
      l$details,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindPerformer$findPerformer ||
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
    final l$disambiguation = disambiguation;
    final lOther$disambiguation = other.disambiguation;
    if (l$disambiguation != lOther$disambiguation) {
      return false;
    }
    final l$image_path = image_path;
    final lOther$image_path = other.image_path;
    if (l$image_path != lOther$image_path) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$birthdate = birthdate;
    final lOther$birthdate = other.birthdate;
    if (l$birthdate != lOther$birthdate) {
      return false;
    }
    final l$gender = gender;
    final lOther$gender = other.gender;
    if (l$gender != lOther$gender) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (l$favorite != lOther$favorite) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (l$rating100 != lOther$rating100) {
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
    final l$details = details;
    final lOther$details = other.details;
    if (l$details != lOther$details) {
      return false;
    }
    return true;
  }
}

class Variables$Query$PerformerUrls {
  factory Variables$Query$PerformerUrls({required String id}) =>
      Variables$Query$PerformerUrls._({r'id': id});

  Variables$Query$PerformerUrls._(this._$data);

  factory Variables$Query$PerformerUrls.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$PerformerUrls._(result$data);
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
    if (other is! Variables$Query$PerformerUrls ||
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

class Query$PerformerUrls {
  Query$PerformerUrls({this.findPerformer, this.$__typename = 'Query'});

  factory Query$PerformerUrls.fromJson(Map<String, dynamic> json) {
    final l$findPerformer = json['findPerformer'];
    final l$$__typename = json['__typename'];
    return Query$PerformerUrls(
      findPerformer: l$findPerformer == null
          ? null
          : Query$PerformerUrls$findPerformer.fromJson(
              (l$findPerformer as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$PerformerUrls$findPerformer? findPerformer;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findPerformer = findPerformer;
    _resultData['findPerformer'] = l$findPerformer?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findPerformer = findPerformer;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findPerformer, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PerformerUrls || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findPerformer = findPerformer;
    final lOther$findPerformer = other.findPerformer;
    if (l$findPerformer != lOther$findPerformer) {
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

const documentNodeQueryPerformerUrls = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'PerformerUrls'),
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
            name: NameNode(value: 'findPerformer'),
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
Query$PerformerUrls _parserFn$Query$PerformerUrls(Map<String, dynamic> data) =>
    Query$PerformerUrls.fromJson(data);
typedef OnQueryComplete$Query$PerformerUrls = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$PerformerUrls?,
);

class Options$Query$PerformerUrls
    extends graphql.QueryOptions<Query$PerformerUrls> {
  Options$Query$PerformerUrls({
    String? operationName,
    required Variables$Query$PerformerUrls variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$PerformerUrls? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$PerformerUrls? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'PerformerUrls',
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
                 data == null ? null : _parserFn$Query$PerformerUrls(data),
               ),
         onError: onError,
         document: documentNodeQueryPerformerUrls,
         parserFn: _parserFn$Query$PerformerUrls,
       );

  final OnQueryComplete$Query$PerformerUrls? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$PerformerUrls
    extends graphql.WatchQueryOptions<Query$PerformerUrls> {
  WatchOptions$Query$PerformerUrls({
    String? operationName,
    required Variables$Query$PerformerUrls variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$PerformerUrls? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'PerformerUrls',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryPerformerUrls,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$PerformerUrls,
       );
}

class FetchMoreOptions$Query$PerformerUrls extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$PerformerUrls({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$PerformerUrls variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryPerformerUrls,
       );
}

extension ClientExtension$Query$PerformerUrls on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$PerformerUrls>> query$PerformerUrls(
    Options$Query$PerformerUrls options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$PerformerUrls> watchQuery$PerformerUrls(
    WatchOptions$Query$PerformerUrls options,
  ) => this.watchQuery(options);

  void writeQuery$PerformerUrls({
    required Query$PerformerUrls data,
    required Variables$Query$PerformerUrls variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryPerformerUrls),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$PerformerUrls? readQuery$PerformerUrls({
    required Variables$Query$PerformerUrls variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryPerformerUrls),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$PerformerUrls.fromJson(result);
  }
}

class Query$PerformerUrls$findPerformer {
  Query$PerformerUrls$findPerformer({
    required this.id,
    this.urls,
    this.$__typename = 'Performer',
  });

  factory Query$PerformerUrls$findPerformer.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$urls = json['urls'];
    final l$$__typename = json['__typename'];
    return Query$PerformerUrls$findPerformer(
      id: (l$id as String),
      urls: (l$urls as List<dynamic>?)?.map((e) => (e as String)).toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<String>? urls;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$urls = urls;
    _resultData['urls'] = l$urls?.map((e) => e).toList();
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
      l$urls == null ? null : Object.hashAll(l$urls.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$PerformerUrls$findPerformer ||
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
    if (l$urls != null && lOther$urls != null) {
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
    } else if (l$urls != lOther$urls) {
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

class Variables$Mutation$PerformerEdit {
  factory Variables$Mutation$PerformerEdit({
    required Input$PerformerUpdateInput input,
  }) => Variables$Mutation$PerformerEdit._({r'input': input});

  Variables$Mutation$PerformerEdit._(this._$data);

  factory Variables$Mutation$PerformerEdit.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$PerformerUpdateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$PerformerEdit._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$PerformerUpdateInput get input =>
      (_$data['input'] as Input$PerformerUpdateInput);

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
    if (other is! Variables$Mutation$PerformerEdit ||
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

class Mutation$PerformerEdit {
  Mutation$PerformerEdit({this.performerUpdate, this.$__typename = 'Mutation'});

  factory Mutation$PerformerEdit.fromJson(Map<String, dynamic> json) {
    final l$performerUpdate = json['performerUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$PerformerEdit(
      performerUpdate: l$performerUpdate == null
          ? null
          : Mutation$PerformerEdit$performerUpdate.fromJson(
              (l$performerUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$PerformerEdit$performerUpdate? performerUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$performerUpdate = performerUpdate;
    _resultData['performerUpdate'] = l$performerUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$performerUpdate = performerUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$performerUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$PerformerEdit || runtimeType != other.runtimeType) {
      return false;
    }
    final l$performerUpdate = performerUpdate;
    final lOther$performerUpdate = other.performerUpdate;
    if (l$performerUpdate != lOther$performerUpdate) {
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

const documentNodeMutationPerformerEdit = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'PerformerEdit'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'PerformerUpdateInput'),
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
            name: NameNode(value: 'performerUpdate'),
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
                  name: NameNode(value: 'PerformerFields'),
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
    fragmentDefinitionPerformerFields,
  ],
);
Mutation$PerformerEdit _parserFn$Mutation$PerformerEdit(
  Map<String, dynamic> data,
) => Mutation$PerformerEdit.fromJson(data);
typedef OnMutationCompleted$Mutation$PerformerEdit = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$PerformerEdit?,
);

class Options$Mutation$PerformerEdit
    extends graphql.MutationOptions<Mutation$PerformerEdit> {
  Options$Mutation$PerformerEdit({
    String? operationName,
    required Variables$Mutation$PerformerEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$PerformerEdit? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$PerformerEdit? onCompleted,
    graphql.OnMutationUpdate<Mutation$PerformerEdit>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'PerformerEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$PerformerEdit(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationPerformerEdit,
         parserFn: _parserFn$Mutation$PerformerEdit,
       );

  final OnMutationCompleted$Mutation$PerformerEdit? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$PerformerEdit
    extends graphql.WatchQueryOptions<Mutation$PerformerEdit> {
  WatchOptions$Mutation$PerformerEdit({
    String? operationName,
    required Variables$Mutation$PerformerEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$PerformerEdit? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'PerformerEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationPerformerEdit,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$PerformerEdit,
       );
}

extension ClientExtension$Mutation$PerformerEdit on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$PerformerEdit>> mutate$PerformerEdit(
    Options$Mutation$PerformerEdit options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$PerformerEdit> watchMutation$PerformerEdit(
    WatchOptions$Mutation$PerformerEdit options,
  ) => this.watchMutation(options);
}

class Mutation$PerformerEdit$performerUpdate
    implements Fragment$PerformerFields {
  Mutation$PerformerEdit$performerUpdate({
    required this.id,
    required this.name,
    this.disambiguation,
    this.image_path,
    this.country,
    this.birthdate,
    this.gender,
    required this.favorite,
    this.rating100,
    required this.scene_count,
    this.$__typename = 'Performer',
    this.details,
  });

  factory Mutation$PerformerEdit$performerUpdate.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$disambiguation = json['disambiguation'];
    final l$image_path = json['image_path'];
    final l$country = json['country'];
    final l$birthdate = json['birthdate'];
    final l$gender = json['gender'];
    final l$favorite = json['favorite'];
    final l$rating100 = json['rating100'];
    final l$scene_count = json['scene_count'];
    final l$$__typename = json['__typename'];
    final l$details = json['details'];
    return Mutation$PerformerEdit$performerUpdate(
      id: (l$id as String),
      name: (l$name as String),
      disambiguation: (l$disambiguation as String?),
      image_path: (l$image_path as String?),
      country: (l$country as String?),
      birthdate: (l$birthdate as String?),
      gender: l$gender == null
          ? null
          : fromJson$Enum$GenderEnum((l$gender as String)),
      favorite: (l$favorite as bool),
      rating100: (l$rating100 as int?),
      scene_count: (l$scene_count as int),
      $__typename: (l$$__typename as String),
      details: (l$details as String?),
    );
  }

  final String id;

  final String name;

  final String? disambiguation;

  final String? image_path;

  final String? country;

  final String? birthdate;

  final Enum$GenderEnum? gender;

  final bool favorite;

  final int? rating100;

  final int scene_count;

  final String $__typename;

  final String? details;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$disambiguation = disambiguation;
    _resultData['disambiguation'] = l$disambiguation;
    final l$image_path = image_path;
    _resultData['image_path'] = l$image_path;
    final l$country = country;
    _resultData['country'] = l$country;
    final l$birthdate = birthdate;
    _resultData['birthdate'] = l$birthdate;
    final l$gender = gender;
    _resultData['gender'] = l$gender == null
        ? null
        : toJson$Enum$GenderEnum(l$gender);
    final l$favorite = favorite;
    _resultData['favorite'] = l$favorite;
    final l$rating100 = rating100;
    _resultData['rating100'] = l$rating100;
    final l$scene_count = scene_count;
    _resultData['scene_count'] = l$scene_count;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$details = details;
    _resultData['details'] = l$details;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$disambiguation = disambiguation;
    final l$image_path = image_path;
    final l$country = country;
    final l$birthdate = birthdate;
    final l$gender = gender;
    final l$favorite = favorite;
    final l$rating100 = rating100;
    final l$scene_count = scene_count;
    final l$$__typename = $__typename;
    final l$details = details;
    return Object.hashAll([
      l$id,
      l$name,
      l$disambiguation,
      l$image_path,
      l$country,
      l$birthdate,
      l$gender,
      l$favorite,
      l$rating100,
      l$scene_count,
      l$$__typename,
      l$details,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$PerformerEdit$performerUpdate ||
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
    final l$disambiguation = disambiguation;
    final lOther$disambiguation = other.disambiguation;
    if (l$disambiguation != lOther$disambiguation) {
      return false;
    }
    final l$image_path = image_path;
    final lOther$image_path = other.image_path;
    if (l$image_path != lOther$image_path) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$birthdate = birthdate;
    final lOther$birthdate = other.birthdate;
    if (l$birthdate != lOther$birthdate) {
      return false;
    }
    final l$gender = gender;
    final lOther$gender = other.gender;
    if (l$gender != lOther$gender) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (l$favorite != lOther$favorite) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (l$rating100 != lOther$rating100) {
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
    final l$details = details;
    final lOther$details = other.details;
    if (l$details != lOther$details) {
      return false;
    }
    return true;
  }
}

class Variables$Mutation$PerformerSetFavorite {
  factory Variables$Mutation$PerformerSetFavorite({
    required String id,
    required bool favorite,
  }) => Variables$Mutation$PerformerSetFavorite._({
    r'id': id,
    r'favorite': favorite,
  });

  Variables$Mutation$PerformerSetFavorite._(this._$data);

  factory Variables$Mutation$PerformerSetFavorite.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$favorite = data['favorite'];
    result$data['favorite'] = (l$favorite as bool);
    return Variables$Mutation$PerformerSetFavorite._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  bool get favorite => (_$data['favorite'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$favorite = favorite;
    result$data['favorite'] = l$favorite;
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$PerformerSetFavorite ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (l$favorite != lOther$favorite) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$favorite = favorite;
    return Object.hashAll([l$id, l$favorite]);
  }
}

class Mutation$PerformerSetFavorite {
  Mutation$PerformerSetFavorite({
    this.performerUpdate,
    this.$__typename = 'Mutation',
  });

  factory Mutation$PerformerSetFavorite.fromJson(Map<String, dynamic> json) {
    final l$performerUpdate = json['performerUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$PerformerSetFavorite(
      performerUpdate: l$performerUpdate == null
          ? null
          : Mutation$PerformerSetFavorite$performerUpdate.fromJson(
              (l$performerUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$PerformerSetFavorite$performerUpdate? performerUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$performerUpdate = performerUpdate;
    _resultData['performerUpdate'] = l$performerUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$performerUpdate = performerUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$performerUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$PerformerSetFavorite ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$performerUpdate = performerUpdate;
    final lOther$performerUpdate = other.performerUpdate;
    if (l$performerUpdate != lOther$performerUpdate) {
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

const documentNodeMutationPerformerSetFavorite = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'PerformerSetFavorite'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'favorite')),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
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
            name: NameNode(value: 'performerUpdate'),
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
                      name: NameNode(value: 'favorite'),
                      value: VariableNode(name: NameNode(value: 'favorite')),
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
                  name: NameNode(value: 'favorite'),
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
Mutation$PerformerSetFavorite _parserFn$Mutation$PerformerSetFavorite(
  Map<String, dynamic> data,
) => Mutation$PerformerSetFavorite.fromJson(data);
typedef OnMutationCompleted$Mutation$PerformerSetFavorite =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation$PerformerSetFavorite?,
    );

class Options$Mutation$PerformerSetFavorite
    extends graphql.MutationOptions<Mutation$PerformerSetFavorite> {
  Options$Mutation$PerformerSetFavorite({
    String? operationName,
    required Variables$Mutation$PerformerSetFavorite variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$PerformerSetFavorite? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$PerformerSetFavorite? onCompleted,
    graphql.OnMutationUpdate<Mutation$PerformerSetFavorite>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'PerformerSetFavorite',
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
                     : _parserFn$Mutation$PerformerSetFavorite(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationPerformerSetFavorite,
         parserFn: _parserFn$Mutation$PerformerSetFavorite,
       );

  final OnMutationCompleted$Mutation$PerformerSetFavorite?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$PerformerSetFavorite
    extends graphql.WatchQueryOptions<Mutation$PerformerSetFavorite> {
  WatchOptions$Mutation$PerformerSetFavorite({
    String? operationName,
    required Variables$Mutation$PerformerSetFavorite variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$PerformerSetFavorite? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'PerformerSetFavorite',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationPerformerSetFavorite,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$PerformerSetFavorite,
       );
}

extension ClientExtension$Mutation$PerformerSetFavorite
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$PerformerSetFavorite>>
  mutate$PerformerSetFavorite(
    Options$Mutation$PerformerSetFavorite options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$PerformerSetFavorite>
  watchMutation$PerformerSetFavorite(
    WatchOptions$Mutation$PerformerSetFavorite options,
  ) => this.watchMutation(options);
}

class Mutation$PerformerSetFavorite$performerUpdate {
  Mutation$PerformerSetFavorite$performerUpdate({
    required this.id,
    required this.favorite,
    this.$__typename = 'Performer',
  });

  factory Mutation$PerformerSetFavorite$performerUpdate.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$favorite = json['favorite'];
    final l$$__typename = json['__typename'];
    return Mutation$PerformerSetFavorite$performerUpdate(
      id: (l$id as String),
      favorite: (l$favorite as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final bool favorite;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$favorite = favorite;
    _resultData['favorite'] = l$favorite;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$favorite = favorite;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$favorite, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$PerformerSetFavorite$performerUpdate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (l$favorite != lOther$favorite) {
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
