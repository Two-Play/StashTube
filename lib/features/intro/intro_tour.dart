import 'package:flutter/material.dart';

import '../../core/config/haptics.dart';
import '../../core/config/theme.dart';
import '../../l10n/l10n.dart';

/// One step of the tour: a large icon, a title and a few sentences.
typedef IntroStep = ({IconData icon, String title, String text});

/// The tour's steps: what is special about StashTube compared with Stash's
/// web UI and other video apps.
List<IntroStep> introSteps(AppLocalizations l) => [
  (icon: Icons.waving_hand_outlined, title: l.introWelcomeTitle, text: l.introWelcomeText),
  (icon: Icons.smart_display_outlined, title: l.introPlayerTitle, text: l.introPlayerText),
  (icon: Icons.slow_motion_video, title: l.introShortsTitle, text: l.introShortsText),
  (icon: Icons.video_library_outlined, title: l.introLibraryTitle, text: l.introLibraryText),
  (icon: Icons.favorite_outline, title: l.introFavoritesTitle, text: l.introFavoritesText),
  (icon: Icons.tune, title: l.introSettingsTitle, text: l.introSettingsText),
];

/// Shows the tour over the whole app (also over the settings sheet); after
/// the first login and from Settings → About.
Future<void> showIntroTour(BuildContext context) => Navigator.of(
  context,
  rootNavigator: true,
).push(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => const IntroTourPage()));

/// A short tour through the app's peculiarities, one step per page: swipe
/// or "Next", "Skip" ends it at any time.
class IntroTourPage extends StatefulWidget {
  const IntroTourPage({super.key});

  @override
  State<IntroTourPage> createState() => _IntroTourPageState();
}

class _IntroTourPageState extends State<IntroTourPage> {
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next(int count) {
    Haptics.selection();
    if (_page >= count - 1) {
      Navigator.of(context).pop();
      return;
    }
    if (MediaQuery.disableAnimationsOf(context)) {
      _pages.jumpToPage(_page + 1);
    } else {
      _pages.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final steps = introSteps(l);
    final last = _page == steps.length - 1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [if (!last) TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.introSkip))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  for (final step in steps)
                    // Large text scrolls instead of overflowing.
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.l),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            children: [
                              const SizedBox(height: AppSpacing.xl),
                              ExcludeSemantics(
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: theme.colorScheme.primaryContainer,
                                  child: Icon(step.icon, size: 48, color: theme.colorScheme.onPrimaryContainer),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                step.title,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: AppSpacing.l),
                              Text(
                                step.text,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.s, AppSpacing.l, AppSpacing.l),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: l.introProgress(_page + 1, steps.length),
                      child: ExcludeSemantics(
                        // Shrinks when large text makes the button wide.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0; i < steps.length; i++)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 6),
                                  width: i == _page ? 20 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: i == _page ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  FilledButton(onPressed: () => _next(steps.length), child: Text(last ? l.introDone : l.introNext)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
