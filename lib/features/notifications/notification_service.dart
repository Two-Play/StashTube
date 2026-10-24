import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// A system notification to post.
@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    this.body,
    required this.payload,
    required this.channelName,
    required this.discreet,
  });

  /// Posting the same id again replaces the earlier notification.
  final int id;
  final String title;
  final String? body;

  /// What tapping it opens ([NotificationPayload]).
  final String payload;

  /// The name of the Android channel, shown in the system settings.
  final String channelName;

  /// Hidden on the Android lock screen completely instead of only its text.
  final bool discreet;
}

/// What a notification opens when tapped.
abstract final class NotificationPayload {
  /// Settings → Server tasks.
  static const serverTasks = 'server_tasks';
}

/// System notifications (flutter_local_notifications). An interface so tests
/// can use a fake; desktop and tests get [UnsupportedNotificationService].
abstract class NotificationService {
  /// Whether this platform can show them at all.
  bool get isSupported;

  /// The payloads of notifications tapped while the app runs.
  Stream<String> get taps;

  /// Sets the plugin up; safe to call more than once.
  Future<void> init();

  /// The payload of the notification that launched the app, if any; only
  /// once per launch, so a rebuilt shell doesn't open it again.
  Future<String?> launchPayload();

  /// Asks the system for the permission (Android 13+, iOS); true when the
  /// app may post notifications.
  Future<bool> requestPermission();

  Future<void> show(AppNotification notification);

  static NotificationService create() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return const UnsupportedNotificationService();
    return PluginNotificationService();
  }
}

class UnsupportedNotificationService implements NotificationService {
  const UnsupportedNotificationService();

  @override
  bool get isSupported => false;

  @override
  Stream<String> get taps => const Stream.empty();

  @override
  Future<void> init() async {}

  @override
  Future<String?> launchPayload() async => null;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> show(AppNotification notification) async {}
}

/// Android and iOS through flutter_local_notifications.
class PluginNotificationService implements NotificationService {
  static const _channelId = 'server_tasks';

  final _plugin = FlutterLocalNotificationsPlugin();
  final _taps = StreamController<String>.broadcast();
  Future<void>? _init;
  var _launchHandled = false;

  @override
  bool get isSupported => true;

  @override
  Stream<String> get taps => _taps.stream;

  @override
  Future<void> init() => _init ??= _initialize();

  Future<void> _initialize() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          // The icon's monochrome layer: the status bar draws it as a silhouette.
          android: AndroidInitializationSettings('@mipmap/ic_launcher_monochrome'),
          // Asked only when the user switches them on in the settings.
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) _taps.add(payload);
        },
      );
    } catch (e) {
      debugPrint('Notifications: initialize failed: $e');
    }
  }

  @override
  Future<String?> launchPayload() async {
    await init();
    if (_launchHandled) return null;
    _launchHandled = true;
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details == null || !details.didNotificationLaunchApp) return null;
      final payload = details.notificationResponse?.payload;
      return payload == null || payload.isEmpty ? null : payload;
    } catch (e) {
      debugPrint('Notifications: launch details failed: $e');
      return null;
    }
  }

  @override
  Future<bool> requestPermission() async {
    await init();
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final granted = await android.requestNotificationsPermission() ?? false;
        // Below Android 13 there is nothing to ask, but they can be off.
        return granted && (await android.areNotificationsEnabled() ?? true);
      }
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      return await ios?.requestPermissions(alert: true, sound: true) ?? false;
    } catch (e) {
      debugPrint('Notifications: permission request failed: $e');
      return false;
    }
  }

  @override
  Future<void> show(AppNotification n) async {
    await init();
    try {
      await _plugin.show(
        id: n.id,
        title: n.title,
        body: n.body,
        payload: n.payload,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            n.channelName,
            category: AndroidNotificationCategory.status,
            // Secret: not on the lock screen at all; private: only that
            // there is a notification, without its text.
            visibility: n.discreet ? NotificationVisibility.secret : NotificationVisibility.private,
          ),
          iOS: const DarwinNotificationDetails(presentBadge: false),
        ),
      );
    } catch (e) {
      debugPrint('Notifications: show failed: $e');
    }
  }
}
