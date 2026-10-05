import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../player/player_providers.dart';
import 'cast_providers.dart';
import 'cast_service.dart';

/// Cast icon like YouTube's: opens the device picker, or the "casting to"
/// sheet while connected. Hidden where Google Cast isn't available.
class CastButton extends ConsumerWidget {
  const CastButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(castServiceProvider).isSupported) return const SizedBox.shrink();
    final connection = ref.watch(castConnectionProvider).value;
    return IconButton(
      tooltip: connection == null ? 'Cast' : 'Casting to ${connection.deviceName}',
      icon: Icon(
        connection == null ? Icons.cast : Icons.cast_connected,
        color: connection == null ? color : Theme.of(context).colorScheme.primary,
      ),
      onPressed: () => showCastSheet(context),
    );
  }
}

Future<void> showCastSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => const _CastSheet(),
    );

class _CastSheet extends ConsumerWidget {
  const _CastSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(castServiceProvider);
    final connection = ref.watch(castConnectionProvider).value;
    final theme = Theme.of(context);

    if (connection != null) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.cast_connected, color: theme.colorScheme.primary),
              title: Text('Casting to ${connection.deviceName}'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.pop(context);
                    service.disconnect();
                  },
                  child: const Text('Stop casting'),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: StreamBuilder<List<CastTarget>>(
        stream: service.devices,
        builder: (context, snapshot) {
          final devices = snapshot.data ?? const [];
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text('Cast to', style: theme.textTheme.titleMedium),
              ),
              if (devices.isEmpty)
                const ListTile(
                  leading: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                  title: Text('Searching for devices…'),
                  subtitle: Text('Chromecast and the phone must be on the same Wi-Fi.'),
                ),
              for (final device in devices)
                ListTile(
                  leading: const Icon(Icons.tv),
                  title: Text(device.name),
                  subtitle: device.model == null ? null : Text(device.model!),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.pop(context);
                    try {
                      await service.connect(device);
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text('Couldn\'t connect to ${device.name}: $e')));
                    }
                  },
                ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

/// Shown over the video while casting: device, remote play/pause, ±10 s and
/// the remote position.
class CastingControls extends ConsumerWidget {
  const CastingControls({super.key, required this.connection, required this.showMinimize});

  final CastConnection connection;
  final bool showMinimize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(castServiceProvider);
    final playback = ref.watch(castPlaybackProvider).value ?? const CastPlayback();

    void seekBy(int seconds) {
      final target = playback.position + Duration(seconds: seconds);
      service.seek(target < Duration.zero ? Duration.zero : target);
    }

    return ColoredBox(
      color: Colors.black87,
      child: IconTheme(
        data: const IconThemeData(color: Colors.white),
        child: Column(
          children: [
            Row(
              children: [
                if (showMinimize)
                  IconButton(
                    tooltip: 'Minimize',
                    icon: const Icon(Icons.keyboard_arrow_down, size: 30),
                    onPressed: () => ref.read(nowPlayingProvider.notifier).collapse(),
                  ),
                const Spacer(),
                const CastButton(color: Colors.white),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Casting to ${connection.deviceName}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(tooltip: 'Back 10 s', icon: const Icon(Icons.replay_10), onPressed: () => seekBy(-10)),
                      const SizedBox(width: 16),
                      playback.loading
                          ? const SizedBox.square(
                              dimension: 48,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : IconButton(
                              iconSize: 48,
                              tooltip: playback.playing ? 'Pause' : 'Play',
                              icon: Icon(playback.playing ? Icons.pause : Icons.play_arrow),
                              onPressed: playback.playing ? service.pause : service.play,
                            ),
                      const SizedBox(width: 16),
                      IconButton(tooltip: 'Forward 10 s', icon: const Icon(Icons.forward_10), onPressed: () => seekBy(10)),
                    ],
                  ),
                  Text(
                    formatDuration(playback.position.inMilliseconds / 1000),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
