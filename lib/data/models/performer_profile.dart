import 'json.dart';
import '../../core/api/documents/performers.graphql.dart';
import '../../core/api/documents/studios.graphql.dart';

/// How many images and galleries a performer or studio has; their channel
/// shows those tabs only when there are any.
class ChannelMediaCounts {
  const ChannelMediaCounts({this.images = 0, this.galleries = 0});

  final int images;
  final int galleries;

  factory ChannelMediaCounts.fromStudio(Query$StudioMediaCounts$findStudio s) =>
      ChannelMediaCounts(images: s.image_count, galleries: s.gallery_count);
}

/// A performer's details for their channel's about tab (CH-2), loaded
/// separately from [Performer].
class PerformerProfile {
  const PerformerProfile({
    this.aliases = const [],
    this.deathDate,
    this.ethnicity,
    this.hairColor,
    this.eyeColor,
    this.heightCm,
    this.weightKg,
    this.measurements,
    this.career,
    this.tattoos,
    this.piercings,
    this.counts = const ChannelMediaCounts(),
  });

  final List<String> aliases;
  final DateTime? deathDate;
  final String? ethnicity;
  final String? hairColor;
  final String? eyeColor;
  final int? heightCm;
  final int? weightKg;
  final String? measurements;

  /// Stash's free-text career length, e.g. "2010 - 2015".
  final String? career;
  final String? tattoos;
  final String? piercings;
  final ChannelMediaCounts counts;

  factory PerformerProfile.fromGraphql(Query$PerformerProfile$findPerformer p) => PerformerProfile(
        aliases: [for (final a in p.alias_list) ?nonEmpty(a)],
        deathDate: parseDate(p.death_date),
        ethnicity: nonEmpty(p.ethnicity),
        hairColor: nonEmpty(p.hair_color),
        eyeColor: nonEmpty(p.eye_color),
        heightCm: p.height_cm == 0 ? null : p.height_cm,
        weightKg: p.weight == 0 ? null : p.weight,
        measurements: nonEmpty(p.measurements),
        // ignore: deprecated_member_use_from_same_package
        career: nonEmpty(p.career_length),
        tattoos: nonEmpty(p.tattoos),
        piercings: nonEmpty(p.piercings),
        counts: ChannelMediaCounts(images: p.image_count, galleries: p.gallery_count),
      );
}
