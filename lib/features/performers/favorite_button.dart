import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/performer.dart';
import '../../widgets/confetti.dart';
import 'performer_favorites.dart';
import '../../l10n/l10n.dart';

Future<void> _toggle(BuildContext context, WidgetRef ref, Performer performer) async {
  final messenger = ScaffoldMessenger.of(context);
  final l = context.l10n;
  try {
    await ref.read(performerFavoritesProvider.notifier).toggle(performer);
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(l.favoriteUpdateFailed(errorText(l, e)))));
  }
}

/// The heart grows past its size and springs back.
final _heartPop = TweenSequence<double>([
  TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.45).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
  TweenSequenceItem(tween: Tween(begin: 1.45, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)), weight: 70),
]);

/// Shared by both buttons: confetti and the heart pop when a performer
/// becomes a favorite, a plain change when removed.
mixin _FavoriteAnimation<T extends ConsumerStatefulWidget> on ConsumerState<T>, TickerProvider {
  late final heart = AnimationController(vsync: this, duration: const Duration(milliseconds: 700), value: 1);
  int bursts = 0;

  Future<void> onPressed(Performer performer, {required bool favorite}) async {
    if (favorite) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
      if (!MediaQuery.disableAnimationsOf(context)) {
        setState(() => bursts++);
        heart.forward(from: 0);
      }
    }
    await _toggle(context, ref, performer);
  }

  @override
  void dispose() {
    heart.dispose();
    super.dispose();
  }
}

/// Compact YouTube "Subscribe"-style button under a performer's name. It
/// bursts into confetti when the performer becomes a favorite, and morphs
/// into the new state (color, label, width).
class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton({super.key, required this.performer});

  final Performer performer;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin, _FavoriteAnimation {
  @override
  Widget build(BuildContext context) {
    final favorite = effectiveFavorite(ref, widget.performer);
    final colors = Theme.of(context).colorScheme;
    void press() => onPressed(widget.performer, favorite: favorite);

    return ConfettiBurst(
      trigger: bursts,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        alignment: Alignment.centerLeft,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(animation), child: child),
          ),
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.centerLeft,
            children: [...previous, ?current],
          ),
          child: favorite
              ? FilledButton.tonalIcon(
                  key: const ValueKey('favorited'),
                  style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                  onPressed: press,
                  icon: ScaleTransition(
                    scale: _heartPop.animate(heart),
                    child: const Icon(Icons.favorite, color: Colors.redAccent),
                  ),
                  label: Text(context.l10n.favorited),
                )
              : FilledButton.icon(
                  key: const ValueKey('favorite'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.onSurface,
                    foregroundColor: colors.surface,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: press,
                  icon: const Icon(Icons.favorite_border),
                  label: Text(context.l10n.favorite),
                ),
        ),
      ),
    );
  }
}

/// Compact heart toggle, e.g. on performer tiles, with a smaller burst.
class FavoriteIconButton extends ConsumerStatefulWidget {
  const FavoriteIconButton({super.key, required this.performer});

  final Performer performer;

  @override
  ConsumerState<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends ConsumerState<FavoriteIconButton>
    with SingleTickerProviderStateMixin, _FavoriteAnimation {
  @override
  Widget build(BuildContext context) {
    final favorite = effectiveFavorite(ref, widget.performer);
    return ConfettiBurst(
      trigger: bursts,
      pieces: 18,
      power: 0.6,
      child: IconButton(
        tooltip: favorite ? context.l10n.favoriteRemove : context.l10n.favoriteAdd,
        visualDensity: VisualDensity.compact,
        style: IconButton.styleFrom(backgroundColor: Colors.black38),
        onPressed: () => onPressed(widget.performer, favorite: favorite),
        icon: ScaleTransition(
          scale: _heartPop.animate(heart),
          child: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.redAccent : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
