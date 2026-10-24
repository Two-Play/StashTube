import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/image_details.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../../widgets/stash_image.dart';
import '../../widgets/status_views.dart';

/// What the info sheet links to; the viewer opens it after closing.
enum ImageInfoTarget { performer, studio, tag, gallery }

typedef ImageInfoLink = ({ImageInfoTarget target, String id});

/// The info sheet for one image. It is modal, so the viewer can't page
/// underneath it: it always describes the image it was opened on. Resolves
/// to the page the user tapped (a performer, ...), or null when dismissed.
Future<ImageInfoLink?> showImageInfoSheet(BuildContext context, String imageId) =>
    showModalBottomSheet<ImageInfoLink>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (_, controller) => ImageInfoSheet(imageId: imageId, scrollController: controller),
      ),
    );

class ImageInfoSheet extends ConsumerWidget {
  const ImageInfoSheet({super.key, required this.imageId, this.scrollController});

  final String imageId;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(imageDetailsProvider(imageId));
    return SafeArea(
      child: switch (details) {
        AsyncValue(:final value?) => _Details(details: value, scrollController: scrollController),
        AsyncValue(:final error?) => SingleChildScrollView(
          controller: scrollController,
          child: ErrorView(error: error, onRetry: () => ref.invalidate(imageDetailsProvider(imageId))),
        ),
        _ => const LoadingView(),
      },
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.details, this.scrollController});

  final ImageDetails details;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final d = details;
    final file = d.file;
    final stars = d.rating100 == null ? 0 : (d.rating100! / 20).round().clamp(0, 5);

    void open(ImageInfoTarget target, String id) => Navigator.of(context).pop<ImageInfoLink>((target: target, id: id));

    final rows = <(String, Widget)>[
      if (d.date != null) (l.fieldDate, _value(context, formatDate(d.date!))),
      if (d.photographer != null) (l.imagePhotographer, _value(context, d.photographer!)),
      if (file?.width != null && file?.height != null)
        (l.imageDimensions, _value(context, '${file!.width} × ${file.height}')),
      if (file?.size != null) (l.fileSize, _value(context, formatBytes(file!.size!.toDouble()))),
      if (file?.format != null) (l.fileFormat, _value(context, file!.format!.toUpperCase())),
      if (file != null) (l.fileName, SelectableText(file.name, style: theme.textTheme.bodyMedium)),
      if (stars > 0) (l.ratingLabel, _Stars(stars: stars)),
      if (d.oCounter > 0) (l.imageOCounter, _value(context, formatNumber(d.oCounter))),
      if (d.organized) (l.organized, Icon(Icons.check_circle, size: 20, color: theme.colorScheme.primary, semanticLabel: l.organized)),
      if (d.created != null) (l.imageCreated, _value(context, formatDate(d.created!.toLocal()))),
      if (d.updated != null) (l.imageUpdated, _value(context, formatDate(d.updated!.toLocal()))),
    ];
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    // Wider with large text, but the values keep most of the row.
    final labelWidth = MediaQuery.textScalerOf(context).scale(110).clamp(110.0, 170.0);
    const sides = EdgeInsets.symmetric(horizontal: AppSpacing.l);

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, AppSpacing.s),
      child: Semantics(header: true, child: Text(text, style: theme.textTheme.titleSmall)),
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      children: [
        Padding(
          padding: sides,
          child: Semantics(
            header: true,
            child: Text(l.imageInfo, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
        ),
        if (d.title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xs, AppSpacing.l, 0),
            child: SelectableText(d.title!, style: theme.textTheme.titleLarge),
          ),
        const SizedBox(height: AppSpacing.s),
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.xs),
            child: MergeSemantics(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: labelWidth, child: Text(label, style: muted)),
                  Expanded(child: Align(alignment: AlignmentDirectional.centerStart, child: value)),
                ],
              ),
            ),
          ),
        if (d.studio case final studio?) ...[
          heading(l.fieldStudio),
          ListTile(
            leading: ChannelAvatar(name: studio.name, imageUrl: studio.imageUrl),
            title: Text(studio.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(ImageInfoTarget.studio, studio.id),
          ),
        ],
        if (d.performers.isNotEmpty) ...[
          heading(l.fieldPerformers),
          Padding(
            padding: sides,
            child: Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final p in d.performers)
                  ActionChip(
                    avatar: ChannelAvatar(name: p.name, imageUrl: p.imageUrl, radius: 12),
                    label: Text(p.name),
                    onPressed: () => open(ImageInfoTarget.performer, p.id),
                  ),
              ],
            ),
          ),
        ],
        if (d.tags.isNotEmpty) ...[
          heading(l.imageTags),
          Padding(
            padding: sides,
            child: Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final tag in d.tags)
                  ActionChip(
                    label: Text('#${tag.name}'),
                    labelStyle: TextStyle(color: theme.colorScheme.primary),
                    onPressed: () => open(ImageInfoTarget.tag, tag.id),
                  ),
              ],
            ),
          ),
        ],
        if (d.galleries.isNotEmpty) ...[
          heading(l.imageGalleries),
          for (final gallery in d.galleries)
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(gallery.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => open(ImageInfoTarget.gallery, gallery.id),
            ),
        ],
        if (d.details case final text?) ...[
          heading(l.fieldDetails),
          Padding(padding: sides, child: SelectableText(text, style: theme.textTheme.bodyMedium)),
        ],
      ],
    );
  }

  static Widget _value(BuildContext context, String text) => Text(text, style: Theme.of(context).textTheme.bodyMedium);
}

class _Stars extends StatelessWidget {
  const _Stars({required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.of(context).rating;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      label: context.l10n.ratingValue(stars),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(
                i <= stars ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 20,
                color: i <= stars ? color : muted,
              ),
          ],
        ),
      ),
    );
  }
}
