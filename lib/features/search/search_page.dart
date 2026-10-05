import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/performer_tile.dart';
import '../../widgets/scene_feed.dart';
import '../shell/navigation.dart';
import '../tags/tags_page.dart';

/// Live search across scenes, with matching performers shown on top.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _term = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _term = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: (v) {
            _debounce?.cancel();
            setState(() => _term = v.trim());
          },
          decoration: InputDecoration(
            hintText: 'Search Stash',
            border: InputBorder.none,
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _term = '');
                    },
                  ),
          ),
        ),
      ),
      body: _term.isEmpty
          ? const _Discover()
          : SceneFeedView(
              key: ValueKey(_term),
              layout: SceneFeedLayout.list,
              initialQuery: SceneQuery(sort: SceneSort.recentlyAdded, search: _term),
              sorts: const [],
              emptyMessage: 'No scenes match "$_term"',
              headerSlivers: [_PerformerResults(term: _term)],
            ),
    );
  }
}

class _PerformerResults extends ConsumerWidget {
  const _PerformerResults({required this.term});

  final String term;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performers = ref.watch(performerListProvider(PerformerQuery(search: term))).value?.items ?? const [];
    if (performers.isEmpty) return const SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Performers', style: Theme.of(context).textTheme.titleMedium),
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: performers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => PerformerBubble(performer: performers[i]),
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}

/// Shown before typing: popular tags to explore (8.2).
class _Discover extends ConsumerWidget {
  const _Discover();

  static const _shown = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tags = ref.watch(tagListProvider(const TagQuery())).value?.items ?? const [];

    return CustomScrollView(
      slivers: [
        if (tags.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 4, 4),
              child: Row(
                children: [
                  Expanded(child: Text('Popular tags', style: theme.textTheme.titleMedium)),
                  TextButton(onPressed: () => openTags(ref), child: const Text('See all')),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: tagGridDelegate,
              delegate: SliverChildBuilderDelegate(
                (_, i) => TagTile(tag: tags[i]),
                childCount: tags.length.clamp(0, _shown),
              ),
            ),
          ),
        ] else
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 64, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('Search scenes and performers', style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
