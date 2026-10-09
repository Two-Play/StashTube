import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/models/studio.dart';
import '../../data/providers.dart';
import '../../widgets/stash_image.dart';
import '../../l10n/l10n.dart';
import '../settings/settings_button.dart' show settingsOpenProvider;

/// Page frame for edit forms: "Save" in the app bar, busy state, errors.
/// [onSave] returns false when there was nothing to save.
/// Opens an edit form ([EditScaffold]) as a sheet over the whole app, like
/// the settings: closed with its X, by swiping it down or by saving. Works
/// from the player too, which it covers.
Future<void> openEditor(BuildContext context, WidgetRef ref, Widget form) async {
  // The shorts pause while a sheet covers them.
  final covered = ref.read(settingsOpenProvider.notifier);
  covered.set(true);
  try {
    await showCupertinoSheet<void>(
      context: context,
      useNestedNavigation: true,
      // The form's list scrolls with the sheet, so swiping down at its top
      // closes the sheet.
      scrollableBuilder: (_, controller) => PrimaryScrollController(controller: controller, child: form),
    );
  } finally {
    covered.set(false);
  }
}

class EditScaffold extends StatefulWidget {
  const EditScaffold({super.key, required this.title, required this.onSave, required this.children});

  final String title;
  final Future<bool> Function() onSave;
  final List<Widget> children;

  @override
  State<EditScaffold> createState() => _EditScaffoldState();
}

class _EditScaffoldState extends State<EditScaffold> {
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l = context.l10n;
    final inSheet = CupertinoSheetRoute.hasParentSheet(context);
    try {
      final saved = await widget.onSave();
      if (!mounted) return;
      inSheet ? CupertinoSheetRoute.popSheet(context) : navigator.pop();
      if (saved) messenger.showSnackBar(SnackBar(content: Text(l.saved)));
    } catch (e) {
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(l.saveFailed(errorText(l, e)))));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          // In a sheet (openEditor) an X closes it without saving.
          leading: CupertinoSheetRoute.hasParentSheet(context)
              ? IconButton(
                  tooltip: context.l10n.close,
                  icon: const Icon(Icons.close),
                  onPressed: () => CupertinoSheetRoute.popSheet(context),
                )
              : null,
          title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(context.l10n.save),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            for (final child in widget.children) Padding(padding: const EdgeInsets.only(bottom: 16), child: child),
          ],
        ),
      );
}

/// `YYYY-MM-DD` as Stash expects it, or null.
String? stashDate(DateTime? date) => date == null ? null : formatDate(date);

/// Date picker field with a clear button.
class DateField extends StatelessWidget {
  const DateField({super.key, required this.label, required this.value, required this.onChanged});

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year + 5),
          );
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: value == null
                ? const Icon(Icons.calendar_today_outlined)
                : IconButton(tooltip: context.l10n.clearField, icon: const Icon(Icons.clear), onPressed: () => onChanged(null)),
          ),
          child: Text(value == null ? '—' : formatDate(value!)),
        ),
      );
}

/// Tappable field showing the current choice, e.g. the studio.
class PickerField extends StatelessWidget {
  const PickerField({super.key, required this.label, required this.text, required this.onTap, this.onClear});

  final String label;
  final String? text;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: text != null && onClear != null
                ? IconButton(tooltip: context.l10n.clearField, icon: const Icon(Icons.clear), onPressed: onClear)
                : const Icon(Icons.chevron_right),
          ),
          child: Text(text ?? '—', maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      );
}

/// Searchable single choice of a studio.
Future<Studio?> showStudioPicker(BuildContext context) => showModalBottomSheet<Studio>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _SearchSheet<Studio>(
        hint: context.l10n.searchStudios,
        results: (ref, term) =>
            ref.watch(studioListProvider(StudioQuery(search: term.isEmpty ? null : term))).current?.items ?? const [],
        tile: (context, studio, _) => ListTile(
          leading: ChannelAvatar(name: studio.name, imageUrl: studio.imageUrl),
          title: Text(studio.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () => Navigator.pop(context, studio),
        ),
      ),
    );

/// Searchable multiple choice of performers; returns the new selection.
Future<List<Performer>?> showPerformerPicker(BuildContext context, List<Performer> selected) =>
    showModalBottomSheet<List<Performer>>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PerformerPicker(initial: selected),
    );

class _PerformerPicker extends StatefulWidget {
  const _PerformerPicker({required this.initial});

  final List<Performer> initial;

  @override
  State<_PerformerPicker> createState() => _PerformerPickerState();
}

class _PerformerPickerState extends State<_PerformerPicker> {
  late List<Performer> _selected = [...widget.initial];

  @override
  Widget build(BuildContext context) => _SearchSheet<Performer>(
        hint: context.l10n.searchPerformers,
        header: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final p in _selected)
              InputChip(
                label: Text(p.name),
                onDeleted: () => setState(() => _selected = _selected.where((s) => s.id != p.id).toList()),
              ),
          ],
        ),
        results: (ref, term) =>
            ref.watch(performerListProvider(PerformerQuery(search: term.isEmpty ? null : term))).current?.items ??
            const [],
        tile: (context, performer, _) {
          final isSelected = _selected.any((p) => p.id == performer.id);
          return CheckboxListTile(
            value: isSelected,
            secondary: ChannelAvatar(name: performer.name, imageUrl: performer.imageUrl),
            title: Text(performer.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            onChanged: withHaptic((_) => setState(() => _selected = isSelected
                ? _selected.where((p) => p.id != performer.id).toList()
                : [..._selected, performer])),
          );
        },
        footer: FilledButton(onPressed: () => Navigator.pop(context, _selected), child: Text(context.l10n.done)),
      );
}

class _SearchSheet<T> extends ConsumerStatefulWidget {
  const _SearchSheet({required this.hint, required this.results, required this.tile, this.header, this.footer});

  final String hint;
  final List<T> Function(WidgetRef ref, String term) results;
  final Widget Function(BuildContext context, T item, WidgetRef ref) tile;
  final Widget? header;
  final Widget? footer;

  @override
  ConsumerState<_SearchSheet<T>> createState() => _SearchSheetState<T>();
}

class _SearchSheetState<T> extends ConsumerState<_SearchSheet<T>> {
  Timer? _debounce;
  String _term = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.results(ref, _term);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  prefixIcon: const Icon(Icons.search),
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
            ),
            if (widget.header != null)
              Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: widget.header),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) => widget.tile(context, items[i], ref),
              ),
            ),
            if (widget.footer != null)
              SafeArea(top: false, child: Padding(padding: const EdgeInsets.all(16), child: widget.footer)),
          ],
        ),
      ),
    );
  }
}
