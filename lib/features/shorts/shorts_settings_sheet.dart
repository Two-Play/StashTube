import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/models/tag.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import 'shorts_settings.dart';

/// Opens the shorts settings; saves them when applied.
Future<void> showShortsSettingsSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const ShortsSettingsSheet(),
    );

class ShortsSettingsSheet extends ConsumerStatefulWidget {
  const ShortsSettingsSheet({super.key});

  @override
  ConsumerState<ShortsSettingsSheet> createState() => _ShortsSettingsSheetState();
}

class _ShortsSettingsSheetState extends ConsumerState<ShortsSettingsSheet> {
  late ShortsSettings _settings = ref.read(shortsSettingsProvider);
  Timer? _debounce;
  String _tagSearch = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleTag(Tag tag) {
    final selected = _settings.tags.any((t) => t.id == tag.id);
    setState(() => _settings = _settings.copyWith(
          tags: selected ? _settings.tags.where((t) => t.id != tag.id).toList() : [..._settings.tags, tag],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final query = _tagSearch.isEmpty ? const TagQuery() : TagQuery(search: _tagSearch, sort: TagSort.name);
    final suggestions = (ref.watch(tagListProvider(query)).current?.items ?? const <Tag>[])
        .where((t) => !_settings.tags.any((s) => s.id == t.id))
        .take(10)
        .toList();

    Widget section(String title) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
          child: Text(title, style: theme.textTheme.titleSmall),
        );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Text(l.shortsSettings, style: theme.textTheme.titleLarge),
                  section(l.shortsTags),
                  Text(l.shortsTagsHint, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  if (_settings.tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in _settings.tags)
                          InputChip(label: Text('#${tag.name}'), onDeleted: () => _toggleTag(tag)),
                      ],
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: l.searchTags,
                      prefixIcon: const Icon(Icons.sell_outlined),
                      border: const OutlineInputBorder(),
                      isDense: true,
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
                      for (final tag in suggestions)
                        ActionChip(label: Text('#${tag.name}'), onPressed: () => _toggleTag(tag)),
                    ],
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.shortsOnlyTags),
                    subtitle: Text(l.shortsOnlyTagsHint),
                    value: _settings.onlyTags,
                    onChanged: _settings.tags.isEmpty
                        ? null
                        : (v) => setState(() => _settings = _settings.copyWith(onlyTags: v)),
                  ),
                  section(l.shortsMaxLength),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final length in ShortsLength.values)
                        ChoiceChip(
                          label: Text(length.label(l)),
                          selected: _settings.length == length,
                          onSelected: (_) => setState(() => _settings = _settings.copyWith(length: length)),
                        ),
                    ],
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.shortsPortraitOnly),
                    value: _settings.portraitOnly,
                    onChanged: (v) => setState(() => _settings = _settings.copyWith(portraitOnly: v)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _settings = const ShortsSettings()),
                      child: Text(l.reset),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        ref.read(shortsSettingsProvider.notifier).set(_settings);
                        Navigator.pop(context);
                      },
                      child: Text(l.apply),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
