import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/config/theme.dart';
import '../../l10n/l10n.dart';
import '../settings/theme_welcome.dart';

/// One announcement: what a release brought, one change per line, each with
/// a fitting icon. [items] are the highlights; [more] shows behind "Show
/// more".
typedef ChangelogEntry = ({int id, String title, List<ChangelogItem> items, List<ChangelogItem> more});

typedef ChangelogItem = ({IconData icon, String text});

/// The announcements, newest first. Add one per release with a higher [id]
/// (not the version: the pipeline picks that only when it releases) and
/// its texts in both ARB files, one change per line, the most relevant
/// first, and an icon per line.
List<ChangelogEntry> changelog(AppLocalizations l) => [
      (
        id: 1,
        title: l.whatsNew1Title,
        items: _items(l.whatsNew1, const [
          Icons.space_dashboard_outlined, // navigation
          Icons.loop, // loops
          Icons.smart_display_outlined, // watch page
          Icons.search, // suggestions
          Icons.fast_forward_outlined, // double tap to skip
          Icons.swap_horiz, // back and forward
          Icons.person_outline, // channel tabs
          Icons.favorite_border, // favorites
        ]),
        more: _items(l.whatsNew1More, const [
          Icons.account_circle_outlined, // you tab
          Icons.tune, // skip settings
          Icons.star_outline, // stars, favorites
          Icons.add_circle_outline, // create
          Icons.open_in_full, // full video
          Icons.tablet_outlined, // tablets
          Icons.picture_in_picture_alt_outlined, // pip
          Icons.dns_outlined, // server tasks
          Icons.image_search, // preview check
          Icons.notifications_none, // notification
          Icons.straighten, // marker ranges
          Icons.fiber_new_outlined, // new since last visit
          Icons.error_outline, // playback errors
          Icons.cloud_off_outlined, // connection banner
          Icons.login, // login
          Icons.info_outline, // image details
          Icons.casino_outlined, // dice
          Icons.bar_chart, // stats chart
          Icons.lock_outline, // touch lock
          Icons.fullscreen, // fullscreen transition
          Icons.screen_rotation_outlined, // portrait on phones
          Icons.visibility_off_outlined, // calmer shorts
          Icons.crop_outlined, // thumbnails
          Icons.explore_outlined, // tour
          Icons.settings_outlined, // settings
        ]),
      ),
    ];

/// One item per line; a plain bullet if a translation has more lines than
/// icons.
List<ChangelogItem> _items(String text, List<IconData> icons) {
  final lines = _lines(text);
  return [
    for (var i = 0; i < lines.length; i++) (icon: i < icons.length ? icons[i] : Icons.circle, text: lines[i]),
  ];
}

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
                    _EntryItems(entry: entry),
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

/// An entry's highlights, and the rest behind "Show more".
class _EntryItems extends StatefulWidget {
  const _EntryItems({required this.entry});

  final ChangelogEntry entry;

  @override
  State<_EntryItems> createState() => _EntryItemsState();
}

class _EntryItemsState extends State<_EntryItems> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final more = widget.entry.more;
    Widget item(ChangelogItem item) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.m),
                child: Icon(item.icon, size: item.icon == Icons.circle ? 6 : 20, color: theme.colorScheme.primary),
              ),
              Expanded(child: Text(item.text, style: theme.textTheme.bodyMedium)),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final i in widget.entry.items) item(i),
        if (_expanded) for (final i in more) item(i),
        if (more.isNotEmpty)
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(_expanded ? l.whatsNewShowLess : l.whatsNewShowMore(more.length)),
          ),
      ],
    );
  }
}
