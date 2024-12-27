import 'scene.graphql.dart';
import 'stash-box.graphql.dart';

class Input$PerformerCreateInput {
  factory Input$PerformerCreateInput({
    required String name,
    String? disambiguation,
    String? url,
    List<String>? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    List<String>? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    List<String>? tag_ids,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  }) =>
      Input$PerformerCreateInput._({
        r'name': name,
        if (disambiguation != null) r'disambiguation': disambiguation,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (gender != null) r'gender': gender,
        if (birthdate != null) r'birthdate': birthdate,
        if (ethnicity != null) r'ethnicity': ethnicity,
        if (country != null) r'country': country,
        if (eye_color != null) r'eye_color': eye_color,
        if (height_cm != null) r'height_cm': height_cm,
        if (measurements != null) r'measurements': measurements,
        if (fake_tits != null) r'fake_tits': fake_tits,
        if (penis_length != null) r'penis_length': penis_length,
        if (circumcised != null) r'circumcised': circumcised,
        if (career_length != null) r'career_length': career_length,
        if (tattoos != null) r'tattoos': tattoos,
        if (piercings != null) r'piercings': piercings,
        if (alias_list != null) r'alias_list': alias_list,
        if (twitter != null) r'twitter': twitter,
        if (instagram != null) r'instagram': instagram,
        if (favorite != null) r'favorite': favorite,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (image != null) r'image': image,
        if (stash_ids != null) r'stash_ids': stash_ids,
        if (rating100 != null) r'rating100': rating100,
        if (details != null) r'details': details,
        if (death_date != null) r'death_date': death_date,
        if (hair_color != null) r'hair_color': hair_color,
        if (weight != null) r'weight': weight,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
      });

  Input$PerformerCreateInput._(this._$data);

  factory Input$PerformerCreateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    if (data.containsKey('disambiguation')) {
      final l$disambiguation = data['disambiguation'];
      result$data['disambiguation'] = (l$disambiguation as String?);
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
    if (data.containsKey('gender')) {
      final l$gender = data['gender'];
      result$data['gender'] = l$gender == null
          ? null
          : fromJson$Enum$GenderEnum((l$gender as String));
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
    if (data.containsKey('height_cm')) {
      final l$height_cm = data['height_cm'];
      result$data['height_cm'] = (l$height_cm as int?);
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
      result$data['penis_length'] = (l$penis_length as num?)?.toDouble();
    }
    if (data.containsKey('circumcised')) {
      final l$circumcised = data['circumcised'];
      result$data['circumcised'] = l$circumcised == null
          ? null
          : fromJson$Enum$CircumisedEnum((l$circumcised as String));
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
    if (data.containsKey('alias_list')) {
      final l$alias_list = data['alias_list'];
      result$data['alias_list'] =
          (l$alias_list as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('twitter')) {
      final l$twitter = data['twitter'];
      result$data['twitter'] = (l$twitter as String?);
    }
    if (data.containsKey('instagram')) {
      final l$instagram = data['instagram'];
      result$data['instagram'] = (l$instagram as String?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('image')) {
      final l$image = data['image'];
      result$data['image'] = (l$image as String?);
    }
    if (data.containsKey('stash_ids')) {
      final l$stash_ids = data['stash_ids'];
      result$data['stash_ids'] = (l$stash_ids as List<dynamic>?)
          ?.map((e) => Input$StashIDInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
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
      result$data['weight'] = (l$weight as int?);
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    return Input$PerformerCreateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  String? get disambiguation => (_$data['disambiguation'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  Enum$GenderEnum? get gender => (_$data['gender'] as Enum$GenderEnum?);

  String? get birthdate => (_$data['birthdate'] as String?);

  String? get ethnicity => (_$data['ethnicity'] as String?);

  String? get country => (_$data['country'] as String?);

  String? get eye_color => (_$data['eye_color'] as String?);

  int? get height_cm => (_$data['height_cm'] as int?);

  String? get measurements => (_$data['measurements'] as String?);

  String? get fake_tits => (_$data['fake_tits'] as String?);

  double? get penis_length => (_$data['penis_length'] as double?);

  Enum$CircumisedEnum? get circumcised =>
      (_$data['circumcised'] as Enum$CircumisedEnum?);

  String? get career_length => (_$data['career_length'] as String?);

  String? get tattoos => (_$data['tattoos'] as String?);

  String? get piercings => (_$data['piercings'] as String?);

  List<String>? get alias_list => (_$data['alias_list'] as List<String>?);

  String? get twitter => (_$data['twitter'] as String?);

  String? get instagram => (_$data['instagram'] as String?);

  bool? get favorite => (_$data['favorite'] as bool?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  String? get image => (_$data['image'] as String?);

  List<Input$StashIDInput>? get stash_ids =>
      (_$data['stash_ids'] as List<Input$StashIDInput>?);

  int? get rating100 => (_$data['rating100'] as int?);

  String? get details => (_$data['details'] as String?);

  String? get death_date => (_$data['death_date'] as String?);

  String? get hair_color => (_$data['hair_color'] as String?);

  int? get weight => (_$data['weight'] as int?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    if (_$data.containsKey('disambiguation')) {
      final l$disambiguation = disambiguation;
      result$data['disambiguation'] = l$disambiguation;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('gender')) {
      final l$gender = gender;
      result$data['gender'] =
          l$gender == null ? null : toJson$Enum$GenderEnum(l$gender);
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
    if (_$data.containsKey('height_cm')) {
      final l$height_cm = height_cm;
      result$data['height_cm'] = l$height_cm;
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
      result$data['circumcised'] = l$circumcised == null
          ? null
          : toJson$Enum$CircumisedEnum(l$circumcised);
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
    if (_$data.containsKey('alias_list')) {
      final l$alias_list = alias_list;
      result$data['alias_list'] = l$alias_list?.map((e) => e).toList();
    }
    if (_$data.containsKey('twitter')) {
      final l$twitter = twitter;
      result$data['twitter'] = l$twitter;
    }
    if (_$data.containsKey('instagram')) {
      final l$instagram = instagram;
      result$data['instagram'] = l$instagram;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('image')) {
      final l$image = image;
      result$data['image'] = l$image;
    }
    if (_$data.containsKey('stash_ids')) {
      final l$stash_ids = stash_ids;
      result$data['stash_ids'] = l$stash_ids?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
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
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    return result$data;
  }

  CopyWith$Input$PerformerCreateInput<Input$PerformerCreateInput>
      get copyWith => CopyWith$Input$PerformerCreateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$PerformerCreateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
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
    final l$gender = gender;
    final lOther$gender = other.gender;
    if (_$data.containsKey('gender') != other._$data.containsKey('gender')) {
      return false;
    }
    if (l$gender != lOther$gender) {
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
    final l$height_cm = height_cm;
    final lOther$height_cm = other.height_cm;
    if (_$data.containsKey('height_cm') !=
        other._$data.containsKey('height_cm')) {
      return false;
    }
    if (l$height_cm != lOther$height_cm) {
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
    final l$alias_list = alias_list;
    final lOther$alias_list = other.alias_list;
    if (_$data.containsKey('alias_list') !=
        other._$data.containsKey('alias_list')) {
      return false;
    }
    if (l$alias_list != null && lOther$alias_list != null) {
      if (l$alias_list.length != lOther$alias_list.length) {
        return false;
      }
      for (int i = 0; i < l$alias_list.length; i++) {
        final l$alias_list$entry = l$alias_list[i];
        final lOther$alias_list$entry = lOther$alias_list[i];
        if (l$alias_list$entry != lOther$alias_list$entry) {
          return false;
        }
      }
    } else if (l$alias_list != lOther$alias_list) {
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
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (_$data.containsKey('favorite') !=
        other._$data.containsKey('favorite')) {
      return false;
    }
    if (l$favorite != lOther$favorite) {
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
    final l$image = image;
    final lOther$image = other.image;
    if (_$data.containsKey('image') != other._$data.containsKey('image')) {
      return false;
    }
    if (l$image != lOther$image) {
      return false;
    }
    final l$stash_ids = stash_ids;
    final lOther$stash_ids = other.stash_ids;
    if (_$data.containsKey('stash_ids') !=
        other._$data.containsKey('stash_ids')) {
      return false;
    }
    if (l$stash_ids != null && lOther$stash_ids != null) {
      if (l$stash_ids.length != lOther$stash_ids.length) {
        return false;
      }
      for (int i = 0; i < l$stash_ids.length; i++) {
        final l$stash_ids$entry = l$stash_ids[i];
        final lOther$stash_ids$entry = lOther$stash_ids[i];
        if (l$stash_ids$entry != lOther$stash_ids$entry) {
          return false;
        }
      }
    } else if (l$stash_ids != lOther$stash_ids) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$disambiguation = disambiguation;
    final l$url = url;
    final l$urls = urls;
    final l$gender = gender;
    final l$birthdate = birthdate;
    final l$ethnicity = ethnicity;
    final l$country = country;
    final l$eye_color = eye_color;
    final l$height_cm = height_cm;
    final l$measurements = measurements;
    final l$fake_tits = fake_tits;
    final l$penis_length = penis_length;
    final l$circumcised = circumcised;
    final l$career_length = career_length;
    final l$tattoos = tattoos;
    final l$piercings = piercings;
    final l$alias_list = alias_list;
    final l$twitter = twitter;
    final l$instagram = instagram;
    final l$favorite = favorite;
    final l$tag_ids = tag_ids;
    final l$image = image;
    final l$stash_ids = stash_ids;
    final l$rating100 = rating100;
    final l$details = details;
    final l$death_date = death_date;
    final l$hair_color = hair_color;
    final l$weight = weight;
    final l$ignore_auto_tag = ignore_auto_tag;
    return Object.hashAll([
      l$name,
      _$data.containsKey('disambiguation') ? l$disambiguation : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('gender') ? l$gender : const {},
      _$data.containsKey('birthdate') ? l$birthdate : const {},
      _$data.containsKey('ethnicity') ? l$ethnicity : const {},
      _$data.containsKey('country') ? l$country : const {},
      _$data.containsKey('eye_color') ? l$eye_color : const {},
      _$data.containsKey('height_cm') ? l$height_cm : const {},
      _$data.containsKey('measurements') ? l$measurements : const {},
      _$data.containsKey('fake_tits') ? l$fake_tits : const {},
      _$data.containsKey('penis_length') ? l$penis_length : const {},
      _$data.containsKey('circumcised') ? l$circumcised : const {},
      _$data.containsKey('career_length') ? l$career_length : const {},
      _$data.containsKey('tattoos') ? l$tattoos : const {},
      _$data.containsKey('piercings') ? l$piercings : const {},
      _$data.containsKey('alias_list')
          ? l$alias_list == null
              ? null
              : Object.hashAll(l$alias_list.map((v) => v))
          : const {},
      _$data.containsKey('twitter') ? l$twitter : const {},
      _$data.containsKey('instagram') ? l$instagram : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('image') ? l$image : const {},
      _$data.containsKey('stash_ids')
          ? l$stash_ids == null
              ? null
              : Object.hashAll(l$stash_ids.map((v) => v))
          : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('death_date') ? l$death_date : const {},
      _$data.containsKey('hair_color') ? l$hair_color : const {},
      _$data.containsKey('weight') ? l$weight : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
    ]);
  }
}

abstract class CopyWith$Input$PerformerCreateInput<TRes> {
  factory CopyWith$Input$PerformerCreateInput(
    Input$PerformerCreateInput instance,
    TRes Function(Input$PerformerCreateInput) then,
  ) = _CopyWithImpl$Input$PerformerCreateInput;

  factory CopyWith$Input$PerformerCreateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PerformerCreateInput;

  TRes call({
    String? name,
    String? disambiguation,
    String? url,
    List<String>? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    List<String>? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    List<String>? tag_ids,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  });
}

class _CopyWithImpl$Input$PerformerCreateInput<TRes>
    implements CopyWith$Input$PerformerCreateInput<TRes> {
  _CopyWithImpl$Input$PerformerCreateInput(
    this._instance,
    this._then,
  );

  final Input$PerformerCreateInput _instance;

  final TRes Function(Input$PerformerCreateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? disambiguation = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? gender = _undefined,
    Object? birthdate = _undefined,
    Object? ethnicity = _undefined,
    Object? country = _undefined,
    Object? eye_color = _undefined,
    Object? height_cm = _undefined,
    Object? measurements = _undefined,
    Object? fake_tits = _undefined,
    Object? penis_length = _undefined,
    Object? circumcised = _undefined,
    Object? career_length = _undefined,
    Object? tattoos = _undefined,
    Object? piercings = _undefined,
    Object? alias_list = _undefined,
    Object? twitter = _undefined,
    Object? instagram = _undefined,
    Object? favorite = _undefined,
    Object? tag_ids = _undefined,
    Object? image = _undefined,
    Object? stash_ids = _undefined,
    Object? rating100 = _undefined,
    Object? details = _undefined,
    Object? death_date = _undefined,
    Object? hair_color = _undefined,
    Object? weight = _undefined,
    Object? ignore_auto_tag = _undefined,
  }) =>
      _then(Input$PerformerCreateInput._({
        ..._instance._$data,
        if (name != _undefined && name != null) 'name': (name as String),
        if (disambiguation != _undefined)
          'disambiguation': (disambiguation as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (gender != _undefined) 'gender': (gender as Enum$GenderEnum?),
        if (birthdate != _undefined) 'birthdate': (birthdate as String?),
        if (ethnicity != _undefined) 'ethnicity': (ethnicity as String?),
        if (country != _undefined) 'country': (country as String?),
        if (eye_color != _undefined) 'eye_color': (eye_color as String?),
        if (height_cm != _undefined) 'height_cm': (height_cm as int?),
        if (measurements != _undefined)
          'measurements': (measurements as String?),
        if (fake_tits != _undefined) 'fake_tits': (fake_tits as String?),
        if (penis_length != _undefined)
          'penis_length': (penis_length as double?),
        if (circumcised != _undefined)
          'circumcised': (circumcised as Enum$CircumisedEnum?),
        if (career_length != _undefined)
          'career_length': (career_length as String?),
        if (tattoos != _undefined) 'tattoos': (tattoos as String?),
        if (piercings != _undefined) 'piercings': (piercings as String?),
        if (alias_list != _undefined)
          'alias_list': (alias_list as List<String>?),
        if (twitter != _undefined) 'twitter': (twitter as String?),
        if (instagram != _undefined) 'instagram': (instagram as String?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (image != _undefined) 'image': (image as String?),
        if (stash_ids != _undefined)
          'stash_ids': (stash_ids as List<Input$StashIDInput>?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (details != _undefined) 'details': (details as String?),
        if (death_date != _undefined) 'death_date': (death_date as String?),
        if (hair_color != _undefined) 'hair_color': (hair_color as String?),
        if (weight != _undefined) 'weight': (weight as int?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
      }));
}

class _CopyWithStubImpl$Input$PerformerCreateInput<TRes>
    implements CopyWith$Input$PerformerCreateInput<TRes> {
  _CopyWithStubImpl$Input$PerformerCreateInput(this._res);

  TRes _res;

  call({
    String? name,
    String? disambiguation,
    String? url,
    List<String>? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    List<String>? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    List<String>? tag_ids,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  }) =>
      _res;
}

class Input$PerformerUpdateInput {
  factory Input$PerformerUpdateInput({
    required String id,
    String? name,
    String? disambiguation,
    String? url,
    List<String>? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    List<String>? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    List<String>? tag_ids,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  }) =>
      Input$PerformerUpdateInput._({
        r'id': id,
        if (name != null) r'name': name,
        if (disambiguation != null) r'disambiguation': disambiguation,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (gender != null) r'gender': gender,
        if (birthdate != null) r'birthdate': birthdate,
        if (ethnicity != null) r'ethnicity': ethnicity,
        if (country != null) r'country': country,
        if (eye_color != null) r'eye_color': eye_color,
        if (height_cm != null) r'height_cm': height_cm,
        if (measurements != null) r'measurements': measurements,
        if (fake_tits != null) r'fake_tits': fake_tits,
        if (penis_length != null) r'penis_length': penis_length,
        if (circumcised != null) r'circumcised': circumcised,
        if (career_length != null) r'career_length': career_length,
        if (tattoos != null) r'tattoos': tattoos,
        if (piercings != null) r'piercings': piercings,
        if (alias_list != null) r'alias_list': alias_list,
        if (twitter != null) r'twitter': twitter,
        if (instagram != null) r'instagram': instagram,
        if (favorite != null) r'favorite': favorite,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (image != null) r'image': image,
        if (stash_ids != null) r'stash_ids': stash_ids,
        if (rating100 != null) r'rating100': rating100,
        if (details != null) r'details': details,
        if (death_date != null) r'death_date': death_date,
        if (hair_color != null) r'hair_color': hair_color,
        if (weight != null) r'weight': weight,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
      });

  Input$PerformerUpdateInput._(this._$data);

  factory Input$PerformerUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('name')) {
      final l$name = data['name'];
      result$data['name'] = (l$name as String?);
    }
    if (data.containsKey('disambiguation')) {
      final l$disambiguation = data['disambiguation'];
      result$data['disambiguation'] = (l$disambiguation as String?);
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
    if (data.containsKey('gender')) {
      final l$gender = data['gender'];
      result$data['gender'] = l$gender == null
          ? null
          : fromJson$Enum$GenderEnum((l$gender as String));
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
    if (data.containsKey('height_cm')) {
      final l$height_cm = data['height_cm'];
      result$data['height_cm'] = (l$height_cm as int?);
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
      result$data['penis_length'] = (l$penis_length as num?)?.toDouble();
    }
    if (data.containsKey('circumcised')) {
      final l$circumcised = data['circumcised'];
      result$data['circumcised'] = l$circumcised == null
          ? null
          : fromJson$Enum$CircumisedEnum((l$circumcised as String));
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
    if (data.containsKey('alias_list')) {
      final l$alias_list = data['alias_list'];
      result$data['alias_list'] =
          (l$alias_list as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('twitter')) {
      final l$twitter = data['twitter'];
      result$data['twitter'] = (l$twitter as String?);
    }
    if (data.containsKey('instagram')) {
      final l$instagram = data['instagram'];
      result$data['instagram'] = (l$instagram as String?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] =
          (l$tag_ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('image')) {
      final l$image = data['image'];
      result$data['image'] = (l$image as String?);
    }
    if (data.containsKey('stash_ids')) {
      final l$stash_ids = data['stash_ids'];
      result$data['stash_ids'] = (l$stash_ids as List<dynamic>?)
          ?.map((e) => Input$StashIDInput.fromJson((e as Map<String, dynamic>)))
          .toList();
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
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
      result$data['weight'] = (l$weight as int?);
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    return Input$PerformerUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String? get name => (_$data['name'] as String?);

  String? get disambiguation => (_$data['disambiguation'] as String?);

  String? get url => (_$data['url'] as String?);

  List<String>? get urls => (_$data['urls'] as List<String>?);

  Enum$GenderEnum? get gender => (_$data['gender'] as Enum$GenderEnum?);

  String? get birthdate => (_$data['birthdate'] as String?);

  String? get ethnicity => (_$data['ethnicity'] as String?);

  String? get country => (_$data['country'] as String?);

  String? get eye_color => (_$data['eye_color'] as String?);

  int? get height_cm => (_$data['height_cm'] as int?);

  String? get measurements => (_$data['measurements'] as String?);

  String? get fake_tits => (_$data['fake_tits'] as String?);

  double? get penis_length => (_$data['penis_length'] as double?);

  Enum$CircumisedEnum? get circumcised =>
      (_$data['circumcised'] as Enum$CircumisedEnum?);

  String? get career_length => (_$data['career_length'] as String?);

  String? get tattoos => (_$data['tattoos'] as String?);

  String? get piercings => (_$data['piercings'] as String?);

  List<String>? get alias_list => (_$data['alias_list'] as List<String>?);

  String? get twitter => (_$data['twitter'] as String?);

  String? get instagram => (_$data['instagram'] as String?);

  bool? get favorite => (_$data['favorite'] as bool?);

  List<String>? get tag_ids => (_$data['tag_ids'] as List<String>?);

  String? get image => (_$data['image'] as String?);

  List<Input$StashIDInput>? get stash_ids =>
      (_$data['stash_ids'] as List<Input$StashIDInput>?);

  int? get rating100 => (_$data['rating100'] as int?);

  String? get details => (_$data['details'] as String?);

  String? get death_date => (_$data['death_date'] as String?);

  String? get hair_color => (_$data['hair_color'] as String?);

  int? get weight => (_$data['weight'] as int?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('name')) {
      final l$name = name;
      result$data['name'] = l$name;
    }
    if (_$data.containsKey('disambiguation')) {
      final l$disambiguation = disambiguation;
      result$data['disambiguation'] = l$disambiguation;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.map((e) => e).toList();
    }
    if (_$data.containsKey('gender')) {
      final l$gender = gender;
      result$data['gender'] =
          l$gender == null ? null : toJson$Enum$GenderEnum(l$gender);
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
    if (_$data.containsKey('height_cm')) {
      final l$height_cm = height_cm;
      result$data['height_cm'] = l$height_cm;
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
      result$data['circumcised'] = l$circumcised == null
          ? null
          : toJson$Enum$CircumisedEnum(l$circumcised);
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
    if (_$data.containsKey('alias_list')) {
      final l$alias_list = alias_list;
      result$data['alias_list'] = l$alias_list?.map((e) => e).toList();
    }
    if (_$data.containsKey('twitter')) {
      final l$twitter = twitter;
      result$data['twitter'] = l$twitter;
    }
    if (_$data.containsKey('instagram')) {
      final l$instagram = instagram;
      result$data['instagram'] = l$instagram;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('image')) {
      final l$image = image;
      result$data['image'] = l$image;
    }
    if (_$data.containsKey('stash_ids')) {
      final l$stash_ids = stash_ids;
      result$data['stash_ids'] = l$stash_ids?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
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
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    return result$data;
  }

  CopyWith$Input$PerformerUpdateInput<Input$PerformerUpdateInput>
      get copyWith => CopyWith$Input$PerformerUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$PerformerUpdateInput) ||
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
    final l$gender = gender;
    final lOther$gender = other.gender;
    if (_$data.containsKey('gender') != other._$data.containsKey('gender')) {
      return false;
    }
    if (l$gender != lOther$gender) {
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
    final l$height_cm = height_cm;
    final lOther$height_cm = other.height_cm;
    if (_$data.containsKey('height_cm') !=
        other._$data.containsKey('height_cm')) {
      return false;
    }
    if (l$height_cm != lOther$height_cm) {
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
    final l$alias_list = alias_list;
    final lOther$alias_list = other.alias_list;
    if (_$data.containsKey('alias_list') !=
        other._$data.containsKey('alias_list')) {
      return false;
    }
    if (l$alias_list != null && lOther$alias_list != null) {
      if (l$alias_list.length != lOther$alias_list.length) {
        return false;
      }
      for (int i = 0; i < l$alias_list.length; i++) {
        final l$alias_list$entry = l$alias_list[i];
        final lOther$alias_list$entry = lOther$alias_list[i];
        if (l$alias_list$entry != lOther$alias_list$entry) {
          return false;
        }
      }
    } else if (l$alias_list != lOther$alias_list) {
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
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (_$data.containsKey('favorite') !=
        other._$data.containsKey('favorite')) {
      return false;
    }
    if (l$favorite != lOther$favorite) {
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
    final l$image = image;
    final lOther$image = other.image;
    if (_$data.containsKey('image') != other._$data.containsKey('image')) {
      return false;
    }
    if (l$image != lOther$image) {
      return false;
    }
    final l$stash_ids = stash_ids;
    final lOther$stash_ids = other.stash_ids;
    if (_$data.containsKey('stash_ids') !=
        other._$data.containsKey('stash_ids')) {
      return false;
    }
    if (l$stash_ids != null && lOther$stash_ids != null) {
      if (l$stash_ids.length != lOther$stash_ids.length) {
        return false;
      }
      for (int i = 0; i < l$stash_ids.length; i++) {
        final l$stash_ids$entry = l$stash_ids[i];
        final lOther$stash_ids$entry = lOther$stash_ids[i];
        if (l$stash_ids$entry != lOther$stash_ids$entry) {
          return false;
        }
      }
    } else if (l$stash_ids != lOther$stash_ids) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$disambiguation = disambiguation;
    final l$url = url;
    final l$urls = urls;
    final l$gender = gender;
    final l$birthdate = birthdate;
    final l$ethnicity = ethnicity;
    final l$country = country;
    final l$eye_color = eye_color;
    final l$height_cm = height_cm;
    final l$measurements = measurements;
    final l$fake_tits = fake_tits;
    final l$penis_length = penis_length;
    final l$circumcised = circumcised;
    final l$career_length = career_length;
    final l$tattoos = tattoos;
    final l$piercings = piercings;
    final l$alias_list = alias_list;
    final l$twitter = twitter;
    final l$instagram = instagram;
    final l$favorite = favorite;
    final l$tag_ids = tag_ids;
    final l$image = image;
    final l$stash_ids = stash_ids;
    final l$rating100 = rating100;
    final l$details = details;
    final l$death_date = death_date;
    final l$hair_color = hair_color;
    final l$weight = weight;
    final l$ignore_auto_tag = ignore_auto_tag;
    return Object.hashAll([
      l$id,
      _$data.containsKey('name') ? l$name : const {},
      _$data.containsKey('disambiguation') ? l$disambiguation : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls')
          ? l$urls == null
              ? null
              : Object.hashAll(l$urls.map((v) => v))
          : const {},
      _$data.containsKey('gender') ? l$gender : const {},
      _$data.containsKey('birthdate') ? l$birthdate : const {},
      _$data.containsKey('ethnicity') ? l$ethnicity : const {},
      _$data.containsKey('country') ? l$country : const {},
      _$data.containsKey('eye_color') ? l$eye_color : const {},
      _$data.containsKey('height_cm') ? l$height_cm : const {},
      _$data.containsKey('measurements') ? l$measurements : const {},
      _$data.containsKey('fake_tits') ? l$fake_tits : const {},
      _$data.containsKey('penis_length') ? l$penis_length : const {},
      _$data.containsKey('circumcised') ? l$circumcised : const {},
      _$data.containsKey('career_length') ? l$career_length : const {},
      _$data.containsKey('tattoos') ? l$tattoos : const {},
      _$data.containsKey('piercings') ? l$piercings : const {},
      _$data.containsKey('alias_list')
          ? l$alias_list == null
              ? null
              : Object.hashAll(l$alias_list.map((v) => v))
          : const {},
      _$data.containsKey('twitter') ? l$twitter : const {},
      _$data.containsKey('instagram') ? l$instagram : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('tag_ids')
          ? l$tag_ids == null
              ? null
              : Object.hashAll(l$tag_ids.map((v) => v))
          : const {},
      _$data.containsKey('image') ? l$image : const {},
      _$data.containsKey('stash_ids')
          ? l$stash_ids == null
              ? null
              : Object.hashAll(l$stash_ids.map((v) => v))
          : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('death_date') ? l$death_date : const {},
      _$data.containsKey('hair_color') ? l$hair_color : const {},
      _$data.containsKey('weight') ? l$weight : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
    ]);
  }
}

abstract class CopyWith$Input$PerformerUpdateInput<TRes> {
  factory CopyWith$Input$PerformerUpdateInput(
    Input$PerformerUpdateInput instance,
    TRes Function(Input$PerformerUpdateInput) then,
  ) = _CopyWithImpl$Input$PerformerUpdateInput;

  factory CopyWith$Input$PerformerUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PerformerUpdateInput;

  TRes call({
    String? id,
    String? name,
    String? disambiguation,
    String? url,
    List<String>? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    List<String>? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    List<String>? tag_ids,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  });
}

class _CopyWithImpl$Input$PerformerUpdateInput<TRes>
    implements CopyWith$Input$PerformerUpdateInput<TRes> {
  _CopyWithImpl$Input$PerformerUpdateInput(
    this._instance,
    this._then,
  );

  final Input$PerformerUpdateInput _instance;

  final TRes Function(Input$PerformerUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? disambiguation = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? gender = _undefined,
    Object? birthdate = _undefined,
    Object? ethnicity = _undefined,
    Object? country = _undefined,
    Object? eye_color = _undefined,
    Object? height_cm = _undefined,
    Object? measurements = _undefined,
    Object? fake_tits = _undefined,
    Object? penis_length = _undefined,
    Object? circumcised = _undefined,
    Object? career_length = _undefined,
    Object? tattoos = _undefined,
    Object? piercings = _undefined,
    Object? alias_list = _undefined,
    Object? twitter = _undefined,
    Object? instagram = _undefined,
    Object? favorite = _undefined,
    Object? tag_ids = _undefined,
    Object? image = _undefined,
    Object? stash_ids = _undefined,
    Object? rating100 = _undefined,
    Object? details = _undefined,
    Object? death_date = _undefined,
    Object? hair_color = _undefined,
    Object? weight = _undefined,
    Object? ignore_auto_tag = _undefined,
  }) =>
      _then(Input$PerformerUpdateInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (name != _undefined) 'name': (name as String?),
        if (disambiguation != _undefined)
          'disambiguation': (disambiguation as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as List<String>?),
        if (gender != _undefined) 'gender': (gender as Enum$GenderEnum?),
        if (birthdate != _undefined) 'birthdate': (birthdate as String?),
        if (ethnicity != _undefined) 'ethnicity': (ethnicity as String?),
        if (country != _undefined) 'country': (country as String?),
        if (eye_color != _undefined) 'eye_color': (eye_color as String?),
        if (height_cm != _undefined) 'height_cm': (height_cm as int?),
        if (measurements != _undefined)
          'measurements': (measurements as String?),
        if (fake_tits != _undefined) 'fake_tits': (fake_tits as String?),
        if (penis_length != _undefined)
          'penis_length': (penis_length as double?),
        if (circumcised != _undefined)
          'circumcised': (circumcised as Enum$CircumisedEnum?),
        if (career_length != _undefined)
          'career_length': (career_length as String?),
        if (tattoos != _undefined) 'tattoos': (tattoos as String?),
        if (piercings != _undefined) 'piercings': (piercings as String?),
        if (alias_list != _undefined)
          'alias_list': (alias_list as List<String>?),
        if (twitter != _undefined) 'twitter': (twitter as String?),
        if (instagram != _undefined) 'instagram': (instagram as String?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as List<String>?),
        if (image != _undefined) 'image': (image as String?),
        if (stash_ids != _undefined)
          'stash_ids': (stash_ids as List<Input$StashIDInput>?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (details != _undefined) 'details': (details as String?),
        if (death_date != _undefined) 'death_date': (death_date as String?),
        if (hair_color != _undefined) 'hair_color': (hair_color as String?),
        if (weight != _undefined) 'weight': (weight as int?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
      }));
}

class _CopyWithStubImpl$Input$PerformerUpdateInput<TRes>
    implements CopyWith$Input$PerformerUpdateInput<TRes> {
  _CopyWithStubImpl$Input$PerformerUpdateInput(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? disambiguation,
    String? url,
    List<String>? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    List<String>? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    List<String>? tag_ids,
    String? image,
    List<Input$StashIDInput>? stash_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  }) =>
      _res;
}

class Input$BulkUpdateStrings {
  factory Input$BulkUpdateStrings({
    List<String>? values,
    required Enum$BulkUpdateIdMode mode,
  }) =>
      Input$BulkUpdateStrings._({
        if (values != null) r'values': values,
        r'mode': mode,
      });

  Input$BulkUpdateStrings._(this._$data);

  factory Input$BulkUpdateStrings.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('values')) {
      final l$values = data['values'];
      result$data['values'] =
          (l$values as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    final l$mode = data['mode'];
    result$data['mode'] = fromJson$Enum$BulkUpdateIdMode((l$mode as String));
    return Input$BulkUpdateStrings._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String>? get values => (_$data['values'] as List<String>?);

  Enum$BulkUpdateIdMode get mode => (_$data['mode'] as Enum$BulkUpdateIdMode);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('values')) {
      final l$values = values;
      result$data['values'] = l$values?.map((e) => e).toList();
    }
    final l$mode = mode;
    result$data['mode'] = toJson$Enum$BulkUpdateIdMode(l$mode);
    return result$data;
  }

  CopyWith$Input$BulkUpdateStrings<Input$BulkUpdateStrings> get copyWith =>
      CopyWith$Input$BulkUpdateStrings(
        this,
        (i) => i,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkUpdateStrings) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$values = values;
    final lOther$values = other.values;
    if (_$data.containsKey('values') != other._$data.containsKey('values')) {
      return false;
    }
    if (l$values != null && lOther$values != null) {
      if (l$values.length != lOther$values.length) {
        return false;
      }
      for (int i = 0; i < l$values.length; i++) {
        final l$values$entry = l$values[i];
        final lOther$values$entry = lOther$values[i];
        if (l$values$entry != lOther$values$entry) {
          return false;
        }
      }
    } else if (l$values != lOther$values) {
      return false;
    }
    final l$mode = mode;
    final lOther$mode = other.mode;
    if (l$mode != lOther$mode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$values = values;
    final l$mode = mode;
    return Object.hashAll([
      _$data.containsKey('values')
          ? l$values == null
              ? null
              : Object.hashAll(l$values.map((v) => v))
          : const {},
      l$mode,
    ]);
  }
}

abstract class CopyWith$Input$BulkUpdateStrings<TRes> {
  factory CopyWith$Input$BulkUpdateStrings(
    Input$BulkUpdateStrings instance,
    TRes Function(Input$BulkUpdateStrings) then,
  ) = _CopyWithImpl$Input$BulkUpdateStrings;

  factory CopyWith$Input$BulkUpdateStrings.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkUpdateStrings;

  TRes call({
    List<String>? values,
    Enum$BulkUpdateIdMode? mode,
  });
}

class _CopyWithImpl$Input$BulkUpdateStrings<TRes>
    implements CopyWith$Input$BulkUpdateStrings<TRes> {
  _CopyWithImpl$Input$BulkUpdateStrings(
    this._instance,
    this._then,
  );

  final Input$BulkUpdateStrings _instance;

  final TRes Function(Input$BulkUpdateStrings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? values = _undefined,
    Object? mode = _undefined,
  }) =>
      _then(Input$BulkUpdateStrings._({
        ..._instance._$data,
        if (values != _undefined) 'values': (values as List<String>?),
        if (mode != _undefined && mode != null)
          'mode': (mode as Enum$BulkUpdateIdMode),
      }));
}

class _CopyWithStubImpl$Input$BulkUpdateStrings<TRes>
    implements CopyWith$Input$BulkUpdateStrings<TRes> {
  _CopyWithStubImpl$Input$BulkUpdateStrings(this._res);

  TRes _res;

  call({
    List<String>? values,
    Enum$BulkUpdateIdMode? mode,
  }) =>
      _res;
}

class Input$BulkPerformerUpdateInput {
  factory Input$BulkPerformerUpdateInput({
    String? clientMutationId,
    List<String>? ids,
    String? disambiguation,
    String? url,
    Input$BulkUpdateStrings? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    Input$BulkUpdateStrings? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    Input$BulkUpdateIds? tag_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  }) =>
      Input$BulkPerformerUpdateInput._({
        if (clientMutationId != null) r'clientMutationId': clientMutationId,
        if (ids != null) r'ids': ids,
        if (disambiguation != null) r'disambiguation': disambiguation,
        if (url != null) r'url': url,
        if (urls != null) r'urls': urls,
        if (gender != null) r'gender': gender,
        if (birthdate != null) r'birthdate': birthdate,
        if (ethnicity != null) r'ethnicity': ethnicity,
        if (country != null) r'country': country,
        if (eye_color != null) r'eye_color': eye_color,
        if (height_cm != null) r'height_cm': height_cm,
        if (measurements != null) r'measurements': measurements,
        if (fake_tits != null) r'fake_tits': fake_tits,
        if (penis_length != null) r'penis_length': penis_length,
        if (circumcised != null) r'circumcised': circumcised,
        if (career_length != null) r'career_length': career_length,
        if (tattoos != null) r'tattoos': tattoos,
        if (piercings != null) r'piercings': piercings,
        if (alias_list != null) r'alias_list': alias_list,
        if (twitter != null) r'twitter': twitter,
        if (instagram != null) r'instagram': instagram,
        if (favorite != null) r'favorite': favorite,
        if (tag_ids != null) r'tag_ids': tag_ids,
        if (rating100 != null) r'rating100': rating100,
        if (details != null) r'details': details,
        if (death_date != null) r'death_date': death_date,
        if (hair_color != null) r'hair_color': hair_color,
        if (weight != null) r'weight': weight,
        if (ignore_auto_tag != null) r'ignore_auto_tag': ignore_auto_tag,
      });

  Input$BulkPerformerUpdateInput._(this._$data);

  factory Input$BulkPerformerUpdateInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('clientMutationId')) {
      final l$clientMutationId = data['clientMutationId'];
      result$data['clientMutationId'] = (l$clientMutationId as String?);
    }
    if (data.containsKey('ids')) {
      final l$ids = data['ids'];
      result$data['ids'] =
          (l$ids as List<dynamic>?)?.map((e) => (e as String)).toList();
    }
    if (data.containsKey('disambiguation')) {
      final l$disambiguation = data['disambiguation'];
      result$data['disambiguation'] = (l$disambiguation as String?);
    }
    if (data.containsKey('url')) {
      final l$url = data['url'];
      result$data['url'] = (l$url as String?);
    }
    if (data.containsKey('urls')) {
      final l$urls = data['urls'];
      result$data['urls'] = l$urls == null
          ? null
          : Input$BulkUpdateStrings.fromJson((l$urls as Map<String, dynamic>));
    }
    if (data.containsKey('gender')) {
      final l$gender = data['gender'];
      result$data['gender'] = l$gender == null
          ? null
          : fromJson$Enum$GenderEnum((l$gender as String));
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
    if (data.containsKey('height_cm')) {
      final l$height_cm = data['height_cm'];
      result$data['height_cm'] = (l$height_cm as int?);
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
      result$data['penis_length'] = (l$penis_length as num?)?.toDouble();
    }
    if (data.containsKey('circumcised')) {
      final l$circumcised = data['circumcised'];
      result$data['circumcised'] = l$circumcised == null
          ? null
          : fromJson$Enum$CircumisedEnum((l$circumcised as String));
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
    if (data.containsKey('alias_list')) {
      final l$alias_list = data['alias_list'];
      result$data['alias_list'] = l$alias_list == null
          ? null
          : Input$BulkUpdateStrings.fromJson(
              (l$alias_list as Map<String, dynamic>));
    }
    if (data.containsKey('twitter')) {
      final l$twitter = data['twitter'];
      result$data['twitter'] = (l$twitter as String?);
    }
    if (data.containsKey('instagram')) {
      final l$instagram = data['instagram'];
      result$data['instagram'] = (l$instagram as String?);
    }
    if (data.containsKey('favorite')) {
      final l$favorite = data['favorite'];
      result$data['favorite'] = (l$favorite as bool?);
    }
    if (data.containsKey('tag_ids')) {
      final l$tag_ids = data['tag_ids'];
      result$data['tag_ids'] = l$tag_ids == null
          ? null
          : Input$BulkUpdateIds.fromJson((l$tag_ids as Map<String, dynamic>));
    }
    if (data.containsKey('rating100')) {
      final l$rating100 = data['rating100'];
      result$data['rating100'] = (l$rating100 as int?);
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
      result$data['weight'] = (l$weight as int?);
    }
    if (data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = data['ignore_auto_tag'];
      result$data['ignore_auto_tag'] = (l$ignore_auto_tag as bool?);
    }
    return Input$BulkPerformerUpdateInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get clientMutationId => (_$data['clientMutationId'] as String?);

  List<String>? get ids => (_$data['ids'] as List<String>?);

  String? get disambiguation => (_$data['disambiguation'] as String?);

  String? get url => (_$data['url'] as String?);

  Input$BulkUpdateStrings? get urls =>
      (_$data['urls'] as Input$BulkUpdateStrings?);

  Enum$GenderEnum? get gender => (_$data['gender'] as Enum$GenderEnum?);

  String? get birthdate => (_$data['birthdate'] as String?);

  String? get ethnicity => (_$data['ethnicity'] as String?);

  String? get country => (_$data['country'] as String?);

  String? get eye_color => (_$data['eye_color'] as String?);

  int? get height_cm => (_$data['height_cm'] as int?);

  String? get measurements => (_$data['measurements'] as String?);

  String? get fake_tits => (_$data['fake_tits'] as String?);

  double? get penis_length => (_$data['penis_length'] as double?);

  Enum$CircumisedEnum? get circumcised =>
      (_$data['circumcised'] as Enum$CircumisedEnum?);

  String? get career_length => (_$data['career_length'] as String?);

  String? get tattoos => (_$data['tattoos'] as String?);

  String? get piercings => (_$data['piercings'] as String?);

  Input$BulkUpdateStrings? get alias_list =>
      (_$data['alias_list'] as Input$BulkUpdateStrings?);

  String? get twitter => (_$data['twitter'] as String?);

  String? get instagram => (_$data['instagram'] as String?);

  bool? get favorite => (_$data['favorite'] as bool?);

  Input$BulkUpdateIds? get tag_ids =>
      (_$data['tag_ids'] as Input$BulkUpdateIds?);

  int? get rating100 => (_$data['rating100'] as int?);

  String? get details => (_$data['details'] as String?);

  String? get death_date => (_$data['death_date'] as String?);

  String? get hair_color => (_$data['hair_color'] as String?);

  int? get weight => (_$data['weight'] as int?);

  bool? get ignore_auto_tag => (_$data['ignore_auto_tag'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('clientMutationId')) {
      final l$clientMutationId = clientMutationId;
      result$data['clientMutationId'] = l$clientMutationId;
    }
    if (_$data.containsKey('ids')) {
      final l$ids = ids;
      result$data['ids'] = l$ids?.map((e) => e).toList();
    }
    if (_$data.containsKey('disambiguation')) {
      final l$disambiguation = disambiguation;
      result$data['disambiguation'] = l$disambiguation;
    }
    if (_$data.containsKey('url')) {
      final l$url = url;
      result$data['url'] = l$url;
    }
    if (_$data.containsKey('urls')) {
      final l$urls = urls;
      result$data['urls'] = l$urls?.toJson();
    }
    if (_$data.containsKey('gender')) {
      final l$gender = gender;
      result$data['gender'] =
          l$gender == null ? null : toJson$Enum$GenderEnum(l$gender);
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
    if (_$data.containsKey('height_cm')) {
      final l$height_cm = height_cm;
      result$data['height_cm'] = l$height_cm;
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
      result$data['circumcised'] = l$circumcised == null
          ? null
          : toJson$Enum$CircumisedEnum(l$circumcised);
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
    if (_$data.containsKey('alias_list')) {
      final l$alias_list = alias_list;
      result$data['alias_list'] = l$alias_list?.toJson();
    }
    if (_$data.containsKey('twitter')) {
      final l$twitter = twitter;
      result$data['twitter'] = l$twitter;
    }
    if (_$data.containsKey('instagram')) {
      final l$instagram = instagram;
      result$data['instagram'] = l$instagram;
    }
    if (_$data.containsKey('favorite')) {
      final l$favorite = favorite;
      result$data['favorite'] = l$favorite;
    }
    if (_$data.containsKey('tag_ids')) {
      final l$tag_ids = tag_ids;
      result$data['tag_ids'] = l$tag_ids?.toJson();
    }
    if (_$data.containsKey('rating100')) {
      final l$rating100 = rating100;
      result$data['rating100'] = l$rating100;
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
    if (_$data.containsKey('ignore_auto_tag')) {
      final l$ignore_auto_tag = ignore_auto_tag;
      result$data['ignore_auto_tag'] = l$ignore_auto_tag;
    }
    return result$data;
  }

  CopyWith$Input$BulkPerformerUpdateInput<Input$BulkPerformerUpdateInput>
      get copyWith => CopyWith$Input$BulkPerformerUpdateInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$BulkPerformerUpdateInput) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$clientMutationId = clientMutationId;
    final lOther$clientMutationId = other.clientMutationId;
    if (_$data.containsKey('clientMutationId') !=
        other._$data.containsKey('clientMutationId')) {
      return false;
    }
    if (l$clientMutationId != lOther$clientMutationId) {
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
    final l$disambiguation = disambiguation;
    final lOther$disambiguation = other.disambiguation;
    if (_$data.containsKey('disambiguation') !=
        other._$data.containsKey('disambiguation')) {
      return false;
    }
    if (l$disambiguation != lOther$disambiguation) {
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
    if (l$urls != lOther$urls) {
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
    final l$height_cm = height_cm;
    final lOther$height_cm = other.height_cm;
    if (_$data.containsKey('height_cm') !=
        other._$data.containsKey('height_cm')) {
      return false;
    }
    if (l$height_cm != lOther$height_cm) {
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
    final l$alias_list = alias_list;
    final lOther$alias_list = other.alias_list;
    if (_$data.containsKey('alias_list') !=
        other._$data.containsKey('alias_list')) {
      return false;
    }
    if (l$alias_list != lOther$alias_list) {
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
    final l$favorite = favorite;
    final lOther$favorite = other.favorite;
    if (_$data.containsKey('favorite') !=
        other._$data.containsKey('favorite')) {
      return false;
    }
    if (l$favorite != lOther$favorite) {
      return false;
    }
    final l$tag_ids = tag_ids;
    final lOther$tag_ids = other.tag_ids;
    if (_$data.containsKey('tag_ids') != other._$data.containsKey('tag_ids')) {
      return false;
    }
    if (l$tag_ids != lOther$tag_ids) {
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
    final l$ignore_auto_tag = ignore_auto_tag;
    final lOther$ignore_auto_tag = other.ignore_auto_tag;
    if (_$data.containsKey('ignore_auto_tag') !=
        other._$data.containsKey('ignore_auto_tag')) {
      return false;
    }
    if (l$ignore_auto_tag != lOther$ignore_auto_tag) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$clientMutationId = clientMutationId;
    final l$ids = ids;
    final l$disambiguation = disambiguation;
    final l$url = url;
    final l$urls = urls;
    final l$gender = gender;
    final l$birthdate = birthdate;
    final l$ethnicity = ethnicity;
    final l$country = country;
    final l$eye_color = eye_color;
    final l$height_cm = height_cm;
    final l$measurements = measurements;
    final l$fake_tits = fake_tits;
    final l$penis_length = penis_length;
    final l$circumcised = circumcised;
    final l$career_length = career_length;
    final l$tattoos = tattoos;
    final l$piercings = piercings;
    final l$alias_list = alias_list;
    final l$twitter = twitter;
    final l$instagram = instagram;
    final l$favorite = favorite;
    final l$tag_ids = tag_ids;
    final l$rating100 = rating100;
    final l$details = details;
    final l$death_date = death_date;
    final l$hair_color = hair_color;
    final l$weight = weight;
    final l$ignore_auto_tag = ignore_auto_tag;
    return Object.hashAll([
      _$data.containsKey('clientMutationId') ? l$clientMutationId : const {},
      _$data.containsKey('ids')
          ? l$ids == null
              ? null
              : Object.hashAll(l$ids.map((v) => v))
          : const {},
      _$data.containsKey('disambiguation') ? l$disambiguation : const {},
      _$data.containsKey('url') ? l$url : const {},
      _$data.containsKey('urls') ? l$urls : const {},
      _$data.containsKey('gender') ? l$gender : const {},
      _$data.containsKey('birthdate') ? l$birthdate : const {},
      _$data.containsKey('ethnicity') ? l$ethnicity : const {},
      _$data.containsKey('country') ? l$country : const {},
      _$data.containsKey('eye_color') ? l$eye_color : const {},
      _$data.containsKey('height_cm') ? l$height_cm : const {},
      _$data.containsKey('measurements') ? l$measurements : const {},
      _$data.containsKey('fake_tits') ? l$fake_tits : const {},
      _$data.containsKey('penis_length') ? l$penis_length : const {},
      _$data.containsKey('circumcised') ? l$circumcised : const {},
      _$data.containsKey('career_length') ? l$career_length : const {},
      _$data.containsKey('tattoos') ? l$tattoos : const {},
      _$data.containsKey('piercings') ? l$piercings : const {},
      _$data.containsKey('alias_list') ? l$alias_list : const {},
      _$data.containsKey('twitter') ? l$twitter : const {},
      _$data.containsKey('instagram') ? l$instagram : const {},
      _$data.containsKey('favorite') ? l$favorite : const {},
      _$data.containsKey('tag_ids') ? l$tag_ids : const {},
      _$data.containsKey('rating100') ? l$rating100 : const {},
      _$data.containsKey('details') ? l$details : const {},
      _$data.containsKey('death_date') ? l$death_date : const {},
      _$data.containsKey('hair_color') ? l$hair_color : const {},
      _$data.containsKey('weight') ? l$weight : const {},
      _$data.containsKey('ignore_auto_tag') ? l$ignore_auto_tag : const {},
    ]);
  }
}

abstract class CopyWith$Input$BulkPerformerUpdateInput<TRes> {
  factory CopyWith$Input$BulkPerformerUpdateInput(
    Input$BulkPerformerUpdateInput instance,
    TRes Function(Input$BulkPerformerUpdateInput) then,
  ) = _CopyWithImpl$Input$BulkPerformerUpdateInput;

  factory CopyWith$Input$BulkPerformerUpdateInput.stub(TRes res) =
      _CopyWithStubImpl$Input$BulkPerformerUpdateInput;

  TRes call({
    String? clientMutationId,
    List<String>? ids,
    String? disambiguation,
    String? url,
    Input$BulkUpdateStrings? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    Input$BulkUpdateStrings? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    Input$BulkUpdateIds? tag_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  });
  CopyWith$Input$BulkUpdateStrings<TRes> get urls;
  CopyWith$Input$BulkUpdateStrings<TRes> get alias_list;
}

class _CopyWithImpl$Input$BulkPerformerUpdateInput<TRes>
    implements CopyWith$Input$BulkPerformerUpdateInput<TRes> {
  _CopyWithImpl$Input$BulkPerformerUpdateInput(
    this._instance,
    this._then,
  );

  final Input$BulkPerformerUpdateInput _instance;

  final TRes Function(Input$BulkPerformerUpdateInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clientMutationId = _undefined,
    Object? ids = _undefined,
    Object? disambiguation = _undefined,
    Object? url = _undefined,
    Object? urls = _undefined,
    Object? gender = _undefined,
    Object? birthdate = _undefined,
    Object? ethnicity = _undefined,
    Object? country = _undefined,
    Object? eye_color = _undefined,
    Object? height_cm = _undefined,
    Object? measurements = _undefined,
    Object? fake_tits = _undefined,
    Object? penis_length = _undefined,
    Object? circumcised = _undefined,
    Object? career_length = _undefined,
    Object? tattoos = _undefined,
    Object? piercings = _undefined,
    Object? alias_list = _undefined,
    Object? twitter = _undefined,
    Object? instagram = _undefined,
    Object? favorite = _undefined,
    Object? tag_ids = _undefined,
    Object? rating100 = _undefined,
    Object? details = _undefined,
    Object? death_date = _undefined,
    Object? hair_color = _undefined,
    Object? weight = _undefined,
    Object? ignore_auto_tag = _undefined,
  }) =>
      _then(Input$BulkPerformerUpdateInput._({
        ..._instance._$data,
        if (clientMutationId != _undefined)
          'clientMutationId': (clientMutationId as String?),
        if (ids != _undefined) 'ids': (ids as List<String>?),
        if (disambiguation != _undefined)
          'disambiguation': (disambiguation as String?),
        if (url != _undefined) 'url': (url as String?),
        if (urls != _undefined) 'urls': (urls as Input$BulkUpdateStrings?),
        if (gender != _undefined) 'gender': (gender as Enum$GenderEnum?),
        if (birthdate != _undefined) 'birthdate': (birthdate as String?),
        if (ethnicity != _undefined) 'ethnicity': (ethnicity as String?),
        if (country != _undefined) 'country': (country as String?),
        if (eye_color != _undefined) 'eye_color': (eye_color as String?),
        if (height_cm != _undefined) 'height_cm': (height_cm as int?),
        if (measurements != _undefined)
          'measurements': (measurements as String?),
        if (fake_tits != _undefined) 'fake_tits': (fake_tits as String?),
        if (penis_length != _undefined)
          'penis_length': (penis_length as double?),
        if (circumcised != _undefined)
          'circumcised': (circumcised as Enum$CircumisedEnum?),
        if (career_length != _undefined)
          'career_length': (career_length as String?),
        if (tattoos != _undefined) 'tattoos': (tattoos as String?),
        if (piercings != _undefined) 'piercings': (piercings as String?),
        if (alias_list != _undefined)
          'alias_list': (alias_list as Input$BulkUpdateStrings?),
        if (twitter != _undefined) 'twitter': (twitter as String?),
        if (instagram != _undefined) 'instagram': (instagram as String?),
        if (favorite != _undefined) 'favorite': (favorite as bool?),
        if (tag_ids != _undefined) 'tag_ids': (tag_ids as Input$BulkUpdateIds?),
        if (rating100 != _undefined) 'rating100': (rating100 as int?),
        if (details != _undefined) 'details': (details as String?),
        if (death_date != _undefined) 'death_date': (death_date as String?),
        if (hair_color != _undefined) 'hair_color': (hair_color as String?),
        if (weight != _undefined) 'weight': (weight as int?),
        if (ignore_auto_tag != _undefined)
          'ignore_auto_tag': (ignore_auto_tag as bool?),
      }));

  CopyWith$Input$BulkUpdateStrings<TRes> get urls {
    final local$urls = _instance.urls;
    return local$urls == null
        ? CopyWith$Input$BulkUpdateStrings.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateStrings(local$urls, (e) => call(urls: e));
  }

  CopyWith$Input$BulkUpdateStrings<TRes> get alias_list {
    final local$alias_list = _instance.alias_list;
    return local$alias_list == null
        ? CopyWith$Input$BulkUpdateStrings.stub(_then(_instance))
        : CopyWith$Input$BulkUpdateStrings(
            local$alias_list, (e) => call(alias_list: e));
  }
}

class _CopyWithStubImpl$Input$BulkPerformerUpdateInput<TRes>
    implements CopyWith$Input$BulkPerformerUpdateInput<TRes> {
  _CopyWithStubImpl$Input$BulkPerformerUpdateInput(this._res);

  TRes _res;

  call({
    String? clientMutationId,
    List<String>? ids,
    String? disambiguation,
    String? url,
    Input$BulkUpdateStrings? urls,
    Enum$GenderEnum? gender,
    String? birthdate,
    String? ethnicity,
    String? country,
    String? eye_color,
    int? height_cm,
    String? measurements,
    String? fake_tits,
    double? penis_length,
    Enum$CircumisedEnum? circumcised,
    String? career_length,
    String? tattoos,
    String? piercings,
    Input$BulkUpdateStrings? alias_list,
    String? twitter,
    String? instagram,
    bool? favorite,
    Input$BulkUpdateIds? tag_ids,
    int? rating100,
    String? details,
    String? death_date,
    String? hair_color,
    int? weight,
    bool? ignore_auto_tag,
  }) =>
      _res;

  CopyWith$Input$BulkUpdateStrings<TRes> get urls =>
      CopyWith$Input$BulkUpdateStrings.stub(_res);

  CopyWith$Input$BulkUpdateStrings<TRes> get alias_list =>
      CopyWith$Input$BulkUpdateStrings.stub(_res);
}

class Input$PerformerDestroyInput {
  factory Input$PerformerDestroyInput({required String id}) =>
      Input$PerformerDestroyInput._({
        r'id': id,
      });

  Input$PerformerDestroyInput._(this._$data);

  factory Input$PerformerDestroyInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Input$PerformerDestroyInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Input$PerformerDestroyInput<Input$PerformerDestroyInput>
      get copyWith => CopyWith$Input$PerformerDestroyInput(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$PerformerDestroyInput) ||
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

abstract class CopyWith$Input$PerformerDestroyInput<TRes> {
  factory CopyWith$Input$PerformerDestroyInput(
    Input$PerformerDestroyInput instance,
    TRes Function(Input$PerformerDestroyInput) then,
  ) = _CopyWithImpl$Input$PerformerDestroyInput;

  factory CopyWith$Input$PerformerDestroyInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PerformerDestroyInput;

  TRes call({String? id});
}

class _CopyWithImpl$Input$PerformerDestroyInput<TRes>
    implements CopyWith$Input$PerformerDestroyInput<TRes> {
  _CopyWithImpl$Input$PerformerDestroyInput(
    this._instance,
    this._then,
  );

  final Input$PerformerDestroyInput _instance;

  final TRes Function(Input$PerformerDestroyInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Input$PerformerDestroyInput._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Input$PerformerDestroyInput<TRes>
    implements CopyWith$Input$PerformerDestroyInput<TRes> {
  _CopyWithStubImpl$Input$PerformerDestroyInput(this._res);

  TRes _res;

  call({String? id}) => _res;
}

enum Enum$GenderEnum {
  MALE,
  FEMALE,
  TRANSGENDER_MALE,
  TRANSGENDER_FEMALE,
  INTERSEX,
  NON_BINARY,
  $unknown;

  factory Enum$GenderEnum.fromJson(String value) =>
      fromJson$Enum$GenderEnum(value);

  String toJson() => toJson$Enum$GenderEnum(this);
}

String toJson$Enum$GenderEnum(Enum$GenderEnum e) {
  switch (e) {
    case Enum$GenderEnum.MALE:
      return r'MALE';
    case Enum$GenderEnum.FEMALE:
      return r'FEMALE';
    case Enum$GenderEnum.TRANSGENDER_MALE:
      return r'TRANSGENDER_MALE';
    case Enum$GenderEnum.TRANSGENDER_FEMALE:
      return r'TRANSGENDER_FEMALE';
    case Enum$GenderEnum.INTERSEX:
      return r'INTERSEX';
    case Enum$GenderEnum.NON_BINARY:
      return r'NON_BINARY';
    case Enum$GenderEnum.$unknown:
      return r'$unknown';
  }
}

Enum$GenderEnum fromJson$Enum$GenderEnum(String value) {
  switch (value) {
    case r'MALE':
      return Enum$GenderEnum.MALE;
    case r'FEMALE':
      return Enum$GenderEnum.FEMALE;
    case r'TRANSGENDER_MALE':
      return Enum$GenderEnum.TRANSGENDER_MALE;
    case r'TRANSGENDER_FEMALE':
      return Enum$GenderEnum.TRANSGENDER_FEMALE;
    case r'INTERSEX':
      return Enum$GenderEnum.INTERSEX;
    case r'NON_BINARY':
      return Enum$GenderEnum.NON_BINARY;
    default:
      return Enum$GenderEnum.$unknown;
  }
}

enum Enum$CircumisedEnum {
  CUT,
  UNCUT,
  $unknown;

  factory Enum$CircumisedEnum.fromJson(String value) =>
      fromJson$Enum$CircumisedEnum(value);

  String toJson() => toJson$Enum$CircumisedEnum(this);
}

String toJson$Enum$CircumisedEnum(Enum$CircumisedEnum e) {
  switch (e) {
    case Enum$CircumisedEnum.CUT:
      return r'CUT';
    case Enum$CircumisedEnum.UNCUT:
      return r'UNCUT';
    case Enum$CircumisedEnum.$unknown:
      return r'$unknown';
  }
}

Enum$CircumisedEnum fromJson$Enum$CircumisedEnum(String value) {
  switch (value) {
    case r'CUT':
      return Enum$CircumisedEnum.CUT;
    case r'UNCUT':
      return Enum$CircumisedEnum.UNCUT;
    default:
      return Enum$CircumisedEnum.$unknown;
  }
}
