import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../core/config/theme.dart';
import '../../core/utils/format.dart';
import '../../data/models/image_item.dart';
import '../../l10n/l10n.dart';
import '../../widgets/play_pause_icon.dart';
import '../../widgets/stash_image.dart';

/// A gallery's video file (#64) on its page in the image viewer: the
/// thumbnail, and over it the video once [controller] plays it (only the
/// current page gets one; the viewer owns the player).
class ImageVideoPage extends StatelessWidget {
  const ImageVideoPage({super.key, required this.image, this.controller});

  final ImageItem image;
  final VideoController? controller;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: StashImage(image.thumbnailUrl, fit: BoxFit.contain, fallbackIcon: Icons.movie_outlined),
        ),
        if (controller != null)
          Video(controller: controller, fit: BoxFit.contain, fill: Colors.transparent, controls: _noControls)
        else
          const Center(child: Icon(Icons.play_circle_outline, color: Colors.white70, size: 64)),
      ],
    );
  }
}

/// media_kit's `NoVideoControls` is `null`, which `Video` ignores.
Widget _noControls(VideoState state) => const SizedBox.shrink();

/// Play/pause, the position as a slider, the times and mute, for the video
/// in the image viewer's bottom overlay.
class ImageVideoBar extends StatefulWidget {
  const ImageVideoBar({super.key, required this.player});

  final Player player;

  @override
  State<ImageVideoBar> createState() => _ImageVideoBarState();
}

class _ImageVideoBarState extends State<ImageVideoBar> {
  final _subscriptions = <StreamSubscription<Object?>>[];
  late bool _playing;
  late Duration _position;
  late Duration _duration;
  late double _volume;

  /// The slider's value while it is dragged, in seconds.
  double? _dragging;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(ImageVideoBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.player != widget.player) {
      _cancel();
      _listen();
    }
  }

  void _listen() {
    final player = widget.player;
    final state = player.state;
    _playing = state.playing;
    _position = state.position;
    _duration = state.duration;
    _volume = state.volume;
    void update(VoidCallback change) {
      if (mounted) setState(change);
    }

    _subscriptions.addAll([
      player.stream.playing.listen((v) => update(() => _playing = v)),
      player.stream.position.listen((v) => update(() => _position = v)),
      player.stream.duration.listen((v) => update(() => _duration = v)),
      player.stream.volume.listen((v) => update(() => _volume = v)),
    ]);
  }

  void _cancel() {
    for (final s in _subscriptions) {
      unawaited(s.cancel());
    }
    _subscriptions.clear();
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final player = widget.player;
    final total = _duration.inMilliseconds / 1000;
    final position = (_dragging ?? _position.inMilliseconds / 1000).clamp(0.0, total > 0 ? total : 0.0);
    final muted = _volume == 0;
    const text = TextStyle(color: Colors.white, fontFeatures: [FontFeature.tabularFigures()]);
    return Row(
      children: [
        IconButton(
          tooltip: _playing ? l.imageVideoPause : l.imageVideoPlay,
          onPressed: () => unawaited(player.playOrPause()),
          icon: PlayPauseIcon(playing: _playing, color: Colors.white),
        ),
        Text(formatDuration(position), style: text),
        Expanded(
          child: Slider(
            value: position,
            max: total > 0 ? total : 1,
            onChanged: total > 0 ? (v) => setState(() => _dragging = v) : null,
            onChangeEnd: (v) {
              unawaited(player.seek(Duration(milliseconds: (v * 1000).round())));
              setState(() => _dragging = null);
            },
            semanticFormatterCallback: (v) => formatDuration(v),
          ),
        ),
        Text(formatDuration(total), style: text),
        const SizedBox(width: AppSpacing.xs),
        IconButton(
          tooltip: muted ? l.imageVideoUnmute : l.imageVideoMute,
          onPressed: () => unawaited(player.setVolume(muted ? 100 : 0)),
          icon: Icon(muted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
        ),
      ],
    );
  }
}

/// The play symbol and length on a video's grid tile.
class VideoBadge extends StatelessWidget {
  const VideoBadge({super.key, required this.seconds});

  final double seconds;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 1),
      decoration: BoxDecoration(color: colors.badgeBackground, borderRadius: AppRadius.badgeBorder),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow, size: 14, color: colors.onBadge),
          Text(
            formatDuration(seconds),
            style: TextStyle(color: colors.onBadge, fontSize: AppTextSize.overlayLabel, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
