import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/server_config.dart';
import '../../data/models/list_queries.dart';
import '../../data/models/scene_filter.dart';
import '../../data/models/tag.dart';

/// Maximum length of a short.
enum ShortsLength {
  oneMinute(60),
  threeMinutes(180),
  tenMinutes(600),
  any(null);

  const ShortsLength(this.maxSeconds);

  final int? maxSeconds;
}

/// What the shorts show: short (by default portrait) videos, with the
/// chosen [tags] shown more often, or exclusively with [onlyTags]. The loops
/// ([ShortsMode.loops]) play scene markers with one of the [tags] (all
/// markers without tags).
@immutable
class ShortsSettings {
  const ShortsSettings({
    this.tags = const [],
    this.onlyTags = false,
    this.length = ShortsLength.threeMinutes,
    this.portraitOnly = true,
  });

  final List<Tag> tags;
  final bool onlyTags;
  final ShortsLength length;
  final bool portraitOnly;

  /// Short videos, without the tag preference.
  SceneFilter get baseFilter => SceneFilter(portraitOnly: portraitOnly, maxSeconds: length.maxSeconds);

  /// Short videos with at least one of [tags]; null without tags.
  SceneFilter? get tagFilter => tags.isEmpty
      ? null
      : SceneFilter(tags: tags, anyTag: true, portraitOnly: portraitOnly, maxSeconds: length.maxSeconds);

  /// Whether the feed also mixes in videos without the tags.
  bool get mixesOthers => tags.isEmpty || !onlyTags;

  /// The loops' markers. The orientation applies (through the marker's
  /// scene); the length doesn't: a marker plays only its marked part.
  MarkerQuery get markerQuery =>
      MarkerQuery(sort: MarkerSort.random, tagIds: [for (final t in tags) t.id], portraitOnly: portraitOnly);

  ShortsSettings copyWith({
    List<Tag>? tags,
    bool? onlyTags,
    ShortsLength? length,
    bool? portraitOnly,
  }) =>
      ShortsSettings(
        tags: tags ?? this.tags,
        onlyTags: onlyTags ?? this.onlyTags,
        length: length ?? this.length,
        portraitOnly: portraitOnly ?? this.portraitOnly,
      );

  Map<String, dynamic> toJson() => {
        'tags': [for (final t in tags) {'id': t.id, 'name': t.name}],
        'onlyTags': onlyTags,
        'length': length.name,
        'portraitOnly': portraitOnly,
      };

  /// Falls back to the defaults for anything missing or unreadable.
  factory ShortsSettings.fromJson(Map<String, dynamic> json) {
    const defaults = ShortsSettings();
    final tags = json['tags'];
    return ShortsSettings(
      tags: [
        if (tags is List)
          for (final t in tags)
            if (t is Map && t['id'] is String) Tag(id: t['id'] as String, name: t['name'] as String? ?? ''),
      ],
      onlyTags: json['onlyTags'] as bool? ?? defaults.onlyTags,
      length: ShortsLength.values.asNameMap()[json['length']] ?? defaults.length,
      // An older "markers" (videos & markers in one feed) is dropped: the
      // markers are the loops now.
      portraitOnly: json['portraitOnly'] as bool? ?? defaults.portraitOnly,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ShortsSettings &&
      listEquals([for (final t in tags) t.id], [for (final t in other.tags) t.id]) &&
      other.onlyTags == onlyTags &&
      other.length == length &&
      other.portraitOnly == portraitOnly;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll([for (final t in tags) t.id]), onlyTags, length, portraitOnly);
}

/// Stored per server, as tag ids belong to one server.
class ShortsSettingsNotifier extends Notifier<ShortsSettings> {
  static const _key = 'shorts_settings';

  String? get _serverKey {
    final server = ref.read(activeServerIdProvider);
    return server == null ? null : '$_key:$server';
  }

  @override
  ShortsSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    ref.watch(activeServerIdProvider);
    final raw = _serverKey == null ? null : prefs.getString(_serverKey!);
    if (raw == null) return const ShortsSettings();
    try {
      return ShortsSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const ShortsSettings();
    }
  }

  Future<void> set(ShortsSettings settings) async {
    if (settings == state) return;
    state = settings;
    final key = _serverKey;
    if (key != null) await ref.read(sharedPreferencesProvider).setString(key, jsonEncode(settings.toJson()));
  }
}

final shortsSettingsProvider =
    NotifierProvider<ShortsSettingsNotifier, ShortsSettings>(ShortsSettingsNotifier.new);

/// What the shorts tab plays: short videos, or scene markers looping on
/// their own ("Loops"). Switched at the top of the tab; stored for all
/// servers.
enum ShortsMode { shorts, loops }

class ShortsModeNotifier extends Notifier<ShortsMode> {
  static const _key = 'shorts_mode';

  @override
  ShortsMode build() {
    try {
      return ShortsMode.values.asNameMap()[ref.watch(sharedPreferencesProvider).getString(_key)] ?? ShortsMode.shorts;
    } catch (_) {
      return ShortsMode.shorts;
    }
  }

  Future<void> set(ShortsMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_key, mode.name);
  }
}

final shortsModeProvider = NotifierProvider<ShortsModeNotifier, ShortsMode>(ShortsModeNotifier.new);
