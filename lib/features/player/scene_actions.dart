import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../edit/edit_common.dart';
import '../edit/edit_pages.dart';
import '../library/watch_later.dart';
import 'player_providers.dart';
import 'scene_edits.dart';
import '../../l10n/l10n.dart';

/// Rating stars on their own row, then O-counter, watch later, edit and
/// "add marker" as chips (epic 10).
class SceneActions extends ConsumerWidget {
  const SceneActions({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = effectiveStars(ref, scene);
    final oCount = effectiveOCounter(ref, scene);
    final l = context.l10n;

    void showError(Object e) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.saveFailed(errorText(l, e)))));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _RatingStars(
            stars: stars,
            onRate: (value) {
              Haptics.selection();
              ref.read(sceneEditsProvider.notifier).rate(scene, value).catchError(showError);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ActionChip(
                avatar: const Icon(Icons.water_drop_outlined, size: 18),
                label: Semantics(
                  label: l.oCounterSemantics(oCount),
                  excludeSemantics: true,
                  child: Text(l.oCounterLabel(oCount)),
                ),
                tooltip: l.addO,
                onPressed: () async {
                  Haptics.medium();
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    final count = await ref.read(sceneEditsProvider.notifier).addO(scene);
                    messenger.showSnackBar(SnackBar(
                      content: Text(l.oCountValue(count)),
                      // With an action, snack bars would stay until tapped.
                      persist: false,
                      action: SnackBarAction(
                        label: l.undo,
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
                label: Text(l.edit),
                tooltip: l.editSceneDetails,
                onPressed: () => openEditor(context, ref, SceneEditPage(scene: scene)),
              ),
              const SizedBox(width: 8),
              ActionChip(
                avatar: const Icon(Icons.bookmark_add_outlined, size: 18),
                label: Text(l.marker),
                tooltip: l.addMarkerHere,
                onPressed: () {
                  // On the TV while casting, not in the paused local player.
                  final position = ref.read(nowPlayingProvider.notifier).currentPosition();
                  showAddMarkerSheet(context, scene: scene, seconds: position.inMilliseconds / 1000);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Five stars for sighted users to tap (tapping the current rating removes
/// it), and one adjustable element for screen readers: "Rating, 4 of 5
/// stars", swiped up or down like a slider (A11Y-2).
class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.stars, required this.onRate});

  final int stars;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final rating = AppColors.of(context).rating;
    return Semantics(
      container: true,
      slider: true,
      label: l.ratingLabel,
      value: l.ratingValue(stars),
      increasedValue: stars < 5 ? l.ratingValue(stars + 1) : null,
      decreasedValue: stars > 0 ? l.ratingValue(stars - 1) : null,
      onIncrease: stars < 5 ? () => onRate(stars + 1) : null,
      onDecrease: stars > 0 ? () => onRate(stars - 1) : null,
      child: ExcludeSemantics(
        child: Row(
          children: [
            // Full 48 dp targets: five fit in 256 dp, so even 320 dp wide
            // screens have room.
            for (var i = 1; i <= 5; i++)
              IconButton(
                tooltip: i == stars ? l.removeRating : l.rateStars(i),
                icon: Icon(
                  i <= stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i <= stars ? rating : colors.onSurfaceVariant,
                ),
                onPressed: () => onRate(i == stars ? 0 : i),
              ),
          ],
        ),
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
    final l = context.l10n;
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container.read(stashRepositoryProvider).createMarker(
            sceneId: widget.scene.id,
            seconds: widget.seconds,
            primaryTagId: tag.id,
            title: _title.text.trim(),
          );
      // Chapters come from the scene details.
      container.invalidate(sceneDetailsProvider(widget.scene.id));
      // Closed meanwhile: popping now would remove the page below the sheet.
      if (mounted) navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.markerAdded(formatDuration(widget.seconds)))));
    } catch (e) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(l.markerAddFailed(errorText(l, e)))));
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
              Text(context.l10n.addMarkerAt(formatDuration(widget.seconds)), style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: context.l10n.titleOptional, border: const OutlineInputBorder()),
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
                  decoration: InputDecoration(
                    labelText: context.l10n.primaryTagRequired,
                    prefixIcon: const Icon(Icons.sell_outlined),
                    border: const OutlineInputBorder(),
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
                    : Text(context.l10n.addMarker),
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
      label: Text(saved ? context.l10n.saved : context.l10n.later),
      tooltip: saved ? context.l10n.watchLaterRemove : context.l10n.watchLaterSave,
      onPressed: () => ref.read(watchLaterProvider.notifier).toggle(sceneId),
    );
  }
}
