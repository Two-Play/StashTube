import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/models/image_item.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/performer.dart';
import '../../data/providers.dart';
import '../shell/navigation.dart';
import '../../widgets/stash_image.dart';

/// Fullscreen image viewer: swipe between images, pinch or double tap to
/// zoom, tap to toggle the info overlay (with the performers). Loads more images when nearing the end.
class ImageViewerPage extends ConsumerStatefulWidget {
  const ImageViewerPage({super.key, required this.query, required this.initialIndex});

  final ImageQuery query;
  final int initialIndex;

  @override
  ConsumerState<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends ConsumerState<ImageViewerPage> {
  late final _pageController = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;
  bool _showOverlay = true;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _index = index;
      _zoomed = false;
    });
    final state = ref.read(imageListProvider(widget.query)).current;
    if (state != null && index >= state.items.length - 5) {
      ref.read(imageListProvider(widget.query).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(imageListProvider(widget.query)).current?.items ?? const <ImageItem>[];
    final current = _index < items.length ? items[_index] : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            // While zoomed in, horizontal drags pan the image instead of paging.
            physics: _zoomed ? const NeverScrollableScrollPhysics() : null,
            itemCount: items.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() => _showOverlay = !_showOverlay),
              child: _ZoomableImage(
                image: items[i],
                onZoomChanged: (zoomed) {
                  if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
                },
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showOverlay ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_showOverlay,
              child: _Overlay(image: current, position: _index + 1, total: items.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomableImage extends StatefulWidget {
  const _ZoomableImage({required this.image, required this.onZoomChanged});

  final ImageItem image;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage> with SingleTickerProviderStateMixin {
  static const _doubleTapScale = 2.5;

  final _transform = TransformationController();
  late final AnimationController _animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 220))
    ..addListener(() => _transform.value = _zoomTween!.transform(Curves.easeOut.transform(_animation.value)));
  Matrix4Tween? _zoomTween;
  Offset _doubleTapAt = Offset.zero;

  @override
  void dispose() {
    _animation.dispose();
    _transform.dispose();
    super.dispose();
  }

  bool get _isZoomed => _transform.value.getMaxScaleOnAxis() > 1.01;

  /// Zooms in around the tapped point, or back out when already zoomed.
  void _onDoubleTap() {
    final zoomIn = !_isZoomed;
    final p = _doubleTapAt;
    final end = zoomIn
        ? (Matrix4.diagonal3Values(_doubleTapScale, _doubleTapScale, 1)
            ..setTranslationRaw(-p.dx * (_doubleTapScale - 1), -p.dy * (_doubleTapScale - 1), 0))
        : Matrix4.identity();
    _zoomTween = Matrix4Tween(begin: _transform.value, end: end);
    _animation.forward(from: 0);
    widget.onZoomChanged(zoomIn);
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.image.imageUrl ?? widget.image.thumbnailUrl;
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapAt = details.localPosition,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transform,
        maxScale: 5,
        onInteractionStart: (_) => _animation.stop(),
        onInteractionEnd: (_) => widget.onZoomChanged(_isZoomed),
        child: Center(
          child: url == null
              ? const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64)
              // Blur-up: the (usually cached) thumbnail first, then the full
              // image at full resolution so zooming stays sharp.
              : StashImage(
                  url,
                  previewUrl: url == widget.image.thumbnailUrl ? null : widget.image.thumbnailUrl,
                  fit: BoxFit.contain,
                  decodeAtDisplaySize: false,
                  fallbackIcon: Icons.broken_image_outlined,
                ),
        ),
      ),
    );
  }
}

class _Overlay extends ConsumerWidget {
  const _Overlay({required this.image, required this.position, required this.total});

  final ImageItem? image;
  final int position;
  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = this.image;
    final meta = [
      if (image?.studio != null) image!.studio!.name,
      if (image?.date != null) formatDate(image!.date!),
    ].join(' • ');

    return Column(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.transparent],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                const BackButton(color: Colors.white),
                Expanded(
                  child: Text(
                    total == 0 ? '' : '$position / ${formatNumber(total)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        if (image != null)
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        image.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      if (meta.isNotEmpty) Text(meta, style: const TextStyle(color: Colors.white70)),
                      if (image.performers.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final performer in image.performers)
                              _PerformerChip(
                                performer: performer,
                                // The viewer covers the shell, so close it to
                                // show the performer page in the current tab.
                                onTap: () {
                                  openPerformer(ref, performer.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PerformerChip extends StatelessWidget {
  const _PerformerChip({required this.performer, required this.onTap});

  final Performer performer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white24,
    shape: const StadiumBorder(),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChannelAvatar(name: performer.name, imageUrl: performer.imageUrl, radius: 14),
            const SizedBox(width: 8),
            Text(performer.name, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}
