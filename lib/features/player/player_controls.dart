import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/utils/format.dart';
import '../../data/models/scene.dart';
import '../../data/models/scene_details.dart';
import '../../data/providers.dart';
import 'player_providers.dart';
import 'video_controls.dart';

/// Claims single taps inside the expanded player.
///
/// The miniplayer package wraps the whole panel in a `GestureDetector` whose
/// `onTap` collapses an expanded panel. media_kit detects single taps with a
/// raw `Listener`, so without this guard every tap on the video (or on empty
/// space in the details) ends up collapsing the player. A deeper tap
/// recognizer wins the gesture arena; buttons, double-tap and drag still work.
class PanelTapGuard extends StatelessWidget {
  const PanelTapGuard({super.key, this.enabled = true, required this.child});

  /// When false, taps reach the miniplayer again (e.g. tap-to-expand on the
  /// collapsed bar). Toggling keeps the widget tree stable.
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      GestureDetector(behavior: HitTestBehavior.opaque, onTap: enabled ? () {} : null, child: child);
}

/// The one video surface of the player, used both in the miniplayer and in
/// the expanded view so it is never rebuilt during the transition.
///
/// With [showControls] it shows [StashVideoControls]: double tap to seek
/// ±10 s (4.11), quality (4.10), scrubbing with previews (4.14), and outside
/// fullscreen a collapse button.
class PlayerVideo extends ConsumerWidget {
  const PlayerVideo({super.key, required this.scene, required this.showControls});

  final Scene scene;
  final bool showControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Video(
        controller: ref.watch(videoControllerProvider),
        // The same builder is used by media_kit's fullscreen route.
        controls: showControls
            ? (state) => StashVideoControls(
                  fullscreen: state.isFullscreen(),
                  onToggleFullscreen: state.toggleFullscreen,
                  scene: scene,
                  onQuality: () => showQualitySheet(context, scene.id),
                )
            : NoVideoControls,
      );
}

String _streamDescription(SceneStream stream) {
  if (stream.isDirect) return 'Original file';
  if (stream.isHls) return 'Adaptive streaming';
  return 'Transcoded – seeking may be limited';
}

/// Bottom sheet listing the scene's `sceneStreams`.
Future<void> showQualitySheet(BuildContext context, String sceneId) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _QualitySheet(sceneId: sceneId),
    );

class _QualitySheet extends ConsumerWidget {
  const _QualitySheet({required this.sceneId});

  final String sceneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(sceneDetailsProvider(sceneId));
    final current = ref.watch(currentStreamProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
        child: switch (details) {
          AsyncData(:final value) when value.streams.isNotEmpty => ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text('Quality', style: Theme.of(context).textTheme.titleMedium),
                ),
                for (final stream in value.streams)
                  ListTile(
                    leading: Icon(
                      (current == null ? stream.isDirect : current.label == stream.label)
                          ? Icons.check
                          : null,
                    ),
                    title: Text(stream.label),
                    subtitle: Text(_streamDescription(stream)),
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(nowPlayingProvider.notifier).selectStream(stream);
                    },
                  ),
              ],
            ),
          AsyncData() => const ListTile(title: Text('No alternative streams available')),
          AsyncError(:final error) => ListTile(
              leading: const Icon(Icons.error_outline),
              title: const Text('Couldn\'t load streams'),
              subtitle: Text(error.toString()),
            ),
          _ => const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator())),
        },
      ),
    );
  }
}

/// Thin progress line under the video with a tick per chapter (scene marker).
class ChapterStrip extends ConsumerWidget {
  const ChapterStrip({super.key, required this.markers, required this.duration});

  final List<SceneMarker> markers;

  /// Fallback duration in seconds until the player reports one.
  final double duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final colors = Theme.of(context).colorScheme;
    return StreamBuilder<Duration>(
      stream: player.stream.position,
      initialData: player.state.position,
      builder: (context, snapshot) {
        final total = player.state.duration.inMilliseconds > 0
            ? player.state.duration.inMilliseconds / 1000
            : duration;
        final position = snapshot.data!.inMilliseconds / 1000;
        return SizedBox(
          height: 4,
          width: double.infinity,
          child: CustomPaint(
            painter: _ChapterPainter(
              progress: total > 0 ? (position / total).clamp(0.0, 1.0) : 0,
              ticks: [if (total > 0) for (final m in markers) (m.seconds / total).clamp(0.0, 1.0)],
              track: colors.surfaceContainerHighest,
              fill: colors.primary,
              tick: colors.surface,
            ),
          ),
        );
      },
    );
  }
}

class _ChapterPainter extends CustomPainter {
  _ChapterPainter({
    required this.progress,
    required this.ticks,
    required this.track,
    required this.fill,
    required this.tick,
  });

  final double progress;
  final List<double> ticks;
  final Color track;
  final Color fill;
  final Color tick;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = track);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width * progress, size.height), Paint()..color = fill);
    // Gaps between chapters, like YouTube's segmented seek bar.
    final gap = Paint()..color = tick;
    for (final t in ticks) {
      if (t <= 0) continue;
      canvas.drawRect(Rect.fromLTWH(size.width * t - 1, 0, 2, size.height), gap);
    }
  }

  @override
  bool shouldRepaint(_ChapterPainter old) =>
      old.progress != progress || old.ticks.length != ticks.length || old.fill != fill;
}

/// Horizontal list of chapters; tapping one seeks there. Highlights the
/// chapter currently playing.
class ChapterList extends ConsumerWidget {
  const ChapterList({super.key, required this.details});

  final SceneDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final player = ref.watch(playerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('Chapters', style: theme.textTheme.titleSmall),
        ),
        SizedBox(
          height: 64,
          child: StreamBuilder<Duration>(
            stream: player.stream.position,
            initialData: player.state.position,
            builder: (context, snapshot) {
              final current = details.markerAt(snapshot.data!.inMilliseconds / 1000);
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: details.markers.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final marker = details.markers[i];
                  final active = identical(marker, current);
                  return Material(
                    color: active ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => ref.read(nowPlayingProvider.notifier).seekTo(marker.seconds),
                      child: Container(
                        width: 140,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatDuration(marker.seconds),
                              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                            ),
                            Text(marker.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
