import 'package:flutter/material.dart';

import 'stash_image.dart';

/// Channel-page header shared by performers and studios: banner image,
/// avatar, name and a stats line.
class ChannelHeader extends StatelessWidget {
  const ChannelHeader({
    super.key,
    required this.name,
    this.imageUrl,
    this.subtitle,
    this.description,
    this.leadingBadge,
    this.action,
  });

  final String name;
  final String? imageUrl;
  final String? subtitle;
  final String? description;

  /// Small widget shown before the name, e.g. a country flag.
  final Widget? leadingBadge;

  /// Full-width button below the header, like YouTube's "Subscribe".
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl != null)
          SizedBox(
            height: 140,
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: StashImage(imageUrl, fit: BoxFit.cover),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              ChannelAvatar(name: name, imageUrl: imageUrl, radius: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (leadingBadge != null) ...[leadingBadge!, const SizedBox(width: 8)],
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        if (action != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(width: double.infinity, child: action),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
