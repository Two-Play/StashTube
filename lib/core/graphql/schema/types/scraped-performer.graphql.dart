class Input$ScrapedPerformerInput {
  factory Input$ScrapedPerformerInput({
    String? stored_id,
    String? name,
    String? disambiguation,
    String? gender,
    String? url,
    List<String>? urls,
    String? twitter,
    String? instagram,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    String? height,
    String? measurements,
    String? fake_tits,
    String? penis_length,
    String? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    String? aliases,
    String? details,
    String? death_date,
    String? hair_color,
    String? weight,
    String? remote_site_id,
  }) =>
      Input$ScrapedPerformerInput._({
        if (stored_id != null) r'stored_id': stored_id,
        if (name != null) r'name': name,
        if (disambiguation != null) r'disambiguation': disambiguation,
        if (gender != null) r'gender': gender,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (twitter != null) r'twitter': twitter,
        if (instagram != null) r'instagram': instagram,
        if (birthdate != null) r'birthdate': birthdate,
        if (ethnicity != null) r'ethnicity': ethnicity,
        if (country != null) r'country': country,
        if (eye_color != null) r'eye_color': eye_color,
        if (height != null) r'height': height,
        if (measurements != null) r'measurements': measurements,
        if (fake_tits != null) r'fake_tits': fake_tits,
        if (penis_length != null) r'penis_length': penis_length,
        if (circumcised != null) r'circumcised': circumcised,
        if (career_length != null) r'career_length': career_length,
        if (tattoos != null) r'tattoos': tattoos,
        if (piercings != null) r'piercings': piercings,
        if (aliases != null) r'aliases': aliases,
        if (details != null) r'details': details,
        if (death_date != null) r'death_date': death_date,
        if (hair_color != null) r'hair_color': hair_color,
        if (weight != null) r'weight': weight,
        if (remote_site_id != null) r'remote_site_id': remote_site_id,
      });

  Input$ScrapedPerformerInput._(this._$data);

  factory Input$ScrapedPerformerInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('stored_id')) {
      final l$stored_id = data['stored_id'];
      result$data['stored_id'] = (l$stored_id as String?);
    }
    if (data.containsKey('name')) {
      final l$name = data['name'];
      result$data['name'] = (l$name as String?);
    }
    if (data.containsKey('disambiguation')) {
      final l$disambiguation = data['disambiguation'];
      result$data['disambiguation'] = (l$disambiguation as String?);
    }
    if (data.containsKey('gender')) {
      final l$gender = data['gender'];
      result$data['gender'] = (l$gender as String?);
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
    if (data.containsKey('twitter')) {
      final l$twitter = data['twitter'];
      result$data['twitter'] = (l$twitter as String?);
    }
    if (data.containsKey('instagram')) {
      final l$instagram = data['instagram'];
      result$data['instagram'] = (l$instagram as String?);
    }
    if (data.containsKey('birthdate')) {
      final l$birthdate = data['birthdate'];
      result$data['birthdate'] = (l$birthdate as String?);
    }
    if (data.containsKey('ethnicity')) {
      final l$ethnicity = data['ethnicity'];
      result$data['ethnicity'] = (l$ethnicity as String?);
    }
    if (data.containsKey('country')) {
      final l$country = data['country'];
      result$data['country'] = (l$country as String?);
    }
    if (data.containsKey('eye_color')) {
      final l$eye_color = data['eye_color'];
      result$data['eye_color'] = (l$eye_color as String?);
    }
    if (data.containsKey('height')) {
      final l$height = data['height'];
      result$data['height'] = (l$height as String?);
    }
    if (data.containsKey('measurements')) {
      final l$measurements = data['measurements'];
      result$data['measurements'] = (l$measurements as String?);
    }
    if (data.containsKey('fake_tits')) {
      final l$fake_tits = data['fake_tits'];
      result$data['fake_tits'] = (l$fake_tits as String?);
    }
    if (data.containsKey('penis_length')) {
      final l$penis_length = data['penis_length'];
      result$data['penis_length'] = (l$penis_length as String?);
    }
    if (data.containsKey('circumcised')) {
      final l$circumcised = data['circumcised'];
      result$data['circumcised'] = (l$circumcised as String?);
    }
    if (data.containsKey('career_length')) {
      final l$career_length = data['career_length'];
      result$data['career_length'] = (l$career_length as String?);
    }
    if (data.containsKey('tattoos')) {
      final l$tattoos = data['tattoos'];
      result$data['tattoos'] = (l$tattoos as String?);
    }
    if (data.containsKey('piercings')) {
      final l$piercings = data['piercings'];
      result$data['piercings'] = (l$piercings as String?);
    }
    if (data.containsKey('aliases')) {
      final l$aliases = data['aliases'];
      result$data['aliases'] = (l$aliases as String?);
    }
    if (data.containsKey('details')) {
      final l$details = data['details'];
      result$data['details'] = (l$details as String?);
    }
    if (data.containsKey('death_date')) {
      final l$death_date = data['death_date'];
      result$data['death_date'] = (l$death_date as String?);
    }
    if (data.containsKey('hair_color')) {
      final l$hair_color = data['hair_color'];
      result$data['hair_color'] = (l$hair_color as String?);
    }
    if (data.containsKey('weight')) {
      final l$weight = data['weight'];
      result$data['weight'] = (l$weight as String?);
    }
    if (data.containsKey('remote_site_id')) {
      final l$remote_site_id = data['remote_site_id'];
      result$data['remote_site_id'] = (l$remote_site_id as String?);
    }
    return Input$ScrapedPerformerInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get stored_id => (_$data['stored_id'] as String?);

  String? get name => (_$data['name'] as String?);

  String? get disambiguation => (_$data['disambiguation'] as String?);

  String? get gender => (_$data['gender'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  String? get twitter => (_$data['twitter'] as String?);

  String? get instagram => (_$data['instagram'] as String?);

  String? get birthdate => (_$data['birthdate'] as String?);

  String? get ethnicity => (_$data['ethnicity'] as String?);

  String? get country => (_$data['country'] as String?);

  String? get eye_color => (_$data['eye_color'] as String?);

  String? get height => (_$data['height'] as String?);

  String? get measurements => (_$data['measurements'] as String?);

  String? get fake_tits => (_$data['fake_tits'] as String?);

  String? get penis_length => (_$data['penis_length'] as String?);

  String? get circumcised => (_$data['circumcised'] as String?);

  String? get career_length => (_$data['career_length'] as String?);

  String? get tattoos => (_$data['tattoos'] as String?);

  String? get piercings => (_$data['piercings'] as String?);

  String? get aliases => (_$data['aliases'] as String?);

  String? get details => (_$data['details'] as String?);

  String? get death_date => (_$data['death_date'] as String?);

  String? get hair_color => (_$data['hair_color'] as String?);

  String? get weight => (_$data['weight'] as String?);

  String? get remote_site_id => (_$data['remote_site_id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('stored_id')) {
      final l$stored_id = stored_id;
      result$data['stored_id'] = l$stored_id;
    }
    if (_$data.containsKey('name')) {
      final l$name = name;
      result$data['name'] = l$name;
    }
    if (_$data.containsKey('disambiguation')) {
      final l$disambiguation = disambiguation;
      result$data['disambiguation'] = l$disambiguation;
    }
    if (_$data.containsKey('gender')) {
      final l$gender = gender;
      result$data['gender'] = l$gender;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('twitter')) {
      final l$twitter = twitter;
      result$data['twitter'] = l$twitter;
    }
    if (_$data.containsKey('instagram')) {
      final l$instagram = instagram;
      result$data['instagram'] = l$instagram;
    }
    if (_$data.containsKey('birthdate')) {
      final l$birthdate = birthdate;
      result$data['birthdate'] = l$birthdate;
    }
    if (_$data.containsKey('ethnicity')) {
      final l$ethnicity = ethnicity;
      result$data['ethnicity'] = l$ethnicity;
    }
    if (_$data.containsKey('country')) {
      final l$country = country;
      result$data['country'] = l$country;
    }
    if (_$data.containsKey('eye_color')) {
      final l$eye_color = eye_color;
      result$data['eye_color'] = l$eye_color;
    }
    if (_$data.containsKey('height')) {
      final l$height = height;
      result$data['height'] = l$height;
    }
    if (_$data.containsKey('measurements')) {
      final l$measurements = measurements;
      result$data['measurements'] = l$measurements;
    }
    if (_$data.containsKey('fake_tits')) {
      final l$fake_tits = fake_tits;
      result$data['fake_tits'] = l$fake_tits;
    }
    if (_$data.containsKey('penis_length')) {
      final l$penis_length = penis_length;
      result$data['penis_length'] = l$penis_length;
    }
    if (_$data.containsKey('circumcised')) {
      final l$circumcised = circumcised;
      result$data['circumcised'] = l$circumcised;
    }
    if (_$data.containsKey('career_length')) {
      final l$career_length = career_length;
      result$data['career_length'] = l$career_length;
    }
    if (_$data.containsKey('tattoos')) {
      final l$tattoos = tattoos;
      result$data['tattoos'] = l$tattoos;
    }
    if (_$data.containsKey('piercings')) {
      final l$piercings = piercings;
      result$data['piercings'] = l$piercings;
    }
    if (_$data.containsKey('aliases')) {
      final l$aliases = aliases;
      result$data['aliases'] = l$aliases;
    }
    if (_$data.containsKey('details')) {
      final l$details = details;
      result$data['details'] = l$details;
    }
    if (_$data.containsKey('death_date')) {
      final l$death_date = death_date;
      result$data['death_date'] = l$death_date;
    }
    if (_$data.containsKey('hair_color')) {
      final l$hair_color = hair_color;
      result$data['hair_color'] = l$hair_color;
    }
    if (_$data.containsKey('weight')) {
      final l$weight = weight;
      result$data['weight'] = l$weight;
    }
    if (_$data.containsKey('remote_site_id')) {
      final l$remote_site_id = remote_site_id;
      result$data['remote_site_id'] = l$remote_site_id;
    }
    return result$data;
  }

  CopyWith$Input$ScrapedPerformerInput<Input$ScrapedPerformerInput>
      get copyWith => CopyWith$Input$ScrapedPerformerInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$ScrapedPerformerInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$stored_id = stored_id;
    final lOther$stored_id = other.stored_id;
    if (_$data.containsKey('stored_id') !=
        other._$data.containsKey('stored_id')) {
      return false;
    }
    if (l$stored_id != lOther$stored_id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (_$data.containsKey('name') != other._$data.containsKey('name')) {
      return false;
    }
    if (l$name != lOther$name) {
      return false;
    }
    final l$disambiguation = disambiguation;
    final lOther$disambiguation = other.disambiguation;
    if (_$data.containsKey('disambiguation') !=
        other._$data.containsKey('disambiguation')) {
      return false;
    }
    if (l$disambiguation != lOther$disambiguation) {
      return false;
    }
    final l$gender = gender;
    final lOther$gender = other.gender;
    if (_$data.containsKey('gender') != other._$data.containsKey('gender')) {
      return false;
    }
    if (l$gender != lOther$gender) {
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
    final l$twitter = twitter;
    final lOther$twitter = other.twitter;
    if (_$data.containsKey('twitter') != other._$data.containsKey('twitter')) {
      return false;
    }
    if (l$twitter != lOther$twitter) {
      return false;
    }
    final l$instagram = instagram;
    final lOther$instagram = other.instagram;
    if (_$data.containsKey('instagram') !=
        other._$data.containsKey('instagram')) {
      return false;
    }
    if (l$instagram != lOther$instagram) {
      return false;
    }
    final l$birthdate = birthdate;
    final lOther$birthdate = other.birthdate;
    if (_$data.containsKey('birthdate') !=
        other._$data.containsKey('birthdate')) {
      return false;
    }
    if (l$birthdate != lOther$birthdate) {
      return false;
    }
    final l$ethnicity = ethnicity;
    final lOther$ethnicity = other.ethnicity;
    if (_$data.containsKey('ethnicity') !=
        other._$data.containsKey('ethnicity')) {
      return false;
    }
    if (l$ethnicity != lOther$ethnicity) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (_$data.containsKey('country') != other._$data.containsKey('country')) {
      return false;
    }
    if (l$country != lOther$country) {
      return false;
    }
    final l$eye_color = eye_color;
    final lOther$eye_color = other.eye_color;
    if (_$data.containsKey('eye_color') !=
        other._$data.containsKey('eye_color')) {
      return false;
    }
    if (l$eye_color != lOther$eye_color) {
      return false;
    }
    final l$height = height;
    final lOther$height = other.height;
    if (_$data.containsKey('height') != other._$data.containsKey('height')) {
      return false;
    }
    if (l$height != lOther$height) {
      return false;
    }
    final l$measurements = measurements;
    final lOther$measurements = other.measurements;
    if (_$data.containsKey('measurements') !=
        other._$data.containsKey('measurements')) {
      return false;
    }
    if (l$measurements != lOther$measurements) {
      return false;
    }
    final l$fake_tits = fake_tits;
    final lOther$fake_tits = other.fake_tits;
    if (_$data.containsKey('fake_tits') !=
        other._$data.containsKey('fake_tits')) {
      return false;
    }
    if (l$fake_tits != lOther$fake_tits) {
      return false;
    }
    final l$penis_length = penis_length;
    final lOther$penis_length = other.penis_length;
    if (_$data.containsKey('penis_length') !=
        other._$data.containsKey('penis_length')) {
      return false;
    }
    if (l$penis_length != lOther$penis_length) {
      return false;
    }
    final l$circumcised = circumcised;
    final lOther$circumcised = other.circumcised;
    if (_$data.containsKey('circumcised') !=
        other._$data.containsKey('circumcised')) {
      return false;
    }
    if (l$circumcised != lOther$circumcised) {
      return false;
    }
    final l$career_length = career_length;
    final lOther$career_length = other.career_length;
    if (_$data.containsKey('career_length') !=
        other._$data.containsKey('career_length')) {
      return false;
    }
    if (l$career_length != lOther$career_length) {
      return false;
    }
    final l$tattoos = tattoos;
    final lOther$tattoos = other.tattoos;
    if (_$data.containsKey('tattoos') != other._$data.containsKey('tattoos')) {
      return false;
    }
    if (l$tattoos != lOther$tattoos) {
      return false;
    }
    final l$piercings = piercings;
    final lOther$piercings = other.piercings;
    if (_$data.containsKey('piercings') !=
        other._$data.containsKey('piercings')) {
      return false;
    }
    if (l$piercings != lOther$piercings) {
      return false;
    }
    final l$aliases = aliases;
    final lOther$aliases = other.aliases;
    if (_$data.containsKey('aliases') != other._$data.containsKey('aliases')) {
      return false;
    }
    if (l$aliases != lOther$aliases) {
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
    final l$death_date = death_date;
    final lOther$death_date = other.death_date;
    if (_$data.containsKey('death_date') !=
        other._$data.containsKey('death_date')) {
      return false;
    }
    if (l$death_date != lOther$death_date) {
      return false;
    }
    final l$hair_color = hair_color;
    final lOther$hair_color = other.hair_color;
    if (_$data.containsKey('hair_color') !=
        other._$data.containsKey('hair_color')) {
      return false;
    }
    if (l$hair_color != lOther$hair_color) {
      return false;
    }
    final l$weight = weight;
    final lOther$weight = other.weight;
    if (_$data.containsKey('weight') != other._$data.containsKey('weight')) {
      return false;
    }
    if (l$weight != lOther$weight) {
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
    final l$stored_id = stored_id;
    final l$name = name;
    final l$disambiguation = disambiguation;
    final l$gender = gender;
    final l$url = url;
    final l$urls = urls;
    final l$twitter = twitter;
    final l$instagram = instagram;
    final l$birthdate = birthdate;
    final l$ethnicity = ethnicity;
    final l$country = country;
    final l$eye_color = eye_color;
    final l$height = height;
    final l$measurements = measurements;
    final l$fake_tits = fake_tits;
    final l$penis_length = penis_length;
    final l$circumcised = circumcised;
    final l$career_length = career_length;
    final l$tattoos = tattoos;
    final l$piercings = piercings;
    final l$aliases = aliases;
    final l$details = details;
    final l$death_date = death_date;
    final l$hair_color = hair_color;
    final l$weight = weight;
    final l$remote_site_id = remote_site_id;
    return Object.hashAll([
      _$data.containsKey('stored_id') ? l$stored_id : const {},
      _$data.containsKey('name') ? l$name : const {},
      _$data.containsKey('disambiguation') ? l$disambiguation : const {},
      _$data.containsKey('gender') ? l$gender : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('twitter') ? l$twitter : const {},
      _$data.containsKey('instagram') ? l$instagram : const {},
      _$data.containsKey('birthdate') ? l$birthdate : const {},
      _$data.containsKey('ethnicity') ? l$ethnicity : const {},
      _$data.containsKey('country') ? l$country : const {},
      _$data.containsKey('eye_color') ? l$eye_color : const {},
      _$data.containsKey('height') ? l$height : const {},
      _$data.containsKey('measurements') ? l$measurements : const {},
      _$data.containsKey('fake_tits') ? l$fake_tits : const {},
      _$data.containsKey('penis_length') ? l$penis_length : const {},
      _$data.containsKey('circumcised') ? l$circumcised : const {},
      _$data.containsKey('career_length') ? l$career_length : const {},
      _$data.containsKey('tattoos') ? l$tattoos : const {},
      _$data.containsKey('piercings') ? l$piercings : const {},
      _$data.containsKey('aliases') ? l$aliases : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('death_date') ? l$death_date : const {},
      _$data.containsKey('hair_color') ? l$hair_color : const {},
      _$data.containsKey('weight') ? l$weight : const {},
      _$data.containsKey('remote_site_id') ? l$remote_site_id : const {},
    ]);
  }
}

abstract class CopyWith$Input$ScrapedPerformerInput<TRes> {
  factory CopyWith$Input$ScrapedPerformerInput(
    Input$ScrapedPerformerInput instance,
    TRes Function(Input$ScrapedPerformerInput) then,
  ) = _CopyWithImpl$Input$ScrapedPerformerInput;

  factory CopyWith$Input$ScrapedPerformerInput.stub(TRes res) =
      _CopyWithStubImpl$Input$ScrapedPerformerInput;

  TRes call({
    String? stored_id,
    String? name,
    String? disambiguation,
    String? gender,
    String? url,
    List<String>? urls,
    String? twitter,
    String? instagram,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    String? height,
    String? measurements,
    String? fake_tits,
    String? penis_length,
    String? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    String? aliases,
    String? details,
    String? death_date,
    String? hair_color,
    String? weight,
    String? remote_site_id,
  });
}

class _CopyWithImpl$Input$ScrapedPerformerInput<TRes>
    implements CopyWith$Input$ScrapedPerformerInput<TRes> {
  _CopyWithImpl$Input$ScrapedPerformerInput(
    this._instance,
    this._then,
  );

  final Input$ScrapedPerformerInput _instance;

  final TRes Function(Input$ScrapedPerformerInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? stored_id = _undefined,
    Object? name = _undefined,
    Object? disambiguation = _undefined,
    Object? gender = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? twitter = _undefined,
    Object? instagram = _undefined,
    Object? birthdate = _undefined,
    Object? ethnicity = _undefined,
    Object? country = _undefined,
    Object? eye_color = _undefined,
    Object? height = _undefined,
    Object? measurements = _undefined,
    Object? fake_tits = _undefined,
    Object? penis_length = _undefined,
    Object? circumcised = _undefined,
    Object? career_length = _undefined,
    Object? tattoos = _undefined,
    Object? piercings = _undefined,
    Object? aliases = _undefined,
    Object? details = _undefined,
    Object? death_date = _undefined,
    Object? hair_color = _undefined,
    Object? weight = _undefined,
    Object? remote_site_id = _undefined,
  }) =>
      _then(Input$ScrapedPerformerInput._({
        ..._instance._$data,
        if (stored_id != _undefined) 'stored_id': (stored_id as String?),
        if (name != _undefined) 'name': (name as String?),
        if (disambiguation != _undefined)
          'disambiguation': (disambiguation as String?),
        if (gender != _undefined) 'gender': (gender as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (twitter != _undefined) 'twitter': (twitter as String?),
        if (instagram != _undefined) 'instagram': (instagram as String?),
        if (birthdate != _undefined) 'birthdate': (birthdate as String?),
        if (ethnicity != _undefined) 'ethnicity': (ethnicity as String?),
        if (country != _undefined) 'country': (country as String?),
        if (eye_color != _undefined) 'eye_color': (eye_color as String?),
        if (height != _undefined) 'height': (height as String?),
        if (measurements != _undefined)
          'measurements': (measurements as String?),
        if (fake_tits != _undefined) 'fake_tits': (fake_tits as String?),
        if (penis_length != _undefined)
          'penis_length': (penis_length as String?),
        if (circumcised != _undefined) 'circumcised': (circumcised as String?),
        if (career_length != _undefined)
          'career_length': (career_length as String?),
        if (tattoos != _undefined) 'tattoos': (tattoos as String?),
        if (piercings != _undefined) 'piercings': (piercings as String?),
        if (aliases != _undefined) 'aliases': (aliases as String?),
        if (details != _undefined) 'details': (details as String?),
        if (death_date != _undefined) 'death_date': (death_date as String?),
        if (hair_color != _undefined) 'hair_color': (hair_color as String?),
        if (weight != _undefined) 'weight': (weight as String?),
        if (remote_site_id != _undefined)
          'remote_site_id': (remote_site_id as String?),
      }));
}

class _CopyWithStubImpl$Input$ScrapedPerformerInput<TRes>
    implements CopyWith$Input$ScrapedPerformerInput<TRes> {
  _CopyWithStubImpl$Input$ScrapedPerformerInput(this._res);

  TRes _res;

  call({
    String? stored_id,
    String? name,
    String? disambiguation,
    String? gender,
    String? url,
    List<String>? urls,
    String? twitter,
    String? instagram,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    String? height,
    String? measurements,
    String? fake_tits,
    String? penis_length,
    String? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    String? aliases,
    String? details,
    String? death_date,
    String? hair_color,
    String? weight,
    String? remote_site_id,
  }) =>
      _res;
}
