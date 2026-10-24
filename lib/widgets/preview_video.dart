import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../data/repositories/stash_session.dart';

/// Loops Stash's MP4 preview of a scene, muted, in a player of its own
/// (not the main player's). Transparent until the first frame, so the
/// thumbnail below shows while it loads and if it fails. Lists show one at
/// a time ([AutoPreviewScope]); each costs a native player while shown.
class PreviewVideo extends ConsumerStatefulWidget {
  const PreviewVideo(this.url, {super.key});

  final String url;

  @override
  ConsumerState<PreviewVideo> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends ConsumerState<PreviewVideo> {
  final _player = Player();
  late final _controller = VideoController(_player);
  var _shown = false;

  @override
  void initState() {
    super.initState();
    _player
      ..setVolume(0)
      ..setPlaylistMode(PlaylistMode.single)
      ..open(Media(widget.url, httpHeaders: ref.read(authHeadersProvider))).ignore();
    _controller.waitUntilFirstFrameRendered.then((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: _shown ? 1 : 0,
    duration: const Duration(milliseconds: 200),
    child: Video(controller: _controller, fit: BoxFit.cover, fill: Colors.transparent, controls: _noControls),
  );
}

/// media_kit's `NoVideoControls` is `null`, which `Video` ignores.
Widget _noControls(VideoState state) => const SizedBox.shrink();
