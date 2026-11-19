import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/haptics.dart';
import '../core/config/server_config.dart';
import '../core/config/theme.dart';
import '../l10n/l10n.dart';

/// Whether long lists show the "Back to top" button (Settings → Appearance);
/// on by default, stored for all servers.
class ScrollToTopNotifier extends Notifier<bool> {
  static const _key = 'scroll_to_top_button';

  @override
  bool build() {
    final SharedPreferences prefs;
    try {
      prefs = ref.watch(sharedPreferencesProvider);
    } catch (_) {
      // Tests of single lists don't provide preferences.
      return true;
    }
    return prefs.getBool(_key) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setBool(_key, value);
  }
}

final scrollToTopProvider = NotifierProvider<ScrollToTopNotifier, bool>(ScrollToTopNotifier.new);

/// Around a vertical list: once it is scrolled down further than
/// [ScrollToTop.threshold] screens, a "Back to top" pill floats at the bottom
/// center (clear of the FABs on the right) and scrolls the list back up.
/// Listens only to its child's outermost scrollable, not to rows inside it.
class ScrollToTop extends ConsumerStatefulWidget {
  const ScrollToTop({super.key, required this.child});

  final Widget child;

  /// In screen heights.
  static const threshold = 1.5;

  /// Further than this many screens, the list first jumps closer, so the
  /// way up doesn't build every item on the way.
  static const jumpBeyond = 6.0;

  @override
  ConsumerState<ScrollToTop> createState() => _ScrollToTopState();
}

class _ScrollToTopState extends ConsumerState<ScrollToTop> {
  ScrollPosition? _position;
  bool _shown = false;

  bool _onScroll(ScrollNotification n) {
    if (n.depth != 0 || n.metrics.axis != Axis.vertical) return false;
    final context = n.context;
    if (context != null) _position = Scrollable.maybeOf(context)?.position;
    final viewport = n.metrics.viewportDimension;
    final shown = viewport > 0 && n.metrics.pixels > viewport * ScrollToTop.threshold;
    if (shown != _shown) setState(() => _shown = shown);
    return false;
  }

  void _toTop() {
    final position = _position;
    if (position == null || !position.hasPixels) return;
    Haptics.selection();
    final viewport = position.viewportDimension;
    if (position.pixels > viewport * ScrollToTop.jumpBeyond) position.jumpTo(viewport * 2);
    if (MediaQuery.disableAnimationsOf(context)) {
      position.jumpTo(0);
    } else {
      position.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(scrollToTopProvider);
    final list = NotificationListener<ScrollNotification>(onNotification: _onScroll, child: widget.child);
    if (!enabled) return list;
    final shown = _shown;
    final animate = !MediaQuery.disableAnimationsOf(context);
    return Stack(
      children: [
        list,
        Positioned(
          left: 0,
          right: 0,
          bottom: AppSpacing.l,
          child: Center(
            child: IgnorePointer(
              ignoring: !shown,
              child: ExcludeSemantics(
                excluding: !shown,
                child: AnimatedSlide(
                  offset: shown ? Offset.zero : const Offset(0, 0.5),
                  duration: animate ? const Duration(milliseconds: 200) : Duration.zero,
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: shown ? 1 : 0,
                    duration: animate ? const Duration(milliseconds: 200) : Duration.zero,
                    child: FilledButton.tonalIcon(
                      key: const ValueKey('scroll-to-top'),
                      onPressed: _toTop,
                      icon: const Icon(Icons.arrow_upward),
                      label: Text(context.l10n.scrollToTop),
                      style: FilledButton.styleFrom(elevation: 3, shadowColor: Theme.of(context).colorScheme.shadow),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
