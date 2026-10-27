import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/models/scene_details.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../edit/edit_common.dart';
import '../edit/edit_pages.dart';
import '../library/add_to_group.dart';
import '../library/watch_later.dart';
import '../tags/tag_editor.dart';
import 'file_info.dart';
import 'player_controls.dart' show markerTimeLabel;
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
          // "O · 3"; counting up and down happens in a small sheet.
          Tooltip(
            message: l.oCounterTitle,
            child: FilledButton.tonalIcon(
              icon: const Icon(Icons.water_drop_outlined),
              label: Semantics(
                label: l.oCounterSemantics(oCount),
                excludeSemantics: true,
                child: Text(l.oCounterLabel(oCount)),
              ),
              onPressed: () => showOCounterSheet(context, scene: scene, onError: showError),
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

/// The star picker behind the rating button: five large stars across the
/// whole sheet, the current value and "Remove rating". A tap rates and
/// closes it, tapping the current rating removes it.
Future<void> showRatingSheet(BuildContext context, {required Scene scene, required ValueChanged<Object> onError}) =>
    showStarsSheet(
      context,
      title: context.l10n.rateThisScene,
      stars: (ref) => effectiveStars(ref, scene),
      onRate: (ref, value) => ref.read(sceneEditsProvider.notifier).rate(scene, value).catchError(onError),
    );

/// [showRatingSheet] for anything rated with stars: [stars] reads the
/// current value (0 = none), [onRate] saves a new one (0 removes it).
Future<void> showStarsSheet(
  BuildContext context, {
  required String title,
  required int Function(WidgetRef ref) stars,
  required void Function(WidgetRef ref, int value) onRate,
}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => _StarsSheet(title: title, starsOf: stars, onRate: onRate),
    );

class _StarsSheet extends ConsumerWidget {
  const _StarsSheet({required this.title, required this.starsOf, required this.onRate});

  final String title;
  final int Function(WidgetRef ref) starsOf;
  final void Function(WidgetRef ref, int value) onRate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final stars = starsOf(ref);

    void rate(int value) {
      Haptics.selection();
      onRate(ref, value);
    }

    return _SheetBody(
      title: title,
      // The slider below says the value to screen readers.
      subtitle: ExcludeSemantics(
        child: Text(
          l.ratingValue(stars),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
      children: [
        _RatingStars(stars: stars, onRate: rate, onPicked: () => Navigator.pop(context)),
        const SizedBox(height: AppSpacing.s),
        TextButton.icon(
          icon: const Icon(Icons.star_border_rounded),
          label: Text(l.removeRating),
          onPressed: stars == 0
              ? null
              : () {
                  rate(0);
                  Navigator.pop(context);
                },
        ),
      ],
    );
  }
}

/// The layout the rating and O-counter sheets share: a centered title and
/// value over full-width content. The bottom sheet itself keeps its width
/// in check on tablets (Material's 640 dp).
class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.title, this.subtitle, required this.children});

  final String title;
  final Widget? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
              ),
              if (subtitle case final subtitle?) ...[
                const SizedBox(height: AppSpacing.xs),
                Center(child: subtitle),
              ],
              const SizedBox(height: AppSpacing.l),
              ...children,
            ],
          ),
        ),
      );
}

/// Five stars spread over the width for sighted users to tap (tapping the
/// current rating removes it), and one adjustable element for screen
/// readers: "Rating, 4 of 5 stars", swiped up or down like a slider
/// (A11Y-2). [onPicked] follows a tap only, so adjusting with a screen
/// reader keeps the picker open.
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Each star gets a fifth of the width (at least 57 dp on a
            // 320 dp phone), drawn as large as it allows.
            final slot = constraints.maxWidth / 5;
            final iconSize = (slot * 0.6).clamp(32.0, 56.0);
            return Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  Expanded(
                    child: SizedBox(
                      height: iconSize + AppSpacing.xl,
                      child: IconButton(
                        tooltip: i == stars ? l.removeRating : l.rateStars(i),
                        iconSize: iconSize,
                        icon: Icon(
                          i <= stars ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: i <= stars ? rating : colors.onSurfaceVariant,
                        ),
                        onPressed: () {
                          onRate(i == stars ? 0 : i);
                          onPicked?.call();
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The O-counter's sheet: the count large in the middle between − and +.
/// Each tap saves right away (optimistically); a failed save closes the
/// sheet, so its snack bar isn't hidden behind it.
Future<void> showOCounterSheet(BuildContext context, {required Scene scene, required ValueChanged<Object> onError}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => _OCounterSheet(scene: scene, onError: onError),
    );

class _OCounterSheet extends ConsumerWidget {
  const _OCounterSheet({required this.scene, required this.onError});

  final Scene scene;
  final ValueChanged<Object> onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final count = effectiveOCounter(ref, scene);
    final notifier = ref.read(sceneEditsProvider.notifier);

    Future<void> save(Future<Object?> Function() change) async {
      final navigator = Navigator.of(context);
      try {
        await change();
      } catch (e) {
        if (context.mounted) navigator.pop();
        onError(e);
      }
    }

    void add() {
      Haptics.medium();
      save(() => notifier.addO(scene));
    }

    void remove() {
      Haptics.light();
      save(() => notifier.removeO(scene));
    }

    final buttonStyle = IconButton.styleFrom(minimumSize: const Size.square(64), iconSize: 32);
    return _SheetBody(
      title: l.oCounterTitle,
      children: [
        // One adjustable element for screen readers ("O-counter, 3"), like
        // the rating (A11Y-2).
        Semantics(
          container: true,
          label: l.oCounterTitle,
          value: '$count',
          increasedValue: '${count + 1}',
          decreasedValue: count > 0 ? '${count - 1}' : null,
          onIncrease: add,
          onDecrease: count > 0 ? remove : null,
          child: ExcludeSemantics(
            child: Row(
              children: [
                IconButton.filledTonal(
                  tooltip: l.removeO,
                  style: buttonStyle,
                  icon: const Icon(Icons.remove),
                  onPressed: count > 0 ? remove : null,
                ),
                Expanded(
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: l.addO,
                  style: buttonStyle,
                  icon: const Icon(Icons.add),
                  onPressed: add,
                ),
              ],
            ),
          ),
        ),
      ],
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
          ListTile(
            leading: const Icon(Icons.playlist_add),
            title: Text(l.addToGroup),
            onTap: () => then((below) => showAddToGroupSheet(below, scene)),
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

/// Opens [AddMarkerSheet] for an existing [marker] of [scene].
Future<void> showEditMarkerSheet(BuildContext context, {required Scene scene, required SceneMarker marker}) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AddMarkerSheet(scene: scene, seconds: marker.seconds, marker: marker),
    );

/// The long-press menu of a marker (a chapter in the player, a tile in the
/// markers grid): [leading] entries of the caller, then edit and delete.
/// Each entry gets `go`, which closes the menu and then acts.
Future<void> showMarkerMenu(
  BuildContext context, {
  required Scene scene,
  required SceneMarker marker,
  List<Widget> Function(BuildContext sheetContext, void Function(VoidCallback action) go)? leading,
}) {
  Haptics.heavy();
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (sheetContext) {
      final l = sheetContext.l10n;
      void go(VoidCallback action) {
        Navigator.pop(sheetContext);
        action();
      }

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(marker.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(markerTimeLabel(l, marker.seconds, marker.endSeconds, withLength: true)),
            ),
            const Divider(height: 1),
            ...?leading?.call(sheetContext, go),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l.markerEdit),
              onTap: () => go(() => showEditMarkerSheet(context, scene: scene, marker: marker)),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l.markerDelete),
              onTap: () => go(() => confirmDeleteMarker(context, sceneId: scene.id, marker: marker)),
            ),
          ],
        ),
      );
    },
  );
}

/// Asks, then deletes [marker] and reloads the chapters and marker lists.
Future<void> confirmDeleteMarker(BuildContext context, {required String sceneId, required SceneMarker marker}) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final container = ProviderScope.containerOf(context, listen: false);
  final delete = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (dialogContext) => AlertDialog(
      title: Text(l.markerDeleteTitle),
      content: Text(l.markerDeleteConfirm(marker.title, markerTimeLabel(l, marker.seconds, marker.endSeconds))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(l.markerDeleteAction)),
      ],
    ),
  );
  if (delete != true) return;
  try {
    await container.read(stashRepositoryProvider).deleteMarker(marker.id);
    Haptics.medium();
    _markersChanged(container, sceneId);
    messenger.showSnackBar(SnackBar(content: Text(l.markerDeleted)));
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(l.saveFailed(errorText(l, e)))));
  }
}

/// Reloads what shows [sceneId]'s markers.
void _markersChanged(ProviderContainer container, String sceneId) {
  container.invalidate(sceneDetailsProvider(sceneId));
  container.invalidate(markerListProvider);
  container.invalidate(markerCountProvider);
}

/// Creates a scene marker (10.3), or with [marker] edits that one (title,
/// tag, end). Stash requires a primary tag. On servers with ranged markers
/// (newer Stash) the marker can also get an end.
class AddMarkerSheet extends ConsumerStatefulWidget {
  const AddMarkerSheet({super.key, required this.scene, required this.seconds, this.marker});

  final Scene scene;
  final double seconds;

  /// The marker to edit; null for a new one.
  final SceneMarker? marker;

  @override
  ConsumerState<AddMarkerSheet> createState() => _AddMarkerSheetState();
}

class _AddMarkerSheetState extends ConsumerState<AddMarkerSheet> {
  late final _title = TextEditingController(text: widget.marker?.ownTitle);
  Timer? _debounce;
  String _tagSearch = '';
  late Tag? _tag = widget.marker?.tag;
  bool _saving = false;

  /// The ranged marker's end; null for a moment.
  late double? _end = widget.marker?.endSeconds;

  /// Step of the end's − / + buttons.
  static const _endStep = 5.0;

  bool get _endValid => _end == null || _end! > widget.seconds;

  /// The end at the current position, or a little after the start while
  /// the player still stands there.
  void _setEndToPosition() {
    final position = ref.read(nowPlayingProvider.notifier).currentPosition().inMilliseconds / 1000;
    setState(() => _end = position > widget.seconds ? position : widget.seconds + 2 * _endStep);
  }

  void _moveEnd(double by) => setState(() => _end = ((_end ?? widget.seconds) + by).clamp(0.0, double.infinity));

  @override
  void dispose() {
    _debounce?.cancel();
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final tag = _tag;
    if (tag == null || !_endValid) return;
    final end = _end;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l = context.l10n;
    final container = ProviderScope.containerOf(context, listen: false);
    if (widget.marker case final marker?) {
      try {
        // Only what changed; the end only where the server knows ends.
        final ranges = ref.read(sceneDetailsProvider(widget.scene.id)).value?.markerRanges ?? false;
        final changes = <String, dynamic>{
          if (_title.text.trim() != marker.ownTitle) 'title': _title.text.trim(),
          if (tag.id != marker.tag?.id) 'primary_tag_id': tag.id,
          if (ranges && end != marker.endSeconds) 'end_seconds': end,
        };
        if (changes.isNotEmpty) await container.read(stashRepositoryProvider).updateMarker(marker.id, changes);
        _markersChanged(container, widget.scene.id);
        if (mounted) navigator.pop();
        if (changes.isNotEmpty) messenger.showSnackBar(SnackBar(content: Text(l.markerSaved)));
      } catch (e) {
        if (mounted) setState(() => _saving = false);
        messenger.showSnackBar(SnackBar(content: Text(l.saveFailed(errorText(l, e)))));
      }
      return;
    }
    try {
      await container.read(stashRepositoryProvider).createMarker(
            sceneId: widget.scene.id,
            seconds: widget.seconds,
            primaryTagId: tag.id,
            title: _title.text.trim(),
            endSeconds: end,
          );
      // Chapters come from the scene details.
      _markersChanged(container, widget.scene.id);
      // Closed meanwhile: popping now would remove the page below the sheet.
      if (mounted) navigator.pop();
      final time = end == null
          ? formatDuration(widget.seconds)
          : l.markerRange(formatDuration(widget.seconds), formatDuration(end));
      messenger.showSnackBar(SnackBar(content: Text(l.markerAdded(time))));
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
    // Only servers that know marker end times get the field.
    final ranges = ref.watch(sceneDetailsProvider(widget.scene.id)).value?.markerRanges ?? false;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.marker == null
                    ? context.l10n.addMarkerAt(formatDuration(widget.seconds))
                    : context.l10n.markerEditAt(formatDuration(widget.seconds)),
                style: theme.textTheme.titleMedium,
              ),
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
              if (ranges) ...[const SizedBox(height: 12), _buildEnd(context)],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _tag == null || !_endValid || _saving ? null : _save,
                child: _saving
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(widget.marker == null ? context.l10n.addMarker : context.l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The optional end: unset, a button sets it to the current position;
  /// set, − / + move it by [_endStep] and an X removes it.
  Widget _buildEnd(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final end = _end;
    if (end == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.last_page),
          label: Text(l.markerEndSet),
          onPressed: _setEndToPosition,
        ),
      );
    }
    return InputDecorator(
      decoration: InputDecoration(
        labelText: l.markerEndOptional,
        border: const OutlineInputBorder(),
        errorText: _endValid ? null : l.markerEndInvalid,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l.markerRange(formatDuration(widget.seconds), formatDuration(end)),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          IconButton(
            tooltip: l.markerEndEarlier,
            icon: const Icon(Icons.remove),
            onPressed: () => _moveEnd(-_endStep),
          ),
          IconButton(
            tooltip: l.markerEndLater,
            icon: const Icon(Icons.add),
            onPressed: () => _moveEnd(_endStep),
          ),
          IconButton(
            tooltip: l.markerEndClear,
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _end = null),
          ),
        ],
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
