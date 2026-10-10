import AVFoundation
import AVKit
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var airPlay: AirPlayController?
  private var pictureInPicture: PictureInPictureController?
  private var privacyCover: PrivacyCoverController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerAppIconChannel(engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "StashAirPlay") {
      airPlay = AirPlayController(messenger: registrar.messenger())
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "StashPrivacy") {
      privacyCover = PrivacyCoverController(messenger: registrar.messenger())
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "StashPictureInPicture") {
      pictureInPicture = PictureInPictureController(messenger: registrar.messenger())
    }
  }

  /// Disguised app icons (11.3): "setIcon" with an alternate icon set name
  /// (AppIcon-Notes, ...) or nil for the regular icon.
  private func registerAppIconChannel(_ registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "StashAppIcon") else { return }
    let channel = FlutterMethodChannel(name: "stash/appicon", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "setIcon" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard UIApplication.shared.supportsAlternateIcons else {
        result(FlutterError(code: "unsupported", message: "Alternate icons are not supported", details: nil))
        return
      }
      UIApplication.shared.setAlternateIconName(call.arguments as? String) { error in
        if let error = error {
          result(FlutterError(code: "failed", message: error.localizedDescription, details: nil))
        } else {
          result(nil)
        }
      }
    }
  }
}

/// AirPlay (4.21) for `AirPlayCastService` in Dart.
///
/// mpv can't send video over AirPlay, so while an AirPlay route is active the
/// scene plays in an AVPlayer with external playback: the TV fetches and
/// shows the video, the phone only controls it. Methods on `stash/airplay`:
/// showPicker, load {url, title, startMs}, play, pause, seek (ms), stop.
/// `stash/airplay/events` sends {route, engaged, playing, loading, positionMs}.
final class AirPlayController: NSObject, FlutterStreamHandler {
  private var events: FlutterEventSink?
  private var player: AVPlayer?
  private var timeObserver: Any?
  private var statusObservation: NSKeyValueObservation?
  private let picker = AVRoutePickerView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))

  /// Whether the app plays on the AirPlay route; false after `stop`, so the
  /// app goes back to local playback even if the route stays on the TV.
  private var engaged = false
  private var lastRoute: String?

  init(messenger: FlutterBinaryMessenger) {
    super.init()
    // Video-capable routes (Apple TV) instead of audio-only speakers.
    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
    picker.prioritizesVideoDevices = true
    lastRoute = airPlayRouteName
    engaged = lastRoute != nil

    let channel = FlutterMethodChannel(name: "stash/airplay", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    FlutterEventChannel(name: "stash/airplay/events", binaryMessenger: messenger).setStreamHandler(self)
    NotificationCenter.default.addObserver(
      self, selector: #selector(routeChanged), name: AVAudioSession.routeChangeNotification, object: nil)
  }

  private var airPlayRouteName: String? {
    AVAudioSession.sharedInstance().currentRoute.outputs.first { $0.portType == .airPlay }?.portName
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "showPicker":
      result(showPicker())
      return
    case "load":
      guard let args = call.arguments as? [String: Any],
            let string = args["url"] as? String, let url = URL(string: string) else {
        result(FlutterError(code: "bad_args", message: "load needs a url", details: nil))
        return
      }
      load(url: url, startMs: (args["startMs"] as? NSNumber)?.int64Value ?? 0)
    case "play":
      player?.play()
    case "pause":
      player?.pause()
    case "seek":
      let millis = (call.arguments as? NSNumber)?.int64Value ?? 0
      player?.seek(to: CMTime(value: millis, timescale: 1000), toleranceBefore: .zero, toleranceAfter: .zero)
    case "stop":
      stopPlayer()
      engaged = false
      sendState()
    default:
      result(FlutterMethodNotImplemented)
      return
    }
    result(nil)
  }

  /// AVRoutePickerView has no API to open it; tapping its button does. It
  /// has to be in a window and laid out for the button to exist. Returns
  /// whether the button was found.
  private func showPicker() -> Bool {
    if picker.superview == nil, let window = mainWindow {
      picker.alpha = 0.011
      window.addSubview(picker)
    }
    picker.layoutIfNeeded()
    let buttons = picker.subviews.compactMap { $0 as? UIButton }
    buttons.forEach { $0.sendActions(for: .touchUpInside) }
    return !buttons.isEmpty
  }

  private var mainWindow: UIWindow? {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
    return windows.first { $0.isKeyWindow } ?? windows.first
  }

  private func load(url: URL, startMs: Int64) {
    stopPlayer()
    engaged = true
    let player = AVPlayer(url: url)
    player.allowsExternalPlayback = true
    player.usesExternalPlaybackWhileExternalScreenIsActive = true
    if startMs > 0 {
      player.seek(to: CMTime(value: startMs, timescale: 1000), toleranceBefore: .zero, toleranceAfter: .zero)
    }
    timeObserver = player.addPeriodicTimeObserver(
      forInterval: CMTime(value: 1, timescale: 2), queue: .main
    ) { [weak self] _ in self?.sendState() }
    statusObservation = player.observe(\.timeControlStatus) { [weak self] _, _ in
      DispatchQueue.main.async { self?.sendState() }
    }
    self.player = player
    player.play()
    sendState()
  }

  private func stopPlayer() {
    if let observer = timeObserver { player?.removeTimeObserver(observer) }
    timeObserver = nil
    statusObservation = nil
    player?.pause()
    player = nil
  }

  @objc private func routeChanged(_ notification: Notification) {
    DispatchQueue.main.async {
      let route = self.airPlayRouteName
      if route == nil {
        // Back on the phone: Dart continues locally at the last position.
        self.stopPlayer()
        self.engaged = false
      } else if self.lastRoute == nil {
        // A TV was picked.
        self.engaged = true
      }
      self.lastRoute = route
      self.sendState()
    }
  }

  private func sendState() {
    guard let events = events else { return }
    let position = player.map { CMTimeGetSeconds($0.currentTime()) } ?? 0
    let status = player?.timeControlStatus
    events([
      "route": airPlayRouteName as Any,
      "engaged": engaged,
      "playing": status == .playing,
      "loading": status == .waitingToPlayAtSpecifiedRate,
      "positionMs": position.isFinite ? Int(position * 1000) : 0
    ])
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.events = events
    sendState()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    events = nil
    return nil
  }
}

/// Covers the app natively as soon as it resigns active (11.1, 11.2), for
/// `SecureWindow` in Dart: locking the phone or opening the app switcher
/// moves the app to the background before Flutter draws another frame, so
/// its last frame, with the content, would show on return until the lock
/// screen is drawn, and in the app switcher. Method on `stash/privacy`:
/// uncover (once Flutter has drawn again).
///
/// Whether to cover is read from the app's settings (shared_preferences
/// keeps them in UserDefaults as "flutter.<key>"), not sent over the
/// channel: a message sent while the app starts can arrive before this
/// handler exists, and is then lost.
final class PrivacyCoverController: NSObject {
  private var cover: UIView?

  /// As `AppLockSettings.hidesApp` in Dart: the lock is on, or "hide in app
  /// switcher". The PIN itself is in the Keychain; covering once too often
  /// (a lock without a PIN) does no harm.
  private var enabled: Bool {
    let defaults = UserDefaults.standard
    return defaults.bool(forKey: "flutter.lock_enabled")
      || defaults.bool(forKey: "flutter.lock_hide_in_switcher")
  }
  /// Bumped on every deactivation, so a fallback timer from an earlier
  /// activation can't remove a newer cover.
  private var generation = 0

  init(messenger: FlutterBinaryMessenger) {
    super.init()
    let channel = FlutterMethodChannel(name: "stash/privacy", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "uncover":
        self?.removeCover()
      default:
        result(FlutterMethodNotImplemented)
        return
      }
      result(nil)
    }
    let center = NotificationCenter.default
    center.addObserver(
      self, selector: #selector(willDeactivate), name: UIScene.willDeactivateNotification, object: nil)
    // In case deactivating was skipped (e.g. locking the phone quickly).
    center.addObserver(
      self, selector: #selector(willDeactivate), name: UIScene.didEnterBackgroundNotification, object: nil)
    center.addObserver(
      self, selector: #selector(didActivate), name: UIScene.didActivateNotification, object: nil)
  }

  @objc private func willDeactivate(_ notification: Notification) {
    generation += 1
    guard enabled, cover == nil,
          let scene = notification.object as? UIWindowScene,
          let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first else { return }
    let view = UIView(frame: window.bounds)
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.backgroundColor = .systemBackground
    let lock = UIImageView(image: UIImage(systemName: "lock.fill"))
    lock.tintColor = .secondaryLabel
    lock.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(lock)
    NSLayoutConstraint.activate([
      lock.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      lock.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      lock.widthAnchor.constraint(equalToConstant: 44),
      lock.heightAnchor.constraint(equalToConstant: 52)
    ])
    window.addSubview(view)
    cover = view
  }

  /// Flutter removes the cover once it has drawn; this is only a fallback.
  @objc private func didActivate(_ notification: Notification) {
    let current = generation
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      if self?.generation == current { self?.removeCover() }
    }
  }

  private func removeCover() {
    cover?.removeFromSuperview()
    cover = nil
  }
}

/// Picture-in-picture (4.12) for `PipService` in Dart.
///
/// mpv's video can't go into picture-in-picture, so an AVPlayer takes over
/// the stream, like for AirPlay: its layer sits where the app's video is,
/// the system window grows out of it, and the app pauses its own player.
/// Methods on `stash/pip`: start {url, headers, startMs, rect: [x, y, w, h]}
/// (returns whether it started), stop. Calls back pipChanged (bool) and,
/// when it ends, pipStopped {positionMs, playing}, so Dart continues there.
final class PictureInPictureController: NSObject, AVPictureInPictureControllerDelegate {
  private let channel: FlutterMethodChannel
  private var player: AVPlayer?
  private var playerView: PlayerLayerView?
  private var pip: AVPictureInPictureController?
  private var possibleObservation: NSKeyValueObservation?
  private var statusObservation: NSKeyValueObservation?
  private var pendingStart: FlutterResult?
  private var playingWhenStopping = true

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(name: "stash/pip", binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
      guard let args = call.arguments as? [String: Any],
            let string = args["url"] as? String, let url = URL(string: string) else {
        result(FlutterError(code: "bad_args", message: "start needs a url", details: nil))
        return
      }
      let rect = (args["rect"] as? [NSNumber])?.map { CGFloat($0.doubleValue) } ?? []
      start(
        url: url,
        headers: args["headers"] as? [String: String] ?? [:],
        startMs: (args["startMs"] as? NSNumber)?.int64Value ?? 0,
        frame: rect.count == 4 ? CGRect(x: rect[0], y: rect[1], width: rect[2], height: rect[3]) : .zero,
        result: result)
    case "stop":
      if pip?.isPictureInPictureActive == true {
        pip?.stopPictureInPicture()
      } else {
        cleanUp()
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func start(
    url: URL, headers: [String: String], startMs: Int64, frame: CGRect, result: @escaping FlutterResult
  ) {
    finishStart(false)
    cleanUp()
    guard AVPictureInPictureController.isPictureInPictureSupported(), let window = mainWindow else {
      result(false)
      return
    }
    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
    try? AVAudioSession.sharedInstance().setActive(true)

    // The headers carry the API key or the session cookie.
    let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
    let item = AVPlayerItem(asset: asset)
    let player = AVPlayer(playerItem: item)
    player.allowsExternalPlayback = false
    // The layer has to be on screen for picture-in-picture to start.
    let onScreen = frame.width > 1 && frame.height > 1
    let view = PlayerLayerView(frame: onScreen ? frame : CGRect(x: 0, y: 0, width: 160, height: 90))
    view.isUserInteractionEnabled = false
    view.playerLayer.videoGravity = .resizeAspect
    view.playerLayer.player = player
    window.addSubview(view)

    guard let pip = AVPictureInPictureController(playerLayer: view.playerLayer) else {
      view.removeFromSuperview()
      result(false)
      return
    }
    pip.delegate = self
    self.player = player
    self.playerView = view
    self.pip = pip
    pendingStart = result

    statusObservation = item.observe(\.status) { [weak self] item, _ in
      guard item.status == .failed else { return }
      DispatchQueue.main.async {
        self?.finishStart(false)
        self?.cleanUp()
      }
    }
    possibleObservation = pip.observe(\.isPictureInPicturePossible, options: [.initial, .new]) { [weak self] pip, _ in
      DispatchQueue.main.async {
        guard self?.pendingStart != nil, pip.isPictureInPicturePossible, !pip.isPictureInPictureActive else { return }
        pip.startPictureInPicture()
      }
    }
    if startMs > 0 {
      player.seek(to: CMTime(value: startMs, timescale: 1000), toleranceBefore: .zero, toleranceAfter: .zero)
    }
    player.play()
    // Streams the AVPlayer can't open never get "possible".
    DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
      guard let self = self, self.pendingStart != nil else { return }
      self.finishStart(false)
      self.cleanUp()
    }
  }

  private var mainWindow: UIWindow? {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
    return windows.first { $0.isKeyWindow } ?? windows.first
  }

  private func finishStart(_ started: Bool) {
    pendingStart?(started)
    pendingStart = nil
  }

  private func cleanUp() {
    possibleObservation = nil
    statusObservation = nil
    player?.pause()
    player = nil
    pip = nil
    playerView?.removeFromSuperview()
    playerView = nil
  }

  func pictureInPictureControllerDidStartPictureInPicture(_ controller: AVPictureInPictureController) {
    // The app shows its own (paused) video again behind the window.
    playerView?.isHidden = true
    finishStart(true)
    channel.invokeMethod("pipChanged", arguments: true)
  }

  func pictureInPictureController(
    _ controller: AVPictureInPictureController,
    failedToStartPictureInPictureWithError error: Error
  ) {
    finishStart(false)
    cleanUp()
  }

  func pictureInPictureControllerWillStopPictureInPicture(_ controller: AVPictureInPictureController) {
    playingWhenStopping = player?.timeControlStatus != .paused
  }

  func pictureInPictureControllerDidStopPictureInPicture(_ controller: AVPictureInPictureController) {
    let seconds = player.map { CMTimeGetSeconds($0.currentTime()) } ?? 0
    channel.invokeMethod("pipStopped", arguments: [
      "positionMs": seconds.isFinite ? Int(seconds * 1000) : 0,
      "playing": playingWhenStopping
    ])
    cleanUp()
  }

  func pictureInPictureController(
    _ controller: AVPictureInPictureController,
    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
  ) {
    completionHandler(true)
  }
}

/// A view whose layer is an AVPlayerLayer.
final class PlayerLayerView: UIView {
  override class var layerClass: AnyClass { AVPlayerLayer.self }

  var playerLayer: AVPlayerLayer {
    guard let playerLayer = layer as? AVPlayerLayer else { fatalError("layerClass is AVPlayerLayer") }
    return playerLayer
  }
}

/// The app's view controller (Main.storyboard). Turns the phone without
/// UIKit's rotation animation: it stretches the last frame until Flutter
/// has drawn the new size, which distorts the video for a moment (4.19).
@objc(RunnerViewController)
final class RunnerViewController: FlutterViewController {
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    UIView.setAnimationsEnabled(false)
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: nil) { _ in
      UIView.setAnimationsEnabled(true)
    }
  }
}
