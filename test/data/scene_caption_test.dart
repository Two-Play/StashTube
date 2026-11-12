import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/scene_details.dart';

void main() {
  test('a caption url adds language and type to the server path', () {
    final c = SceneCaption.build('http://s:9999/scene/7/caption', 'ja', 'srt')!;
    expect(Uri.parse(c.url).path, '/scene/7/caption');
    expect(Uri.parse(c.url).queryParameters, {'lang': 'ja', 'type': 'srt'});
    expect(c.id, 'ja:srt');
    expect(c.languageKnown, isTrue);
  });

  test('keeps existing query parameters, and no path means no caption', () {
    final c = SceneCaption.build('http://s/scene/7/caption?x=1', '00', 'vtt')!;
    expect(Uri.parse(c.url).queryParameters, {'x': '1', 'lang': '00', 'type': 'vtt'});
    expect(c.languageKnown, isFalse);
    expect(SceneCaption.build(null, 'ja', 'srt'), isNull);
    expect(SceneCaption.build('', 'ja', 'srt'), isNull);
  });
}
