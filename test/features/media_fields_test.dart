import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/models/performer.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/edit/edit_pages.dart';
import 'package:stash_app_mobile/features/edit/media_fields.dart';

class FakeRepository implements StashRepository {
  Map<String, dynamic>? sent;
  List<String>? urls = ['https://a.example'];

  @override
  Future<List<String>?> performerUrls(String id) async => urls;

  @override
  Future<Performer> updatePerformer(String id, Map<String, dynamic> changes) async {
    sent = changes;
    return Performer(id: id, name: 'x');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('ImageChoice: data URI for picked bytes, plain URL otherwise', () {
    final bytes = Uint8List.fromList([1, 2, 3]);
    expect(ImageChoice.bytes(bytes, 'image/png').value, 'data:image/png;base64,${base64Encode(bytes)}');
    expect(const ImageChoice.url('https://x/y.jpg').value, 'https://x/y.jpg');
  });

  testWidgets('ImageEditField uses the picker and can revert', (tester) async {
    ImageChoice? choice;
    final picked = ImageChoice.bytes(Uint8List.fromList(base64Decode(_png)), 'image/png');
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => ImageEditField(
            label: 'Image',
            currentUrl: null,
            choice: choice,
            picker: () async => picked,
            onChanged: (c) => setState(() => choice = c),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('Choose photo'));
    await tester.pumpAndSettle();
    expect(choice, same(picked));
    await tester.tap(find.text('Keep current image'));
    await tester.pump();
    expect(choice, isNull);
  });

  testWidgets('UrlListField validates, adds and removes', (tester) async {
    var urls = <String>['https://a.example'];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => UrlListField(urls: urls, onChanged: (v) => setState(() => urls = v)),
        ),
      ),
    ));
    await tester.enterText(find.byType(TextField), 'not a url');
    await tester.tap(find.byTooltip('Add URL'));
    await tester.pump();
    expect(find.textContaining('Enter a full URL'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'https://b.example');
    await tester.tap(find.byTooltip('Add URL'));
    await tester.pump();
    expect(urls, ['https://a.example', 'https://b.example']);

    await tester.tap(find.byTooltip('Remove URL').first);
    await tester.pump();
    expect(urls, ['https://b.example']);
  });

  testWidgets('performer form sends a new image URL and the edited URL list', (tester) async {
    final repo = FakeRepository();
    final container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo)]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PerformerEditPage(performer: Performer(id: 'p', name: 'Alice')),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('From URL'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'https://…'), 'https://img.example/a.jpg');
    await tester.tap(find.text('Use'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(TextField, 'Add URL'),
      200,
      scrollable: find.byType(Scrollable).first, // the form, not a multi-line field
    );
    expect(find.text('https://a.example'), findsOneWidget, reason: 'URLs loaded from the server');
    await tester.enterText(find.widgetWithText(TextField, 'Add URL'), 'https://b.example');
    await tester.tap(find.byTooltip('Add URL'));
    await tester.pump();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repo.sent, {
      'image': 'https://img.example/a.jpg',
      'urls': ['https://a.example', 'https://b.example'],
    });
  });

  testWidgets('URL editor is hidden when the server has no URL lists', (tester) async {
    final repo = FakeRepository()..urls = null;
    final container = ProviderContainer(overrides: [stashRepositoryProvider.overrideWithValue(repo)]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: PerformerEditPage(performer: Performer(id: 'p', name: 'Alice'))),
    ));
    await tester.pumpAndSettle();
    expect(find.text('URLs'), findsNothing);
  });
}

// 1×1 transparent PNG.
const _png = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';
