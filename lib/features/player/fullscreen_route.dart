import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// How long entering fullscreen takes; leaving is a bit faster.
const kFullscreenDuration = Duration(milliseconds: 380);
const kFullscreenReverseDuration = Duration(milliseconds: 260);

/// The share of the transition in which the screen goes black, before the
/// video grows in. The phone turns meanwhile, so the turn isn't seen.
const _blackShare = 0.35;

/// Like media_kit's [toggleFullscreen], but with [enterPlayerFullscreen]'s
/// animation. [context] is below the [Video] (its controls').
Future<void> togglePlayerFullscreen(BuildContext context) =>
    isFullscreen(context) ? exitFullscreen(context) : enterPlayerFullscreen(context);

/// Like media_kit's [enterFullscreen], whose route appears without any
/// transition: the screen fades to black, the video's `onEnterFullscreen`
/// (system bars, orientation) runs while it is black, then the video grows
/// in from slightly smaller. Leaving plays it backwards. Without animations
/// (reduced motion) it switches at once.
///
/// [context] is below the [Video] (its controls'); the route carries the
/// same inherited widgets as media_kit's, so [isFullscreen] and
/// [exitFullscreen] work in it.
Future<void> enterPlayerFullscreen(BuildContext context) => lock.synchronized(() async {
  if (!context.mounted || isFullscreen(context)) return;
  final inherited = VideoStateInheritedWidget.of(context);
  final state = inherited.state;
  final parameters = inherited.videoViewParametersNotifier.value;
  final animate = !MediaQuery.disableAnimationsOf(context);
  Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      transitionDuration: animate ? kFullscreenDuration : Duration.zero,
      reverseTransitionDuration: animate ? kFullscreenReverseDuration : Duration.zero,
      transitionsBuilder: (_, animation, _, child) => _FullscreenTransition(animation: animation, child: child),
      pageBuilder: (_, _, _) => Material(
        color: Colors.black,
        child: VideoStateInheritedWidget(
          state: state,
          contextNotifier: inherited.contextNotifier,
          videoViewParametersNotifier: inherited.videoViewParametersNotifier,
          disposeNotifiers: false,
          child: FullscreenInheritedWidget(
            parent: state,
            // Another VideoStateInheritedWidget inside, as in media_kit:
            // it tells the controls about the fullscreen context.
            child: VideoStateInheritedWidget(
              state: state,
              contextNotifier: inherited.contextNotifier,
              videoViewParametersNotifier: inherited.videoViewParametersNotifier,
              disposeNotifiers: false,
              child: Video(
                controller: state.widget.controller,
                fit: parameters.fit,
                fill: parameters.fill,
                alignment: parameters.alignment,
                aspectRatio: parameters.aspectRatio,
                filterQuality: parameters.filterQuality,
                controls: parameters.controls,
                // The inline Video holds the wakelock.
                wakelock: false,
                pauseUponEnteringBackgroundMode: state.widget.pauseUponEnteringBackgroundMode,
                resumeUponEnteringForegroundMode: state.widget.resumeUponEnteringForegroundMode,
                subtitleViewConfiguration: parameters.subtitleViewConfiguration,
                focusNode: parameters.focusNode,
                onEnterFullscreen: state.widget.onEnterFullscreen,
                onExitFullscreen: state.widget.onExitFullscreen,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  // Turn the phone and hide the system bars once the screen is black.
  if (animate) await Future<void>.delayed(kFullscreenDuration * _blackShare);
  await state.widget.onEnterFullscreen();
});

/// Black fades in over the page below, then the video fades in growing from
/// 92 %.
class _FullscreenTransition extends StatelessWidget {
  const _FullscreenTransition({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final black = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, _blackShare, curve: Curves.easeOut),
    );
    final video = CurvedAnimation(
      parent: animation,
      curve: const Interval(_blackShare * 0.8, 1, curve: Curves.easeOutCubic),
      reverseCurve: const Interval(0, 1, curve: Curves.easeInCubic),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        FadeTransition(
          opacity: black,
          child: const ColoredBox(color: Colors.black),
        ),
        FadeTransition(
          opacity: video,
          child: ScaleTransition(scale: Tween(begin: 0.92, end: 1.0).animate(video), child: child),
        ),
      ],
    );
  }
}
