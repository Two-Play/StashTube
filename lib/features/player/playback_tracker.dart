import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../data/models/scene.dart';

/// The server calls the tracker needs; implemented by `StashRepository`.
abstract interface class PlaybackActivityApi {
  /// Stores the resume position and adds [playDuration] seconds to the
  /// scene's total watch time (`sceneSaveActivity`).
  Future<void> saveActivity(String sceneId, {required double resumeTime, required double playDuration});

  /// Increments the play count (`sceneAddPlay`).
  Future<void> addPlay(String sceneId);
}

/// Bookkeeping for "continue watching" (backlog 4.8) and play counts (4.9).
///
/// Fed with player events; it is free of Flutter/media_kit types so the
/// policy can be unit tested:
/// * Only time actually watched counts: position jumps (seeks) are ignored.
/// * The activity is saved every [saveInterval] of watching, on pause and on [stop].
/// * A play is counted once per session after watching [playThresholdFraction]
///   of the scene, capped at [maxPlayThreshold].
/// * Near the end ([finishedFraction]) the resume position is reset to 0.
class PlaybackTracker {
  PlaybackTracker({
    required this.api,
    this.onResumeSaved,
    this.saveInterval = const Duration(seconds: 15),
    this.playThresholdFraction = 0.1,
    this.maxPlayThreshold = const Duration(seconds: 60),
    this.finishedFraction = 0.95,
  });

  final PlaybackActivityApi api;

  /// Called after the resume position was saved, so lists can show progress
  /// without refetching.
  final void Function(String sceneId, double resumeTime)? onResumeSaved;
  final Duration saveInterval;
  final double playThresholdFraction;
  final Duration maxPlayThreshold;
  final double finishedFraction;

  /// Position jumps larger than this between two updates are treated as seeks.
  static const _maxTickSeconds = 2.0;

  Scene? _scene;
  double _position = 0;
  double _duration = 0;
  bool _playing = false;
  double _unsavedWatched = 0;
  double _sessionWatched = 0;
  double? _lastSavedResume;
  bool _playCounted = false;

  Scene? get scene => _scene;

  /// Starts a new session; saves the previous one first.
  Future<void> start(Scene scene) async {
    final previous = _flush();
    _scene = scene;
    _position = scene.resumeTime;
    _duration = scene.duration;
    _playing = false;
    _unsavedWatched = 0;
    _sessionWatched = 0;
    _lastSavedResume = scene.resumeTime;
    _playCounted = false;
    await previous;
  }

  /// Saves and ends the current session.
  Future<void> stop() async {
    final pending = _flush();
    _scene = null;
    await pending;
  }

  /// Saves without ending the session, e.g. when the app goes to background.
  Future<void> flush() => _flush();

  void onDuration(Duration duration) {
    if (duration > Duration.zero) _duration = duration.inMilliseconds / 1000;
  }

  void onPlaying(bool playing) {
    final paused = _playing && !playing;
    _playing = playing;
    if (paused) _flush();
  }

  void onPosition(Duration position) {
    final seconds = position.inMilliseconds / 1000;
    final delta = seconds - _position;
    _position = seconds;
    if (_scene == null || !_playing || delta <= 0 || delta > _maxTickSeconds) return;

    _unsavedWatched += delta;
    _sessionWatched += delta;
    _maybeCountPlay();
    if (_unsavedWatched >= saveInterval.inMilliseconds / 1000) _flush();
  }

  /// Resume position to store for [position]: 0 once the scene is (nearly) finished.
  double resumeTimeFor(double position) =>
      _duration > 0 && position >= _duration * finishedFraction ? 0 : position;

  void _maybeCountPlay() {
    final scene = _scene;
    if (_playCounted || scene == null) return;
    final cap = maxPlayThreshold.inMilliseconds / 1000;
    final threshold = _duration > 0 ? min(_duration * playThresholdFraction, cap) : cap;
    if (_sessionWatched < threshold) return;

    _playCounted = true;
    api.addPlay(scene.id).catchError((Object e) {
      debugPrint('sceneAddPlay failed: $e');
    });
  }

  Future<void> _flush() async {
    final scene = _scene;
    if (scene == null) return;
    final resume = resumeTimeFor(_position);
    final watched = _unsavedWatched;
    if (watched <= 0 && resume == _lastSavedResume) return;

    // Snapshot before the await: the session may change meanwhile.
    _unsavedWatched = 0;
    _lastSavedResume = resume;
    try {
      await api.saveActivity(scene.id, resumeTime: resume, playDuration: watched);
      onResumeSaved?.call(scene.id, resume);
    } catch (e) {
      debugPrint('sceneSaveActivity failed: $e');
      if (identical(_scene, scene)) {
        // Retry with the next save.
        _unsavedWatched += watched;
        _lastSavedResume = null;
      }
    }
  }
}
