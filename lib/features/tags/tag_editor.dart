import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/scene.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../player/scene_edits.dart';
import '../../l10n/l10n.dart';

/// Creates a tag and refreshes tag lists. Throws [StashApiException] on errors
/// (e.g. the name already exists).
Future<Tag> createTag(WidgetRef ref, String name) async {
  // The dialog or sheet may be closed before the server answers.
  final container = ProviderScope.containerOf(ref.context, listen: false);
  final tag = await container.read(stashRepositoryProvider).createTag(name.trim());
  container.invalidate(tagListProvider);
  return tag;
}

/// Dialog asking for a new tag's name; returns the created tag.
Future<Tag?> showCreateTagDialog(BuildContext context, WidgetRef ref, {String initialName = ''}) => showDialog<Tag>(
  context: context,
  builder: (_) => _CreateTagDialog(initialName: initialName),
);

class _CreateTagDialog extends ConsumerStatefulWidget {
  const _CreateTagDialog({required this.initialName});

  final String initialName;

  @override
  ConsumerState<_CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends ConsumerState<_CreateTagDialog> {
  late final _name = TextEditingController(text: widget.initialName);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final tag = await createTag(ref, _name.text);
      if (mounted) Navigator.pop(context, tag);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = errorText(context.l10n, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.newTag),
    content: TextField(
      controller: _name,
      autofocus: true,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _save(),
      decoration: InputDecoration(labelText: context.l10n.name, errorText: _error, prefixText: '#'),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
      FilledButton(onPressed: _saving ? null : _save, child: Text(context.l10n.create)),
    ],
  );
}

Future<void> showSceneTagEditor(BuildContext context, Scene scene, List<Tag> current) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => SceneTagEditor(scene: scene, initial: current),
);

/// Edits a scene's tags from the player: remove, add from search, or create
/// a new tag on the fly.
class SceneTagEditor extends ConsumerStatefulWidget {
  const SceneTagEditor({super.key, required this.scene, required this.initial});

  final Scene scene;
  final List<Tag> initial;

  @override
  ConsumerState<SceneTagEditor> createState() => _SceneTagEditorState();
}

class _SceneTagEditorState extends ConsumerState<SceneTagEditor> {
  late List<Tag> _tags = [...widget.initial];
  final _search = TextEditingController();
  Timer? _debounce;
  String _term = '';
  bool _busy = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _add(Tag tag) {
    if (_tags.any((t) => t.id == tag.id)) return;
    setState(() => _tags = [..._tags, tag]);
    _search.clear();
    _debounce?.cancel();
    setState(() => _term = '');
  }

  Future<void> _create() async {
    setState(() => _busy = true);
    try {
      _add(await createTag(ref, _term));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.tagCreateFailed(errorText(context.l10n, e)))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    final navigator = Navigator.of(context);
    try {
      await ref.read(sceneEditsProvider.notifier).setTags(widget.scene, _tags);
      // Closed meanwhile: popping now would remove the page below the sheet.
      if (mounted) navigator.pop();
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(l.tagsSaveFailed(errorText(l, e)))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = _term.isEmpty ? const TagQuery() : TagQuery(search: _term, sort: TagSort.name);
    final results = ref.watch(tagListProvider(query)).current?.items ?? const <Tag>[];
    final suggestions = results.where((t) => !_tags.any((s) => s.id == t.id)).take(12).toList();
    final exists = results.any((t) => t.name.toLowerCase() == _term.toLowerCase());

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.tagsTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              if (_tags.isEmpty)
                Text(
                  context.l10n.tagsEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in _tags)
                      InputChip(
                        label: Text('#${tag.name}'),
                        onDeleted: () => setState(() => _tags = _tags.where((t) => t.id != tag.id).toList()),
                      ),
                  ],
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: context.l10n.tagAddOrCreate,
                  prefixIcon: const Icon(Icons.sell_outlined),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (v) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _term = v.trim());
                  });
                },
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (_term.isNotEmpty && !exists)
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: Text(context.l10n.tagCreate(_term)),
                      onPressed: _busy ? null : _create,
                    ),
                  for (final tag in suggestions) ActionChip(label: Text('#${tag.name}'), onPressed: () => _add(tag)),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _busy ? null : _save, child: Text(context.l10n.tagsSave)),
            ],
          ),
        ),
      ),
    );
  }
}
