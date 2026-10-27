import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/core/utils/external_links.dart';
import 'package:stash_app_mobile/data/models/scene.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/channel/channel_tabs.dart';
import 'package:stash_app_mobile/features/player/scene_description.dart';

class _NoRepository implements StashRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError('${invocation.memberName}');
}

void main() {
  late List<Uri> opened;
  var opens = true;

  setUp(() {
    opened = [];
    opens = true;
    urlOpener = (uri) async {
      opened.add(uri);
      return opens;
    };
  });
  tearDown(() => urlOpener = (uri) async => false);

  test('web addresses: https added without a scheme, other schemes refused', () {
    expect(webUri('example.com/a'), Uri.parse('https://example.com/a'));
    expect(webUri(' http://nas:9999/x '), Uri.parse('http://nas:9999/x'));
    expect(webUri('javascript:alert(1)'), isNull);
    expect(webUri('file:///etc/passwd'), isNull);
    expect(webUri(''), isNull);
  });

  test("a scene's page in Stash never carries the API key", () {
    expect(stashSceneWebUrl('http://nas:9999', '12'), 'http://nas:9999/scenes/12');
    expect(stashSceneWebUrl('https://h.example/stash/', '7'), 'https://h.example/stash/scenes/7');
  });

  Widget app(Widget child, {ServerConfig server = const ServerConfig(baseUrl: 'http://test')}) => ProviderScope(
        retry: (_, _) => null,
        overrides: [
          activeServerIdProvider.overrideWithValue('test-server'),
          serverConfigProvider.overrideWithValue(server),
          stashRepositoryProvider.overrideWithValue(_NoRepository()),
        ],
        child: MaterialApp(home: Scaffold(body: child)),
      );

  testWidgets('channel links open in the browser; a long press copies them', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String;
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));

    await tester.pumpWidget(app(const ChannelLinks(label: 'Links', urls: ['example.com/me'])));
    await tester.tap(find.text('example.com/me'));
    await tester.pump();
    expect(opened, [Uri.parse('https://example.com/me')]);
    expect(find.byType(SnackBar), findsNothing);

    await tester.longPress(find.text('example.com/me'));
    await tester.pump();
    expect(copied, 'example.com/me');
    expect(find.text('Link copied'), findsOneWidget);
    expect(opened, hasLength(1));
  });

  testWidgets('a link that does not open shows a snack bar', (tester) async {
    opens = false;
    await tester.pumpWidget(app(const ChannelLinks(label: 'Links', urls: ['https://example.com'])));
    await tester.tap(find.text('https://example.com'));
    await tester.pump();
    expect(find.text("Couldn't open https://example.com"), findsOneWidget);
  });

  testWidgets('"Open in Stash" opens the scene in the web interface', (tester) async {
    await tester.pumpWidget(app(
      const SceneDescriptionSheet(scene: Scene(id: '42', title: 'Beach')),
      server: const ServerConfig(baseUrl: 'http://nas:9999', apiKey: 'secret'),
    ));
    await tester.pump();
    await tester.ensureVisible(find.text('Open in Stash'));
    await tester.tap(find.text('Open in Stash'));
    await tester.pump();
    expect(opened, [Uri.parse('http://nas:9999/scenes/42')]);
    expect(opened.single.toString(), isNot(contains('secret')));
  });

  testWidgets('the demo has no web interface to open', (tester) async {
    await tester.pumpWidget(app(
      const SceneDescriptionSheet(scene: Scene(id: '42', title: 'Beach')),
      server: const ServerConfig(baseUrl: ServerConfig.demoUrl),
    ));
    await tester.pump();
    expect(find.text('Open in Stash'), findsNothing);
  });
}
