import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/channel_header.dart';
import '../../widgets/scene_feed.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';
import '../shell/navigation.dart';

/// Studio "channel": header, parent studio and sub-studios (7.3), and all
/// scenes of the studio, optionally including its sub-studios.
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

  @override
  Widget build(BuildContext context) {
    final studio = ref.watch(studioProvider(widget.studioId));
    final hasChildren = studio.value?.children.isNotEmpty ?? false;
    final includeSubStudios = _includeSubStudios ?? hasChildren;

    return Scaffold(
      appBar: AppBar(title: Text(studio.value?.name ?? '')),
      body: SceneFeedView(
        initialQuery: SceneQuery(
          sort: SceneSort.newest,
          studioId: widget.studioId,
          includeSubStudios: includeSubStudios,
        ),
        sorts: _sorts,
        headerSlivers: [
          SliverToBoxAdapter(
            child: studio.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(studioProvider(widget.studioId))),
              data: (s) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChannelHeader(
                    name: s.name,
                    imageUrl: s.imageUrl,
                    subtitle: [
                      formatCount(s.sceneCount, 'scene'),
                      if (s.children.isNotEmpty) formatCount(s.children.length, 'sub-studio'),
                    ].join(' • '),
                    description: s.details,
                  ),
                  if (s.parent case final parent?)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                      child: ActionChip(
                        avatar: ChannelAvatar(name: parent.name, imageUrl: parent.imageUrl, radius: 12),
                        label: Text('Part of ${parent.name}'),
                        onPressed: () => openStudio(ref, parent.id),
                      ),
                    ),
                  if (s.children.isNotEmpty) ...[
                    _SubStudios(children: s.children),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                      child: FilterChip(
                        label: const Text('Include sub-studios'),
                        selected: includeSubStudios,
                        onSelected: (v) => setState(() => _includeSubStudios = v),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
          child: Text('Sub-studios', style: theme.textTheme.titleSmall),
        ),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: children.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
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
                        formatCount(child.sceneCount, 'scene'),
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
