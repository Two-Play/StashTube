import 'config.graphql.dart';
import 'scraper.graphql.dart';

class Input$GenerateMetadataInput {
  factory Input$GenerateMetadataInput({
    bool? covers,
    bool? sprites,
    bool? previews,
    bool? imagePreviews,
    Input$GeneratePreviewOptionsInput? previewOptions,
    bool? markers,
    bool? markerImagePreviews,
    bool? markerScreenshots,
    bool? transcodes,
    bool? forceTranscodes,
    bool? phashes,
    bool? interactiveHeatmapsSpeeds,
    bool? imageThumbnails,
    bool? clipPreviews,
    List<String>? sceneIDs,
    List<String>? markerIDs,
    bool? overwrite,
  }) =>
      Input$GenerateMetadataInput._({
        if (covers != null) r'covers': covers,
        if (sprites != null) r'sprites': sprites,
        if (previews != null) r'previews': previews,
        if (imagePreviews != null) r'imagePreviews': imagePreviews,
        if (previewOptions != null) r'previewOptions': previewOptions,
        if (markers != null) r'markers': markers,
        if (markerImagePreviews != null)
          r'markerImagePreviews': markerImagePreviews,
        if (markerScreenshots != null) r'markerScreenshots': markerScreenshots,
        if (transcodes != null) r'transcodes': transcodes,
        if (forceTranscodes != null) r'forceTranscodes': forceTranscodes,
        if (phashes != null) r'phashes': phashes,
        if (interactiveHeatmapsSpeeds != null)
          r'interactiveHeatmapsSpeeds': interactiveHeatmapsSpeeds,
        if (imageThumbnails != null) r'imageThumbnails': imageThumbnails,
        if (clipPreviews != null) r'clipPreviews': clipPreviews,
        if (sceneIDs != null) r'sceneIDs': sceneIDs,
        if (markerIDs != null) r'markerIDs': markerIDs,
        if (overwrite != null) r'overwrite': overwrite,
      });

  Input$GenerateMetadataInput._(this._$data);

  factory Input$GenerateMetadataInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('covers')) {
      final l$covers = data['covers'];
      result$data['covers'] = (l$covers as bool?);
    }
    if (data.containsKey('sprites')) {
      final l$sprites = data['sprites'];
      result$data['sprites'] = (l$sprites as bool?);
    }
    if (data.containsKey('previews')) {
      final l$previews = data['previews'];
      result$data['previews'] = (l$previews as bool?);
    }
    if (data.containsKey('imagePreviews')) {
      final l$imagePreviews = data['imagePreviews'];
      result$data['imagePreviews'] = (l$imagePreviews as bool?);
    }
    if (data.containsKey('previewOptions')) {
      final l$previewOptions = data['previewOptions'];
      result$data['previewOptions'] = l$previewOptions == null
          ? null
          : Input$GeneratePreviewOptionsInput.fromJson(
              (l$previewOptions as Map<String, dynamic>));
    }
    if (data.containsKey('markers')) {
      final l$markers = data['markers'];
      result$data['markers'] = (l$markers as bool?);
    }
    if (data.containsKey('markerImagePreviews')) {
      final l$markerImagePreviews = data['markerImagePreviews'];
      result$data['markerImagePreviews'] = (l$markerImagePreviews as bool?);
    }
    if (data.containsKey('markerScreenshots')) {
      final l$markerScreenshots = data['markerScreenshots'];
      result$data['markerScreenshots'] = (l$markerScreenshots as bool?);
    }
    if (data.containsKey('transcodes')) {
      final l$transcodes = data['transcodes'];
      result$data['transcodes'] = (l$transcodes as bool?);
    }
    if (data.containsKey('forceTranscodes')) {
      final l$forceTranscodes = data['forceTranscodes'];
      result$data['forceTranscodes'] = (l$forceTranscodes as bool?);
    }
    if (data.containsKey('phashes')) {
      final l$phashes = data['phashes'];
      result$data['phashes'] = (l$phashes as bool?);
    }
    if (data.containsKey('interactiveHeatmapsSpeeds')) {
      final l$interactiveHeatmapsSpeeds = data['interactiveHeatmapsSpeeds'];
      result$data['interactiveHeatmapsSpeeds'] =
          (l$interactiveHeatmapsSpeeds as bool?);
    }
    if (data.containsKey('imageThumbnails')) {
      final l$imageThumbnails = data['imageThumbnails'];
      result$data['imageThumbnails'] = (l$imageThumbnails as bool?);
    }
    if (data.containsKey('clipPreviews')) {
      final l$clipPreviews = data['clipPreviews'];
      result$data['clipPreviews'] = (l$clipPreviews as bool?);
    }
    if (data.containsKey('sceneIDs')) {
      final l$sceneIDs = data['sceneIDs'];
      result$data['sceneIDs'] =
          (l$sceneIDs as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('markerIDs')) {
      final l$markerIDs = data['markerIDs'];
      result$data['markerIDs'] =
          (l$markerIDs as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('overwrite')) {
      final l$overwrite = data['overwrite'];
      result$data['overwrite'] = (l$overwrite as bool?);
    }
    return Input$GenerateMetadataInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get covers => (_$data['covers'] as bool?);

  bool? get sprites => (_$data['sprites'] as bool?);

  bool? get previews => (_$data['previews'] as bool?);

  bool? get imagePreviews => (_$data['imagePreviews'] as bool?);

  Input$GeneratePreviewOptionsInput? get previewOptions =>
      (_$data['previewOptions'] as Input$GeneratePreviewOptionsInput?);

  bool? get markers => (_$data['markers'] as bool?);

  bool? get markerImagePreviews => (_$data['markerImagePreviews'] as bool?);

  bool? get markerScreenshots => (_$data['markerScreenshots'] as bool?);

  bool? get transcodes => (_$data['transcodes'] as bool?);

  bool? get forceTranscodes => (_$data['forceTranscodes'] as bool?);

  bool? get phashes => (_$data['phashes'] as bool?);

  bool? get interactiveHeatmapsSpeeds =>
      (_$data['interactiveHeatmapsSpeeds'] as bool?);

  bool? get imageThumbnails => (_$data['imageThumbnails'] as bool?);

  bool? get clipPreviews => (_$data['clipPreviews'] as bool?);

  List<String>? get sceneIDs => (_$data['sceneIDs'] as List<String>?);

  List<String>? get markerIDs => (_$data['markerIDs'] as List<String>?);

  bool? get overwrite => (_$data['overwrite'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('covers')) {
      final l$covers = covers;
      result$data['covers'] = l$covers;
    }
    if (_$data.containsKey('sprites')) {
      final l$sprites = sprites;
      result$data['sprites'] = l$sprites;
    }
    if (_$data.containsKey('previews')) {
      final l$previews = previews;
      result$data['previews'] = l$previews;
    }
    if (_$data.containsKey('imagePreviews')) {
      final l$imagePreviews = imagePreviews;
      result$data['imagePreviews'] = l$imagePreviews;
    }
    if (_$data.containsKey('previewOptions')) {
      final l$previewOptions = previewOptions;
      result$data['previewOptions'] = l$previewOptions?.toJson();
    }
    if (_$data.containsKey('markers')) {
      final l$markers = markers;
      result$data['markers'] = l$markers;
    }
    if (_$data.containsKey('markerImagePreviews')) {
      final l$markerImagePreviews = markerImagePreviews;
      result$data['markerImagePreviews'] = l$markerImagePreviews;
    }
    if (_$data.containsKey('markerScreenshots')) {
      final l$markerScreenshots = markerScreenshots;
      result$data['markerScreenshots'] = l$markerScreenshots;
    }
    if (_$data.containsKey('transcodes')) {
      final l$transcodes = transcodes;
      result$data['transcodes'] = l$transcodes;
    }
    if (_$data.containsKey('forceTranscodes')) {
      final l$forceTranscodes = forceTranscodes;
      result$data['forceTranscodes'] = l$forceTranscodes;
    }
    if (_$data.containsKey('phashes')) {
      final l$phashes = phashes;
      result$data['phashes'] = l$phashes;
    }
    if (_$data.containsKey('interactiveHeatmapsSpeeds')) {
      final l$interactiveHeatmapsSpeeds = interactiveHeatmapsSpeeds;
      result$data['interactiveHeatmapsSpeeds'] = l$interactiveHeatmapsSpeeds;
    }
    if (_$data.containsKey('imageThumbnails')) {
      final l$imageThumbnails = imageThumbnails;
      result$data['imageThumbnails'] = l$imageThumbnails;
    }
    if (_$data.containsKey('clipPreviews')) {
      final l$clipPreviews = clipPreviews;
      result$data['clipPreviews'] = l$clipPreviews;
    }
    if (_$data.containsKey('sceneIDs')) {
      final l$sceneIDs = sceneIDs;
      result$data['sceneIDs'] = l$sceneIDs?.map((e) => e).toList();
    }
    if (_$data.containsKey('markerIDs')) {
      final l$markerIDs = markerIDs;
      result$data['markerIDs'] = l$markerIDs?.map((e) => e).toList();
    }
    if (_$data.containsKey('overwrite')) {
      final l$overwrite = overwrite;
      result$data['overwrite'] = l$overwrite;
    }
    return result$data;
  }

  CopyWith$Input$GenerateMetadataInput<Input$GenerateMetadataInput>
      get copyWith => CopyWith$Input$GenerateMetadataInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GenerateMetadataInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$covers = covers;
    final lOther$covers = other.covers;
    if (_$data.containsKey('covers') != other._$data.containsKey('covers')) {
      return false;
    }
    if (l$covers != lOther$covers) {
      return false;
    }
    final l$sprites = sprites;
    final lOther$sprites = other.sprites;
    if (_$data.containsKey('sprites') != other._$data.containsKey('sprites')) {
      return false;
    }
    if (l$sprites != lOther$sprites) {
      return false;
    }
    final l$previews = previews;
    final lOther$previews = other.previews;
    if (_$data.containsKey('previews') !=
        other._$data.containsKey('previews')) {
      return false;
    }
    if (l$previews != lOther$previews) {
      return false;
    }
    final l$imagePreviews = imagePreviews;
    final lOther$imagePreviews = other.imagePreviews;
    if (_$data.containsKey('imagePreviews') !=
        other._$data.containsKey('imagePreviews')) {
      return false;
    }
    if (l$imagePreviews != lOther$imagePreviews) {
      return false;
    }
    final l$previewOptions = previewOptions;
    final lOther$previewOptions = other.previewOptions;
    if (_$data.containsKey('previewOptions') !=
        other._$data.containsKey('previewOptions')) {
      return false;
    }
    if (l$previewOptions != lOther$previewOptions) {
      return false;
    }
    final l$markers = markers;
    final lOther$markers = other.markers;
    if (_$data.containsKey('markers') != other._$data.containsKey('markers')) {
      return false;
    }
    if (l$markers != lOther$markers) {
      return false;
    }
    final l$markerImagePreviews = markerImagePreviews;
    final lOther$markerImagePreviews = other.markerImagePreviews;
    if (_$data.containsKey('markerImagePreviews') !=
        other._$data.containsKey('markerImagePreviews')) {
      return false;
    }
    if (l$markerImagePreviews != lOther$markerImagePreviews) {
      return false;
    }
    final l$markerScreenshots = markerScreenshots;
    final lOther$markerScreenshots = other.markerScreenshots;
    if (_$data.containsKey('markerScreenshots') !=
        other._$data.containsKey('markerScreenshots')) {
      return false;
    }
    if (l$markerScreenshots != lOther$markerScreenshots) {
      return false;
    }
    final l$transcodes = transcodes;
    final lOther$transcodes = other.transcodes;
    if (_$data.containsKey('transcodes') !=
        other._$data.containsKey('transcodes')) {
      return false;
    }
    if (l$transcodes != lOther$transcodes) {
      return false;
    }
    final l$forceTranscodes = forceTranscodes;
    final lOther$forceTranscodes = other.forceTranscodes;
    if (_$data.containsKey('forceTranscodes') !=
        other._$data.containsKey('forceTranscodes')) {
      return false;
    }
    if (l$forceTranscodes != lOther$forceTranscodes) {
      return false;
    }
    final l$phashes = phashes;
    final lOther$phashes = other.phashes;
    if (_$data.containsKey('phashes') != other._$data.containsKey('phashes')) {
      return false;
    }
    if (l$phashes != lOther$phashes) {
      return false;
    }
    final l$interactiveHeatmapsSpeeds = interactiveHeatmapsSpeeds;
    final lOther$interactiveHeatmapsSpeeds = other.interactiveHeatmapsSpeeds;
    if (_$data.containsKey('interactiveHeatmapsSpeeds') !=
        other._$data.containsKey('interactiveHeatmapsSpeeds')) {
      return false;
    }
    if (l$interactiveHeatmapsSpeeds != lOther$interactiveHeatmapsSpeeds) {
      return false;
    }
    final l$imageThumbnails = imageThumbnails;
    final lOther$imageThumbnails = other.imageThumbnails;
    if (_$data.containsKey('imageThumbnails') !=
        other._$data.containsKey('imageThumbnails')) {
      return false;
    }
    if (l$imageThumbnails != lOther$imageThumbnails) {
      return false;
    }
    final l$clipPreviews = clipPreviews;
    final lOther$clipPreviews = other.clipPreviews;
    if (_$data.containsKey('clipPreviews') !=
        other._$data.containsKey('clipPreviews')) {
      return false;
    }
    if (l$clipPreviews != lOther$clipPreviews) {
      return false;
    }
    final l$sceneIDs = sceneIDs;
    final lOther$sceneIDs = other.sceneIDs;
    if (_$data.containsKey('sceneIDs') !=
        other._$data.containsKey('sceneIDs')) {
      return false;
    }
    if (l$sceneIDs != null && lOther$sceneIDs != null) {
      if (l$sceneIDs.length != lOther$sceneIDs.length) {
        return false;
      }
      for (int i = 0; i < l$sceneIDs.length; i++) {
        final l$sceneIDs$entry = l$sceneIDs[i];
        final lOther$sceneIDs$entry = lOther$sceneIDs[i];
        if (l$sceneIDs$entry != lOther$sceneIDs$entry) {
          return false;
        }
      }
    } else if (l$sceneIDs != lOther$sceneIDs) {
      return false;
    }
    final l$markerIDs = markerIDs;
    final lOther$markerIDs = other.markerIDs;
    if (_$data.containsKey('markerIDs') !=
        other._$data.containsKey('markerIDs')) {
      return false;
    }
    if (l$markerIDs != null && lOther$markerIDs != null) {
      if (l$markerIDs.length != lOther$markerIDs.length) {
        return false;
      }
      for (int i = 0; i < l$markerIDs.length; i++) {
        final l$markerIDs$entry = l$markerIDs[i];
        final lOther$markerIDs$entry = lOther$markerIDs[i];
        if (l$markerIDs$entry != lOther$markerIDs$entry) {
          return false;
        }
      }
    } else if (l$markerIDs != lOther$markerIDs) {
      return false;
    }
    final l$overwrite = overwrite;
    final lOther$overwrite = other.overwrite;
    if (_$data.containsKey('overwrite') !=
        other._$data.containsKey('overwrite')) {
      return false;
    }
    if (l$overwrite != lOther$overwrite) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$covers = covers;
    final l$sprites = sprites;
    final l$previews = previews;
    final l$imagePreviews = imagePreviews;
    final l$previewOptions = previewOptions;
    final l$markers = markers;
    final l$markerImagePreviews = markerImagePreviews;
    final l$markerScreenshots = markerScreenshots;
    final l$transcodes = transcodes;
    final l$forceTranscodes = forceTranscodes;
    final l$phashes = phashes;
    final l$interactiveHeatmapsSpeeds = interactiveHeatmapsSpeeds;
    final l$imageThumbnails = imageThumbnails;
    final l$clipPreviews = clipPreviews;
    final l$sceneIDs = sceneIDs;
    final l$markerIDs = markerIDs;
    final l$overwrite = overwrite;
    return Object.hashAll([
      _$data.containsKey('covers') ? l$covers : const {},
      _$data.containsKey('sprites') ? l$sprites : const {},
      _$data.containsKey('previews') ? l$previews : const {},
      _$data.containsKey('imagePreviews') ? l$imagePreviews : const {},
      _$data.containsKey('previewOptions') ? l$previewOptions : const {},
      _$data.containsKey('markers') ? l$markers : const {},
      _$data.containsKey('markerImagePreviews')
          ? l$markerImagePreviews
          : const {},
      _$data.containsKey('markerScreenshots') ? l$markerScreenshots : const {},
      _$data.containsKey('transcodes') ? l$transcodes : const {},
      _$data.containsKey('forceTranscodes') ? l$forceTranscodes : const {},
      _$data.containsKey('phashes') ? l$phashes : const {},
      _$data.containsKey('interactiveHeatmapsSpeeds')
          ? l$interactiveHeatmapsSpeeds
          : const {},
      _$data.containsKey('imageThumbnails') ? l$imageThumbnails : const {},
      _$data.containsKey('clipPreviews') ? l$clipPreviews : const {},
      _$data.containsKey('sceneIDs')
          ? l$sceneIDs == null
              ? null
              : Object.hashAll(l$sceneIDs.map((v) => v))
          : const {},
      _$data.containsKey('markerIDs')
          ? l$markerIDs == null
              ? null
              : Object.hashAll(l$markerIDs.map((v) => v))
          : const {},
      _$data.containsKey('overwrite') ? l$overwrite : const {},
    ]);
  }
}

abstract class CopyWith$Input$GenerateMetadataInput<TRes> {
  factory CopyWith$Input$GenerateMetadataInput(
    Input$GenerateMetadataInput instance,
    TRes Function(Input$GenerateMetadataInput) then,
  ) = _CopyWithImpl$Input$GenerateMetadataInput;

  factory CopyWith$Input$GenerateMetadataInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GenerateMetadataInput;

  TRes call({
    bool? covers,
    bool? sprites,
    bool? previews,
    bool? imagePreviews,
    Input$GeneratePreviewOptionsInput? previewOptions,
    bool? markers,
    bool? markerImagePreviews,
    bool? markerScreenshots,
    bool? transcodes,
    bool? forceTranscodes,
    bool? phashes,
    bool? interactiveHeatmapsSpeeds,
    bool? imageThumbnails,
    bool? clipPreviews,
    List<String>? sceneIDs,
    List<String>? markerIDs,
    bool? overwrite,
  });
  CopyWith$Input$GeneratePreviewOptionsInput<TRes> get previewOptions;
}

class _CopyWithImpl$Input$GenerateMetadataInput<TRes>
    implements CopyWith$Input$GenerateMetadataInput<TRes> {
  _CopyWithImpl$Input$GenerateMetadataInput(
    this._instance,
    this._then,
  );

  final Input$GenerateMetadataInput _instance;

  final TRes Function(Input$GenerateMetadataInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? covers = _undefined,
    Object? sprites = _undefined,
    Object? previews = _undefined,
    Object? imagePreviews = _undefined,
    Object? previewOptions = _undefined,
    Object? markers = _undefined,
    Object? markerImagePreviews = _undefined,
    Object? markerScreenshots = _undefined,
    Object? transcodes = _undefined,
    Object? forceTranscodes = _undefined,
    Object? phashes = _undefined,
    Object? interactiveHeatmapsSpeeds = _undefined,
    Object? imageThumbnails = _undefined,
    Object? clipPreviews = _undefined,
    Object? sceneIDs = _undefined,
    Object? markerIDs = _undefined,
    Object? overwrite = _undefined,
  }) =>
      _then(Input$GenerateMetadataInput._({
        ..._instance._$data,
        if (covers != _undefined) 'covers': (covers as bool?),
        if (sprites != _undefined) 'sprites': (sprites as bool?),
        if (previews != _undefined) 'previews': (previews as bool?),
        if (imagePreviews != _undefined)
          'imagePreviews': (imagePreviews as bool?),
        if (previewOptions != _undefined)
          'previewOptions':
              (previewOptions as Input$GeneratePreviewOptionsInput?),
        if (markers != _undefined) 'markers': (markers as bool?),
        if (markerImagePreviews != _undefined)
          'markerImagePreviews': (markerImagePreviews as bool?),
        if (markerScreenshots != _undefined)
          'markerScreenshots': (markerScreenshots as bool?),
        if (transcodes != _undefined) 'transcodes': (transcodes as bool?),
        if (forceTranscodes != _undefined)
          'forceTranscodes': (forceTranscodes as bool?),
        if (phashes != _undefined) 'phashes': (phashes as bool?),
        if (interactiveHeatmapsSpeeds != _undefined)
          'interactiveHeatmapsSpeeds': (interactiveHeatmapsSpeeds as bool?),
        if (imageThumbnails != _undefined)
          'imageThumbnails': (imageThumbnails as bool?),
        if (clipPreviews != _undefined) 'clipPreviews': (clipPreviews as bool?),
        if (sceneIDs != _undefined) 'sceneIDs': (sceneIDs as List<String>?),
        if (markerIDs != _undefined) 'markerIDs': (markerIDs as List<String>?),
        if (overwrite != _undefined) 'overwrite': (overwrite as bool?),
      }));

  CopyWith$Input$GeneratePreviewOptionsInput<TRes> get previewOptions {
    final local$previewOptions = _instance.previewOptions;
    return local$previewOptions == null
        ? CopyWith$Input$GeneratePreviewOptionsInput.stub(_then(_instance))
        : CopyWith$Input$GeneratePreviewOptionsInput(
            local$previewOptions, (e) => call(previewOptions: e));
  }
}

class _CopyWithStubImpl$Input$GenerateMetadataInput<TRes>
    implements CopyWith$Input$GenerateMetadataInput<TRes> {
  _CopyWithStubImpl$Input$GenerateMetadataInput(this._res);

  TRes _res;

  call({
    bool? covers,
    bool? sprites,
    bool? previews,
    bool? imagePreviews,
    Input$GeneratePreviewOptionsInput? previewOptions,
    bool? markers,
    bool? markerImagePreviews,
    bool? markerScreenshots,
    bool? transcodes,
    bool? forceTranscodes,
    bool? phashes,
    bool? interactiveHeatmapsSpeeds,
    bool? imageThumbnails,
    bool? clipPreviews,
    List<String>? sceneIDs,
    List<String>? markerIDs,
    bool? overwrite,
  }) =>
      _res;

  CopyWith$Input$GeneratePreviewOptionsInput<TRes> get previewOptions =>
      CopyWith$Input$GeneratePreviewOptionsInput.stub(_res);
}

class Input$GeneratePreviewOptionsInput {
  factory Input$GeneratePreviewOptionsInput({
    int? previewSegments,
    double? previewSegmentDuration,
    String? previewExcludeStart,
    String? previewExcludeEnd,
    Enum$PreviewPreset? previewPreset,
  }) =>
      Input$GeneratePreviewOptionsInput._({
        if (previewSegments != null) r'previewSegments': previewSegments,
        if (previewSegmentDuration != null)
          r'previewSegmentDuration': previewSegmentDuration,
        if (previewExcludeStart != null)
          r'previewExcludeStart': previewExcludeStart,
        if (previewExcludeEnd != null) r'previewExcludeEnd': previewExcludeEnd,
        if (previewPreset != null) r'previewPreset': previewPreset,
      });

  Input$GeneratePreviewOptionsInput._(this._$data);

  factory Input$GeneratePreviewOptionsInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('previewSegments')) {
      final l$previewSegments = data['previewSegments'];
      result$data['previewSegments'] = (l$previewSegments as int?);
    }
    if (data.containsKey('previewSegmentDuration')) {
      final l$previewSegmentDuration = data['previewSegmentDuration'];
      result$data['previewSegmentDuration'] =
          (l$previewSegmentDuration as num?)?.toDouble();
    }
    if (data.containsKey('previewExcludeStart')) {
      final l$previewExcludeStart = data['previewExcludeStart'];
      result$data['previewExcludeStart'] = (l$previewExcludeStart as String?);
    }
    if (data.containsKey('previewExcludeEnd')) {
      final l$previewExcludeEnd = data['previewExcludeEnd'];
      result$data['previewExcludeEnd'] = (l$previewExcludeEnd as String?);
    }
    if (data.containsKey('previewPreset')) {
      final l$previewPreset = data['previewPreset'];
      result$data['previewPreset'] = l$previewPreset == null
          ? null
          : fromJson$Enum$PreviewPreset((l$previewPreset as String));
    }
    return Input$GeneratePreviewOptionsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get previewSegments => (_$data['previewSegments'] as int?);

  double? get previewSegmentDuration =>
      (_$data['previewSegmentDuration'] as double?);

  String? get previewExcludeStart => (_$data['previewExcludeStart'] as String?);

  String? get previewExcludeEnd => (_$data['previewExcludeEnd'] as String?);

  Enum$PreviewPreset? get previewPreset =>
      (_$data['previewPreset'] as Enum$PreviewPreset?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('previewSegments')) {
      final l$previewSegments = previewSegments;
      result$data['previewSegments'] = l$previewSegments;
    }
    if (_$data.containsKey('previewSegmentDuration')) {
      final l$previewSegmentDuration = previewSegmentDuration;
      result$data['previewSegmentDuration'] = l$previewSegmentDuration;
    }
    if (_$data.containsKey('previewExcludeStart')) {
      final l$previewExcludeStart = previewExcludeStart;
      result$data['previewExcludeStart'] = l$previewExcludeStart;
    }
    if (_$data.containsKey('previewExcludeEnd')) {
      final l$previewExcludeEnd = previewExcludeEnd;
      result$data['previewExcludeEnd'] = l$previewExcludeEnd;
    }
    if (_$data.containsKey('previewPreset')) {
      final l$previewPreset = previewPreset;
      result$data['previewPreset'] = l$previewPreset == null
          ? null
          : toJson$Enum$PreviewPreset(l$previewPreset);
    }
    return result$data;
  }

  CopyWith$Input$GeneratePreviewOptionsInput<Input$GeneratePreviewOptionsInput>
      get copyWith => CopyWith$Input$GeneratePreviewOptionsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GeneratePreviewOptionsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$previewSegments = previewSegments;
    final lOther$previewSegments = other.previewSegments;
    if (_$data.containsKey('previewSegments') !=
        other._$data.containsKey('previewSegments')) {
      return false;
    }
    if (l$previewSegments != lOther$previewSegments) {
      return false;
    }
    final l$previewSegmentDuration = previewSegmentDuration;
    final lOther$previewSegmentDuration = other.previewSegmentDuration;
    if (_$data.containsKey('previewSegmentDuration') !=
        other._$data.containsKey('previewSegmentDuration')) {
      return false;
    }
    if (l$previewSegmentDuration != lOther$previewSegmentDuration) {
      return false;
    }
    final l$previewExcludeStart = previewExcludeStart;
    final lOther$previewExcludeStart = other.previewExcludeStart;
    if (_$data.containsKey('previewExcludeStart') !=
        other._$data.containsKey('previewExcludeStart')) {
      return false;
    }
    if (l$previewExcludeStart != lOther$previewExcludeStart) {
      return false;
    }
    final l$previewExcludeEnd = previewExcludeEnd;
    final lOther$previewExcludeEnd = other.previewExcludeEnd;
    if (_$data.containsKey('previewExcludeEnd') !=
        other._$data.containsKey('previewExcludeEnd')) {
      return false;
    }
    if (l$previewExcludeEnd != lOther$previewExcludeEnd) {
      return false;
    }
    final l$previewPreset = previewPreset;
    final lOther$previewPreset = other.previewPreset;
    if (_$data.containsKey('previewPreset') !=
        other._$data.containsKey('previewPreset')) {
      return false;
    }
    if (l$previewPreset != lOther$previewPreset) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$previewSegments = previewSegments;
    final l$previewSegmentDuration = previewSegmentDuration;
    final l$previewExcludeStart = previewExcludeStart;
    final l$previewExcludeEnd = previewExcludeEnd;
    final l$previewPreset = previewPreset;
    return Object.hashAll([
      _$data.containsKey('previewSegments') ? l$previewSegments : const {},
      _$data.containsKey('previewSegmentDuration')
          ? l$previewSegmentDuration
          : const {},
      _$data.containsKey('previewExcludeStart')
          ? l$previewExcludeStart
          : const {},
      _$data.containsKey('previewExcludeEnd') ? l$previewExcludeEnd : const {},
      _$data.containsKey('previewPreset') ? l$previewPreset : const {},
    ]);
  }
}

abstract class CopyWith$Input$GeneratePreviewOptionsInput<TRes> {
  factory CopyWith$Input$GeneratePreviewOptionsInput(
    Input$GeneratePreviewOptionsInput instance,
    TRes Function(Input$GeneratePreviewOptionsInput) then,
  ) = _CopyWithImpl$Input$GeneratePreviewOptionsInput;

  factory CopyWith$Input$GeneratePreviewOptionsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GeneratePreviewOptionsInput;

  TRes call({
    int? previewSegments,
    double? previewSegmentDuration,
    String? previewExcludeStart,
    String? previewExcludeEnd,
    Enum$PreviewPreset? previewPreset,
  });
}

class _CopyWithImpl$Input$GeneratePreviewOptionsInput<TRes>
    implements CopyWith$Input$GeneratePreviewOptionsInput<TRes> {
  _CopyWithImpl$Input$GeneratePreviewOptionsInput(
    this._instance,
    this._then,
  );

  final Input$GeneratePreviewOptionsInput _instance;

  final TRes Function(Input$GeneratePreviewOptionsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? previewSegments = _undefined,
    Object? previewSegmentDuration = _undefined,
    Object? previewExcludeStart = _undefined,
    Object? previewExcludeEnd = _undefined,
    Object? previewPreset = _undefined,
  }) =>
      _then(Input$GeneratePreviewOptionsInput._({
        ..._instance._$data,
        if (previewSegments != _undefined)
          'previewSegments': (previewSegments as int?),
        if (previewSegmentDuration != _undefined)
          'previewSegmentDuration': (previewSegmentDuration as double?),
        if (previewExcludeStart != _undefined)
          'previewExcludeStart': (previewExcludeStart as String?),
        if (previewExcludeEnd != _undefined)
          'previewExcludeEnd': (previewExcludeEnd as String?),
        if (previewPreset != _undefined)
          'previewPreset': (previewPreset as Enum$PreviewPreset?),
      }));
}

class _CopyWithStubImpl$Input$GeneratePreviewOptionsInput<TRes>
    implements CopyWith$Input$GeneratePreviewOptionsInput<TRes> {
  _CopyWithStubImpl$Input$GeneratePreviewOptionsInput(this._res);

  TRes _res;

  call({
    int? previewSegments,
    double? previewSegmentDuration,
    String? previewExcludeStart,
    String? previewExcludeEnd,
    Enum$PreviewPreset? previewPreset,
  }) =>
      _res;
}

class Input$ScanMetaDataFilterInput {
  factory Input$ScanMetaDataFilterInput({String? minModTime}) =>
      Input$ScanMetaDataFilterInput._({
        if (minModTime != null) r'minModTime': minModTime,
      });

  Input$ScanMetaDataFilterInput._(this._$data);

  factory Input$ScanMetaDataFilterInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('minModTime')) {
      final l$minModTime = data['minModTime'];
      result$data['minModTime'] = (l$minModTime as String?);
    }
    return Input$ScanMetaDataFilterInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get minModTime => (_$data['minModTime'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('minModTime')) {
      final l$minModTime = minModTime;
      result$data['minModTime'] = l$minModTime;
    }
    return result$data;
  }

  CopyWith$Input$ScanMetaDataFilterInput<Input$ScanMetaDataFilterInput>
      get copyWith => CopyWith$Input$ScanMetaDataFilterInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScanMetaDataFilterInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$minModTime = minModTime;
    final lOther$minModTime = other.minModTime;
    if (_$data.containsKey('minModTime') !=
        other._$data.containsKey('minModTime')) {
      return false;
    }
    if (l$minModTime != lOther$minModTime) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$minModTime = minModTime;
    return Object.hashAll(
        [_$data.containsKey('minModTime') ? l$minModTime : const {}]);
  }
}

abstract class CopyWith$Input$ScanMetaDataFilterInput<TRes> {
  factory CopyWith$Input$ScanMetaDataFilterInput(
    Input$ScanMetaDataFilterInput instance,
    TRes Function(Input$ScanMetaDataFilterInput) then,
  ) = _CopyWithImpl$Input$ScanMetaDataFilterInput;

  factory CopyWith$Input$ScanMetaDataFilterInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScanMetaDataFilterInput;

  TRes call({String? minModTime});
}

class _CopyWithImpl$Input$ScanMetaDataFilterInput<TRes>
    implements CopyWith$Input$ScanMetaDataFilterInput<TRes> {
  _CopyWithImpl$Input$ScanMetaDataFilterInput(
    this._instance,
    this._then,
  );

  final Input$ScanMetaDataFilterInput _instance;

  final TRes Function(Input$ScanMetaDataFilterInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? minModTime = _undefined}) =>
      _then(Input$ScanMetaDataFilterInput._({
        ..._instance._$data,
        if (minModTime != _undefined) 'minModTime': (minModTime as String?),
      }));
}

class _CopyWithStubImpl$Input$ScanMetaDataFilterInput<TRes>
    implements CopyWith$Input$ScanMetaDataFilterInput<TRes> {
  _CopyWithStubImpl$Input$ScanMetaDataFilterInput(this._res);

  TRes _res;

  call({String? minModTime}) => _res;
}

class Input$ScanMetadataInput {
  factory Input$ScanMetadataInput({
    List<String>? paths,
    bool? rescan,
    bool? scanGenerateCovers,
    bool? scanGeneratePreviews,
    bool? scanGenerateImagePreviews,
    bool? scanGenerateSprites,
    bool? scanGeneratePhashes,
    bool? scanGenerateThumbnails,
    bool? scanGenerateClipPreviews,
    Input$ScanMetaDataFilterInput? filter,
  }) =>
      Input$ScanMetadataInput._({
        if (paths != null) r'paths': paths,
        if (rescan != null) r'rescan': rescan,
        if (scanGenerateCovers != null)
          r'scanGenerateCovers': scanGenerateCovers,
        if (scanGeneratePreviews != null)
          r'scanGeneratePreviews': scanGeneratePreviews,
        if (scanGenerateImagePreviews != null)
          r'scanGenerateImagePreviews': scanGenerateImagePreviews,
        if (scanGenerateSprites != null)
          r'scanGenerateSprites': scanGenerateSprites,
        if (scanGeneratePhashes != null)
          r'scanGeneratePhashes': scanGeneratePhashes,
        if (scanGenerateThumbnails != null)
          r'scanGenerateThumbnails': scanGenerateThumbnails,
        if (scanGenerateClipPreviews != null)
          r'scanGenerateClipPreviews': scanGenerateClipPreviews,
        if (filter != null) r'filter': filter,
      });

  Input$ScanMetadataInput._(this._$data);

  factory Input$ScanMetadataInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('paths')) {
      final l$paths = data['paths'];
      result$data['paths'] =
          (l$paths as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('rescan')) {
      final l$rescan = data['rescan'];
      result$data['rescan'] = (l$rescan as bool?);
    }
    if (data.containsKey('scanGenerateCovers')) {
      final l$scanGenerateCovers = data['scanGenerateCovers'];
      result$data['scanGenerateCovers'] = (l$scanGenerateCovers as bool?);
    }
    if (data.containsKey('scanGeneratePreviews')) {
      final l$scanGeneratePreviews = data['scanGeneratePreviews'];
      result$data['scanGeneratePreviews'] = (l$scanGeneratePreviews as bool?);
    }
    if (data.containsKey('scanGenerateImagePreviews')) {
      final l$scanGenerateImagePreviews = data['scanGenerateImagePreviews'];
      result$data['scanGenerateImagePreviews'] =
          (l$scanGenerateImagePreviews as bool?);
    }
    if (data.containsKey('scanGenerateSprites')) {
      final l$scanGenerateSprites = data['scanGenerateSprites'];
      result$data['scanGenerateSprites'] = (l$scanGenerateSprites as bool?);
    }
    if (data.containsKey('scanGeneratePhashes')) {
      final l$scanGeneratePhashes = data['scanGeneratePhashes'];
      result$data['scanGeneratePhashes'] = (l$scanGeneratePhashes as bool?);
    }
    if (data.containsKey('scanGenerateThumbnails')) {
      final l$scanGenerateThumbnails = data['scanGenerateThumbnails'];
      result$data['scanGenerateThumbnails'] =
          (l$scanGenerateThumbnails as bool?);
    }
    if (data.containsKey('scanGenerateClipPreviews')) {
      final l$scanGenerateClipPreviews = data['scanGenerateClipPreviews'];
      result$data['scanGenerateClipPreviews'] =
          (l$scanGenerateClipPreviews as bool?);
    }
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$ScanMetaDataFilterInput.fromJson(
              (l$filter as Map<String, dynamic>));
    }
    return Input$ScanMetadataInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get paths => (_$data['paths'] as List<String>?);

  bool? get rescan => (_$data['rescan'] as bool?);

  bool? get scanGenerateCovers => (_$data['scanGenerateCovers'] as bool?);

  bool? get scanGeneratePreviews => (_$data['scanGeneratePreviews'] as bool?);

  bool? get scanGenerateImagePreviews =>
      (_$data['scanGenerateImagePreviews'] as bool?);

  bool? get scanGenerateSprites => (_$data['scanGenerateSprites'] as bool?);

  bool? get scanGeneratePhashes => (_$data['scanGeneratePhashes'] as bool?);

  bool? get scanGenerateThumbnails =>
      (_$data['scanGenerateThumbnails'] as bool?);

  bool? get scanGenerateClipPreviews =>
      (_$data['scanGenerateClipPreviews'] as bool?);

  Input$ScanMetaDataFilterInput? get filter =>
      (_$data['filter'] as Input$ScanMetaDataFilterInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('paths')) {
      final l$paths = paths;
      result$data['paths'] = l$paths?.map((e) => e).toList();
    }
    if (_$data.containsKey('rescan')) {
      final l$rescan = rescan;
      result$data['rescan'] = l$rescan;
    }
    if (_$data.containsKey('scanGenerateCovers')) {
      final l$scanGenerateCovers = scanGenerateCovers;
      result$data['scanGenerateCovers'] = l$scanGenerateCovers;
    }
    if (_$data.containsKey('scanGeneratePreviews')) {
      final l$scanGeneratePreviews = scanGeneratePreviews;
      result$data['scanGeneratePreviews'] = l$scanGeneratePreviews;
    }
    if (_$data.containsKey('scanGenerateImagePreviews')) {
      final l$scanGenerateImagePreviews = scanGenerateImagePreviews;
      result$data['scanGenerateImagePreviews'] = l$scanGenerateImagePreviews;
    }
    if (_$data.containsKey('scanGenerateSprites')) {
      final l$scanGenerateSprites = scanGenerateSprites;
      result$data['scanGenerateSprites'] = l$scanGenerateSprites;
    }
    if (_$data.containsKey('scanGeneratePhashes')) {
      final l$scanGeneratePhashes = scanGeneratePhashes;
      result$data['scanGeneratePhashes'] = l$scanGeneratePhashes;
    }
    if (_$data.containsKey('scanGenerateThumbnails')) {
      final l$scanGenerateThumbnails = scanGenerateThumbnails;
      result$data['scanGenerateThumbnails'] = l$scanGenerateThumbnails;
    }
    if (_$data.containsKey('scanGenerateClipPreviews')) {
      final l$scanGenerateClipPreviews = scanGenerateClipPreviews;
      result$data['scanGenerateClipPreviews'] = l$scanGenerateClipPreviews;
    }
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$ScanMetadataInput<Input$ScanMetadataInput> get copyWith =>
      CopyWith$Input$ScanMetadataInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScanMetadataInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$paths = paths;
    final lOther$paths = other.paths;
    if (_$data.containsKey('paths') != other._$data.containsKey('paths')) {
      return false;
    }
    if (l$paths != null && lOther$paths != null) {
      if (l$paths.length != lOther$paths.length) {
        return false;
      }
      for (int i = 0; i < l$paths.length; i++) {
        final l$paths$entry = l$paths[i];
        final lOther$paths$entry = lOther$paths[i];
        if (l$paths$entry != lOther$paths$entry) {
          return false;
        }
      }
    } else if (l$paths != lOther$paths) {
      return false;
    }
    final l$rescan = rescan;
    final lOther$rescan = other.rescan;
    if (_$data.containsKey('rescan') != other._$data.containsKey('rescan')) {
      return false;
    }
    if (l$rescan != lOther$rescan) {
      return false;
    }
    final l$scanGenerateCovers = scanGenerateCovers;
    final lOther$scanGenerateCovers = other.scanGenerateCovers;
    if (_$data.containsKey('scanGenerateCovers') !=
        other._$data.containsKey('scanGenerateCovers')) {
      return false;
    }
    if (l$scanGenerateCovers != lOther$scanGenerateCovers) {
      return false;
    }
    final l$scanGeneratePreviews = scanGeneratePreviews;
    final lOther$scanGeneratePreviews = other.scanGeneratePreviews;
    if (_$data.containsKey('scanGeneratePreviews') !=
        other._$data.containsKey('scanGeneratePreviews')) {
      return false;
    }
    if (l$scanGeneratePreviews != lOther$scanGeneratePreviews) {
      return false;
    }
    final l$scanGenerateImagePreviews = scanGenerateImagePreviews;
    final lOther$scanGenerateImagePreviews = other.scanGenerateImagePreviews;
    if (_$data.containsKey('scanGenerateImagePreviews') !=
        other._$data.containsKey('scanGenerateImagePreviews')) {
      return false;
    }
    if (l$scanGenerateImagePreviews != lOther$scanGenerateImagePreviews) {
      return false;
    }
    final l$scanGenerateSprites = scanGenerateSprites;
    final lOther$scanGenerateSprites = other.scanGenerateSprites;
    if (_$data.containsKey('scanGenerateSprites') !=
        other._$data.containsKey('scanGenerateSprites')) {
      return false;
    }
    if (l$scanGenerateSprites != lOther$scanGenerateSprites) {
      return false;
    }
    final l$scanGeneratePhashes = scanGeneratePhashes;
    final lOther$scanGeneratePhashes = other.scanGeneratePhashes;
    if (_$data.containsKey('scanGeneratePhashes') !=
        other._$data.containsKey('scanGeneratePhashes')) {
      return false;
    }
    if (l$scanGeneratePhashes != lOther$scanGeneratePhashes) {
      return false;
    }
    final l$scanGenerateThumbnails = scanGenerateThumbnails;
    final lOther$scanGenerateThumbnails = other.scanGenerateThumbnails;
    if (_$data.containsKey('scanGenerateThumbnails') !=
        other._$data.containsKey('scanGenerateThumbnails')) {
      return false;
    }
    if (l$scanGenerateThumbnails != lOther$scanGenerateThumbnails) {
      return false;
    }
    final l$scanGenerateClipPreviews = scanGenerateClipPreviews;
    final lOther$scanGenerateClipPreviews = other.scanGenerateClipPreviews;
    if (_$data.containsKey('scanGenerateClipPreviews') !=
        other._$data.containsKey('scanGenerateClipPreviews')) {
      return false;
    }
    if (l$scanGenerateClipPreviews != lOther$scanGenerateClipPreviews) {
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
    final l$paths = paths;
    final l$rescan = rescan;
    final l$scanGenerateCovers = scanGenerateCovers;
    final l$scanGeneratePreviews = scanGeneratePreviews;
    final l$scanGenerateImagePreviews = scanGenerateImagePreviews;
    final l$scanGenerateSprites = scanGenerateSprites;
    final l$scanGeneratePhashes = scanGeneratePhashes;
    final l$scanGenerateThumbnails = scanGenerateThumbnails;
    final l$scanGenerateClipPreviews = scanGenerateClipPreviews;
    final l$filter = filter;
    return Object.hashAll([
      _$data.containsKey('paths')
          ? l$paths == null
              ? null
              : Object.hashAll(l$paths.map((v) => v))
          : const {},
      _$data.containsKey('rescan') ? l$rescan : const {},
      _$data.containsKey('scanGenerateCovers')
          ? l$scanGenerateCovers
          : const {},
      _$data.containsKey('scanGeneratePreviews')
          ? l$scanGeneratePreviews
          : const {},
      _$data.containsKey('scanGenerateImagePreviews')
          ? l$scanGenerateImagePreviews
          : const {},
      _$data.containsKey('scanGenerateSprites')
          ? l$scanGenerateSprites
          : const {},
      _$data.containsKey('scanGeneratePhashes')
          ? l$scanGeneratePhashes
          : const {},
      _$data.containsKey('scanGenerateThumbnails')
          ? l$scanGenerateThumbnails
          : const {},
      _$data.containsKey('scanGenerateClipPreviews')
          ? l$scanGenerateClipPreviews
          : const {},
      _$data.containsKey('filter') ? l$filter : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScanMetadataInput<TRes> {
  factory CopyWith$Input$ScanMetadataInput(
    Input$ScanMetadataInput instance,
    TRes Function(Input$ScanMetadataInput) then,
  ) = _CopyWithImpl$Input$ScanMetadataInput;

  factory CopyWith$Input$ScanMetadataInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScanMetadataInput;

  TRes call({
    List<String>? paths,
    bool? rescan,
    bool? scanGenerateCovers,
    bool? scanGeneratePreviews,
    bool? scanGenerateImagePreviews,
    bool? scanGenerateSprites,
    bool? scanGeneratePhashes,
    bool? scanGenerateThumbnails,
    bool? scanGenerateClipPreviews,
    Input$ScanMetaDataFilterInput? filter,
  });
  CopyWith$Input$ScanMetaDataFilterInput<TRes> get filter;
}

class _CopyWithImpl$Input$ScanMetadataInput<TRes>
    implements CopyWith$Input$ScanMetadataInput<TRes> {
  _CopyWithImpl$Input$ScanMetadataInput(
    this._instance,
    this._then,
  );

  final Input$ScanMetadataInput _instance;

  final TRes Function(Input$ScanMetadataInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? paths = _undefined,
    Object? rescan = _undefined,
    Object? scanGenerateCovers = _undefined,
    Object? scanGeneratePreviews = _undefined,
    Object? scanGenerateImagePreviews = _undefined,
    Object? scanGenerateSprites = _undefined,
    Object? scanGeneratePhashes = _undefined,
    Object? scanGenerateThumbnails = _undefined,
    Object? scanGenerateClipPreviews = _undefined,
    Object? filter = _undefined,
  }) =>
      _then(Input$ScanMetadataInput._({
        ..._instance._$data,
        if (paths != _undefined) 'paths': (paths as List<String>?),
        if (rescan != _undefined) 'rescan': (rescan as bool?),
        if (scanGenerateCovers != _undefined)
          'scanGenerateCovers': (scanGenerateCovers as bool?),
        if (scanGeneratePreviews != _undefined)
          'scanGeneratePreviews': (scanGeneratePreviews as bool?),
        if (scanGenerateImagePreviews != _undefined)
          'scanGenerateImagePreviews': (scanGenerateImagePreviews as bool?),
        if (scanGenerateSprites != _undefined)
          'scanGenerateSprites': (scanGenerateSprites as bool?),
        if (scanGeneratePhashes != _undefined)
          'scanGeneratePhashes': (scanGeneratePhashes as bool?),
        if (scanGenerateThumbnails != _undefined)
          'scanGenerateThumbnails': (scanGenerateThumbnails as bool?),
        if (scanGenerateClipPreviews != _undefined)
          'scanGenerateClipPreviews': (scanGenerateClipPreviews as bool?),
        if (filter != _undefined)
          'filter': (filter as Input$ScanMetaDataFilterInput?),
      }));

  CopyWith$Input$ScanMetaDataFilterInput<TRes> get filter {
    final local$filter = _instance.filter;
    return local$filter == null
        ? CopyWith$Input$ScanMetaDataFilterInput.stub(_then(_instance))
        : CopyWith$Input$ScanMetaDataFilterInput(
            local$filter, (e) => call(filter: e));
  }
}

class _CopyWithStubImpl$Input$ScanMetadataInput<TRes>
    implements CopyWith$Input$ScanMetadataInput<TRes> {
  _CopyWithStubImpl$Input$ScanMetadataInput(this._res);

  TRes _res;

  call({
    List<String>? paths,
    bool? rescan,
    bool? scanGenerateCovers,
    bool? scanGeneratePreviews,
    bool? scanGenerateImagePreviews,
    bool? scanGenerateSprites,
    bool? scanGeneratePhashes,
    bool? scanGenerateThumbnails,
    bool? scanGenerateClipPreviews,
    Input$ScanMetaDataFilterInput? filter,
  }) =>
      _res;

  CopyWith$Input$ScanMetaDataFilterInput<TRes> get filter =>
      CopyWith$Input$ScanMetaDataFilterInput.stub(_res);
}

class Input$CleanMetadataInput {
  factory Input$CleanMetadataInput({
    List<String>? paths,
    required bool dryRun,
  }) =>
      Input$CleanMetadataInput._({
        if (paths != null) r'paths': paths,
        r'dryRun': dryRun,
      });

  Input$CleanMetadataInput._(this._$data);

  factory Input$CleanMetadataInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('paths')) {
      final l$paths = data['paths'];
      result$data['paths'] =
          (l$paths as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    final l$dryRun = data['dryRun'];
    result$data['dryRun'] = (l$dryRun as bool);
    return Input$CleanMetadataInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get paths => (_$data['paths'] as List<String>?);

  bool get dryRun => (_$data['dryRun'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('paths')) {
      final l$paths = paths;
      result$data['paths'] = l$paths?.map((e) => e).toList();
    }
    final l$dryRun = dryRun;
    result$data['dryRun'] = l$dryRun;
    return result$data;
  }

  CopyWith$Input$CleanMetadataInput<Input$CleanMetadataInput> get copyWith =>
      CopyWith$Input$CleanMetadataInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$CleanMetadataInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$paths = paths;
    final lOther$paths = other.paths;
    if (_$data.containsKey('paths') != other._$data.containsKey('paths')) {
      return false;
    }
    if (l$paths != null && lOther$paths != null) {
      if (l$paths.length != lOther$paths.length) {
        return false;
      }
      for (int i = 0; i < l$paths.length; i++) {
        final l$paths$entry = l$paths[i];
        final lOther$paths$entry = lOther$paths[i];
        if (l$paths$entry != lOther$paths$entry) {
          return false;
        }
      }
    } else if (l$paths != lOther$paths) {
      return false;
    }
    final l$dryRun = dryRun;
    final lOther$dryRun = other.dryRun;
    if (l$dryRun != lOther$dryRun) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$paths = paths;
    final l$dryRun = dryRun;
    return Object.hashAll([
      _$data.containsKey('paths')
          ? l$paths == null
              ? null
              : Object.hashAll(l$paths.map((v) => v))
          : const {},
      l$dryRun,
    ]);
  }
}

abstract class CopyWith$Input$CleanMetadataInput<TRes> {
  factory CopyWith$Input$CleanMetadataInput(
    Input$CleanMetadataInput instance,
    TRes Function(Input$CleanMetadataInput) then,
  ) = _CopyWithImpl$Input$CleanMetadataInput;

  factory CopyWith$Input$CleanMetadataInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CleanMetadataInput;

  TRes call({
    List<String>? paths,
    bool? dryRun,
  });
}

class _CopyWithImpl$Input$CleanMetadataInput<TRes>
    implements CopyWith$Input$CleanMetadataInput<TRes> {
  _CopyWithImpl$Input$CleanMetadataInput(
    this._instance,
    this._then,
  );

  final Input$CleanMetadataInput _instance;

  final TRes Function(Input$CleanMetadataInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? paths = _undefined,
    Object? dryRun = _undefined,
  }) =>
      _then(Input$CleanMetadataInput._({
        ..._instance._$data,
        if (paths != _undefined) 'paths': (paths as List<String>?),
        if (dryRun != _undefined && dryRun != null) 'dryRun': (dryRun as bool),
      }));
}

class _CopyWithStubImpl$Input$CleanMetadataInput<TRes>
    implements CopyWith$Input$CleanMetadataInput<TRes> {
  _CopyWithStubImpl$Input$CleanMetadataInput(this._res);

  TRes _res;

  call({
    List<String>? paths,
    bool? dryRun,
  }) =>
      _res;
}

class Input$CleanGeneratedInput {
  factory Input$CleanGeneratedInput({
    bool? blobFiles,
    bool? sprites,
    bool? screenshots,
    bool? transcodes,
    bool? markers,
    bool? imageThumbnails,
    bool? dryRun,
  }) =>
      Input$CleanGeneratedInput._({
        if (blobFiles != null) r'blobFiles': blobFiles,
        if (sprites != null) r'sprites': sprites,
        if (screenshots != null) r'screenshots': screenshots,
        if (transcodes != null) r'transcodes': transcodes,
        if (markers != null) r'markers': markers,
        if (imageThumbnails != null) r'imageThumbnails': imageThumbnails,
        if (dryRun != null) r'dryRun': dryRun,
      });

  Input$CleanGeneratedInput._(this._$data);

  factory Input$CleanGeneratedInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('blobFiles')) {
      final l$blobFiles = data['blobFiles'];
      result$data['blobFiles'] = (l$blobFiles as bool?);
    }
    if (data.containsKey('sprites')) {
      final l$sprites = data['sprites'];
      result$data['sprites'] = (l$sprites as bool?);
    }
    if (data.containsKey('screenshots')) {
      final l$screenshots = data['screenshots'];
      result$data['screenshots'] = (l$screenshots as bool?);
    }
    if (data.containsKey('transcodes')) {
      final l$transcodes = data['transcodes'];
      result$data['transcodes'] = (l$transcodes as bool?);
    }
    if (data.containsKey('markers')) {
      final l$markers = data['markers'];
      result$data['markers'] = (l$markers as bool?);
    }
    if (data.containsKey('imageThumbnails')) {
      final l$imageThumbnails = data['imageThumbnails'];
      result$data['imageThumbnails'] = (l$imageThumbnails as bool?);
    }
    if (data.containsKey('dryRun')) {
      final l$dryRun = data['dryRun'];
      result$data['dryRun'] = (l$dryRun as bool?);
    }
    return Input$CleanGeneratedInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get blobFiles => (_$data['blobFiles'] as bool?);

  bool? get sprites => (_$data['sprites'] as bool?);

  bool? get screenshots => (_$data['screenshots'] as bool?);

  bool? get transcodes => (_$data['transcodes'] as bool?);

  bool? get markers => (_$data['markers'] as bool?);

  bool? get imageThumbnails => (_$data['imageThumbnails'] as bool?);

  bool? get dryRun => (_$data['dryRun'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('blobFiles')) {
      final l$blobFiles = blobFiles;
      result$data['blobFiles'] = l$blobFiles;
    }
    if (_$data.containsKey('sprites')) {
      final l$sprites = sprites;
      result$data['sprites'] = l$sprites;
    }
    if (_$data.containsKey('screenshots')) {
      final l$screenshots = screenshots;
      result$data['screenshots'] = l$screenshots;
    }
    if (_$data.containsKey('transcodes')) {
      final l$transcodes = transcodes;
      result$data['transcodes'] = l$transcodes;
    }
    if (_$data.containsKey('markers')) {
      final l$markers = markers;
      result$data['markers'] = l$markers;
    }
    if (_$data.containsKey('imageThumbnails')) {
      final l$imageThumbnails = imageThumbnails;
      result$data['imageThumbnails'] = l$imageThumbnails;
    }
    if (_$data.containsKey('dryRun')) {
      final l$dryRun = dryRun;
      result$data['dryRun'] = l$dryRun;
    }
    return result$data;
  }

  CopyWith$Input$CleanGeneratedInput<Input$CleanGeneratedInput> get copyWith =>
      CopyWith$Input$CleanGeneratedInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$CleanGeneratedInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$blobFiles = blobFiles;
    final lOther$blobFiles = other.blobFiles;
    if (_$data.containsKey('blobFiles') !=
        other._$data.containsKey('blobFiles')) {
      return false;
    }
    if (l$blobFiles != lOther$blobFiles) {
      return false;
    }
    final l$sprites = sprites;
    final lOther$sprites = other.sprites;
    if (_$data.containsKey('sprites') != other._$data.containsKey('sprites')) {
      return false;
    }
    if (l$sprites != lOther$sprites) {
      return false;
    }
    final l$screenshots = screenshots;
    final lOther$screenshots = other.screenshots;
    if (_$data.containsKey('screenshots') !=
        other._$data.containsKey('screenshots')) {
      return false;
    }
    if (l$screenshots != lOther$screenshots) {
      return false;
    }
    final l$transcodes = transcodes;
    final lOther$transcodes = other.transcodes;
    if (_$data.containsKey('transcodes') !=
        other._$data.containsKey('transcodes')) {
      return false;
    }
    if (l$transcodes != lOther$transcodes) {
      return false;
    }
    final l$markers = markers;
    final lOther$markers = other.markers;
    if (_$data.containsKey('markers') != other._$data.containsKey('markers')) {
      return false;
    }
    if (l$markers != lOther$markers) {
      return false;
    }
    final l$imageThumbnails = imageThumbnails;
    final lOther$imageThumbnails = other.imageThumbnails;
    if (_$data.containsKey('imageThumbnails') !=
        other._$data.containsKey('imageThumbnails')) {
      return false;
    }
    if (l$imageThumbnails != lOther$imageThumbnails) {
      return false;
    }
    final l$dryRun = dryRun;
    final lOther$dryRun = other.dryRun;
    if (_$data.containsKey('dryRun') != other._$data.containsKey('dryRun')) {
      return false;
    }
    if (l$dryRun != lOther$dryRun) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$blobFiles = blobFiles;
    final l$sprites = sprites;
    final l$screenshots = screenshots;
    final l$transcodes = transcodes;
    final l$markers = markers;
    final l$imageThumbnails = imageThumbnails;
    final l$dryRun = dryRun;
    return Object.hashAll([
      _$data.containsKey('blobFiles') ? l$blobFiles : const {},
      _$data.containsKey('sprites') ? l$sprites : const {},
      _$data.containsKey('screenshots') ? l$screenshots : const {},
      _$data.containsKey('transcodes') ? l$transcodes : const {},
      _$data.containsKey('markers') ? l$markers : const {},
      _$data.containsKey('imageThumbnails') ? l$imageThumbnails : const {},
      _$data.containsKey('dryRun') ? l$dryRun : const {},
    ]);
  }
}

abstract class CopyWith$Input$CleanGeneratedInput<TRes> {
  factory CopyWith$Input$CleanGeneratedInput(
    Input$CleanGeneratedInput instance,
    TRes Function(Input$CleanGeneratedInput) then,
  ) = _CopyWithImpl$Input$CleanGeneratedInput;

  factory CopyWith$Input$CleanGeneratedInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CleanGeneratedInput;

  TRes call({
    bool? blobFiles,
    bool? sprites,
    bool? screenshots,
    bool? transcodes,
    bool? markers,
    bool? imageThumbnails,
    bool? dryRun,
  });
}

class _CopyWithImpl$Input$CleanGeneratedInput<TRes>
    implements CopyWith$Input$CleanGeneratedInput<TRes> {
  _CopyWithImpl$Input$CleanGeneratedInput(
    this._instance,
    this._then,
  );

  final Input$CleanGeneratedInput _instance;

  final TRes Function(Input$CleanGeneratedInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? blobFiles = _undefined,
    Object? sprites = _undefined,
    Object? screenshots = _undefined,
    Object? transcodes = _undefined,
    Object? markers = _undefined,
    Object? imageThumbnails = _undefined,
    Object? dryRun = _undefined,
  }) =>
      _then(Input$CleanGeneratedInput._({
        ..._instance._$data,
        if (blobFiles != _undefined) 'blobFiles': (blobFiles as bool?),
        if (sprites != _undefined) 'sprites': (sprites as bool?),
        if (screenshots != _undefined) 'screenshots': (screenshots as bool?),
        if (transcodes != _undefined) 'transcodes': (transcodes as bool?),
        if (markers != _undefined) 'markers': (markers as bool?),
        if (imageThumbnails != _undefined)
          'imageThumbnails': (imageThumbnails as bool?),
        if (dryRun != _undefined) 'dryRun': (dryRun as bool?),
      }));
}

class _CopyWithStubImpl$Input$CleanGeneratedInput<TRes>
    implements CopyWith$Input$CleanGeneratedInput<TRes> {
  _CopyWithStubImpl$Input$CleanGeneratedInput(this._res);

  TRes _res;

  call({
    bool? blobFiles,
    bool? sprites,
    bool? screenshots,
    bool? transcodes,
    bool? markers,
    bool? imageThumbnails,
    bool? dryRun,
  }) =>
      _res;
}

class Input$AutoTagMetadataInput {
  factory Input$AutoTagMetadataInput({
    List<String>? paths,
    List<String>? performers,
    List<String>? studios,
    List<String>? tags,
  }) =>
      Input$AutoTagMetadataInput._({
        if (paths != null) r'paths': paths,
        if (performers != null) r'performers': performers,
        if (studios != null) r'studios': studios,
        if (tags != null) r'tags': tags,
      });

  Input$AutoTagMetadataInput._(this._$data);

  factory Input$AutoTagMetadataInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('paths')) {
      final l$paths = data['paths'];
      result$data['paths'] =
          (l$paths as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('performers')) {
      final l$performers = data['performers'];
      result$data['performers'] =
          (l$performers as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('studios')) {
      final l$studios = data['studios'];
      result$data['studios'] =
          (l$studios as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('tags')) {
      final l$tags = data['tags'];
      result$data['tags'] =
          (l$tags as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$AutoTagMetadataInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get paths => (_$data['paths'] as List<String>?);

  List<String>? get performers => (_$data['performers'] as List<String>?);

  List<String>? get studios => (_$data['studios'] as List<String>?);

  List<String>? get tags => (_$data['tags'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('paths')) {
      final l$paths = paths;
      result$data['paths'] = l$paths?.map((e) => e).toList();
    }
    if (_$data.containsKey('performers')) {
      final l$performers = performers;
      result$data['performers'] = l$performers?.map((e) => e).toList();
    }
    if (_$data.containsKey('studios')) {
      final l$studios = studios;
      result$data['studios'] = l$studios?.map((e) => e).toList();
    }
    if (_$data.containsKey('tags')) {
      final l$tags = tags;
      result$data['tags'] = l$tags?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$AutoTagMetadataInput<Input$AutoTagMetadataInput>
      get copyWith => CopyWith$Input$AutoTagMetadataInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$AutoTagMetadataInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$paths = paths;
    final lOther$paths = other.paths;
    if (_$data.containsKey('paths') != other._$data.containsKey('paths')) {
      return false;
    }
    if (l$paths != null && lOther$paths != null) {
      if (l$paths.length != lOther$paths.length) {
        return false;
      }
      for (int i = 0; i < l$paths.length; i++) {
        final l$paths$entry = l$paths[i];
        final lOther$paths$entry = lOther$paths[i];
        if (l$paths$entry != lOther$paths$entry) {
          return false;
        }
      }
    } else if (l$paths != lOther$paths) {
      return false;
    }
    final l$performers = performers;
    final lOther$performers = other.performers;
    if (_$data.containsKey('performers') !=
        other._$data.containsKey('performers')) {
      return false;
    }
    if (l$performers != null && lOther$performers != null) {
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
    } else if (l$performers != lOther$performers) {
      return false;
    }
    final l$studios = studios;
    final lOther$studios = other.studios;
    if (_$data.containsKey('studios') != other._$data.containsKey('studios')) {
      return false;
    }
    if (l$studios != null && lOther$studios != null) {
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
    } else if (l$studios != lOther$studios) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (_$data.containsKey('tags') != other._$data.containsKey('tags')) {
      return false;
    }
    if (l$tags != null && lOther$tags != null) {
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
    } else if (l$tags != lOther$tags) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$paths = paths;
    final l$performers = performers;
    final l$studios = studios;
    final l$tags = tags;
    return Object.hashAll([
      _$data.containsKey('paths')
          ? l$paths == null
              ? null
              : Object.hashAll(l$paths.map((v) => v))
          : const {},
      _$data.containsKey('performers')
          ? l$performers == null
              ? null
              : Object.hashAll(l$performers.map((v) => v))
          : const {},
      _$data.containsKey('studios')
          ? l$studios == null
              ? null
              : Object.hashAll(l$studios.map((v) => v))
          : const {},
      _$data.containsKey('tags')
          ? l$tags == null
              ? null
              : Object.hashAll(l$tags.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$AutoTagMetadataInput<TRes> {
  factory CopyWith$Input$AutoTagMetadataInput(
    Input$AutoTagMetadataInput instance,
    TRes Function(Input$AutoTagMetadataInput) then,
  ) = _CopyWithImpl$Input$AutoTagMetadataInput;

  factory CopyWith$Input$AutoTagMetadataInput.stub(TRes res) =
      _CopyWithStubImpl$Input$AutoTagMetadataInput;

  TRes call({
    List<String>? paths,
    List<String>? performers,
    List<String>? studios,
    List<String>? tags,
  });
}

class _CopyWithImpl$Input$AutoTagMetadataInput<TRes>
    implements CopyWith$Input$AutoTagMetadataInput<TRes> {
  _CopyWithImpl$Input$AutoTagMetadataInput(
    this._instance,
    this._then,
  );

  final Input$AutoTagMetadataInput _instance;

  final TRes Function(Input$AutoTagMetadataInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? paths = _undefined,
    Object? performers = _undefined,
    Object? studios = _undefined,
    Object? tags = _undefined,
  }) =>
      _then(Input$AutoTagMetadataInput._({
        ..._instance._$data,
        if (paths != _undefined) 'paths': (paths as List<String>?),
        if (performers != _undefined)
          'performers': (performers as List<String>?),
        if (studios != _undefined) 'studios': (studios as List<String>?),
        if (tags != _undefined) 'tags': (tags as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$AutoTagMetadataInput<TRes>
    implements CopyWith$Input$AutoTagMetadataInput<TRes> {
  _CopyWithStubImpl$Input$AutoTagMetadataInput(this._res);

  TRes _res;

  call({
    List<String>? paths,
    List<String>? performers,
    List<String>? studios,
    List<String>? tags,
  }) =>
      _res;
}

class Input$IdentifyFieldOptionsInput {
  factory Input$IdentifyFieldOptionsInput({
    required String field,
    required Enum$IdentifyFieldStrategy strategy,
    bool? createMissing,
  }) =>
      Input$IdentifyFieldOptionsInput._({
        r'field': field,
        r'strategy': strategy,
        if (createMissing != null) r'createMissing': createMissing,
      });

  Input$IdentifyFieldOptionsInput._(this._$data);

  factory Input$IdentifyFieldOptionsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$field = data['field'];
    result$data['field'] = (l$field as String);
    final l$strategy = data['strategy'];
    result$data['strategy'] =
        fromJson$Enum$IdentifyFieldStrategy((l$strategy as String));
    if (data.containsKey('createMissing')) {
      final l$createMissing = data['createMissing'];
      result$data['createMissing'] = (l$createMissing as bool?);
    }
    return Input$IdentifyFieldOptionsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get field => (_$data['field'] as String);

  Enum$IdentifyFieldStrategy get strategy =>
      (_$data['strategy'] as Enum$IdentifyFieldStrategy);

  bool? get createMissing => (_$data['createMissing'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$field = field;
    result$data['field'] = l$field;
    final l$strategy = strategy;
    result$data['strategy'] = toJson$Enum$IdentifyFieldStrategy(l$strategy);
    if (_$data.containsKey('createMissing')) {
      final l$createMissing = createMissing;
      result$data['createMissing'] = l$createMissing;
    }
    return result$data;
  }

  CopyWith$Input$IdentifyFieldOptionsInput<Input$IdentifyFieldOptionsInput>
      get copyWith => CopyWith$Input$IdentifyFieldOptionsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$IdentifyFieldOptionsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$field = field;
    final lOther$field = other.field;
    if (l$field != lOther$field) {
      return false;
    }
    final l$strategy = strategy;
    final lOther$strategy = other.strategy;
    if (l$strategy != lOther$strategy) {
      return false;
    }
    final l$createMissing = createMissing;
    final lOther$createMissing = other.createMissing;
    if (_$data.containsKey('createMissing') !=
        other._$data.containsKey('createMissing')) {
      return false;
    }
    if (l$createMissing != lOther$createMissing) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$field = field;
    final l$strategy = strategy;
    final l$createMissing = createMissing;
    return Object.hashAll([
      l$field,
      l$strategy,
      _$data.containsKey('createMissing') ? l$createMissing : const {},
    ]);
  }
}

abstract class CopyWith$Input$IdentifyFieldOptionsInput<TRes> {
  factory CopyWith$Input$IdentifyFieldOptionsInput(
    Input$IdentifyFieldOptionsInput instance,
    TRes Function(Input$IdentifyFieldOptionsInput) then,
  ) = _CopyWithImpl$Input$IdentifyFieldOptionsInput;

  factory CopyWith$Input$IdentifyFieldOptionsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$IdentifyFieldOptionsInput;

  TRes call({
    String? field,
    Enum$IdentifyFieldStrategy? strategy,
    bool? createMissing,
  });
}

class _CopyWithImpl$Input$IdentifyFieldOptionsInput<TRes>
    implements CopyWith$Input$IdentifyFieldOptionsInput<TRes> {
  _CopyWithImpl$Input$IdentifyFieldOptionsInput(
    this._instance,
    this._then,
  );

  final Input$IdentifyFieldOptionsInput _instance;

  final TRes Function(Input$IdentifyFieldOptionsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? strategy = _undefined,
    Object? createMissing = _undefined,
  }) =>
      _then(Input$IdentifyFieldOptionsInput._({
        ..._instance._$data,
        if (field != _undefined && field != null) 'field': (field as String),
        if (strategy != _undefined && strategy != null)
          'strategy': (strategy as Enum$IdentifyFieldStrategy),
        if (createMissing != _undefined)
          'createMissing': (createMissing as bool?),
      }));
}

class _CopyWithStubImpl$Input$IdentifyFieldOptionsInput<TRes>
    implements CopyWith$Input$IdentifyFieldOptionsInput<TRes> {
  _CopyWithStubImpl$Input$IdentifyFieldOptionsInput(this._res);

  TRes _res;

  call({
    String? field,
    Enum$IdentifyFieldStrategy? strategy,
    bool? createMissing,
  }) =>
      _res;
}

class Input$IdentifyMetadataOptionsInput {
  factory Input$IdentifyMetadataOptionsInput({
    List<Input$IdentifyFieldOptionsInput>? fieldOptions,
    bool? setCoverImage,
    bool? setOrganized,
    bool? includeMalePerformers,
    bool? skipMultipleMatches,
    String? skipMultipleMatchTag,
    bool? skipSingleNamePerformers,
    String? skipSingleNamePerformerTag,
  }) =>
      Input$IdentifyMetadataOptionsInput._({
        if (fieldOptions != null) r'fieldOptions': fieldOptions,
        if (setCoverImage != null) r'setCoverImage': setCoverImage,
        if (setOrganized != null) r'setOrganized': setOrganized,
        if (includeMalePerformers != null)
          r'includeMalePerformers': includeMalePerformers,
        if (skipMultipleMatches != null)
          r'skipMultipleMatches': skipMultipleMatches,
        if (skipMultipleMatchTag != null)
          r'skipMultipleMatchTag': skipMultipleMatchTag,
        if (skipSingleNamePerformers != null)
          r'skipSingleNamePerformers': skipSingleNamePerformers,
        if (skipSingleNamePerformerTag != null)
          r'skipSingleNamePerformerTag': skipSingleNamePerformerTag,
      });

  Input$IdentifyMetadataOptionsInput._(this._$data);

  factory Input$IdentifyMetadataOptionsInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('fieldOptions')) {
      final l$fieldOptions = data['fieldOptions'];
      result$data['fieldOptions'] = (l$fieldOptions as List<dynamic>?)
          ?.map((e) => Input$IdentifyFieldOptionsInput.fromJson(
              (e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('setCoverImage')) {
      final l$setCoverImage = data['setCoverImage'];
      result$data['setCoverImage'] = (l$setCoverImage as bool?);
    }
    if (data.containsKey('setOrganized')) {
      final l$setOrganized = data['setOrganized'];
      result$data['setOrganized'] = (l$setOrganized as bool?);
    }
    if (data.containsKey('includeMalePerformers')) {
      final l$includeMalePerformers = data['includeMalePerformers'];
      result$data['includeMalePerformers'] = (l$includeMalePerformers as bool?);
    }
    if (data.containsKey('skipMultipleMatches')) {
      final l$skipMultipleMatches = data['skipMultipleMatches'];
      result$data['skipMultipleMatches'] = (l$skipMultipleMatches as bool?);
    }
    if (data.containsKey('skipMultipleMatchTag')) {
      final l$skipMultipleMatchTag = data['skipMultipleMatchTag'];
      result$data['skipMultipleMatchTag'] = (l$skipMultipleMatchTag as String?);
    }
    if (data.containsKey('skipSingleNamePerformers')) {
      final l$skipSingleNamePerformers = data['skipSingleNamePerformers'];
      result$data['skipSingleNamePerformers'] =
          (l$skipSingleNamePerformers as bool?);
    }
    if (data.containsKey('skipSingleNamePerformerTag')) {
      final l$skipSingleNamePerformerTag = data['skipSingleNamePerformerTag'];
      result$data['skipSingleNamePerformerTag'] =
          (l$skipSingleNamePerformerTag as String?);
    }
    return Input$IdentifyMetadataOptionsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Input$IdentifyFieldOptionsInput>? get fieldOptions =>
      (_$data['fieldOptions'] as List<Input$IdentifyFieldOptionsInput>?);

  bool? get setCoverImage => (_$data['setCoverImage'] as bool?);

  bool? get setOrganized => (_$data['setOrganized'] as bool?);

  bool? get includeMalePerformers => (_$data['includeMalePerformers'] as bool?);

  bool? get skipMultipleMatches => (_$data['skipMultipleMatches'] as bool?);

  String? get skipMultipleMatchTag =>
      (_$data['skipMultipleMatchTag'] as String?);

  bool? get skipSingleNamePerformers =>
      (_$data['skipSingleNamePerformers'] as bool?);

  String? get skipSingleNamePerformerTag =>
      (_$data['skipSingleNamePerformerTag'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('fieldOptions')) {
      final l$fieldOptions = fieldOptions;
      result$data['fieldOptions'] =
          l$fieldOptions?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('setCoverImage')) {
      final l$setCoverImage = setCoverImage;
      result$data['setCoverImage'] = l$setCoverImage;
    }
    if (_$data.containsKey('setOrganized')) {
      final l$setOrganized = setOrganized;
      result$data['setOrganized'] = l$setOrganized;
    }
    if (_$data.containsKey('includeMalePerformers')) {
      final l$includeMalePerformers = includeMalePerformers;
      result$data['includeMalePerformers'] = l$includeMalePerformers;
    }
    if (_$data.containsKey('skipMultipleMatches')) {
      final l$skipMultipleMatches = skipMultipleMatches;
      result$data['skipMultipleMatches'] = l$skipMultipleMatches;
    }
    if (_$data.containsKey('skipMultipleMatchTag')) {
      final l$skipMultipleMatchTag = skipMultipleMatchTag;
      result$data['skipMultipleMatchTag'] = l$skipMultipleMatchTag;
    }
    if (_$data.containsKey('skipSingleNamePerformers')) {
      final l$skipSingleNamePerformers = skipSingleNamePerformers;
      result$data['skipSingleNamePerformers'] = l$skipSingleNamePerformers;
    }
    if (_$data.containsKey('skipSingleNamePerformerTag')) {
      final l$skipSingleNamePerformerTag = skipSingleNamePerformerTag;
      result$data['skipSingleNamePerformerTag'] = l$skipSingleNamePerformerTag;
    }
    return result$data;
  }

  CopyWith$Input$IdentifyMetadataOptionsInput<
          Input$IdentifyMetadataOptionsInput>
      get copyWith => CopyWith$Input$IdentifyMetadataOptionsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$IdentifyMetadataOptionsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$fieldOptions = fieldOptions;
    final lOther$fieldOptions = other.fieldOptions;
    if (_$data.containsKey('fieldOptions') !=
        other._$data.containsKey('fieldOptions')) {
      return false;
    }
    if (l$fieldOptions != null && lOther$fieldOptions != null) {
      if (l$fieldOptions.length != lOther$fieldOptions.length) {
        return false;
      }
      for (int i = 0; i < l$fieldOptions.length; i++) {
        final l$fieldOptions$entry = l$fieldOptions[i];
        final lOther$fieldOptions$entry = lOther$fieldOptions[i];
        if (l$fieldOptions$entry != lOther$fieldOptions$entry) {
          return false;
        }
      }
    } else if (l$fieldOptions != lOther$fieldOptions) {
      return false;
    }
    final l$setCoverImage = setCoverImage;
    final lOther$setCoverImage = other.setCoverImage;
    if (_$data.containsKey('setCoverImage') !=
        other._$data.containsKey('setCoverImage')) {
      return false;
    }
    if (l$setCoverImage != lOther$setCoverImage) {
      return false;
    }
    final l$setOrganized = setOrganized;
    final lOther$setOrganized = other.setOrganized;
    if (_$data.containsKey('setOrganized') !=
        other._$data.containsKey('setOrganized')) {
      return false;
    }
    if (l$setOrganized != lOther$setOrganized) {
      return false;
    }
    final l$includeMalePerformers = includeMalePerformers;
    final lOther$includeMalePerformers = other.includeMalePerformers;
    if (_$data.containsKey('includeMalePerformers') !=
        other._$data.containsKey('includeMalePerformers')) {
      return false;
    }
    if (l$includeMalePerformers != lOther$includeMalePerformers) {
      return false;
    }
    final l$skipMultipleMatches = skipMultipleMatches;
    final lOther$skipMultipleMatches = other.skipMultipleMatches;
    if (_$data.containsKey('skipMultipleMatches') !=
        other._$data.containsKey('skipMultipleMatches')) {
      return false;
    }
    if (l$skipMultipleMatches != lOther$skipMultipleMatches) {
      return false;
    }
    final l$skipMultipleMatchTag = skipMultipleMatchTag;
    final lOther$skipMultipleMatchTag = other.skipMultipleMatchTag;
    if (_$data.containsKey('skipMultipleMatchTag') !=
        other._$data.containsKey('skipMultipleMatchTag')) {
      return false;
    }
    if (l$skipMultipleMatchTag != lOther$skipMultipleMatchTag) {
      return false;
    }
    final l$skipSingleNamePerformers = skipSingleNamePerformers;
    final lOther$skipSingleNamePerformers = other.skipSingleNamePerformers;
    if (_$data.containsKey('skipSingleNamePerformers') !=
        other._$data.containsKey('skipSingleNamePerformers')) {
      return false;
    }
    if (l$skipSingleNamePerformers != lOther$skipSingleNamePerformers) {
      return false;
    }
    final l$skipSingleNamePerformerTag = skipSingleNamePerformerTag;
    final lOther$skipSingleNamePerformerTag = other.skipSingleNamePerformerTag;
    if (_$data.containsKey('skipSingleNamePerformerTag') !=
        other._$data.containsKey('skipSingleNamePerformerTag')) {
      return false;
    }
    if (l$skipSingleNamePerformerTag != lOther$skipSingleNamePerformerTag) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$fieldOptions = fieldOptions;
    final l$setCoverImage = setCoverImage;
    final l$setOrganized = setOrganized;
    final l$includeMalePerformers = includeMalePerformers;
    final l$skipMultipleMatches = skipMultipleMatches;
    final l$skipMultipleMatchTag = skipMultipleMatchTag;
    final l$skipSingleNamePerformers = skipSingleNamePerformers;
    final l$skipSingleNamePerformerTag = skipSingleNamePerformerTag;
    return Object.hashAll([
      _$data.containsKey('fieldOptions')
          ? l$fieldOptions == null
              ? null
              : Object.hashAll(l$fieldOptions.map((v) => v))
          : const {},
      _$data.containsKey('setCoverImage') ? l$setCoverImage : const {},
      _$data.containsKey('setOrganized') ? l$setOrganized : const {},
      _$data.containsKey('includeMalePerformers')
          ? l$includeMalePerformers
          : const {},
      _$data.containsKey('skipMultipleMatches')
          ? l$skipMultipleMatches
          : const {},
      _$data.containsKey('skipMultipleMatchTag')
          ? l$skipMultipleMatchTag
          : const {},
      _$data.containsKey('skipSingleNamePerformers')
          ? l$skipSingleNamePerformers
          : const {},
      _$data.containsKey('skipSingleNamePerformerTag')
          ? l$skipSingleNamePerformerTag
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$IdentifyMetadataOptionsInput<TRes> {
  factory CopyWith$Input$IdentifyMetadataOptionsInput(
    Input$IdentifyMetadataOptionsInput instance,
    TRes Function(Input$IdentifyMetadataOptionsInput) then,
  ) = _CopyWithImpl$Input$IdentifyMetadataOptionsInput;

  factory CopyWith$Input$IdentifyMetadataOptionsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$IdentifyMetadataOptionsInput;

  TRes call({
    List<Input$IdentifyFieldOptionsInput>? fieldOptions,
    bool? setCoverImage,
    bool? setOrganized,
    bool? includeMalePerformers,
    bool? skipMultipleMatches,
    String? skipMultipleMatchTag,
    bool? skipSingleNamePerformers,
    String? skipSingleNamePerformerTag,
  });
  TRes fieldOptions(
      Iterable<Input$IdentifyFieldOptionsInput>? Function(
              Iterable<
                  CopyWith$Input$IdentifyFieldOptionsInput<
                      Input$IdentifyFieldOptionsInput>>?)
          _fn);
}

class _CopyWithImpl$Input$IdentifyMetadataOptionsInput<TRes>
    implements CopyWith$Input$IdentifyMetadataOptionsInput<TRes> {
  _CopyWithImpl$Input$IdentifyMetadataOptionsInput(
    this._instance,
    this._then,
  );

  final Input$IdentifyMetadataOptionsInput _instance;

  final TRes Function(Input$IdentifyMetadataOptionsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? fieldOptions = _undefined,
    Object? setCoverImage = _undefined,
    Object? setOrganized = _undefined,
    Object? includeMalePerformers = _undefined,
    Object? skipMultipleMatches = _undefined,
    Object? skipMultipleMatchTag = _undefined,
    Object? skipSingleNamePerformers = _undefined,
    Object? skipSingleNamePerformerTag = _undefined,
  }) =>
      _then(Input$IdentifyMetadataOptionsInput._({
        ..._instance._$data,
        if (fieldOptions != _undefined)
          'fieldOptions':
              (fieldOptions as List<Input$IdentifyFieldOptionsInput>?),
        if (setCoverImage != _undefined)
          'setCoverImage': (setCoverImage as bool?),
        if (setOrganized != _undefined) 'setOrganized': (setOrganized as bool?),
        if (includeMalePerformers != _undefined)
          'includeMalePerformers': (includeMalePerformers as bool?),
        if (skipMultipleMatches != _undefined)
          'skipMultipleMatches': (skipMultipleMatches as bool?),
        if (skipMultipleMatchTag != _undefined)
          'skipMultipleMatchTag': (skipMultipleMatchTag as String?),
        if (skipSingleNamePerformers != _undefined)
          'skipSingleNamePerformers': (skipSingleNamePerformers as bool?),
        if (skipSingleNamePerformerTag != _undefined)
          'skipSingleNamePerformerTag': (skipSingleNamePerformerTag as String?),
      }));

  TRes fieldOptions(
          Iterable<Input$IdentifyFieldOptionsInput>? Function(
                  Iterable<
                      CopyWith$Input$IdentifyFieldOptionsInput<
                          Input$IdentifyFieldOptionsInput>>?)
              _fn) =>
      call(
          fieldOptions: _fn(_instance.fieldOptions
              ?.map((e) => CopyWith$Input$IdentifyFieldOptionsInput(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Input$IdentifyMetadataOptionsInput<TRes>
    implements CopyWith$Input$IdentifyMetadataOptionsInput<TRes> {
  _CopyWithStubImpl$Input$IdentifyMetadataOptionsInput(this._res);

  TRes _res;

  call({
    List<Input$IdentifyFieldOptionsInput>? fieldOptions,
    bool? setCoverImage,
    bool? setOrganized,
    bool? includeMalePerformers,
    bool? skipMultipleMatches,
    String? skipMultipleMatchTag,
    bool? skipSingleNamePerformers,
    String? skipSingleNamePerformerTag,
  }) =>
      _res;

  fieldOptions(_fn) => _res;
}

class Input$IdentifySourceInput {
  factory Input$IdentifySourceInput({
    required Input$ScraperSourceInput source,
    Input$IdentifyMetadataOptionsInput? options,
  }) =>
      Input$IdentifySourceInput._({
        r'source': source,
        if (options != null) r'options': options,
      });

  Input$IdentifySourceInput._(this._$data);

  factory Input$IdentifySourceInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$source = data['source'];
    result$data['source'] =
        Input$ScraperSourceInput.fromJson((l$source as Map<String, dynamic>));
    if (data.containsKey('options')) {
      final l$options = data['options'];
      result$data['options'] = l$options == null
          ? null
          : Input$IdentifyMetadataOptionsInput.fromJson(
              (l$options as Map<String, dynamic>));
    }
    return Input$IdentifySourceInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ScraperSourceInput get source =>
      (_$data['source'] as Input$ScraperSourceInput);

  Input$IdentifyMetadataOptionsInput? get options =>
      (_$data['options'] as Input$IdentifyMetadataOptionsInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$source = source;
    result$data['source'] = l$source.toJson();
    if (_$data.containsKey('options')) {
      final l$options = options;
      result$data['options'] = l$options?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$IdentifySourceInput<Input$IdentifySourceInput> get copyWith =>
      CopyWith$Input$IdentifySourceInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$IdentifySourceInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != lOther$source) {
      return false;
    }
    final l$options = options;
    final lOther$options = other.options;
    if (_$data.containsKey('options') != other._$data.containsKey('options')) {
      return false;
    }
    if (l$options != lOther$options) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$source = source;
    final l$options = options;
    return Object.hashAll([
      l$source,
      _$data.containsKey('options') ? l$options : const {},
    ]);
  }
}

abstract class CopyWith$Input$IdentifySourceInput<TRes> {
  factory CopyWith$Input$IdentifySourceInput(
    Input$IdentifySourceInput instance,
    TRes Function(Input$IdentifySourceInput) then,
  ) = _CopyWithImpl$Input$IdentifySourceInput;

  factory CopyWith$Input$IdentifySourceInput.stub(TRes res) =
      _CopyWithStubImpl$Input$IdentifySourceInput;

  TRes call({
    Input$ScraperSourceInput? source,
    Input$IdentifyMetadataOptionsInput? options,
  });
  CopyWith$Input$IdentifyMetadataOptionsInput<TRes> get options;
}

class _CopyWithImpl$Input$IdentifySourceInput<TRes>
    implements CopyWith$Input$IdentifySourceInput<TRes> {
  _CopyWithImpl$Input$IdentifySourceInput(
    this._instance,
    this._then,
  );

  final Input$IdentifySourceInput _instance;

  final TRes Function(Input$IdentifySourceInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? source = _undefined,
    Object? options = _undefined,
  }) =>
      _then(Input$IdentifySourceInput._({
        ..._instance._$data,
        if (source != _undefined && source != null)
          'source': (source as Input$ScraperSourceInput),
        if (options != _undefined)
          'options': (options as Input$IdentifyMetadataOptionsInput?),
      }));

  CopyWith$Input$IdentifyMetadataOptionsInput<TRes> get options {
    final local$options = _instance.options;
    return local$options == null
        ? CopyWith$Input$IdentifyMetadataOptionsInput.stub(_then(_instance))
        : CopyWith$Input$IdentifyMetadataOptionsInput(
            local$options, (e) => call(options: e));
  }
}

class _CopyWithStubImpl$Input$IdentifySourceInput<TRes>
    implements CopyWith$Input$IdentifySourceInput<TRes> {
  _CopyWithStubImpl$Input$IdentifySourceInput(this._res);

  TRes _res;

  call({
    Input$ScraperSourceInput? source,
    Input$IdentifyMetadataOptionsInput? options,
  }) =>
      _res;

  CopyWith$Input$IdentifyMetadataOptionsInput<TRes> get options =>
      CopyWith$Input$IdentifyMetadataOptionsInput.stub(_res);
}

class Input$IdentifyMetadataInput {
  factory Input$IdentifyMetadataInput({
    required List<Input$IdentifySourceInput> sources,
    Input$IdentifyMetadataOptionsInput? options,
    List<String>? sceneIDs,
    List<String>? paths,
  }) =>
      Input$IdentifyMetadataInput._({
        r'sources': sources,
        if (options != null) r'options': options,
        if (sceneIDs != null) r'sceneIDs': sceneIDs,
        if (paths != null) r'paths': paths,
      });

  Input$IdentifyMetadataInput._(this._$data);

  factory Input$IdentifyMetadataInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$sources = data['sources'];
    result$data['sources'] = (l$sources as List<dynamic>)
        .map((e) =>
            Input$IdentifySourceInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    if (data.containsKey('options')) {
      final l$options = data['options'];
      result$data['options'] = l$options == null
          ? null
          : Input$IdentifyMetadataOptionsInput.fromJson(
              (l$options as Map<String, dynamic>));
    }
    if (data.containsKey('sceneIDs')) {
      final l$sceneIDs = data['sceneIDs'];
      result$data['sceneIDs'] =
          (l$sceneIDs as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('paths')) {
      final l$paths = data['paths'];
      result$data['paths'] =
          (l$paths as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$IdentifyMetadataInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Input$IdentifySourceInput> get sources =>
      (_$data['sources'] as List<Input$IdentifySourceInput>);

  Input$IdentifyMetadataOptionsInput? get options =>
      (_$data['options'] as Input$IdentifyMetadataOptionsInput?);

  List<String>? get sceneIDs => (_$data['sceneIDs'] as List<String>?);

  List<String>? get paths => (_$data['paths'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sources = sources;
    result$data['sources'] = l$sources.map((e) => e.toJson()).toList();
    if (_$data.containsKey('options')) {
      final l$options = options;
      result$data['options'] = l$options?.toJson();
    }
    if (_$data.containsKey('sceneIDs')) {
      final l$sceneIDs = sceneIDs;
      result$data['sceneIDs'] = l$sceneIDs?.map((e) => e).toList();
    }
    if (_$data.containsKey('paths')) {
      final l$paths = paths;
      result$data['paths'] = l$paths?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$IdentifyMetadataInput<Input$IdentifyMetadataInput>
      get copyWith => CopyWith$Input$IdentifyMetadataInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$IdentifyMetadataInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sources = sources;
    final lOther$sources = other.sources;
    if (l$sources.length != lOther$sources.length) {
      return false;
    }
    for (int i = 0; i < l$sources.length; i++) {
      final l$sources$entry = l$sources[i];
      final lOther$sources$entry = lOther$sources[i];
      if (l$sources$entry != lOther$sources$entry) {
        return false;
      }
    }
    final l$options = options;
    final lOther$options = other.options;
    if (_$data.containsKey('options') != other._$data.containsKey('options')) {
      return false;
    }
    if (l$options != lOther$options) {
      return false;
    }
    final l$sceneIDs = sceneIDs;
    final lOther$sceneIDs = other.sceneIDs;
    if (_$data.containsKey('sceneIDs') !=
        other._$data.containsKey('sceneIDs')) {
      return false;
    }
    if (l$sceneIDs != null && lOther$sceneIDs != null) {
      if (l$sceneIDs.length != lOther$sceneIDs.length) {
        return false;
      }
      for (int i = 0; i < l$sceneIDs.length; i++) {
        final l$sceneIDs$entry = l$sceneIDs[i];
        final lOther$sceneIDs$entry = lOther$sceneIDs[i];
        if (l$sceneIDs$entry != lOther$sceneIDs$entry) {
          return false;
        }
      }
    } else if (l$sceneIDs != lOther$sceneIDs) {
      return false;
    }
    final l$paths = paths;
    final lOther$paths = other.paths;
    if (_$data.containsKey('paths') != other._$data.containsKey('paths')) {
      return false;
    }
    if (l$paths != null && lOther$paths != null) {
      if (l$paths.length != lOther$paths.length) {
        return false;
      }
      for (int i = 0; i < l$paths.length; i++) {
        final l$paths$entry = l$paths[i];
        final lOther$paths$entry = lOther$paths[i];
        if (l$paths$entry != lOther$paths$entry) {
          return false;
        }
      }
    } else if (l$paths != lOther$paths) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sources = sources;
    final l$options = options;
    final l$sceneIDs = sceneIDs;
    final l$paths = paths;
    return Object.hashAll([
      Object.hashAll(l$sources.map((v) => v)),
      _$data.containsKey('options') ? l$options : const {},
      _$data.containsKey('sceneIDs')
          ? l$sceneIDs == null
              ? null
              : Object.hashAll(l$sceneIDs.map((v) => v))
          : const {},
      _$data.containsKey('paths')
          ? l$paths == null
              ? null
              : Object.hashAll(l$paths.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$IdentifyMetadataInput<TRes> {
  factory CopyWith$Input$IdentifyMetadataInput(
    Input$IdentifyMetadataInput instance,
    TRes Function(Input$IdentifyMetadataInput) then,
  ) = _CopyWithImpl$Input$IdentifyMetadataInput;

  factory CopyWith$Input$IdentifyMetadataInput.stub(TRes res) =
      _CopyWithStubImpl$Input$IdentifyMetadataInput;

  TRes call({
    List<Input$IdentifySourceInput>? sources,
    Input$IdentifyMetadataOptionsInput? options,
    List<String>? sceneIDs,
    List<String>? paths,
  });
  TRes sources(
      Iterable<Input$IdentifySourceInput> Function(
              Iterable<
                  CopyWith$Input$IdentifySourceInput<
                      Input$IdentifySourceInput>>)
          _fn);
  CopyWith$Input$IdentifyMetadataOptionsInput<TRes> get options;
}

class _CopyWithImpl$Input$IdentifyMetadataInput<TRes>
    implements CopyWith$Input$IdentifyMetadataInput<TRes> {
  _CopyWithImpl$Input$IdentifyMetadataInput(
    this._instance,
    this._then,
  );

  final Input$IdentifyMetadataInput _instance;

  final TRes Function(Input$IdentifyMetadataInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sources = _undefined,
    Object? options = _undefined,
    Object? sceneIDs = _undefined,
    Object? paths = _undefined,
  }) =>
      _then(Input$IdentifyMetadataInput._({
        ..._instance._$data,
        if (sources != _undefined && sources != null)
          'sources': (sources as List<Input$IdentifySourceInput>),
        if (options != _undefined)
          'options': (options as Input$IdentifyMetadataOptionsInput?),
        if (sceneIDs != _undefined) 'sceneIDs': (sceneIDs as List<String>?),
        if (paths != _undefined) 'paths': (paths as List<String>?),
      }));

  TRes sources(
          Iterable<Input$IdentifySourceInput> Function(
                  Iterable<
                      CopyWith$Input$IdentifySourceInput<
                          Input$IdentifySourceInput>>)
              _fn) =>
      call(
          sources: _fn(
              _instance.sources.map((e) => CopyWith$Input$IdentifySourceInput(
                    e,
                    (i) => i,
                  ))).toList());

  CopyWith$Input$IdentifyMetadataOptionsInput<TRes> get options {
    final local$options = _instance.options;
    return local$options == null
        ? CopyWith$Input$IdentifyMetadataOptionsInput.stub(_then(_instance))
        : CopyWith$Input$IdentifyMetadataOptionsInput(
            local$options, (e) => call(options: e));
  }
}

class _CopyWithStubImpl$Input$IdentifyMetadataInput<TRes>
    implements CopyWith$Input$IdentifyMetadataInput<TRes> {
  _CopyWithStubImpl$Input$IdentifyMetadataInput(this._res);

  TRes _res;

  call({
    List<Input$IdentifySourceInput>? sources,
    Input$IdentifyMetadataOptionsInput? options,
    List<String>? sceneIDs,
    List<String>? paths,
  }) =>
      _res;

  sources(_fn) => _res;

  CopyWith$Input$IdentifyMetadataOptionsInput<TRes> get options =>
      CopyWith$Input$IdentifyMetadataOptionsInput.stub(_res);
}

class Input$ExportObjectTypeInput {
  factory Input$ExportObjectTypeInput({
    List<String>? ids,
    bool? all,
  }) =>
      Input$ExportObjectTypeInput._({
        if (ids != null) r'ids': ids,
        if (all != null) r'all': all,
      });

  Input$ExportObjectTypeInput._(this._$data);

  factory Input$ExportObjectTypeInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] =
          (l$ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('all')) {
      final l$all = data['all'];
      result$data['all'] = (l$all as bool?);
    }
    return Input$ExportObjectTypeInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get ids => (_$data['ids'] as List<String>?);

  bool? get all => (_$data['all'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('ids')) {
      final l$ids = ids;
      result$data['ids'] = l$ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('all')) {
      final l$all = all;
      result$data['all'] = l$all;
    }
    return result$data;
  }

  CopyWith$Input$ExportObjectTypeInput<Input$ExportObjectTypeInput>
      get copyWith => CopyWith$Input$ExportObjectTypeInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ExportObjectTypeInput) ||
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
    final l$all = all;
    final lOther$all = other.all;
    if (_$data.containsKey('all') != other._$data.containsKey('all')) {
      return false;
    }
    if (l$all != lOther$all) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$ids = ids;
    final l$all = all;
    return Object.hashAll([
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('all') ? l$all : const {},
    ]);
  }
}

abstract class CopyWith$Input$ExportObjectTypeInput<TRes> {
  factory CopyWith$Input$ExportObjectTypeInput(
    Input$ExportObjectTypeInput instance,
    TRes Function(Input$ExportObjectTypeInput) then,
  ) = _CopyWithImpl$Input$ExportObjectTypeInput;

  factory CopyWith$Input$ExportObjectTypeInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ExportObjectTypeInput;

  TRes call({
    List<String>? ids,
    bool? all,
  });
}

class _CopyWithImpl$Input$ExportObjectTypeInput<TRes>
    implements CopyWith$Input$ExportObjectTypeInput<TRes> {
  _CopyWithImpl$Input$ExportObjectTypeInput(
    this._instance,
    this._then,
  );

  final Input$ExportObjectTypeInput _instance;

  final TRes Function(Input$ExportObjectTypeInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? ids = _undefined,
    Object? all = _undefined,
  }) =>
      _then(Input$ExportObjectTypeInput._({
        ..._instance._$data,
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (all != _undefined) 'all': (all as bool?),
      }));
}

class _CopyWithStubImpl$Input$ExportObjectTypeInput<TRes>
    implements CopyWith$Input$ExportObjectTypeInput<TRes> {
  _CopyWithStubImpl$Input$ExportObjectTypeInput(this._res);

  TRes _res;

  call({
    List<String>? ids,
    bool? all,
  }) =>
      _res;
}

class Input$ExportObjectsInput {
  factory Input$ExportObjectsInput({
    Input$ExportObjectTypeInput? scenes,
    Input$ExportObjectTypeInput? images,
    Input$ExportObjectTypeInput? studios,
    Input$ExportObjectTypeInput? performers,
    Input$ExportObjectTypeInput? tags,
    Input$ExportObjectTypeInput? groups,
    Input$ExportObjectTypeInput? movies,
    Input$ExportObjectTypeInput? galleries,
    bool? includeDependencies,
  }) =>
      Input$ExportObjectsInput._({
        if (scenes != null) r'scenes': scenes,
        if (images != null) r'images': images,
        if (studios != null) r'studios': studios,
        if (performers != null) r'performers': performers,
        if (tags != null) r'tags': tags,
        if (groups != null) r'groups': groups,
        if (movies != null) r'movies': movies,
        if (galleries != null) r'galleries': galleries,
        if (includeDependencies != null)
          r'includeDependencies': includeDependencies,
      });

  Input$ExportObjectsInput._(this._$data);

  factory Input$ExportObjectsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('scenes')) {
      final l$scenes = data['scenes'];
      result$data['scenes'] = l$scenes == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$scenes as Map<String, dynamic>));
    }
    if (data.containsKey('images')) {
      final l$images = data['images'];
      result$data['images'] = l$images == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$images as Map<String, dynamic>));
    }
    if (data.containsKey('studios')) {
      final l$studios = data['studios'];
      result$data['studios'] = l$studios == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$studios as Map<String, dynamic>));
    }
    if (data.containsKey('performers')) {
      final l$performers = data['performers'];
      result$data['performers'] = l$performers == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$performers as Map<String, dynamic>));
    }
    if (data.containsKey('tags')) {
      final l$tags = data['tags'];
      result$data['tags'] = l$tags == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$tags as Map<String, dynamic>));
    }
    if (data.containsKey('groups')) {
      final l$groups = data['groups'];
      result$data['groups'] = l$groups == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$groups as Map<String, dynamic>));
    }
    if (data.containsKey('movies')) {
      final l$movies = data['movies'];
      result$data['movies'] = l$movies == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$movies as Map<String, dynamic>));
    }
    if (data.containsKey('galleries')) {
      final l$galleries = data['galleries'];
      result$data['galleries'] = l$galleries == null
          ? null
          : Input$ExportObjectTypeInput.fromJson(
              (l$galleries as Map<String, dynamic>));
    }
    if (data.containsKey('includeDependencies')) {
      final l$includeDependencies = data['includeDependencies'];
      result$data['includeDependencies'] = (l$includeDependencies as bool?);
    }
    return Input$ExportObjectsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ExportObjectTypeInput? get scenes =>
      (_$data['scenes'] as Input$ExportObjectTypeInput?);

  Input$ExportObjectTypeInput? get images =>
      (_$data['images'] as Input$ExportObjectTypeInput?);

  Input$ExportObjectTypeInput? get studios =>
      (_$data['studios'] as Input$ExportObjectTypeInput?);

  Input$ExportObjectTypeInput? get performers =>
      (_$data['performers'] as Input$ExportObjectTypeInput?);

  Input$ExportObjectTypeInput? get tags =>
      (_$data['tags'] as Input$ExportObjectTypeInput?);

  Input$ExportObjectTypeInput? get groups =>
      (_$data['groups'] as Input$ExportObjectTypeInput?);

  Input$ExportObjectTypeInput? get movies =>
      (_$data['movies'] as Input$ExportObjectTypeInput?);

  Input$ExportObjectTypeInput? get galleries =>
      (_$data['galleries'] as Input$ExportObjectTypeInput?);

  bool? get includeDependencies => (_$data['includeDependencies'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('scenes')) {
      final l$scenes = scenes;
      result$data['scenes'] = l$scenes?.toJson();
    }
    if (_$data.containsKey('images')) {
      final l$images = images;
      result$data['images'] = l$images?.toJson();
    }
    if (_$data.containsKey('studios')) {
      final l$studios = studios;
      result$data['studios'] = l$studios?.toJson();
    }
    if (_$data.containsKey('performers')) {
      final l$performers = performers;
      result$data['performers'] = l$performers?.toJson();
    }
    if (_$data.containsKey('tags')) {
      final l$tags = tags;
      result$data['tags'] = l$tags?.toJson();
    }
    if (_$data.containsKey('groups')) {
      final l$groups = groups;
      result$data['groups'] = l$groups?.toJson();
    }
    if (_$data.containsKey('movies')) {
      final l$movies = movies;
      result$data['movies'] = l$movies?.toJson();
    }
    if (_$data.containsKey('galleries')) {
      final l$galleries = galleries;
      result$data['galleries'] = l$galleries?.toJson();
    }
    if (_$data.containsKey('includeDependencies')) {
      final l$includeDependencies = includeDependencies;
      result$data['includeDependencies'] = l$includeDependencies;
    }
    return result$data;
  }

  CopyWith$Input$ExportObjectsInput<Input$ExportObjectsInput> get copyWith =>
      CopyWith$Input$ExportObjectsInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ExportObjectsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scenes = scenes;
    final lOther$scenes = other.scenes;
    if (_$data.containsKey('scenes') != other._$data.containsKey('scenes')) {
      return false;
    }
    if (l$scenes != lOther$scenes) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (_$data.containsKey('images') != other._$data.containsKey('images')) {
      return false;
    }
    if (l$images != lOther$images) {
      return false;
    }
    final l$studios = studios;
    final lOther$studios = other.studios;
    if (_$data.containsKey('studios') != other._$data.containsKey('studios')) {
      return false;
    }
    if (l$studios != lOther$studios) {
      return false;
    }
    final l$performers = performers;
    final lOther$performers = other.performers;
    if (_$data.containsKey('performers') !=
        other._$data.containsKey('performers')) {
      return false;
    }
    if (l$performers != lOther$performers) {
      return false;
    }
    final l$tags = tags;
    final lOther$tags = other.tags;
    if (_$data.containsKey('tags') != other._$data.containsKey('tags')) {
      return false;
    }
    if (l$tags != lOther$tags) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (_$data.containsKey('groups') != other._$data.containsKey('groups')) {
      return false;
    }
    if (l$groups != lOther$groups) {
      return false;
    }
    final l$movies = movies;
    final lOther$movies = other.movies;
    if (_$data.containsKey('movies') != other._$data.containsKey('movies')) {
      return false;
    }
    if (l$movies != lOther$movies) {
      return false;
    }
    final l$galleries = galleries;
    final lOther$galleries = other.galleries;
    if (_$data.containsKey('galleries') !=
        other._$data.containsKey('galleries')) {
      return false;
    }
    if (l$galleries != lOther$galleries) {
      return false;
    }
    final l$includeDependencies = includeDependencies;
    final lOther$includeDependencies = other.includeDependencies;
    if (_$data.containsKey('includeDependencies') !=
        other._$data.containsKey('includeDependencies')) {
      return false;
    }
    if (l$includeDependencies != lOther$includeDependencies) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scenes = scenes;
    final l$images = images;
    final l$studios = studios;
    final l$performers = performers;
    final l$tags = tags;
    final l$groups = groups;
    final l$movies = movies;
    final l$galleries = galleries;
    final l$includeDependencies = includeDependencies;
    return Object.hashAll([
      _$data.containsKey('scenes') ? l$scenes : const {},
      _$data.containsKey('images') ? l$images : const {},
      _$data.containsKey('studios') ? l$studios : const {},
      _$data.containsKey('performers') ? l$performers : const {},
      _$data.containsKey('tags') ? l$tags : const {},
      _$data.containsKey('groups') ? l$groups : const {},
      _$data.containsKey('movies') ? l$movies : const {},
      _$data.containsKey('galleries') ? l$galleries : const {},
      _$data.containsKey('includeDependencies')
          ? l$includeDependencies
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$ExportObjectsInput<TRes> {
  factory CopyWith$Input$ExportObjectsInput(
    Input$ExportObjectsInput instance,
    TRes Function(Input$ExportObjectsInput) then,
  ) = _CopyWithImpl$Input$ExportObjectsInput;

  factory CopyWith$Input$ExportObjectsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ExportObjectsInput;

  TRes call({
    Input$ExportObjectTypeInput? scenes,
    Input$ExportObjectTypeInput? images,
    Input$ExportObjectTypeInput? studios,
    Input$ExportObjectTypeInput? performers,
    Input$ExportObjectTypeInput? tags,
    Input$ExportObjectTypeInput? groups,
    Input$ExportObjectTypeInput? movies,
    Input$ExportObjectTypeInput? galleries,
    bool? includeDependencies,
  });
  CopyWith$Input$ExportObjectTypeInput<TRes> get scenes;
  CopyWith$Input$ExportObjectTypeInput<TRes> get images;
  CopyWith$Input$ExportObjectTypeInput<TRes> get studios;
  CopyWith$Input$ExportObjectTypeInput<TRes> get performers;
  CopyWith$Input$ExportObjectTypeInput<TRes> get tags;
  CopyWith$Input$ExportObjectTypeInput<TRes> get groups;
  CopyWith$Input$ExportObjectTypeInput<TRes> get movies;
  CopyWith$Input$ExportObjectTypeInput<TRes> get galleries;
}

class _CopyWithImpl$Input$ExportObjectsInput<TRes>
    implements CopyWith$Input$ExportObjectsInput<TRes> {
  _CopyWithImpl$Input$ExportObjectsInput(
    this._instance,
    this._then,
  );

  final Input$ExportObjectsInput _instance;

  final TRes Function(Input$ExportObjectsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scenes = _undefined,
    Object? images = _undefined,
    Object? studios = _undefined,
    Object? performers = _undefined,
    Object? tags = _undefined,
    Object? groups = _undefined,
    Object? movies = _undefined,
    Object? galleries = _undefined,
    Object? includeDependencies = _undefined,
  }) =>
      _then(Input$ExportObjectsInput._({
        ..._instance._$data,
        if (scenes != _undefined)
          'scenes': (scenes as Input$ExportObjectTypeInput?),
        if (images != _undefined)
          'images': (images as Input$ExportObjectTypeInput?),
        if (studios != _undefined)
          'studios': (studios as Input$ExportObjectTypeInput?),
        if (performers != _undefined)
          'performers': (performers as Input$ExportObjectTypeInput?),
        if (tags != _undefined) 'tags': (tags as Input$ExportObjectTypeInput?),
        if (groups != _undefined)
          'groups': (groups as Input$ExportObjectTypeInput?),
        if (movies != _undefined)
          'movies': (movies as Input$ExportObjectTypeInput?),
        if (galleries != _undefined)
          'galleries': (galleries as Input$ExportObjectTypeInput?),
        if (includeDependencies != _undefined)
          'includeDependencies': (includeDependencies as bool?),
      }));

  CopyWith$Input$ExportObjectTypeInput<TRes> get scenes {
    final local$scenes = _instance.scenes;
    return local$scenes == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$scenes, (e) => call(scenes: e));
  }

  CopyWith$Input$ExportObjectTypeInput<TRes> get images {
    final local$images = _instance.images;
    return local$images == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$images, (e) => call(images: e));
  }

  CopyWith$Input$ExportObjectTypeInput<TRes> get studios {
    final local$studios = _instance.studios;
    return local$studios == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$studios, (e) => call(studios: e));
  }

  CopyWith$Input$ExportObjectTypeInput<TRes> get performers {
    final local$performers = _instance.performers;
    return local$performers == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$performers, (e) => call(performers: e));
  }

  CopyWith$Input$ExportObjectTypeInput<TRes> get tags {
    final local$tags = _instance.tags;
    return local$tags == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$tags, (e) => call(tags: e));
  }

  CopyWith$Input$ExportObjectTypeInput<TRes> get groups {
    final local$groups = _instance.groups;
    return local$groups == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$groups, (e) => call(groups: e));
  }

  CopyWith$Input$ExportObjectTypeInput<TRes> get movies {
    final local$movies = _instance.movies;
    return local$movies == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$movies, (e) => call(movies: e));
  }

  CopyWith$Input$ExportObjectTypeInput<TRes> get galleries {
    final local$galleries = _instance.galleries;
    return local$galleries == null
        ? CopyWith$Input$ExportObjectTypeInput.stub(_then(_instance))
        : CopyWith$Input$ExportObjectTypeInput(
            local$galleries, (e) => call(galleries: e));
  }
}

class _CopyWithStubImpl$Input$ExportObjectsInput<TRes>
    implements CopyWith$Input$ExportObjectsInput<TRes> {
  _CopyWithStubImpl$Input$ExportObjectsInput(this._res);

  TRes _res;

  call({
    Input$ExportObjectTypeInput? scenes,
    Input$ExportObjectTypeInput? images,
    Input$ExportObjectTypeInput? studios,
    Input$ExportObjectTypeInput? performers,
    Input$ExportObjectTypeInput? tags,
    Input$ExportObjectTypeInput? groups,
    Input$ExportObjectTypeInput? movies,
    Input$ExportObjectTypeInput? galleries,
    bool? includeDependencies,
  }) =>
      _res;

  CopyWith$Input$ExportObjectTypeInput<TRes> get scenes =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);

  CopyWith$Input$ExportObjectTypeInput<TRes> get images =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);

  CopyWith$Input$ExportObjectTypeInput<TRes> get studios =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);

  CopyWith$Input$ExportObjectTypeInput<TRes> get performers =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);

  CopyWith$Input$ExportObjectTypeInput<TRes> get tags =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);

  CopyWith$Input$ExportObjectTypeInput<TRes> get groups =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);

  CopyWith$Input$ExportObjectTypeInput<TRes> get movies =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);

  CopyWith$Input$ExportObjectTypeInput<TRes> get galleries =>
      CopyWith$Input$ExportObjectTypeInput.stub(_res);
}

class Input$ImportObjectsInput {
  factory Input$ImportObjectsInput({
    required String file,
    required Enum$ImportDuplicateEnum duplicateBehaviour,
    required Enum$ImportMissingRefEnum missingRefBehaviour,
  }) =>
      Input$ImportObjectsInput._({
        r'file': file,
        r'duplicateBehaviour': duplicateBehaviour,
        r'missingRefBehaviour': missingRefBehaviour,
      });

  Input$ImportObjectsInput._(this._$data);

  factory Input$ImportObjectsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$file = data['file'];
    result$data['file'] = (l$file as String);
    final l$duplicateBehaviour = data['duplicateBehaviour'];
    result$data['duplicateBehaviour'] =
        fromJson$Enum$ImportDuplicateEnum((l$duplicateBehaviour as String));
    final l$missingRefBehaviour = data['missingRefBehaviour'];
    result$data['missingRefBehaviour'] =
        fromJson$Enum$ImportMissingRefEnum((l$missingRefBehaviour as String));
    return Input$ImportObjectsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get file => (_$data['file'] as String);

  Enum$ImportDuplicateEnum get duplicateBehaviour =>
      (_$data['duplicateBehaviour'] as Enum$ImportDuplicateEnum);

  Enum$ImportMissingRefEnum get missingRefBehaviour =>
      (_$data['missingRefBehaviour'] as Enum$ImportMissingRefEnum);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$file = file;
    result$data['file'] = l$file;
    final l$duplicateBehaviour = duplicateBehaviour;
    result$data['duplicateBehaviour'] =
        toJson$Enum$ImportDuplicateEnum(l$duplicateBehaviour);
    final l$missingRefBehaviour = missingRefBehaviour;
    result$data['missingRefBehaviour'] =
        toJson$Enum$ImportMissingRefEnum(l$missingRefBehaviour);
    return result$data;
  }

  CopyWith$Input$ImportObjectsInput<Input$ImportObjectsInput> get copyWith =>
      CopyWith$Input$ImportObjectsInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ImportObjectsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$file = file;
    final lOther$file = other.file;
    if (l$file != lOther$file) {
      return false;
    }
    final l$duplicateBehaviour = duplicateBehaviour;
    final lOther$duplicateBehaviour = other.duplicateBehaviour;
    if (l$duplicateBehaviour != lOther$duplicateBehaviour) {
      return false;
    }
    final l$missingRefBehaviour = missingRefBehaviour;
    final lOther$missingRefBehaviour = other.missingRefBehaviour;
    if (l$missingRefBehaviour != lOther$missingRefBehaviour) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$file = file;
    final l$duplicateBehaviour = duplicateBehaviour;
    final l$missingRefBehaviour = missingRefBehaviour;
    return Object.hashAll([
      l$file,
      l$duplicateBehaviour,
      l$missingRefBehaviour,
    ]);
  }
}

abstract class CopyWith$Input$ImportObjectsInput<TRes> {
  factory CopyWith$Input$ImportObjectsInput(
    Input$ImportObjectsInput instance,
    TRes Function(Input$ImportObjectsInput) then,
  ) = _CopyWithImpl$Input$ImportObjectsInput;

  factory CopyWith$Input$ImportObjectsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ImportObjectsInput;

  TRes call({
    String? file,
    Enum$ImportDuplicateEnum? duplicateBehaviour,
    Enum$ImportMissingRefEnum? missingRefBehaviour,
  });
}

class _CopyWithImpl$Input$ImportObjectsInput<TRes>
    implements CopyWith$Input$ImportObjectsInput<TRes> {
  _CopyWithImpl$Input$ImportObjectsInput(
    this._instance,
    this._then,
  );

  final Input$ImportObjectsInput _instance;

  final TRes Function(Input$ImportObjectsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? file = _undefined,
    Object? duplicateBehaviour = _undefined,
    Object? missingRefBehaviour = _undefined,
  }) =>
      _then(Input$ImportObjectsInput._({
        ..._instance._$data,
        if (file != _undefined && file != null) 'file': (file as String),
        if (duplicateBehaviour != _undefined && duplicateBehaviour != null)
          'duplicateBehaviour':
              (duplicateBehaviour as Enum$ImportDuplicateEnum),
        if (missingRefBehaviour != _undefined && missingRefBehaviour != null)
          'missingRefBehaviour':
              (missingRefBehaviour as Enum$ImportMissingRefEnum),
      }));
}

class _CopyWithStubImpl$Input$ImportObjectsInput<TRes>
    implements CopyWith$Input$ImportObjectsInput<TRes> {
  _CopyWithStubImpl$Input$ImportObjectsInput(this._res);

  TRes _res;

  call({
    String? file,
    Enum$ImportDuplicateEnum? duplicateBehaviour,
    Enum$ImportMissingRefEnum? missingRefBehaviour,
  }) =>
      _res;
}

class Input$BackupDatabaseInput {
  factory Input$BackupDatabaseInput({bool? download}) =>
      Input$BackupDatabaseInput._({
        if (download != null) r'download': download,
      });

  Input$BackupDatabaseInput._(this._$data);

  factory Input$BackupDatabaseInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('download')) {
      final l$download = data['download'];
      result$data['download'] = (l$download as bool?);
    }
    return Input$BackupDatabaseInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get download => (_$data['download'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('download')) {
      final l$download = download;
      result$data['download'] = l$download;
    }
    return result$data;
  }

  CopyWith$Input$BackupDatabaseInput<Input$BackupDatabaseInput> get copyWith =>
      CopyWith$Input$BackupDatabaseInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BackupDatabaseInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$download = download;
    final lOther$download = other.download;
    if (_$data.containsKey('download') !=
        other._$data.containsKey('download')) {
      return false;
    }
    if (l$download != lOther$download) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$download = download;
    return Object.hashAll(
        [_$data.containsKey('download') ? l$download : const {}]);
  }
}

abstract class CopyWith$Input$BackupDatabaseInput<TRes> {
  factory CopyWith$Input$BackupDatabaseInput(
    Input$BackupDatabaseInput instance,
    TRes Function(Input$BackupDatabaseInput) then,
  ) = _CopyWithImpl$Input$BackupDatabaseInput;

  factory CopyWith$Input$BackupDatabaseInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BackupDatabaseInput;

  TRes call({bool? download});
}

class _CopyWithImpl$Input$BackupDatabaseInput<TRes>
    implements CopyWith$Input$BackupDatabaseInput<TRes> {
  _CopyWithImpl$Input$BackupDatabaseInput(
    this._instance,
    this._then,
  );

  final Input$BackupDatabaseInput _instance;

  final TRes Function(Input$BackupDatabaseInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? download = _undefined}) =>
      _then(Input$BackupDatabaseInput._({
        ..._instance._$data,
        if (download != _undefined) 'download': (download as bool?),
      }));
}

class _CopyWithStubImpl$Input$BackupDatabaseInput<TRes>
    implements CopyWith$Input$BackupDatabaseInput<TRes> {
  _CopyWithStubImpl$Input$BackupDatabaseInput(this._res);

  TRes _res;

  call({bool? download}) => _res;
}

class Input$AnonymiseDatabaseInput {
  factory Input$AnonymiseDatabaseInput({bool? download}) =>
      Input$AnonymiseDatabaseInput._({
        if (download != null) r'download': download,
      });

  Input$AnonymiseDatabaseInput._(this._$data);

  factory Input$AnonymiseDatabaseInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('download')) {
      final l$download = data['download'];
      result$data['download'] = (l$download as bool?);
    }
    return Input$AnonymiseDatabaseInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get download => (_$data['download'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('download')) {
      final l$download = download;
      result$data['download'] = l$download;
    }
    return result$data;
  }

  CopyWith$Input$AnonymiseDatabaseInput<Input$AnonymiseDatabaseInput>
      get copyWith => CopyWith$Input$AnonymiseDatabaseInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$AnonymiseDatabaseInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$download = download;
    final lOther$download = other.download;
    if (_$data.containsKey('download') !=
        other._$data.containsKey('download')) {
      return false;
    }
    if (l$download != lOther$download) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$download = download;
    return Object.hashAll(
        [_$data.containsKey('download') ? l$download : const {}]);
  }
}

abstract class CopyWith$Input$AnonymiseDatabaseInput<TRes> {
  factory CopyWith$Input$AnonymiseDatabaseInput(
    Input$AnonymiseDatabaseInput instance,
    TRes Function(Input$AnonymiseDatabaseInput) then,
  ) = _CopyWithImpl$Input$AnonymiseDatabaseInput;

  factory CopyWith$Input$AnonymiseDatabaseInput.stub(TRes res) =
      _CopyWithStubImpl$Input$AnonymiseDatabaseInput;

  TRes call({bool? download});
}

class _CopyWithImpl$Input$AnonymiseDatabaseInput<TRes>
    implements CopyWith$Input$AnonymiseDatabaseInput<TRes> {
  _CopyWithImpl$Input$AnonymiseDatabaseInput(
    this._instance,
    this._then,
  );

  final Input$AnonymiseDatabaseInput _instance;

  final TRes Function(Input$AnonymiseDatabaseInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? download = _undefined}) =>
      _then(Input$AnonymiseDatabaseInput._({
        ..._instance._$data,
        if (download != _undefined) 'download': (download as bool?),
      }));
}

class _CopyWithStubImpl$Input$AnonymiseDatabaseInput<TRes>
    implements CopyWith$Input$AnonymiseDatabaseInput<TRes> {
  _CopyWithStubImpl$Input$AnonymiseDatabaseInput(this._res);

  TRes _res;

  call({bool? download}) => _res;
}

class Input$MigrateInput {
  factory Input$MigrateInput({required String backupPath}) =>
      Input$MigrateInput._({
        r'backupPath': backupPath,
      });

  Input$MigrateInput._(this._$data);

  factory Input$MigrateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$backupPath = data['backupPath'];
    result$data['backupPath'] = (l$backupPath as String);
    return Input$MigrateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get backupPath => (_$data['backupPath'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$backupPath = backupPath;
    result$data['backupPath'] = l$backupPath;
    return result$data;
  }

  CopyWith$Input$MigrateInput<Input$MigrateInput> get copyWith =>
      CopyWith$Input$MigrateInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$MigrateInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$backupPath = backupPath;
    final lOther$backupPath = other.backupPath;
    if (l$backupPath != lOther$backupPath) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$backupPath = backupPath;
    return Object.hashAll([l$backupPath]);
  }
}

abstract class CopyWith$Input$MigrateInput<TRes> {
  factory CopyWith$Input$MigrateInput(
    Input$MigrateInput instance,
    TRes Function(Input$MigrateInput) then,
  ) = _CopyWithImpl$Input$MigrateInput;

  factory CopyWith$Input$MigrateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MigrateInput;

  TRes call({String? backupPath});
}

class _CopyWithImpl$Input$MigrateInput<TRes>
    implements CopyWith$Input$MigrateInput<TRes> {
  _CopyWithImpl$Input$MigrateInput(
    this._instance,
    this._then,
  );

  final Input$MigrateInput _instance;

  final TRes Function(Input$MigrateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? backupPath = _undefined}) => _then(Input$MigrateInput._({
        ..._instance._$data,
        if (backupPath != _undefined && backupPath != null)
          'backupPath': (backupPath as String),
      }));
}

class _CopyWithStubImpl$Input$MigrateInput<TRes>
    implements CopyWith$Input$MigrateInput<TRes> {
  _CopyWithStubImpl$Input$MigrateInput(this._res);

  TRes _res;

  call({String? backupPath}) => _res;
}

enum Enum$IdentifyFieldStrategy {
  IGNORE,
  MERGE,
  OVERWRITE,
  $unknown;

  factory Enum$IdentifyFieldStrategy.fromJson(String value) =>
      fromJson$Enum$IdentifyFieldStrategy(value);

  String toJson() => toJson$Enum$IdentifyFieldStrategy(this);
}

String toJson$Enum$IdentifyFieldStrategy(Enum$IdentifyFieldStrategy e) {
  switch (e) {
    case Enum$IdentifyFieldStrategy.IGNORE:
      return r'IGNORE';
    case Enum$IdentifyFieldStrategy.MERGE:
      return r'MERGE';
    case Enum$IdentifyFieldStrategy.OVERWRITE:
      return r'OVERWRITE';
    case Enum$IdentifyFieldStrategy.$unknown:
      return r'$unknown';
  }
}

Enum$IdentifyFieldStrategy fromJson$Enum$IdentifyFieldStrategy(String value) {
  switch (value) {
    case r'IGNORE':
      return Enum$IdentifyFieldStrategy.IGNORE;
    case r'MERGE':
      return Enum$IdentifyFieldStrategy.MERGE;
    case r'OVERWRITE':
      return Enum$IdentifyFieldStrategy.OVERWRITE;
    default:
      return Enum$IdentifyFieldStrategy.$unknown;
  }
}

enum Enum$ImportDuplicateEnum {
  IGNORE,
  OVERWRITE,
  FAIL,
  $unknown;

  factory Enum$ImportDuplicateEnum.fromJson(String value) =>
      fromJson$Enum$ImportDuplicateEnum(value);

  String toJson() => toJson$Enum$ImportDuplicateEnum(this);
}

String toJson$Enum$ImportDuplicateEnum(Enum$ImportDuplicateEnum e) {
  switch (e) {
    case Enum$ImportDuplicateEnum.IGNORE:
      return r'IGNORE';
    case Enum$ImportDuplicateEnum.OVERWRITE:
      return r'OVERWRITE';
    case Enum$ImportDuplicateEnum.FAIL:
      return r'FAIL';
    case Enum$ImportDuplicateEnum.$unknown:
      return r'$unknown';
  }
}

Enum$ImportDuplicateEnum fromJson$Enum$ImportDuplicateEnum(String value) {
  switch (value) {
    case r'IGNORE':
      return Enum$ImportDuplicateEnum.IGNORE;
    case r'OVERWRITE':
      return Enum$ImportDuplicateEnum.OVERWRITE;
    case r'FAIL':
      return Enum$ImportDuplicateEnum.FAIL;
    default:
      return Enum$ImportDuplicateEnum.$unknown;
  }
}

enum Enum$ImportMissingRefEnum {
  IGNORE,
  FAIL,
  CREATE,
  $unknown;

  factory Enum$ImportMissingRefEnum.fromJson(String value) =>
      fromJson$Enum$ImportMissingRefEnum(value);

  String toJson() => toJson$Enum$ImportMissingRefEnum(this);
}

String toJson$Enum$ImportMissingRefEnum(Enum$ImportMissingRefEnum e) {
  switch (e) {
    case Enum$ImportMissingRefEnum.IGNORE:
      return r'IGNORE';
    case Enum$ImportMissingRefEnum.FAIL:
      return r'FAIL';
    case Enum$ImportMissingRefEnum.CREATE:
      return r'CREATE';
    case Enum$ImportMissingRefEnum.$unknown:
      return r'$unknown';
  }
}

Enum$ImportMissingRefEnum fromJson$Enum$ImportMissingRefEnum(String value) {
  switch (value) {
    case r'IGNORE':
      return Enum$ImportMissingRefEnum.IGNORE;
    case r'FAIL':
      return Enum$ImportMissingRefEnum.FAIL;
    case r'CREATE':
      return Enum$ImportMissingRefEnum.CREATE;
    default:
      return Enum$ImportMissingRefEnum.$unknown;
  }
}

enum Enum$SystemStatusEnum {
  SETUP,
  NEEDS_MIGRATION,
  OK,
  $unknown;

  factory Enum$SystemStatusEnum.fromJson(String value) =>
      fromJson$Enum$SystemStatusEnum(value);

  String toJson() => toJson$Enum$SystemStatusEnum(this);
}

String toJson$Enum$SystemStatusEnum(Enum$SystemStatusEnum e) {
  switch (e) {
    case Enum$SystemStatusEnum.SETUP:
      return r'SETUP';
    case Enum$SystemStatusEnum.NEEDS_MIGRATION:
      return r'NEEDS_MIGRATION';
    case Enum$SystemStatusEnum.OK:
      return r'OK';
    case Enum$SystemStatusEnum.$unknown:
      return r'$unknown';
  }
}

Enum$SystemStatusEnum fromJson$Enum$SystemStatusEnum(String value) {
  switch (value) {
    case r'SETUP':
      return Enum$SystemStatusEnum.SETUP;
    case r'NEEDS_MIGRATION':
      return Enum$SystemStatusEnum.NEEDS_MIGRATION;
    case r'OK':
      return Enum$SystemStatusEnum.OK;
    default:
      return Enum$SystemStatusEnum.$unknown;
  }
}
