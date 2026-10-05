import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/status_views.dart';
import '../shell/navigation.dart';
import 'images_tab.dart';

/// One gallery: header with its details, then all of its images in file
/// order; tapping one opens the fullscreen viewer.
class GalleryPage extends ConsumerWidget {
  const GalleryPage({super.key, required this.galleryId});

  final String galleryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gallery = ref.watch(galleryProvider(galleryId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(gallery.value?.title ?? '')),
      body: ImageGridView(
        initialQuery: ImageQuery(sort: ImageSort.path, galleryId: galleryId),
        sorts: const [ImageSort.path, ImageSort.title, ImageSort.newest, ImageSort.random],
        headerSlivers: [
          SliverToBoxAdapter(
            child: gallery.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(galleryProvider(galleryId))),
              data: (g) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [
                        formatCount(g.imageCount, 'image'),
                        if (g.date != null) formatDate(g.date!),
                      ].join(' • '),
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    if (g.details != null) ...[
                      const SizedBox(height: 4),
                      Text(g.details!, maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                    ],
                    if (g.studio != null || g.performers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (g.studio != null)
                              ActionChip(
                                avatar: const Icon(Icons.subscriptions_outlined, size: 16),
                                label: Text(g.studio!.name),
                                onPressed: () => openStudio(ref, g.studio!.id),
                              ),
                            for (final p in g.performers)
                              ActionChip(
                                avatar: const Icon(Icons.person_outline, size: 16),
                                label: Text(p.name),
                                onPressed: () => openPerformer(ref, p.id),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
