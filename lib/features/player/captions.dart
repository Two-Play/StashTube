import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../data/models/scene_details.dart';
import '../../data/providers.dart';
import '../../l10n/l10n.dart';
import 'player_providers.dart';

/// The subtitle language to switch on again for the next scenes (the ISO
/// code of the caption picked last); null = subtitles off.
class PreferredCaptionNotifier extends Notifier<String?> {
  static const _key = 'caption_language';

  @override
  String? build() => ref.watch(sharedPreferencesProvider).getString(_key);

  Future<void> set(String? language) async {
    state = language;
    final prefs = ref.read(sharedPreferencesProvider);
    if (language == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, language);
    }
  }
}

final preferredCaptionProvider = NotifierProvider<PreferredCaptionNotifier, String?>(PreferredCaptionNotifier.new);

/// The subtitles showing on the current scene; null = none.
class ActiveCaptionNotifier extends Notifier<SceneCaption?> {
  @override
  SceneCaption? build() => null;

  void set(SceneCaption? caption) => state = caption;
}

final activeCaptionProvider = NotifierProvider<ActiveCaptionNotifier, SceneCaption?>(ActiveCaptionNotifier.new);

/// Whether the scene has subtitles to pick from (decides if the button shows).
final hasCaptionsProvider = Provider.autoDispose.family<bool, String>(
  (ref, sceneId) => ref.watch(sceneDetailsProvider(sceneId).select((d) => d.value?.captions.isNotEmpty ?? false)),
);

/// "JA", or "JA · SRT" when the scene has the language in several formats;
/// "Unknown language" for Stash's "00".
String captionLabel(BuildContext context, SceneCaption caption, {bool withType = false}) {
  final language = caption.languageKnown ? caption.languageCode.toUpperCase() : context.l10n.captionUnknownLanguage;
  return withType ? '$language · ${caption.type.toUpperCase()}' : language;
}

/// Bottom sheet to switch the subtitles of [sceneId] on or off.
Future<void> showCaptionSheet(BuildContext context, String sceneId) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _CaptionSheet(sceneId: sceneId),
    );

class _CaptionSheet extends ConsumerWidget {
  const _CaptionSheet({required this.sceneId});

  final String sceneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captions = ref.watch(sceneDetailsProvider(sceneId)).value?.captions ?? const <SceneCaption>[];
    final active = ref.watch(activeCaptionProvider);
    final languages = {for (final c in captions) c.languageCode};
    void pick(SceneCaption? caption) {
      Navigator.pop(context);
      ref.read(nowPlayingProvider.notifier).selectCaption(caption);
    }

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(context.l10n.subtitles, style: Theme.of(context).textTheme.titleMedium),
            ),
            ListTile(
              leading: Icon(active == null ? Icons.check : null),
              title: Text(context.l10n.subtitlesOff),
              onTap: () => pick(null),
            ),
            for (final caption in captions)
              ListTile(
                leading: Icon(caption == active ? Icons.check : null),
                title: Text(captionLabel(context, caption, withType: languages.length < captions.length)),
                onTap: () => pick(caption),
              ),
          ],
        ),
      ),
    );
  }
}
