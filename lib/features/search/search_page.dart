import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/performer_tile.dart';
import '../../widgets/scene_feed.dart';

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
          ? const _SearchHint()
          : SceneFeedView(
              key: ValueKey(_term),
              compact: true,
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
    final performers = ref.watch(performerListProvider(PerformerQuery(search: term))).valueOrNull?.items ?? const [];
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

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 64, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('Search scenes and performers', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
