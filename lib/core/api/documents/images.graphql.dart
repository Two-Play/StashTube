import '../stash_schema.graphql.dart';

import 'dart:async';

import 'galleries.graphql.dart';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'refs.graphql.dart';

class Variables$Query$FindImages {
  factory Variables$Query$FindImages({
    Input$FindFilterType? filter,
    Input$ImageFilterType? image_filter,
  }) => Variables$Query$FindImages._({
    if (filter != null) r'filter': filter,
    if (image_filter != null) r'image_filter': image_filter,
  });

  Variables$Query$FindImages._(this._$data);

  factory Variables$Query$FindImages.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$FindFilterType.fromJson((l$filter as Map<String, dynamic>));
    }
    if (data.containsKey('image_filter')) {
      final l$image_filter = data['image_filter'];
      result$data['image_filter'] = l$image_filter == null
          ? null
          : Input$ImageFilterType.fromJson(
              (l$image_filter as Map<String, dynamic>),
            );
    }
    return Variables$Query$FindImages._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$FindFilterType? get filter =>
      (_$data['filter'] as Input$FindFilterType?);

  Input$ImageFilterType? get image_filter =>
      (_$data['image_filter'] as Input$ImageFilterType?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    if (_$data.containsKey('image_filter')) {
      final l$image_filter = image_filter;
      result$data['image_filter'] = l$image_filter?.toJson();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$FindImages ||
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
    final l$image_filter = image_filter;
    final lOther$image_filter = other.image_filter;
    if (_$data.containsKey('image_filter') !=
        other._$data.containsKey('image_filter')) {
      return false;
    }
    if (l$image_filter != lOther$image_filter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$filter = filter;
    final l$image_filter = image_filter;
    return Object.hashAll([
      _$data.containsKey('filter') ? l$filter : const {},
      _$data.containsKey('image_filter') ? l$image_filter : const {},
    ]);
  }
}

class Query$FindImages {
  Query$FindImages({required this.findImages, this.$__typename = 'Query'});

  factory Query$FindImages.fromJson(Map<String, dynamic> json) {
    final l$findImages = json['findImages'];
    final l$$__typename = json['__typename'];
    return Query$FindImages(
      findImages: Query$FindImages$findImages.fromJson(
        (l$findImages as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindImages$findImages findImages;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findImages = findImages;
    _resultData['findImages'] = l$findImages.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findImages = findImages;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findImages, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImages || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findImages = findImages;
    final lOther$findImages = other.findImages;
    if (l$findImages != lOther$findImages) {
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

const documentNodeQueryFindImages = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindImages'),
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
          variable: VariableNode(name: NameNode(value: 'image_filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'ImageFilterType'),
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
            name: NameNode(value: 'findImages'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: VariableNode(name: NameNode(value: 'filter')),
              ),
              ArgumentNode(
                name: NameNode(value: 'image_filter'),
                value: VariableNode(name: NameNode(value: 'image_filter')),
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
                  name: NameNode(value: 'images'),
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
                        name: NameNode(value: 'rating100'),
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
                              name: NameNode(value: 'thumbnail'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'image'),
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
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
  ],
);
Query$FindImages _parserFn$Query$FindImages(Map<String, dynamic> data) =>
    Query$FindImages.fromJson(data);
typedef OnQueryComplete$Query$FindImages = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindImages?,
);

class Options$Query$FindImages extends graphql.QueryOptions<Query$FindImages> {
  Options$Query$FindImages({
    String? operationName,
    Variables$Query$FindImages? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindImages? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindImages? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindImages',
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
                 data == null ? null : _parserFn$Query$FindImages(data),
               ),
         onError: onError,
         document: documentNodeQueryFindImages,
         parserFn: _parserFn$Query$FindImages,
       );

  final OnQueryComplete$Query$FindImages? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindImages
    extends graphql.WatchQueryOptions<Query$FindImages> {
  WatchOptions$Query$FindImages({
    String? operationName,
    Variables$Query$FindImages? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindImages? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindImages',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindImages,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindImages,
       );
}

class FetchMoreOptions$Query$FindImages extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindImages({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindImages? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindImages,
       );
}

extension ClientExtension$Query$FindImages on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindImages>> query$FindImages([
    Options$Query$FindImages? options,
  ]) async => await this.query(options ?? Options$Query$FindImages());

  graphql.ObservableQuery<Query$FindImages> watchQuery$FindImages([
    WatchOptions$Query$FindImages? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindImages());

  void writeQuery$FindImages({
    required Query$FindImages data,
    Variables$Query$FindImages? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindImages),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindImages? readQuery$FindImages({
    Variables$Query$FindImages? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindImages),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindImages.fromJson(result);
  }
}

class Query$FindImages$findImages {
  Query$FindImages$findImages({
    required this.count,
    required this.images,
    this.$__typename = 'FindImagesResultType',
  });

  factory Query$FindImages$findImages.fromJson(Map<String, dynamic> json) {
    final l$count = json['count'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$FindImages$findImages(
      count: (l$count as int),
      images: (l$images as List<dynamic>)
          .map(
            (e) => Query$FindImages$findImages$images.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final List<Query$FindImages$findImages$images> images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$images = images;
    _resultData['images'] = l$images.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$count,
      Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImages$findImages ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images.length != lOther$images.length) {
      return false;
    }
    for (int i = 0; i < l$images.length; i++) {
      final l$images$entry = l$images[i];
      final lOther$images$entry = lOther$images[i];
      if (l$images$entry != lOther$images$entry) {
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

class Query$FindImages$findImages$images {
  Query$FindImages$findImages$images({
    required this.id,
    this.title,
    this.date,
    this.rating100,
    required this.paths,
    this.studio,
    required this.performers,
    this.$__typename = 'Image',
  });

  factory Query$FindImages$findImages$images.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$date = json['date'];
    final l$rating100 = json['rating100'];
    final l$paths = json['paths'];
    final l$studio = json['studio'];
    final l$performers = json['performers'];
    final l$$__typename = json['__typename'];
    return Query$FindImages$findImages$images(
      id: (l$id as String),
      title: (l$title as String?),
      date: (l$date as String?),
      rating100: (l$rating100 as int?),
      paths: Query$FindImages$findImages$images$paths.fromJson(
        (l$paths as Map<String, dynamic>),
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

  final int? rating100;

  final Query$FindImages$findImages$images$paths paths;

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
    final l$rating100 = rating100;
    _resultData['rating100'] = l$rating100;
    final l$paths = paths;
    _resultData['paths'] = l$paths.toJson();
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
    final l$rating100 = rating100;
    final l$paths = paths;
    final l$studio = studio;
    final l$performers = performers;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$date,
      l$rating100,
      l$paths,
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
    if (other is! Query$FindImages$findImages$images ||
        runtimeType != other.runtimeType) {
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
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$paths = paths;
    final lOther$paths = other.paths;
    if (l$paths != lOther$paths) {
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

class Query$FindImages$findImages$images$paths {
  Query$FindImages$findImages$images$paths({
    this.thumbnail,
    this.image,
    this.$__typename = 'ImagePathsType',
  });

  factory Query$FindImages$findImages$images$paths.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$thumbnail = json['thumbnail'];
    final l$image = json['image'];
    final l$$__typename = json['__typename'];
    return Query$FindImages$findImages$images$paths(
      thumbnail: (l$thumbnail as String?),
      image: (l$image as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? thumbnail;

  final String? image;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$thumbnail = thumbnail;
    _resultData['thumbnail'] = l$thumbnail;
    final l$image = image;
    _resultData['image'] = l$image;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$thumbnail = thumbnail;
    final l$image = image;
    final l$$__typename = $__typename;
    return Object.hashAll([l$thumbnail, l$image, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImages$findImages$images$paths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$thumbnail = thumbnail;
    final lOther$thumbnail = other.thumbnail;
    if (l$thumbnail != lOther$thumbnail) {
      return false;
    }
    final l$image = image;
    final lOther$image = other.image;
    if (l$image != lOther$image) {
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

class Variables$Query$FindImageDetails {
  factory Variables$Query$FindImageDetails({required String id}) =>
      Variables$Query$FindImageDetails._({r'id': id});

  Variables$Query$FindImageDetails._(this._$data);

  factory Variables$Query$FindImageDetails.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$FindImageDetails._(result$data);
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
    if (other is! Variables$Query$FindImageDetails ||
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

class Query$FindImageDetails {
  Query$FindImageDetails({this.findImage, this.$__typename = 'Query'});

  factory Query$FindImageDetails.fromJson(Map<String, dynamic> json) {
    final l$findImage = json['findImage'];
    final l$$__typename = json['__typename'];
    return Query$FindImageDetails(
      findImage: l$findImage == null
          ? null
          : Query$FindImageDetails$findImage.fromJson(
              (l$findImage as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindImageDetails$findImage? findImage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findImage = findImage;
    _resultData['findImage'] = l$findImage?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findImage = findImage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findImage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImageDetails || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findImage = findImage;
    final lOther$findImage = other.findImage;
    if (l$findImage != lOther$findImage) {
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

const documentNodeQueryFindImageDetails = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindImageDetails'),
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
            name: NameNode(value: 'findImage'),
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
                  name: NameNode(value: 'photographer'),
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
                  name: NameNode(value: 'o_counter'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'organized'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'created_at'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'updated_at'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'visual_files'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'ImageFile'),
                            isNonNull: false,
                          ),
                        ),
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
                              name: NameNode(value: 'basename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'size'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'format'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'width'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'height'),
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
                      InlineFragmentNode(
                        typeCondition: TypeConditionNode(
                          on: NamedTypeNode(
                            name: NameNode(value: 'VideoFile'),
                            isNonNull: false,
                          ),
                        ),
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
                              name: NameNode(value: 'basename'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'size'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'format'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'width'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'height'),
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
                  name: NameNode(value: 'tags'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'TagRef'),
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
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
    fragmentDefinitionTagRef,
    fragmentDefinitionGalleryFields,
  ],
);
Query$FindImageDetails _parserFn$Query$FindImageDetails(
  Map<String, dynamic> data,
) => Query$FindImageDetails.fromJson(data);
typedef OnQueryComplete$Query$FindImageDetails = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindImageDetails?,
);

class Options$Query$FindImageDetails
    extends graphql.QueryOptions<Query$FindImageDetails> {
  Options$Query$FindImageDetails({
    String? operationName,
    required Variables$Query$FindImageDetails variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindImageDetails? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindImageDetails? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindImageDetails',
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
                 data == null ? null : _parserFn$Query$FindImageDetails(data),
               ),
         onError: onError,
         document: documentNodeQueryFindImageDetails,
         parserFn: _parserFn$Query$FindImageDetails,
       );

  final OnQueryComplete$Query$FindImageDetails? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindImageDetails
    extends graphql.WatchQueryOptions<Query$FindImageDetails> {
  WatchOptions$Query$FindImageDetails({
    String? operationName,
    required Variables$Query$FindImageDetails variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindImageDetails? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindImageDetails',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindImageDetails,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindImageDetails,
       );
}

class FetchMoreOptions$Query$FindImageDetails extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindImageDetails({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$FindImageDetails variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryFindImageDetails,
       );
}

extension ClientExtension$Query$FindImageDetails on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindImageDetails>> query$FindImageDetails(
    Options$Query$FindImageDetails options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$FindImageDetails> watchQuery$FindImageDetails(
    WatchOptions$Query$FindImageDetails options,
  ) => this.watchQuery(options);

  void writeQuery$FindImageDetails({
    required Query$FindImageDetails data,
    required Variables$Query$FindImageDetails variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindImageDetails),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindImageDetails? readQuery$FindImageDetails({
    required Variables$Query$FindImageDetails variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryFindImageDetails,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindImageDetails.fromJson(result);
  }
}

class Query$FindImageDetails$findImage {
  Query$FindImageDetails$findImage({
    required this.id,
    this.title,
    this.date,
    this.details,
    this.photographer,
    this.rating100,
    this.o_counter,
    required this.organized,
    required this.created_at,
    required this.updated_at,
    required this.visual_files,
    this.studio,
    required this.performers,
    required this.tags,
    required this.galleries,
    this.$__typename = 'Image',
  });

  factory Query$FindImageDetails$findImage.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$date = json['date'];
    final l$details = json['details'];
    final l$photographer = json['photographer'];
    final l$rating100 = json['rating100'];
    final l$o_counter = json['o_counter'];
    final l$organized = json['organized'];
    final l$created_at = json['created_at'];
    final l$updated_at = json['updated_at'];
    final l$visual_files = json['visual_files'];
    final l$studio = json['studio'];
    final l$performers = json['performers'];
    final l$tags = json['tags'];
    final l$galleries = json['galleries'];
    final l$$__typename = json['__typename'];
    return Query$FindImageDetails$findImage(
      id: (l$id as String),
      title: (l$title as String?),
      date: (l$date as String?),
      details: (l$details as String?),
      photographer: (l$photographer as String?),
      rating100: (l$rating100 as int?),
      o_counter: (l$o_counter as int?),
      organized: (l$organized as bool),
      created_at: (l$created_at as String),
      updated_at: (l$updated_at as String),
      visual_files: (l$visual_files as List<dynamic>)
          .map(
            (e) => Query$FindImageDetails$findImage$visual_files.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      studio: l$studio == null
          ? null
          : Fragment$StudioRef.fromJson((l$studio as Map<String, dynamic>)),
      performers: (l$performers as List<dynamic>)
          .map(
            (e) => Fragment$PerformerRef.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      tags: (l$tags as List<dynamic>)
          .map((e) => Fragment$TagRef.fromJson((e as Map<String, dynamic>)))
          .toList(),
      galleries: (l$galleries as List<dynamic>)
          .map(
            (e) => Fragment$GalleryFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? title;

  final String? date;

  final String? details;

  final String? photographer;

  final int? rating100;

  final int? o_counter;

  final bool organized;

  final String created_at;

  final String updated_at;

  final List<Query$FindImageDetails$findImage$visual_files> visual_files;

  final Fragment$StudioRef? studio;

  final List<Fragment$PerformerRef> performers;

  final List<Fragment$TagRef> tags;

  final List<Fragment$GalleryFields> galleries;

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
    final l$photographer = photographer;
    _resultData['photographer'] = l$photographer;
    final l$rating100 = rating100;
    _resultData['rating100'] = l$rating100;
    final l$o_counter = o_counter;
    _resultData['o_counter'] = l$o_counter;
    final l$organized = organized;
    _resultData['organized'] = l$organized;
    final l$created_at = created_at;
    _resultData['created_at'] = l$created_at;
    final l$updated_at = updated_at;
    _resultData['updated_at'] = l$updated_at;
    final l$visual_files = visual_files;
    _resultData['visual_files'] = l$visual_files
        .map((e) => e.toJson())
        .toList();
    final l$studio = studio;
    _resultData['studio'] = l$studio?.toJson();
    final l$performers = performers;
    _resultData['performers'] = l$performers.map((e) => e.toJson()).toList();
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e.toJson()).toList();
    final l$galleries = galleries;
    _resultData['galleries'] = l$galleries.map((e) => e.toJson()).toList();
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
    final l$photographer = photographer;
    final l$rating100 = rating100;
    final l$o_counter = o_counter;
    final l$organized = organized;
    final l$created_at = created_at;
    final l$updated_at = updated_at;
    final l$visual_files = visual_files;
    final l$studio = studio;
    final l$performers = performers;
    final l$tags = tags;
    final l$galleries = galleries;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$date,
      l$details,
      l$photographer,
      l$rating100,
      l$o_counter,
      l$organized,
      l$created_at,
      l$updated_at,
      Object.hashAll(l$visual_files.map((v) => v)),
      l$studio,
      Object.hashAll(l$performers.map((v) => v)),
      Object.hashAll(l$tags.map((v) => v)),
      Object.hashAll(l$galleries.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImageDetails$findImage ||
        runtimeType != other.runtimeType) {
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
    final l$photographer = photographer;
    final lOther$photographer = other.photographer;
    if (l$photographer != lOther$photographer) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$o_counter = o_counter;
    final lOther$o_counter = other.o_counter;
    if (l$o_counter != lOther$o_counter) {
      return false;
    }
    final l$organized = organized;
    final lOther$organized = other.organized;
    if (l$organized != lOther$organized) {
      return false;
    }
    final l$created_at = created_at;
    final lOther$created_at = other.created_at;
    if (l$created_at != lOther$created_at) {
      return false;
    }
    final l$updated_at = updated_at;
    final lOther$updated_at = other.updated_at;
    if (l$updated_at != lOther$updated_at) {
      return false;
    }
    final l$visual_files = visual_files;
    final lOther$visual_files = other.visual_files;
    if (l$visual_files.length != lOther$visual_files.length) {
      return false;
    }
    for (int i = 0; i < l$visual_files.length; i++) {
      final l$visual_files$entry = l$visual_files[i];
      final lOther$visual_files$entry = lOther$visual_files[i];
      if (l$visual_files$entry != lOther$visual_files$entry) {
        return false;
      }
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

class Query$FindImageDetails$findImage$visual_files {
  Query$FindImageDetails$findImage$visual_files({required this.$__typename});

  factory Query$FindImageDetails$findImage$visual_files.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "ImageFile":
        return Query$FindImageDetails$findImage$visual_files$$ImageFile.fromJson(
          json,
        );

      case "VideoFile":
        return Query$FindImageDetails$findImage$visual_files$$VideoFile.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Query$FindImageDetails$findImage$visual_files(
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImageDetails$findImage$visual_files ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$FindImageDetails$findImage$visual_files
    on Query$FindImageDetails$findImage$visual_files {
  _T when<_T>({
    required _T Function(
      Query$FindImageDetails$findImage$visual_files$$ImageFile,
    )
    imageFile,
    required _T Function(
      Query$FindImageDetails$findImage$visual_files$$VideoFile,
    )
    videoFile,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "ImageFile":
        return imageFile(
          this as Query$FindImageDetails$findImage$visual_files$$ImageFile,
        );

      case "VideoFile":
        return videoFile(
          this as Query$FindImageDetails$findImage$visual_files$$VideoFile,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query$FindImageDetails$findImage$visual_files$$ImageFile)?
    imageFile,
    _T Function(Query$FindImageDetails$findImage$visual_files$$VideoFile)?
    videoFile,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "ImageFile":
        if (imageFile != null) {
          return imageFile(
            this as Query$FindImageDetails$findImage$visual_files$$ImageFile,
          );
        } else {
          return orElse();
        }

      case "VideoFile":
        if (videoFile != null) {
          return videoFile(
            this as Query$FindImageDetails$findImage$visual_files$$VideoFile,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

class Query$FindImageDetails$findImage$visual_files$$ImageFile
    implements Query$FindImageDetails$findImage$visual_files {
  Query$FindImageDetails$findImage$visual_files$$ImageFile({
    required this.path,
    required this.basename,
    required this.size,
    required this.format,
    required this.width,
    required this.height,
    this.$__typename = 'ImageFile',
  });

  factory Query$FindImageDetails$findImage$visual_files$$ImageFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$path = json['path'];
    final l$basename = json['basename'];
    final l$size = json['size'];
    final l$format = json['format'];
    final l$width = json['width'];
    final l$height = json['height'];
    final l$$__typename = json['__typename'];
    return Query$FindImageDetails$findImage$visual_files$$ImageFile(
      path: (l$path as String),
      basename: (l$basename as String),
      size: (l$size as int),
      format: (l$format as String),
      width: (l$width as int),
      height: (l$height as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final String basename;

  final int size;

  final String format;

  final int width;

  final int height;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$basename = basename;
    _resultData['basename'] = l$basename;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$format = format;
    _resultData['format'] = l$format;
    final l$width = width;
    _resultData['width'] = l$width;
    final l$height = height;
    _resultData['height'] = l$height;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$basename = basename;
    final l$size = size;
    final l$format = format;
    final l$width = width;
    final l$height = height;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$path,
      l$basename,
      l$size,
      l$format,
      l$width,
      l$height,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImageDetails$findImage$visual_files$$ImageFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$basename = basename;
    final lOther$basename = other.basename;
    if (l$basename != lOther$basename) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (l$size != lOther$size) {
      return false;
    }
    final l$format = format;
    final lOther$format = other.format;
    if (l$format != lOther$format) {
      return false;
    }
    final l$width = width;
    final lOther$width = other.width;
    if (l$width != lOther$width) {
      return false;
    }
    final l$height = height;
    final lOther$height = other.height;
    if (l$height != lOther$height) {
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

class Query$FindImageDetails$findImage$visual_files$$VideoFile
    implements Query$FindImageDetails$findImage$visual_files {
  Query$FindImageDetails$findImage$visual_files$$VideoFile({
    required this.path,
    required this.basename,
    required this.size,
    required this.format,
    required this.width,
    required this.height,
    this.$__typename = 'VideoFile',
  });

  factory Query$FindImageDetails$findImage$visual_files$$VideoFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$path = json['path'];
    final l$basename = json['basename'];
    final l$size = json['size'];
    final l$format = json['format'];
    final l$width = json['width'];
    final l$height = json['height'];
    final l$$__typename = json['__typename'];
    return Query$FindImageDetails$findImage$visual_files$$VideoFile(
      path: (l$path as String),
      basename: (l$basename as String),
      size: (l$size as int),
      format: (l$format as String),
      width: (l$width as int),
      height: (l$height as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final String basename;

  final int size;

  final String format;

  final int width;

  final int height;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$basename = basename;
    _resultData['basename'] = l$basename;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$format = format;
    _resultData['format'] = l$format;
    final l$width = width;
    _resultData['width'] = l$width;
    final l$height = height;
    _resultData['height'] = l$height;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$basename = basename;
    final l$size = size;
    final l$format = format;
    final l$width = width;
    final l$height = height;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$path,
      l$basename,
      l$size,
      l$format,
      l$width,
      l$height,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindImageDetails$findImage$visual_files$$VideoFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$basename = basename;
    final lOther$basename = other.basename;
    if (l$basename != lOther$basename) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (l$size != lOther$size) {
      return false;
    }
    final l$format = format;
    final lOther$format = other.format;
    if (l$format != lOther$format) {
      return false;
    }
    final l$width = width;
    final lOther$width = other.width;
    if (l$width != lOther$width) {
      return false;
    }
    final l$height = height;
    final lOther$height = other.height;
    if (l$height != lOther$height) {
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
