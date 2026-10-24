import 'package:flutter/material.dart';
import '../data/repositories/stash_repository.dart';
import '../l10n/l10n.dart';

/// Shown when a list has no entries: a symbol for what is missing in a soft
/// accent-tinted circle, a title, an optional hint and an optional action
/// (e.g. what to do about it).
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.hint,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? hint;

  /// A button under the hint; shown when both [actionLabel] and [onAction]
  /// are set.
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primaryContainer.withValues(alpha: 0.5),
            ),
            child: Icon(icon, size: 44, color: colors.onPrimaryContainer),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (hint != null) ...[
            const SizedBox(height: 6),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            actionIcon != null
                ? FilledButton.tonalIcon(onPressed: onAction, icon: Icon(actionIcon), label: Text(actionLabel!))
                : FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

/// A failed load (STATE-2): an icon for the kind of error, a short headline,
/// one plain sentence about what to do, "Retry", and the technical message
/// behind "Details" (selectable, for bug reports). Snack bars use
/// [errorText] instead.
class ErrorView extends StatefulWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  /// The symbol for [error]: offline, a lock for access, else an error.
  static IconData iconFor(Object error) => switch (error) {
        StashApiException(kind: StashErrorKind.unreachable) => Icons.cloud_off,
        StashApiException(kind: StashErrorKind.localNetworkDenied) => Icons.wifi_off,
        StashApiException(kind: StashErrorKind.unauthorized || StashErrorKind.invalidCredentials) =>
          Icons.lock_outline,
        StashApiException(kind: StashErrorKind.notFound) => Icons.search_off,
        _ => Icons.error_outline,
      };

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  bool _showDetails = false;

  @override
  void didUpdateWidget(ErrorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error != widget.error) _showDetails = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l = context.l10n;
    final error = widget.error;
    final explanation = errorExplanation(l, error);
    final details = errorDetails(error);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colors.errorContainer.withValues(alpha: 0.6)),
            child: Icon(ErrorView.iconFor(error), size: 44, color: colors.onErrorContainer),
          ),
          const SizedBox(height: 20),
          Text(
            errorHeadline(l, error),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            explanation,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
          if (widget.onRetry != null) ...[
            const SizedBox(height: 20),
            FilledButton.tonalIcon(onPressed: widget.onRetry, icon: const Icon(Icons.refresh), label: Text(l.retry)),
          ],
          if (details != null && details != explanation) ...[
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => setState(() => _showDetails = !_showDetails),
              child: Text(_showDetails ? l.errorHideDetails : l.errorShowDetails),
            ),
            if (_showDetails)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(details, style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
              ),
          ],
        ],
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
}
