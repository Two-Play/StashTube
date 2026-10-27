import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/design_tokens.dart';
import '../performers/favorite_button.dart';
import '../channel/channel_rating.dart';
import '../../core/config/haptics.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
import '../edit/edit_common.dart';
import '../edit/edit_pages.dart';
import '../channel/channel_tabs.dart';
import '../library/images_tab.dart';
import '../library/markers_tab.dart';
import '../shell/navigation.dart';
import '../shorts/shorts_feed.dart';
import '../../l10n/l10n.dart';

/// Studio "channel" (CH-2): header with the parent studio and sub-studios
/// (7.3) above the tabs videos, shorts, markers, images, galleries (each
/// only when there are any) and about. The videos, markers, images and
/// galleries optionally include the sub-studios'.
class StudioPage extends ConsumerStatefulWidget {
  const StudioPage({super.key, required this.studioId});

  final String studioId;

  @override
  ConsumerState<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends ConsumerState<StudioPage> {
  static const _sorts = [SceneSort.newest, SceneSort.recentlyAdded, SceneSort.topRated, SceneSort.random];

  /// Null until the user toggles it: then defaults to on for studios with
  /// sub-studios (a network's own scene list is often nearly empty).
  bool? _includeSubStudios;

  String get _id => widget.studioId;

  MarkerQuery get _markerCountQuery => MarkerQuery(studioId: _id, includeSubStudios: true);

  @override
  Widget build(BuildContext context) {
    final studio = ref.watch(studioProvider(_id));
    final hasChildren = studio.value?.children.isNotEmpty ?? false;
    final includeSubStudios = _includeSubStudios ?? hasChildren;
    final name = studio.value?.name;
    final shortsSource = ShortsSource.studio(_id, title: name);
    final shorts = ref.watch(channelShortsCountProvider(shortsSource)).value ?? 0;
    final counts = ref.watch(studioMediaCountsProvider(_id)).value;
    // Like the media counts, with the sub-studios' (the toggle only
    // filters the tab).
    final markers = ref.watch(markerCountProvider(_markerCountQuery)).value ?? 0;

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
        if (studio.value case final value?)
          IconButton(
            tooltip: context.l10n.edit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => openEditor(context, ref, StudioEditPage(studio: value)),
          ),
      ],
      body: ChannelTabsView(
        tabs: tabs,
        header: studio.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(studioProvider(_id))),
          data: (s) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChannelHeader(
                name: s.name,
                imageUrl: s.imageUrl,
                subtitle: [
                  context.l10n.scenesCount(s.sceneCount),
                  if (s.children.isNotEmpty) context.l10n.subStudiosCount(s.children.length),
                ].join(' • '),
                // Each only on servers that have it.
                action: Wrap(
                  spacing: AppSpacing.s,
                  runSpacing: AppSpacing.xs,
                  children: [StudioFavoriteButton(studioId: s.id), _StudioRating(studioId: s.id)],
                ),
              ),
              if (s.parent case final parent?) _ParentChip(parent: parent),
              if (s.children.isNotEmpty) ...[
                _SubStudios(children: s.children),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                  child: FilterChip(
                    label: Text(context.l10n.includeSubStudios),
                    selected: includeSubStudios,
                    onSelected: withHaptic((v) => setState(() => _includeSubStudios = v)),
                  ),
                ),
              ],
            ],
          ),
        ),
        builder: (context, tab, headerSlivers) => switch (tab) {
          ChannelTab.videos => SceneFeedView(
              initialQuery: SceneQuery(sort: SceneSort.newest, studioId: _id, includeSubStudios: includeSubStudios),
              sorts: _sorts,
              headerSlivers: headerSlivers,
              onRefresh: _refreshHeader,
            ),
          ChannelTab.shorts => ChannelShortsGrid(source: shortsSource, headerSlivers: headerSlivers),
          ChannelTab.markers => MarkerGridView(
              initialQuery: MarkerQuery(studioId: _id, includeSubStudios: includeSubStudios),
              headerSlivers: headerSlivers,
            ),
          ChannelTab.images => ImageGridView(
              // The grid keeps its query; a new one for the toggle.
              key: ValueKey(includeSubStudios),
              initialQuery: ImageQuery(studioId: _id, includeSubStudios: includeSubStudios),
              sorts: ImageSort.browse,
              searchable: false,
              headerSlivers: headerSlivers,
            ),
          ChannelTab.galleries => ChannelGalleryGrid(
              initialQuery: GalleryQuery(studioId: _id, includeSubStudios: includeSubStudios),
              headerSlivers: headerSlivers,
            ),
          ChannelTab.about => ChannelAboutView(
              headerSlivers: headerSlivers,
              onRefresh: () async {
                ref.invalidate(studioMediaCountsProvider(_id));
                await refreshFuture(ref, studioProvider(_id).future);
              },
              sections: [
                if (studio.value case final s?) ...studioFacts(context, ref, s),
              ],
            ),
        },
      ),
    );
  }

  /// Pull-to-refresh on the videos also reloads the header and the tabs.
  void _refreshHeader() {
    ref.invalidate(studioProvider(_id));
    ref.invalidate(studioMediaCountsProvider(_id));
    ref.invalidate(channelShortsCountProvider(ShortsSource.studio(_id)));
    ref.invalidate(markerCountProvider(_markerCountQuery));
  }
}

/// The about tab's sections for [s], those that are set.
@visibleForTesting
List<Widget> studioFacts(BuildContext context, WidgetRef ref, Studio s) {
  final l = context.l10n;
  return [
    if (s.url case final url?) ChannelLinks(label: l.fieldWebsite, urls: [url]),
    if (s.parent case final parent?)
      ListTile(
        leading: ChannelAvatar(name: parent.name, imageUrl: parent.imageUrl, radius: 20),
        title: Text(parent.name),
        subtitle: Text(l.fieldParentStudio),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => openStudio(ref, parent.id),
      ),
    if (s.details case final details?) ChannelAboutText(label: l.fieldDescription, text: details),
  ];
}

class _ParentChip extends ConsumerWidget {
  const _ParentChip({required this.parent});

  final Studio parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
        child: ActionChip(
          avatar: ChannelAvatar(name: parent.name, imageUrl: parent.imageUrl, radius: 12),
          label: Text(context.l10n.partOf(parent.name)),
          onPressed: () => openStudio(ref, parent.id),
        ),
      );
}

class _SubStudios extends ConsumerWidget {
  const _SubStudios({required this.children});

  final List<Studio> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(context.l10n.subStudios, style: theme.textTheme.titleSmall),
        ),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: children.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final child = children[i];
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => openStudio(ref, child.id),
                child: SizedBox(
                  width: 84,
                  child: Column(
                    children: [
                      ChannelAvatar(name: child.name, imageUrl: child.imageUrl, radius: 30),
                      const SizedBox(height: 6),
                      Text(
                        child.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        context.l10n.scenesCount(child.sceneCount),
                        maxLines: 1,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// The studio's stars, on servers with studio ratings.
class _StudioRating extends ConsumerWidget {
  const _StudioRating({required this.studioId});

  final String studioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (effectiveStudioStars(ref, studioId) == null) return const SizedBox.shrink();
    return ChannelRatingButton(
      kind: ChannelKind.studio,
      id: studioId,
      stars: (ref) => effectiveStudioStars(ref, studioId) ?? 0,
    );
  }
}
