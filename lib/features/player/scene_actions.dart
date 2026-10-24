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
import '../tags/tag_editor.dart';
import 'file_info.dart';
import 'player_providers.dart';
import 'scene_description.dart';
import 'scene_edits.dart';
import '../../l10n/l10n.dart';

/// The one action bar under the channel row (WATCH-2): pill buttons for the
/// rating, the O-counter, watch later and "add marker", then "More" with the
/// rarer actions (edit, tags, file info). Scrolls sideways when it doesn't
/// fit (epic 10).
class SceneActions extends ConsumerWidget {
  const SceneActions({super.key, required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = effectiveStars(ref, scene);
    final oCount = effectiveOCounter(ref, scene);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    void showError(Object e) => messenger.showSnackBar(SnackBar(content: Text(l.saveFailed(errorText(l, e)))));

    const gap = SizedBox(width: AppSpacing.s);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xs),
      child: Row(
        children: [
          // "★ 4" or "Rate"; the stars themselves are in a small sheet.
          FilledButton.tonalIcon(
            icon: Icon(
              stars > 0 ? Icons.star_rounded : Icons.star_outline_rounded,
              color: stars > 0 ? AppColors.of(context).rating : null,
            ),
            label: Semantics(
              label: l.ratingButtonSemantics(l.ratingValue(stars)),
              excludeSemantics: true,
              child: Text(stars > 0 ? '$stars' : l.rateScene),
            ),
            onPressed: () => showRatingSheet(context, scene: scene, onError: showError),
          ),
          gap,
          Tooltip(
            message: l.addO,
            child: FilledButton.tonalIcon(
              icon: const Icon(Icons.water_drop_outlined),
              label: Semantics(
                label: l.oCounterSemantics(oCount),
                excludeSemantics: true,
                child: Text(l.oCounterLabel(oCount)),
              ),
              onPressed: () async {
                Haptics.medium();
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
          ),
          gap,
          WatchLaterButton(sceneId: scene.id),
          gap,
          Tooltip(
            message: l.addMarkerHere,
            child: FilledButton.tonalIcon(
              icon: const Icon(Icons.bookmark_add_outlined),
              label: Text(l.marker),
              onPressed: () {
                // On the TV while casting, not in the paused local player.
                final position = ref.read(nowPlayingProvider.notifier).currentPosition();
                showAddMarkerSheet(context, scene: scene, seconds: position.inMilliseconds / 1000);
              },
            ),
          ),
          gap,
          IconButton.filledTonal(
            tooltip: l.moreActions,
            icon: const Icon(Icons.more_horiz),
            onPressed: () => showSceneMoreSheet(context, scene),
          ),
        ],
      ),
    );
  }
}

/// The compact star picker behind the rating button: a tap rates and closes
/// it, tapping the current rating removes it.
Future<void> showRatingSheet(BuildContext context, {required Scene scene, required ValueChanged<Object> onError}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => _RatingSheet(scene: scene, onError: onError),
    );

class _RatingSheet extends ConsumerWidget {
  const _RatingSheet({required this.scene, required this.onError});

  final Scene scene;
  final ValueChanged<Object> onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = effectiveStars(ref, scene);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.rateThisScene, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s),
            _RatingStars(
              stars: stars,
              onRate: (value) {
                Haptics.selection();
                ref.read(sceneEditsProvider.notifier).rate(scene, value).catchError(onError);
              },
              onPicked: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Five stars for sighted users to tap (tapping the current rating removes
/// it), and one adjustable element for screen readers: "Rating, 4 of 5
/// stars", swiped up or down like a slider (A11Y-2). [onPicked] follows a
/// tap only, so adjusting with a screen reader keeps the picker open.
class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.stars, required this.onRate, this.onPicked});

  final int stars;
  final ValueChanged<int> onRate;
  final VoidCallback? onPicked;

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
          mainAxisSize: MainAxisSize.min,
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
                onPressed: () {
                  onRate(i == stars ? 0 : i);
                  onPicked?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// "More" of the action bar: the description, editing, tags and file info.
/// The actions run on the navigator below the sheet once it is closed.
Future<void> showSceneMoreSheet(BuildContext context, Scene scene) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => _SceneMoreSheet(scene: scene),
    );

class _SceneMoreSheet extends ConsumerWidget {
  const _SceneMoreSheet({required this.scene});

  final Scene scene;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final files = ref.watch(sceneDetailsProvider(scene.id)).value?.files ?? const [];
    final tags = effectiveTags(ref, scene);

    // Closes the sheet, then runs [action] with a context that outlives it.
    void then(void Function(BuildContext below) action) {
      final navigator = Navigator.of(context);
      navigator.pop();
      action(navigator.context);
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.notes),
            title: Text(l.sceneDescription),
            onTap: () => then((below) => showSceneDescription(below, scene)),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l.editScene),
            onTap: () => then((below) => openEditor(below, ref, SceneEditPage(scene: scene))),
          ),
          ListTile(
            leading: Icon(tags.isEmpty ? Icons.add : Icons.sell_outlined),
            title: Text(tags.isEmpty ? l.addTags : l.editTags),
            onTap: () => then((below) => showSceneTagEditor(below, scene, tags)),
          ),
          if (files.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l.fileInfo),
              onTap: () => then((below) => showFileInfoSheet(below, files)),
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
class WatchLaterButton extends ConsumerWidget {
  const WatchLaterButton({super.key, required this.sceneId});

  final String sceneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(watchLaterProvider).contains(sceneId);
    final l = context.l10n;
    return Tooltip(
      message: saved ? l.watchLaterRemove : l.watchLaterSave,
      child: FilledButton.tonalIcon(
        icon: Icon(saved ? Icons.watch_later : Icons.watch_later_outlined),
        label: Text(saved ? l.saved : l.later),
        onPressed: () {
          Haptics.light();
          ref.read(watchLaterProvider.notifier).toggle(sceneId);
        },
      ),
    );
  }
}
