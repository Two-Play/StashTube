import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/design_tokens.dart';
import '../../core/config/server_config.dart';
import '../../core/utils/external_links.dart';
import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import '../edit/edit_common.dart';
import '../edit/edit_pages.dart';
import '../shell/navigation.dart';
import '../tags/tag_editor.dart';
import 'file_info.dart';
import 'scene_edits.dart';

/// "3 plays · 26.09.2012 · 1080p": the line under the player's title.
String sceneMetaText(AppLocalizations l, Scene scene) => [
      if (scene.playCount > 0) l.playsCount(scene.playCount),
      if (scene.date != null) formatDate(scene.date!),
      ?resolutionLabel(scene.height),
    ].join(' · ');

/// Opens the description sheet (WATCH-2) over the whole app: the full
/// title, the description, tags, file info and "Edit scene" — what used to
/// fill the page under the video.
Future<void> showSceneDescription(BuildContext context, Scene scene) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (_, controller) => SceneDescriptionSheet(scene: scene, controller: controller),
      ),
    );

class SceneDescriptionSheet extends ConsumerWidget {
  const SceneDescriptionSheet({super.key, required this.scene, this.controller});

  final Scene scene;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final files = ref.watch(sceneDetailsProvider(scene.id)).value?.files ?? const [];
    final tags = effectiveTags(ref, scene);
    final meta = sceneMetaText(l, scene);
    final description = scene.details?.trim() ?? '';
    final server = ref.watch(serverConfigProvider);

    // Closes the sheet, then runs [action] with a context that outlives it.
    void then(void Function(BuildContext below) action) {
      final navigator = Navigator.of(context);
      navigator.pop();
      action(navigator.context);
    }

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, AppSpacing.s),
          child: Text(text, style: theme.textTheme.titleSmall),
        );

    const sides = EdgeInsets.symmetric(horizontal: AppSpacing.l);
    return SingleChildScrollView(
      controller: controller,
      padding: EdgeInsets.only(bottom: AppSpacing.xl + MediaQuery.paddingOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: sides,
            child: SelectableText(scene.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
          ),
          if (meta.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xs, AppSpacing.l, 0),
              child: Text(meta, style: muted),
            ),
          heading(l.sceneDescription),
          Padding(
            padding: sides,
            child: description.isEmpty
                ? Text(l.noDescription, style: muted)
                : SelectableText(description, style: theme.textTheme.bodyMedium),
          ),
          heading(l.tagsTitle),
          Padding(
            padding: sides,
            child: Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final tag in tags)
                  ActionChip(
                    label: Text('#${tag.name}'),
                    labelStyle: TextStyle(color: theme.colorScheme.primary),
                    onPressed: () => then((_) => openTag(ref, tag.id)),
                  ),
                ActionChip(
                  avatar: Icon(tags.isEmpty ? Icons.add : Icons.edit_outlined, size: 16),
                  label: Text(tags.isEmpty ? l.addTags : l.editTags),
                  // A sheet over this one; the tags above update when it saves.
                  onPressed: () => showSceneTagEditor(context, scene, tags),
                ),
              ],
            ),
          ),
          if (files.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            FileInfoCard(files: files),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, 0),
            child: Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l.editScene),
                  onPressed: () => then((below) => openEditor(below, ref, SceneEditPage(scene: scene))),
                ),
                // The scene in Stash's web interface (not for the demo, which
                // has none); the browser signs in itself, no API key.
                if (server != null && server.baseUrl != ServerConfig.demoUrl)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: Text(l.openInStash),
                    onPressed: () => openExternalUrl(context, stashSceneWebUrl(server.baseUrl, scene.id)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
