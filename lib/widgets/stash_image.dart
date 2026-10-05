import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/server_config.dart';

/// Network image from the Stash server, sent with the API key header.
///
/// Loads gently: the image is decoded at the size it is shown at (not the
/// full file resolution) unless [decodeAtDisplaySize] is false, e.g. for a
/// zoomable viewer. While loading it shows [previewUrl] blurred when given
/// (blur-up from a small version), otherwise a shimmer placeholder.
class StashImage extends ConsumerWidget {
  const StashImage(
    this.url, {
    super.key,
    this.previewUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.decodeAtDisplaySize = true,
    this.fallbackIcon = Icons.image_not_supported_outlined,
  });

  final String? url;

  /// A smaller version of the same image (e.g. Stash's image thumbnail).
  final String? previewUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool decodeAtDisplaySize;
  final IconData fallbackIcon;

  /// Decode size for a box of [width]×[height] logical pixels: only the larger
  /// side is constrained, so the aspect ratio is kept.
  static ({int? width, int? height}) decodeSize(double? width, double? height, double devicePixelRatio) {
    int? px(double? v) => v == null || !v.isFinite || v <= 0 ? null : (v * devicePixelRatio).ceil();
    final w = px(width);
    final h = px(height);
    if (w != null && h != null) return w >= h ? (width: w, height: null) : (width: null, height: h);
    return (width: w, height: h);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final url = this.url;
    if (url == null) return _fallback(colors);
    final headers = ref.watch(authHeadersProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = decodeAtDisplaySize
            ? decodeSize(width ?? constraints.maxWidth, height ?? constraints.maxHeight,
                MediaQuery.devicePixelRatioOf(context))
            : (width: null, height: null);
        final preview = previewUrl;
        return CachedNetworkImage(
          imageUrl: url,
          httpHeaders: headers,
          width: width,
          height: height,
          fit: fit,
          memCacheWidth: size.width,
          memCacheHeight: size.height,
          fadeInDuration: const Duration(milliseconds: 250),
          fadeOutDuration: const Duration(milliseconds: 150),
          placeholder: (_, __) => preview == null
              ? ShimmerBox(width: width, height: height)
              : BlurredPreview(url: preview, headers: headers, fit: fit),
          // Stash serves SVG placeholders for missing studio/performer images,
          // which CachedNetworkImage can't decode; show an icon instead.
          errorWidget: (_, __, ___) => _fallback(colors),
        );
      },
    );
  }

  Widget _fallback(ColorScheme colors) => Container(
        width: width,
        height: height,
        color: colors.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(fallbackIcon, color: colors.onSurfaceVariant),
      );
}

/// A small image shown blurred while the full one loads.
class BlurredPreview extends StatelessWidget {
  const BlurredPreview({super.key, required this.url, required this.headers, this.fit = BoxFit.cover});

  final String url;
  final Map<String, String> headers;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => ClipRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: CachedNetworkImage(
            imageUrl: url,
            httpHeaders: headers,
            fit: fit,
            fadeInDuration: Duration.zero,
            placeholder: (_, __) => const ShimmerBox(),
            errorWidget: (_, __, ___) => const ShimmerBox(),
          ),
        ),
      );
}

/// Loading placeholder with a soft moving highlight (static when the system
/// asks for reduced motion).
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final base = colors.surfaceContainerHighest;
    final highlight = Color.lerp(base, colors.surface, 0.5)!;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final x = -1.5 + 3 * _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(x - 1, 0),
              end: Alignment(x + 1, 0),
              colors: [base, highlight, base],
            ),
          ),
        );
      },
    );
  }
}

/// Round avatar for a "channel" (performer or studio), with initials as fallback.
class ChannelAvatar extends StatelessWidget {
  const ChannelAvatar({super.key, required this.name, this.imageUrl, this.radius = 18});

  final String name;
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();
    return ClipOval(
      child: SizedBox.square(
        dimension: radius * 2,
        child: imageUrl == null
            ? _Initial(initial: initial, colors: colors, radius: radius)
            : Stack(
                fit: StackFit.expand,
                children: [
                  _Initial(initial: initial, colors: colors, radius: radius),
                  StashImage(imageUrl, fallbackIcon: Icons.person),
                ],
              ),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.initial, required this.colors, required this.radius});

  final String initial;
  final ColorScheme colors;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        color: colors.primaryContainer,
        alignment: Alignment.center,
        child: Text(
          initial,
          style: TextStyle(
            color: colors.onPrimaryContainer,
            fontSize: radius * 0.9,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
