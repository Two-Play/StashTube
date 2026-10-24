import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/design_tokens.dart';
import '../../core/config/haptics.dart';
import '../../data/models/group.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/paged_sliver.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';

/// "Add to group…" (PL-1): the server's groups with a checkbox each,
/// showing whether [scene] is in it; ticking adds the scene at the end of
/// the group, unticking removes it. "New group" creates one with the scene.
Future<void> showAddToGroupSheet(BuildContext context, Scene scene) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => AddToGroupSheet(scene: scene),
);

class AddToGroupSheet extends ConsumerStatefulWidget {
  const AddToGroupSheet({super.key, required this.scene});

  final Scene scene;

  /// From this many groups on the sheet has a search field.
  static const searchThreshold = 8;

  @override
  ConsumerState<AddToGroupSheet> createState() => _AddToGroupSheetState();
}

class _AddToGroupSheetState extends ConsumerState<AddToGroupSheet> {
  static const _all = GroupQuery();

  final _search = TextEditingController();
  Timer? _debounce;
  String _term = '';

  /// Toggles not yet reflected by the server's answer (optimistic UI).
  final _checked = <String, bool>{};
  final _busy = <String>{};

  /// Scenes added (+1) or removed (-1) per group since the list loaded.
  final _delta = <String, int>{};
  bool _changed = false;
  late final ProviderContainer _container;

  @override
  void initState() {
    super.initState();
    _container = ProviderScope.containerOf(context, listen: false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    // Scene counts changed; reloaded only now so the list doesn't jump
    // while the sheet is open.
    if (_changed) _container.invalidate(groupListProvider);
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _term = value.trim());
    });
  }

  void _afterChange(String groupId) {
    _changed = true;
    _container
      ..invalidate(groupProvider(groupId))
      ..invalidate(sceneGroupIdsProvider(widget.scene.id))
      // The group pages' scene lists.
      ..invalidate(sceneListProvider);
  }

  Future<void> _toggle(Group group, bool add) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    final repo = ref.read(stashRepositoryProvider);
    setState(() {
      _checked[group.id] = add;
      _busy.add(group.id);
      _delta.update(group.id, (d) => d + (add ? 1 : -1), ifAbsent: () => add ? 1 : -1);
    });
    try {
      if (add) {
        await repo.addSceneToGroup(widget.scene.id, group.id);
      } else {
        await repo.removeSceneFromGroup(widget.scene.id, group.id);
      }
      _afterChange(group.id);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(add ? l.addedToGroup(group.name) : l.removedFromGroup(group.name))),
        );
    } catch (e) {
      if (mounted) {
        setState(() {
          _checked.remove(group.id);
          _delta.update(group.id, (d) => d - (add ? 1 : -1));
        });
      }
      Haptics.error();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.groupUpdateFailed(errorText(l, e)))));
    } finally {
      if (mounted) setState(() => _busy.remove(group.id));
    }
  }

  Future<void> _newGroup() async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    final name = await showDialog<String>(context: context, builder: (_) => const _NewGroupDialog());
    if (name == null || !mounted) return;
    final repo = ref.read(stashRepositoryProvider);
    try {
      final group = await repo.createGroup(name);
      await repo.addSceneToGroup(widget.scene.id, group.id);
      _afterChange(group.id);
      // The new group has to show up in the list right away; the counts
      // reload with it.
      _container.invalidate(groupListProvider);
      if (mounted) {
        setState(() {
          _checked[group.id] = true;
          _delta.clear();
        });
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.addedToGroup(group.name))));
    } catch (e) {
      Haptics.error();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.groupCreateFailed(errorText(l, e)))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final query = _term.isEmpty ? _all : GroupQuery(search: _term);
    final provider = groupListProvider(query);
    final groups = ref.watch(provider);
    // Watched while searching too, so the field stays.
    final total = ref.watch(groupListProvider(_all)).value?.totalCount ?? 0;
    final searchable = total >= AddToGroupSheet.searchThreshold || _term.isNotEmpty;
    final membership = ref.watch(sceneGroupIdsProvider(widget.scene.id));
    final member = membership.value;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) => ScaffoldMessenger(
        // Snack bars show on the sheet, above the list.
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: LoadMoreListener(
            onLoadMore: () => ref.read(provider.notifier).loadMore(),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.s),
                    child: Text(l.addToGroupTitle, style: theme.textTheme.titleLarge),
                  ),
                ),
                if (searchable)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xs),
                      child: TextField(
                        controller: _search,
                        onChanged: _onSearch,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: l.searchGroups,
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: ListTile(
                    leading: const SizedBox(width: 40, child: Icon(Icons.add)),
                    title: Text(l.newGroup),
                    onTap: _newGroup,
                  ),
                ),
                if (membership.hasError && member == null)
                  SliverToBoxAdapter(
                    child: ErrorView(
                      error: membership.error!,
                      onRetry: () => ref.invalidate(sceneGroupIdsProvider(widget.scene.id)),
                    ),
                  )
                else
                  PagedSliver<Group>(
                    value: groups,
                    emptyMessage: _term.isEmpty ? l.groupsEmpty : l.groupsNoMatch,
                    emptyIcon: Icons.video_library_outlined,
                    padding: const EdgeInsets.only(bottom: AppSpacing.l),
                    onRetry: () => ref.invalidate(provider),
                    onLoadMore: () => ref.read(provider.notifier).loadMore(retry: true),
                    itemBuilder: (context, group) {
                      final checked = _checked[group.id] ?? member?.contains(group.id) ?? false;
                      final count = group.sceneCount + (_delta[group.id] ?? 0);
                      return CheckboxListTile(
                        key: ValueKey('group-${group.id}'),
                        value: checked,
                        onChanged: member == null || _busy.contains(group.id)
                            ? null
                            : withHaptic((value) => _toggle(group, value ?? false)),
                        secondary: SizedBox(
                          width: 40,
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.badge),
                              child: StashImage(group.frontImageUrl, fallbackIcon: Icons.video_library_outlined),
                            ),
                          ),
                        ),
                        title: Text(group.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(l.scenesCount(count < 0 ? 0 : count)),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Asks for the new group's name; pops it, or null when cancelled.
class _NewGroupDialog extends StatefulWidget {
  const _NewGroupDialog();

  @override
  State<_NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<_NewGroupDialog> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.newGroup),
      content: TextField(
        controller: _name,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(labelText: l.groupName),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: _name.text.trim().isEmpty ? null : _submit, child: Text(l.create)),
      ],
    );
  }
}
