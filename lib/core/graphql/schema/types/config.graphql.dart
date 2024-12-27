import 'metadata.graphql.dart';
import 'package.graphql.dart';
import 'stash-box.graphql.dart';

class Input$SetupInput {
  factory Input$SetupInput({
    required String configLocation,
    required List<Input$StashConfigInput> stashes,
    required String databaseFile,
    required String generatedLocation,
    required String cacheLocation,
    required bool storeBlobsInDatabase,
    required String blobsLocation,
  }) =>
      Input$SetupInput._({
        r'configLocation': configLocation,
        r'stashes': stashes,
        r'databaseFile': databaseFile,
        r'generatedLocation': generatedLocation,
        r'cacheLocation': cacheLocation,
        r'storeBlobsInDatabase': storeBlobsInDatabase,
        r'blobsLocation': blobsLocation,
      });

  Input$SetupInput._(this._$data);

  factory Input$SetupInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$configLocation = data['configLocation'];
    result$data['configLocation'] = (l$configLocation as String);
    final l$stashes = data['stashes'];
    result$data['stashes'] = (l$stashes as List<dynamic>)
        .map(
            (e) => Input$StashConfigInput.fromJson((e as Map<String, dynamic>)))
        .toList();
    final l$databaseFile = data['databaseFile'];
    result$data['databaseFile'] = (l$databaseFile as String);
    final l$generatedLocation = data['generatedLocation'];
    result$data['generatedLocation'] = (l$generatedLocation as String);
    final l$cacheLocation = data['cacheLocation'];
    result$data['cacheLocation'] = (l$cacheLocation as String);
    final l$storeBlobsInDatabase = data['storeBlobsInDatabase'];
    result$data['storeBlobsInDatabase'] = (l$storeBlobsInDatabase as bool);
    final l$blobsLocation = data['blobsLocation'];
    result$data['blobsLocation'] = (l$blobsLocation as String);
    return Input$SetupInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get configLocation => (_$data['configLocation'] as String);

  List<Input$StashConfigInput> get stashes =>
      (_$data['stashes'] as List<Input$StashConfigInput>);

  String get databaseFile => (_$data['databaseFile'] as String);

  String get generatedLocation => (_$data['generatedLocation'] as String);

  String get cacheLocation => (_$data['cacheLocation'] as String);

  bool get storeBlobsInDatabase => (_$data['storeBlobsInDatabase'] as bool);

  String get blobsLocation => (_$data['blobsLocation'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$configLocation = configLocation;
    result$data['configLocation'] = l$configLocation;
    final l$stashes = stashes;
    result$data['stashes'] = l$stashes.map((e) => e.toJson()).toList();
    final l$databaseFile = databaseFile;
    result$data['databaseFile'] = l$databaseFile;
    final l$generatedLocation = generatedLocation;
    result$data['generatedLocation'] = l$generatedLocation;
    final l$cacheLocation = cacheLocation;
    result$data['cacheLocation'] = l$cacheLocation;
    final l$storeBlobsInDatabase = storeBlobsInDatabase;
    result$data['storeBlobsInDatabase'] = l$storeBlobsInDatabase;
    final l$blobsLocation = blobsLocation;
    result$data['blobsLocation'] = l$blobsLocation;
    return result$data;
  }

  CopyWith$Input$SetupInput<Input$SetupInput> get copyWith =>
      CopyWith$Input$SetupInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$SetupInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$configLocation = configLocation;
    final lOther$configLocation = other.configLocation;
    if (l$configLocation != lOther$configLocation) {
      return false;
    }
    final l$stashes = stashes;
    final lOther$stashes = other.stashes;
    if (l$stashes.length != lOther$stashes.length) {
      return false;
    }
    for (int i = 0; i < l$stashes.length; i++) {
      final l$stashes$entry = l$stashes[i];
      final lOther$stashes$entry = lOther$stashes[i];
      if (l$stashes$entry != lOther$stashes$entry) {
        return false;
      }
    }
    final l$databaseFile = databaseFile;
    final lOther$databaseFile = other.databaseFile;
    if (l$databaseFile != lOther$databaseFile) {
      return false;
    }
    final l$generatedLocation = generatedLocation;
    final lOther$generatedLocation = other.generatedLocation;
    if (l$generatedLocation != lOther$generatedLocation) {
      return false;
    }
    final l$cacheLocation = cacheLocation;
    final lOther$cacheLocation = other.cacheLocation;
    if (l$cacheLocation != lOther$cacheLocation) {
      return false;
    }
    final l$storeBlobsInDatabase = storeBlobsInDatabase;
    final lOther$storeBlobsInDatabase = other.storeBlobsInDatabase;
    if (l$storeBlobsInDatabase != lOther$storeBlobsInDatabase) {
      return false;
    }
    final l$blobsLocation = blobsLocation;
    final lOther$blobsLocation = other.blobsLocation;
    if (l$blobsLocation != lOther$blobsLocation) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$configLocation = configLocation;
    final l$stashes = stashes;
    final l$databaseFile = databaseFile;
    final l$generatedLocation = generatedLocation;
    final l$cacheLocation = cacheLocation;
    final l$storeBlobsInDatabase = storeBlobsInDatabase;
    final l$blobsLocation = blobsLocation;
    return Object.hashAll([
      l$configLocation,
      Object.hashAll(l$stashes.map((v) => v)),
      l$databaseFile,
      l$generatedLocation,
      l$cacheLocation,
      l$storeBlobsInDatabase,
      l$blobsLocation,
    ]);
  }
}

abstract class CopyWith$Input$SetupInput<TRes> {
  factory CopyWith$Input$SetupInput(
    Input$SetupInput instance,
    TRes Function(Input$SetupInput) then,
  ) = _CopyWithImpl$Input$SetupInput;

  factory CopyWith$Input$SetupInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SetupInput;

  TRes call({
    String? configLocation,
    List<Input$StashConfigInput>? stashes,
    String? databaseFile,
    String? generatedLocation,
    String? cacheLocation,
    bool? storeBlobsInDatabase,
    String? blobsLocation,
  });
  TRes stashes(
      Iterable<Input$StashConfigInput> Function(
              Iterable<CopyWith$Input$StashConfigInput<Input$StashConfigInput>>)
          _fn);
}

class _CopyWithImpl$Input$SetupInput<TRes>
    implements CopyWith$Input$SetupInput<TRes> {
  _CopyWithImpl$Input$SetupInput(
    this._instance,
    this._then,
  );

  final Input$SetupInput _instance;

  final TRes Function(Input$SetupInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? configLocation = _undefined,
    Object? stashes = _undefined,
    Object? databaseFile = _undefined,
    Object? generatedLocation = _undefined,
    Object? cacheLocation = _undefined,
    Object? storeBlobsInDatabase = _undefined,
    Object? blobsLocation = _undefined,
  }) =>
      _then(Input$SetupInput._({
        ..._instance._$data,
        if (configLocation != _undefined && configLocation != null)
          'configLocation': (configLocation as String),
        if (stashes != _undefined && stashes != null)
          'stashes': (stashes as List<Input$StashConfigInput>),
        if (databaseFile != _undefined && databaseFile != null)
          'databaseFile': (databaseFile as String),
        if (generatedLocation != _undefined && generatedLocation != null)
          'generatedLocation': (generatedLocation as String),
        if (cacheLocation != _undefined && cacheLocation != null)
          'cacheLocation': (cacheLocation as String),
        if (storeBlobsInDatabase != _undefined && storeBlobsInDatabase != null)
          'storeBlobsInDatabase': (storeBlobsInDatabase as bool),
        if (blobsLocation != _undefined && blobsLocation != null)
          'blobsLocation': (blobsLocation as String),
      }));

  TRes stashes(
          Iterable<Input$StashConfigInput> Function(
                  Iterable<
                      CopyWith$Input$StashConfigInput<Input$StashConfigInput>>)
              _fn) =>
      call(
          stashes:
              _fn(_instance.stashes.map((e) => CopyWith$Input$StashConfigInput(
                    e,
                    (i) => i,
                  ))).toList());
}

class _CopyWithStubImpl$Input$SetupInput<TRes>
    implements CopyWith$Input$SetupInput<TRes> {
  _CopyWithStubImpl$Input$SetupInput(this._res);

  TRes _res;

  call({
    String? configLocation,
    List<Input$StashConfigInput>? stashes,
    String? databaseFile,
    String? generatedLocation,
    String? cacheLocation,
    bool? storeBlobsInDatabase,
    String? blobsLocation,
  }) =>
      _res;

  stashes(_fn) => _res;
}

class Input$ConfigGeneralInput {
  factory Input$ConfigGeneralInput({
    List<Input$StashConfigInput>? stashes,
    String? databasePath,
    String? backupDirectoryPath,
    String? generatedPath,
    String? metadataPath,
    String? scrapersPath,
    String? pluginsPath,
    String? cachePath,
    String? blobsPath,
    Enum$BlobsStorageType? blobsStorage,
    String? ffmpegPath,
    String? ffprobePath,
    bool? calculateMD5,
    Enum$HashAlgorithm? videoFileNamingAlgorithm,
    int? parallelTasks,
    bool? previewAudio,
    int? previewSegments,
    double? previewSegmentDuration,
    String? previewExcludeStart,
    String? previewExcludeEnd,
    Enum$PreviewPreset? previewPreset,
    bool? transcodeHardwareAcceleration,
    Enum$StreamingResolutionEnum? maxTranscodeSize,
    Enum$StreamingResolutionEnum? maxStreamingTranscodeSize,
    List<String>? transcodeInputArgs,
    List<String>? transcodeOutputArgs,
    List<String>? liveTranscodeInputArgs,
    List<String>? liveTranscodeOutputArgs,
    bool? drawFunscriptHeatmapRange,
    bool? writeImageThumbnails,
    bool? createImageClipsFromVideos,
    String? username,
    String? password,
    int? maxSessionAge,
    String? logFile,
    bool? logOut,
    String? logLevel,
    bool? logAccess,
    bool? createGalleriesFromFolders,
    String? galleryCoverRegex,
    List<String>? videoExtensions,
    List<String>? imageExtensions,
    List<String>? galleryExtensions,
    List<String>? excludes,
    List<String>? imageExcludes,
    String? customPerformerImageLocation,
    List<Input$StashBoxInput>? stashBoxes,
    String? pythonPath,
    List<Input$PackageSourceInput>? scraperPackageSources,
    List<Input$PackageSourceInput>? pluginPackageSources,
  }) =>
      Input$ConfigGeneralInput._({
        if (stashes != null) r'stashes': stashes,
        if (databasePath != null) r'databasePath': databasePath,
        if (backupDirectoryPath != null)
          r'backupDirectoryPath': backupDirectoryPath,
        if (generatedPath != null) r'generatedPath': generatedPath,
        if (metadataPath != null) r'metadataPath': metadataPath,
        if (scrapersPath != null) r'scrapersPath': scrapersPath,
        if (pluginsPath != null) r'pluginsPath': pluginsPath,
        if (cachePath != null) r'cachePath': cachePath,
        if (blobsPath != null) r'blobsPath': blobsPath,
        if (blobsStorage != null) r'blobsStorage': blobsStorage,
        if (ffmpegPath != null) r'ffmpegPath': ffmpegPath,
        if (ffprobePath != null) r'ffprobePath': ffprobePath,
        if (calculateMD5 != null) r'calculateMD5': calculateMD5,
        if (videoFileNamingAlgorithm != null)
          r'videoFileNamingAlgorithm': videoFileNamingAlgorithm,
        if (parallelTasks != null) r'parallelTasks': parallelTasks,
        if (previewAudio != null) r'previewAudio': previewAudio,
        if (previewSegments != null) r'previewSegments': previewSegments,
        if (previewSegmentDuration != null)
          r'previewSegmentDuration': previewSegmentDuration,
        if (previewExcludeStart != null)
          r'previewExcludeStart': previewExcludeStart,
        if (previewExcludeEnd != null) r'previewExcludeEnd': previewExcludeEnd,
        if (previewPreset != null) r'previewPreset': previewPreset,
        if (transcodeHardwareAcceleration != null)
          r'transcodeHardwareAcceleration': transcodeHardwareAcceleration,
        if (maxTranscodeSize != null) r'maxTranscodeSize': maxTranscodeSize,
        if (maxStreamingTranscodeSize != null)
          r'maxStreamingTranscodeSize': maxStreamingTranscodeSize,
        if (transcodeInputArgs != null)
          r'transcodeInputArgs': transcodeInputArgs,
        if (transcodeOutputArgs != null)
          r'transcodeOutputArgs': transcodeOutputArgs,
        if (liveTranscodeInputArgs != null)
          r'liveTranscodeInputArgs': liveTranscodeInputArgs,
        if (liveTranscodeOutputArgs != null)
          r'liveTranscodeOutputArgs': liveTranscodeOutputArgs,
        if (drawFunscriptHeatmapRange != null)
          r'drawFunscriptHeatmapRange': drawFunscriptHeatmapRange,
        if (writeImageThumbnails != null)
          r'writeImageThumbnails': writeImageThumbnails,
        if (createImageClipsFromVideos != null)
          r'createImageClipsFromVideos': createImageClipsFromVideos,
        if (username != null) r'username': username,
        if (password != null) r'password': password,
        if (maxSessionAge != null) r'maxSessionAge': maxSessionAge,
        if (logFile != null) r'logFile': logFile,
        if (logOut != null) r'logOut': logOut,
        if (logLevel != null) r'logLevel': logLevel,
        if (logAccess != null) r'logAccess': logAccess,
        if (createGalleriesFromFolders != null)
          r'createGalleriesFromFolders': createGalleriesFromFolders,
        if (galleryCoverRegex != null) r'galleryCoverRegex': galleryCoverRegex,
        if (videoExtensions != null) r'videoExtensions': videoExtensions,
        if (imageExtensions != null) r'imageExtensions': imageExtensions,
        if (galleryExtensions != null) r'galleryExtensions': galleryExtensions,
        if (excludes != null) r'excludes': excludes,
        if (imageExcludes != null) r'imageExcludes': imageExcludes,
        if (customPerformerImageLocation != null)
          r'customPerformerImageLocation': customPerformerImageLocation,
        if (stashBoxes != null) r'stashBoxes': stashBoxes,
        if (pythonPath != null) r'pythonPath': pythonPath,
        if (scraperPackageSources != null)
          r'scraperPackageSources': scraperPackageSources,
        if (pluginPackageSources != null)
          r'pluginPackageSources': pluginPackageSources,
      });

  Input$ConfigGeneralInput._(this._$data);

  factory Input$ConfigGeneralInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('stashes')) {
      final l$stashes = data['stashes'];
      result$data['stashes'] = (l$stashes as List<dynamic>?)
          ?.map((e) =>
              Input$StashConfigInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('databasePath')) {
      final l$databasePath = data['databasePath'];
      result$data['databasePath'] = (l$databasePath as String?);
    }
    if (data.containsKey('backupDirectoryPath')) {
      final l$backupDirectoryPath = data['backupDirectoryPath'];
      result$data['backupDirectoryPath'] = (l$backupDirectoryPath as String?);
    }
    if (data.containsKey('generatedPath')) {
      final l$generatedPath = data['generatedPath'];
      result$data['generatedPath'] = (l$generatedPath as String?);
    }
    if (data.containsKey('metadataPath')) {
      final l$metadataPath = data['metadataPath'];
      result$data['metadataPath'] = (l$metadataPath as String?);
    }
    if (data.containsKey('scrapersPath')) {
      final l$scrapersPath = data['scrapersPath'];
      result$data['scrapersPath'] = (l$scrapersPath as String?);
    }
    if (data.containsKey('pluginsPath')) {
      final l$pluginsPath = data['pluginsPath'];
      result$data['pluginsPath'] = (l$pluginsPath as String?);
    }
    if (data.containsKey('cachePath')) {
      final l$cachePath = data['cachePath'];
      result$data['cachePath'] = (l$cachePath as String?);
    }
    if (data.containsKey('blobsPath')) {
      final l$blobsPath = data['blobsPath'];
      result$data['blobsPath'] = (l$blobsPath as String?);
    }
    if (data.containsKey('blobsStorage')) {
      final l$blobsStorage = data['blobsStorage'];
      result$data['blobsStorage'] = l$blobsStorage == null
          ? null
          : fromJson$Enum$BlobsStorageType((l$blobsStorage as String));
    }
    if (data.containsKey('ffmpegPath')) {
      final l$ffmpegPath = data['ffmpegPath'];
      result$data['ffmpegPath'] = (l$ffmpegPath as String?);
    }
    if (data.containsKey('ffprobePath')) {
      final l$ffprobePath = data['ffprobePath'];
      result$data['ffprobePath'] = (l$ffprobePath as String?);
    }
    if (data.containsKey('calculateMD5')) {
      final l$calculateMD5 = data['calculateMD5'];
      result$data['calculateMD5'] = (l$calculateMD5 as bool?);
    }
    if (data.containsKey('videoFileNamingAlgorithm')) {
      final l$videoFileNamingAlgorithm = data['videoFileNamingAlgorithm'];
      result$data['videoFileNamingAlgorithm'] = l$videoFileNamingAlgorithm ==
              null
          ? null
          : fromJson$Enum$HashAlgorithm((l$videoFileNamingAlgorithm as String));
    }
    if (data.containsKey('parallelTasks')) {
      final l$parallelTasks = data['parallelTasks'];
      result$data['parallelTasks'] = (l$parallelTasks as int?);
    }
    if (data.containsKey('previewAudio')) {
      final l$previewAudio = data['previewAudio'];
      result$data['previewAudio'] = (l$previewAudio as bool?);
    }
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
    if (data.containsKey('transcodeHardwareAcceleration')) {
      final l$transcodeHardwareAcceleration =
          data['transcodeHardwareAcceleration'];
      result$data['transcodeHardwareAcceleration'] =
          (l$transcodeHardwareAcceleration as bool?);
    }
    if (data.containsKey('maxTranscodeSize')) {
      final l$maxTranscodeSize = data['maxTranscodeSize'];
      result$data['maxTranscodeSize'] = l$maxTranscodeSize == null
          ? null
          : fromJson$Enum$StreamingResolutionEnum(
              (l$maxTranscodeSize as String));
    }
    if (data.containsKey('maxStreamingTranscodeSize')) {
      final l$maxStreamingTranscodeSize = data['maxStreamingTranscodeSize'];
      result$data['maxStreamingTranscodeSize'] =
          l$maxStreamingTranscodeSize == null
              ? null
              : fromJson$Enum$StreamingResolutionEnum(
                  (l$maxStreamingTranscodeSize as String));
    }
    if (data.containsKey('transcodeInputArgs')) {
      final l$transcodeInputArgs = data['transcodeInputArgs'];
      result$data['transcodeInputArgs'] =
          (l$transcodeInputArgs as List<dynamic>?)
              ?.map((e) => (e as String))
              .toList();
    }
    if (data.containsKey('transcodeOutputArgs')) {
      final l$transcodeOutputArgs = data['transcodeOutputArgs'];
      result$data['transcodeOutputArgs'] =
          (l$transcodeOutputArgs as List<dynamic>?)
              ?.map((e) => (e as String))
              .toList();
    }
    if (data.containsKey('liveTranscodeInputArgs')) {
      final l$liveTranscodeInputArgs = data['liveTranscodeInputArgs'];
      result$data['liveTranscodeInputArgs'] =
          (l$liveTranscodeInputArgs as List<dynamic>?)
              ?.map((e) => (e as String))
              .toList();
    }
    if (data.containsKey('liveTranscodeOutputArgs')) {
      final l$liveTranscodeOutputArgs = data['liveTranscodeOutputArgs'];
      result$data['liveTranscodeOutputArgs'] =
          (l$liveTranscodeOutputArgs as List<dynamic>?)
              ?.map((e) => (e as String))
              .toList();
    }
    if (data.containsKey('drawFunscriptHeatmapRange')) {
      final l$drawFunscriptHeatmapRange = data['drawFunscriptHeatmapRange'];
      result$data['drawFunscriptHeatmapRange'] =
          (l$drawFunscriptHeatmapRange as bool?);
    }
    if (data.containsKey('writeImageThumbnails')) {
      final l$writeImageThumbnails = data['writeImageThumbnails'];
      result$data['writeImageThumbnails'] = (l$writeImageThumbnails as bool?);
    }
    if (data.containsKey('createImageClipsFromVideos')) {
      final l$createImageClipsFromVideos = data['createImageClipsFromVideos'];
      result$data['createImageClipsFromVideos'] =
          (l$createImageClipsFromVideos as bool?);
    }
    if (data.containsKey('username')) {
      final l$username = data['username'];
      result$data['username'] = (l$username as String?);
    }
    if (data.containsKey('password')) {
      final l$password = data['password'];
      result$data['password'] = (l$password as String?);
    }
    if (data.containsKey('maxSessionAge')) {
      final l$maxSessionAge = data['maxSessionAge'];
      result$data['maxSessionAge'] = (l$maxSessionAge as int?);
    }
    if (data.containsKey('logFile')) {
      final l$logFile = data['logFile'];
      result$data['logFile'] = (l$logFile as String?);
    }
    if (data.containsKey('logOut')) {
      final l$logOut = data['logOut'];
      result$data['logOut'] = (l$logOut as bool?);
    }
    if (data.containsKey('logLevel')) {
      final l$logLevel = data['logLevel'];
      result$data['logLevel'] = (l$logLevel as String?);
    }
    if (data.containsKey('logAccess')) {
      final l$logAccess = data['logAccess'];
      result$data['logAccess'] = (l$logAccess as bool?);
    }
    if (data.containsKey('createGalleriesFromFolders')) {
      final l$createGalleriesFromFolders = data['createGalleriesFromFolders'];
      result$data['createGalleriesFromFolders'] =
          (l$createGalleriesFromFolders as bool?);
    }
    if (data.containsKey('galleryCoverRegex')) {
      final l$galleryCoverRegex = data['galleryCoverRegex'];
      result$data['galleryCoverRegex'] = (l$galleryCoverRegex as String?);
    }
    if (data.containsKey('videoExtensions')) {
      final l$videoExtensions = data['videoExtensions'];
      result$data['videoExtensions'] = (l$videoExtensions as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('imageExtensions')) {
      final l$imageExtensions = data['imageExtensions'];
      result$data['imageExtensions'] = (l$imageExtensions as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('galleryExtensions')) {
      final l$galleryExtensions = data['galleryExtensions'];
      result$data['galleryExtensions'] = (l$galleryExtensions as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('excludes')) {
      final l$excludes = data['excludes'];
      result$data['excludes'] =
          (l$excludes as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('imageExcludes')) {
      final l$imageExcludes = data['imageExcludes'];
      result$data['imageExcludes'] = (l$imageExcludes as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('customPerformerImageLocation')) {
      final l$customPerformerImageLocation =
          data['customPerformerImageLocation'];
      result$data['customPerformerImageLocation'] =
          (l$customPerformerImageLocation as String?);
    }
    if (data.containsKey('stashBoxes')) {
      final l$stashBoxes = data['stashBoxes'];
      result$data['stashBoxes'] = (l$stashBoxes as List<dynamic>?)
          ?.map(
              (e) => Input$StashBoxInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('pythonPath')) {
      final l$pythonPath = data['pythonPath'];
      result$data['pythonPath'] = (l$pythonPath as String?);
    }
    if (data.containsKey('scraperPackageSources')) {
      final l$scraperPackageSources = data['scraperPackageSources'];
      result$data['scraperPackageSources'] = (l$scraperPackageSources
              as List<dynamic>?)
          ?.map((e) =>
              Input$PackageSourceInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('pluginPackageSources')) {
      final l$pluginPackageSources = data['pluginPackageSources'];
      result$data['pluginPackageSources'] = (l$pluginPackageSources
              as List<dynamic>?)
          ?.map((e) =>
              Input$PackageSourceInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    return Input$ConfigGeneralInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<Input$StashConfigInput>? get stashes =>
      (_$data['stashes'] as List<Input$StashConfigInput>?);

  String? get databasePath => (_$data['databasePath'] as String?);

  String? get backupDirectoryPath => (_$data['backupDirectoryPath'] as String?);

  String? get generatedPath => (_$data['generatedPath'] as String?);

  String? get metadataPath => (_$data['metadataPath'] as String?);

  String? get scrapersPath => (_$data['scrapersPath'] as String?);

  String? get pluginsPath => (_$data['pluginsPath'] as String?);

  String? get cachePath => (_$data['cachePath'] as String?);

  String? get blobsPath => (_$data['blobsPath'] as String?);

  Enum$BlobsStorageType? get blobsStorage =>
      (_$data['blobsStorage'] as Enum$BlobsStorageType?);

  String? get ffmpegPath => (_$data['ffmpegPath'] as String?);

  String? get ffprobePath => (_$data['ffprobePath'] as String?);

  bool? get calculateMD5 => (_$data['calculateMD5'] as bool?);

  Enum$HashAlgorithm? get videoFileNamingAlgorithm =>
      (_$data['videoFileNamingAlgorithm'] as Enum$HashAlgorithm?);

  int? get parallelTasks => (_$data['parallelTasks'] as int?);

  bool? get previewAudio => (_$data['previewAudio'] as bool?);

  int? get previewSegments => (_$data['previewSegments'] as int?);

  double? get previewSegmentDuration =>
      (_$data['previewSegmentDuration'] as double?);

  String? get previewExcludeStart => (_$data['previewExcludeStart'] as String?);

  String? get previewExcludeEnd => (_$data['previewExcludeEnd'] as String?);

  Enum$PreviewPreset? get previewPreset =>
      (_$data['previewPreset'] as Enum$PreviewPreset?);

  bool? get transcodeHardwareAcceleration =>
      (_$data['transcodeHardwareAcceleration'] as bool?);

  Enum$StreamingResolutionEnum? get maxTranscodeSize =>
      (_$data['maxTranscodeSize'] as Enum$StreamingResolutionEnum?);

  Enum$StreamingResolutionEnum? get maxStreamingTranscodeSize =>
      (_$data['maxStreamingTranscodeSize'] as Enum$StreamingResolutionEnum?);

  List<String>? get transcodeInputArgs =>
      (_$data['transcodeInputArgs'] as List<String>?);

  List<String>? get transcodeOutputArgs =>
      (_$data['transcodeOutputArgs'] as List<String>?);

  List<String>? get liveTranscodeInputArgs =>
      (_$data['liveTranscodeInputArgs'] as List<String>?);

  List<String>? get liveTranscodeOutputArgs =>
      (_$data['liveTranscodeOutputArgs'] as List<String>?);

  bool? get drawFunscriptHeatmapRange =>
      (_$data['drawFunscriptHeatmapRange'] as bool?);

  bool? get writeImageThumbnails => (_$data['writeImageThumbnails'] as bool?);

  bool? get createImageClipsFromVideos =>
      (_$data['createImageClipsFromVideos'] as bool?);

  String? get username => (_$data['username'] as String?);

  String? get password => (_$data['password'] as String?);

  int? get maxSessionAge => (_$data['maxSessionAge'] as int?);

  String? get logFile => (_$data['logFile'] as String?);

  bool? get logOut => (_$data['logOut'] as bool?);

  String? get logLevel => (_$data['logLevel'] as String?);

  bool? get logAccess => (_$data['logAccess'] as bool?);

  bool? get createGalleriesFromFolders =>
      (_$data['createGalleriesFromFolders'] as bool?);

  String? get galleryCoverRegex => (_$data['galleryCoverRegex'] as String?);

  List<String>? get videoExtensions =>
      (_$data['videoExtensions'] as List<String>?);

  List<String>? get imageExtensions =>
      (_$data['imageExtensions'] as List<String>?);

  List<String>? get galleryExtensions =>
      (_$data['galleryExtensions'] as List<String>?);

  List<String>? get excludes => (_$data['excludes'] as List<String>?);

  List<String>? get imageExcludes => (_$data['imageExcludes'] as List<String>?);

  String? get customPerformerImageLocation =>
      (_$data['customPerformerImageLocation'] as String?);

  List<Input$StashBoxInput>? get stashBoxes =>
      (_$data['stashBoxes'] as List<Input$StashBoxInput>?);

  String? get pythonPath => (_$data['pythonPath'] as String?);

  List<Input$PackageSourceInput>? get scraperPackageSources =>
      (_$data['scraperPackageSources'] as List<Input$PackageSourceInput>?);

  List<Input$PackageSourceInput>? get pluginPackageSources =>
      (_$data['pluginPackageSources'] as List<Input$PackageSourceInput>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('stashes')) {
      final l$stashes = stashes;
      result$data['stashes'] = l$stashes?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('databasePath')) {
      final l$databasePath = databasePath;
      result$data['databasePath'] = l$databasePath;
    }
    if (_$data.containsKey('backupDirectoryPath')) {
      final l$backupDirectoryPath = backupDirectoryPath;
      result$data['backupDirectoryPath'] = l$backupDirectoryPath;
    }
    if (_$data.containsKey('generatedPath')) {
      final l$generatedPath = generatedPath;
      result$data['generatedPath'] = l$generatedPath;
    }
    if (_$data.containsKey('metadataPath')) {
      final l$metadataPath = metadataPath;
      result$data['metadataPath'] = l$metadataPath;
    }
    if (_$data.containsKey('scrapersPath')) {
      final l$scrapersPath = scrapersPath;
      result$data['scrapersPath'] = l$scrapersPath;
    }
    if (_$data.containsKey('pluginsPath')) {
      final l$pluginsPath = pluginsPath;
      result$data['pluginsPath'] = l$pluginsPath;
    }
    if (_$data.containsKey('cachePath')) {
      final l$cachePath = cachePath;
      result$data['cachePath'] = l$cachePath;
    }
    if (_$data.containsKey('blobsPath')) {
      final l$blobsPath = blobsPath;
      result$data['blobsPath'] = l$blobsPath;
    }
    if (_$data.containsKey('blobsStorage')) {
      final l$blobsStorage = blobsStorage;
      result$data['blobsStorage'] = l$blobsStorage == null
          ? null
          : toJson$Enum$BlobsStorageType(l$blobsStorage);
    }
    if (_$data.containsKey('ffmpegPath')) {
      final l$ffmpegPath = ffmpegPath;
      result$data['ffmpegPath'] = l$ffmpegPath;
    }
    if (_$data.containsKey('ffprobePath')) {
      final l$ffprobePath = ffprobePath;
      result$data['ffprobePath'] = l$ffprobePath;
    }
    if (_$data.containsKey('calculateMD5')) {
      final l$calculateMD5 = calculateMD5;
      result$data['calculateMD5'] = l$calculateMD5;
    }
    if (_$data.containsKey('videoFileNamingAlgorithm')) {
      final l$videoFileNamingAlgorithm = videoFileNamingAlgorithm;
      result$data['videoFileNamingAlgorithm'] =
          l$videoFileNamingAlgorithm == null
              ? null
              : toJson$Enum$HashAlgorithm(l$videoFileNamingAlgorithm);
    }
    if (_$data.containsKey('parallelTasks')) {
      final l$parallelTasks = parallelTasks;
      result$data['parallelTasks'] = l$parallelTasks;
    }
    if (_$data.containsKey('previewAudio')) {
      final l$previewAudio = previewAudio;
      result$data['previewAudio'] = l$previewAudio;
    }
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
    if (_$data.containsKey('transcodeHardwareAcceleration')) {
      final l$transcodeHardwareAcceleration = transcodeHardwareAcceleration;
      result$data['transcodeHardwareAcceleration'] =
          l$transcodeHardwareAcceleration;
    }
    if (_$data.containsKey('maxTranscodeSize')) {
      final l$maxTranscodeSize = maxTranscodeSize;
      result$data['maxTranscodeSize'] = l$maxTranscodeSize == null
          ? null
          : toJson$Enum$StreamingResolutionEnum(l$maxTranscodeSize);
    }
    if (_$data.containsKey('maxStreamingTranscodeSize')) {
      final l$maxStreamingTranscodeSize = maxStreamingTranscodeSize;
      result$data['maxStreamingTranscodeSize'] = l$maxStreamingTranscodeSize ==
              null
          ? null
          : toJson$Enum$StreamingResolutionEnum(l$maxStreamingTranscodeSize);
    }
    if (_$data.containsKey('transcodeInputArgs')) {
      final l$transcodeInputArgs = transcodeInputArgs;
      result$data['transcodeInputArgs'] =
          l$transcodeInputArgs?.map((e) => e).toList();
    }
    if (_$data.containsKey('transcodeOutputArgs')) {
      final l$transcodeOutputArgs = transcodeOutputArgs;
      result$data['transcodeOutputArgs'] =
          l$transcodeOutputArgs?.map((e) => e).toList();
    }
    if (_$data.containsKey('liveTranscodeInputArgs')) {
      final l$liveTranscodeInputArgs = liveTranscodeInputArgs;
      result$data['liveTranscodeInputArgs'] =
          l$liveTranscodeInputArgs?.map((e) => e).toList();
    }
    if (_$data.containsKey('liveTranscodeOutputArgs')) {
      final l$liveTranscodeOutputArgs = liveTranscodeOutputArgs;
      result$data['liveTranscodeOutputArgs'] =
          l$liveTranscodeOutputArgs?.map((e) => e).toList();
    }
    if (_$data.containsKey('drawFunscriptHeatmapRange')) {
      final l$drawFunscriptHeatmapRange = drawFunscriptHeatmapRange;
      result$data['drawFunscriptHeatmapRange'] = l$drawFunscriptHeatmapRange;
    }
    if (_$data.containsKey('writeImageThumbnails')) {
      final l$writeImageThumbnails = writeImageThumbnails;
      result$data['writeImageThumbnails'] = l$writeImageThumbnails;
    }
    if (_$data.containsKey('createImageClipsFromVideos')) {
      final l$createImageClipsFromVideos = createImageClipsFromVideos;
      result$data['createImageClipsFromVideos'] = l$createImageClipsFromVideos;
    }
    if (_$data.containsKey('username')) {
      final l$username = username;
      result$data['username'] = l$username;
    }
    if (_$data.containsKey('password')) {
      final l$password = password;
      result$data['password'] = l$password;
    }
    if (_$data.containsKey('maxSessionAge')) {
      final l$maxSessionAge = maxSessionAge;
      result$data['maxSessionAge'] = l$maxSessionAge;
    }
    if (_$data.containsKey('logFile')) {
      final l$logFile = logFile;
      result$data['logFile'] = l$logFile;
    }
    if (_$data.containsKey('logOut')) {
      final l$logOut = logOut;
      result$data['logOut'] = l$logOut;
    }
    if (_$data.containsKey('logLevel')) {
      final l$logLevel = logLevel;
      result$data['logLevel'] = l$logLevel;
    }
    if (_$data.containsKey('logAccess')) {
      final l$logAccess = logAccess;
      result$data['logAccess'] = l$logAccess;
    }
    if (_$data.containsKey('createGalleriesFromFolders')) {
      final l$createGalleriesFromFolders = createGalleriesFromFolders;
      result$data['createGalleriesFromFolders'] = l$createGalleriesFromFolders;
    }
    if (_$data.containsKey('galleryCoverRegex')) {
      final l$galleryCoverRegex = galleryCoverRegex;
      result$data['galleryCoverRegex'] = l$galleryCoverRegex;
    }
    if (_$data.containsKey('videoExtensions')) {
      final l$videoExtensions = videoExtensions;
      result$data['videoExtensions'] =
          l$videoExtensions?.map((e) => e).toList();
    }
    if (_$data.containsKey('imageExtensions')) {
      final l$imageExtensions = imageExtensions;
      result$data['imageExtensions'] =
          l$imageExtensions?.map((e) => e).toList();
    }
    if (_$data.containsKey('galleryExtensions')) {
      final l$galleryExtensions = galleryExtensions;
      result$data['galleryExtensions'] =
          l$galleryExtensions?.map((e) => e).toList();
    }
    if (_$data.containsKey('excludes')) {
      final l$excludes = excludes;
      result$data['excludes'] = l$excludes?.map((e) => e).toList();
    }
    if (_$data.containsKey('imageExcludes')) {
      final l$imageExcludes = imageExcludes;
      result$data['imageExcludes'] = l$imageExcludes?.map((e) => e).toList();
    }
    if (_$data.containsKey('customPerformerImageLocation')) {
      final l$customPerformerImageLocation = customPerformerImageLocation;
      result$data['customPerformerImageLocation'] =
          l$customPerformerImageLocation;
    }
    if (_$data.containsKey('stashBoxes')) {
      final l$stashBoxes = stashBoxes;
      result$data['stashBoxes'] = l$stashBoxes?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('pythonPath')) {
      final l$pythonPath = pythonPath;
      result$data['pythonPath'] = l$pythonPath;
    }
    if (_$data.containsKey('scraperPackageSources')) {
      final l$scraperPackageSources = scraperPackageSources;
      result$data['scraperPackageSources'] =
          l$scraperPackageSources?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('pluginPackageSources')) {
      final l$pluginPackageSources = pluginPackageSources;
      result$data['pluginPackageSources'] =
          l$pluginPackageSources?.map((e) => e.toJson()).toList();
    }
    return result$data;
  }

  CopyWith$Input$ConfigGeneralInput<Input$ConfigGeneralInput> get copyWith =>
      CopyWith$Input$ConfigGeneralInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ConfigGeneralInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$stashes = stashes;
    final lOther$stashes = other.stashes;
    if (_$data.containsKey('stashes') != other._$data.containsKey('stashes')) {
      return false;
    }
    if (l$stashes != null && lOther$stashes != null) {
      if (l$stashes.length != lOther$stashes.length) {
        return false;
      }
      for (int i = 0; i < l$stashes.length; i++) {
        final l$stashes$entry = l$stashes[i];
        final lOther$stashes$entry = lOther$stashes[i];
        if (l$stashes$entry != lOther$stashes$entry) {
          return false;
        }
      }
    } else if (l$stashes != lOther$stashes) {
      return false;
    }
    final l$databasePath = databasePath;
    final lOther$databasePath = other.databasePath;
    if (_$data.containsKey('databasePath') !=
        other._$data.containsKey('databasePath')) {
      return false;
    }
    if (l$databasePath != lOther$databasePath) {
      return false;
    }
    final l$backupDirectoryPath = backupDirectoryPath;
    final lOther$backupDirectoryPath = other.backupDirectoryPath;
    if (_$data.containsKey('backupDirectoryPath') !=
        other._$data.containsKey('backupDirectoryPath')) {
      return false;
    }
    if (l$backupDirectoryPath != lOther$backupDirectoryPath) {
      return false;
    }
    final l$generatedPath = generatedPath;
    final lOther$generatedPath = other.generatedPath;
    if (_$data.containsKey('generatedPath') !=
        other._$data.containsKey('generatedPath')) {
      return false;
    }
    if (l$generatedPath != lOther$generatedPath) {
      return false;
    }
    final l$metadataPath = metadataPath;
    final lOther$metadataPath = other.metadataPath;
    if (_$data.containsKey('metadataPath') !=
        other._$data.containsKey('metadataPath')) {
      return false;
    }
    if (l$metadataPath != lOther$metadataPath) {
      return false;
    }
    final l$scrapersPath = scrapersPath;
    final lOther$scrapersPath = other.scrapersPath;
    if (_$data.containsKey('scrapersPath') !=
        other._$data.containsKey('scrapersPath')) {
      return false;
    }
    if (l$scrapersPath != lOther$scrapersPath) {
      return false;
    }
    final l$pluginsPath = pluginsPath;
    final lOther$pluginsPath = other.pluginsPath;
    if (_$data.containsKey('pluginsPath') !=
        other._$data.containsKey('pluginsPath')) {
      return false;
    }
    if (l$pluginsPath != lOther$pluginsPath) {
      return false;
    }
    final l$cachePath = cachePath;
    final lOther$cachePath = other.cachePath;
    if (_$data.containsKey('cachePath') !=
        other._$data.containsKey('cachePath')) {
      return false;
    }
    if (l$cachePath != lOther$cachePath) {
      return false;
    }
    final l$blobsPath = blobsPath;
    final lOther$blobsPath = other.blobsPath;
    if (_$data.containsKey('blobsPath') !=
        other._$data.containsKey('blobsPath')) {
      return false;
    }
    if (l$blobsPath != lOther$blobsPath) {
      return false;
    }
    final l$blobsStorage = blobsStorage;
    final lOther$blobsStorage = other.blobsStorage;
    if (_$data.containsKey('blobsStorage') !=
        other._$data.containsKey('blobsStorage')) {
      return false;
    }
    if (l$blobsStorage != lOther$blobsStorage) {
      return false;
    }
    final l$ffmpegPath = ffmpegPath;
    final lOther$ffmpegPath = other.ffmpegPath;
    if (_$data.containsKey('ffmpegPath') !=
        other._$data.containsKey('ffmpegPath')) {
      return false;
    }
    if (l$ffmpegPath != lOther$ffmpegPath) {
      return false;
    }
    final l$ffprobePath = ffprobePath;
    final lOther$ffprobePath = other.ffprobePath;
    if (_$data.containsKey('ffprobePath') !=
        other._$data.containsKey('ffprobePath')) {
      return false;
    }
    if (l$ffprobePath != lOther$ffprobePath) {
      return false;
    }
    final l$calculateMD5 = calculateMD5;
    final lOther$calculateMD5 = other.calculateMD5;
    if (_$data.containsKey('calculateMD5') !=
        other._$data.containsKey('calculateMD5')) {
      return false;
    }
    if (l$calculateMD5 != lOther$calculateMD5) {
      return false;
    }
    final l$videoFileNamingAlgorithm = videoFileNamingAlgorithm;
    final lOther$videoFileNamingAlgorithm = other.videoFileNamingAlgorithm;
    if (_$data.containsKey('videoFileNamingAlgorithm') !=
        other._$data.containsKey('videoFileNamingAlgorithm')) {
      return false;
    }
    if (l$videoFileNamingAlgorithm != lOther$videoFileNamingAlgorithm) {
      return false;
    }
    final l$parallelTasks = parallelTasks;
    final lOther$parallelTasks = other.parallelTasks;
    if (_$data.containsKey('parallelTasks') !=
        other._$data.containsKey('parallelTasks')) {
      return false;
    }
    if (l$parallelTasks != lOther$parallelTasks) {
      return false;
    }
    final l$previewAudio = previewAudio;
    final lOther$previewAudio = other.previewAudio;
    if (_$data.containsKey('previewAudio') !=
        other._$data.containsKey('previewAudio')) {
      return false;
    }
    if (l$previewAudio != lOther$previewAudio) {
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
    final l$transcodeHardwareAcceleration = transcodeHardwareAcceleration;
    final lOther$transcodeHardwareAcceleration =
        other.transcodeHardwareAcceleration;
    if (_$data.containsKey('transcodeHardwareAcceleration') !=
        other._$data.containsKey('transcodeHardwareAcceleration')) {
      return false;
    }
    if (l$transcodeHardwareAcceleration !=
        lOther$transcodeHardwareAcceleration) {
      return false;
    }
    final l$maxTranscodeSize = maxTranscodeSize;
    final lOther$maxTranscodeSize = other.maxTranscodeSize;
    if (_$data.containsKey('maxTranscodeSize') !=
        other._$data.containsKey('maxTranscodeSize')) {
      return false;
    }
    if (l$maxTranscodeSize != lOther$maxTranscodeSize) {
      return false;
    }
    final l$maxStreamingTranscodeSize = maxStreamingTranscodeSize;
    final lOther$maxStreamingTranscodeSize = other.maxStreamingTranscodeSize;
    if (_$data.containsKey('maxStreamingTranscodeSize') !=
        other._$data.containsKey('maxStreamingTranscodeSize')) {
      return false;
    }
    if (l$maxStreamingTranscodeSize != lOther$maxStreamingTranscodeSize) {
      return false;
    }
    final l$transcodeInputArgs = transcodeInputArgs;
    final lOther$transcodeInputArgs = other.transcodeInputArgs;
    if (_$data.containsKey('transcodeInputArgs') !=
        other._$data.containsKey('transcodeInputArgs')) {
      return false;
    }
    if (l$transcodeInputArgs != null && lOther$transcodeInputArgs != null) {
      if (l$transcodeInputArgs.length != lOther$transcodeInputArgs.length) {
        return false;
      }
      for (int i = 0; i < l$transcodeInputArgs.length; i++) {
        final l$transcodeInputArgs$entry = l$transcodeInputArgs[i];
        final lOther$transcodeInputArgs$entry = lOther$transcodeInputArgs[i];
        if (l$transcodeInputArgs$entry != lOther$transcodeInputArgs$entry) {
          return false;
        }
      }
    } else if (l$transcodeInputArgs != lOther$transcodeInputArgs) {
      return false;
    }
    final l$transcodeOutputArgs = transcodeOutputArgs;
    final lOther$transcodeOutputArgs = other.transcodeOutputArgs;
    if (_$data.containsKey('transcodeOutputArgs') !=
        other._$data.containsKey('transcodeOutputArgs')) {
      return false;
    }
    if (l$transcodeOutputArgs != null && lOther$transcodeOutputArgs != null) {
      if (l$transcodeOutputArgs.length != lOther$transcodeOutputArgs.length) {
        return false;
      }
      for (int i = 0; i < l$transcodeOutputArgs.length; i++) {
        final l$transcodeOutputArgs$entry = l$transcodeOutputArgs[i];
        final lOther$transcodeOutputArgs$entry = lOther$transcodeOutputArgs[i];
        if (l$transcodeOutputArgs$entry != lOther$transcodeOutputArgs$entry) {
          return false;
        }
      }
    } else if (l$transcodeOutputArgs != lOther$transcodeOutputArgs) {
      return false;
    }
    final l$liveTranscodeInputArgs = liveTranscodeInputArgs;
    final lOther$liveTranscodeInputArgs = other.liveTranscodeInputArgs;
    if (_$data.containsKey('liveTranscodeInputArgs') !=
        other._$data.containsKey('liveTranscodeInputArgs')) {
      return false;
    }
    if (l$liveTranscodeInputArgs != null &&
        lOther$liveTranscodeInputArgs != null) {
      if (l$liveTranscodeInputArgs.length !=
          lOther$liveTranscodeInputArgs.length) {
        return false;
      }
      for (int i = 0; i < l$liveTranscodeInputArgs.length; i++) {
        final l$liveTranscodeInputArgs$entry = l$liveTranscodeInputArgs[i];
        final lOther$liveTranscodeInputArgs$entry =
            lOther$liveTranscodeInputArgs[i];
        if (l$liveTranscodeInputArgs$entry !=
            lOther$liveTranscodeInputArgs$entry) {
          return false;
        }
      }
    } else if (l$liveTranscodeInputArgs != lOther$liveTranscodeInputArgs) {
      return false;
    }
    final l$liveTranscodeOutputArgs = liveTranscodeOutputArgs;
    final lOther$liveTranscodeOutputArgs = other.liveTranscodeOutputArgs;
    if (_$data.containsKey('liveTranscodeOutputArgs') !=
        other._$data.containsKey('liveTranscodeOutputArgs')) {
      return false;
    }
    if (l$liveTranscodeOutputArgs != null &&
        lOther$liveTranscodeOutputArgs != null) {
      if (l$liveTranscodeOutputArgs.length !=
          lOther$liveTranscodeOutputArgs.length) {
        return false;
      }
      for (int i = 0; i < l$liveTranscodeOutputArgs.length; i++) {
        final l$liveTranscodeOutputArgs$entry = l$liveTranscodeOutputArgs[i];
        final lOther$liveTranscodeOutputArgs$entry =
            lOther$liveTranscodeOutputArgs[i];
        if (l$liveTranscodeOutputArgs$entry !=
            lOther$liveTranscodeOutputArgs$entry) {
          return false;
        }
      }
    } else if (l$liveTranscodeOutputArgs != lOther$liveTranscodeOutputArgs) {
      return false;
    }
    final l$drawFunscriptHeatmapRange = drawFunscriptHeatmapRange;
    final lOther$drawFunscriptHeatmapRange = other.drawFunscriptHeatmapRange;
    if (_$data.containsKey('drawFunscriptHeatmapRange') !=
        other._$data.containsKey('drawFunscriptHeatmapRange')) {
      return false;
    }
    if (l$drawFunscriptHeatmapRange != lOther$drawFunscriptHeatmapRange) {
      return false;
    }
    final l$writeImageThumbnails = writeImageThumbnails;
    final lOther$writeImageThumbnails = other.writeImageThumbnails;
    if (_$data.containsKey('writeImageThumbnails') !=
        other._$data.containsKey('writeImageThumbnails')) {
      return false;
    }
    if (l$writeImageThumbnails != lOther$writeImageThumbnails) {
      return false;
    }
    final l$createImageClipsFromVideos = createImageClipsFromVideos;
    final lOther$createImageClipsFromVideos = other.createImageClipsFromVideos;
    if (_$data.containsKey('createImageClipsFromVideos') !=
        other._$data.containsKey('createImageClipsFromVideos')) {
      return false;
    }
    if (l$createImageClipsFromVideos != lOther$createImageClipsFromVideos) {
      return false;
    }
    final l$username = username;
    final lOther$username = other.username;
    if (_$data.containsKey('username') !=
        other._$data.containsKey('username')) {
      return false;
    }
    if (l$username != lOther$username) {
      return false;
    }
    final l$password = password;
    final lOther$password = other.password;
    if (_$data.containsKey('password') !=
        other._$data.containsKey('password')) {
      return false;
    }
    if (l$password != lOther$password) {
      return false;
    }
    final l$maxSessionAge = maxSessionAge;
    final lOther$maxSessionAge = other.maxSessionAge;
    if (_$data.containsKey('maxSessionAge') !=
        other._$data.containsKey('maxSessionAge')) {
      return false;
    }
    if (l$maxSessionAge != lOther$maxSessionAge) {
      return false;
    }
    final l$logFile = logFile;
    final lOther$logFile = other.logFile;
    if (_$data.containsKey('logFile') != other._$data.containsKey('logFile')) {
      return false;
    }
    if (l$logFile != lOther$logFile) {
      return false;
    }
    final l$logOut = logOut;
    final lOther$logOut = other.logOut;
    if (_$data.containsKey('logOut') != other._$data.containsKey('logOut')) {
      return false;
    }
    if (l$logOut != lOther$logOut) {
      return false;
    }
    final l$logLevel = logLevel;
    final lOther$logLevel = other.logLevel;
    if (_$data.containsKey('logLevel') !=
        other._$data.containsKey('logLevel')) {
      return false;
    }
    if (l$logLevel != lOther$logLevel) {
      return false;
    }
    final l$logAccess = logAccess;
    final lOther$logAccess = other.logAccess;
    if (_$data.containsKey('logAccess') !=
        other._$data.containsKey('logAccess')) {
      return false;
    }
    if (l$logAccess != lOther$logAccess) {
      return false;
    }
    final l$createGalleriesFromFolders = createGalleriesFromFolders;
    final lOther$createGalleriesFromFolders = other.createGalleriesFromFolders;
    if (_$data.containsKey('createGalleriesFromFolders') !=
        other._$data.containsKey('createGalleriesFromFolders')) {
      return false;
    }
    if (l$createGalleriesFromFolders != lOther$createGalleriesFromFolders) {
      return false;
    }
    final l$galleryCoverRegex = galleryCoverRegex;
    final lOther$galleryCoverRegex = other.galleryCoverRegex;
    if (_$data.containsKey('galleryCoverRegex') !=
        other._$data.containsKey('galleryCoverRegex')) {
      return false;
    }
    if (l$galleryCoverRegex != lOther$galleryCoverRegex) {
      return false;
    }
    final l$videoExtensions = videoExtensions;
    final lOther$videoExtensions = other.videoExtensions;
    if (_$data.containsKey('videoExtensions') !=
        other._$data.containsKey('videoExtensions')) {
      return false;
    }
    if (l$videoExtensions != null && lOther$videoExtensions != null) {
      if (l$videoExtensions.length != lOther$videoExtensions.length) {
        return false;
      }
      for (int i = 0; i < l$videoExtensions.length; i++) {
        final l$videoExtensions$entry = l$videoExtensions[i];
        final lOther$videoExtensions$entry = lOther$videoExtensions[i];
        if (l$videoExtensions$entry != lOther$videoExtensions$entry) {
          return false;
        }
      }
    } else if (l$videoExtensions != lOther$videoExtensions) {
      return false;
    }
    final l$imageExtensions = imageExtensions;
    final lOther$imageExtensions = other.imageExtensions;
    if (_$data.containsKey('imageExtensions') !=
        other._$data.containsKey('imageExtensions')) {
      return false;
    }
    if (l$imageExtensions != null && lOther$imageExtensions != null) {
      if (l$imageExtensions.length != lOther$imageExtensions.length) {
        return false;
      }
      for (int i = 0; i < l$imageExtensions.length; i++) {
        final l$imageExtensions$entry = l$imageExtensions[i];
        final lOther$imageExtensions$entry = lOther$imageExtensions[i];
        if (l$imageExtensions$entry != lOther$imageExtensions$entry) {
          return false;
        }
      }
    } else if (l$imageExtensions != lOther$imageExtensions) {
      return false;
    }
    final l$galleryExtensions = galleryExtensions;
    final lOther$galleryExtensions = other.galleryExtensions;
    if (_$data.containsKey('galleryExtensions') !=
        other._$data.containsKey('galleryExtensions')) {
      return false;
    }
    if (l$galleryExtensions != null && lOther$galleryExtensions != null) {
      if (l$galleryExtensions.length != lOther$galleryExtensions.length) {
        return false;
      }
      for (int i = 0; i < l$galleryExtensions.length; i++) {
        final l$galleryExtensions$entry = l$galleryExtensions[i];
        final lOther$galleryExtensions$entry = lOther$galleryExtensions[i];
        if (l$galleryExtensions$entry != lOther$galleryExtensions$entry) {
          return false;
        }
      }
    } else if (l$galleryExtensions != lOther$galleryExtensions) {
      return false;
    }
    final l$excludes = excludes;
    final lOther$excludes = other.excludes;
    if (_$data.containsKey('excludes') !=
        other._$data.containsKey('excludes')) {
      return false;
    }
    if (l$excludes != null && lOther$excludes != null) {
      if (l$excludes.length != lOther$excludes.length) {
        return false;
      }
      for (int i = 0; i < l$excludes.length; i++) {
        final l$excludes$entry = l$excludes[i];
        final lOther$excludes$entry = lOther$excludes[i];
        if (l$excludes$entry != lOther$excludes$entry) {
          return false;
        }
      }
    } else if (l$excludes != lOther$excludes) {
      return false;
    }
    final l$imageExcludes = imageExcludes;
    final lOther$imageExcludes = other.imageExcludes;
    if (_$data.containsKey('imageExcludes') !=
        other._$data.containsKey('imageExcludes')) {
      return false;
    }
    if (l$imageExcludes != null && lOther$imageExcludes != null) {
      if (l$imageExcludes.length != lOther$imageExcludes.length) {
        return false;
      }
      for (int i = 0; i < l$imageExcludes.length; i++) {
        final l$imageExcludes$entry = l$imageExcludes[i];
        final lOther$imageExcludes$entry = lOther$imageExcludes[i];
        if (l$imageExcludes$entry != lOther$imageExcludes$entry) {
          return false;
        }
      }
    } else if (l$imageExcludes != lOther$imageExcludes) {
      return false;
    }
    final l$customPerformerImageLocation = customPerformerImageLocation;
    final lOther$customPerformerImageLocation =
        other.customPerformerImageLocation;
    if (_$data.containsKey('customPerformerImageLocation') !=
        other._$data.containsKey('customPerformerImageLocation')) {
      return false;
    }
    if (l$customPerformerImageLocation != lOther$customPerformerImageLocation) {
      return false;
    }
    final l$stashBoxes = stashBoxes;
    final lOther$stashBoxes = other.stashBoxes;
    if (_$data.containsKey('stashBoxes') !=
        other._$data.containsKey('stashBoxes')) {
      return false;
    }
    if (l$stashBoxes != null && lOther$stashBoxes != null) {
      if (l$stashBoxes.length != lOther$stashBoxes.length) {
        return false;
      }
      for (int i = 0; i < l$stashBoxes.length; i++) {
        final l$stashBoxes$entry = l$stashBoxes[i];
        final lOther$stashBoxes$entry = lOther$stashBoxes[i];
        if (l$stashBoxes$entry != lOther$stashBoxes$entry) {
          return false;
        }
      }
    } else if (l$stashBoxes != lOther$stashBoxes) {
      return false;
    }
    final l$pythonPath = pythonPath;
    final lOther$pythonPath = other.pythonPath;
    if (_$data.containsKey('pythonPath') !=
        other._$data.containsKey('pythonPath')) {
      return false;
    }
    if (l$pythonPath != lOther$pythonPath) {
      return false;
    }
    final l$scraperPackageSources = scraperPackageSources;
    final lOther$scraperPackageSources = other.scraperPackageSources;
    if (_$data.containsKey('scraperPackageSources') !=
        other._$data.containsKey('scraperPackageSources')) {
      return false;
    }
    if (l$scraperPackageSources != null &&
        lOther$scraperPackageSources != null) {
      if (l$scraperPackageSources.length !=
          lOther$scraperPackageSources.length) {
        return false;
      }
      for (int i = 0; i < l$scraperPackageSources.length; i++) {
        final l$scraperPackageSources$entry = l$scraperPackageSources[i];
        final lOther$scraperPackageSources$entry =
            lOther$scraperPackageSources[i];
        if (l$scraperPackageSources$entry !=
            lOther$scraperPackageSources$entry) {
          return false;
        }
      }
    } else if (l$scraperPackageSources != lOther$scraperPackageSources) {
      return false;
    }
    final l$pluginPackageSources = pluginPackageSources;
    final lOther$pluginPackageSources = other.pluginPackageSources;
    if (_$data.containsKey('pluginPackageSources') !=
        other._$data.containsKey('pluginPackageSources')) {
      return false;
    }
    if (l$pluginPackageSources != null && lOther$pluginPackageSources != null) {
      if (l$pluginPackageSources.length != lOther$pluginPackageSources.length) {
        return false;
      }
      for (int i = 0; i < l$pluginPackageSources.length; i++) {
        final l$pluginPackageSources$entry = l$pluginPackageSources[i];
        final lOther$pluginPackageSources$entry =
            lOther$pluginPackageSources[i];
        if (l$pluginPackageSources$entry != lOther$pluginPackageSources$entry) {
          return false;
        }
      }
    } else if (l$pluginPackageSources != lOther$pluginPackageSources) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$stashes = stashes;
    final l$databasePath = databasePath;
    final l$backupDirectoryPath = backupDirectoryPath;
    final l$generatedPath = generatedPath;
    final l$metadataPath = metadataPath;
    final l$scrapersPath = scrapersPath;
    final l$pluginsPath = pluginsPath;
    final l$cachePath = cachePath;
    final l$blobsPath = blobsPath;
    final l$blobsStorage = blobsStorage;
    final l$ffmpegPath = ffmpegPath;
    final l$ffprobePath = ffprobePath;
    final l$calculateMD5 = calculateMD5;
    final l$videoFileNamingAlgorithm = videoFileNamingAlgorithm;
    final l$parallelTasks = parallelTasks;
    final l$previewAudio = previewAudio;
    final l$previewSegments = previewSegments;
    final l$previewSegmentDuration = previewSegmentDuration;
    final l$previewExcludeStart = previewExcludeStart;
    final l$previewExcludeEnd = previewExcludeEnd;
    final l$previewPreset = previewPreset;
    final l$transcodeHardwareAcceleration = transcodeHardwareAcceleration;
    final l$maxTranscodeSize = maxTranscodeSize;
    final l$maxStreamingTranscodeSize = maxStreamingTranscodeSize;
    final l$transcodeInputArgs = transcodeInputArgs;
    final l$transcodeOutputArgs = transcodeOutputArgs;
    final l$liveTranscodeInputArgs = liveTranscodeInputArgs;
    final l$liveTranscodeOutputArgs = liveTranscodeOutputArgs;
    final l$drawFunscriptHeatmapRange = drawFunscriptHeatmapRange;
    final l$writeImageThumbnails = writeImageThumbnails;
    final l$createImageClipsFromVideos = createImageClipsFromVideos;
    final l$username = username;
    final l$password = password;
    final l$maxSessionAge = maxSessionAge;
    final l$logFile = logFile;
    final l$logOut = logOut;
    final l$logLevel = logLevel;
    final l$logAccess = logAccess;
    final l$createGalleriesFromFolders = createGalleriesFromFolders;
    final l$galleryCoverRegex = galleryCoverRegex;
    final l$videoExtensions = videoExtensions;
    final l$imageExtensions = imageExtensions;
    final l$galleryExtensions = galleryExtensions;
    final l$excludes = excludes;
    final l$imageExcludes = imageExcludes;
    final l$customPerformerImageLocation = customPerformerImageLocation;
    final l$stashBoxes = stashBoxes;
    final l$pythonPath = pythonPath;
    final l$scraperPackageSources = scraperPackageSources;
    final l$pluginPackageSources = pluginPackageSources;
    return Object.hashAll([
      _$data.containsKey('stashes')
          ? l$stashes == null
              ? null
              : Object.hashAll(l$stashes.map((v) => v))
          : const {},
      _$data.containsKey('databasePath') ? l$databasePath : const {},
      _$data.containsKey('backupDirectoryPath')
          ? l$backupDirectoryPath
          : const {},
      _$data.containsKey('generatedPath') ? l$generatedPath : const {},
      _$data.containsKey('metadataPath') ? l$metadataPath : const {},
      _$data.containsKey('scrapersPath') ? l$scrapersPath : const {},
      _$data.containsKey('pluginsPath') ? l$pluginsPath : const {},
      _$data.containsKey('cachePath') ? l$cachePath : const {},
      _$data.containsKey('blobsPath') ? l$blobsPath : const {},
      _$data.containsKey('blobsStorage') ? l$blobsStorage : const {},
      _$data.containsKey('ffmpegPath') ? l$ffmpegPath : const {},
      _$data.containsKey('ffprobePath') ? l$ffprobePath : const {},
      _$data.containsKey('calculateMD5') ? l$calculateMD5 : const {},
      _$data.containsKey('videoFileNamingAlgorithm')
          ? l$videoFileNamingAlgorithm
          : const {},
      _$data.containsKey('parallelTasks') ? l$parallelTasks : const {},
      _$data.containsKey('previewAudio') ? l$previewAudio : const {},
      _$data.containsKey('previewSegments') ? l$previewSegments : const {},
      _$data.containsKey('previewSegmentDuration')
          ? l$previewSegmentDuration
          : const {},
      _$data.containsKey('previewExcludeStart')
          ? l$previewExcludeStart
          : const {},
      _$data.containsKey('previewExcludeEnd') ? l$previewExcludeEnd : const {},
      _$data.containsKey('previewPreset') ? l$previewPreset : const {},
      _$data.containsKey('transcodeHardwareAcceleration')
          ? l$transcodeHardwareAcceleration
          : const {},
      _$data.containsKey('maxTranscodeSize') ? l$maxTranscodeSize : const {},
      _$data.containsKey('maxStreamingTranscodeSize')
          ? l$maxStreamingTranscodeSize
          : const {},
      _$data.containsKey('transcodeInputArgs')
          ? l$transcodeInputArgs == null
              ? null
              : Object.hashAll(l$transcodeInputArgs.map((v) => v))
          : const {},
      _$data.containsKey('transcodeOutputArgs')
          ? l$transcodeOutputArgs == null
              ? null
              : Object.hashAll(l$transcodeOutputArgs.map((v) => v))
          : const {},
      _$data.containsKey('liveTranscodeInputArgs')
          ? l$liveTranscodeInputArgs == null
              ? null
              : Object.hashAll(l$liveTranscodeInputArgs.map((v) => v))
          : const {},
      _$data.containsKey('liveTranscodeOutputArgs')
          ? l$liveTranscodeOutputArgs == null
              ? null
              : Object.hashAll(l$liveTranscodeOutputArgs.map((v) => v))
          : const {},
      _$data.containsKey('drawFunscriptHeatmapRange')
          ? l$drawFunscriptHeatmapRange
          : const {},
      _$data.containsKey('writeImageThumbnails')
          ? l$writeImageThumbnails
          : const {},
      _$data.containsKey('createImageClipsFromVideos')
          ? l$createImageClipsFromVideos
          : const {},
      _$data.containsKey('username') ? l$username : const {},
      _$data.containsKey('password') ? l$password : const {},
      _$data.containsKey('maxSessionAge') ? l$maxSessionAge : const {},
      _$data.containsKey('logFile') ? l$logFile : const {},
      _$data.containsKey('logOut') ? l$logOut : const {},
      _$data.containsKey('logLevel') ? l$logLevel : const {},
      _$data.containsKey('logAccess') ? l$logAccess : const {},
      _$data.containsKey('createGalleriesFromFolders')
          ? l$createGalleriesFromFolders
          : const {},
      _$data.containsKey('galleryCoverRegex') ? l$galleryCoverRegex : const {},
      _$data.containsKey('videoExtensions')
          ? l$videoExtensions == null
              ? null
              : Object.hashAll(l$videoExtensions.map((v) => v))
          : const {},
      _$data.containsKey('imageExtensions')
          ? l$imageExtensions == null
              ? null
              : Object.hashAll(l$imageExtensions.map((v) => v))
          : const {},
      _$data.containsKey('galleryExtensions')
          ? l$galleryExtensions == null
              ? null
              : Object.hashAll(l$galleryExtensions.map((v) => v))
          : const {},
      _$data.containsKey('excludes')
          ? l$excludes == null
              ? null
              : Object.hashAll(l$excludes.map((v) => v))
          : const {},
      _$data.containsKey('imageExcludes')
          ? l$imageExcludes == null
              ? null
              : Object.hashAll(l$imageExcludes.map((v) => v))
          : const {},
      _$data.containsKey('customPerformerImageLocation')
          ? l$customPerformerImageLocation
          : const {},
      _$data.containsKey('stashBoxes')
          ? l$stashBoxes == null
              ? null
              : Object.hashAll(l$stashBoxes.map((v) => v))
          : const {},
      _$data.containsKey('pythonPath') ? l$pythonPath : const {},
      _$data.containsKey('scraperPackageSources')
          ? l$scraperPackageSources == null
              ? null
              : Object.hashAll(l$scraperPackageSources.map((v) => v))
          : const {},
      _$data.containsKey('pluginPackageSources')
          ? l$pluginPackageSources == null
              ? null
              : Object.hashAll(l$pluginPackageSources.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$ConfigGeneralInput<TRes> {
  factory CopyWith$Input$ConfigGeneralInput(
    Input$ConfigGeneralInput instance,
    TRes Function(Input$ConfigGeneralInput) then,
  ) = _CopyWithImpl$Input$ConfigGeneralInput;

  factory CopyWith$Input$ConfigGeneralInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfigGeneralInput;

  TRes call({
    List<Input$StashConfigInput>? stashes,
    String? databasePath,
    String? backupDirectoryPath,
    String? generatedPath,
    String? metadataPath,
    String? scrapersPath,
    String? pluginsPath,
    String? cachePath,
    String? blobsPath,
    Enum$BlobsStorageType? blobsStorage,
    String? ffmpegPath,
    String? ffprobePath,
    bool? calculateMD5,
    Enum$HashAlgorithm? videoFileNamingAlgorithm,
    int? parallelTasks,
    bool? previewAudio,
    int? previewSegments,
    double? previewSegmentDuration,
    String? previewExcludeStart,
    String? previewExcludeEnd,
    Enum$PreviewPreset? previewPreset,
    bool? transcodeHardwareAcceleration,
    Enum$StreamingResolutionEnum? maxTranscodeSize,
    Enum$StreamingResolutionEnum? maxStreamingTranscodeSize,
    List<String>? transcodeInputArgs,
    List<String>? transcodeOutputArgs,
    List<String>? liveTranscodeInputArgs,
    List<String>? liveTranscodeOutputArgs,
    bool? drawFunscriptHeatmapRange,
    bool? writeImageThumbnails,
    bool? createImageClipsFromVideos,
    String? username,
    String? password,
    int? maxSessionAge,
    String? logFile,
    bool? logOut,
    String? logLevel,
    bool? logAccess,
    bool? createGalleriesFromFolders,
    String? galleryCoverRegex,
    List<String>? videoExtensions,
    List<String>? imageExtensions,
    List<String>? galleryExtensions,
    List<String>? excludes,
    List<String>? imageExcludes,
    String? customPerformerImageLocation,
    List<Input$StashBoxInput>? stashBoxes,
    String? pythonPath,
    List<Input$PackageSourceInput>? scraperPackageSources,
    List<Input$PackageSourceInput>? pluginPackageSources,
  });
  TRes stashes(
      Iterable<Input$StashConfigInput>? Function(
              Iterable<
                  CopyWith$Input$StashConfigInput<Input$StashConfigInput>>?)
          _fn);
}

class _CopyWithImpl$Input$ConfigGeneralInput<TRes>
    implements CopyWith$Input$ConfigGeneralInput<TRes> {
  _CopyWithImpl$Input$ConfigGeneralInput(
    this._instance,
    this._then,
  );

  final Input$ConfigGeneralInput _instance;

  final TRes Function(Input$ConfigGeneralInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? stashes = _undefined,
    Object? databasePath = _undefined,
    Object? backupDirectoryPath = _undefined,
    Object? generatedPath = _undefined,
    Object? metadataPath = _undefined,
    Object? scrapersPath = _undefined,
    Object? pluginsPath = _undefined,
    Object? cachePath = _undefined,
    Object? blobsPath = _undefined,
    Object? blobsStorage = _undefined,
    Object? ffmpegPath = _undefined,
    Object? ffprobePath = _undefined,
    Object? calculateMD5 = _undefined,
    Object? videoFileNamingAlgorithm = _undefined,
    Object? parallelTasks = _undefined,
    Object? previewAudio = _undefined,
    Object? previewSegments = _undefined,
    Object? previewSegmentDuration = _undefined,
    Object? previewExcludeStart = _undefined,
    Object? previewExcludeEnd = _undefined,
    Object? previewPreset = _undefined,
    Object? transcodeHardwareAcceleration = _undefined,
    Object? maxTranscodeSize = _undefined,
    Object? maxStreamingTranscodeSize = _undefined,
    Object? transcodeInputArgs = _undefined,
    Object? transcodeOutputArgs = _undefined,
    Object? liveTranscodeInputArgs = _undefined,
    Object? liveTranscodeOutputArgs = _undefined,
    Object? drawFunscriptHeatmapRange = _undefined,
    Object? writeImageThumbnails = _undefined,
    Object? createImageClipsFromVideos = _undefined,
    Object? username = _undefined,
    Object? password = _undefined,
    Object? maxSessionAge = _undefined,
    Object? logFile = _undefined,
    Object? logOut = _undefined,
    Object? logLevel = _undefined,
    Object? logAccess = _undefined,
    Object? createGalleriesFromFolders = _undefined,
    Object? galleryCoverRegex = _undefined,
    Object? videoExtensions = _undefined,
    Object? imageExtensions = _undefined,
    Object? galleryExtensions = _undefined,
    Object? excludes = _undefined,
    Object? imageExcludes = _undefined,
    Object? customPerformerImageLocation = _undefined,
    Object? stashBoxes = _undefined,
    Object? pythonPath = _undefined,
    Object? scraperPackageSources = _undefined,
    Object? pluginPackageSources = _undefined,
  }) =>
      _then(Input$ConfigGeneralInput._({
        ..._instance._$data,
        if (stashes != _undefined)
          'stashes': (stashes as List<Input$StashConfigInput>?),
        if (databasePath != _undefined)
          'databasePath': (databasePath as String?),
        if (backupDirectoryPath != _undefined)
          'backupDirectoryPath': (backupDirectoryPath as String?),
        if (generatedPath != _undefined)
          'generatedPath': (generatedPath as String?),
        if (metadataPath != _undefined)
          'metadataPath': (metadataPath as String?),
        if (scrapersPath != _undefined)
          'scrapersPath': (scrapersPath as String?),
        if (pluginsPath != _undefined) 'pluginsPath': (pluginsPath as String?),
        if (cachePath != _undefined) 'cachePath': (cachePath as String?),
        if (blobsPath != _undefined) 'blobsPath': (blobsPath as String?),
        if (blobsStorage != _undefined)
          'blobsStorage': (blobsStorage as Enum$BlobsStorageType?),
        if (ffmpegPath != _undefined) 'ffmpegPath': (ffmpegPath as String?),
        if (ffprobePath != _undefined) 'ffprobePath': (ffprobePath as String?),
        if (calculateMD5 != _undefined) 'calculateMD5': (calculateMD5 as bool?),
        if (videoFileNamingAlgorithm != _undefined)
          'videoFileNamingAlgorithm':
              (videoFileNamingAlgorithm as Enum$HashAlgorithm?),
        if (parallelTasks != _undefined)
          'parallelTasks': (parallelTasks as int?),
        if (previewAudio != _undefined) 'previewAudio': (previewAudio as bool?),
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
        if (transcodeHardwareAcceleration != _undefined)
          'transcodeHardwareAcceleration':
              (transcodeHardwareAcceleration as bool?),
        if (maxTranscodeSize != _undefined)
          'maxTranscodeSize':
              (maxTranscodeSize as Enum$StreamingResolutionEnum?),
        if (maxStreamingTranscodeSize != _undefined)
          'maxStreamingTranscodeSize':
              (maxStreamingTranscodeSize as Enum$StreamingResolutionEnum?),
        if (transcodeInputArgs != _undefined)
          'transcodeInputArgs': (transcodeInputArgs as List<String>?),
        if (transcodeOutputArgs != _undefined)
          'transcodeOutputArgs': (transcodeOutputArgs as List<String>?),
        if (liveTranscodeInputArgs != _undefined)
          'liveTranscodeInputArgs': (liveTranscodeInputArgs as List<String>?),
        if (liveTranscodeOutputArgs != _undefined)
          'liveTranscodeOutputArgs': (liveTranscodeOutputArgs as List<String>?),
        if (drawFunscriptHeatmapRange != _undefined)
          'drawFunscriptHeatmapRange': (drawFunscriptHeatmapRange as bool?),
        if (writeImageThumbnails != _undefined)
          'writeImageThumbnails': (writeImageThumbnails as bool?),
        if (createImageClipsFromVideos != _undefined)
          'createImageClipsFromVideos': (createImageClipsFromVideos as bool?),
        if (username != _undefined) 'username': (username as String?),
        if (password != _undefined) 'password': (password as String?),
        if (maxSessionAge != _undefined)
          'maxSessionAge': (maxSessionAge as int?),
        if (logFile != _undefined) 'logFile': (logFile as String?),
        if (logOut != _undefined) 'logOut': (logOut as bool?),
        if (logLevel != _undefined) 'logLevel': (logLevel as String?),
        if (logAccess != _undefined) 'logAccess': (logAccess as bool?),
        if (createGalleriesFromFolders != _undefined)
          'createGalleriesFromFolders': (createGalleriesFromFolders as bool?),
        if (galleryCoverRegex != _undefined)
          'galleryCoverRegex': (galleryCoverRegex as String?),
        if (videoExtensions != _undefined)
          'videoExtensions': (videoExtensions as List<String>?),
        if (imageExtensions != _undefined)
          'imageExtensions': (imageExtensions as List<String>?),
        if (galleryExtensions != _undefined)
          'galleryExtensions': (galleryExtensions as List<String>?),
        if (excludes != _undefined) 'excludes': (excludes as List<String>?),
        if (imageExcludes != _undefined)
          'imageExcludes': (imageExcludes as List<String>?),
        if (customPerformerImageLocation != _undefined)
          'customPerformerImageLocation':
              (customPerformerImageLocation as String?),
        if (stashBoxes != _undefined)
          'stashBoxes': (stashBoxes as List<Input$StashBoxInput>?),
        if (pythonPath != _undefined) 'pythonPath': (pythonPath as String?),
        if (scraperPackageSources != _undefined)
          'scraperPackageSources':
              (scraperPackageSources as List<Input$PackageSourceInput>?),
        if (pluginPackageSources != _undefined)
          'pluginPackageSources':
              (pluginPackageSources as List<Input$PackageSourceInput>?),
      }));

  TRes stashes(
          Iterable<Input$StashConfigInput>? Function(
                  Iterable<
                      CopyWith$Input$StashConfigInput<Input$StashConfigInput>>?)
              _fn) =>
      call(
          stashes:
              _fn(_instance.stashes?.map((e) => CopyWith$Input$StashConfigInput(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Input$ConfigGeneralInput<TRes>
    implements CopyWith$Input$ConfigGeneralInput<TRes> {
  _CopyWithStubImpl$Input$ConfigGeneralInput(this._res);

  TRes _res;

  call({
    List<Input$StashConfigInput>? stashes,
    String? databasePath,
    String? backupDirectoryPath,
    String? generatedPath,
    String? metadataPath,
    String? scrapersPath,
    String? pluginsPath,
    String? cachePath,
    String? blobsPath,
    Enum$BlobsStorageType? blobsStorage,
    String? ffmpegPath,
    String? ffprobePath,
    bool? calculateMD5,
    Enum$HashAlgorithm? videoFileNamingAlgorithm,
    int? parallelTasks,
    bool? previewAudio,
    int? previewSegments,
    double? previewSegmentDuration,
    String? previewExcludeStart,
    String? previewExcludeEnd,
    Enum$PreviewPreset? previewPreset,
    bool? transcodeHardwareAcceleration,
    Enum$StreamingResolutionEnum? maxTranscodeSize,
    Enum$StreamingResolutionEnum? maxStreamingTranscodeSize,
    List<String>? transcodeInputArgs,
    List<String>? transcodeOutputArgs,
    List<String>? liveTranscodeInputArgs,
    List<String>? liveTranscodeOutputArgs,
    bool? drawFunscriptHeatmapRange,
    bool? writeImageThumbnails,
    bool? createImageClipsFromVideos,
    String? username,
    String? password,
    int? maxSessionAge,
    String? logFile,
    bool? logOut,
    String? logLevel,
    bool? logAccess,
    bool? createGalleriesFromFolders,
    String? galleryCoverRegex,
    List<String>? videoExtensions,
    List<String>? imageExtensions,
    List<String>? galleryExtensions,
    List<String>? excludes,
    List<String>? imageExcludes,
    String? customPerformerImageLocation,
    List<Input$StashBoxInput>? stashBoxes,
    String? pythonPath,
    List<Input$PackageSourceInput>? scraperPackageSources,
    List<Input$PackageSourceInput>? pluginPackageSources,
  }) =>
      _res;

  stashes(_fn) => _res;
}

class Input$ConfigDisableDropdownCreateInput {
  factory Input$ConfigDisableDropdownCreateInput({
    bool? performer,
    bool? tag,
    bool? studio,
    bool? movie,
  }) =>
      Input$ConfigDisableDropdownCreateInput._({
        if (performer != null) r'performer': performer,
        if (tag != null) r'tag': tag,
        if (studio != null) r'studio': studio,
        if (movie != null) r'movie': movie,
      });

  Input$ConfigDisableDropdownCreateInput._(this._$data);

  factory Input$ConfigDisableDropdownCreateInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('performer')) {
      final l$performer = data['performer'];
      result$data['performer'] = (l$performer as bool?);
    }
    if (data.containsKey('tag')) {
      final l$tag = data['tag'];
      result$data['tag'] = (l$tag as bool?);
    }
    if (data.containsKey('studio')) {
      final l$studio = data['studio'];
      result$data['studio'] = (l$studio as bool?);
    }
    if (data.containsKey('movie')) {
      final l$movie = data['movie'];
      result$data['movie'] = (l$movie as bool?);
    }
    return Input$ConfigDisableDropdownCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get performer => (_$data['performer'] as bool?);

  bool? get tag => (_$data['tag'] as bool?);

  bool? get studio => (_$data['studio'] as bool?);

  bool? get movie => (_$data['movie'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('performer')) {
      final l$performer = performer;
      result$data['performer'] = l$performer;
    }
    if (_$data.containsKey('tag')) {
      final l$tag = tag;
      result$data['tag'] = l$tag;
    }
    if (_$data.containsKey('studio')) {
      final l$studio = studio;
      result$data['studio'] = l$studio;
    }
    if (_$data.containsKey('movie')) {
      final l$movie = movie;
      result$data['movie'] = l$movie;
    }
    return result$data;
  }

  CopyWith$Input$ConfigDisableDropdownCreateInput<
          Input$ConfigDisableDropdownCreateInput>
      get copyWith => CopyWith$Input$ConfigDisableDropdownCreateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ConfigDisableDropdownCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$performer = performer;
    final lOther$performer = other.performer;
    if (_$data.containsKey('performer') !=
        other._$data.containsKey('performer')) {
      return false;
    }
    if (l$performer != lOther$performer) {
      return false;
    }
    final l$tag = tag;
    final lOther$tag = other.tag;
    if (_$data.containsKey('tag') != other._$data.containsKey('tag')) {
      return false;
    }
    if (l$tag != lOther$tag) {
      return false;
    }
    final l$studio = studio;
    final lOther$studio = other.studio;
    if (_$data.containsKey('studio') != other._$data.containsKey('studio')) {
      return false;
    }
    if (l$studio != lOther$studio) {
      return false;
    }
    final l$movie = movie;
    final lOther$movie = other.movie;
    if (_$data.containsKey('movie') != other._$data.containsKey('movie')) {
      return false;
    }
    if (l$movie != lOther$movie) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$performer = performer;
    final l$tag = tag;
    final l$studio = studio;
    final l$movie = movie;
    return Object.hashAll([
      _$data.containsKey('performer') ? l$performer : const {},
      _$data.containsKey('tag') ? l$tag : const {},
      _$data.containsKey('studio') ? l$studio : const {},
      _$data.containsKey('movie') ? l$movie : const {},
    ]);
  }
}

abstract class CopyWith$Input$ConfigDisableDropdownCreateInput<TRes> {
  factory CopyWith$Input$ConfigDisableDropdownCreateInput(
    Input$ConfigDisableDropdownCreateInput instance,
    TRes Function(Input$ConfigDisableDropdownCreateInput) then,
  ) = _CopyWithImpl$Input$ConfigDisableDropdownCreateInput;

  factory CopyWith$Input$ConfigDisableDropdownCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfigDisableDropdownCreateInput;

  TRes call({
    bool? performer,
    bool? tag,
    bool? studio,
    bool? movie,
  });
}

class _CopyWithImpl$Input$ConfigDisableDropdownCreateInput<TRes>
    implements CopyWith$Input$ConfigDisableDropdownCreateInput<TRes> {
  _CopyWithImpl$Input$ConfigDisableDropdownCreateInput(
    this._instance,
    this._then,
  );

  final Input$ConfigDisableDropdownCreateInput _instance;

  final TRes Function(Input$ConfigDisableDropdownCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? performer = _undefined,
    Object? tag = _undefined,
    Object? studio = _undefined,
    Object? movie = _undefined,
  }) =>
      _then(Input$ConfigDisableDropdownCreateInput._({
        ..._instance._$data,
        if (performer != _undefined) 'performer': (performer as bool?),
        if (tag != _undefined) 'tag': (tag as bool?),
        if (studio != _undefined) 'studio': (studio as bool?),
        if (movie != _undefined) 'movie': (movie as bool?),
      }));
}

class _CopyWithStubImpl$Input$ConfigDisableDropdownCreateInput<TRes>
    implements CopyWith$Input$ConfigDisableDropdownCreateInput<TRes> {
  _CopyWithStubImpl$Input$ConfigDisableDropdownCreateInput(this._res);

  TRes _res;

  call({
    bool? performer,
    bool? tag,
    bool? studio,
    bool? movie,
  }) =>
      _res;
}

class Input$ConfigImageLightboxInput {
  factory Input$ConfigImageLightboxInput({
    int? slideshowDelay,
    Enum$ImageLightboxDisplayMode? displayMode,
    bool? scaleUp,
    bool? resetZoomOnNav,
    Enum$ImageLightboxScrollMode? scrollMode,
    int? scrollAttemptsBeforeChange,
  }) =>
      Input$ConfigImageLightboxInput._({
        if (slideshowDelay != null) r'slideshowDelay': slideshowDelay,
        if (displayMode != null) r'displayMode': displayMode,
        if (scaleUp != null) r'scaleUp': scaleUp,
        if (resetZoomOnNav != null) r'resetZoomOnNav': resetZoomOnNav,
        if (scrollMode != null) r'scrollMode': scrollMode,
        if (scrollAttemptsBeforeChange != null)
          r'scrollAttemptsBeforeChange': scrollAttemptsBeforeChange,
      });

  Input$ConfigImageLightboxInput._(this._$data);

  factory Input$ConfigImageLightboxInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('slideshowDelay')) {
      final l$slideshowDelay = data['slideshowDelay'];
      result$data['slideshowDelay'] = (l$slideshowDelay as int?);
    }
    if (data.containsKey('displayMode')) {
      final l$displayMode = data['displayMode'];
      result$data['displayMode'] = l$displayMode == null
          ? null
          : fromJson$Enum$ImageLightboxDisplayMode((l$displayMode as String));
    }
    if (data.containsKey('scaleUp')) {
      final l$scaleUp = data['scaleUp'];
      result$data['scaleUp'] = (l$scaleUp as bool?);
    }
    if (data.containsKey('resetZoomOnNav')) {
      final l$resetZoomOnNav = data['resetZoomOnNav'];
      result$data['resetZoomOnNav'] = (l$resetZoomOnNav as bool?);
    }
    if (data.containsKey('scrollMode')) {
      final l$scrollMode = data['scrollMode'];
      result$data['scrollMode'] = l$scrollMode == null
          ? null
          : fromJson$Enum$ImageLightboxScrollMode((l$scrollMode as String));
    }
    if (data.containsKey('scrollAttemptsBeforeChange')) {
      final l$scrollAttemptsBeforeChange = data['scrollAttemptsBeforeChange'];
      result$data['scrollAttemptsBeforeChange'] =
          (l$scrollAttemptsBeforeChange as int?);
    }
    return Input$ConfigImageLightboxInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get slideshowDelay => (_$data['slideshowDelay'] as int?);

  Enum$ImageLightboxDisplayMode? get displayMode =>
      (_$data['displayMode'] as Enum$ImageLightboxDisplayMode?);

  bool? get scaleUp => (_$data['scaleUp'] as bool?);

  bool? get resetZoomOnNav => (_$data['resetZoomOnNav'] as bool?);

  Enum$ImageLightboxScrollMode? get scrollMode =>
      (_$data['scrollMode'] as Enum$ImageLightboxScrollMode?);

  int? get scrollAttemptsBeforeChange =>
      (_$data['scrollAttemptsBeforeChange'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('slideshowDelay')) {
      final l$slideshowDelay = slideshowDelay;
      result$data['slideshowDelay'] = l$slideshowDelay;
    }
    if (_$data.containsKey('displayMode')) {
      final l$displayMode = displayMode;
      result$data['displayMode'] = l$displayMode == null
          ? null
          : toJson$Enum$ImageLightboxDisplayMode(l$displayMode);
    }
    if (_$data.containsKey('scaleUp')) {
      final l$scaleUp = scaleUp;
      result$data['scaleUp'] = l$scaleUp;
    }
    if (_$data.containsKey('resetZoomOnNav')) {
      final l$resetZoomOnNav = resetZoomOnNav;
      result$data['resetZoomOnNav'] = l$resetZoomOnNav;
    }
    if (_$data.containsKey('scrollMode')) {
      final l$scrollMode = scrollMode;
      result$data['scrollMode'] = l$scrollMode == null
          ? null
          : toJson$Enum$ImageLightboxScrollMode(l$scrollMode);
    }
    if (_$data.containsKey('scrollAttemptsBeforeChange')) {
      final l$scrollAttemptsBeforeChange = scrollAttemptsBeforeChange;
      result$data['scrollAttemptsBeforeChange'] = l$scrollAttemptsBeforeChange;
    }
    return result$data;
  }

  CopyWith$Input$ConfigImageLightboxInput<Input$ConfigImageLightboxInput>
      get copyWith => CopyWith$Input$ConfigImageLightboxInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ConfigImageLightboxInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$slideshowDelay = slideshowDelay;
    final lOther$slideshowDelay = other.slideshowDelay;
    if (_$data.containsKey('slideshowDelay') !=
        other._$data.containsKey('slideshowDelay')) {
      return false;
    }
    if (l$slideshowDelay != lOther$slideshowDelay) {
      return false;
    }
    final l$displayMode = displayMode;
    final lOther$displayMode = other.displayMode;
    if (_$data.containsKey('displayMode') !=
        other._$data.containsKey('displayMode')) {
      return false;
    }
    if (l$displayMode != lOther$displayMode) {
      return false;
    }
    final l$scaleUp = scaleUp;
    final lOther$scaleUp = other.scaleUp;
    if (_$data.containsKey('scaleUp') != other._$data.containsKey('scaleUp')) {
      return false;
    }
    if (l$scaleUp != lOther$scaleUp) {
      return false;
    }
    final l$resetZoomOnNav = resetZoomOnNav;
    final lOther$resetZoomOnNav = other.resetZoomOnNav;
    if (_$data.containsKey('resetZoomOnNav') !=
        other._$data.containsKey('resetZoomOnNav')) {
      return false;
    }
    if (l$resetZoomOnNav != lOther$resetZoomOnNav) {
      return false;
    }
    final l$scrollMode = scrollMode;
    final lOther$scrollMode = other.scrollMode;
    if (_$data.containsKey('scrollMode') !=
        other._$data.containsKey('scrollMode')) {
      return false;
    }
    if (l$scrollMode != lOther$scrollMode) {
      return false;
    }
    final l$scrollAttemptsBeforeChange = scrollAttemptsBeforeChange;
    final lOther$scrollAttemptsBeforeChange = other.scrollAttemptsBeforeChange;
    if (_$data.containsKey('scrollAttemptsBeforeChange') !=
        other._$data.containsKey('scrollAttemptsBeforeChange')) {
      return false;
    }
    if (l$scrollAttemptsBeforeChange != lOther$scrollAttemptsBeforeChange) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$slideshowDelay = slideshowDelay;
    final l$displayMode = displayMode;
    final l$scaleUp = scaleUp;
    final l$resetZoomOnNav = resetZoomOnNav;
    final l$scrollMode = scrollMode;
    final l$scrollAttemptsBeforeChange = scrollAttemptsBeforeChange;
    return Object.hashAll([
      _$data.containsKey('slideshowDelay') ? l$slideshowDelay : const {},
      _$data.containsKey('displayMode') ? l$displayMode : const {},
      _$data.containsKey('scaleUp') ? l$scaleUp : const {},
      _$data.containsKey('resetZoomOnNav') ? l$resetZoomOnNav : const {},
      _$data.containsKey('scrollMode') ? l$scrollMode : const {},
      _$data.containsKey('scrollAttemptsBeforeChange')
          ? l$scrollAttemptsBeforeChange
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$ConfigImageLightboxInput<TRes> {
  factory CopyWith$Input$ConfigImageLightboxInput(
    Input$ConfigImageLightboxInput instance,
    TRes Function(Input$ConfigImageLightboxInput) then,
  ) = _CopyWithImpl$Input$ConfigImageLightboxInput;

  factory CopyWith$Input$ConfigImageLightboxInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfigImageLightboxInput;

  TRes call({
    int? slideshowDelay,
    Enum$ImageLightboxDisplayMode? displayMode,
    bool? scaleUp,
    bool? resetZoomOnNav,
    Enum$ImageLightboxScrollMode? scrollMode,
    int? scrollAttemptsBeforeChange,
  });
}

class _CopyWithImpl$Input$ConfigImageLightboxInput<TRes>
    implements CopyWith$Input$ConfigImageLightboxInput<TRes> {
  _CopyWithImpl$Input$ConfigImageLightboxInput(
    this._instance,
    this._then,
  );

  final Input$ConfigImageLightboxInput _instance;

  final TRes Function(Input$ConfigImageLightboxInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? slideshowDelay = _undefined,
    Object? displayMode = _undefined,
    Object? scaleUp = _undefined,
    Object? resetZoomOnNav = _undefined,
    Object? scrollMode = _undefined,
    Object? scrollAttemptsBeforeChange = _undefined,
  }) =>
      _then(Input$ConfigImageLightboxInput._({
        ..._instance._$data,
        if (slideshowDelay != _undefined)
          'slideshowDelay': (slideshowDelay as int?),
        if (displayMode != _undefined)
          'displayMode': (displayMode as Enum$ImageLightboxDisplayMode?),
        if (scaleUp != _undefined) 'scaleUp': (scaleUp as bool?),
        if (resetZoomOnNav != _undefined)
          'resetZoomOnNav': (resetZoomOnNav as bool?),
        if (scrollMode != _undefined)
          'scrollMode': (scrollMode as Enum$ImageLightboxScrollMode?),
        if (scrollAttemptsBeforeChange != _undefined)
          'scrollAttemptsBeforeChange': (scrollAttemptsBeforeChange as int?),
      }));
}

class _CopyWithStubImpl$Input$ConfigImageLightboxInput<TRes>
    implements CopyWith$Input$ConfigImageLightboxInput<TRes> {
  _CopyWithStubImpl$Input$ConfigImageLightboxInput(this._res);

  TRes _res;

  call({
    int? slideshowDelay,
    Enum$ImageLightboxDisplayMode? displayMode,
    bool? scaleUp,
    bool? resetZoomOnNav,
    Enum$ImageLightboxScrollMode? scrollMode,
    int? scrollAttemptsBeforeChange,
  }) =>
      _res;
}

class Input$ConfigInterfaceInput {
  factory Input$ConfigInterfaceInput({
    List<String>? menuItems,
    bool? soundOnPreview,
    bool? wallShowTitle,
    String? wallPlayback,
    bool? showScrubber,
    int? maximumLoopDuration,
    bool? autostartVideo,
    bool? autostartVideoOnPlaySelected,
    bool? continuePlaylistDefault,
    bool? showStudioAsText,
    String? css,
    bool? cssEnabled,
    String? javascript,
    bool? javascriptEnabled,
    String? customLocales,
    bool? customLocalesEnabled,
    String? language,
    Input$ConfigImageLightboxInput? imageLightbox,
    Input$ConfigDisableDropdownCreateInput? disableDropdownCreate,
    String? handyKey,
    int? funscriptOffset,
    bool? useStashHostedFunscript,
    bool? noBrowser,
    bool? notificationsEnabled,
  }) =>
      Input$ConfigInterfaceInput._({
        if (menuItems != null) r'menuItems': menuItems,
        if (soundOnPreview != null) r'soundOnPreview': soundOnPreview,
        if (wallShowTitle != null) r'wallShowTitle': wallShowTitle,
        if (wallPlayback != null) r'wallPlayback': wallPlayback,
        if (showScrubber != null) r'showScrubber': showScrubber,
        if (maximumLoopDuration != null)
          r'maximumLoopDuration': maximumLoopDuration,
        if (autostartVideo != null) r'autostartVideo': autostartVideo,
        if (autostartVideoOnPlaySelected != null)
          r'autostartVideoOnPlaySelected': autostartVideoOnPlaySelected,
        if (continuePlaylistDefault != null)
          r'continuePlaylistDefault': continuePlaylistDefault,
        if (showStudioAsText != null) r'showStudioAsText': showStudioAsText,
        if (css != null) r'css': css,
        if (cssEnabled != null) r'cssEnabled': cssEnabled,
        if (javascript != null) r'javascript': javascript,
        if (javascriptEnabled != null) r'javascriptEnabled': javascriptEnabled,
        if (customLocales != null) r'customLocales': customLocales,
        if (customLocalesEnabled != null)
          r'customLocalesEnabled': customLocalesEnabled,
        if (language != null) r'language': language,
        if (imageLightbox != null) r'imageLightbox': imageLightbox,
        if (disableDropdownCreate != null)
          r'disableDropdownCreate': disableDropdownCreate,
        if (handyKey != null) r'handyKey': handyKey,
        if (funscriptOffset != null) r'funscriptOffset': funscriptOffset,
        if (useStashHostedFunscript != null)
          r'useStashHostedFunscript': useStashHostedFunscript,
        if (noBrowser != null) r'noBrowser': noBrowser,
        if (notificationsEnabled != null)
          r'notificationsEnabled': notificationsEnabled,
      });

  Input$ConfigInterfaceInput._(this._$data);

  factory Input$ConfigInterfaceInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('menuItems')) {
      final l$menuItems = data['menuItems'];
      result$data['menuItems'] =
          (l$menuItems as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('soundOnPreview')) {
      final l$soundOnPreview = data['soundOnPreview'];
      result$data['soundOnPreview'] = (l$soundOnPreview as bool?);
    }
    if (data.containsKey('wallShowTitle')) {
      final l$wallShowTitle = data['wallShowTitle'];
      result$data['wallShowTitle'] = (l$wallShowTitle as bool?);
    }
    if (data.containsKey('wallPlayback')) {
      final l$wallPlayback = data['wallPlayback'];
      result$data['wallPlayback'] = (l$wallPlayback as String?);
    }
    if (data.containsKey('showScrubber')) {
      final l$showScrubber = data['showScrubber'];
      result$data['showScrubber'] = (l$showScrubber as bool?);
    }
    if (data.containsKey('maximumLoopDuration')) {
      final l$maximumLoopDuration = data['maximumLoopDuration'];
      result$data['maximumLoopDuration'] = (l$maximumLoopDuration as int?);
    }
    if (data.containsKey('autostartVideo')) {
      final l$autostartVideo = data['autostartVideo'];
      result$data['autostartVideo'] = (l$autostartVideo as bool?);
    }
    if (data.containsKey('autostartVideoOnPlaySelected')) {
      final l$autostartVideoOnPlaySelected =
          data['autostartVideoOnPlaySelected'];
      result$data['autostartVideoOnPlaySelected'] =
          (l$autostartVideoOnPlaySelected as bool?);
    }
    if (data.containsKey('continuePlaylistDefault')) {
      final l$continuePlaylistDefault = data['continuePlaylistDefault'];
      result$data['continuePlaylistDefault'] =
          (l$continuePlaylistDefault as bool?);
    }
    if (data.containsKey('showStudioAsText')) {
      final l$showStudioAsText = data['showStudioAsText'];
      result$data['showStudioAsText'] = (l$showStudioAsText as bool?);
    }
    if (data.containsKey('css')) {
      final l$css = data['css'];
      result$data['css'] = (l$css as String?);
    }
    if (data.containsKey('cssEnabled')) {
      final l$cssEnabled = data['cssEnabled'];
      result$data['cssEnabled'] = (l$cssEnabled as bool?);
    }
    if (data.containsKey('javascript')) {
      final l$javascript = data['javascript'];
      result$data['javascript'] = (l$javascript as String?);
    }
    if (data.containsKey('javascriptEnabled')) {
      final l$javascriptEnabled = data['javascriptEnabled'];
      result$data['javascriptEnabled'] = (l$javascriptEnabled as bool?);
    }
    if (data.containsKey('customLocales')) {
      final l$customLocales = data['customLocales'];
      result$data['customLocales'] = (l$customLocales as String?);
    }
    if (data.containsKey('customLocalesEnabled')) {
      final l$customLocalesEnabled = data['customLocalesEnabled'];
      result$data['customLocalesEnabled'] = (l$customLocalesEnabled as bool?);
    }
    if (data.containsKey('language')) {
      final l$language = data['language'];
      result$data['language'] = (l$language as String?);
    }
    if (data.containsKey('imageLightbox')) {
      final l$imageLightbox = data['imageLightbox'];
      result$data['imageLightbox'] = l$imageLightbox == null
          ? null
          : Input$ConfigImageLightboxInput.fromJson(
              (l$imageLightbox as Map<String, dynamic>));
    }
    if (data.containsKey('disableDropdownCreate')) {
      final l$disableDropdownCreate = data['disableDropdownCreate'];
      result$data['disableDropdownCreate'] = l$disableDropdownCreate == null
          ? null
          : Input$ConfigDisableDropdownCreateInput.fromJson(
              (l$disableDropdownCreate as Map<String, dynamic>));
    }
    if (data.containsKey('handyKey')) {
      final l$handyKey = data['handyKey'];
      result$data['handyKey'] = (l$handyKey as String?);
    }
    if (data.containsKey('funscriptOffset')) {
      final l$funscriptOffset = data['funscriptOffset'];
      result$data['funscriptOffset'] = (l$funscriptOffset as int?);
    }
    if (data.containsKey('useStashHostedFunscript')) {
      final l$useStashHostedFunscript = data['useStashHostedFunscript'];
      result$data['useStashHostedFunscript'] =
          (l$useStashHostedFunscript as bool?);
    }
    if (data.containsKey('noBrowser')) {
      final l$noBrowser = data['noBrowser'];
      result$data['noBrowser'] = (l$noBrowser as bool?);
    }
    if (data.containsKey('notificationsEnabled')) {
      final l$notificationsEnabled = data['notificationsEnabled'];
      result$data['notificationsEnabled'] = (l$notificationsEnabled as bool?);
    }
    return Input$ConfigInterfaceInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get menuItems => (_$data['menuItems'] as List<String>?);

  bool? get soundOnPreview => (_$data['soundOnPreview'] as bool?);

  bool? get wallShowTitle => (_$data['wallShowTitle'] as bool?);

  String? get wallPlayback => (_$data['wallPlayback'] as String?);

  bool? get showScrubber => (_$data['showScrubber'] as bool?);

  int? get maximumLoopDuration => (_$data['maximumLoopDuration'] as int?);

  bool? get autostartVideo => (_$data['autostartVideo'] as bool?);

  bool? get autostartVideoOnPlaySelected =>
      (_$data['autostartVideoOnPlaySelected'] as bool?);

  bool? get continuePlaylistDefault =>
      (_$data['continuePlaylistDefault'] as bool?);

  bool? get showStudioAsText => (_$data['showStudioAsText'] as bool?);

  String? get css => (_$data['css'] as String?);

  bool? get cssEnabled => (_$data['cssEnabled'] as bool?);

  String? get javascript => (_$data['javascript'] as String?);

  bool? get javascriptEnabled => (_$data['javascriptEnabled'] as bool?);

  String? get customLocales => (_$data['customLocales'] as String?);

  bool? get customLocalesEnabled => (_$data['customLocalesEnabled'] as bool?);

  String? get language => (_$data['language'] as String?);

  Input$ConfigImageLightboxInput? get imageLightbox =>
      (_$data['imageLightbox'] as Input$ConfigImageLightboxInput?);

  Input$ConfigDisableDropdownCreateInput? get disableDropdownCreate =>
      (_$data['disableDropdownCreate']
          as Input$ConfigDisableDropdownCreateInput?);

  String? get handyKey => (_$data['handyKey'] as String?);

  int? get funscriptOffset => (_$data['funscriptOffset'] as int?);

  bool? get useStashHostedFunscript =>
      (_$data['useStashHostedFunscript'] as bool?);

  bool? get noBrowser => (_$data['noBrowser'] as bool?);

  bool? get notificationsEnabled => (_$data['notificationsEnabled'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('menuItems')) {
      final l$menuItems = menuItems;
      result$data['menuItems'] = l$menuItems?.map((e) => e).toList();
    }
    if (_$data.containsKey('soundOnPreview')) {
      final l$soundOnPreview = soundOnPreview;
      result$data['soundOnPreview'] = l$soundOnPreview;
    }
    if (_$data.containsKey('wallShowTitle')) {
      final l$wallShowTitle = wallShowTitle;
      result$data['wallShowTitle'] = l$wallShowTitle;
    }
    if (_$data.containsKey('wallPlayback')) {
      final l$wallPlayback = wallPlayback;
      result$data['wallPlayback'] = l$wallPlayback;
    }
    if (_$data.containsKey('showScrubber')) {
      final l$showScrubber = showScrubber;
      result$data['showScrubber'] = l$showScrubber;
    }
    if (_$data.containsKey('maximumLoopDuration')) {
      final l$maximumLoopDuration = maximumLoopDuration;
      result$data['maximumLoopDuration'] = l$maximumLoopDuration;
    }
    if (_$data.containsKey('autostartVideo')) {
      final l$autostartVideo = autostartVideo;
      result$data['autostartVideo'] = l$autostartVideo;
    }
    if (_$data.containsKey('autostartVideoOnPlaySelected')) {
      final l$autostartVideoOnPlaySelected = autostartVideoOnPlaySelected;
      result$data['autostartVideoOnPlaySelected'] =
          l$autostartVideoOnPlaySelected;
    }
    if (_$data.containsKey('continuePlaylistDefault')) {
      final l$continuePlaylistDefault = continuePlaylistDefault;
      result$data['continuePlaylistDefault'] = l$continuePlaylistDefault;
    }
    if (_$data.containsKey('showStudioAsText')) {
      final l$showStudioAsText = showStudioAsText;
      result$data['showStudioAsText'] = l$showStudioAsText;
    }
    if (_$data.containsKey('css')) {
      final l$css = css;
      result$data['css'] = l$css;
    }
    if (_$data.containsKey('cssEnabled')) {
      final l$cssEnabled = cssEnabled;
      result$data['cssEnabled'] = l$cssEnabled;
    }
    if (_$data.containsKey('javascript')) {
      final l$javascript = javascript;
      result$data['javascript'] = l$javascript;
    }
    if (_$data.containsKey('javascriptEnabled')) {
      final l$javascriptEnabled = javascriptEnabled;
      result$data['javascriptEnabled'] = l$javascriptEnabled;
    }
    if (_$data.containsKey('customLocales')) {
      final l$customLocales = customLocales;
      result$data['customLocales'] = l$customLocales;
    }
    if (_$data.containsKey('customLocalesEnabled')) {
      final l$customLocalesEnabled = customLocalesEnabled;
      result$data['customLocalesEnabled'] = l$customLocalesEnabled;
    }
    if (_$data.containsKey('language')) {
      final l$language = language;
      result$data['language'] = l$language;
    }
    if (_$data.containsKey('imageLightbox')) {
      final l$imageLightbox = imageLightbox;
      result$data['imageLightbox'] = l$imageLightbox?.toJson();
    }
    if (_$data.containsKey('disableDropdownCreate')) {
      final l$disableDropdownCreate = disableDropdownCreate;
      result$data['disableDropdownCreate'] = l$disableDropdownCreate?.toJson();
    }
    if (_$data.containsKey('handyKey')) {
      final l$handyKey = handyKey;
      result$data['handyKey'] = l$handyKey;
    }
    if (_$data.containsKey('funscriptOffset')) {
      final l$funscriptOffset = funscriptOffset;
      result$data['funscriptOffset'] = l$funscriptOffset;
    }
    if (_$data.containsKey('useStashHostedFunscript')) {
      final l$useStashHostedFunscript = useStashHostedFunscript;
      result$data['useStashHostedFunscript'] = l$useStashHostedFunscript;
    }
    if (_$data.containsKey('noBrowser')) {
      final l$noBrowser = noBrowser;
      result$data['noBrowser'] = l$noBrowser;
    }
    if (_$data.containsKey('notificationsEnabled')) {
      final l$notificationsEnabled = notificationsEnabled;
      result$data['notificationsEnabled'] = l$notificationsEnabled;
    }
    return result$data;
  }

  CopyWith$Input$ConfigInterfaceInput<Input$ConfigInterfaceInput>
      get copyWith => CopyWith$Input$ConfigInterfaceInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ConfigInterfaceInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$menuItems = menuItems;
    final lOther$menuItems = other.menuItems;
    if (_$data.containsKey('menuItems') !=
        other._$data.containsKey('menuItems')) {
      return false;
    }
    if (l$menuItems != null && lOther$menuItems != null) {
      if (l$menuItems.length != lOther$menuItems.length) {
        return false;
      }
      for (int i = 0; i < l$menuItems.length; i++) {
        final l$menuItems$entry = l$menuItems[i];
        final lOther$menuItems$entry = lOther$menuItems[i];
        if (l$menuItems$entry != lOther$menuItems$entry) {
          return false;
        }
      }
    } else if (l$menuItems != lOther$menuItems) {
      return false;
    }
    final l$soundOnPreview = soundOnPreview;
    final lOther$soundOnPreview = other.soundOnPreview;
    if (_$data.containsKey('soundOnPreview') !=
        other._$data.containsKey('soundOnPreview')) {
      return false;
    }
    if (l$soundOnPreview != lOther$soundOnPreview) {
      return false;
    }
    final l$wallShowTitle = wallShowTitle;
    final lOther$wallShowTitle = other.wallShowTitle;
    if (_$data.containsKey('wallShowTitle') !=
        other._$data.containsKey('wallShowTitle')) {
      return false;
    }
    if (l$wallShowTitle != lOther$wallShowTitle) {
      return false;
    }
    final l$wallPlayback = wallPlayback;
    final lOther$wallPlayback = other.wallPlayback;
    if (_$data.containsKey('wallPlayback') !=
        other._$data.containsKey('wallPlayback')) {
      return false;
    }
    if (l$wallPlayback != lOther$wallPlayback) {
      return false;
    }
    final l$showScrubber = showScrubber;
    final lOther$showScrubber = other.showScrubber;
    if (_$data.containsKey('showScrubber') !=
        other._$data.containsKey('showScrubber')) {
      return false;
    }
    if (l$showScrubber != lOther$showScrubber) {
      return false;
    }
    final l$maximumLoopDuration = maximumLoopDuration;
    final lOther$maximumLoopDuration = other.maximumLoopDuration;
    if (_$data.containsKey('maximumLoopDuration') !=
        other._$data.containsKey('maximumLoopDuration')) {
      return false;
    }
    if (l$maximumLoopDuration != lOther$maximumLoopDuration) {
      return false;
    }
    final l$autostartVideo = autostartVideo;
    final lOther$autostartVideo = other.autostartVideo;
    if (_$data.containsKey('autostartVideo') !=
        other._$data.containsKey('autostartVideo')) {
      return false;
    }
    if (l$autostartVideo != lOther$autostartVideo) {
      return false;
    }
    final l$autostartVideoOnPlaySelected = autostartVideoOnPlaySelected;
    final lOther$autostartVideoOnPlaySelected =
        other.autostartVideoOnPlaySelected;
    if (_$data.containsKey('autostartVideoOnPlaySelected') !=
        other._$data.containsKey('autostartVideoOnPlaySelected')) {
      return false;
    }
    if (l$autostartVideoOnPlaySelected != lOther$autostartVideoOnPlaySelected) {
      return false;
    }
    final l$continuePlaylistDefault = continuePlaylistDefault;
    final lOther$continuePlaylistDefault = other.continuePlaylistDefault;
    if (_$data.containsKey('continuePlaylistDefault') !=
        other._$data.containsKey('continuePlaylistDefault')) {
      return false;
    }
    if (l$continuePlaylistDefault != lOther$continuePlaylistDefault) {
      return false;
    }
    final l$showStudioAsText = showStudioAsText;
    final lOther$showStudioAsText = other.showStudioAsText;
    if (_$data.containsKey('showStudioAsText') !=
        other._$data.containsKey('showStudioAsText')) {
      return false;
    }
    if (l$showStudioAsText != lOther$showStudioAsText) {
      return false;
    }
    final l$css = css;
    final lOther$css = other.css;
    if (_$data.containsKey('css') != other._$data.containsKey('css')) {
      return false;
    }
    if (l$css != lOther$css) {
      return false;
    }
    final l$cssEnabled = cssEnabled;
    final lOther$cssEnabled = other.cssEnabled;
    if (_$data.containsKey('cssEnabled') !=
        other._$data.containsKey('cssEnabled')) {
      return false;
    }
    if (l$cssEnabled != lOther$cssEnabled) {
      return false;
    }
    final l$javascript = javascript;
    final lOther$javascript = other.javascript;
    if (_$data.containsKey('javascript') !=
        other._$data.containsKey('javascript')) {
      return false;
    }
    if (l$javascript != lOther$javascript) {
      return false;
    }
    final l$javascriptEnabled = javascriptEnabled;
    final lOther$javascriptEnabled = other.javascriptEnabled;
    if (_$data.containsKey('javascriptEnabled') !=
        other._$data.containsKey('javascriptEnabled')) {
      return false;
    }
    if (l$javascriptEnabled != lOther$javascriptEnabled) {
      return false;
    }
    final l$customLocales = customLocales;
    final lOther$customLocales = other.customLocales;
    if (_$data.containsKey('customLocales') !=
        other._$data.containsKey('customLocales')) {
      return false;
    }
    if (l$customLocales != lOther$customLocales) {
      return false;
    }
    final l$customLocalesEnabled = customLocalesEnabled;
    final lOther$customLocalesEnabled = other.customLocalesEnabled;
    if (_$data.containsKey('customLocalesEnabled') !=
        other._$data.containsKey('customLocalesEnabled')) {
      return false;
    }
    if (l$customLocalesEnabled != lOther$customLocalesEnabled) {
      return false;
    }
    final l$language = language;
    final lOther$language = other.language;
    if (_$data.containsKey('language') !=
        other._$data.containsKey('language')) {
      return false;
    }
    if (l$language != lOther$language) {
      return false;
    }
    final l$imageLightbox = imageLightbox;
    final lOther$imageLightbox = other.imageLightbox;
    if (_$data.containsKey('imageLightbox') !=
        other._$data.containsKey('imageLightbox')) {
      return false;
    }
    if (l$imageLightbox != lOther$imageLightbox) {
      return false;
    }
    final l$disableDropdownCreate = disableDropdownCreate;
    final lOther$disableDropdownCreate = other.disableDropdownCreate;
    if (_$data.containsKey('disableDropdownCreate') !=
        other._$data.containsKey('disableDropdownCreate')) {
      return false;
    }
    if (l$disableDropdownCreate != lOther$disableDropdownCreate) {
      return false;
    }
    final l$handyKey = handyKey;
    final lOther$handyKey = other.handyKey;
    if (_$data.containsKey('handyKey') !=
        other._$data.containsKey('handyKey')) {
      return false;
    }
    if (l$handyKey != lOther$handyKey) {
      return false;
    }
    final l$funscriptOffset = funscriptOffset;
    final lOther$funscriptOffset = other.funscriptOffset;
    if (_$data.containsKey('funscriptOffset') !=
        other._$data.containsKey('funscriptOffset')) {
      return false;
    }
    if (l$funscriptOffset != lOther$funscriptOffset) {
      return false;
    }
    final l$useStashHostedFunscript = useStashHostedFunscript;
    final lOther$useStashHostedFunscript = other.useStashHostedFunscript;
    if (_$data.containsKey('useStashHostedFunscript') !=
        other._$data.containsKey('useStashHostedFunscript')) {
      return false;
    }
    if (l$useStashHostedFunscript != lOther$useStashHostedFunscript) {
      return false;
    }
    final l$noBrowser = noBrowser;
    final lOther$noBrowser = other.noBrowser;
    if (_$data.containsKey('noBrowser') !=
        other._$data.containsKey('noBrowser')) {
      return false;
    }
    if (l$noBrowser != lOther$noBrowser) {
      return false;
    }
    final l$notificationsEnabled = notificationsEnabled;
    final lOther$notificationsEnabled = other.notificationsEnabled;
    if (_$data.containsKey('notificationsEnabled') !=
        other._$data.containsKey('notificationsEnabled')) {
      return false;
    }
    if (l$notificationsEnabled != lOther$notificationsEnabled) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$menuItems = menuItems;
    final l$soundOnPreview = soundOnPreview;
    final l$wallShowTitle = wallShowTitle;
    final l$wallPlayback = wallPlayback;
    final l$showScrubber = showScrubber;
    final l$maximumLoopDuration = maximumLoopDuration;
    final l$autostartVideo = autostartVideo;
    final l$autostartVideoOnPlaySelected = autostartVideoOnPlaySelected;
    final l$continuePlaylistDefault = continuePlaylistDefault;
    final l$showStudioAsText = showStudioAsText;
    final l$css = css;
    final l$cssEnabled = cssEnabled;
    final l$javascript = javascript;
    final l$javascriptEnabled = javascriptEnabled;
    final l$customLocales = customLocales;
    final l$customLocalesEnabled = customLocalesEnabled;
    final l$language = language;
    final l$imageLightbox = imageLightbox;
    final l$disableDropdownCreate = disableDropdownCreate;
    final l$handyKey = handyKey;
    final l$funscriptOffset = funscriptOffset;
    final l$useStashHostedFunscript = useStashHostedFunscript;
    final l$noBrowser = noBrowser;
    final l$notificationsEnabled = notificationsEnabled;
    return Object.hashAll([
      _$data.containsKey('menuItems')
          ? l$menuItems == null
              ? null
              : Object.hashAll(l$menuItems.map((v) => v))
          : const {},
      _$data.containsKey('soundOnPreview') ? l$soundOnPreview : const {},
      _$data.containsKey('wallShowTitle') ? l$wallShowTitle : const {},
      _$data.containsKey('wallPlayback') ? l$wallPlayback : const {},
      _$data.containsKey('showScrubber') ? l$showScrubber : const {},
      _$data.containsKey('maximumLoopDuration')
          ? l$maximumLoopDuration
          : const {},
      _$data.containsKey('autostartVideo') ? l$autostartVideo : const {},
      _$data.containsKey('autostartVideoOnPlaySelected')
          ? l$autostartVideoOnPlaySelected
          : const {},
      _$data.containsKey('continuePlaylistDefault')
          ? l$continuePlaylistDefault
          : const {},
      _$data.containsKey('showStudioAsText') ? l$showStudioAsText : const {},
      _$data.containsKey('css') ? l$css : const {},
      _$data.containsKey('cssEnabled') ? l$cssEnabled : const {},
      _$data.containsKey('javascript') ? l$javascript : const {},
      _$data.containsKey('javascriptEnabled') ? l$javascriptEnabled : const {},
      _$data.containsKey('customLocales') ? l$customLocales : const {},
      _$data.containsKey('customLocalesEnabled')
          ? l$customLocalesEnabled
          : const {},
      _$data.containsKey('language') ? l$language : const {},
      _$data.containsKey('imageLightbox') ? l$imageLightbox : const {},
      _$data.containsKey('disableDropdownCreate')
          ? l$disableDropdownCreate
          : const {},
      _$data.containsKey('handyKey') ? l$handyKey : const {},
      _$data.containsKey('funscriptOffset') ? l$funscriptOffset : const {},
      _$data.containsKey('useStashHostedFunscript')
          ? l$useStashHostedFunscript
          : const {},
      _$data.containsKey('noBrowser') ? l$noBrowser : const {},
      _$data.containsKey('notificationsEnabled')
          ? l$notificationsEnabled
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$ConfigInterfaceInput<TRes> {
  factory CopyWith$Input$ConfigInterfaceInput(
    Input$ConfigInterfaceInput instance,
    TRes Function(Input$ConfigInterfaceInput) then,
  ) = _CopyWithImpl$Input$ConfigInterfaceInput;

  factory CopyWith$Input$ConfigInterfaceInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfigInterfaceInput;

  TRes call({
    List<String>? menuItems,
    bool? soundOnPreview,
    bool? wallShowTitle,
    String? wallPlayback,
    bool? showScrubber,
    int? maximumLoopDuration,
    bool? autostartVideo,
    bool? autostartVideoOnPlaySelected,
    bool? continuePlaylistDefault,
    bool? showStudioAsText,
    String? css,
    bool? cssEnabled,
    String? javascript,
    bool? javascriptEnabled,
    String? customLocales,
    bool? customLocalesEnabled,
    String? language,
    Input$ConfigImageLightboxInput? imageLightbox,
    Input$ConfigDisableDropdownCreateInput? disableDropdownCreate,
    String? handyKey,
    int? funscriptOffset,
    bool? useStashHostedFunscript,
    bool? noBrowser,
    bool? notificationsEnabled,
  });
  CopyWith$Input$ConfigImageLightboxInput<TRes> get imageLightbox;
  CopyWith$Input$ConfigDisableDropdownCreateInput<TRes>
      get disableDropdownCreate;
}

class _CopyWithImpl$Input$ConfigInterfaceInput<TRes>
    implements CopyWith$Input$ConfigInterfaceInput<TRes> {
  _CopyWithImpl$Input$ConfigInterfaceInput(
    this._instance,
    this._then,
  );

  final Input$ConfigInterfaceInput _instance;

  final TRes Function(Input$ConfigInterfaceInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? menuItems = _undefined,
    Object? soundOnPreview = _undefined,
    Object? wallShowTitle = _undefined,
    Object? wallPlayback = _undefined,
    Object? showScrubber = _undefined,
    Object? maximumLoopDuration = _undefined,
    Object? autostartVideo = _undefined,
    Object? autostartVideoOnPlaySelected = _undefined,
    Object? continuePlaylistDefault = _undefined,
    Object? showStudioAsText = _undefined,
    Object? css = _undefined,
    Object? cssEnabled = _undefined,
    Object? javascript = _undefined,
    Object? javascriptEnabled = _undefined,
    Object? customLocales = _undefined,
    Object? customLocalesEnabled = _undefined,
    Object? language = _undefined,
    Object? imageLightbox = _undefined,
    Object? disableDropdownCreate = _undefined,
    Object? handyKey = _undefined,
    Object? funscriptOffset = _undefined,
    Object? useStashHostedFunscript = _undefined,
    Object? noBrowser = _undefined,
    Object? notificationsEnabled = _undefined,
  }) =>
      _then(Input$ConfigInterfaceInput._({
        ..._instance._$data,
        if (menuItems != _undefined) 'menuItems': (menuItems as List<String>?),
        if (soundOnPreview != _undefined)
          'soundOnPreview': (soundOnPreview as bool?),
        if (wallShowTitle != _undefined)
          'wallShowTitle': (wallShowTitle as bool?),
        if (wallPlayback != _undefined)
          'wallPlayback': (wallPlayback as String?),
        if (showScrubber != _undefined) 'showScrubber': (showScrubber as bool?),
        if (maximumLoopDuration != _undefined)
          'maximumLoopDuration': (maximumLoopDuration as int?),
        if (autostartVideo != _undefined)
          'autostartVideo': (autostartVideo as bool?),
        if (autostartVideoOnPlaySelected != _undefined)
          'autostartVideoOnPlaySelected':
              (autostartVideoOnPlaySelected as bool?),
        if (continuePlaylistDefault != _undefined)
          'continuePlaylistDefault': (continuePlaylistDefault as bool?),
        if (showStudioAsText != _undefined)
          'showStudioAsText': (showStudioAsText as bool?),
        if (css != _undefined) 'css': (css as String?),
        if (cssEnabled != _undefined) 'cssEnabled': (cssEnabled as bool?),
        if (javascript != _undefined) 'javascript': (javascript as String?),
        if (javascriptEnabled != _undefined)
          'javascriptEnabled': (javascriptEnabled as bool?),
        if (customLocales != _undefined)
          'customLocales': (customLocales as String?),
        if (customLocalesEnabled != _undefined)
          'customLocalesEnabled': (customLocalesEnabled as bool?),
        if (language != _undefined) 'language': (language as String?),
        if (imageLightbox != _undefined)
          'imageLightbox': (imageLightbox as Input$ConfigImageLightboxInput?),
        if (disableDropdownCreate != _undefined)
          'disableDropdownCreate': (disableDropdownCreate
              as Input$ConfigDisableDropdownCreateInput?),
        if (handyKey != _undefined) 'handyKey': (handyKey as String?),
        if (funscriptOffset != _undefined)
          'funscriptOffset': (funscriptOffset as int?),
        if (useStashHostedFunscript != _undefined)
          'useStashHostedFunscript': (useStashHostedFunscript as bool?),
        if (noBrowser != _undefined) 'noBrowser': (noBrowser as bool?),
        if (notificationsEnabled != _undefined)
          'notificationsEnabled': (notificationsEnabled as bool?),
      }));

  CopyWith$Input$ConfigImageLightboxInput<TRes> get imageLightbox {
    final local$imageLightbox = _instance.imageLightbox;
    return local$imageLightbox == null
        ? CopyWith$Input$ConfigImageLightboxInput.stub(_then(_instance))
        : CopyWith$Input$ConfigImageLightboxInput(
            local$imageLightbox, (e) => call(imageLightbox: e));
  }

  CopyWith$Input$ConfigDisableDropdownCreateInput<TRes>
      get disableDropdownCreate {
    final local$disableDropdownCreate = _instance.disableDropdownCreate;
    return local$disableDropdownCreate == null
        ? CopyWith$Input$ConfigDisableDropdownCreateInput.stub(_then(_instance))
        : CopyWith$Input$ConfigDisableDropdownCreateInput(
            local$disableDropdownCreate, (e) => call(disableDropdownCreate: e));
  }
}

class _CopyWithStubImpl$Input$ConfigInterfaceInput<TRes>
    implements CopyWith$Input$ConfigInterfaceInput<TRes> {
  _CopyWithStubImpl$Input$ConfigInterfaceInput(this._res);

  TRes _res;

  call({
    List<String>? menuItems,
    bool? soundOnPreview,
    bool? wallShowTitle,
    String? wallPlayback,
    bool? showScrubber,
    int? maximumLoopDuration,
    bool? autostartVideo,
    bool? autostartVideoOnPlaySelected,
    bool? continuePlaylistDefault,
    bool? showStudioAsText,
    String? css,
    bool? cssEnabled,
    String? javascript,
    bool? javascriptEnabled,
    String? customLocales,
    bool? customLocalesEnabled,
    String? language,
    Input$ConfigImageLightboxInput? imageLightbox,
    Input$ConfigDisableDropdownCreateInput? disableDropdownCreate,
    String? handyKey,
    int? funscriptOffset,
    bool? useStashHostedFunscript,
    bool? noBrowser,
    bool? notificationsEnabled,
  }) =>
      _res;

  CopyWith$Input$ConfigImageLightboxInput<TRes> get imageLightbox =>
      CopyWith$Input$ConfigImageLightboxInput.stub(_res);

  CopyWith$Input$ConfigDisableDropdownCreateInput<TRes>
      get disableDropdownCreate =>
          CopyWith$Input$ConfigDisableDropdownCreateInput.stub(_res);
}

class Input$ConfigDLNAInput {
  factory Input$ConfigDLNAInput({
    String? serverName,
    bool? enabled,
    int? port,
    List<String>? whitelistedIPs,
    List<String>? interfaces,
    String? videoSortOrder,
  }) =>
      Input$ConfigDLNAInput._({
        if (serverName != null) r'serverName': serverName,
        if (enabled != null) r'enabled': enabled,
        if (port != null) r'port': port,
        if (whitelistedIPs != null) r'whitelistedIPs': whitelistedIPs,
        if (interfaces != null) r'interfaces': interfaces,
        if (videoSortOrder != null) r'videoSortOrder': videoSortOrder,
      });

  Input$ConfigDLNAInput._(this._$data);

  factory Input$ConfigDLNAInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('serverName')) {
      final l$serverName = data['serverName'];
      result$data['serverName'] = (l$serverName as String?);
    }
    if (data.containsKey('enabled')) {
      final l$enabled = data['enabled'];
      result$data['enabled'] = (l$enabled as bool?);
    }
    if (data.containsKey('port')) {
      final l$port = data['port'];
      result$data['port'] = (l$port as int?);
    }
    if (data.containsKey('whitelistedIPs')) {
      final l$whitelistedIPs = data['whitelistedIPs'];
      result$data['whitelistedIPs'] = (l$whitelistedIPs as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('interfaces')) {
      final l$interfaces = data['interfaces'];
      result$data['interfaces'] =
          (l$interfaces as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('videoSortOrder')) {
      final l$videoSortOrder = data['videoSortOrder'];
      result$data['videoSortOrder'] = (l$videoSortOrder as String?);
    }
    return Input$ConfigDLNAInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get serverName => (_$data['serverName'] as String?);

  bool? get enabled => (_$data['enabled'] as bool?);

  int? get port => (_$data['port'] as int?);

  List<String>? get whitelistedIPs =>
      (_$data['whitelistedIPs'] as List<String>?);

  List<String>? get interfaces => (_$data['interfaces'] as List<String>?);

  String? get videoSortOrder => (_$data['videoSortOrder'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('serverName')) {
      final l$serverName = serverName;
      result$data['serverName'] = l$serverName;
    }
    if (_$data.containsKey('enabled')) {
      final l$enabled = enabled;
      result$data['enabled'] = l$enabled;
    }
    if (_$data.containsKey('port')) {
      final l$port = port;
      result$data['port'] = l$port;
    }
    if (_$data.containsKey('whitelistedIPs')) {
      final l$whitelistedIPs = whitelistedIPs;
      result$data['whitelistedIPs'] = l$whitelistedIPs?.map((e) => e).toList();
    }
    if (_$data.containsKey('interfaces')) {
      final l$interfaces = interfaces;
      result$data['interfaces'] = l$interfaces?.map((e) => e).toList();
    }
    if (_$data.containsKey('videoSortOrder')) {
      final l$videoSortOrder = videoSortOrder;
      result$data['videoSortOrder'] = l$videoSortOrder;
    }
    return result$data;
  }

  CopyWith$Input$ConfigDLNAInput<Input$ConfigDLNAInput> get copyWith =>
      CopyWith$Input$ConfigDLNAInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ConfigDLNAInput) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$serverName = serverName;
    final lOther$serverName = other.serverName;
    if (_$data.containsKey('serverName') !=
        other._$data.containsKey('serverName')) {
      return false;
    }
    if (l$serverName != lOther$serverName) {
      return false;
    }
    final l$enabled = enabled;
    final lOther$enabled = other.enabled;
    if (_$data.containsKey('enabled') != other._$data.containsKey('enabled')) {
      return false;
    }
    if (l$enabled != lOther$enabled) {
      return false;
    }
    final l$port = port;
    final lOther$port = other.port;
    if (_$data.containsKey('port') != other._$data.containsKey('port')) {
      return false;
    }
    if (l$port != lOther$port) {
      return false;
    }
    final l$whitelistedIPs = whitelistedIPs;
    final lOther$whitelistedIPs = other.whitelistedIPs;
    if (_$data.containsKey('whitelistedIPs') !=
        other._$data.containsKey('whitelistedIPs')) {
      return false;
    }
    if (l$whitelistedIPs != null && lOther$whitelistedIPs != null) {
      if (l$whitelistedIPs.length != lOther$whitelistedIPs.length) {
        return false;
      }
      for (int i = 0; i < l$whitelistedIPs.length; i++) {
        final l$whitelistedIPs$entry = l$whitelistedIPs[i];
        final lOther$whitelistedIPs$entry = lOther$whitelistedIPs[i];
        if (l$whitelistedIPs$entry != lOther$whitelistedIPs$entry) {
          return false;
        }
      }
    } else if (l$whitelistedIPs != lOther$whitelistedIPs) {
      return false;
    }
    final l$interfaces = interfaces;
    final lOther$interfaces = other.interfaces;
    if (_$data.containsKey('interfaces') !=
        other._$data.containsKey('interfaces')) {
      return false;
    }
    if (l$interfaces != null && lOther$interfaces != null) {
      if (l$interfaces.length != lOther$interfaces.length) {
        return false;
      }
      for (int i = 0; i < l$interfaces.length; i++) {
        final l$interfaces$entry = l$interfaces[i];
        final lOther$interfaces$entry = lOther$interfaces[i];
        if (l$interfaces$entry != lOther$interfaces$entry) {
          return false;
        }
      }
    } else if (l$interfaces != lOther$interfaces) {
      return false;
    }
    final l$videoSortOrder = videoSortOrder;
    final lOther$videoSortOrder = other.videoSortOrder;
    if (_$data.containsKey('videoSortOrder') !=
        other._$data.containsKey('videoSortOrder')) {
      return false;
    }
    if (l$videoSortOrder != lOther$videoSortOrder) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$serverName = serverName;
    final l$enabled = enabled;
    final l$port = port;
    final l$whitelistedIPs = whitelistedIPs;
    final l$interfaces = interfaces;
    final l$videoSortOrder = videoSortOrder;
    return Object.hashAll([
      _$data.containsKey('serverName') ? l$serverName : const {},
      _$data.containsKey('enabled') ? l$enabled : const {},
      _$data.containsKey('port') ? l$port : const {},
      _$data.containsKey('whitelistedIPs')
          ? l$whitelistedIPs == null
              ? null
              : Object.hashAll(l$whitelistedIPs.map((v) => v))
          : const {},
      _$data.containsKey('interfaces')
          ? l$interfaces == null
              ? null
              : Object.hashAll(l$interfaces.map((v) => v))
          : const {},
      _$data.containsKey('videoSortOrder') ? l$videoSortOrder : const {},
    ]);
  }
}

abstract class CopyWith$Input$ConfigDLNAInput<TRes> {
  factory CopyWith$Input$ConfigDLNAInput(
    Input$ConfigDLNAInput instance,
    TRes Function(Input$ConfigDLNAInput) then,
  ) = _CopyWithImpl$Input$ConfigDLNAInput;

  factory CopyWith$Input$ConfigDLNAInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfigDLNAInput;

  TRes call({
    String? serverName,
    bool? enabled,
    int? port,
    List<String>? whitelistedIPs,
    List<String>? interfaces,
    String? videoSortOrder,
  });
}

class _CopyWithImpl$Input$ConfigDLNAInput<TRes>
    implements CopyWith$Input$ConfigDLNAInput<TRes> {
  _CopyWithImpl$Input$ConfigDLNAInput(
    this._instance,
    this._then,
  );

  final Input$ConfigDLNAInput _instance;

  final TRes Function(Input$ConfigDLNAInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? serverName = _undefined,
    Object? enabled = _undefined,
    Object? port = _undefined,
    Object? whitelistedIPs = _undefined,
    Object? interfaces = _undefined,
    Object? videoSortOrder = _undefined,
  }) =>
      _then(Input$ConfigDLNAInput._({
        ..._instance._$data,
        if (serverName != _undefined) 'serverName': (serverName as String?),
        if (enabled != _undefined) 'enabled': (enabled as bool?),
        if (port != _undefined) 'port': (port as int?),
        if (whitelistedIPs != _undefined)
          'whitelistedIPs': (whitelistedIPs as List<String>?),
        if (interfaces != _undefined)
          'interfaces': (interfaces as List<String>?),
        if (videoSortOrder != _undefined)
          'videoSortOrder': (videoSortOrder as String?),
      }));
}

class _CopyWithStubImpl$Input$ConfigDLNAInput<TRes>
    implements CopyWith$Input$ConfigDLNAInput<TRes> {
  _CopyWithStubImpl$Input$ConfigDLNAInput(this._res);

  TRes _res;

  call({
    String? serverName,
    bool? enabled,
    int? port,
    List<String>? whitelistedIPs,
    List<String>? interfaces,
    String? videoSortOrder,
  }) =>
      _res;
}

class Input$ConfigScrapingInput {
  factory Input$ConfigScrapingInput({
    String? scraperUserAgent,
    String? scraperCDPPath,
    bool? scraperCertCheck,
    List<String>? excludeTagPatterns,
  }) =>
      Input$ConfigScrapingInput._({
        if (scraperUserAgent != null) r'scraperUserAgent': scraperUserAgent,
        if (scraperCDPPath != null) r'scraperCDPPath': scraperCDPPath,
        if (scraperCertCheck != null) r'scraperCertCheck': scraperCertCheck,
        if (excludeTagPatterns != null)
          r'excludeTagPatterns': excludeTagPatterns,
      });

  Input$ConfigScrapingInput._(this._$data);

  factory Input$ConfigScrapingInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('scraperUserAgent')) {
      final l$scraperUserAgent = data['scraperUserAgent'];
      result$data['scraperUserAgent'] = (l$scraperUserAgent as String?);
    }
    if (data.containsKey('scraperCDPPath')) {
      final l$scraperCDPPath = data['scraperCDPPath'];
      result$data['scraperCDPPath'] = (l$scraperCDPPath as String?);
    }
    if (data.containsKey('scraperCertCheck')) {
      final l$scraperCertCheck = data['scraperCertCheck'];
      result$data['scraperCertCheck'] = (l$scraperCertCheck as bool?);
    }
    if (data.containsKey('excludeTagPatterns')) {
      final l$excludeTagPatterns = data['excludeTagPatterns'];
      result$data['excludeTagPatterns'] =
          (l$excludeTagPatterns as List<dynamic>?)
              ?.map((e) => (e as String))
              .toList();
    }
    return Input$ConfigScrapingInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get scraperUserAgent => (_$data['scraperUserAgent'] as String?);

  String? get scraperCDPPath => (_$data['scraperCDPPath'] as String?);

  bool? get scraperCertCheck => (_$data['scraperCertCheck'] as bool?);

  List<String>? get excludeTagPatterns =>
      (_$data['excludeTagPatterns'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('scraperUserAgent')) {
      final l$scraperUserAgent = scraperUserAgent;
      result$data['scraperUserAgent'] = l$scraperUserAgent;
    }
    if (_$data.containsKey('scraperCDPPath')) {
      final l$scraperCDPPath = scraperCDPPath;
      result$data['scraperCDPPath'] = l$scraperCDPPath;
    }
    if (_$data.containsKey('scraperCertCheck')) {
      final l$scraperCertCheck = scraperCertCheck;
      result$data['scraperCertCheck'] = l$scraperCertCheck;
    }
    if (_$data.containsKey('excludeTagPatterns')) {
      final l$excludeTagPatterns = excludeTagPatterns;
      result$data['excludeTagPatterns'] =
          l$excludeTagPatterns?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$ConfigScrapingInput<Input$ConfigScrapingInput> get copyWith =>
      CopyWith$Input$ConfigScrapingInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ConfigScrapingInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scraperUserAgent = scraperUserAgent;
    final lOther$scraperUserAgent = other.scraperUserAgent;
    if (_$data.containsKey('scraperUserAgent') !=
        other._$data.containsKey('scraperUserAgent')) {
      return false;
    }
    if (l$scraperUserAgent != lOther$scraperUserAgent) {
      return false;
    }
    final l$scraperCDPPath = scraperCDPPath;
    final lOther$scraperCDPPath = other.scraperCDPPath;
    if (_$data.containsKey('scraperCDPPath') !=
        other._$data.containsKey('scraperCDPPath')) {
      return false;
    }
    if (l$scraperCDPPath != lOther$scraperCDPPath) {
      return false;
    }
    final l$scraperCertCheck = scraperCertCheck;
    final lOther$scraperCertCheck = other.scraperCertCheck;
    if (_$data.containsKey('scraperCertCheck') !=
        other._$data.containsKey('scraperCertCheck')) {
      return false;
    }
    if (l$scraperCertCheck != lOther$scraperCertCheck) {
      return false;
    }
    final l$excludeTagPatterns = excludeTagPatterns;
    final lOther$excludeTagPatterns = other.excludeTagPatterns;
    if (_$data.containsKey('excludeTagPatterns') !=
        other._$data.containsKey('excludeTagPatterns')) {
      return false;
    }
    if (l$excludeTagPatterns != null && lOther$excludeTagPatterns != null) {
      if (l$excludeTagPatterns.length != lOther$excludeTagPatterns.length) {
        return false;
      }
      for (int i = 0; i < l$excludeTagPatterns.length; i++) {
        final l$excludeTagPatterns$entry = l$excludeTagPatterns[i];
        final lOther$excludeTagPatterns$entry = lOther$excludeTagPatterns[i];
        if (l$excludeTagPatterns$entry != lOther$excludeTagPatterns$entry) {
          return false;
        }
      }
    } else if (l$excludeTagPatterns != lOther$excludeTagPatterns) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scraperUserAgent = scraperUserAgent;
    final l$scraperCDPPath = scraperCDPPath;
    final l$scraperCertCheck = scraperCertCheck;
    final l$excludeTagPatterns = excludeTagPatterns;
    return Object.hashAll([
      _$data.containsKey('scraperUserAgent') ? l$scraperUserAgent : const {},
      _$data.containsKey('scraperCDPPath') ? l$scraperCDPPath : const {},
      _$data.containsKey('scraperCertCheck') ? l$scraperCertCheck : const {},
      _$data.containsKey('excludeTagPatterns')
          ? l$excludeTagPatterns == null
              ? null
              : Object.hashAll(l$excludeTagPatterns.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$ConfigScrapingInput<TRes> {
  factory CopyWith$Input$ConfigScrapingInput(
    Input$ConfigScrapingInput instance,
    TRes Function(Input$ConfigScrapingInput) then,
  ) = _CopyWithImpl$Input$ConfigScrapingInput;

  factory CopyWith$Input$ConfigScrapingInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfigScrapingInput;

  TRes call({
    String? scraperUserAgent,
    String? scraperCDPPath,
    bool? scraperCertCheck,
    List<String>? excludeTagPatterns,
  });
}

class _CopyWithImpl$Input$ConfigScrapingInput<TRes>
    implements CopyWith$Input$ConfigScrapingInput<TRes> {
  _CopyWithImpl$Input$ConfigScrapingInput(
    this._instance,
    this._then,
  );

  final Input$ConfigScrapingInput _instance;

  final TRes Function(Input$ConfigScrapingInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scraperUserAgent = _undefined,
    Object? scraperCDPPath = _undefined,
    Object? scraperCertCheck = _undefined,
    Object? excludeTagPatterns = _undefined,
  }) =>
      _then(Input$ConfigScrapingInput._({
        ..._instance._$data,
        if (scraperUserAgent != _undefined)
          'scraperUserAgent': (scraperUserAgent as String?),
        if (scraperCDPPath != _undefined)
          'scraperCDPPath': (scraperCDPPath as String?),
        if (scraperCertCheck != _undefined)
          'scraperCertCheck': (scraperCertCheck as bool?),
        if (excludeTagPatterns != _undefined)
          'excludeTagPatterns': (excludeTagPatterns as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$ConfigScrapingInput<TRes>
    implements CopyWith$Input$ConfigScrapingInput<TRes> {
  _CopyWithStubImpl$Input$ConfigScrapingInput(this._res);

  TRes _res;

  call({
    String? scraperUserAgent,
    String? scraperCDPPath,
    bool? scraperCertCheck,
    List<String>? excludeTagPatterns,
  }) =>
      _res;
}

class Input$ConfigDefaultSettingsInput {
  factory Input$ConfigDefaultSettingsInput({
    Input$ScanMetadataInput? scan,
    Input$IdentifyMetadataInput? identify,
    Input$AutoTagMetadataInput? autoTag,
    Input$GenerateMetadataInput? generate,
    bool? deleteFile,
    bool? deleteGenerated,
  }) =>
      Input$ConfigDefaultSettingsInput._({
        if (scan != null) r'scan': scan,
        if (identify != null) r'identify': identify,
        if (autoTag != null) r'autoTag': autoTag,
        if (generate != null) r'generate': generate,
        if (deleteFile != null) r'deleteFile': deleteFile,
        if (deleteGenerated != null) r'deleteGenerated': deleteGenerated,
      });

  Input$ConfigDefaultSettingsInput._(this._$data);

  factory Input$ConfigDefaultSettingsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('scan')) {
      final l$scan = data['scan'];
      result$data['scan'] = l$scan == null
          ? null
          : Input$ScanMetadataInput.fromJson((l$scan as Map<String, dynamic>));
    }
    if (data.containsKey('identify')) {
      final l$identify = data['identify'];
      result$data['identify'] = l$identify == null
          ? null
          : Input$IdentifyMetadataInput.fromJson(
              (l$identify as Map<String, dynamic>));
    }
    if (data.containsKey('autoTag')) {
      final l$autoTag = data['autoTag'];
      result$data['autoTag'] = l$autoTag == null
          ? null
          : Input$AutoTagMetadataInput.fromJson(
              (l$autoTag as Map<String, dynamic>));
    }
    if (data.containsKey('generate')) {
      final l$generate = data['generate'];
      result$data['generate'] = l$generate == null
          ? null
          : Input$GenerateMetadataInput.fromJson(
              (l$generate as Map<String, dynamic>));
    }
    if (data.containsKey('deleteFile')) {
      final l$deleteFile = data['deleteFile'];
      result$data['deleteFile'] = (l$deleteFile as bool?);
    }
    if (data.containsKey('deleteGenerated')) {
      final l$deleteGenerated = data['deleteGenerated'];
      result$data['deleteGenerated'] = (l$deleteGenerated as bool?);
    }
    return Input$ConfigDefaultSettingsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ScanMetadataInput? get scan =>
      (_$data['scan'] as Input$ScanMetadataInput?);

  Input$IdentifyMetadataInput? get identify =>
      (_$data['identify'] as Input$IdentifyMetadataInput?);

  Input$AutoTagMetadataInput? get autoTag =>
      (_$data['autoTag'] as Input$AutoTagMetadataInput?);

  Input$GenerateMetadataInput? get generate =>
      (_$data['generate'] as Input$GenerateMetadataInput?);

  bool? get deleteFile => (_$data['deleteFile'] as bool?);

  bool? get deleteGenerated => (_$data['deleteGenerated'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('scan')) {
      final l$scan = scan;
      result$data['scan'] = l$scan?.toJson();
    }
    if (_$data.containsKey('identify')) {
      final l$identify = identify;
      result$data['identify'] = l$identify?.toJson();
    }
    if (_$data.containsKey('autoTag')) {
      final l$autoTag = autoTag;
      result$data['autoTag'] = l$autoTag?.toJson();
    }
    if (_$data.containsKey('generate')) {
      final l$generate = generate;
      result$data['generate'] = l$generate?.toJson();
    }
    if (_$data.containsKey('deleteFile')) {
      final l$deleteFile = deleteFile;
      result$data['deleteFile'] = l$deleteFile;
    }
    if (_$data.containsKey('deleteGenerated')) {
      final l$deleteGenerated = deleteGenerated;
      result$data['deleteGenerated'] = l$deleteGenerated;
    }
    return result$data;
  }

  CopyWith$Input$ConfigDefaultSettingsInput<Input$ConfigDefaultSettingsInput>
      get copyWith => CopyWith$Input$ConfigDefaultSettingsInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ConfigDefaultSettingsInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scan = scan;
    final lOther$scan = other.scan;
    if (_$data.containsKey('scan') != other._$data.containsKey('scan')) {
      return false;
    }
    if (l$scan != lOther$scan) {
      return false;
    }
    final l$identify = identify;
    final lOther$identify = other.identify;
    if (_$data.containsKey('identify') !=
        other._$data.containsKey('identify')) {
      return false;
    }
    if (l$identify != lOther$identify) {
      return false;
    }
    final l$autoTag = autoTag;
    final lOther$autoTag = other.autoTag;
    if (_$data.containsKey('autoTag') != other._$data.containsKey('autoTag')) {
      return false;
    }
    if (l$autoTag != lOther$autoTag) {
      return false;
    }
    final l$generate = generate;
    final lOther$generate = other.generate;
    if (_$data.containsKey('generate') !=
        other._$data.containsKey('generate')) {
      return false;
    }
    if (l$generate != lOther$generate) {
      return false;
    }
    final l$deleteFile = deleteFile;
    final lOther$deleteFile = other.deleteFile;
    if (_$data.containsKey('deleteFile') !=
        other._$data.containsKey('deleteFile')) {
      return false;
    }
    if (l$deleteFile != lOther$deleteFile) {
      return false;
    }
    final l$deleteGenerated = deleteGenerated;
    final lOther$deleteGenerated = other.deleteGenerated;
    if (_$data.containsKey('deleteGenerated') !=
        other._$data.containsKey('deleteGenerated')) {
      return false;
    }
    if (l$deleteGenerated != lOther$deleteGenerated) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scan = scan;
    final l$identify = identify;
    final l$autoTag = autoTag;
    final l$generate = generate;
    final l$deleteFile = deleteFile;
    final l$deleteGenerated = deleteGenerated;
    return Object.hashAll([
      _$data.containsKey('scan') ? l$scan : const {},
      _$data.containsKey('identify') ? l$identify : const {},
      _$data.containsKey('autoTag') ? l$autoTag : const {},
      _$data.containsKey('generate') ? l$generate : const {},
      _$data.containsKey('deleteFile') ? l$deleteFile : const {},
      _$data.containsKey('deleteGenerated') ? l$deleteGenerated : const {},
    ]);
  }
}

abstract class CopyWith$Input$ConfigDefaultSettingsInput<TRes> {
  factory CopyWith$Input$ConfigDefaultSettingsInput(
    Input$ConfigDefaultSettingsInput instance,
    TRes Function(Input$ConfigDefaultSettingsInput) then,
  ) = _CopyWithImpl$Input$ConfigDefaultSettingsInput;

  factory CopyWith$Input$ConfigDefaultSettingsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ConfigDefaultSettingsInput;

  TRes call({
    Input$ScanMetadataInput? scan,
    Input$IdentifyMetadataInput? identify,
    Input$AutoTagMetadataInput? autoTag,
    Input$GenerateMetadataInput? generate,
    bool? deleteFile,
    bool? deleteGenerated,
  });
}

class _CopyWithImpl$Input$ConfigDefaultSettingsInput<TRes>
    implements CopyWith$Input$ConfigDefaultSettingsInput<TRes> {
  _CopyWithImpl$Input$ConfigDefaultSettingsInput(
    this._instance,
    this._then,
  );

  final Input$ConfigDefaultSettingsInput _instance;

  final TRes Function(Input$ConfigDefaultSettingsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scan = _undefined,
    Object? identify = _undefined,
    Object? autoTag = _undefined,
    Object? generate = _undefined,
    Object? deleteFile = _undefined,
    Object? deleteGenerated = _undefined,
  }) =>
      _then(Input$ConfigDefaultSettingsInput._({
        ..._instance._$data,
        if (scan != _undefined) 'scan': (scan as Input$ScanMetadataInput?),
        if (identify != _undefined)
          'identify': (identify as Input$IdentifyMetadataInput?),
        if (autoTag != _undefined)
          'autoTag': (autoTag as Input$AutoTagMetadataInput?),
        if (generate != _undefined)
          'generate': (generate as Input$GenerateMetadataInput?),
        if (deleteFile != _undefined) 'deleteFile': (deleteFile as bool?),
        if (deleteGenerated != _undefined)
          'deleteGenerated': (deleteGenerated as bool?),
      }));
}

class _CopyWithStubImpl$Input$ConfigDefaultSettingsInput<TRes>
    implements CopyWith$Input$ConfigDefaultSettingsInput<TRes> {
  _CopyWithStubImpl$Input$ConfigDefaultSettingsInput(this._res);

  TRes _res;

  call({
    Input$ScanMetadataInput? scan,
    Input$IdentifyMetadataInput? identify,
    Input$AutoTagMetadataInput? autoTag,
    Input$GenerateMetadataInput? generate,
    bool? deleteFile,
    bool? deleteGenerated,
  }) =>
      _res;
}

class Input$StashConfigInput {
  factory Input$StashConfigInput({
    required String path,
    required bool excludeVideo,
    required bool excludeImage,
  }) =>
      Input$StashConfigInput._({
        r'path': path,
        r'excludeVideo': excludeVideo,
        r'excludeImage': excludeImage,
      });

  Input$StashConfigInput._(this._$data);

  factory Input$StashConfigInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$path = data['path'];
    result$data['path'] = (l$path as String);
    final l$excludeVideo = data['excludeVideo'];
    result$data['excludeVideo'] = (l$excludeVideo as bool);
    final l$excludeImage = data['excludeImage'];
    result$data['excludeImage'] = (l$excludeImage as bool);
    return Input$StashConfigInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get path => (_$data['path'] as String);

  bool get excludeVideo => (_$data['excludeVideo'] as bool);

  bool get excludeImage => (_$data['excludeImage'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$path = path;
    result$data['path'] = l$path;
    final l$excludeVideo = excludeVideo;
    result$data['excludeVideo'] = l$excludeVideo;
    final l$excludeImage = excludeImage;
    result$data['excludeImage'] = l$excludeImage;
    return result$data;
  }

  CopyWith$Input$StashConfigInput<Input$StashConfigInput> get copyWith =>
      CopyWith$Input$StashConfigInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashConfigInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$excludeVideo = excludeVideo;
    final lOther$excludeVideo = other.excludeVideo;
    if (l$excludeVideo != lOther$excludeVideo) {
      return false;
    }
    final l$excludeImage = excludeImage;
    final lOther$excludeImage = other.excludeImage;
    if (l$excludeImage != lOther$excludeImage) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$excludeVideo = excludeVideo;
    final l$excludeImage = excludeImage;
    return Object.hashAll([
      l$path,
      l$excludeVideo,
      l$excludeImage,
    ]);
  }
}

abstract class CopyWith$Input$StashConfigInput<TRes> {
  factory CopyWith$Input$StashConfigInput(
    Input$StashConfigInput instance,
    TRes Function(Input$StashConfigInput) then,
  ) = _CopyWithImpl$Input$StashConfigInput;

  factory CopyWith$Input$StashConfigInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashConfigInput;

  TRes call({
    String? path,
    bool? excludeVideo,
    bool? excludeImage,
  });
}

class _CopyWithImpl$Input$StashConfigInput<TRes>
    implements CopyWith$Input$StashConfigInput<TRes> {
  _CopyWithImpl$Input$StashConfigInput(
    this._instance,
    this._then,
  );

  final Input$StashConfigInput _instance;

  final TRes Function(Input$StashConfigInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? path = _undefined,
    Object? excludeVideo = _undefined,
    Object? excludeImage = _undefined,
  }) =>
      _then(Input$StashConfigInput._({
        ..._instance._$data,
        if (path != _undefined && path != null) 'path': (path as String),
        if (excludeVideo != _undefined && excludeVideo != null)
          'excludeVideo': (excludeVideo as bool),
        if (excludeImage != _undefined && excludeImage != null)
          'excludeImage': (excludeImage as bool),
      }));
}

class _CopyWithStubImpl$Input$StashConfigInput<TRes>
    implements CopyWith$Input$StashConfigInput<TRes> {
  _CopyWithStubImpl$Input$StashConfigInput(this._res);

  TRes _res;

  call({
    String? path,
    bool? excludeVideo,
    bool? excludeImage,
  }) =>
      _res;
}

class Input$GenerateAPIKeyInput {
  factory Input$GenerateAPIKeyInput({bool? clear}) =>
      Input$GenerateAPIKeyInput._({
        if (clear != null) r'clear': clear,
      });

  Input$GenerateAPIKeyInput._(this._$data);

  factory Input$GenerateAPIKeyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('clear')) {
      final l$clear = data['clear'];
      result$data['clear'] = (l$clear as bool?);
    }
    return Input$GenerateAPIKeyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get clear => (_$data['clear'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('clear')) {
      final l$clear = clear;
      result$data['clear'] = l$clear;
    }
    return result$data;
  }

  CopyWith$Input$GenerateAPIKeyInput<Input$GenerateAPIKeyInput> get copyWith =>
      CopyWith$Input$GenerateAPIKeyInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$GenerateAPIKeyInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$clear = clear;
    final lOther$clear = other.clear;
    if (_$data.containsKey('clear') != other._$data.containsKey('clear')) {
      return false;
    }
    if (l$clear != lOther$clear) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$clear = clear;
    return Object.hashAll([_$data.containsKey('clear') ? l$clear : const {}]);
  }
}

abstract class CopyWith$Input$GenerateAPIKeyInput<TRes> {
  factory CopyWith$Input$GenerateAPIKeyInput(
    Input$GenerateAPIKeyInput instance,
    TRes Function(Input$GenerateAPIKeyInput) then,
  ) = _CopyWithImpl$Input$GenerateAPIKeyInput;

  factory CopyWith$Input$GenerateAPIKeyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$GenerateAPIKeyInput;

  TRes call({bool? clear});
}

class _CopyWithImpl$Input$GenerateAPIKeyInput<TRes>
    implements CopyWith$Input$GenerateAPIKeyInput<TRes> {
  _CopyWithImpl$Input$GenerateAPIKeyInput(
    this._instance,
    this._then,
  );

  final Input$GenerateAPIKeyInput _instance;

  final TRes Function(Input$GenerateAPIKeyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? clear = _undefined}) => _then(Input$GenerateAPIKeyInput._({
        ..._instance._$data,
        if (clear != _undefined) 'clear': (clear as bool?),
      }));
}

class _CopyWithStubImpl$Input$GenerateAPIKeyInput<TRes>
    implements CopyWith$Input$GenerateAPIKeyInput<TRes> {
  _CopyWithStubImpl$Input$GenerateAPIKeyInput(this._res);

  TRes _res;

  call({bool? clear}) => _res;
}

enum Enum$StreamingResolutionEnum {
  LOW,
  STANDARD,
  STANDARD_HD,
  FULL_HD,
  FOUR_K,
  ORIGINAL,
  $unknown;

  factory Enum$StreamingResolutionEnum.fromJson(String value) =>
      fromJson$Enum$StreamingResolutionEnum(value);

  String toJson() => toJson$Enum$StreamingResolutionEnum(this);
}

String toJson$Enum$StreamingResolutionEnum(Enum$StreamingResolutionEnum e) {
  switch (e) {
    case Enum$StreamingResolutionEnum.LOW:
      return r'LOW';
    case Enum$StreamingResolutionEnum.STANDARD:
      return r'STANDARD';
    case Enum$StreamingResolutionEnum.STANDARD_HD:
      return r'STANDARD_HD';
    case Enum$StreamingResolutionEnum.FULL_HD:
      return r'FULL_HD';
    case Enum$StreamingResolutionEnum.FOUR_K:
      return r'FOUR_K';
    case Enum$StreamingResolutionEnum.ORIGINAL:
      return r'ORIGINAL';
    case Enum$StreamingResolutionEnum.$unknown:
      return r'$unknown';
  }
}

Enum$StreamingResolutionEnum fromJson$Enum$StreamingResolutionEnum(
    String value) {
  switch (value) {
    case r'LOW':
      return Enum$StreamingResolutionEnum.LOW;
    case r'STANDARD':
      return Enum$StreamingResolutionEnum.STANDARD;
    case r'STANDARD_HD':
      return Enum$StreamingResolutionEnum.STANDARD_HD;
    case r'FULL_HD':
      return Enum$StreamingResolutionEnum.FULL_HD;
    case r'FOUR_K':
      return Enum$StreamingResolutionEnum.FOUR_K;
    case r'ORIGINAL':
      return Enum$StreamingResolutionEnum.ORIGINAL;
    default:
      return Enum$StreamingResolutionEnum.$unknown;
  }
}

enum Enum$PreviewPreset {
  ultrafast,
  veryfast,
  fast,
  medium,
  slow,
  slower,
  veryslow,
  $unknown;

  factory Enum$PreviewPreset.fromJson(String value) =>
      fromJson$Enum$PreviewPreset(value);

  String toJson() => toJson$Enum$PreviewPreset(this);
}

String toJson$Enum$PreviewPreset(Enum$PreviewPreset e) {
  switch (e) {
    case Enum$PreviewPreset.ultrafast:
      return r'ultrafast';
    case Enum$PreviewPreset.veryfast:
      return r'veryfast';
    case Enum$PreviewPreset.fast:
      return r'fast';
    case Enum$PreviewPreset.medium:
      return r'medium';
    case Enum$PreviewPreset.slow:
      return r'slow';
    case Enum$PreviewPreset.slower:
      return r'slower';
    case Enum$PreviewPreset.veryslow:
      return r'veryslow';
    case Enum$PreviewPreset.$unknown:
      return r'$unknown';
  }
}

Enum$PreviewPreset fromJson$Enum$PreviewPreset(String value) {
  switch (value) {
    case r'ultrafast':
      return Enum$PreviewPreset.ultrafast;
    case r'veryfast':
      return Enum$PreviewPreset.veryfast;
    case r'fast':
      return Enum$PreviewPreset.fast;
    case r'medium':
      return Enum$PreviewPreset.medium;
    case r'slow':
      return Enum$PreviewPreset.slow;
    case r'slower':
      return Enum$PreviewPreset.slower;
    case r'veryslow':
      return Enum$PreviewPreset.veryslow;
    default:
      return Enum$PreviewPreset.$unknown;
  }
}

enum Enum$HashAlgorithm {
  MD5,
  OSHASH,
  $unknown;

  factory Enum$HashAlgorithm.fromJson(String value) =>
      fromJson$Enum$HashAlgorithm(value);

  String toJson() => toJson$Enum$HashAlgorithm(this);
}

String toJson$Enum$HashAlgorithm(Enum$HashAlgorithm e) {
  switch (e) {
    case Enum$HashAlgorithm.MD5:
      return r'MD5';
    case Enum$HashAlgorithm.OSHASH:
      return r'OSHASH';
    case Enum$HashAlgorithm.$unknown:
      return r'$unknown';
  }
}

Enum$HashAlgorithm fromJson$Enum$HashAlgorithm(String value) {
  switch (value) {
    case r'MD5':
      return Enum$HashAlgorithm.MD5;
    case r'OSHASH':
      return Enum$HashAlgorithm.OSHASH;
    default:
      return Enum$HashAlgorithm.$unknown;
  }
}

enum Enum$BlobsStorageType {
  DATABASE,
  FILESYSTEM,
  $unknown;

  factory Enum$BlobsStorageType.fromJson(String value) =>
      fromJson$Enum$BlobsStorageType(value);

  String toJson() => toJson$Enum$BlobsStorageType(this);
}

String toJson$Enum$BlobsStorageType(Enum$BlobsStorageType e) {
  switch (e) {
    case Enum$BlobsStorageType.DATABASE:
      return r'DATABASE';
    case Enum$BlobsStorageType.FILESYSTEM:
      return r'FILESYSTEM';
    case Enum$BlobsStorageType.$unknown:
      return r'$unknown';
  }
}

Enum$BlobsStorageType fromJson$Enum$BlobsStorageType(String value) {
  switch (value) {
    case r'DATABASE':
      return Enum$BlobsStorageType.DATABASE;
    case r'FILESYSTEM':
      return Enum$BlobsStorageType.FILESYSTEM;
    default:
      return Enum$BlobsStorageType.$unknown;
  }
}

enum Enum$ImageLightboxDisplayMode {
  ORIGINAL,
  FIT_XY,
  FIT_X,
  $unknown;

  factory Enum$ImageLightboxDisplayMode.fromJson(String value) =>
      fromJson$Enum$ImageLightboxDisplayMode(value);

  String toJson() => toJson$Enum$ImageLightboxDisplayMode(this);
}

String toJson$Enum$ImageLightboxDisplayMode(Enum$ImageLightboxDisplayMode e) {
  switch (e) {
    case Enum$ImageLightboxDisplayMode.ORIGINAL:
      return r'ORIGINAL';
    case Enum$ImageLightboxDisplayMode.FIT_XY:
      return r'FIT_XY';
    case Enum$ImageLightboxDisplayMode.FIT_X:
      return r'FIT_X';
    case Enum$ImageLightboxDisplayMode.$unknown:
      return r'$unknown';
  }
}

Enum$ImageLightboxDisplayMode fromJson$Enum$ImageLightboxDisplayMode(
    String value) {
  switch (value) {
    case r'ORIGINAL':
      return Enum$ImageLightboxDisplayMode.ORIGINAL;
    case r'FIT_XY':
      return Enum$ImageLightboxDisplayMode.FIT_XY;
    case r'FIT_X':
      return Enum$ImageLightboxDisplayMode.FIT_X;
    default:
      return Enum$ImageLightboxDisplayMode.$unknown;
  }
}

enum Enum$ImageLightboxScrollMode {
  ZOOM,
  PAN_Y,
  $unknown;

  factory Enum$ImageLightboxScrollMode.fromJson(String value) =>
      fromJson$Enum$ImageLightboxScrollMode(value);

  String toJson() => toJson$Enum$ImageLightboxScrollMode(this);
}

String toJson$Enum$ImageLightboxScrollMode(Enum$ImageLightboxScrollMode e) {
  switch (e) {
    case Enum$ImageLightboxScrollMode.ZOOM:
      return r'ZOOM';
    case Enum$ImageLightboxScrollMode.PAN_Y:
      return r'PAN_Y';
    case Enum$ImageLightboxScrollMode.$unknown:
      return r'$unknown';
  }
}

Enum$ImageLightboxScrollMode fromJson$Enum$ImageLightboxScrollMode(
    String value) {
  switch (value) {
    case r'ZOOM':
      return Enum$ImageLightboxScrollMode.ZOOM;
    case r'PAN_Y':
      return Enum$ImageLightboxScrollMode.PAN_Y;
    default:
      return Enum$ImageLightboxScrollMode.$unknown;
  }
}
