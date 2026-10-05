import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../edit/edit_pages.dart';
import '../library/watch_later.dart';
import '../shell/navigation.dart';
import 'player_providers.dart';
import 'scene_edits.dart';

/// Rating stars, O-counter and "add marker" below the title (epic 10).
class SceneActions extends ConsumerWidget {
  const SceneActions({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = effectiveStars(ref, scene);
    final oCount = effectiveOCounter(ref, scene);
    final colors = Theme.of(context).colorScheme;

    void showError(Object e) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Couldn\'t save: $e')));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (var i = 1; i <= 5; i++)
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: i == stars ? 'Remove rating' : 'Rate $i star${i == 1 ? '' : 's'}',
              icon: Icon(i <= stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i <= stars ? Colors.amber.shade600 : colors.onSurfaceVariant),
              onPressed: () {
                HapticFeedback.selectionClick();
                // Tapping the current rating again removes it.
                ref.read(sceneEditsProvider.notifier).rate(scene, i == stars ? 0 : i).catchError(showError);
              },
            ),
          const SizedBox(width: 8),
          ActionChip(
            avatar: const Icon(Icons.water_drop_outlined, size: 18),
            label: Text('$oCount'),
            tooltip: 'Add O',
            onPressed: () async {
              HapticFeedback.mediumImpact();
              final messenger = ScaffoldMessenger.of(context);
              try {
                final count = await ref.read(sceneEditsProvider.notifier).addO(scene);
                messenger.showSnackBar(SnackBar(
                  content: Text('O-count: $count'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () => ref.read(sceneEditsProvider.notifier).removeO(scene).catchError(showError),
                  ),
                ));
              } catch (e) {
                showError(e);
              }
            },
          ),
          const SizedBox(width: 8),
          WatchLaterChip(sceneId: scene.id),
          const SizedBox(width: 8),
          ActionChip(
            avatar: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit'),
            tooltip: 'Edit scene details',
            onPressed: () => openPage(ref, SceneEditPage(scene: scene)),
          ),
          const SizedBox(width: 8),
          ActionChip(
            avatar: const Icon(Icons.bookmark_add_outlined, size: 18),
            label: const Text('Marker'),
            tooltip: 'Add a marker at the current position',
            onPressed: () {
              final position = ref.read(playerProvider).state.position;
              showAddMarkerSheet(context, scene: scene, seconds: position.inMilliseconds / 1000);
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showAddMarkerSheet(BuildContext context, {required Scene scene, required double seconds}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddMarkerSheet(scene: scene, seconds: seconds),
    );

/// Creates a scene marker (10.3). Stash requires a primary tag.
class AddMarkerSheet extends ConsumerStatefulWidget {
  const AddMarkerSheet({super.key, required this.scene, required this.seconds});

  final Scene scene;
  final double seconds;

  @override
  ConsumerState<AddMarkerSheet> createState() => _AddMarkerSheetState();
}

class _AddMarkerSheetState extends ConsumerState<AddMarkerSheet> {
  final _title = TextEditingController();
  Timer? _debounce;
  String _tagSearch = '';
  Tag? _tag;
  bool _saving = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final tag = _tag;
    if (tag == null) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref.read(stashRepositoryProvider).createMarker(
            sceneId: widget.scene.id,
            seconds: widget.seconds,
            primaryTagId: tag.id,
            title: _title.text.trim(),
          );
      // Chapters come from the scene details.
      ref.invalidate(sceneDetailsProvider(widget.scene.id));
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text('Marker added at ${formatDuration(widget.seconds)}')));
    } catch (e) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text('Couldn\'t add marker: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = _tagSearch.isEmpty ? const TagQuery() : TagQuery(search: _tagSearch, sort: TagSort.name);
    final tags = ref.watch(tagListProvider(query)).current?.items ?? const <Tag>[];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add marker at ${formatDuration(widget.seconds)}', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Title (optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              if (_tag case final tag?)
                Align(
                  alignment: Alignment.centerLeft,
                  child: InputChip(
                    label: Text('#${tag.name}'),
                    onDeleted: () => setState(() => _tag = null),
                  ),
                )
              else ...[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Primary tag (required)',
                    prefixIcon: Icon(Icons.sell_outlined),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 300), () {
                      if (mounted) setState(() => _tagSearch = v.trim());
                    });
                  },
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in tags.take(12))
                      ActionChip(label: Text('#${tag.name}'), onPressed: () => setState(() => _tag = tag)),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _tag == null || _saving ? null : _save,
                child: _saving
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Add marker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toggles the scene in "Watch later" (9.4).
class WatchLaterChip extends ConsumerWidget {
  const WatchLaterChip({super.key, required this.sceneId});

  final String sceneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(watchLaterProvider).contains(sceneId);
    return ActionChip(
      avatar: Icon(saved ? Icons.watch_later : Icons.watch_later_outlined, size: 18),
      label: Text(saved ? 'Saved' : 'Later'),
      tooltip: saved ? 'Remove from Watch later' : 'Save to Watch later',
      onPressed: () => ref.read(watchLaterProvider.notifier).toggle(sceneId),
    );
  }
}
