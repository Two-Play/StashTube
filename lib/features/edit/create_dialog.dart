import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/group.dart';
import '../../data/models/performer.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';

/// Creates a performer with [name] and refreshes the performer lists.
/// Throws [StashApiException] on errors (e.g. the name already exists).
Future<Performer> createPerformer(WidgetRef ref, String name) async {
  // The dialog may be closed before the server answers.
  final container = ProviderScope.containerOf(ref.context, listen: false);
  final performer = await container.read(stashRepositoryProvider).createPerformer(name.trim());
  container.invalidate(performerListProvider);
  return performer;
}

/// Creates a studio with [name] and refreshes the studio lists.
Future<Studio> createStudio(WidgetRef ref, String name) async {
  final container = ProviderScope.containerOf(ref.context, listen: false);
  final studio = await container.read(stashRepositoryProvider).createStudio(name.trim());
  container.invalidate(studioListProvider);
  return studio;
}

/// Creates a group with [name] and refreshes the group lists.
Future<Group> createGroup(WidgetRef ref, String name) async {
  final container = ProviderScope.containerOf(ref.context, listen: false);
  final group = await container.read(stashRepositoryProvider).createGroup(name.trim());
  container.invalidate(groupListProvider);
  return group;
}

/// Dialog asking for a name and creating something with it through
/// [create]; returns what was created, or null when cancelled. A failure
/// (e.g. the name exists) shows under the field and keeps the dialog open.
Future<T?> showCreateDialog<T>(
  BuildContext context, {
  required String title,
  required Future<T> Function(String name) create,
  String initialName = '',
  String? prefix,
  TextCapitalization capitalization = TextCapitalization.words,
}) =>
    showDialog<T>(
      context: context,
      builder: (_) => _CreateDialog<T>(
        title: title,
        create: create,
        initialName: initialName,
        prefix: prefix,
        capitalization: capitalization,
      ),
    );

class _CreateDialog<T> extends StatefulWidget {
  const _CreateDialog({
    required this.title,
    required this.create,
    required this.initialName,
    this.prefix,
    required this.capitalization,
  });

  final String title;
  final TextCapitalization capitalization;
  final Future<T> Function(String name) create;
  final String initialName;
  final String? prefix;

  @override
  State<_CreateDialog<T>> createState() => _CreateDialogState<T>();
}

class _CreateDialogState<T> extends State<_CreateDialog<T>> {
  late final _name = TextEditingController(text: widget.initialName);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final created = await widget.create(_name.text);
      if (mounted) Navigator.pop(context, created);
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
    title: Text(widget.title),
    content: TextField(
      controller: _name,
      autofocus: true,
      textCapitalization: widget.capitalization,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _save(),
      decoration: InputDecoration(labelText: context.l10n.name, errorText: _error, prefixText: widget.prefix),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
      FilledButton(onPressed: _saving ? null : _save, child: Text(context.l10n.create)),
    ],
  );
}
