import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/server_config.dart';

/// Network image from the Stash server, sent with the API key header.
class StashImage extends ConsumerWidget {
  const StashImage(
    this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallbackIcon = Icons.image_not_supported_outlined,
  });

  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: width,
      height: height,
      color: colors.surfaceContainerHighest,
    );
    final url = this.url;
    if (url == null) return _fallback(colors);

    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: ref.watch(authHeadersProvider),
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, __) => placeholder,
      // Stash serves SVG placeholders for missing studio/performer images,
      // which CachedNetworkImage can't decode; show an icon instead.
      errorWidget: (_, __, ___) => _fallback(colors),
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
