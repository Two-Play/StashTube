import '../core/config/haptics.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/list_queries.dart';
import '../data/models/scene_filter.dart';
import '../data/models/tag.dart';
import '../data/providers.dart';
import '../l10n/l10n.dart';

/// Opens the filter sheet (5.4); returns the new filter, or null if dismissed.
/// With [forImages] (15.4) it leaves out the duration.
Future<SceneFilter?> showSceneFilterSheet(BuildContext context, SceneFilter initial, {bool forImages = false}) =>
    showModalBottomSheet<SceneFilter>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SceneFilterSheet(initial: initial, forImages: forImages),
    );

class SceneFilterSheet extends ConsumerStatefulWidget {
  const SceneFilterSheet({super.key, required this.initial, this.forImages = false});

  final SceneFilter initial;
  final bool forImages;

  @override
  ConsumerState<SceneFilterSheet> createState() => _SceneFilterSheetState();
}

class _SceneFilterSheetState extends ConsumerState<SceneFilterSheet> {
  late SceneFilter _filter = widget.initial;
  Timer? _debounce;
  String _tagSearch = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleTag(Tag tag) {
    final selected = _filter.tags.any((t) => t.id == tag.id);
    setState(() => _filter = _filter.copyWith(
          tags: selected ? _filter.tags.where((t) => t.id != tag.id).toList() : [..._filter.tags, tag],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = _tagSearch.isEmpty ? const TagQuery() : TagQuery(search: _tagSearch, sort: TagSort.name);
    final suggestions = (ref.watch(tagListProvider(query)).current?.items ?? const <Tag>[])
        .where((t) => !_filter.tags.any((s) => s.id == t.id))
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
                  Text(widget.forImages ? context.l10n.filterImages : context.l10n.filterScenes, style: theme.textTheme.titleLarge),
                  section(context.l10n.filterTagsAllOf),
                  if (_filter.tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in _filter.tags)
                          InputChip(label: Text('#${tag.name}'), onDeleted: () => _toggleTag(tag)),
                      ],
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: context.l10n.searchTags,
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
                  section(context.l10n.minimumRating),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (var stars = 0; stars <= 5; stars++)
                        ChoiceChip(
                          label: Text(stars == 0 ? context.l10n.ratingAny : '$stars★'),
                          selected: _filter.minStars == stars,
                          onSelected: (_) => setState(() => _filter = _filter.copyWith(minStars: stars)),
                        ),
                    ],
                  ),
                  if (!widget.forImages) ...[
                    section(context.l10n.duration),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final d in DurationFilter.values)
                          ChoiceChip(
                            label: Text(d.label(context.l10n)),
                            selected: _filter.duration == d,
                            onSelected: (_) => setState(() => _filter = _filter.copyWith(duration: d)),
                          ),
                      ],
                    ),
                  ],
                  section(context.l10n.quality),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final r in ResolutionFilter.values)
                        ChoiceChip(
                          label: Text(r.label(context.l10n)),
                          selected: _filter.resolution == r,
                          onSelected: (_) => setState(() => _filter = _filter.copyWith(resolution: r)),
                        ),
                    ],
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
                      onPressed: () => setState(() => _filter = SceneFilter(savedFilter: _filter.savedFilter)),
                      child: Text(context.l10n.reset),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        Haptics.light();
                        Navigator.pop(context, _filter);
                      },
                      child: Text(context.l10n.apply),
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
