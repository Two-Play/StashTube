import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/server_config.dart';
import '../../data/models/server_task.dart';
import '../../data/repositories/stash_repository.dart';
import '../../l10n/l10n.dart';
import '../notifications/notifications.dart';
import '../settings/settings_button.dart';

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

/// The jobs started from this app on the active server that haven't ended
/// yet: job id → the task's name.
class StartedJobsNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    ref.watch(activeServerIdProvider);
    return const {};
  }

  void add(String id, String name) => state = {...state, id: name};

  void remove(String id) => state = {...state}..remove(id);
}

final startedJobsProvider = NotifierProvider<StartedJobsNotifier, Map<String, String>>(StartedJobsNotifier.new);

/// Settings → Server tasks: Stash's scan, generate, auto tag and clean, the
/// running jobs, and whether the previews exist. Inside the settings sheet.
class ServerTasksPage extends StatefulWidget {
  const ServerTasksPage({super.key});

  /// Whether the page is open: it shows the jobs' end itself.
  static bool get isOpen => _open > 0;
  static int _open = 0;

  @override
  State<ServerTasksPage> createState() => _ServerTasksPageState();
}

class _ServerTasksPageState extends State<ServerTasksPage> {
  @override
  void initState() {
    super.initState();
    ServerTasksPage._open++;
  }

  @override
  void dispose() {
    ServerTasksPage._open--;
    super.dispose();
  }

  // Its own messenger: the app's would show the snack bars under the sheet.
  @override
  Widget build(BuildContext context) => const ScaffoldMessenger(child: _ServerTasksView());
}

/// Reports when a job started from the app ends ("Finished: Scan library",
/// NOTIF-1). Polls the queue only while such a job runs.
///
/// In the app it shows a snack bar, unless the tasks page, which shows it
/// anyway, is open. In the background (hidden or paused) it posts a system
/// notification instead when they are switched on ([notifyTaskEnded]);
/// otherwise the job is reported when the app comes back. The app only
/// notices it while the system lets it run: Android stops it after a
/// while, iOS suspends it soon after it is left, so a job that ends then is
/// reported in the app on return. Tapping the notification opens the tasks
/// page. Placed once around the shell.
class JobFinishedListener extends ConsumerStatefulWidget {
  const JobFinishedListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<JobFinishedListener> createState() => _JobFinishedListenerState();
}

class _JobFinishedListenerState extends ConsumerState<JobFinishedListener> {
  StreamSubscription<String>? _taps;

  @override
  void initState() {
    super.initState();
    final service = ref.read(notificationServiceProvider);
    if (!service.isSupported) return;
    _taps = service.taps.listen(_open);
    unawaited(service.launchPayload().then((payload) {
      if (payload != null) _open(payload);
    }));
  }

  @override
  void dispose() {
    _taps?.cancel();
    super.dispose();
  }

  void _open(String payload) {
    if (!mounted || payload != NotificationPayload.serverTasks) return;
    // Already there, or the settings sheet is open anyway.
    if (ServerTasksPage.isOpen || ref.read(settingsOpenProvider)) return;
    openSettings(context, ref, initialPage: const ServerTasksPage());
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(startedJobsProvider).isNotEmpty) {
      ref.listen(jobQueueProvider, (_, next) {
        final jobs = next.value;
        if (jobs != null) _report(jobs);
      });
    }
    return widget.child;
  }

  bool get _notificationsOn =>
      ref.read(notificationServiceProvider).isSupported && ref.read(notificationSettingsProvider).enabled;

  void _report(List<ServerJob> jobs) {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    final inApp = lifecycle == null || lifecycle == AppLifecycleState.resumed;
    // Inactive (e.g. the app switcher): reported in the app when it's back.
    final background = lifecycle == AppLifecycleState.hidden || lifecycle == AppLifecycleState.paused;
    // In the background without system notifications: reported on return.
    if (!inApp && !(background && _notificationsOn)) return;
    for (final MapEntry(key: id, value: name) in ref.read(startedJobsProvider).entries) {
      final job = jobs.where((j) => j.id == id).firstOrNull;
      // Stash drops ended jobs from the queue after a while.
      final state = job?.state ?? JobState.finished;
      if (job != null && (job.isActive || state == JobState.stopping)) continue;
      ref.read(startedJobsProvider.notifier).remove(id);
      // Stopped by the user: nothing to report.
      if (state == JobState.cancelled) continue;
      final failed = state == JobState.failed;
      if (!inApp) {
        unawaited(notifyTaskEnded(ref, l, jobId: id, taskName: name, failed: failed));
        continue;
      }
      if (ServerTasksPage.isOpen || messenger == null) continue;
      if (failed) {
        Haptics.error();
      } else {
        Haptics.medium();
      }
      messenger.showSnackBar(SnackBar(content: Text(failed ? l.taskFailedNamed(name) : l.taskFinishedNamed(name))));
    }
  }
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
                await _start(context, ref, l.taskScan, (repo) => repo.scanLibrary(options));
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
                await _start(context, ref, l.taskGenerate, (repo) => repo.generate(options));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.sell_outlined),
            title: Text(l.taskAutoTag),
            subtitle: Text(l.taskAutoTagSubtitle),
            onTap: () async {
              if (await _confirm(context, l.taskAutoTag, l.taskAutoTagSubtitle) && context.mounted) {
                await _start(context, ref, l.taskAutoTag, (repo) => repo.autoTag());
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: Text(l.taskClean),
            subtitle: Text(l.taskCleanSubtitle),
            onTap: () async {
              if (await _confirm(context, l.taskClean, l.taskCleanConfirm) && context.mounted) {
                await _start(context, ref, l.taskClean, (repo) => repo.clean());
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

/// Starts a job and reports it; the queue shows its progress, and
/// [JobFinishedListener] reports its end elsewhere in the app.
Future<void> _start(
  BuildContext context,
  WidgetRef ref,
  String name,
  Future<String> Function(StashRepository repo) task,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final l = context.l10n;
  try {
    final id = await task(ref.read(stashRepositoryProvider));
    ref.read(startedJobsProvider.notifier).add(id, name);
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
                onPressed: () => _start(context, ref, l.generateAnimatedPreviews, (repo) => repo.generate(GenerateOption.animatedPreviews)),
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
