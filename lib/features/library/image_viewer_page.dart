import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../core/utils/format.dart';
import '../../data/models/image_item.dart';
import '../../data/models/list_queries.dart';
import '../../data/providers.dart';
import '../../widgets/stash_image.dart';

/// Fullscreen image viewer: swipe between images, pinch to zoom, tap to
/// toggle the info overlay. Loads more images when nearing the end.
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
    final state = ref.read(imageListProvider(widget.query)).value;
    if (state != null && index >= state.items.length - 5) {
      ref.read(imageListProvider(widget.query).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(imageListProvider(widget.query)).value?.items ?? const <ImageItem>[];
    final headers = ref.watch(authHeadersProvider);
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
                headers: headers,
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
  const _ZoomableImage({required this.image, required this.headers, required this.onZoomChanged});

  final ImageItem image;
  final Map<String, String> headers;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage> {
  final _transform = TransformationController();

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.image.imageUrl ?? widget.image.thumbnailUrl;
    return InteractiveViewer(
      transformationController: _transform,
      maxScale: 5,
      onInteractionEnd: (_) => widget.onZoomChanged(_transform.value.getMaxScaleOnAxis() > 1.01),
      child: Center(
        child: url == null
            ? const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64)
            : CachedNetworkImage(
                imageUrl: url,
                httpHeaders: widget.headers,
                fit: BoxFit.contain,
                fadeInDuration: Duration.zero,
                // Show the (usually cached) thumbnail while the full image loads.
                placeholder: (_, __) => StashImage(widget.image.thumbnailUrl, fit: BoxFit.contain),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
              ),
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({required this.image, required this.position, required this.total});

  final ImageItem? image;
  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    final meta = [
      if (image?.studio != null) image!.studio!.name,
      ...?image?.performers.map((p) => p.name),
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
                      Text(image.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      if (meta.isNotEmpty) Text(meta, style: const TextStyle(color: Colors.white70)),
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
