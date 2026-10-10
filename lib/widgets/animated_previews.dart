import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/server_config.dart';

/// Stash's short looping previews (animated WebP), switched separately for
/// lists and for markers; on by default, stored for all servers.
class _PreviewSwitch extends Notifier<bool> {
  _PreviewSwitch(this._key);

  final String _key;

  /// The one setting for both, before they were split.
  static const _sharedKey = 'animated_previews';

  @override
  bool build() {
    final SharedPreferences prefs;
    try {
      prefs = ref.watch(sharedPreferencesProvider);
    } catch (_) {
      // Tests of single pages don't provide preferences.
      return true;
    }
    return prefs.getBool(_key) ?? prefs.getBool(_sharedKey) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setBool(_key, value);
  }
}

/// In scene lists, the first fully shown video plays its preview
/// ([AutoPreviewScope]).
final feedPreviewsProvider = NotifierProvider<_PreviewSwitch, bool>(() => _PreviewSwitch('feed_previews'));

/// Marker tiles loop their preview instead of the still frame.
final markerPreviewsProvider = NotifierProvider<_PreviewSwitch, bool>(() => _PreviewSwitch('marker_previews'));

/// How long a list rests before its first video plays the preview.
class FeedPreviewDelayNotifier extends Notifier<Duration> {
  static const _key = 'feed_preview_delay_ms';
  static const standard = Duration(milliseconds: 1500);
  static const choices = [
    Duration(milliseconds: 500),
    Duration(seconds: 1),
    standard,
    Duration(seconds: 2),
    Duration(seconds: 3),
  ];

  @override
  Duration build() {
    try {
      final ms = ref.watch(sharedPreferencesProvider).getInt(_key);
      return ms == null ? standard : Duration(milliseconds: ms);
    } catch (_) {
      return standard;
    }
  }

  Future<void> set(Duration delay) async {
    state = delay;
    await ref.read(sharedPreferencesProvider).setInt(_key, delay.inMilliseconds);
  }
}

final feedPreviewDelayProvider = NotifierProvider<FeedPreviewDelayNotifier, Duration>(FeedPreviewDelayNotifier.new);

/// Whether the previews of [setting] play here: switched on, and no
/// reduced motion.
bool previewsPlay(BuildContext context, WidgetRef ref, NotifierProvider<Notifier<bool>, bool> setting) =>
    ref.watch(setting) && !MediaQuery.disableAnimationsOf(context);
