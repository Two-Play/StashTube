import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/haptics.dart';
import '../../core/config/server_config.dart';
import '../../l10n/l10n.dart';
import '../settings/settings_categories.dart';
import 'notification_service.dart';

export 'notification_service.dart';

/// The platform's notifications; overridden in tests with a fake.
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService.create());

/// Whether the app posts system notifications (off by default, for
/// discretion), and whether they leave out names. For the device, not per
/// server.
@immutable
class NotificationSettings {
  const NotificationSettings({this.enabled = false, this.discreet = true});

  final bool enabled;

  /// Only "StashTube" and a neutral text, and nothing on the lock screen.
  final bool discreet;

  @override
  bool operator ==(Object other) =>
      other is NotificationSettings && other.enabled == enabled && other.discreet == discreet;

  @override
  int get hashCode => Object.hash(enabled, discreet);
}

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  static const _enabledKey = 'notifications_enabled';
  static const _discreetKey = 'notifications_discreet';

  @override
  NotificationSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return NotificationSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      discreet: prefs.getBool(_discreetKey) ?? true,
    );
  }

  /// Asks for the permission first; false (and still off) when denied.
  Future<bool> enable() async {
    final granted = await ref.read(notificationServiceProvider).requestPermission();
    if (!granted || !ref.mounted) return false;
    await ref.read(sharedPreferencesProvider).setBool(_enabledKey, true);
    if (ref.mounted) state = NotificationSettings(enabled: true, discreet: state.discreet);
    return true;
  }

  Future<void> disable() async {
    state = NotificationSettings(enabled: false, discreet: state.discreet);
    await ref.read(sharedPreferencesProvider).setBool(_enabledKey, false);
  }

  Future<void> setDiscreet(bool discreet) async {
    state = NotificationSettings(enabled: state.enabled, discreet: discreet);
    await ref.read(sharedPreferencesProvider).setBool(_discreetKey, discreet);
  }
}

final notificationSettingsProvider = NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

/// Posts that a server task ended, following the settings: with discreet
/// notifications only "StashTube" and a neutral text, otherwise the task's
/// and the server's names. Does nothing while they are off.
Future<bool> notifyTaskEnded(
  WidgetRef ref,
  AppLocalizations l, {
  required String jobId,
  required String taskName,
  required bool failed,
}) async {
  final settings = ref.read(notificationSettingsProvider);
  final service = ref.read(notificationServiceProvider);
  if (!settings.enabled || !service.isSupported) return false;
  final server = ref.read(serverProfilesProvider).active?.name;
  await service.show(
    AppNotification(
      id: jobId.hashCode & 0x7fffffff,
      title: settings.discreet ? 'StashTube' : (failed ? l.taskFailedNamed(taskName) : l.taskFinishedNamed(taskName)),
      body: settings.discreet ? (failed ? l.notificationTaskFailed : l.notificationTaskFinished) : server,
      payload: NotificationPayload.serverTasks,
      channelName: l.serverTasks,
      discreet: settings.discreet,
    ),
  );
  return true;
}

/// Settings → Privacy & security: the system notifications. Hidden where
/// the platform has none.
class NotificationSettingsSection extends ConsumerWidget {
  const NotificationSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(notificationServiceProvider).isSupported) return const SizedBox.shrink();
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);
    final l = context.l10n;
    return Column(
      children: [
        SettingsSectionTitle(l.sectionNotifications),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_outlined),
          title: Text(l.systemNotifications),
          subtitle: Text(l.systemNotificationsSubtitle),
          value: settings.enabled,
          onChanged: withHaptic((on) async {
            if (!on) return notifier.disable();
            if (await notifier.enable() || !context.mounted) return;
            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l.notificationsDenied),
                content: Text(l.notificationsDeniedBody),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l.close))],
              ),
            );
          }),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.visibility_off_outlined),
          title: Text(l.discreetNotifications),
          subtitle: Text(l.discreetNotificationsSubtitle),
          value: settings.discreet,
          onChanged: withHaptic(settings.enabled ? notifier.setDiscreet : null),
        ),
      ],
    );
  }
}
