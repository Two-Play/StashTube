import '../stash_schema.graphql.dart';

import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'refs.graphql.dart';

class Fragment$SceneFields {
  Fragment$SceneFields({
    required this.id,
    this.title,
    this.details,
    this.date,
    required this.created_at,
    this.rating100,
    this.play_count,
    this.o_counter,
    this.resume_time,
    required this.organized,
    required this.files,
    required this.paths,
    this.studio,
    required this.performers,
    required this.tags,
    this.$__typename = 'Scene',
  });

  factory Fragment$SceneFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$details = json['details'];
    final l$date = json['date'];
    final l$created_at = json['created_at'];
    final l$rating100 = json['rating100'];
    final l$play_count = json['play_count'];
    final l$o_counter = json['o_counter'];
    final l$resume_time = json['resume_time'];
    final l$organized = json['organized'];
    final l$files = json['files'];
    final l$paths = json['paths'];
    final l$studio = json['studio'];
    final l$performers = json['performers'];
    final l$tags = json['tags'];
    final l$$__typename = json['__typename'];
    return Fragment$SceneFields(
      id: (l$id as String),
      title: (l$title as String?),
      details: (l$details as String?),
      date: (l$date as String?),
      created_at: (l$created_at as String),
      rating100: (l$rating100 as int?),
      play_count: (l$play_count as int?),
      o_counter: (l$o_counter as int?),
      resume_time: (l$resume_time as num?)?.toDouble(),
      organized: (l$organized as bool),
      files: (l$files as List<dynamic>)
          .map(
            (e) => Fragment$SceneFields$files.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      paths: Fragment$SceneFields$paths.fromJson(
        (l$paths as Map<String, dynamic>),
      ),
      studio: l$studio == null
          ? null
          : Fragment$StudioRef.fromJson((l$studio as Map<String, dynamic>)),
      performers: (l$performers as List<dynamic>)
          .map(
            (e) => Fragment$SceneFields$performers.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      tags: (l$tags as List<dynamic>)
          .map((e) => Fragment$TagRef.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? title;

  final String? details;

  final String? date;

  final String created_at;

  final int? rating100;

  final int? play_count;

  final int? o_counter;

  final double? resume_time;

  final bool organized;

  final List<Fragment$SceneFields$files> files;

  final Fragment$SceneFields$paths paths;

  final Fragment$StudioRef? studio;

  final List<Fragment$SceneFields$performers> performers;

  final List<Fragment$TagRef> tags;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$details = details;
    _resultData['details'] = l$details;
    final l$date = date;
    _resultData['date'] = l$date;
    final l$created_at = created_at;
    _resultData['created_at'] = l$created_at;
    final l$rating100 = rating100;
    _resultData['rating100'] = l$rating100;
    final l$play_count = play_count;
    _resultData['play_count'] = l$play_count;
    final l$o_counter = o_counter;
    _resultData['o_counter'] = l$o_counter;
    final l$resume_time = resume_time;
    _resultData['resume_time'] = l$resume_time;
    final l$organized = organized;
    _resultData['organized'] = l$organized;
    final l$files = files;
    _resultData['files'] = l$files.map((e) => e.toJson()).toList();
    final l$paths = paths;
    _resultData['paths'] = l$paths.toJson();
    final l$studio = studio;
    _resultData['studio'] = l$studio?.toJson();
    final l$performers = performers;
    _resultData['performers'] = l$performers.map((e) => e.toJson()).toList();
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$details = details;
    final l$date = date;
    final l$created_at = created_at;
    final l$rating100 = rating100;
    final l$play_count = play_count;
    final l$o_counter = o_counter;
    final l$resume_time = resume_time;
    final l$organized = organized;
    final l$files = files;
    final l$paths = paths;
    final l$studio = studio;
    final l$performers = performers;
    final l$tags = tags;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$details,
      l$date,
      l$created_at,
      l$rating100,
      l$play_count,
      l$o_counter,
      l$resume_time,
      l$organized,
      Object.hashAll(l$files.map((v) => v)),
      l$paths,
      l$studio,
      Object.hashAll(l$performers.map((v) => v)),
      Object.hashAll(l$tags.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SceneFields || runtimeType != other.runtimeType) {
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
    final l$details = details;
    final lOther$details = other.details;
    if (l$details != lOther$details) {
      return false;
    }
    final l$date = date;
    final lOther$date = other.date;
    if (l$date != lOther$date) {
      return false;
    }
    final l$created_at = created_at;
    final lOther$created_at = other.created_at;
    if (l$created_at != lOther$created_at) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    final l$play_count = play_count;
    final lOther$play_count = other.play_count;
    if (l$play_count != lOther$play_count) {
      return false;
    }
    final l$o_counter = o_counter;
    final lOther$o_counter = other.o_counter;
    if (l$o_counter != lOther$o_counter) {
      return false;
    }
    final l$resume_time = resume_time;
    final lOther$resume_time = other.resume_time;
    if (l$resume_time != lOther$resume_time) {
      return false;
    }
    final l$organized = organized;
    final lOther$organized = other.organized;
    if (l$organized != lOther$organized) {
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

const fragmentDefinitionSceneFields = FragmentDefinitionNode(
  name: NameNode(value: 'SceneFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Scene'), isNonNull: false),
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
        name: NameNode(value: 'details'),
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
        name: NameNode(value: 'created_at'),
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
        name: NameNode(value: 'play_count'),
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
        name: NameNode(value: 'resume_time'),
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
              name: NameNode(value: 'duration'),
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
        name: NameNode(value: 'paths'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'screenshot'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'preview'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'stream'),
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
              name: NameNode(value: 'country'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentSceneFields = DocumentNode(
  definitions: [
    fragmentDefinitionSceneFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
    fragmentDefinitionTagRef,
  ],
);

extension ClientExtension$Fragment$SceneFields on graphql.GraphQLClient {
  void writeFragment$SceneFields({
    required Fragment$SceneFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'SceneFields',
        document: documentNodeFragmentSceneFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$SceneFields? readFragment$SceneFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'SceneFields',
          document: documentNodeFragmentSceneFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$SceneFields.fromJson(result);
  }
}

class Fragment$SceneFields$files {
  Fragment$SceneFields$files({
    required this.basename,
    required this.duration,
    required this.width,
    required this.height,
    this.$__typename = 'VideoFile',
  });

  factory Fragment$SceneFields$files.fromJson(Map<String, dynamic> json) {
    final l$basename = json['basename'];
    final l$duration = json['duration'];
    final l$width = json['width'];
    final l$height = json['height'];
    final l$$__typename = json['__typename'];
    return Fragment$SceneFields$files(
      basename: (l$basename as String),
      duration: (l$duration as num).toDouble(),
      width: (l$width as int),
      height: (l$height as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String basename;

  final double duration;

  final int width;

  final int height;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$basename = basename;
    _resultData['basename'] = l$basename;
    final l$duration = duration;
    _resultData['duration'] = l$duration;
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
    final l$basename = basename;
    final l$duration = duration;
    final l$width = width;
    final l$height = height;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$basename,
      l$duration,
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
    if (other is! Fragment$SceneFields$files ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$basename = basename;
    final lOther$basename = other.basename;
    if (l$basename != lOther$basename) {
      return false;
    }
    final l$duration = duration;
    final lOther$duration = other.duration;
    if (l$duration != lOther$duration) {
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

class Fragment$SceneFields$paths {
  Fragment$SceneFields$paths({
    this.screenshot,
    this.preview,
    this.stream,
    this.$__typename = 'ScenePathsType',
  });

  factory Fragment$SceneFields$paths.fromJson(Map<String, dynamic> json) {
    final l$screenshot = json['screenshot'];
    final l$preview = json['preview'];
    final l$stream = json['stream'];
    final l$$__typename = json['__typename'];
    return Fragment$SceneFields$paths(
      screenshot: (l$screenshot as String?),
      preview: (l$preview as String?),
      stream: (l$stream as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? screenshot;

  final String? preview;

  final String? stream;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$screenshot = screenshot;
    _resultData['screenshot'] = l$screenshot;
    final l$preview = preview;
    _resultData['preview'] = l$preview;
    final l$stream = stream;
    _resultData['stream'] = l$stream;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$screenshot = screenshot;
    final l$preview = preview;
    final l$stream = stream;
    final l$$__typename = $__typename;
    return Object.hashAll([l$screenshot, l$preview, l$stream, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SceneFields$paths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$screenshot = screenshot;
    final lOther$screenshot = other.screenshot;
    if (l$screenshot != lOther$screenshot) {
      return false;
    }
    final l$preview = preview;
    final lOther$preview = other.preview;
    if (l$preview != lOther$preview) {
      return false;
    }
    final l$stream = stream;
    final lOther$stream = other.stream;
    if (l$stream != lOther$stream) {
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

class Fragment$SceneFields$performers implements Fragment$PerformerRef {
  Fragment$SceneFields$performers({
    required this.id,
    required this.name,
    this.image_path,
    this.$__typename = 'Performer',
    this.country,
    required this.favorite,
  });

  factory Fragment$SceneFields$performers.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$image_path = json['image_path'];
    final l$$__typename = json['__typename'];
    final l$country = json['country'];
    final l$favorite = json['favorite'];
    return Fragment$SceneFields$performers(
      id: (l$id as String),
      name: (l$name as String),
      image_path: (l$image_path as String?),
      $__typename: (l$$__typename as String),
      country: (l$country as String?),
      favorite: (l$favorite as bool),
    );
  }

  final String id;

  final String name;

  final String? image_path;

  final String $__typename;

  final String? country;

  final bool favorite;

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
    final l$country = country;
    _resultData['country'] = l$country;
    final l$favorite = favorite;
    _resultData['favorite'] = l$favorite;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$image_path = image_path;
    final l$$__typename = $__typename;
    final l$country = country;
    final l$favorite = favorite;
    return Object.hashAll([
      l$id,
      l$name,
      l$image_path,
      l$$__typename,
      l$country,
      l$favorite,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SceneFields$performers ||
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
    final l$country = country;
    final lOther$country = other.country;
    if (l$country != lOther$country) {
      return false;
    }
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (l$favorite != lOther$favorite) {
      return false;
    }
    return true;
  }
}

class Fragment$MarkerFields {
  Fragment$MarkerFields({
    required this.id,
    required this.title,
    required this.seconds,
    required this.primary_tag,
    this.$__typename = 'SceneMarker',
  });

  factory Fragment$MarkerFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$seconds = json['seconds'];
    final l$primary_tag = json['primary_tag'];
    final l$$__typename = json['__typename'];
    return Fragment$MarkerFields(
      id: (l$id as String),
      title: (l$title as String),
      seconds: (l$seconds as num).toDouble(),
      primary_tag: Fragment$MarkerFields$primary_tag.fromJson(
        (l$primary_tag as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final double seconds;

  final Fragment$MarkerFields$primary_tag primary_tag;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$seconds = seconds;
    _resultData['seconds'] = l$seconds;
    final l$primary_tag = primary_tag;
    _resultData['primary_tag'] = l$primary_tag.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$seconds = seconds;
    final l$primary_tag = primary_tag;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$seconds,
      l$primary_tag,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$MarkerFields || runtimeType != other.runtimeType) {
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
    final l$seconds = seconds;
    final lOther$seconds = other.seconds;
    if (l$seconds != lOther$seconds) {
      return false;
    }
    final l$primary_tag = primary_tag;
    final lOther$primary_tag = other.primary_tag;
    if (l$primary_tag != lOther$primary_tag) {
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

const fragmentDefinitionMarkerFields = FragmentDefinitionNode(
  name: NameNode(value: 'MarkerFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SceneMarker'), isNonNull: false),
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
        name: NameNode(value: 'seconds'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'primary_tag'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'name'),
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
const documentNodeFragmentMarkerFields = DocumentNode(
  definitions: [fragmentDefinitionMarkerFields],
);

extension ClientExtension$Fragment$MarkerFields on graphql.GraphQLClient {
  void writeFragment$MarkerFields({
    required Fragment$MarkerFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'MarkerFields',
        document: documentNodeFragmentMarkerFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$MarkerFields? readFragment$MarkerFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'MarkerFields',
          document: documentNodeFragmentMarkerFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$MarkerFields.fromJson(result);
  }
}

class Fragment$MarkerFields$primary_tag {
  Fragment$MarkerFields$primary_tag({
    required this.name,
    this.$__typename = 'Tag',
  });

  factory Fragment$MarkerFields$primary_tag.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$MarkerFields$primary_tag(
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$MarkerFields$primary_tag ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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

class Variables$Query$FindScenes {
  factory Variables$Query$FindScenes({
    Input$FindFilterType? filter,
    Input$SceneFilterType? scene_filter,
  }) => Variables$Query$FindScenes._({
    if (filter != null) r'filter': filter,
    if (scene_filter != null) r'scene_filter': scene_filter,
  });

  Variables$Query$FindScenes._(this._$data);

  factory Variables$Query$FindScenes.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$FindFilterType.fromJson((l$filter as Map<String, dynamic>));
    }
    if (data.containsKey('scene_filter')) {
      final l$scene_filter = data['scene_filter'];
      result$data['scene_filter'] = l$scene_filter == null
          ? null
          : Input$SceneFilterType.fromJson(
              (l$scene_filter as Map<String, dynamic>),
            );
    }
    return Variables$Query$FindScenes._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$FindFilterType? get filter =>
      (_$data['filter'] as Input$FindFilterType?);

  Input$SceneFilterType? get scene_filter =>
      (_$data['scene_filter'] as Input$SceneFilterType?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    if (_$data.containsKey('scene_filter')) {
      final l$scene_filter = scene_filter;
      result$data['scene_filter'] = l$scene_filter?.toJson();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$FindScenes ||
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
    final l$scene_filter = scene_filter;
    final lOther$scene_filter = other.scene_filter;
    if (_$data.containsKey('scene_filter') !=
        other._$data.containsKey('scene_filter')) {
      return false;
    }
    if (l$scene_filter != lOther$scene_filter) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$filter = filter;
    final l$scene_filter = scene_filter;
    return Object.hashAll([
      _$data.containsKey('filter') ? l$filter : const {},
      _$data.containsKey('scene_filter') ? l$scene_filter : const {},
    ]);
  }
}

class Query$FindScenes {
  Query$FindScenes({required this.findScenes, this.$__typename = 'Query'});

  factory Query$FindScenes.fromJson(Map<String, dynamic> json) {
    final l$findScenes = json['findScenes'];
    final l$$__typename = json['__typename'];
    return Query$FindScenes(
      findScenes: Query$FindScenes$findScenes.fromJson(
        (l$findScenes as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindScenes$findScenes findScenes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findScenes = findScenes;
    _resultData['findScenes'] = l$findScenes.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findScenes = findScenes;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findScenes, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindScenes || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findScenes = findScenes;
    final lOther$findScenes = other.findScenes;
    if (l$findScenes != lOther$findScenes) {
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

const documentNodeQueryFindScenes = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindScenes'),
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
          variable: VariableNode(name: NameNode(value: 'scene_filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'SceneFilterType'),
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
            name: NameNode(value: 'findScenes'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: VariableNode(name: NameNode(value: 'filter')),
              ),
              ArgumentNode(
                name: NameNode(value: 'scene_filter'),
                value: VariableNode(name: NameNode(value: 'scene_filter')),
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
                  name: NameNode(value: 'scenes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'SceneFields'),
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
    fragmentDefinitionSceneFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
    fragmentDefinitionTagRef,
  ],
);
Query$FindScenes _parserFn$Query$FindScenes(Map<String, dynamic> data) =>
    Query$FindScenes.fromJson(data);
typedef OnQueryComplete$Query$FindScenes = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindScenes?,
);

class Options$Query$FindScenes extends graphql.QueryOptions<Query$FindScenes> {
  Options$Query$FindScenes({
    String? operationName,
    Variables$Query$FindScenes? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindScenes? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindScenes? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindScenes',
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
                 data == null ? null : _parserFn$Query$FindScenes(data),
               ),
         onError: onError,
         document: documentNodeQueryFindScenes,
         parserFn: _parserFn$Query$FindScenes,
       );

  final OnQueryComplete$Query$FindScenes? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindScenes
    extends graphql.WatchQueryOptions<Query$FindScenes> {
  WatchOptions$Query$FindScenes({
    String? operationName,
    Variables$Query$FindScenes? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindScenes? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindScenes',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindScenes,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindScenes,
       );
}

class FetchMoreOptions$Query$FindScenes extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindScenes({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindScenes? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindScenes,
       );
}

extension ClientExtension$Query$FindScenes on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindScenes>> query$FindScenes([
    Options$Query$FindScenes? options,
  ]) async => await this.query(options ?? Options$Query$FindScenes());

  graphql.ObservableQuery<Query$FindScenes> watchQuery$FindScenes([
    WatchOptions$Query$FindScenes? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindScenes());

  void writeQuery$FindScenes({
    required Query$FindScenes data,
    Variables$Query$FindScenes? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindScenes),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindScenes? readQuery$FindScenes({
    Variables$Query$FindScenes? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryFindScenes),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindScenes.fromJson(result);
  }
}

class Query$FindScenes$findScenes {
  Query$FindScenes$findScenes({
    required this.count,
    required this.scenes,
    this.$__typename = 'FindScenesResultType',
  });

  factory Query$FindScenes$findScenes.fromJson(Map<String, dynamic> json) {
    final l$count = json['count'];
    final l$scenes = json['scenes'];
    final l$$__typename = json['__typename'];
    return Query$FindScenes$findScenes(
      count: (l$count as int),
      scenes: (l$scenes as List<dynamic>)
          .map(
            (e) => Fragment$SceneFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int count;

  final List<Fragment$SceneFields> scenes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$count = count;
    _resultData['count'] = l$count;
    final l$scenes = scenes;
    _resultData['scenes'] = l$scenes.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$count = count;
    final l$scenes = scenes;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$count,
      Object.hashAll(l$scenes.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindScenes$findScenes ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$count = count;
    final lOther$count = other.count;
    if (l$count != lOther$count) {
      return false;
    }
    final l$scenes = scenes;
    final lOther$scenes = other.scenes;
    if (l$scenes.length != lOther$scenes.length) {
      return false;
    }
    for (int i = 0; i < l$scenes.length; i++) {
      final l$scenes$entry = l$scenes[i];
      final lOther$scenes$entry = lOther$scenes[i];
      if (l$scenes$entry != lOther$scenes$entry) {
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

class Variables$Query$FindScenesByIds {
  factory Variables$Query$FindScenesByIds({List<String>? ids}) =>
      Variables$Query$FindScenesByIds._({if (ids != null) r'ids': ids});

  Variables$Query$FindScenesByIds._(this._$data);

  factory Variables$Query$FindScenesByIds.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] = (l$ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Variables$Query$FindScenesByIds._(result$data);
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
    if (other is! Variables$Query$FindScenesByIds ||
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

class Query$FindScenesByIds {
  Query$FindScenesByIds({required this.findScenes, this.$__typename = 'Query'});

  factory Query$FindScenesByIds.fromJson(Map<String, dynamic> json) {
    final l$findScenes = json['findScenes'];
    final l$$__typename = json['__typename'];
    return Query$FindScenesByIds(
      findScenes: Query$FindScenesByIds$findScenes.fromJson(
        (l$findScenes as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindScenesByIds$findScenes findScenes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$findScenes = findScenes;
    _resultData['findScenes'] = l$findScenes.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$findScenes = findScenes;
    final l$$__typename = $__typename;
    return Object.hashAll([l$findScenes, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindScenesByIds || runtimeType != other.runtimeType) {
      return false;
    }
    final l$findScenes = findScenes;
    final lOther$findScenes = other.findScenes;
    if (l$findScenes != lOther$findScenes) {
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

const documentNodeQueryFindScenesByIds = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindScenesByIds'),
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
            name: NameNode(value: 'findScenes'),
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
                  name: NameNode(value: 'scenes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'SceneFields'),
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
    fragmentDefinitionSceneFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
    fragmentDefinitionTagRef,
  ],
);
Query$FindScenesByIds _parserFn$Query$FindScenesByIds(
  Map<String, dynamic> data,
) => Query$FindScenesByIds.fromJson(data);
typedef OnQueryComplete$Query$FindScenesByIds = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindScenesByIds?,
);

class Options$Query$FindScenesByIds
    extends graphql.QueryOptions<Query$FindScenesByIds> {
  Options$Query$FindScenesByIds({
    String? operationName,
    Variables$Query$FindScenesByIds? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindScenesByIds? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindScenesByIds? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindScenesByIds',
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
                 data == null ? null : _parserFn$Query$FindScenesByIds(data),
               ),
         onError: onError,
         document: documentNodeQueryFindScenesByIds,
         parserFn: _parserFn$Query$FindScenesByIds,
       );

  final OnQueryComplete$Query$FindScenesByIds? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindScenesByIds
    extends graphql.WatchQueryOptions<Query$FindScenesByIds> {
  WatchOptions$Query$FindScenesByIds({
    String? operationName,
    Variables$Query$FindScenesByIds? variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindScenesByIds? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables?.toJson() ?? {},
         operationName: operationName ?? 'FindScenesByIds',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindScenesByIds,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindScenesByIds,
       );
}

class FetchMoreOptions$Query$FindScenesByIds extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindScenesByIds({
    required graphql.UpdateQuery updateQuery,
    Variables$Query$FindScenesByIds? variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables?.toJson() ?? {},
         document: documentNodeQueryFindScenesByIds,
       );
}

extension ClientExtension$Query$FindScenesByIds on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindScenesByIds>> query$FindScenesByIds([
    Options$Query$FindScenesByIds? options,
  ]) async => await this.query(options ?? Options$Query$FindScenesByIds());

  graphql.ObservableQuery<Query$FindScenesByIds> watchQuery$FindScenesByIds([
    WatchOptions$Query$FindScenesByIds? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$FindScenesByIds());

  void writeQuery$FindScenesByIds({
    required Query$FindScenesByIds data,
    Variables$Query$FindScenesByIds? variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindScenesByIds),
      variables: variables?.toJson() ?? const {},
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindScenesByIds? readQuery$FindScenesByIds({
    Variables$Query$FindScenesByIds? variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryFindScenesByIds,
        ),
        variables: variables?.toJson() ?? const {},
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindScenesByIds.fromJson(result);
  }
}

class Query$FindScenesByIds$findScenes {
  Query$FindScenesByIds$findScenes({
    required this.scenes,
    this.$__typename = 'FindScenesResultType',
  });

  factory Query$FindScenesByIds$findScenes.fromJson(Map<String, dynamic> json) {
    final l$scenes = json['scenes'];
    final l$$__typename = json['__typename'];
    return Query$FindScenesByIds$findScenes(
      scenes: (l$scenes as List<dynamic>)
          .map(
            (e) => Fragment$SceneFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$SceneFields> scenes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scenes = scenes;
    _resultData['scenes'] = l$scenes.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scenes = scenes;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$scenes.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindScenesByIds$findScenes ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scenes = scenes;
    final lOther$scenes = other.scenes;
    if (l$scenes.length != lOther$scenes.length) {
      return false;
    }
    for (int i = 0; i < l$scenes.length; i++) {
      final l$scenes$entry = l$scenes[i];
      final lOther$scenes$entry = lOther$scenes[i];
      if (l$scenes$entry != lOther$scenes$entry) {
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

class Variables$Query$FindSceneDetails {
  factory Variables$Query$FindSceneDetails({required String id}) =>
      Variables$Query$FindSceneDetails._({r'id': id});

  Variables$Query$FindSceneDetails._(this._$data);

  factory Variables$Query$FindSceneDetails.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$FindSceneDetails._(result$data);
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
    if (other is! Variables$Query$FindSceneDetails ||
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

class Query$FindSceneDetails {
  Query$FindSceneDetails({this.findScene, this.$__typename = 'Query'});

  factory Query$FindSceneDetails.fromJson(Map<String, dynamic> json) {
    final l$findScene = json['findScene'];
    final l$$__typename = json['__typename'];
    return Query$FindSceneDetails(
      findScene: l$findScene == null
          ? null
          : Query$FindSceneDetails$findScene.fromJson(
              (l$findScene as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$FindSceneDetails$findScene? findScene;

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
    if (other is! Query$FindSceneDetails || runtimeType != other.runtimeType) {
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

const documentNodeQueryFindSceneDetails = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'FindSceneDetails'),
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
                  name: NameNode(value: 'paths'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sprite'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'vtt'),
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
                  name: NameNode(value: 'sceneStreams'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'url'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'mime_type'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'label'),
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
                  name: NameNode(value: 'scene_markers'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'MarkerFields'),
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
                  name: NameNode(value: 'files'),
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
                        name: NameNode(value: 'duration'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'video_codec'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'audio_codec'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'frame_rate'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'bit_rate'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'mod_time'),
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
    fragmentDefinitionMarkerFields,
  ],
);
Query$FindSceneDetails _parserFn$Query$FindSceneDetails(
  Map<String, dynamic> data,
) => Query$FindSceneDetails.fromJson(data);
typedef OnQueryComplete$Query$FindSceneDetails = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$FindSceneDetails?,
);

class Options$Query$FindSceneDetails
    extends graphql.QueryOptions<Query$FindSceneDetails> {
  Options$Query$FindSceneDetails({
    String? operationName,
    required Variables$Query$FindSceneDetails variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindSceneDetails? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$FindSceneDetails? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindSceneDetails',
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
                 data == null ? null : _parserFn$Query$FindSceneDetails(data),
               ),
         onError: onError,
         document: documentNodeQueryFindSceneDetails,
         parserFn: _parserFn$Query$FindSceneDetails,
       );

  final OnQueryComplete$Query$FindSceneDetails? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$FindSceneDetails
    extends graphql.WatchQueryOptions<Query$FindSceneDetails> {
  WatchOptions$Query$FindSceneDetails({
    String? operationName,
    required Variables$Query$FindSceneDetails variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$FindSceneDetails? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'FindSceneDetails',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryFindSceneDetails,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$FindSceneDetails,
       );
}

class FetchMoreOptions$Query$FindSceneDetails extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$FindSceneDetails({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$FindSceneDetails variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryFindSceneDetails,
       );
}

extension ClientExtension$Query$FindSceneDetails on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$FindSceneDetails>> query$FindSceneDetails(
    Options$Query$FindSceneDetails options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$FindSceneDetails> watchQuery$FindSceneDetails(
    WatchOptions$Query$FindSceneDetails options,
  ) => this.watchQuery(options);

  void writeQuery$FindSceneDetails({
    required Query$FindSceneDetails data,
    required Variables$Query$FindSceneDetails variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryFindSceneDetails),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$FindSceneDetails? readQuery$FindSceneDetails({
    required Variables$Query$FindSceneDetails variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryFindSceneDetails,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$FindSceneDetails.fromJson(result);
  }
}

class Query$FindSceneDetails$findScene {
  Query$FindSceneDetails$findScene({
    required this.id,
    required this.paths,
    required this.sceneStreams,
    required this.scene_markers,
    required this.files,
    this.$__typename = 'Scene',
  });

  factory Query$FindSceneDetails$findScene.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$paths = json['paths'];
    final l$sceneStreams = json['sceneStreams'];
    final l$scene_markers = json['scene_markers'];
    final l$files = json['files'];
    final l$$__typename = json['__typename'];
    return Query$FindSceneDetails$findScene(
      id: (l$id as String),
      paths: Query$FindSceneDetails$findScene$paths.fromJson(
        (l$paths as Map<String, dynamic>),
      ),
      sceneStreams: (l$sceneStreams as List<dynamic>)
          .map(
            (e) => Query$FindSceneDetails$findScene$sceneStreams.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      scene_markers: (l$scene_markers as List<dynamic>)
          .map(
            (e) => Fragment$MarkerFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      files: (l$files as List<dynamic>)
          .map(
            (e) => Query$FindSceneDetails$findScene$files.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$FindSceneDetails$findScene$paths paths;

  final List<Query$FindSceneDetails$findScene$sceneStreams> sceneStreams;

  final List<Fragment$MarkerFields> scene_markers;

  final List<Query$FindSceneDetails$findScene$files> files;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$paths = paths;
    _resultData['paths'] = l$paths.toJson();
    final l$sceneStreams = sceneStreams;
    _resultData['sceneStreams'] = l$sceneStreams
        .map((e) => e.toJson())
        .toList();
    final l$scene_markers = scene_markers;
    _resultData['scene_markers'] = l$scene_markers
        .map((e) => e.toJson())
        .toList();
    final l$files = files;
    _resultData['files'] = l$files.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$paths = paths;
    final l$sceneStreams = sceneStreams;
    final l$scene_markers = scene_markers;
    final l$files = files;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$paths,
      Object.hashAll(l$sceneStreams.map((v) => v)),
      Object.hashAll(l$scene_markers.map((v) => v)),
      Object.hashAll(l$files.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindSceneDetails$findScene ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$paths = paths;
    final lOther$paths = other.paths;
    if (l$paths != lOther$paths) {
      return false;
    }
    final l$sceneStreams = sceneStreams;
    final lOther$sceneStreams = other.sceneStreams;
    if (l$sceneStreams.length != lOther$sceneStreams.length) {
      return false;
    }
    for (int i = 0; i < l$sceneStreams.length; i++) {
      final l$sceneStreams$entry = l$sceneStreams[i];
      final lOther$sceneStreams$entry = lOther$sceneStreams[i];
      if (l$sceneStreams$entry != lOther$sceneStreams$entry) {
        return false;
      }
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

class Query$FindSceneDetails$findScene$paths {
  Query$FindSceneDetails$findScene$paths({
    this.sprite,
    this.vtt,
    this.$__typename = 'ScenePathsType',
  });

  factory Query$FindSceneDetails$findScene$paths.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sprite = json['sprite'];
    final l$vtt = json['vtt'];
    final l$$__typename = json['__typename'];
    return Query$FindSceneDetails$findScene$paths(
      sprite: (l$sprite as String?),
      vtt: (l$vtt as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? sprite;

  final String? vtt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sprite = sprite;
    _resultData['sprite'] = l$sprite;
    final l$vtt = vtt;
    _resultData['vtt'] = l$vtt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sprite = sprite;
    final l$vtt = vtt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sprite, l$vtt, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindSceneDetails$findScene$paths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sprite = sprite;
    final lOther$sprite = other.sprite;
    if (l$sprite != lOther$sprite) {
      return false;
    }
    final l$vtt = vtt;
    final lOther$vtt = other.vtt;
    if (l$vtt != lOther$vtt) {
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

class Query$FindSceneDetails$findScene$sceneStreams {
  Query$FindSceneDetails$findScene$sceneStreams({
    required this.url,
    this.mime_type,
    this.label,
    this.$__typename = 'SceneStreamEndpoint',
  });

  factory Query$FindSceneDetails$findScene$sceneStreams.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$mime_type = json['mime_type'];
    final l$label = json['label'];
    final l$$__typename = json['__typename'];
    return Query$FindSceneDetails$findScene$sceneStreams(
      url: (l$url as String),
      mime_type: (l$mime_type as String?),
      label: (l$label as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String url;

  final String? mime_type;

  final String? label;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$mime_type = mime_type;
    _resultData['mime_type'] = l$mime_type;
    final l$label = label;
    _resultData['label'] = l$label;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$mime_type = mime_type;
    final l$label = label;
    final l$$__typename = $__typename;
    return Object.hashAll([l$url, l$mime_type, l$label, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindSceneDetails$findScene$sceneStreams ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$mime_type = mime_type;
    final lOther$mime_type = other.mime_type;
    if (l$mime_type != lOther$mime_type) {
      return false;
    }
    final l$label = label;
    final lOther$label = other.label;
    if (l$label != lOther$label) {
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

class Query$FindSceneDetails$findScene$files {
  Query$FindSceneDetails$findScene$files({
    required this.path,
    required this.size,
    required this.format,
    required this.width,
    required this.height,
    required this.duration,
    required this.video_codec,
    required this.audio_codec,
    required this.frame_rate,
    required this.bit_rate,
    required this.mod_time,
    this.$__typename = 'VideoFile',
  });

  factory Query$FindSceneDetails$findScene$files.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$path = json['path'];
    final l$size = json['size'];
    final l$format = json['format'];
    final l$width = json['width'];
    final l$height = json['height'];
    final l$duration = json['duration'];
    final l$video_codec = json['video_codec'];
    final l$audio_codec = json['audio_codec'];
    final l$frame_rate = json['frame_rate'];
    final l$bit_rate = json['bit_rate'];
    final l$mod_time = json['mod_time'];
    final l$$__typename = json['__typename'];
    return Query$FindSceneDetails$findScene$files(
      path: (l$path as String),
      size: (l$size as int),
      format: (l$format as String),
      width: (l$width as int),
      height: (l$height as int),
      duration: (l$duration as num).toDouble(),
      video_codec: (l$video_codec as String),
      audio_codec: (l$audio_codec as String),
      frame_rate: (l$frame_rate as num).toDouble(),
      bit_rate: (l$bit_rate as int),
      mod_time: (l$mod_time as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final int size;

  final String format;

  final int width;

  final int height;

  final double duration;

  final String video_codec;

  final String audio_codec;

  final double frame_rate;

  final int bit_rate;

  final String mod_time;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$format = format;
    _resultData['format'] = l$format;
    final l$width = width;
    _resultData['width'] = l$width;
    final l$height = height;
    _resultData['height'] = l$height;
    final l$duration = duration;
    _resultData['duration'] = l$duration;
    final l$video_codec = video_codec;
    _resultData['video_codec'] = l$video_codec;
    final l$audio_codec = audio_codec;
    _resultData['audio_codec'] = l$audio_codec;
    final l$frame_rate = frame_rate;
    _resultData['frame_rate'] = l$frame_rate;
    final l$bit_rate = bit_rate;
    _resultData['bit_rate'] = l$bit_rate;
    final l$mod_time = mod_time;
    _resultData['mod_time'] = l$mod_time;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$size = size;
    final l$format = format;
    final l$width = width;
    final l$height = height;
    final l$duration = duration;
    final l$video_codec = video_codec;
    final l$audio_codec = audio_codec;
    final l$frame_rate = frame_rate;
    final l$bit_rate = bit_rate;
    final l$mod_time = mod_time;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$path,
      l$size,
      l$format,
      l$width,
      l$height,
      l$duration,
      l$video_codec,
      l$audio_codec,
      l$frame_rate,
      l$bit_rate,
      l$mod_time,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$FindSceneDetails$findScene$files ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
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
    final l$duration = duration;
    final lOther$duration = other.duration;
    if (l$duration != lOther$duration) {
      return false;
    }
    final l$video_codec = video_codec;
    final lOther$video_codec = other.video_codec;
    if (l$video_codec != lOther$video_codec) {
      return false;
    }
    final l$audio_codec = audio_codec;
    final lOther$audio_codec = other.audio_codec;
    if (l$audio_codec != lOther$audio_codec) {
      return false;
    }
    final l$frame_rate = frame_rate;
    final lOther$frame_rate = other.frame_rate;
    if (l$frame_rate != lOther$frame_rate) {
      return false;
    }
    final l$bit_rate = bit_rate;
    final lOther$bit_rate = other.bit_rate;
    if (l$bit_rate != lOther$bit_rate) {
      return false;
    }
    final l$mod_time = mod_time;
    final lOther$mod_time = other.mod_time;
    if (l$mod_time != lOther$mod_time) {
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

class Variables$Query$SceneUrls {
  factory Variables$Query$SceneUrls({required String id}) =>
      Variables$Query$SceneUrls._({r'id': id});

  Variables$Query$SceneUrls._(this._$data);

  factory Variables$Query$SceneUrls.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$SceneUrls._(result$data);
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
    if (other is! Variables$Query$SceneUrls ||
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

class Query$SceneUrls {
  Query$SceneUrls({this.findScene, this.$__typename = 'Query'});

  factory Query$SceneUrls.fromJson(Map<String, dynamic> json) {
    final l$findScene = json['findScene'];
    final l$$__typename = json['__typename'];
    return Query$SceneUrls(
      findScene: l$findScene == null
          ? null
          : Query$SceneUrls$findScene.fromJson(
              (l$findScene as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$SceneUrls$findScene? findScene;

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
    if (other is! Query$SceneUrls || runtimeType != other.runtimeType) {
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

const documentNodeQuerySceneUrls = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'SceneUrls'),
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
Query$SceneUrls _parserFn$Query$SceneUrls(Map<String, dynamic> data) =>
    Query$SceneUrls.fromJson(data);
typedef OnQueryComplete$Query$SceneUrls = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$SceneUrls?,
);

class Options$Query$SceneUrls extends graphql.QueryOptions<Query$SceneUrls> {
  Options$Query$SceneUrls({
    String? operationName,
    required Variables$Query$SceneUrls variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneUrls? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$SceneUrls? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneUrls',
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
                 data == null ? null : _parserFn$Query$SceneUrls(data),
               ),
         onError: onError,
         document: documentNodeQuerySceneUrls,
         parserFn: _parserFn$Query$SceneUrls,
       );

  final OnQueryComplete$Query$SceneUrls? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$SceneUrls
    extends graphql.WatchQueryOptions<Query$SceneUrls> {
  WatchOptions$Query$SceneUrls({
    String? operationName,
    required Variables$Query$SceneUrls variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$SceneUrls? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneUrls',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQuerySceneUrls,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$SceneUrls,
       );
}

class FetchMoreOptions$Query$SceneUrls extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$SceneUrls({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$SceneUrls variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQuerySceneUrls,
       );
}

extension ClientExtension$Query$SceneUrls on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$SceneUrls>> query$SceneUrls(
    Options$Query$SceneUrls options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$SceneUrls> watchQuery$SceneUrls(
    WatchOptions$Query$SceneUrls options,
  ) => this.watchQuery(options);

  void writeQuery$SceneUrls({
    required Query$SceneUrls data,
    required Variables$Query$SceneUrls variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQuerySceneUrls),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$SceneUrls? readQuery$SceneUrls({
    required Variables$Query$SceneUrls variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQuerySceneUrls),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$SceneUrls.fromJson(result);
  }
}

class Query$SceneUrls$findScene {
  Query$SceneUrls$findScene({
    required this.id,
    required this.urls,
    this.$__typename = 'Scene',
  });

  factory Query$SceneUrls$findScene.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$urls = json['urls'];
    final l$$__typename = json['__typename'];
    return Query$SceneUrls$findScene(
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
    if (other is! Query$SceneUrls$findScene ||
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

class Variables$Mutation$SceneSaveActivity {
  factory Variables$Mutation$SceneSaveActivity({
    required String id,
    double? resume_time,
    double? playDuration,
  }) => Variables$Mutation$SceneSaveActivity._({
    r'id': id,
    if (resume_time != null) r'resume_time': resume_time,
    if (playDuration != null) r'playDuration': playDuration,
  });

  Variables$Mutation$SceneSaveActivity._(this._$data);

  factory Variables$Mutation$SceneSaveActivity.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('resume_time')) {
      final l$resume_time = data['resume_time'];
      result$data['resume_time'] = (l$resume_time as num?)?.toDouble();
    }
    if (data.containsKey('playDuration')) {
      final l$playDuration = data['playDuration'];
      result$data['playDuration'] = (l$playDuration as num?)?.toDouble();
    }
    return Variables$Mutation$SceneSaveActivity._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  double? get resume_time => (_$data['resume_time'] as double?);

  double? get playDuration => (_$data['playDuration'] as double?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('resume_time')) {
      final l$resume_time = resume_time;
      result$data['resume_time'] = l$resume_time;
    }
    if (_$data.containsKey('playDuration')) {
      final l$playDuration = playDuration;
      result$data['playDuration'] = l$playDuration;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SceneSaveActivity ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$resume_time = resume_time;
    final lOther$resume_time = other.resume_time;
    if (_$data.containsKey('resume_time') !=
        other._$data.containsKey('resume_time')) {
      return false;
    }
    if (l$resume_time != lOther$resume_time) {
      return false;
    }
    final l$playDuration = playDuration;
    final lOther$playDuration = other.playDuration;
    if (_$data.containsKey('playDuration') !=
        other._$data.containsKey('playDuration')) {
      return false;
    }
    if (l$playDuration != lOther$playDuration) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$resume_time = resume_time;
    final l$playDuration = playDuration;
    return Object.hashAll([
      l$id,
      _$data.containsKey('resume_time') ? l$resume_time : const {},
      _$data.containsKey('playDuration') ? l$playDuration : const {},
    ]);
  }
}

class Mutation$SceneSaveActivity {
  Mutation$SceneSaveActivity({
    required this.sceneSaveActivity,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SceneSaveActivity.fromJson(Map<String, dynamic> json) {
    final l$sceneSaveActivity = json['sceneSaveActivity'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneSaveActivity(
      sceneSaveActivity: (l$sceneSaveActivity as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool sceneSaveActivity;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneSaveActivity = sceneSaveActivity;
    _resultData['sceneSaveActivity'] = l$sceneSaveActivity;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneSaveActivity = sceneSaveActivity;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneSaveActivity, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneSaveActivity ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneSaveActivity = sceneSaveActivity;
    final lOther$sceneSaveActivity = other.sceneSaveActivity;
    if (l$sceneSaveActivity != lOther$sceneSaveActivity) {
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

const documentNodeMutationSceneSaveActivity = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneSaveActivity'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'resume_time')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playDuration')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sceneSaveActivity'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'resume_time'),
                value: VariableNode(name: NameNode(value: 'resume_time')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playDuration'),
                value: VariableNode(name: NameNode(value: 'playDuration')),
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
Mutation$SceneSaveActivity _parserFn$Mutation$SceneSaveActivity(
  Map<String, dynamic> data,
) => Mutation$SceneSaveActivity.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneSaveActivity =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation$SceneSaveActivity?);

class Options$Mutation$SceneSaveActivity
    extends graphql.MutationOptions<Mutation$SceneSaveActivity> {
  Options$Mutation$SceneSaveActivity({
    String? operationName,
    required Variables$Mutation$SceneSaveActivity variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSaveActivity? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneSaveActivity? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneSaveActivity>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSaveActivity',
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
                     : _parserFn$Mutation$SceneSaveActivity(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneSaveActivity,
         parserFn: _parserFn$Mutation$SceneSaveActivity,
       );

  final OnMutationCompleted$Mutation$SceneSaveActivity? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneSaveActivity
    extends graphql.WatchQueryOptions<Mutation$SceneSaveActivity> {
  WatchOptions$Mutation$SceneSaveActivity({
    String? operationName,
    required Variables$Mutation$SceneSaveActivity variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSaveActivity? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSaveActivity',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneSaveActivity,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneSaveActivity,
       );
}

extension ClientExtension$Mutation$SceneSaveActivity on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneSaveActivity>>
  mutate$SceneSaveActivity(Options$Mutation$SceneSaveActivity options) async =>
      await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneSaveActivity>
  watchMutation$SceneSaveActivity(
    WatchOptions$Mutation$SceneSaveActivity options,
  ) => this.watchMutation(options);
}

class Variables$Mutation$SceneAddPlay {
  factory Variables$Mutation$SceneAddPlay({required String id}) =>
      Variables$Mutation$SceneAddPlay._({r'id': id});

  Variables$Mutation$SceneAddPlay._(this._$data);

  factory Variables$Mutation$SceneAddPlay.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$SceneAddPlay._(result$data);
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
    if (other is! Variables$Mutation$SceneAddPlay ||
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

class Mutation$SceneAddPlay {
  Mutation$SceneAddPlay({
    required this.sceneAddPlay,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SceneAddPlay.fromJson(Map<String, dynamic> json) {
    final l$sceneAddPlay = json['sceneAddPlay'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneAddPlay(
      sceneAddPlay: Mutation$SceneAddPlay$sceneAddPlay.fromJson(
        (l$sceneAddPlay as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SceneAddPlay$sceneAddPlay sceneAddPlay;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneAddPlay = sceneAddPlay;
    _resultData['sceneAddPlay'] = l$sceneAddPlay.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneAddPlay = sceneAddPlay;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneAddPlay, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneAddPlay || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneAddPlay = sceneAddPlay;
    final lOther$sceneAddPlay = other.sceneAddPlay;
    if (l$sceneAddPlay != lOther$sceneAddPlay) {
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

const documentNodeMutationSceneAddPlay = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneAddPlay'),
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
            name: NameNode(value: 'sceneAddPlay'),
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
Mutation$SceneAddPlay _parserFn$Mutation$SceneAddPlay(
  Map<String, dynamic> data,
) => Mutation$SceneAddPlay.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneAddPlay = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SceneAddPlay?,
);

class Options$Mutation$SceneAddPlay
    extends graphql.MutationOptions<Mutation$SceneAddPlay> {
  Options$Mutation$SceneAddPlay({
    String? operationName,
    required Variables$Mutation$SceneAddPlay variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneAddPlay? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneAddPlay? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneAddPlay>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneAddPlay',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$SceneAddPlay(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneAddPlay,
         parserFn: _parserFn$Mutation$SceneAddPlay,
       );

  final OnMutationCompleted$Mutation$SceneAddPlay? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneAddPlay
    extends graphql.WatchQueryOptions<Mutation$SceneAddPlay> {
  WatchOptions$Mutation$SceneAddPlay({
    String? operationName,
    required Variables$Mutation$SceneAddPlay variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneAddPlay? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneAddPlay',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneAddPlay,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneAddPlay,
       );
}

extension ClientExtension$Mutation$SceneAddPlay on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneAddPlay>> mutate$SceneAddPlay(
    Options$Mutation$SceneAddPlay options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneAddPlay> watchMutation$SceneAddPlay(
    WatchOptions$Mutation$SceneAddPlay options,
  ) => this.watchMutation(options);
}

class Mutation$SceneAddPlay$sceneAddPlay {
  Mutation$SceneAddPlay$sceneAddPlay({
    required this.count,
    this.$__typename = 'HistoryMutationResult',
  });

  factory Mutation$SceneAddPlay$sceneAddPlay.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$count = json['count'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneAddPlay$sceneAddPlay(
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
    if (other is! Mutation$SceneAddPlay$sceneAddPlay ||
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

class Variables$Mutation$SceneSetRating {
  factory Variables$Mutation$SceneSetRating({
    required String id,
    int? rating100,
  }) => Variables$Mutation$SceneSetRating._({
    r'id': id,
    if (rating100 != null) r'rating100': rating100,
  });

  Variables$Mutation$SceneSetRating._(this._$data);

  factory Variables$Mutation$SceneSetRating.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
    }
    return Variables$Mutation$SceneSetRating._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  int? get rating100 => (_$data['rating100'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SceneSetRating ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (_$data.containsKey('rating100') !=
        other._$data.containsKey('rating100')) {
      return false;
    }
    if (l$rating100 != lOther$rating100) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$rating100 = rating100;
    return Object.hashAll([
      l$id,
      _$data.containsKey('rating100') ? l$rating100 : const {},
    ]);
  }
}

class Mutation$SceneSetRating {
  Mutation$SceneSetRating({this.sceneUpdate, this.$__typename = 'Mutation'});

  factory Mutation$SceneSetRating.fromJson(Map<String, dynamic> json) {
    final l$sceneUpdate = json['sceneUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneSetRating(
      sceneUpdate: l$sceneUpdate == null
          ? null
          : Mutation$SceneSetRating$sceneUpdate.fromJson(
              (l$sceneUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SceneSetRating$sceneUpdate? sceneUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneUpdate = sceneUpdate;
    _resultData['sceneUpdate'] = l$sceneUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneUpdate = sceneUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneSetRating || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneUpdate = sceneUpdate;
    final lOther$sceneUpdate = other.sceneUpdate;
    if (l$sceneUpdate != lOther$sceneUpdate) {
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

const documentNodeMutationSceneSetRating = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneSetRating'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'rating100')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sceneUpdate'),
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
                      name: NameNode(value: 'rating100'),
                      value: VariableNode(name: NameNode(value: 'rating100')),
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
                  name: NameNode(value: 'rating100'),
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
Mutation$SceneSetRating _parserFn$Mutation$SceneSetRating(
  Map<String, dynamic> data,
) => Mutation$SceneSetRating.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneSetRating = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SceneSetRating?,
);

class Options$Mutation$SceneSetRating
    extends graphql.MutationOptions<Mutation$SceneSetRating> {
  Options$Mutation$SceneSetRating({
    String? operationName,
    required Variables$Mutation$SceneSetRating variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSetRating? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneSetRating? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneSetRating>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSetRating',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$SceneSetRating(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneSetRating,
         parserFn: _parserFn$Mutation$SceneSetRating,
       );

  final OnMutationCompleted$Mutation$SceneSetRating? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneSetRating
    extends graphql.WatchQueryOptions<Mutation$SceneSetRating> {
  WatchOptions$Mutation$SceneSetRating({
    String? operationName,
    required Variables$Mutation$SceneSetRating variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSetRating? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSetRating',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneSetRating,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneSetRating,
       );
}

extension ClientExtension$Mutation$SceneSetRating on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneSetRating>> mutate$SceneSetRating(
    Options$Mutation$SceneSetRating options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneSetRating> watchMutation$SceneSetRating(
    WatchOptions$Mutation$SceneSetRating options,
  ) => this.watchMutation(options);
}

class Mutation$SceneSetRating$sceneUpdate {
  Mutation$SceneSetRating$sceneUpdate({
    required this.id,
    this.rating100,
    this.$__typename = 'Scene',
  });

  factory Mutation$SceneSetRating$sceneUpdate.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$rating100 = json['rating100'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneSetRating$sceneUpdate(
      id: (l$id as String),
      rating100: (l$rating100 as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? rating100;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$rating100 = rating100;
    _resultData['rating100'] = l$rating100;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$rating100 = rating100;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$rating100, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneSetRating$sceneUpdate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$rating100 = rating100;
    final lOther$rating100 = other.rating100;
    if (l$rating100 != lOther$rating100) {
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

class Variables$Mutation$SceneSetTags {
  factory Variables$Mutation$SceneSetTags({
    required String id,
    List<String>? tag_ids,
  }) => Variables$Mutation$SceneSetTags._({
    r'id': id,
    if (tag_ids != null) r'tag_ids': tag_ids,
  });

  Variables$Mutation$SceneSetTags._(this._$data);

  factory Variables$Mutation$SceneSetTags.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] = (l$tag_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Variables$Mutation$SceneSetTags._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SceneSetTags ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$tag_ids = tag_ids;
    final lOther$tag_ids = other.tag_ids;
    if (_$data.containsKey('tag_ids') != other._$data.containsKey('tag_ids')) {
      return false;
    }
    if (l$tag_ids != null && lOther$tag_ids != null) {
      if (l$tag_ids.length != lOther$tag_ids.length) {
        return false;
      }
      for (int i = 0; i < l$tag_ids.length; i++) {
        final l$tag_ids$entry = l$tag_ids[i];
        final lOther$tag_ids$entry = lOther$tag_ids[i];
        if (l$tag_ids$entry != lOther$tag_ids$entry) {
          return false;
        }
      }
    } else if (l$tag_ids != lOther$tag_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$tag_ids = tag_ids;
    return Object.hashAll([
      l$id,
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
                ? null
                : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
    ]);
  }
}

class Mutation$SceneSetTags {
  Mutation$SceneSetTags({this.sceneUpdate, this.$__typename = 'Mutation'});

  factory Mutation$SceneSetTags.fromJson(Map<String, dynamic> json) {
    final l$sceneUpdate = json['sceneUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneSetTags(
      sceneUpdate: l$sceneUpdate == null
          ? null
          : Mutation$SceneSetTags$sceneUpdate.fromJson(
              (l$sceneUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SceneSetTags$sceneUpdate? sceneUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneUpdate = sceneUpdate;
    _resultData['sceneUpdate'] = l$sceneUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneUpdate = sceneUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneSetTags || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneUpdate = sceneUpdate;
    final lOther$sceneUpdate = other.sceneUpdate;
    if (l$sceneUpdate != lOther$sceneUpdate) {
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

const documentNodeMutationSceneSetTags = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneSetTags'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'tag_ids')),
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
            name: NameNode(value: 'sceneUpdate'),
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
                      name: NameNode(value: 'tag_ids'),
                      value: VariableNode(name: NameNode(value: 'tag_ids')),
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
    fragmentDefinitionTagRef,
  ],
);
Mutation$SceneSetTags _parserFn$Mutation$SceneSetTags(
  Map<String, dynamic> data,
) => Mutation$SceneSetTags.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneSetTags = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SceneSetTags?,
);

class Options$Mutation$SceneSetTags
    extends graphql.MutationOptions<Mutation$SceneSetTags> {
  Options$Mutation$SceneSetTags({
    String? operationName,
    required Variables$Mutation$SceneSetTags variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSetTags? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneSetTags? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneSetTags>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSetTags',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$SceneSetTags(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneSetTags,
         parserFn: _parserFn$Mutation$SceneSetTags,
       );

  final OnMutationCompleted$Mutation$SceneSetTags? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneSetTags
    extends graphql.WatchQueryOptions<Mutation$SceneSetTags> {
  WatchOptions$Mutation$SceneSetTags({
    String? operationName,
    required Variables$Mutation$SceneSetTags variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneSetTags? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneSetTags',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneSetTags,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneSetTags,
       );
}

extension ClientExtension$Mutation$SceneSetTags on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneSetTags>> mutate$SceneSetTags(
    Options$Mutation$SceneSetTags options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneSetTags> watchMutation$SceneSetTags(
    WatchOptions$Mutation$SceneSetTags options,
  ) => this.watchMutation(options);
}

class Mutation$SceneSetTags$sceneUpdate {
  Mutation$SceneSetTags$sceneUpdate({
    required this.id,
    required this.tags,
    this.$__typename = 'Scene',
  });

  factory Mutation$SceneSetTags$sceneUpdate.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$tags = json['tags'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneSetTags$sceneUpdate(
      id: (l$id as String),
      tags: (l$tags as List<dynamic>)
          .map((e) => Fragment$TagRef.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$TagRef> tags;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$tags = tags;
    _resultData['tags'] = l$tags.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$tags = tags;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$tags.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneSetTags$sceneUpdate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

class Variables$Mutation$SceneAddO {
  factory Variables$Mutation$SceneAddO({required String id}) =>
      Variables$Mutation$SceneAddO._({r'id': id});

  Variables$Mutation$SceneAddO._(this._$data);

  factory Variables$Mutation$SceneAddO.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$SceneAddO._(result$data);
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
    if (other is! Variables$Mutation$SceneAddO ||
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

class Mutation$SceneAddO {
  Mutation$SceneAddO({required this.sceneAddO, this.$__typename = 'Mutation'});

  factory Mutation$SceneAddO.fromJson(Map<String, dynamic> json) {
    final l$sceneAddO = json['sceneAddO'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneAddO(
      sceneAddO: Mutation$SceneAddO$sceneAddO.fromJson(
        (l$sceneAddO as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SceneAddO$sceneAddO sceneAddO;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneAddO = sceneAddO;
    _resultData['sceneAddO'] = l$sceneAddO.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneAddO = sceneAddO;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneAddO, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneAddO || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneAddO = sceneAddO;
    final lOther$sceneAddO = other.sceneAddO;
    if (l$sceneAddO != lOther$sceneAddO) {
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

const documentNodeMutationSceneAddO = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneAddO'),
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
            name: NameNode(value: 'sceneAddO'),
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
Mutation$SceneAddO _parserFn$Mutation$SceneAddO(Map<String, dynamic> data) =>
    Mutation$SceneAddO.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneAddO = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SceneAddO?,
);

class Options$Mutation$SceneAddO
    extends graphql.MutationOptions<Mutation$SceneAddO> {
  Options$Mutation$SceneAddO({
    String? operationName,
    required Variables$Mutation$SceneAddO variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneAddO? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneAddO? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneAddO>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneAddO',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$SceneAddO(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneAddO,
         parserFn: _parserFn$Mutation$SceneAddO,
       );

  final OnMutationCompleted$Mutation$SceneAddO? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneAddO
    extends graphql.WatchQueryOptions<Mutation$SceneAddO> {
  WatchOptions$Mutation$SceneAddO({
    String? operationName,
    required Variables$Mutation$SceneAddO variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneAddO? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneAddO',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneAddO,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneAddO,
       );
}

extension ClientExtension$Mutation$SceneAddO on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneAddO>> mutate$SceneAddO(
    Options$Mutation$SceneAddO options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneAddO> watchMutation$SceneAddO(
    WatchOptions$Mutation$SceneAddO options,
  ) => this.watchMutation(options);
}

class Mutation$SceneAddO$sceneAddO {
  Mutation$SceneAddO$sceneAddO({
    required this.count,
    this.$__typename = 'HistoryMutationResult',
  });

  factory Mutation$SceneAddO$sceneAddO.fromJson(Map<String, dynamic> json) {
    final l$count = json['count'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneAddO$sceneAddO(
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
    if (other is! Mutation$SceneAddO$sceneAddO ||
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

class Variables$Mutation$SceneDeleteO {
  factory Variables$Mutation$SceneDeleteO({required String id}) =>
      Variables$Mutation$SceneDeleteO._({r'id': id});

  Variables$Mutation$SceneDeleteO._(this._$data);

  factory Variables$Mutation$SceneDeleteO.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$SceneDeleteO._(result$data);
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
    if (other is! Variables$Mutation$SceneDeleteO ||
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

class Mutation$SceneDeleteO {
  Mutation$SceneDeleteO({
    required this.sceneDeleteO,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SceneDeleteO.fromJson(Map<String, dynamic> json) {
    final l$sceneDeleteO = json['sceneDeleteO'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneDeleteO(
      sceneDeleteO: Mutation$SceneDeleteO$sceneDeleteO.fromJson(
        (l$sceneDeleteO as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SceneDeleteO$sceneDeleteO sceneDeleteO;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneDeleteO = sceneDeleteO;
    _resultData['sceneDeleteO'] = l$sceneDeleteO.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneDeleteO = sceneDeleteO;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneDeleteO, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneDeleteO || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneDeleteO = sceneDeleteO;
    final lOther$sceneDeleteO = other.sceneDeleteO;
    if (l$sceneDeleteO != lOther$sceneDeleteO) {
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

const documentNodeMutationSceneDeleteO = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneDeleteO'),
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
            name: NameNode(value: 'sceneDeleteO'),
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
Mutation$SceneDeleteO _parserFn$Mutation$SceneDeleteO(
  Map<String, dynamic> data,
) => Mutation$SceneDeleteO.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneDeleteO = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SceneDeleteO?,
);

class Options$Mutation$SceneDeleteO
    extends graphql.MutationOptions<Mutation$SceneDeleteO> {
  Options$Mutation$SceneDeleteO({
    String? operationName,
    required Variables$Mutation$SceneDeleteO variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneDeleteO? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneDeleteO? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneDeleteO>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneDeleteO',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$SceneDeleteO(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneDeleteO,
         parserFn: _parserFn$Mutation$SceneDeleteO,
       );

  final OnMutationCompleted$Mutation$SceneDeleteO? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneDeleteO
    extends graphql.WatchQueryOptions<Mutation$SceneDeleteO> {
  WatchOptions$Mutation$SceneDeleteO({
    String? operationName,
    required Variables$Mutation$SceneDeleteO variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneDeleteO? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneDeleteO',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneDeleteO,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneDeleteO,
       );
}

extension ClientExtension$Mutation$SceneDeleteO on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneDeleteO>> mutate$SceneDeleteO(
    Options$Mutation$SceneDeleteO options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneDeleteO> watchMutation$SceneDeleteO(
    WatchOptions$Mutation$SceneDeleteO options,
  ) => this.watchMutation(options);
}

class Mutation$SceneDeleteO$sceneDeleteO {
  Mutation$SceneDeleteO$sceneDeleteO({
    required this.count,
    this.$__typename = 'HistoryMutationResult',
  });

  factory Mutation$SceneDeleteO$sceneDeleteO.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$count = json['count'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneDeleteO$sceneDeleteO(
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
    if (other is! Mutation$SceneDeleteO$sceneDeleteO ||
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

class Variables$Mutation$SceneMarkerCreate {
  factory Variables$Mutation$SceneMarkerCreate({
    required Input$SceneMarkerCreateInput input,
  }) => Variables$Mutation$SceneMarkerCreate._({r'input': input});

  Variables$Mutation$SceneMarkerCreate._(this._$data);

  factory Variables$Mutation$SceneMarkerCreate.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$SceneMarkerCreateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$SceneMarkerCreate._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$SceneMarkerCreateInput get input =>
      (_$data['input'] as Input$SceneMarkerCreateInput);

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
    if (other is! Variables$Mutation$SceneMarkerCreate ||
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

class Mutation$SceneMarkerCreate {
  Mutation$SceneMarkerCreate({
    this.sceneMarkerCreate,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SceneMarkerCreate.fromJson(Map<String, dynamic> json) {
    final l$sceneMarkerCreate = json['sceneMarkerCreate'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneMarkerCreate(
      sceneMarkerCreate: l$sceneMarkerCreate == null
          ? null
          : Fragment$MarkerFields.fromJson(
              (l$sceneMarkerCreate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$MarkerFields? sceneMarkerCreate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneMarkerCreate = sceneMarkerCreate;
    _resultData['sceneMarkerCreate'] = l$sceneMarkerCreate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneMarkerCreate = sceneMarkerCreate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneMarkerCreate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneMarkerCreate ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneMarkerCreate = sceneMarkerCreate;
    final lOther$sceneMarkerCreate = other.sceneMarkerCreate;
    if (l$sceneMarkerCreate != lOther$sceneMarkerCreate) {
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

const documentNodeMutationSceneMarkerCreate = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneMarkerCreate'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'SceneMarkerCreateInput'),
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
            name: NameNode(value: 'sceneMarkerCreate'),
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
                  name: NameNode(value: 'MarkerFields'),
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
    fragmentDefinitionMarkerFields,
  ],
);
Mutation$SceneMarkerCreate _parserFn$Mutation$SceneMarkerCreate(
  Map<String, dynamic> data,
) => Mutation$SceneMarkerCreate.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneMarkerCreate =
    FutureOr<void> Function(Map<String, dynamic>?, Mutation$SceneMarkerCreate?);

class Options$Mutation$SceneMarkerCreate
    extends graphql.MutationOptions<Mutation$SceneMarkerCreate> {
  Options$Mutation$SceneMarkerCreate({
    String? operationName,
    required Variables$Mutation$SceneMarkerCreate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneMarkerCreate? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneMarkerCreate? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneMarkerCreate>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneMarkerCreate',
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
                     : _parserFn$Mutation$SceneMarkerCreate(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneMarkerCreate,
         parserFn: _parserFn$Mutation$SceneMarkerCreate,
       );

  final OnMutationCompleted$Mutation$SceneMarkerCreate? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneMarkerCreate
    extends graphql.WatchQueryOptions<Mutation$SceneMarkerCreate> {
  WatchOptions$Mutation$SceneMarkerCreate({
    String? operationName,
    required Variables$Mutation$SceneMarkerCreate variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneMarkerCreate? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneMarkerCreate',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneMarkerCreate,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneMarkerCreate,
       );
}

extension ClientExtension$Mutation$SceneMarkerCreate on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneMarkerCreate>>
  mutate$SceneMarkerCreate(Options$Mutation$SceneMarkerCreate options) async =>
      await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneMarkerCreate>
  watchMutation$SceneMarkerCreate(
    WatchOptions$Mutation$SceneMarkerCreate options,
  ) => this.watchMutation(options);
}

class Variables$Mutation$SceneEdit {
  factory Variables$Mutation$SceneEdit({
    required Input$SceneUpdateInput input,
  }) => Variables$Mutation$SceneEdit._({r'input': input});

  Variables$Mutation$SceneEdit._(this._$data);

  factory Variables$Mutation$SceneEdit.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$SceneUpdateInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$SceneEdit._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$SceneUpdateInput get input =>
      (_$data['input'] as Input$SceneUpdateInput);

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
    if (other is! Variables$Mutation$SceneEdit ||
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

class Mutation$SceneEdit {
  Mutation$SceneEdit({this.sceneUpdate, this.$__typename = 'Mutation'});

  factory Mutation$SceneEdit.fromJson(Map<String, dynamic> json) {
    final l$sceneUpdate = json['sceneUpdate'];
    final l$$__typename = json['__typename'];
    return Mutation$SceneEdit(
      sceneUpdate: l$sceneUpdate == null
          ? null
          : Fragment$SceneFields.fromJson(
              (l$sceneUpdate as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$SceneFields? sceneUpdate;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sceneUpdate = sceneUpdate;
    _resultData['sceneUpdate'] = l$sceneUpdate?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sceneUpdate = sceneUpdate;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sceneUpdate, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SceneEdit || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sceneUpdate = sceneUpdate;
    final lOther$sceneUpdate = other.sceneUpdate;
    if (l$sceneUpdate != lOther$sceneUpdate) {
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

const documentNodeMutationSceneEdit = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SceneEdit'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'SceneUpdateInput'),
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
            name: NameNode(value: 'sceneUpdate'),
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
                  name: NameNode(value: 'SceneFields'),
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
    fragmentDefinitionSceneFields,
    fragmentDefinitionStudioRef,
    fragmentDefinitionPerformerRef,
    fragmentDefinitionTagRef,
  ],
);
Mutation$SceneEdit _parserFn$Mutation$SceneEdit(Map<String, dynamic> data) =>
    Mutation$SceneEdit.fromJson(data);
typedef OnMutationCompleted$Mutation$SceneEdit = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SceneEdit?,
);

class Options$Mutation$SceneEdit
    extends graphql.MutationOptions<Mutation$SceneEdit> {
  Options$Mutation$SceneEdit({
    String? operationName,
    required Variables$Mutation$SceneEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneEdit? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SceneEdit? onCompleted,
    graphql.OnMutationUpdate<Mutation$SceneEdit>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$SceneEdit(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSceneEdit,
         parserFn: _parserFn$Mutation$SceneEdit,
       );

  final OnMutationCompleted$Mutation$SceneEdit? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SceneEdit
    extends graphql.WatchQueryOptions<Mutation$SceneEdit> {
  WatchOptions$Mutation$SceneEdit({
    String? operationName,
    required Variables$Mutation$SceneEdit variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SceneEdit? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName ?? 'SceneEdit',
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationSceneEdit,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SceneEdit,
       );
}

extension ClientExtension$Mutation$SceneEdit on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SceneEdit>> mutate$SceneEdit(
    Options$Mutation$SceneEdit options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SceneEdit> watchMutation$SceneEdit(
    WatchOptions$Mutation$SceneEdit options,
  ) => this.watchMutation(options);
}
