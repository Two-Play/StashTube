import AVFoundation
import AVKit
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var airPlay: AirPlayController?

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
