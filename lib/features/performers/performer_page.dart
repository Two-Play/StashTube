import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/models/performer_profile.dart';
import '../../data/providers.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/performer_tile.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/status_views.dart';
import '../channel/channel_tabs.dart';
import '../edit/edit_common.dart';
import '../edit/edit_pages.dart';
import '../library/images_tab.dart';
import '../library/markers_tab.dart';
import '../shorts/shorts_feed.dart';
import 'favorite_button.dart';
import '../../l10n/l10n.dart';

/// Performer "channel" (CH-2): a header with their picture, name and
/// favorite button above the tabs videos, shorts, markers, images,
/// galleries (each only when there are any) and about.
class PerformerPage extends ConsumerWidget {
  const PerformerPage({super.key, required this.performerId});

  final String performerId;

  static const _sorts = [SceneSort.newest, SceneSort.recentlyAdded, SceneSort.topRated, SceneSort.random];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performer = ref.watch(performerProvider(performerId));
    final counts = ref.watch(performerProfileProvider(performerId)).value?.counts;
    final shorts = ref.watch(performerShortsCountProvider(performerId)).value ?? 0;
    final markerQuery = MarkerQuery(performerId: performerId);
    final markers = ref.watch(markerCountProvider(markerQuery)).value ?? 0;
    final name = performer.value?.name;

    final tabs = [
      ChannelTab.videos,
      if (shorts > 0) ChannelTab.shorts,
      if (markers > 0) ChannelTab.markers,
      if ((counts?.images ?? 0) > 0) ChannelTab.images,
      if ((counts?.galleries ?? 0) > 0) ChannelTab.galleries,
      ChannelTab.about,
    ];

    return ChannelScaffold(
      title: Text(name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        if (performer.value case final value?)
          IconButton(
            tooltip: context.l10n.edit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => openEditor(context, ref, PerformerEditPage(performer: value)),
          ),
      ],
      body: ChannelTabsView(
        tabs: tabs,
        header: performer.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(performerProvider(performerId))),
          data: (p) => _PerformerHeader(performer: p),
        ),
        builder: (context, tab, headerSlivers) => switch (tab) {
          ChannelTab.videos => SceneFeedView(
              initialQuery: SceneQuery(sort: SceneSort.newest, performerId: performerId),
              sorts: _sorts,
              headerSlivers: headerSlivers,
              onRefresh: () => _refreshHeader(ref),
            ),
          ChannelTab.shorts => ChannelShortsGrid(
              source: ShortsSource.performer(performerId, title: name),
              headerSlivers: headerSlivers,
            ),
          ChannelTab.markers => MarkerGridView(initialQuery: markerQuery, headerSlivers: headerSlivers),
          ChannelTab.images => ImageGridView(
              initialQuery: ImageQuery(performerId: performerId),
              sorts: ImageSort.browse,
              searchable: false,
              headerSlivers: headerSlivers,
            ),
          ChannelTab.galleries => ChannelGalleryGrid(
              initialQuery: GalleryQuery(performerId: performerId),
              headerSlivers: headerSlivers,
            ),
          ChannelTab.about => _PerformerAbout(performerId: performerId, headerSlivers: headerSlivers),
        },
      ),
    );
  }

  /// Pull-to-refresh on the videos also reloads the header and the tabs.
  void _refreshHeader(WidgetRef ref) {
    ref.invalidate(performerProvider(performerId));
    ref.invalidate(performerProfileProvider(performerId));
    ref.invalidate(performerShortsCountProvider(performerId));
    ref.invalidate(markerCountProvider(MarkerQuery(performerId: performerId)));
  }
}

class _PerformerHeader extends StatelessWidget {
  const _PerformerHeader({required this.performer});

  final Performer performer;

  @override
  Widget build(BuildContext context) {
    final p = performer;
    final age = p.ageAt(DateTime.now());
    return ChannelHeader(
      name: p.disambiguation == null ? p.name : '${p.name} (${p.disambiguation})',
      imageUrl: p.imageUrl,
      leadingBadge: p.country == null ? null : CountryFlagIcon(code: p.country!),
      subtitle: [
        context.l10n.scenesCount(p.sceneCount),
        if (age != null) context.l10n.ageYears(age),
      ].join(' • '),
      action: FavoriteButton(performer: p),
    );
  }
}

/// The about tab: the performer's details, links and description.
class _PerformerAbout extends ConsumerWidget {
  const _PerformerAbout({required this.performerId, required this.headerSlivers});

  final String performerId;
  final List<Widget> headerSlivers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final performer = ref.watch(performerProvider(performerId)).value;
    final profile = ref.watch(performerProfileProvider(performerId));
    final urls = ref.watch(performerUrlsProvider(performerId)).value ?? const <String>[];

    return ChannelAboutView(
      headerSlivers: headerSlivers,
      onRefresh: () async {
        ref.invalidate(performerUrlsProvider(performerId));
        await refreshFuture(ref, performerProfileProvider(performerId).future);
      },
      sections: [
        ...channelAboutStatus(profile, () => ref.invalidate(performerProfileProvider(performerId))),
        if (performer != null) ...performerFacts(l, performer, profile.value, DateTime.now()),
        if (urls.isNotEmpty) ChannelLinks(label: l.channelLinks, urls: urls),
        if (performer?.details case final details?) ChannelAboutText(label: l.fieldDetails, text: details),
      ],
    );
  }
}

/// The facts the about tab lists for [p], those that are set.
@visibleForTesting
List<Widget> performerFacts(AppLocalizations l, Performer p, PerformerProfile? profile, DateTime now) {
  final age = p.ageAt(now);
  return [
    if (profile != null && profile.aliases.isNotEmpty) ChannelFact(label: l.fieldAliases, value: profile.aliases.join(', ')),
    if (p.gender case final gender?) ChannelFact(label: l.fieldGender, value: _genderLabel(l, gender)),
    if (p.birthdate case final birthdate?)
      ChannelFact(
        label: l.fieldBirthdate,
        value: [formatDate(birthdate), if (age != null && profile?.deathDate == null) l.ageYears(age)].join(' • '),
      ),
    if (profile?.deathDate case final died?) ChannelFact(label: l.fieldDeathDate, value: formatDate(died)),
    if (p.country case final country?)
      ChannelFact(label: l.fieldCountry, value: country, leading: CountryFlagIcon(code: country)),
    if (profile != null) ...[
      if (profile.ethnicity case final v?) ChannelFact(label: l.fieldEthnicity, value: v),
      if (profile.hairColor case final v?) ChannelFact(label: l.fieldHairColor, value: v),
      if (profile.eyeColor case final v?) ChannelFact(label: l.fieldEyeColor, value: v),
      if (profile.heightCm case final v?) ChannelFact(label: l.fieldHeight, value: l.heightCm(v)),
      if (profile.weightKg case final v?) ChannelFact(label: l.fieldWeight, value: l.weightKg(v)),
      if (profile.measurements case final v?) ChannelFact(label: l.fieldMeasurements, value: v),
      if (profile.career case final v?) ChannelFact(label: l.fieldCareer, value: v),
      if (profile.tattoos case final v?) ChannelFact(label: l.fieldTattoos, value: v),
      if (profile.piercings case final v?) ChannelFact(label: l.fieldPiercings, value: v),
    ],
  ];
}

String _genderLabel(AppLocalizations l, String gender) => switch (gender) {
      'FEMALE' => l.genderFemale,
      'MALE' => l.genderMale,
      'TRANSGENDER_FEMALE' => l.genderTransFemale,
      'TRANSGENDER_MALE' => l.genderTransMale,
      'INTERSEX' => l.genderIntersex,
      _ => l.genderNonBinary,
    };
