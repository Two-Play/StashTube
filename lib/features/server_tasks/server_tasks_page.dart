import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../data/models/server_task.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';

/// Stash's task queue, polled while someone watches it.
class JobQueueNotifier extends AsyncNotifier<List<ServerJob>> {
  static const interval = Duration(seconds: 2);

  @override
  Future<List<ServerJob>> build() {
    final timer = Timer.periodic(interval, (_) => refresh());
    ref.onDispose(timer.cancel);
    return ref.watch(stashRepositoryProvider).jobQueue();
  }

  Future<void> refresh() async {
    try {
      final jobs = await ref.read(stashRepositoryProvider).jobQueue();
      if (ref.mounted) state = AsyncData(jobs);
    } catch (e, stack) {
      // A failed poll keeps the last list; the next one tries again.
      if (ref.mounted && !state.hasValue) state = AsyncError(e, stack);
    }
  }
}

final jobQueueProvider = AsyncNotifierProvider.autoDispose<JobQueueNotifier, List<ServerJob>>(JobQueueNotifier.new);

/// Whether the server has the previews the lists play (a random sample).
final previewCheckProvider = FutureProvider.autoDispose<PreviewCheck>(
  (ref) => ref.watch(stashRepositoryProvider).checkPreviews(),
);

/// Settings → Server tasks: Stash's scan, generate, auto tag and clean, the
/// running jobs, and whether the previews exist. Inside the settings sheet.
class ServerTasksPage extends StatelessWidget {
  const ServerTasksPage({super.key});

  // Its own messenger: the app's would show the snack bars under the sheet.
  @override
  Widget build(BuildContext context) => const ScaffoldMessenger(child: _ServerTasksView());
}

class _ServerTasksView extends ConsumerWidget {
  const _ServerTasksView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    // A finished job may have created the previews.
    ref.listen(jobQueueProvider, (previous, next) {
      final before = previous?.value?.where((j) => j.isActive).length ?? 0;
      final now = next.value?.where((j) => j.isActive).length ?? 0;
      if (now < before) ref.invalidate(previewCheckProvider);
    });
    return Scaffold(
      appBar: AppBar(title: Text(l.serverTasks)),
      body: ListView(
        children: [
          _SectionTitle(
            l.sectionPreviewCheck,
            trailing: IconButton(
              tooltip: l.checkAgain,
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(previewCheckProvider),
            ),
          ),
          const _PreviewCheckTiles(),
          _SectionTitle(l.sectionTasks),
          ListTile(
            leading: const Icon(Icons.manage_search),
            title: Text(l.taskScan),
            subtitle: Text(l.taskScanSubtitle),
            onTap: () async {
              final options = await _pickOptions(
                context,
                title: l.taskScan,
                heading: l.taskScanGenerates,
                values: ScanOption.values,
                initial: ScanOption.standard,
                label: (o) => o.label(l),
              );
              if (options != null && context.mounted) {
                await _start(context, ref, (repo) => repo.scanLibrary(options));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_motion_outlined),
            title: Text(l.taskGenerate),
            subtitle: Text(l.taskGenerateSubtitle),
            onTap: () async {
              final options = await _pickOptions(
                context,
                title: l.taskGenerate,
                values: GenerateOption.values,
                initial: GenerateOption.standard,
                label: (o) => o.label(l),
              );
              if (options != null && context.mounted) {
                await _start(context, ref, (repo) => repo.generate(options));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.sell_outlined),
            title: Text(l.taskAutoTag),
            subtitle: Text(l.taskAutoTagSubtitle),
            onTap: () async {
              if (await _confirm(context, l.taskAutoTag, l.taskAutoTagSubtitle) && context.mounted) {
                await _start(context, ref, (repo) => repo.autoTag());
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: Text(l.taskClean),
            subtitle: Text(l.taskCleanSubtitle),
            onTap: () async {
              if (await _confirm(context, l.taskClean, l.taskCleanConfirm) && context.mounted) {
                await _start(context, ref, (repo) => repo.clean());
              }
            },
          ),
          _SectionTitle(l.sectionJobs),
          const _JobList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Starts a job and reports it; the queue shows its progress.
Future<void> _start(BuildContext context, WidgetRef ref, Future<String> Function(StashRepository repo) task) async {
  final messenger = ScaffoldMessenger.of(context);
  final l = context.l10n;
  try {
    await task(ref.read(stashRepositoryProvider));
    Haptics.medium();
    messenger.showSnackBar(SnackBar(content: Text(l.taskStarted)));
    await ref.read(jobQueueProvider.notifier).refresh();
  } catch (e) {
    Haptics.error();
    messenger.showSnackBar(SnackBar(content: Text(errorText(l, e))));
  }
}

Future<bool> _confirm(BuildContext context, String title, String body) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(context.l10n.startTask)),
        ],
      ),
    ) ??
    false;

/// A sheet of check boxes for a task's options; null when dismissed.
Future<Set<T>?> _pickOptions<T>(
  BuildContext context, {
  required String title,
  String? heading,
  required List<T> values,
  required Set<T> initial,
  required String Function(T) label,
}) => showModalBottomSheet<Set<T>>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) {
    final selected = {...initial};
    return StatefulBuilder(
      builder: (context, setState) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(title, style: Theme.of(context).textTheme.titleLarge),
              ),
              if (heading != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Text(heading, style: Theme.of(context).textTheme.bodyMedium),
                ),
              for (final value in values)
                CheckboxListTile(
                  title: Text(label(value)),
                  value: selected.contains(value),
                  onChanged: withHaptic(
                    (on) => setState(() => on == true ? selected.add(value) : selected.remove(value)),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: Text(context.l10n.startTask),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);

class _PreviewCheckTiles extends ConsumerWidget {
  const _PreviewCheckTiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return switch (ref.watch(previewCheckProvider)) {
      AsyncData(:final value) when value.scenes == 0 => ListTile(title: Text(l.previewCheckNothing)),
      AsyncData(:final value) => Column(
        children: [
          _CheckTile(title: l.previewCheckAnimated, found: value.animated, checked: value.scenes),
          _CheckTile(title: l.previewCheckVideo, found: value.videos, checked: value.scenes),
          if (value.markers > 0)
            _CheckTile(title: l.previewCheckMarkers, found: value.markerAnimated, checked: value.markers),
          if (value.animated < value.scenes || value.markerAnimated < value.markers) ...[
            ListTile(leading: const Icon(Icons.info_outline), subtitle: Text(l.previewCheckMissingHint)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.auto_awesome_motion_outlined),
                label: Text(l.generateAnimatedPreviews),
                onPressed: () => _start(context, ref, (repo) => repo.generate(GenerateOption.animatedPreviews)),
              ),
            ),
          ],
        ],
      ),
      AsyncError(:final error) => ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(errorText(l, error)),
        trailing: TextButton(onPressed: () => ref.invalidate(previewCheckProvider), child: Text(l.retry)),
      ),
      _ => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _CheckTile extends StatelessWidget {
  const _CheckTile({required this.title, required this.found, required this.checked});

  final String title;
  final int found;
  final int checked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: found == checked
          ? Icon(Icons.check_circle_outline, color: scheme.primary)
          : Icon(found == 0 ? Icons.cancel_outlined : Icons.warning_amber_outlined, color: scheme.error),
      title: Text(title),
      subtitle: Text(context.l10n.previewCheckFound(found, checked)),
    );
  }
}

class _JobList extends ConsumerWidget {
  const _JobList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return switch (ref.watch(jobQueueProvider)) {
      AsyncData(:final value) when value.isEmpty => ListTile(title: Text(l.noJobs)),
      AsyncData(:final value) => Column(children: [for (final job in value) _JobTile(job)]),
      AsyncError(:final error) => ListTile(leading: const Icon(Icons.error_outline), title: Text(errorText(l, error))),
      _ => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _JobTile extends ConsumerWidget {
  const _JobTile(this.job);

  final ServerJob job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final progress = job.progress;
    final detail = job.error ?? job.subTasks.firstOrNull;
    return ListTile(
      title: Text(job.description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text([job.state.label(l), if (progress != null) '${(progress * 100).round()} %'].join(' · ')),
          if (detail != null) Text(detail, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (job.isActive)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(value: progress),
            ),
        ],
      ),
      trailing: job.isActive
          ? IconButton(
              tooltip: l.stopJob,
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: () async {
                Haptics.light();
                try {
                  await ref.read(stashRepositoryProvider).stopJob(job.id);
                } catch (_) {
                  // The queue shows whether it stopped.
                }
                await ref.read(jobQueueProvider.notifier).refresh();
              },
            )
          : null,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(16, 20, trailing == null ? 16 : 4, 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
