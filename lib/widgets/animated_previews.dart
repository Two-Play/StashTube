import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/server_config.dart';

/// Whether lists play Stash's short looping previews (animated WebP): on
/// marker tiles, and on the first fully shown video of a scene list after
/// a few seconds. On by default, stored for all servers.
class AnimatedPreviewsNotifier extends Notifier<bool> {
  static const _key = 'animated_previews';

  /// The setting's name when it was for markers only.
  static const _oldKey = 'marker_previews';

  @override
  bool build() {
    try {
      final prefs = ref.watch(sharedPreferencesProvider);
      return prefs.getBool(_key) ?? prefs.getBool(_oldKey) ?? true;
    } catch (_) {
      // Tests of single pages don't provide preferences.
      return true;
    }
  }

  Future<void> set(bool value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setBool(_key, value);
  }
}

final animatedPreviewsProvider = NotifierProvider<AnimatedPreviewsNotifier, bool>(AnimatedPreviewsNotifier.new);

/// Whether previews play here: switched on, and no reduced motion.
bool previewsPlay(BuildContext context, WidgetRef ref) =>
    ref.watch(animatedPreviewsProvider) && !MediaQuery.disableAnimationsOf(context);
