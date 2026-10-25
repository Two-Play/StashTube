import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../l10n/l10n.dart';
import '../settings/theme_welcome.dart';

/// One announcement: what a release brought, as bullet points.
typedef ChangelogEntry = ({int id, String title, List<String> items});

/// The announcements, newest first. Add one per release with a higher [id]
/// (not the version: the pipeline picks that only when it releases) and
/// its texts in both ARB files, one bullet per line.
List<ChangelogEntry> changelog(AppLocalizations l) => [
      (id: 1, title: l.whatsNew1Title, items: _lines(l.whatsNew1)),
    ];

List<String> _lines(String text) => [
      for (final line in text.split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
    ];

/// The newest announcement's id.
int latestChangelogId(AppLocalizations l) => changelog(l).first.id;

/// The id of the newest announcement the user has seen; null until the app
/// decided (after the first login nothing is new, see [showWhatsNewIfPending]).
class WhatsNewSeenNotifier extends Notifier<int?> {
  static const _key = 'whats_new_seen';

  @override
  int? build() => ref.watch(sharedPreferencesProvider).getInt(_key);

  Future<void> set(int id) async {
    state = id;
    await ref.read(sharedPreferencesProvider).setInt(_key, id);
  }
}

final whatsNewSeenProvider = NotifierProvider<WhatsNewSeenNotifier, int?>(WhatsNewSeenNotifier.new);

/// After an update: shows the announcements the user hasn't seen, once.
/// Right after the first login (the theme picker is pending) everything
/// counts as seen, the tour explains the app instead. Call after a frame.
Future<void> showWhatsNewIfPending(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final latest = latestChangelogId(l);
  final seen = ref.read(whatsNewSeenProvider);
  if (seen != null && seen >= latest) return;
  final notifier = ref.read(whatsNewSeenProvider.notifier);
  await notifier.set(latest);
  if (ref.read(themeWelcomeProvider) || !context.mounted) return;
  final unseen = [for (final entry in changelog(l)) if (entry.id > (seen ?? 0)) entry];
  await showWhatsNew(context, entries: unseen);
}

/// The announcements as a sheet over the whole app; all of them from
/// Settings → About.
Future<void> showWhatsNew(BuildContext context, {List<ChangelogEntry>? entries}) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => WhatsNewSheet(entries: entries ?? changelog(context.l10n)),
    );

class WhatsNewSheet extends StatelessWidget {
  const WhatsNewSheet({super.key, required this.entries});

  final List<ChangelogEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scroll) => SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.l),
                children: [
                  Text(l.whatsNewTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                  for (final entry in entries) ...[
                    const SizedBox(height: AppSpacing.l),
                    Text(entry.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.s),
                    for (final item in entry.items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: AppSpacing.m),
                              child: Icon(Icons.auto_awesome, size: 16, color: theme.colorScheme.primary),
                            ),
                            Expanded(child: Text(item, style: theme.textTheme.bodyMedium)),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.s, AppSpacing.xl, AppSpacing.l),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.whatsNewDone)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
