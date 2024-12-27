import 'scraped-group.graphql.dart';
import 'scraped-performer.graphql.dart';

class Input$ScrapedSceneInput {
  factory Input$ScrapedSceneInput({
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    String? remote_site_id,
  }) =>
      Input$ScrapedSceneInput._({
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (details != null) r'details': details,
        if (director != null) r'director': director,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
        if (remote_site_id != null) r'remote_site_id': remote_site_id,
      });

  Input$ScrapedSceneInput._(this._$data);

  factory Input$ScrapedSceneInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('title')) {
      final l$title = data['title'];
      result$data['title'] = (l$title as String?);
    }
    if (data.containsKey('code')) {
      final l$code = data['code'];
      result$data['code'] = (l$code as String?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('director')) {
      final l$director = data['director'];
      result$data['director'] = (l$director as String?);
    }
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('urls')) {
      final l$urls = data['urls'];
      result$data['urls'] =
          (l$urls as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('date')) {
      final l$date = data['date'];
      result$data['date'] = (l$date as String?);
    }
    if (data.containsKey('remote_site_id')) {
      final l$remote_site_id = data['remote_site_id'];
      result$data['remote_site_id'] = (l$remote_site_id as String?);
    }
    return Input$ScrapedSceneInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get director => (_$data['director'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get date => (_$data['date'] as String?);

  String? get remote_site_id => (_$data['remote_site_id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('title')) {
      final l$title = title;
      result$data['title'] = l$title;
    }
    if (_$data.containsKey('code')) {
      final l$code = code;
      result$data['code'] = l$code;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('director')) {
      final l$director = director;
      result$data['director'] = l$director;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('date')) {
      final l$date = date;
      result$data['date'] = l$date;
    }
    if (_$data.containsKey('remote_site_id')) {
      final l$remote_site_id = remote_site_id;
      result$data['remote_site_id'] = l$remote_site_id;
    }
    return result$data;
  }

  CopyWith$Input$ScrapedSceneInput<Input$ScrapedSceneInput> get copyWith =>
      CopyWith$Input$ScrapedSceneInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapedSceneInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (_$data.containsKey('title') != other._$data.containsKey('title')) {
      return false;
    }
    if (l$title != lOther$title) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (_$data.containsKey('code') != other._$data.containsKey('code')) {
      return false;
    }
    if (l$code != lOther$code) {
      return false;
    }
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$director = director;
    final lOther$director = other.director;
    if (_$data.containsKey('director') !=
        other._$data.containsKey('director')) {
      return false;
    }
    if (l$director != lOther$director) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (_$data.containsKey('url') != other._$data.containsKey('url')) {
      return false;
    }
    if (l$url != lOther$url) {
      return false;
    }
    final l$urls = urls;
    final lOther$urls = other.urls;
    if (_$data.containsKey('urls') != other._$data.containsKey('urls')) {
      return false;
    }
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
    final l$date = date;
    final lOther$date = other.date;
    if (_$data.containsKey('date') != other._$data.containsKey('date')) {
      return false;
    }
    if (l$date != lOther$date) {
      return false;
    }
    final l$remote_site_id = remote_site_id;
    final lOther$remote_site_id = other.remote_site_id;
    if (_$data.containsKey('remote_site_id') !=
        other._$data.containsKey('remote_site_id')) {
      return false;
    }
    if (l$remote_site_id != lOther$remote_site_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$title = title;
    final l$code = code;
    final l$details = details;
    final l$director = director;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    final l$remote_site_id = remote_site_id;
    return Object.hashAll([
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('director') ? l$director : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('date') ? l$date : const {},
      _$data.containsKey('remote_site_id') ? l$remote_site_id : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapedSceneInput<TRes> {
  factory CopyWith$Input$ScrapedSceneInput(
    Input$ScrapedSceneInput instance,
    TRes Function(Input$ScrapedSceneInput) then,
  ) = _CopyWithImpl$Input$ScrapedSceneInput;

  factory CopyWith$Input$ScrapedSceneInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapedSceneInput;

  TRes call({
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    String? remote_site_id,
  });
}

class _CopyWithImpl$Input$ScrapedSceneInput<TRes>
    implements CopyWith$Input$ScrapedSceneInput<TRes> {
  _CopyWithImpl$Input$ScrapedSceneInput(
    this._instance,
    this._then,
  );

  final Input$ScrapedSceneInput _instance;

  final TRes Function(Input$ScrapedSceneInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? title = _undefined,
    Object? code = _undefined,
    Object? details = _undefined,
    Object? director = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
    Object? remote_site_id = _undefined,
  }) =>
      _then(Input$ScrapedSceneInput._({
        ..._instance._$data,
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (details != _undefined) 'details': (details as String?),
        if (director != _undefined) 'director': (director as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (date != _undefined) 'date': (date as String?),
        if (remote_site_id != _undefined)
          'remote_site_id': (remote_site_id as String?),
      }));
}

class _CopyWithStubImpl$Input$ScrapedSceneInput<TRes>
    implements CopyWith$Input$ScrapedSceneInput<TRes> {
  _CopyWithStubImpl$Input$ScrapedSceneInput(this._res);

  TRes _res;

  call({
    String? title,
    String? code,
    String? details,
    String? director,
    String? url,
    List<String>? urls,
    String? date,
    String? remote_site_id,
  }) =>
      _res;
}

class Input$ScrapedGalleryInput {
  factory Input$ScrapedGalleryInput({
    String? title,
    String? code,
    String? details,
    String? photographer,
    String? url,
    List<String>? urls,
    String? date,
  }) =>
      Input$ScrapedGalleryInput._({
        if (title != null) r'title': title,
        if (code != null) r'code': code,
        if (details != null) r'details': details,
        if (photographer != null) r'photographer': photographer,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (date != null) r'date': date,
      });

  Input$ScrapedGalleryInput._(this._$data);

  factory Input$ScrapedGalleryInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('title')) {
      final l$title = data['title'];
      result$data['title'] = (l$title as String?);
    }
    if (data.containsKey('code')) {
      final l$code = data['code'];
      result$data['code'] = (l$code as String?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('photographer')) {
      final l$photographer = data['photographer'];
      result$data['photographer'] = (l$photographer as String?);
    }
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('urls')) {
      final l$urls = data['urls'];
      result$data['urls'] =
          (l$urls as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('date')) {
      final l$date = data['date'];
      result$data['date'] = (l$date as String?);
    }
    return Input$ScrapedGalleryInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get title => (_$data['title'] as String?);

  String? get code => (_$data['code'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get photographer => (_$data['photographer'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get date => (_$data['date'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('title')) {
      final l$title = title;
      result$data['title'] = l$title;
    }
    if (_$data.containsKey('code')) {
      final l$code = code;
      result$data['code'] = l$code;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('photographer')) {
      final l$photographer = photographer;
      result$data['photographer'] = l$photographer;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('date')) {
      final l$date = date;
      result$data['date'] = l$date;
    }
    return result$data;
  }

  CopyWith$Input$ScrapedGalleryInput<Input$ScrapedGalleryInput> get copyWith =>
      CopyWith$Input$ScrapedGalleryInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapedGalleryInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (_$data.containsKey('title') != other._$data.containsKey('title')) {
      return false;
    }
    if (l$title != lOther$title) {
      return false;
    }
    final l$code = code;
    final lOther$code = other.code;
    if (_$data.containsKey('code') != other._$data.containsKey('code')) {
      return false;
    }
    if (l$code != lOther$code) {
      return false;
    }
    final l$details = details;
    final lOther$details = other.details;
    if (_$data.containsKey('details') != other._$data.containsKey('details')) {
      return false;
    }
    if (l$details != lOther$details) {
      return false;
    }
    final l$photographer = photographer;
    final lOther$photographer = other.photographer;
    if (_$data.containsKey('photographer') !=
        other._$data.containsKey('photographer')) {
      return false;
    }
    if (l$photographer != lOther$photographer) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (_$data.containsKey('url') != other._$data.containsKey('url')) {
      return false;
    }
    if (l$url != lOther$url) {
      return false;
    }
    final l$urls = urls;
    final lOther$urls = other.urls;
    if (_$data.containsKey('urls') != other._$data.containsKey('urls')) {
      return false;
    }
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
    final l$date = date;
    final lOther$date = other.date;
    if (_$data.containsKey('date') != other._$data.containsKey('date')) {
      return false;
    }
    if (l$date != lOther$date) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$title = title;
    final l$code = code;
    final l$details = details;
    final l$photographer = photographer;
    final l$url = url;
    final l$urls = urls;
    final l$date = date;
    return Object.hashAll([
      _$data.containsKey('title') ? l$title : const {},
      _$data.containsKey('code') ? l$code : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('photographer') ? l$photographer : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('date') ? l$date : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapedGalleryInput<TRes> {
  factory CopyWith$Input$ScrapedGalleryInput(
    Input$ScrapedGalleryInput instance,
    TRes Function(Input$ScrapedGalleryInput) then,
  ) = _CopyWithImpl$Input$ScrapedGalleryInput;

  factory CopyWith$Input$ScrapedGalleryInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapedGalleryInput;

  TRes call({
    String? title,
    String? code,
    String? details,
    String? photographer,
    String? url,
    List<String>? urls,
    String? date,
  });
}

class _CopyWithImpl$Input$ScrapedGalleryInput<TRes>
    implements CopyWith$Input$ScrapedGalleryInput<TRes> {
  _CopyWithImpl$Input$ScrapedGalleryInput(
    this._instance,
    this._then,
  );

  final Input$ScrapedGalleryInput _instance;

  final TRes Function(Input$ScrapedGalleryInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? title = _undefined,
    Object? code = _undefined,
    Object? details = _undefined,
    Object? photographer = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? date = _undefined,
  }) =>
      _then(Input$ScrapedGalleryInput._({
        ..._instance._$data,
        if (title != _undefined) 'title': (title as String?),
        if (code != _undefined) 'code': (code as String?),
        if (details != _undefined) 'details': (details as String?),
        if (photographer != _undefined)
          'photographer': (photographer as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (date != _undefined) 'date': (date as String?),
      }));
}

class _CopyWithStubImpl$Input$ScrapedGalleryInput<TRes>
    implements CopyWith$Input$ScrapedGalleryInput<TRes> {
  _CopyWithStubImpl$Input$ScrapedGalleryInput(this._res);

  TRes _res;

  call({
    String? title,
    String? code,
    String? details,
    String? photographer,
    String? url,
    List<String>? urls,
    String? date,
  }) =>
      _res;
}

class Input$ScraperSourceInput {
  factory Input$ScraperSourceInput({
    int? stash_box_index,
    String? stash_box_endpoint,
    String? scraper_id,
  }) =>
      Input$ScraperSourceInput._({
        if (stash_box_index != null) r'stash_box_index': stash_box_index,
        if (stash_box_endpoint != null)
          r'stash_box_endpoint': stash_box_endpoint,
        if (scraper_id != null) r'scraper_id': scraper_id,
      });

  Input$ScraperSourceInput._(this._$data);

  factory Input$ScraperSourceInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('stash_box_index')) {
      final l$stash_box_index = data['stash_box_index'];
      result$data['stash_box_index'] = (l$stash_box_index as int?);
    }
    if (data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = data['stash_box_endpoint'];
      result$data['stash_box_endpoint'] = (l$stash_box_endpoint as String?);
    }
    if (data.containsKey('scraper_id')) {
      final l$scraper_id = data['scraper_id'];
      result$data['scraper_id'] = (l$scraper_id as String?);
    }
    return Input$ScraperSourceInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get stash_box_index => (_$data['stash_box_index'] as int?);

  String? get stash_box_endpoint => (_$data['stash_box_endpoint'] as String?);

  String? get scraper_id => (_$data['scraper_id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('stash_box_index')) {
      final l$stash_box_index = stash_box_index;
      result$data['stash_box_index'] = l$stash_box_index;
    }
    if (_$data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = stash_box_endpoint;
      result$data['stash_box_endpoint'] = l$stash_box_endpoint;
    }
    if (_$data.containsKey('scraper_id')) {
      final l$scraper_id = scraper_id;
      result$data['scraper_id'] = l$scraper_id;
    }
    return result$data;
  }

  CopyWith$Input$ScraperSourceInput<Input$ScraperSourceInput> get copyWith =>
      CopyWith$Input$ScraperSourceInput(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScraperSourceInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$stash_box_index = stash_box_index;
    final lOther$stash_box_index = other.stash_box_index;
    if (_$data.containsKey('stash_box_index') !=
        other._$data.containsKey('stash_box_index')) {
      return false;
    }
    if (l$stash_box_index != lOther$stash_box_index) {
      return false;
    }
    final l$stash_box_endpoint = stash_box_endpoint;
    final lOther$stash_box_endpoint = other.stash_box_endpoint;
    if (_$data.containsKey('stash_box_endpoint') !=
        other._$data.containsKey('stash_box_endpoint')) {
      return false;
    }
    if (l$stash_box_endpoint != lOther$stash_box_endpoint) {
      return false;
    }
    final l$scraper_id = scraper_id;
    final lOther$scraper_id = other.scraper_id;
    if (_$data.containsKey('scraper_id') !=
        other._$data.containsKey('scraper_id')) {
      return false;
    }
    if (l$scraper_id != lOther$scraper_id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$stash_box_index = stash_box_index;
    final l$stash_box_endpoint = stash_box_endpoint;
    final l$scraper_id = scraper_id;
    return Object.hashAll([
      _$data.containsKey('stash_box_index') ? l$stash_box_index : const {},
      _$data.containsKey('stash_box_endpoint')
          ? l$stash_box_endpoint
          : const {},
      _$data.containsKey('scraper_id') ? l$scraper_id : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScraperSourceInput<TRes> {
  factory CopyWith$Input$ScraperSourceInput(
    Input$ScraperSourceInput instance,
    TRes Function(Input$ScraperSourceInput) then,
  ) = _CopyWithImpl$Input$ScraperSourceInput;

  factory CopyWith$Input$ScraperSourceInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScraperSourceInput;

  TRes call({
    int? stash_box_index,
    String? stash_box_endpoint,
    String? scraper_id,
  });
}

class _CopyWithImpl$Input$ScraperSourceInput<TRes>
    implements CopyWith$Input$ScraperSourceInput<TRes> {
  _CopyWithImpl$Input$ScraperSourceInput(
    this._instance,
    this._then,
  );

  final Input$ScraperSourceInput _instance;

  final TRes Function(Input$ScraperSourceInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? stash_box_index = _undefined,
    Object? stash_box_endpoint = _undefined,
    Object? scraper_id = _undefined,
  }) =>
      _then(Input$ScraperSourceInput._({
        ..._instance._$data,
        if (stash_box_index != _undefined)
          'stash_box_index': (stash_box_index as int?),
        if (stash_box_endpoint != _undefined)
          'stash_box_endpoint': (stash_box_endpoint as String?),
        if (scraper_id != _undefined) 'scraper_id': (scraper_id as String?),
      }));
}

class _CopyWithStubImpl$Input$ScraperSourceInput<TRes>
    implements CopyWith$Input$ScraperSourceInput<TRes> {
  _CopyWithStubImpl$Input$ScraperSourceInput(this._res);

  TRes _res;

  call({
    int? stash_box_index,
    String? stash_box_endpoint,
    String? scraper_id,
  }) =>
      _res;
}

class Input$ScrapeSingleSceneInput {
  factory Input$ScrapeSingleSceneInput({
    String? query,
    String? scene_id,
    Input$ScrapedSceneInput? scene_input,
  }) =>
      Input$ScrapeSingleSceneInput._({
        if (query != null) r'query': query,
        if (scene_id != null) r'scene_id': scene_id,
        if (scene_input != null) r'scene_input': scene_input,
      });

  Input$ScrapeSingleSceneInput._(this._$data);

  factory Input$ScrapeSingleSceneInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('query')) {
      final l$query = data['query'];
      result$data['query'] = (l$query as String?);
    }
    if (data.containsKey('scene_id')) {
      final l$scene_id = data['scene_id'];
      result$data['scene_id'] = (l$scene_id as String?);
    }
    if (data.containsKey('scene_input')) {
      final l$scene_input = data['scene_input'];
      result$data['scene_input'] = l$scene_input == null
          ? null
          : Input$ScrapedSceneInput.fromJson(
              (l$scene_input as Map<String, dynamic>));
    }
    return Input$ScrapeSingleSceneInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get query => (_$data['query'] as String?);

  String? get scene_id => (_$data['scene_id'] as String?);

  Input$ScrapedSceneInput? get scene_input =>
      (_$data['scene_input'] as Input$ScrapedSceneInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('query')) {
      final l$query = query;
      result$data['query'] = l$query;
    }
    if (_$data.containsKey('scene_id')) {
      final l$scene_id = scene_id;
      result$data['scene_id'] = l$scene_id;
    }
    if (_$data.containsKey('scene_input')) {
      final l$scene_input = scene_input;
      result$data['scene_input'] = l$scene_input?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$ScrapeSingleSceneInput<Input$ScrapeSingleSceneInput>
      get copyWith => CopyWith$Input$ScrapeSingleSceneInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeSingleSceneInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (_$data.containsKey('query') != other._$data.containsKey('query')) {
      return false;
    }
    if (l$query != lOther$query) {
      return false;
    }
    final l$scene_id = scene_id;
    final lOther$scene_id = other.scene_id;
    if (_$data.containsKey('scene_id') !=
        other._$data.containsKey('scene_id')) {
      return false;
    }
    if (l$scene_id != lOther$scene_id) {
      return false;
    }
    final l$scene_input = scene_input;
    final lOther$scene_input = other.scene_input;
    if (_$data.containsKey('scene_input') !=
        other._$data.containsKey('scene_input')) {
      return false;
    }
    if (l$scene_input != lOther$scene_input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$query = query;
    final l$scene_id = scene_id;
    final l$scene_input = scene_input;
    return Object.hashAll([
      _$data.containsKey('query') ? l$query : const {},
      _$data.containsKey('scene_id') ? l$scene_id : const {},
      _$data.containsKey('scene_input') ? l$scene_input : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapeSingleSceneInput<TRes> {
  factory CopyWith$Input$ScrapeSingleSceneInput(
    Input$ScrapeSingleSceneInput instance,
    TRes Function(Input$ScrapeSingleSceneInput) then,
  ) = _CopyWithImpl$Input$ScrapeSingleSceneInput;

  factory CopyWith$Input$ScrapeSingleSceneInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeSingleSceneInput;

  TRes call({
    String? query,
    String? scene_id,
    Input$ScrapedSceneInput? scene_input,
  });
  CopyWith$Input$ScrapedSceneInput<TRes> get scene_input;
}

class _CopyWithImpl$Input$ScrapeSingleSceneInput<TRes>
    implements CopyWith$Input$ScrapeSingleSceneInput<TRes> {
  _CopyWithImpl$Input$ScrapeSingleSceneInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeSingleSceneInput _instance;

  final TRes Function(Input$ScrapeSingleSceneInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? query = _undefined,
    Object? scene_id = _undefined,
    Object? scene_input = _undefined,
  }) =>
      _then(Input$ScrapeSingleSceneInput._({
        ..._instance._$data,
        if (query != _undefined) 'query': (query as String?),
        if (scene_id != _undefined) 'scene_id': (scene_id as String?),
        if (scene_input != _undefined)
          'scene_input': (scene_input as Input$ScrapedSceneInput?),
      }));

  CopyWith$Input$ScrapedSceneInput<TRes> get scene_input {
    final local$scene_input = _instance.scene_input;
    return local$scene_input == null
        ? CopyWith$Input$ScrapedSceneInput.stub(_then(_instance))
        : CopyWith$Input$ScrapedSceneInput(
            local$scene_input, (e) => call(scene_input: e));
  }
}

class _CopyWithStubImpl$Input$ScrapeSingleSceneInput<TRes>
    implements CopyWith$Input$ScrapeSingleSceneInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeSingleSceneInput(this._res);

  TRes _res;

  call({
    String? query,
    String? scene_id,
    Input$ScrapedSceneInput? scene_input,
  }) =>
      _res;

  CopyWith$Input$ScrapedSceneInput<TRes> get scene_input =>
      CopyWith$Input$ScrapedSceneInput.stub(_res);
}

class Input$ScrapeMultiScenesInput {
  factory Input$ScrapeMultiScenesInput({List<String>? scene_ids}) =>
      Input$ScrapeMultiScenesInput._({
        if (scene_ids != null) r'scene_ids': scene_ids,
      });

  Input$ScrapeMultiScenesInput._(this._$data);

  factory Input$ScrapeMultiScenesInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('scene_ids')) {
      final l$scene_ids = data['scene_ids'];
      result$data['scene_ids'] =
          (l$scene_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    return Input$ScrapeMultiScenesInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get scene_ids => (_$data['scene_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('scene_ids')) {
      final l$scene_ids = scene_ids;
      result$data['scene_ids'] = l$scene_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$ScrapeMultiScenesInput<Input$ScrapeMultiScenesInput>
      get copyWith => CopyWith$Input$ScrapeMultiScenesInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeMultiScenesInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scene_ids = scene_ids;
    final lOther$scene_ids = other.scene_ids;
    if (_$data.containsKey('scene_ids') !=
        other._$data.containsKey('scene_ids')) {
      return false;
    }
    if (l$scene_ids != null && lOther$scene_ids != null) {
      if (l$scene_ids.length != lOther$scene_ids.length) {
        return false;
      }
      for (int i = 0; i < l$scene_ids.length; i++) {
        final l$scene_ids$entry = l$scene_ids[i];
        final lOther$scene_ids$entry = lOther$scene_ids[i];
        if (l$scene_ids$entry != lOther$scene_ids$entry) {
          return false;
        }
      }
    } else if (l$scene_ids != lOther$scene_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scene_ids = scene_ids;
    return Object.hashAll([
      _$data.containsKey('scene_ids')
          ? l$scene_ids == null
              ? null
              : Object.hashAll(l$scene_ids.map((v) => v))
          : const {}
    ]);
  }
}

abstract class CopyWith$Input$ScrapeMultiScenesInput<TRes> {
  factory CopyWith$Input$ScrapeMultiScenesInput(
    Input$ScrapeMultiScenesInput instance,
    TRes Function(Input$ScrapeMultiScenesInput) then,
  ) = _CopyWithImpl$Input$ScrapeMultiScenesInput;

  factory CopyWith$Input$ScrapeMultiScenesInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeMultiScenesInput;

  TRes call({List<String>? scene_ids});
}

class _CopyWithImpl$Input$ScrapeMultiScenesInput<TRes>
    implements CopyWith$Input$ScrapeMultiScenesInput<TRes> {
  _CopyWithImpl$Input$ScrapeMultiScenesInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeMultiScenesInput _instance;

  final TRes Function(Input$ScrapeMultiScenesInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? scene_ids = _undefined}) =>
      _then(Input$ScrapeMultiScenesInput._({
        ..._instance._$data,
        if (scene_ids != _undefined) 'scene_ids': (scene_ids as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$ScrapeMultiScenesInput<TRes>
    implements CopyWith$Input$ScrapeMultiScenesInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeMultiScenesInput(this._res);

  TRes _res;

  call({List<String>? scene_ids}) => _res;
}

class Input$ScrapeSingleStudioInput {
  factory Input$ScrapeSingleStudioInput({String? query}) =>
      Input$ScrapeSingleStudioInput._({
        if (query != null) r'query': query,
      });

  Input$ScrapeSingleStudioInput._(this._$data);

  factory Input$ScrapeSingleStudioInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('query')) {
      final l$query = data['query'];
      result$data['query'] = (l$query as String?);
    }
    return Input$ScrapeSingleStudioInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get query => (_$data['query'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('query')) {
      final l$query = query;
      result$data['query'] = l$query;
    }
    return result$data;
  }

  CopyWith$Input$ScrapeSingleStudioInput<Input$ScrapeSingleStudioInput>
      get copyWith => CopyWith$Input$ScrapeSingleStudioInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeSingleStudioInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (_$data.containsKey('query') != other._$data.containsKey('query')) {
      return false;
    }
    if (l$query != lOther$query) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$query = query;
    return Object.hashAll([_$data.containsKey('query') ? l$query : const {}]);
  }
}

abstract class CopyWith$Input$ScrapeSingleStudioInput<TRes> {
  factory CopyWith$Input$ScrapeSingleStudioInput(
    Input$ScrapeSingleStudioInput instance,
    TRes Function(Input$ScrapeSingleStudioInput) then,
  ) = _CopyWithImpl$Input$ScrapeSingleStudioInput;

  factory CopyWith$Input$ScrapeSingleStudioInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeSingleStudioInput;

  TRes call({String? query});
}

class _CopyWithImpl$Input$ScrapeSingleStudioInput<TRes>
    implements CopyWith$Input$ScrapeSingleStudioInput<TRes> {
  _CopyWithImpl$Input$ScrapeSingleStudioInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeSingleStudioInput _instance;

  final TRes Function(Input$ScrapeSingleStudioInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? query = _undefined}) =>
      _then(Input$ScrapeSingleStudioInput._({
        ..._instance._$data,
        if (query != _undefined) 'query': (query as String?),
      }));
}

class _CopyWithStubImpl$Input$ScrapeSingleStudioInput<TRes>
    implements CopyWith$Input$ScrapeSingleStudioInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeSingleStudioInput(this._res);

  TRes _res;

  call({String? query}) => _res;
}

class Input$ScrapeSinglePerformerInput {
  factory Input$ScrapeSinglePerformerInput({
    String? query,
    String? performer_id,
    Input$ScrapedPerformerInput? performer_input,
  }) =>
      Input$ScrapeSinglePerformerInput._({
        if (query != null) r'query': query,
        if (performer_id != null) r'performer_id': performer_id,
        if (performer_input != null) r'performer_input': performer_input,
      });

  Input$ScrapeSinglePerformerInput._(this._$data);

  factory Input$ScrapeSinglePerformerInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('query')) {
      final l$query = data['query'];
      result$data['query'] = (l$query as String?);
    }
    if (data.containsKey('performer_id')) {
      final l$performer_id = data['performer_id'];
      result$data['performer_id'] = (l$performer_id as String?);
    }
    if (data.containsKey('performer_input')) {
      final l$performer_input = data['performer_input'];
      result$data['performer_input'] = l$performer_input == null
          ? null
          : Input$ScrapedPerformerInput.fromJson(
              (l$performer_input as Map<String, dynamic>));
    }
    return Input$ScrapeSinglePerformerInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get query => (_$data['query'] as String?);

  String? get performer_id => (_$data['performer_id'] as String?);

  Input$ScrapedPerformerInput? get performer_input =>
      (_$data['performer_input'] as Input$ScrapedPerformerInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('query')) {
      final l$query = query;
      result$data['query'] = l$query;
    }
    if (_$data.containsKey('performer_id')) {
      final l$performer_id = performer_id;
      result$data['performer_id'] = l$performer_id;
    }
    if (_$data.containsKey('performer_input')) {
      final l$performer_input = performer_input;
      result$data['performer_input'] = l$performer_input?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$ScrapeSinglePerformerInput<Input$ScrapeSinglePerformerInput>
      get copyWith => CopyWith$Input$ScrapeSinglePerformerInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeSinglePerformerInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (_$data.containsKey('query') != other._$data.containsKey('query')) {
      return false;
    }
    if (l$query != lOther$query) {
      return false;
    }
    final l$performer_id = performer_id;
    final lOther$performer_id = other.performer_id;
    if (_$data.containsKey('performer_id') !=
        other._$data.containsKey('performer_id')) {
      return false;
    }
    if (l$performer_id != lOther$performer_id) {
      return false;
    }
    final l$performer_input = performer_input;
    final lOther$performer_input = other.performer_input;
    if (_$data.containsKey('performer_input') !=
        other._$data.containsKey('performer_input')) {
      return false;
    }
    if (l$performer_input != lOther$performer_input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$query = query;
    final l$performer_id = performer_id;
    final l$performer_input = performer_input;
    return Object.hashAll([
      _$data.containsKey('query') ? l$query : const {},
      _$data.containsKey('performer_id') ? l$performer_id : const {},
      _$data.containsKey('performer_input') ? l$performer_input : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapeSinglePerformerInput<TRes> {
  factory CopyWith$Input$ScrapeSinglePerformerInput(
    Input$ScrapeSinglePerformerInput instance,
    TRes Function(Input$ScrapeSinglePerformerInput) then,
  ) = _CopyWithImpl$Input$ScrapeSinglePerformerInput;

  factory CopyWith$Input$ScrapeSinglePerformerInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeSinglePerformerInput;

  TRes call({
    String? query,
    String? performer_id,
    Input$ScrapedPerformerInput? performer_input,
  });
}

class _CopyWithImpl$Input$ScrapeSinglePerformerInput<TRes>
    implements CopyWith$Input$ScrapeSinglePerformerInput<TRes> {
  _CopyWithImpl$Input$ScrapeSinglePerformerInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeSinglePerformerInput _instance;

  final TRes Function(Input$ScrapeSinglePerformerInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? query = _undefined,
    Object? performer_id = _undefined,
    Object? performer_input = _undefined,
  }) =>
      _then(Input$ScrapeSinglePerformerInput._({
        ..._instance._$data,
        if (query != _undefined) 'query': (query as String?),
        if (performer_id != _undefined)
          'performer_id': (performer_id as String?),
        if (performer_input != _undefined)
          'performer_input': (performer_input as Input$ScrapedPerformerInput?),
      }));
}

class _CopyWithStubImpl$Input$ScrapeSinglePerformerInput<TRes>
    implements CopyWith$Input$ScrapeSinglePerformerInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeSinglePerformerInput(this._res);

  TRes _res;

  call({
    String? query,
    String? performer_id,
    Input$ScrapedPerformerInput? performer_input,
  }) =>
      _res;
}

class Input$ScrapeMultiPerformersInput {
  factory Input$ScrapeMultiPerformersInput({List<String>? performer_ids}) =>
      Input$ScrapeMultiPerformersInput._({
        if (performer_ids != null) r'performer_ids': performer_ids,
      });

  Input$ScrapeMultiPerformersInput._(this._$data);

  factory Input$ScrapeMultiPerformersInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Input$ScrapeMultiPerformersInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$ScrapeMultiPerformersInput<Input$ScrapeMultiPerformersInput>
      get copyWith => CopyWith$Input$ScrapeMultiPerformersInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeMultiPerformersInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$performer_ids = performer_ids;
    final lOther$performer_ids = other.performer_ids;
    if (_$data.containsKey('performer_ids') !=
        other._$data.containsKey('performer_ids')) {
      return false;
    }
    if (l$performer_ids != null && lOther$performer_ids != null) {
      if (l$performer_ids.length != lOther$performer_ids.length) {
        return false;
      }
      for (int i = 0; i < l$performer_ids.length; i++) {
        final l$performer_ids$entry = l$performer_ids[i];
        final lOther$performer_ids$entry = lOther$performer_ids[i];
        if (l$performer_ids$entry != lOther$performer_ids$entry) {
          return false;
        }
      }
    } else if (l$performer_ids != lOther$performer_ids) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$performer_ids = performer_ids;
    return Object.hashAll([
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {}
    ]);
  }
}

abstract class CopyWith$Input$ScrapeMultiPerformersInput<TRes> {
  factory CopyWith$Input$ScrapeMultiPerformersInput(
    Input$ScrapeMultiPerformersInput instance,
    TRes Function(Input$ScrapeMultiPerformersInput) then,
  ) = _CopyWithImpl$Input$ScrapeMultiPerformersInput;

  factory CopyWith$Input$ScrapeMultiPerformersInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeMultiPerformersInput;

  TRes call({List<String>? performer_ids});
}

class _CopyWithImpl$Input$ScrapeMultiPerformersInput<TRes>
    implements CopyWith$Input$ScrapeMultiPerformersInput<TRes> {
  _CopyWithImpl$Input$ScrapeMultiPerformersInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeMultiPerformersInput _instance;

  final TRes Function(Input$ScrapeMultiPerformersInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? performer_ids = _undefined}) =>
      _then(Input$ScrapeMultiPerformersInput._({
        ..._instance._$data,
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$ScrapeMultiPerformersInput<TRes>
    implements CopyWith$Input$ScrapeMultiPerformersInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeMultiPerformersInput(this._res);

  TRes _res;

  call({List<String>? performer_ids}) => _res;
}

class Input$ScrapeSingleGalleryInput {
  factory Input$ScrapeSingleGalleryInput({
    String? query,
    String? gallery_id,
    Input$ScrapedGalleryInput? gallery_input,
  }) =>
      Input$ScrapeSingleGalleryInput._({
        if (query != null) r'query': query,
        if (gallery_id != null) r'gallery_id': gallery_id,
        if (gallery_input != null) r'gallery_input': gallery_input,
      });

  Input$ScrapeSingleGalleryInput._(this._$data);

  factory Input$ScrapeSingleGalleryInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('query')) {
      final l$query = data['query'];
      result$data['query'] = (l$query as String?);
    }
    if (data.containsKey('gallery_id')) {
      final l$gallery_id = data['gallery_id'];
      result$data['gallery_id'] = (l$gallery_id as String?);
    }
    if (data.containsKey('gallery_input')) {
      final l$gallery_input = data['gallery_input'];
      result$data['gallery_input'] = l$gallery_input == null
          ? null
          : Input$ScrapedGalleryInput.fromJson(
              (l$gallery_input as Map<String, dynamic>));
    }
    return Input$ScrapeSingleGalleryInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get query => (_$data['query'] as String?);

  String? get gallery_id => (_$data['gallery_id'] as String?);

  Input$ScrapedGalleryInput? get gallery_input =>
      (_$data['gallery_input'] as Input$ScrapedGalleryInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('query')) {
      final l$query = query;
      result$data['query'] = l$query;
    }
    if (_$data.containsKey('gallery_id')) {
      final l$gallery_id = gallery_id;
      result$data['gallery_id'] = l$gallery_id;
    }
    if (_$data.containsKey('gallery_input')) {
      final l$gallery_input = gallery_input;
      result$data['gallery_input'] = l$gallery_input?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$ScrapeSingleGalleryInput<Input$ScrapeSingleGalleryInput>
      get copyWith => CopyWith$Input$ScrapeSingleGalleryInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeSingleGalleryInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (_$data.containsKey('query') != other._$data.containsKey('query')) {
      return false;
    }
    if (l$query != lOther$query) {
      return false;
    }
    final l$gallery_id = gallery_id;
    final lOther$gallery_id = other.gallery_id;
    if (_$data.containsKey('gallery_id') !=
        other._$data.containsKey('gallery_id')) {
      return false;
    }
    if (l$gallery_id != lOther$gallery_id) {
      return false;
    }
    final l$gallery_input = gallery_input;
    final lOther$gallery_input = other.gallery_input;
    if (_$data.containsKey('gallery_input') !=
        other._$data.containsKey('gallery_input')) {
      return false;
    }
    if (l$gallery_input != lOther$gallery_input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$query = query;
    final l$gallery_id = gallery_id;
    final l$gallery_input = gallery_input;
    return Object.hashAll([
      _$data.containsKey('query') ? l$query : const {},
      _$data.containsKey('gallery_id') ? l$gallery_id : const {},
      _$data.containsKey('gallery_input') ? l$gallery_input : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapeSingleGalleryInput<TRes> {
  factory CopyWith$Input$ScrapeSingleGalleryInput(
    Input$ScrapeSingleGalleryInput instance,
    TRes Function(Input$ScrapeSingleGalleryInput) then,
  ) = _CopyWithImpl$Input$ScrapeSingleGalleryInput;

  factory CopyWith$Input$ScrapeSingleGalleryInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeSingleGalleryInput;

  TRes call({
    String? query,
    String? gallery_id,
    Input$ScrapedGalleryInput? gallery_input,
  });
  CopyWith$Input$ScrapedGalleryInput<TRes> get gallery_input;
}

class _CopyWithImpl$Input$ScrapeSingleGalleryInput<TRes>
    implements CopyWith$Input$ScrapeSingleGalleryInput<TRes> {
  _CopyWithImpl$Input$ScrapeSingleGalleryInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeSingleGalleryInput _instance;

  final TRes Function(Input$ScrapeSingleGalleryInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? query = _undefined,
    Object? gallery_id = _undefined,
    Object? gallery_input = _undefined,
  }) =>
      _then(Input$ScrapeSingleGalleryInput._({
        ..._instance._$data,
        if (query != _undefined) 'query': (query as String?),
        if (gallery_id != _undefined) 'gallery_id': (gallery_id as String?),
        if (gallery_input != _undefined)
          'gallery_input': (gallery_input as Input$ScrapedGalleryInput?),
      }));

  CopyWith$Input$ScrapedGalleryInput<TRes> get gallery_input {
    final local$gallery_input = _instance.gallery_input;
    return local$gallery_input == null
        ? CopyWith$Input$ScrapedGalleryInput.stub(_then(_instance))
        : CopyWith$Input$ScrapedGalleryInput(
            local$gallery_input, (e) => call(gallery_input: e));
  }
}

class _CopyWithStubImpl$Input$ScrapeSingleGalleryInput<TRes>
    implements CopyWith$Input$ScrapeSingleGalleryInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeSingleGalleryInput(this._res);

  TRes _res;

  call({
    String? query,
    String? gallery_id,
    Input$ScrapedGalleryInput? gallery_input,
  }) =>
      _res;

  CopyWith$Input$ScrapedGalleryInput<TRes> get gallery_input =>
      CopyWith$Input$ScrapedGalleryInput.stub(_res);
}

class Input$ScrapeSingleMovieInput {
  factory Input$ScrapeSingleMovieInput({
    String? query,
    String? movie_id,
    Input$ScrapedMovieInput? movie_input,
  }) =>
      Input$ScrapeSingleMovieInput._({
        if (query != null) r'query': query,
        if (movie_id != null) r'movie_id': movie_id,
        if (movie_input != null) r'movie_input': movie_input,
      });

  Input$ScrapeSingleMovieInput._(this._$data);

  factory Input$ScrapeSingleMovieInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('query')) {
      final l$query = data['query'];
      result$data['query'] = (l$query as String?);
    }
    if (data.containsKey('movie_id')) {
      final l$movie_id = data['movie_id'];
      result$data['movie_id'] = (l$movie_id as String?);
    }
    if (data.containsKey('movie_input')) {
      final l$movie_input = data['movie_input'];
      result$data['movie_input'] = l$movie_input == null
          ? null
          : Input$ScrapedMovieInput.fromJson(
              (l$movie_input as Map<String, dynamic>));
    }
    return Input$ScrapeSingleMovieInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get query => (_$data['query'] as String?);

  String? get movie_id => (_$data['movie_id'] as String?);

  Input$ScrapedMovieInput? get movie_input =>
      (_$data['movie_input'] as Input$ScrapedMovieInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('query')) {
      final l$query = query;
      result$data['query'] = l$query;
    }
    if (_$data.containsKey('movie_id')) {
      final l$movie_id = movie_id;
      result$data['movie_id'] = l$movie_id;
    }
    if (_$data.containsKey('movie_input')) {
      final l$movie_input = movie_input;
      result$data['movie_input'] = l$movie_input?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$ScrapeSingleMovieInput<Input$ScrapeSingleMovieInput>
      get copyWith => CopyWith$Input$ScrapeSingleMovieInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeSingleMovieInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (_$data.containsKey('query') != other._$data.containsKey('query')) {
      return false;
    }
    if (l$query != lOther$query) {
      return false;
    }
    final l$movie_id = movie_id;
    final lOther$movie_id = other.movie_id;
    if (_$data.containsKey('movie_id') !=
        other._$data.containsKey('movie_id')) {
      return false;
    }
    if (l$movie_id != lOther$movie_id) {
      return false;
    }
    final l$movie_input = movie_input;
    final lOther$movie_input = other.movie_input;
    if (_$data.containsKey('movie_input') !=
        other._$data.containsKey('movie_input')) {
      return false;
    }
    if (l$movie_input != lOther$movie_input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$query = query;
    final l$movie_id = movie_id;
    final l$movie_input = movie_input;
    return Object.hashAll([
      _$data.containsKey('query') ? l$query : const {},
      _$data.containsKey('movie_id') ? l$movie_id : const {},
      _$data.containsKey('movie_input') ? l$movie_input : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapeSingleMovieInput<TRes> {
  factory CopyWith$Input$ScrapeSingleMovieInput(
    Input$ScrapeSingleMovieInput instance,
    TRes Function(Input$ScrapeSingleMovieInput) then,
  ) = _CopyWithImpl$Input$ScrapeSingleMovieInput;

  factory CopyWith$Input$ScrapeSingleMovieInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeSingleMovieInput;

  TRes call({
    String? query,
    String? movie_id,
    Input$ScrapedMovieInput? movie_input,
  });
}

class _CopyWithImpl$Input$ScrapeSingleMovieInput<TRes>
    implements CopyWith$Input$ScrapeSingleMovieInput<TRes> {
  _CopyWithImpl$Input$ScrapeSingleMovieInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeSingleMovieInput _instance;

  final TRes Function(Input$ScrapeSingleMovieInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? query = _undefined,
    Object? movie_id = _undefined,
    Object? movie_input = _undefined,
  }) =>
      _then(Input$ScrapeSingleMovieInput._({
        ..._instance._$data,
        if (query != _undefined) 'query': (query as String?),
        if (movie_id != _undefined) 'movie_id': (movie_id as String?),
        if (movie_input != _undefined)
          'movie_input': (movie_input as Input$ScrapedMovieInput?),
      }));
}

class _CopyWithStubImpl$Input$ScrapeSingleMovieInput<TRes>
    implements CopyWith$Input$ScrapeSingleMovieInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeSingleMovieInput(this._res);

  TRes _res;

  call({
    String? query,
    String? movie_id,
    Input$ScrapedMovieInput? movie_input,
  }) =>
      _res;
}

class Input$ScrapeSingleGroupInput {
  factory Input$ScrapeSingleGroupInput({
    String? query,
    String? group_id,
    Input$ScrapedGroupInput? group_input,
  }) =>
      Input$ScrapeSingleGroupInput._({
        if (query != null) r'query': query,
        if (group_id != null) r'group_id': group_id,
        if (group_input != null) r'group_input': group_input,
      });

  Input$ScrapeSingleGroupInput._(this._$data);

  factory Input$ScrapeSingleGroupInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('query')) {
      final l$query = data['query'];
      result$data['query'] = (l$query as String?);
    }
    if (data.containsKey('group_id')) {
      final l$group_id = data['group_id'];
      result$data['group_id'] = (l$group_id as String?);
    }
    if (data.containsKey('group_input')) {
      final l$group_input = data['group_input'];
      result$data['group_input'] = l$group_input == null
          ? null
          : Input$ScrapedGroupInput.fromJson(
              (l$group_input as Map<String, dynamic>));
    }
    return Input$ScrapeSingleGroupInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get query => (_$data['query'] as String?);

  String? get group_id => (_$data['group_id'] as String?);

  Input$ScrapedGroupInput? get group_input =>
      (_$data['group_input'] as Input$ScrapedGroupInput?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('query')) {
      final l$query = query;
      result$data['query'] = l$query;
    }
    if (_$data.containsKey('group_id')) {
      final l$group_id = group_id;
      result$data['group_id'] = l$group_id;
    }
    if (_$data.containsKey('group_input')) {
      final l$group_input = group_input;
      result$data['group_input'] = l$group_input?.toJson();
    }
    return result$data;
  }

  CopyWith$Input$ScrapeSingleGroupInput<Input$ScrapeSingleGroupInput>
      get copyWith => CopyWith$Input$ScrapeSingleGroupInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapeSingleGroupInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$query = query;
    final lOther$query = other.query;
    if (_$data.containsKey('query') != other._$data.containsKey('query')) {
      return false;
    }
    if (l$query != lOther$query) {
      return false;
    }
    final l$group_id = group_id;
    final lOther$group_id = other.group_id;
    if (_$data.containsKey('group_id') !=
        other._$data.containsKey('group_id')) {
      return false;
    }
    if (l$group_id != lOther$group_id) {
      return false;
    }
    final l$group_input = group_input;
    final lOther$group_input = other.group_input;
    if (_$data.containsKey('group_input') !=
        other._$data.containsKey('group_input')) {
      return false;
    }
    if (l$group_input != lOther$group_input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$query = query;
    final l$group_id = group_id;
    final l$group_input = group_input;
    return Object.hashAll([
      _$data.containsKey('query') ? l$query : const {},
      _$data.containsKey('group_id') ? l$group_id : const {},
      _$data.containsKey('group_input') ? l$group_input : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapeSingleGroupInput<TRes> {
  factory CopyWith$Input$ScrapeSingleGroupInput(
    Input$ScrapeSingleGroupInput instance,
    TRes Function(Input$ScrapeSingleGroupInput) then,
  ) = _CopyWithImpl$Input$ScrapeSingleGroupInput;

  factory CopyWith$Input$ScrapeSingleGroupInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapeSingleGroupInput;

  TRes call({
    String? query,
    String? group_id,
    Input$ScrapedGroupInput? group_input,
  });
}

class _CopyWithImpl$Input$ScrapeSingleGroupInput<TRes>
    implements CopyWith$Input$ScrapeSingleGroupInput<TRes> {
  _CopyWithImpl$Input$ScrapeSingleGroupInput(
    this._instance,
    this._then,
  );

  final Input$ScrapeSingleGroupInput _instance;

  final TRes Function(Input$ScrapeSingleGroupInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? query = _undefined,
    Object? group_id = _undefined,
    Object? group_input = _undefined,
  }) =>
      _then(Input$ScrapeSingleGroupInput._({
        ..._instance._$data,
        if (query != _undefined) 'query': (query as String?),
        if (group_id != _undefined) 'group_id': (group_id as String?),
        if (group_input != _undefined)
          'group_input': (group_input as Input$ScrapedGroupInput?),
      }));
}

class _CopyWithStubImpl$Input$ScrapeSingleGroupInput<TRes>
    implements CopyWith$Input$ScrapeSingleGroupInput<TRes> {
  _CopyWithStubImpl$Input$ScrapeSingleGroupInput(this._res);

  TRes _res;

  call({
    String? query,
    String? group_id,
    Input$ScrapedGroupInput? group_input,
  }) =>
      _res;
}

class Input$StashBoxSceneQueryInput {
  factory Input$StashBoxSceneQueryInput({
    int? stash_box_index,
    String? stash_box_endpoint,
    List<String>? scene_ids,
    String? q,
  }) =>
      Input$StashBoxSceneQueryInput._({
        if (stash_box_index != null) r'stash_box_index': stash_box_index,
        if (stash_box_endpoint != null)
          r'stash_box_endpoint': stash_box_endpoint,
        if (scene_ids != null) r'scene_ids': scene_ids,
        if (q != null) r'q': q,
      });

  Input$StashBoxSceneQueryInput._(this._$data);

  factory Input$StashBoxSceneQueryInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('stash_box_index')) {
      final l$stash_box_index = data['stash_box_index'];
      result$data['stash_box_index'] = (l$stash_box_index as int?);
    }
    if (data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = data['stash_box_endpoint'];
      result$data['stash_box_endpoint'] = (l$stash_box_endpoint as String?);
    }
    if (data.containsKey('scene_ids')) {
      final l$scene_ids = data['scene_ids'];
      result$data['scene_ids'] =
          (l$scene_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('q')) {
      final l$q = data['q'];
      result$data['q'] = (l$q as String?);
    }
    return Input$StashBoxSceneQueryInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get stash_box_index => (_$data['stash_box_index'] as int?);

  String? get stash_box_endpoint => (_$data['stash_box_endpoint'] as String?);

  List<String>? get scene_ids => (_$data['scene_ids'] as List<String>?);

  String? get q => (_$data['q'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('stash_box_index')) {
      final l$stash_box_index = stash_box_index;
      result$data['stash_box_index'] = l$stash_box_index;
    }
    if (_$data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = stash_box_endpoint;
      result$data['stash_box_endpoint'] = l$stash_box_endpoint;
    }
    if (_$data.containsKey('scene_ids')) {
      final l$scene_ids = scene_ids;
      result$data['scene_ids'] = l$scene_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('q')) {
      final l$q = q;
      result$data['q'] = l$q;
    }
    return result$data;
  }

  CopyWith$Input$StashBoxSceneQueryInput<Input$StashBoxSceneQueryInput>
      get copyWith => CopyWith$Input$StashBoxSceneQueryInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashBoxSceneQueryInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$stash_box_index = stash_box_index;
    final lOther$stash_box_index = other.stash_box_index;
    if (_$data.containsKey('stash_box_index') !=
        other._$data.containsKey('stash_box_index')) {
      return false;
    }
    if (l$stash_box_index != lOther$stash_box_index) {
      return false;
    }
    final l$stash_box_endpoint = stash_box_endpoint;
    final lOther$stash_box_endpoint = other.stash_box_endpoint;
    if (_$data.containsKey('stash_box_endpoint') !=
        other._$data.containsKey('stash_box_endpoint')) {
      return false;
    }
    if (l$stash_box_endpoint != lOther$stash_box_endpoint) {
      return false;
    }
    final l$scene_ids = scene_ids;
    final lOther$scene_ids = other.scene_ids;
    if (_$data.containsKey('scene_ids') !=
        other._$data.containsKey('scene_ids')) {
      return false;
    }
    if (l$scene_ids != null && lOther$scene_ids != null) {
      if (l$scene_ids.length != lOther$scene_ids.length) {
        return false;
      }
      for (int i = 0; i < l$scene_ids.length; i++) {
        final l$scene_ids$entry = l$scene_ids[i];
        final lOther$scene_ids$entry = lOther$scene_ids[i];
        if (l$scene_ids$entry != lOther$scene_ids$entry) {
          return false;
        }
      }
    } else if (l$scene_ids != lOther$scene_ids) {
      return false;
    }
    final l$q = q;
    final lOther$q = other.q;
    if (_$data.containsKey('q') != other._$data.containsKey('q')) {
      return false;
    }
    if (l$q != lOther$q) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$stash_box_index = stash_box_index;
    final l$stash_box_endpoint = stash_box_endpoint;
    final l$scene_ids = scene_ids;
    final l$q = q;
    return Object.hashAll([
      _$data.containsKey('stash_box_index') ? l$stash_box_index : const {},
      _$data.containsKey('stash_box_endpoint')
          ? l$stash_box_endpoint
          : const {},
      _$data.containsKey('scene_ids')
          ? l$scene_ids == null
              ? null
              : Object.hashAll(l$scene_ids.map((v) => v))
          : const {},
      _$data.containsKey('q') ? l$q : const {},
    ]);
  }
}

abstract class CopyWith$Input$StashBoxSceneQueryInput<TRes> {
  factory CopyWith$Input$StashBoxSceneQueryInput(
    Input$StashBoxSceneQueryInput instance,
    TRes Function(Input$StashBoxSceneQueryInput) then,
  ) = _CopyWithImpl$Input$StashBoxSceneQueryInput;

  factory CopyWith$Input$StashBoxSceneQueryInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashBoxSceneQueryInput;

  TRes call({
    int? stash_box_index,
    String? stash_box_endpoint,
    List<String>? scene_ids,
    String? q,
  });
}

class _CopyWithImpl$Input$StashBoxSceneQueryInput<TRes>
    implements CopyWith$Input$StashBoxSceneQueryInput<TRes> {
  _CopyWithImpl$Input$StashBoxSceneQueryInput(
    this._instance,
    this._then,
  );

  final Input$StashBoxSceneQueryInput _instance;

  final TRes Function(Input$StashBoxSceneQueryInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? stash_box_index = _undefined,
    Object? stash_box_endpoint = _undefined,
    Object? scene_ids = _undefined,
    Object? q = _undefined,
  }) =>
      _then(Input$StashBoxSceneQueryInput._({
        ..._instance._$data,
        if (stash_box_index != _undefined)
          'stash_box_index': (stash_box_index as int?),
        if (stash_box_endpoint != _undefined)
          'stash_box_endpoint': (stash_box_endpoint as String?),
        if (scene_ids != _undefined) 'scene_ids': (scene_ids as List<String>?),
        if (q != _undefined) 'q': (q as String?),
      }));
}

class _CopyWithStubImpl$Input$StashBoxSceneQueryInput<TRes>
    implements CopyWith$Input$StashBoxSceneQueryInput<TRes> {
  _CopyWithStubImpl$Input$StashBoxSceneQueryInput(this._res);

  TRes _res;

  call({
    int? stash_box_index,
    String? stash_box_endpoint,
    List<String>? scene_ids,
    String? q,
  }) =>
      _res;
}

class Input$StashBoxPerformerQueryInput {
  factory Input$StashBoxPerformerQueryInput({
    int? stash_box_index,
    String? stash_box_endpoint,
    List<String>? performer_ids,
    String? q,
  }) =>
      Input$StashBoxPerformerQueryInput._({
        if (stash_box_index != null) r'stash_box_index': stash_box_index,
        if (stash_box_endpoint != null)
          r'stash_box_endpoint': stash_box_endpoint,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (q != null) r'q': q,
      });

  Input$StashBoxPerformerQueryInput._(this._$data);

  factory Input$StashBoxPerformerQueryInput.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('stash_box_index')) {
      final l$stash_box_index = data['stash_box_index'];
      result$data['stash_box_index'] = (l$stash_box_index as int?);
    }
    if (data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = data['stash_box_endpoint'];
      result$data['stash_box_endpoint'] = (l$stash_box_endpoint as String?);
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('q')) {
      final l$q = data['q'];
      result$data['q'] = (l$q as String?);
    }
    return Input$StashBoxPerformerQueryInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get stash_box_index => (_$data['stash_box_index'] as int?);

  String? get stash_box_endpoint => (_$data['stash_box_endpoint'] as String?);

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

  String? get q => (_$data['q'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('stash_box_index')) {
      final l$stash_box_index = stash_box_index;
      result$data['stash_box_index'] = l$stash_box_index;
    }
    if (_$data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = stash_box_endpoint;
      result$data['stash_box_endpoint'] = l$stash_box_endpoint;
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('q')) {
      final l$q = q;
      result$data['q'] = l$q;
    }
    return result$data;
  }

  CopyWith$Input$StashBoxPerformerQueryInput<Input$StashBoxPerformerQueryInput>
      get copyWith => CopyWith$Input$StashBoxPerformerQueryInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashBoxPerformerQueryInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$stash_box_index = stash_box_index;
    final lOther$stash_box_index = other.stash_box_index;
    if (_$data.containsKey('stash_box_index') !=
        other._$data.containsKey('stash_box_index')) {
      return false;
    }
    if (l$stash_box_index != lOther$stash_box_index) {
      return false;
    }
    final l$stash_box_endpoint = stash_box_endpoint;
    final lOther$stash_box_endpoint = other.stash_box_endpoint;
    if (_$data.containsKey('stash_box_endpoint') !=
        other._$data.containsKey('stash_box_endpoint')) {
      return false;
    }
    if (l$stash_box_endpoint != lOther$stash_box_endpoint) {
      return false;
    }
    final l$performer_ids = performer_ids;
    final lOther$performer_ids = other.performer_ids;
    if (_$data.containsKey('performer_ids') !=
        other._$data.containsKey('performer_ids')) {
      return false;
    }
    if (l$performer_ids != null && lOther$performer_ids != null) {
      if (l$performer_ids.length != lOther$performer_ids.length) {
        return false;
      }
      for (int i = 0; i < l$performer_ids.length; i++) {
        final l$performer_ids$entry = l$performer_ids[i];
        final lOther$performer_ids$entry = lOther$performer_ids[i];
        if (l$performer_ids$entry != lOther$performer_ids$entry) {
          return false;
        }
      }
    } else if (l$performer_ids != lOther$performer_ids) {
      return false;
    }
    final l$q = q;
    final lOther$q = other.q;
    if (_$data.containsKey('q') != other._$data.containsKey('q')) {
      return false;
    }
    if (l$q != lOther$q) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$stash_box_index = stash_box_index;
    final l$stash_box_endpoint = stash_box_endpoint;
    final l$performer_ids = performer_ids;
    final l$q = q;
    return Object.hashAll([
      _$data.containsKey('stash_box_index') ? l$stash_box_index : const {},
      _$data.containsKey('stash_box_endpoint')
          ? l$stash_box_endpoint
          : const {},
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {},
      _$data.containsKey('q') ? l$q : const {},
    ]);
  }
}

abstract class CopyWith$Input$StashBoxPerformerQueryInput<TRes> {
  factory CopyWith$Input$StashBoxPerformerQueryInput(
    Input$StashBoxPerformerQueryInput instance,
    TRes Function(Input$StashBoxPerformerQueryInput) then,
  ) = _CopyWithImpl$Input$StashBoxPerformerQueryInput;

  factory CopyWith$Input$StashBoxPerformerQueryInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashBoxPerformerQueryInput;

  TRes call({
    int? stash_box_index,
    String? stash_box_endpoint,
    List<String>? performer_ids,
    String? q,
  });
}

class _CopyWithImpl$Input$StashBoxPerformerQueryInput<TRes>
    implements CopyWith$Input$StashBoxPerformerQueryInput<TRes> {
  _CopyWithImpl$Input$StashBoxPerformerQueryInput(
    this._instance,
    this._then,
  );

  final Input$StashBoxPerformerQueryInput _instance;

  final TRes Function(Input$StashBoxPerformerQueryInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? stash_box_index = _undefined,
    Object? stash_box_endpoint = _undefined,
    Object? performer_ids = _undefined,
    Object? q = _undefined,
  }) =>
      _then(Input$StashBoxPerformerQueryInput._({
        ..._instance._$data,
        if (stash_box_index != _undefined)
          'stash_box_index': (stash_box_index as int?),
        if (stash_box_endpoint != _undefined)
          'stash_box_endpoint': (stash_box_endpoint as String?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
        if (q != _undefined) 'q': (q as String?),
      }));
}

class _CopyWithStubImpl$Input$StashBoxPerformerQueryInput<TRes>
    implements CopyWith$Input$StashBoxPerformerQueryInput<TRes> {
  _CopyWithStubImpl$Input$StashBoxPerformerQueryInput(this._res);

  TRes _res;

  call({
    int? stash_box_index,
    String? stash_box_endpoint,
    List<String>? performer_ids,
    String? q,
  }) =>
      _res;
}

class Input$StashBoxBatchTagInput {
  factory Input$StashBoxBatchTagInput({
    int? endpoint,
    String? stash_box_endpoint,
    List<String>? exclude_fields,
    required bool refresh,
    required bool createParent,
    List<String>? ids,
    List<String>? names,
    List<String>? performer_ids,
    List<String>? performer_names,
  }) =>
      Input$StashBoxBatchTagInput._({
        if (endpoint != null) r'endpoint': endpoint,
        if (stash_box_endpoint != null)
          r'stash_box_endpoint': stash_box_endpoint,
        if (exclude_fields != null) r'exclude_fields': exclude_fields,
        r'refresh': refresh,
        r'createParent': createParent,
        if (ids != null) r'ids': ids,
        if (names != null) r'names': names,
        if (performer_ids != null) r'performer_ids': performer_ids,
        if (performer_names != null) r'performer_names': performer_names,
      });

  Input$StashBoxBatchTagInput._(this._$data);

  factory Input$StashBoxBatchTagInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('endpoint')) {
      final l$endpoint = data['endpoint'];
      result$data['endpoint'] = (l$endpoint as int?);
    }
    if (data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = data['stash_box_endpoint'];
      result$data['stash_box_endpoint'] = (l$stash_box_endpoint as String?);
    }
    if (data.containsKey('exclude_fields')) {
      final l$exclude_fields = data['exclude_fields'];
      result$data['exclude_fields'] = (l$exclude_fields as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    final l$refresh = data['refresh'];
    result$data['refresh'] = (l$refresh as bool);
    final l$createParent = data['createParent'];
    result$data['createParent'] = (l$createParent as bool);
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] =
          (l$ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('names')) {
      final l$names = data['names'];
      result$data['names'] =
          (l$names as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('performer_ids')) {
      final l$performer_ids = data['performer_ids'];
      result$data['performer_ids'] = (l$performer_ids as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    if (data.containsKey('performer_names')) {
      final l$performer_names = data['performer_names'];
      result$data['performer_names'] = (l$performer_names as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Input$StashBoxBatchTagInput._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get endpoint => (_$data['endpoint'] as int?);

  String? get stash_box_endpoint => (_$data['stash_box_endpoint'] as String?);

  List<String>? get exclude_fields =>
      (_$data['exclude_fields'] as List<String>?);

  bool get refresh => (_$data['refresh'] as bool);

  bool get createParent => (_$data['createParent'] as bool);

  List<String>? get ids => (_$data['ids'] as List<String>?);

  List<String>? get names => (_$data['names'] as List<String>?);

  List<String>? get performer_ids => (_$data['performer_ids'] as List<String>?);

  List<String>? get performer_names =>
      (_$data['performer_names'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('endpoint')) {
      final l$endpoint = endpoint;
      result$data['endpoint'] = l$endpoint;
    }
    if (_$data.containsKey('stash_box_endpoint')) {
      final l$stash_box_endpoint = stash_box_endpoint;
      result$data['stash_box_endpoint'] = l$stash_box_endpoint;
    }
    if (_$data.containsKey('exclude_fields')) {
      final l$exclude_fields = exclude_fields;
      result$data['exclude_fields'] = l$exclude_fields?.map((e) => e).toList();
    }
    final l$refresh = refresh;
    result$data['refresh'] = l$refresh;
    final l$createParent = createParent;
    result$data['createParent'] = l$createParent;
    if (_$data.containsKey('ids')) {
      final l$ids = ids;
      result$data['ids'] = l$ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('names')) {
      final l$names = names;
      result$data['names'] = l$names?.map((e) => e).toList();
    }
    if (_$data.containsKey('performer_ids')) {
      final l$performer_ids = performer_ids;
      result$data['performer_ids'] = l$performer_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('performer_names')) {
      final l$performer_names = performer_names;
      result$data['performer_names'] =
          l$performer_names?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Input$StashBoxBatchTagInput<Input$StashBoxBatchTagInput>
      get copyWith => CopyWith$Input$StashBoxBatchTagInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$StashBoxBatchTagInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$endpoint = endpoint;
    final lOther$endpoint = other.endpoint;
    if (_$data.containsKey('endpoint') !=
        other._$data.containsKey('endpoint')) {
      return false;
    }
    if (l$endpoint != lOther$endpoint) {
      return false;
    }
    final l$stash_box_endpoint = stash_box_endpoint;
    final lOther$stash_box_endpoint = other.stash_box_endpoint;
    if (_$data.containsKey('stash_box_endpoint') !=
        other._$data.containsKey('stash_box_endpoint')) {
      return false;
    }
    if (l$stash_box_endpoint != lOther$stash_box_endpoint) {
      return false;
    }
    final l$exclude_fields = exclude_fields;
    final lOther$exclude_fields = other.exclude_fields;
    if (_$data.containsKey('exclude_fields') !=
        other._$data.containsKey('exclude_fields')) {
      return false;
    }
    if (l$exclude_fields != null && lOther$exclude_fields != null) {
      if (l$exclude_fields.length != lOther$exclude_fields.length) {
        return false;
      }
      for (int i = 0; i < l$exclude_fields.length; i++) {
        final l$exclude_fields$entry = l$exclude_fields[i];
        final lOther$exclude_fields$entry = lOther$exclude_fields[i];
        if (l$exclude_fields$entry != lOther$exclude_fields$entry) {
          return false;
        }
      }
    } else if (l$exclude_fields != lOther$exclude_fields) {
      return false;
    }
    final l$refresh = refresh;
    final lOther$refresh = other.refresh;
    if (l$refresh != lOther$refresh) {
      return false;
    }
    final l$createParent = createParent;
    final lOther$createParent = other.createParent;
    if (l$createParent != lOther$createParent) {
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
    final l$names = names;
    final lOther$names = other.names;
    if (_$data.containsKey('names') != other._$data.containsKey('names')) {
      return false;
    }
    if (l$names != null && lOther$names != null) {
      if (l$names.length != lOther$names.length) {
        return false;
      }
      for (int i = 0; i < l$names.length; i++) {
        final l$names$entry = l$names[i];
        final lOther$names$entry = lOther$names[i];
        if (l$names$entry != lOther$names$entry) {
          return false;
        }
      }
    } else if (l$names != lOther$names) {
      return false;
    }
    final l$performer_ids = performer_ids;
    final lOther$performer_ids = other.performer_ids;
    if (_$data.containsKey('performer_ids') !=
        other._$data.containsKey('performer_ids')) {
      return false;
    }
    if (l$performer_ids != null && lOther$performer_ids != null) {
      if (l$performer_ids.length != lOther$performer_ids.length) {
        return false;
      }
      for (int i = 0; i < l$performer_ids.length; i++) {
        final l$performer_ids$entry = l$performer_ids[i];
        final lOther$performer_ids$entry = lOther$performer_ids[i];
        if (l$performer_ids$entry != lOther$performer_ids$entry) {
          return false;
        }
      }
    } else if (l$performer_ids != lOther$performer_ids) {
      return false;
    }
    final l$performer_names = performer_names;
    final lOther$performer_names = other.performer_names;
    if (_$data.containsKey('performer_names') !=
        other._$data.containsKey('performer_names')) {
      return false;
    }
    if (l$performer_names != null && lOther$performer_names != null) {
      if (l$performer_names.length != lOther$performer_names.length) {
        return false;
      }
      for (int i = 0; i < l$performer_names.length; i++) {
        final l$performer_names$entry = l$performer_names[i];
        final lOther$performer_names$entry = lOther$performer_names[i];
        if (l$performer_names$entry != lOther$performer_names$entry) {
          return false;
        }
      }
    } else if (l$performer_names != lOther$performer_names) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$endpoint = endpoint;
    final l$stash_box_endpoint = stash_box_endpoint;
    final l$exclude_fields = exclude_fields;
    final l$refresh = refresh;
    final l$createParent = createParent;
    final l$ids = ids;
    final l$names = names;
    final l$performer_ids = performer_ids;
    final l$performer_names = performer_names;
    return Object.hashAll([
      _$data.containsKey('endpoint') ? l$endpoint : const {},
      _$data.containsKey('stash_box_endpoint')
          ? l$stash_box_endpoint
          : const {},
      _$data.containsKey('exclude_fields')
          ? l$exclude_fields == null
              ? null
              : Object.hashAll(l$exclude_fields.map((v) => v))
          : const {},
      l$refresh,
      l$createParent,
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('names')
          ? l$names == null
              ? null
              : Object.hashAll(l$names.map((v) => v))
          : const {},
      _$data.containsKey('performer_ids')
          ? l$performer_ids == null
              ? null
              : Object.hashAll(l$performer_ids.map((v) => v))
          : const {},
      _$data.containsKey('performer_names')
          ? l$performer_names == null
              ? null
              : Object.hashAll(l$performer_names.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Input$StashBoxBatchTagInput<TRes> {
  factory CopyWith$Input$StashBoxBatchTagInput(
    Input$StashBoxBatchTagInput instance,
    TRes Function(Input$StashBoxBatchTagInput) then,
  ) = _CopyWithImpl$Input$StashBoxBatchTagInput;

  factory CopyWith$Input$StashBoxBatchTagInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StashBoxBatchTagInput;

  TRes call({
    int? endpoint,
    String? stash_box_endpoint,
    List<String>? exclude_fields,
    bool? refresh,
    bool? createParent,
    List<String>? ids,
    List<String>? names,
    List<String>? performer_ids,
    List<String>? performer_names,
  });
}

class _CopyWithImpl$Input$StashBoxBatchTagInput<TRes>
    implements CopyWith$Input$StashBoxBatchTagInput<TRes> {
  _CopyWithImpl$Input$StashBoxBatchTagInput(
    this._instance,
    this._then,
  );

  final Input$StashBoxBatchTagInput _instance;

  final TRes Function(Input$StashBoxBatchTagInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? endpoint = _undefined,
    Object? stash_box_endpoint = _undefined,
    Object? exclude_fields = _undefined,
    Object? refresh = _undefined,
    Object? createParent = _undefined,
    Object? ids = _undefined,
    Object? names = _undefined,
    Object? performer_ids = _undefined,
    Object? performer_names = _undefined,
  }) =>
      _then(Input$StashBoxBatchTagInput._({
        ..._instance._$data,
        if (endpoint != _undefined) 'endpoint': (endpoint as int?),
        if (stash_box_endpoint != _undefined)
          'stash_box_endpoint': (stash_box_endpoint as String?),
        if (exclude_fields != _undefined)
          'exclude_fields': (exclude_fields as List<String>?),
        if (refresh != _undefined && refresh != null)
          'refresh': (refresh as bool),
        if (createParent != _undefined && createParent != null)
          'createParent': (createParent as bool),
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (names != _undefined) 'names': (names as List<String>?),
        if (performer_ids != _undefined)
          'performer_ids': (performer_ids as List<String>?),
        if (performer_names != _undefined)
          'performer_names': (performer_names as List<String>?),
      }));
}

class _CopyWithStubImpl$Input$StashBoxBatchTagInput<TRes>
    implements CopyWith$Input$StashBoxBatchTagInput<TRes> {
  _CopyWithStubImpl$Input$StashBoxBatchTagInput(this._res);

  TRes _res;

  call({
    int? endpoint,
    String? stash_box_endpoint,
    List<String>? exclude_fields,
    bool? refresh,
    bool? createParent,
    List<String>? ids,
    List<String>? names,
    List<String>? performer_ids,
    List<String>? performer_names,
  }) =>
      _res;
}

enum Enum$ScrapeType {
  NAME,
  FRAGMENT,
  URL,
  $unknown;

  factory Enum$ScrapeType.fromJson(String value) =>
      fromJson$Enum$ScrapeType(value);

  String toJson() => toJson$Enum$ScrapeType(this);
}

String toJson$Enum$ScrapeType(Enum$ScrapeType e) {
  switch (e) {
    case Enum$ScrapeType.NAME:
      return r'NAME';
    case Enum$ScrapeType.FRAGMENT:
      return r'FRAGMENT';
    case Enum$ScrapeType.URL:
      return r'URL';
    case Enum$ScrapeType.$unknown:
      return r'$unknown';
  }
}

Enum$ScrapeType fromJson$Enum$ScrapeType(String value) {
  switch (value) {
    case r'NAME':
      return Enum$ScrapeType.NAME;
    case r'FRAGMENT':
      return Enum$ScrapeType.FRAGMENT;
    case r'URL':
      return Enum$ScrapeType.URL;
    default:
      return Enum$ScrapeType.$unknown;
  }
}

enum Enum$ScrapeContentType {
  GALLERY,
  MOVIE,
  GROUP,
  PERFORMER,
  SCENE,
  $unknown;

  factory Enum$ScrapeContentType.fromJson(String value) =>
      fromJson$Enum$ScrapeContentType(value);

  String toJson() => toJson$Enum$ScrapeContentType(this);
}

String toJson$Enum$ScrapeContentType(Enum$ScrapeContentType e) {
  switch (e) {
    case Enum$ScrapeContentType.GALLERY:
      return r'GALLERY';
    case Enum$ScrapeContentType.MOVIE:
      return r'MOVIE';
    case Enum$ScrapeContentType.GROUP:
      return r'GROUP';
    case Enum$ScrapeContentType.PERFORMER:
      return r'PERFORMER';
    case Enum$ScrapeContentType.SCENE:
      return r'SCENE';
    case Enum$ScrapeContentType.$unknown:
      return r'$unknown';
  }
}

Enum$ScrapeContentType fromJson$Enum$ScrapeContentType(String value) {
  switch (value) {
    case r'GALLERY':
      return Enum$ScrapeContentType.GALLERY;
    case r'MOVIE':
      return Enum$ScrapeContentType.MOVIE;
    case r'GROUP':
      return Enum$ScrapeContentType.GROUP;
    case r'PERFORMER':
      return Enum$ScrapeContentType.PERFORMER;
    case r'SCENE':
      return Enum$ScrapeContentType.SCENE;
    default:
      return Enum$ScrapeContentType.$unknown;
  }
}
