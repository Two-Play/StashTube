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

  /// Compact button under the name and stats, e.g. "Favorite".
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
                    ChannelTitleAnchor(
                      child: Row(
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
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    if (action != null) ...[const SizedBox(height: 8), action!],
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
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Scaffold for pages whose header shows the name (performer, studio, tag,
/// group): the app bar's [title] fades in only once the header's
/// [ChannelTitleAnchor] has scrolled away under the app bar, so the name
/// isn't shown twice (CH-1). Without an anchor (loading, errors) the title
/// stays hidden.
class ChannelScaffold extends StatefulWidget {
  const ChannelScaffold({super.key, required this.title, this.actions, required this.body});

  final Widget title;
  final List<Widget>? actions;
  final Widget body;

  @override
  State<ChannelScaffold> createState() => _ChannelScaffoldState();
}

class _ChannelScaffoldState extends State<ChannelScaffold> {
  final _anchorKey = GlobalKey();
  final _bodyKey = GlobalKey();
  bool _showTitle = false;

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification || notification is ScrollMetricsNotification) _update();
    return false;
  }

  void _update() {
    if (!mounted) return;
    final anchor = _anchorKey.currentContext?.findRenderObject();
    final body = _bodyKey.currentContext?.findRenderObject();
    var show = false;
    if (anchor is RenderBox && body is RenderBox && anchor.attached && body.attached && anchor.hasSize) {
      final anchorBottom = anchor.localToGlobal(Offset(0, anchor.size.height)).dy;
      show = anchorBottom <= body.localToGlobal(Offset.zero).dy + 0.5;
    }
    if (show != _showTitle) setState(() => _showTitle = show);
  }

  @override
  Widget build(BuildContext context) {
    // The header may appear or move without a scroll (data loaded, rotation).
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _showTitle ? 1 : 0,
          duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
          child: widget.title,
        ),
        actions: widget.actions,
      ),
      body: _ChannelTitleScope(
        anchorKey: _anchorKey,
        child: NotificationListener<Notification>(
          onNotification: _onNotification,
          child: KeyedSubtree(key: _bodyKey, child: widget.body),
        ),
      ),
    );
  }
}

class _ChannelTitleScope extends InheritedWidget {
  const _ChannelTitleScope({required this.anchorKey, required super.child});

  /// Null below a disabled [ChannelTitleAnchorScope].
  final GlobalKey? anchorKey;

  @override
  bool updateShouldNotify(_ChannelTitleScope oldWidget) => anchorKey != oldWidget.anchorKey;
}

/// Turns the [ChannelTitleAnchor]s below it off unless [enabled], e.g. in
/// the headers of a channel's hidden tabs (each tab scrolls its own copy of
/// the header), so only the shown tab's header drives the title.
class ChannelTitleAnchorScope extends StatelessWidget {
  const ChannelTitleAnchorScope({super.key, required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final key = context.dependOnInheritedWidgetOfExactType<_ChannelTitleScope>()?.anchorKey;
    return _ChannelTitleScope(anchorKey: enabled ? key : null, child: child);
  }
}

/// Marks the name in a page's header: [ChannelScaffold] shows its app bar
/// title once this has scrolled out of view. Use it once per page (or once
/// per enabled [ChannelTitleAnchorScope]).
class ChannelTitleAnchor extends StatelessWidget {
  const ChannelTitleAnchor({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final key = context.dependOnInheritedWidgetOfExactType<_ChannelTitleScope>()?.anchorKey;
    return key == null ? child : KeyedSubtree(key: key, child: child);
  }
}
