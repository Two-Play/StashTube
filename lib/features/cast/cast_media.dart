import '../../core/config/server_config.dart';
import '../../core/network/origin_guard.dart';
import '../../data/models/scene.dart';
import '../../data/models/scene_details.dart';
import 'cast_service.dart' show CastKind;

/// What gets sent to a cast device.
class CastMedia {
  const CastMedia({
    required this.url,
    required this.contentType,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.start = Duration.zero,
  });

  final String url;
  final String contentType;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Duration start;
}

/// Cast devices fetch media themselves and can't send the `ApiKey` header,
/// so [server]'s key goes into the URL (Stash also accepts `?apikey=`);
/// only for URLs on the server itself, never for one pointing elsewhere.
String withApiKey(String url, ServerConfig? server) {
  final apiKey = server?.apiKey;
  if (server == null || apiKey == null || apiKey.isEmpty) return url;
  final uri = Uri.tryParse(url);
  final origin = Uri.tryParse(server.baseUrl);
  if (uri == null || origin == null || !sameOrigin(uri, origin)) return url;
  return uri.replace(queryParameters: {...uri.queryParameters, 'apikey': apiKey}).toString();
}

/// Picks the stream a Chromecast can play: the original file if it is MP4 or
/// WebM, otherwise Stash's HLS transcode, otherwise any MP4 transcode, and as
/// a last resort the original file.
({String url, String contentType}) pickCastStream(Scene scene, SceneDetails? details) {
  final streams = details?.streams ?? const <SceneStream>[];
  bool castable(String? mime) => mime == 'video/mp4' || mime == 'video/webm';

  final direct = streams.where((s) => s.isDirect && castable(s.mimeType)).firstOrNull;
  if (direct != null) return (url: direct.url, contentType: direct.mimeType!);

  final hls = streams.where((s) => s.isHls).firstOrNull;
  if (hls != null) return (url: hls.url, contentType: 'application/x-mpegURL');

  final mp4 = streams.where((s) => s.mimeType == 'video/mp4').firstOrNull;
  if (mp4 != null) return (url: mp4.url, contentType: 'video/mp4');

  return (url: scene.streamUrl ?? '', contentType: 'video/mp4');
}

/// Picks the stream AirPlay (AVPlayer) can play: the original file if it is
/// MP4 or QuickTime, otherwise Stash's HLS transcode, otherwise any MP4
/// transcode, and as a last resort the original file. WebM and MKV don't
/// play on Apple TV.
({String url, String contentType}) pickAirPlayStream(Scene scene, SceneDetails? details) {
  final streams = details?.streams ?? const <SceneStream>[];
  bool playable(String? mime) => mime == 'video/mp4' || mime == 'video/quicktime';

  final direct = streams.where((s) => s.isDirect && playable(s.mimeType)).firstOrNull;
  if (direct != null) return (url: direct.url, contentType: direct.mimeType!);

  final hls = streams.where((s) => s.isHls).firstOrNull;
  if (hls != null) return (url: hls.url, contentType: 'application/x-mpegURL');

  final mp4 = streams.where((s) => s.mimeType == 'video/mp4').firstOrNull;
  if (mp4 != null) return (url: mp4.url, contentType: 'video/mp4');

  return (url: scene.streamUrl ?? '', contentType: 'video/mp4');
}

CastMedia castMediaFor(
  Scene scene,
  SceneDetails? details, {
  ServerConfig? server,
  Duration start = Duration.zero,
  CastKind kind = CastKind.googleCast,
}) {
  final stream = kind == CastKind.airPlay ? pickAirPlayStream(scene, details) : pickCastStream(scene, details);
  final image = scene.screenshotUrl;
  return CastMedia(
    url: withApiKey(stream.url, server),
    contentType: stream.contentType,
    title: scene.title,
    subtitle: scene.studio?.name ?? scene.performers.firstOrNull?.name,
    imageUrl: image == null ? null : withApiKey(image, server),
    start: start,
  );
}
