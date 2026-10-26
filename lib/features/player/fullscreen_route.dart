import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'fullscreen_morph.dart';
import 'held_orientation.dart';

/// Like media_kit's [toggleFullscreen], with [enterPlayerFullscreen] and
/// [exitPlayerFullscreen]. [context] is below the [Video] (its controls').
/// The fullscreen route while it is open: there is only ever one. The
/// guard of media_kit's own (the context's [isFullscreen]) doesn't see a
/// route opened from another context, or one still being opened.
Route<void>? _openRoute;

/// Whether the player's fullscreen is open or opening.
bool get playerFullscreenOpen {
  // Gone without a pop (its navigator went away).
  if (_openRoute?.isActive == false && _openRoute?.navigator == null) _openRoute = null;
  return _openRoute != null;
}

Future<void> togglePlayerFullscreen(BuildContext context, {HeldOrientation? held, required Rect? Function() inline}) =>
    isFullscreen(context) ? exitPlayerFullscreen(context) : enterPlayerFullscreen(context, held: held, inline: inline);

/// The aspect the video's frames have, as the fullscreen shows them.
double playingAspect(VideoController controller) {
  final state = controller.player.state;
  final width = state.width;
  final height = state.height;
  return width == null || height == null || width <= 0 || height <= 0 ? 16 / 9 : width / height;
}

/// Like media_kit's [enterFullscreen], whose route just appears and lets
/// the system turn the screen in view. With [FullscreenMorph.curtainOnly]
/// (the default) the app fades to black, the route opens and the screen turns
/// underneath, then the black fades out. Otherwise the [FullscreenMorph] first carries
/// the video from its place ([inline]) into the fullscreen pose, turned the
/// way the phone is [held], while the app goes black. Then the fullscreen
/// route opens underneath, the video's `onEnterFullscreen` turns the screen
/// (and waits until it has turned), and the morph goes: what it showed is
/// exactly the fullscreen.
///
/// [context] is below the [Video] (its controls'); the route carries the
/// same inherited widgets as media_kit's, so [isFullscreen] and
/// [exitPlayerFullscreen] work in it.
Future<void> enterPlayerFullscreen(BuildContext context, {HeldOrientation? held, required Rect? Function() inline}) =>
    lock.synchronized(() async {
      if (!context.mounted || isFullscreen(context) || playerFullscreenOpen) return;
      final inherited = VideoStateInheritedWidget.of(context);
      final state = inherited.state;
      final parameters = inherited.videoViewParametersNotifier.value;
      final controller = state.widget.controller;
      final morph = fullscreenMorphKey.currentState;
      final curtain = FullscreenMorph.curtainOnly;
      if (curtain) {
        await morph?.cover();
        if (!context.mounted) return morph?.uncover();
      } else {
        morph?.show((controller: controller, aspect: playingAspect(controller), held: held, inline: inline), at: 0);
        await morph?.animateTo(1);
        if (!context.mounted) return morph?.hide();
      }
      final route = PageRouteBuilder<void>(
        // The morph covers the switch.
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
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
                  controller: controller,
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
      );
      _openRoute = route;
      route.popped.whenComplete(() {
        if (_openRoute == route) _openRoute = null;
      });
      Navigator.of(context, rootNavigator: true).push(route);
      try {
        await state.widget.onEnterFullscreen();
      } finally {
        if (curtain) {
          await morph?.uncover();
        } else {
          morph?.hide();
        }
      }
    });

/// Like media_kit's [exitFullscreen]. The route's pop calls the video's
/// `onExitFullscreen`, which shows the morph in the fullscreen pose at once
/// (also after the system's back), turns the screen back and carries the
/// video back into its place. With [FullscreenMorph.curtainOnly] the app
/// first fades to black, and `onExitFullscreen` fades it in again.
Future<void> exitPlayerFullscreen(BuildContext context) => lock.synchronized(() async {
  if (!context.mounted || !isFullscreen(context)) return;
  final morph = fullscreenMorphKey.currentState;
  if (FullscreenMorph.curtainOnly) await morph?.cover();
  if (!context.mounted || !await Navigator.of(context).maybePop()) await morph?.uncover();
});
