import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/api/documents/images.graphql.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/models/image_details.dart';
import 'package:stash_app_mobile/data/models/image_item.dart';
import 'package:stash_app_mobile/data/models/json.dart';
import 'package:stash_app_mobile/data/models/list_queries.dart';
import 'package:stash_app_mobile/data/models/page_result.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/features/library/image_viewer_page.dart';
import 'package:stash_app_mobile/features/performers/performer_page.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';

import '../../fixtures.dart';
import '../../helpers.dart';

/// A complete `findImage` result: [fields] override the defaults, which
/// leave everything optional unset.
Json imageDetailsJson([Json fields = const {}]) => typed('Image', {
  'id': '1',
  'title': null,
  'date': null,
  'details': null,
  'photographer': null,
  'rating100': null,
  'o_counter': null,
  'organized': false,
  'created_at': '',
  'updated_at': '',
  'visual_files': const [],
  'studio': null,
  'performers': const [],
  'tags': const [],
  'galleries': const [],
  ...fields,
}, const {'visual_files': 'ImageFile', 'studio': 'Studio', 'performers': 'Performer', 'tags': 'Tag'});

ImageDetails imageDetailsFrom([Json fields = const {}]) =>
    ImageDetails.fromGraphql(Query$FindImageDetails$findImage.fromJson(imageDetailsJson(fields)));

final _full = imageDetailsFrom({
  'title': 'Sunset at the lake',
  'date': '2024-05-01',
  'details': 'Shot from the pier.',
  'photographer': 'Jo Lens',
  'rating100': 80,
  'o_counter': 3,
  'organized': true,
  'created_at': '2024-05-02T10:00:00Z',
  'updated_at': '2024-06-03T10:00:00Z',
  'visual_files': [
    {'path': '/photos/lake/sunset.jpg', 'basename': 'sunset.jpg', 'size': 2500000, 'format': 'jpeg', 'width': 4000, 'height': 3000},
  ],
  'studio': studioRefJson({'id': '4', 'name': 'Lake Studio'}),
  'performers': [performerRefJson({'id': '7', 'name': 'Ada'})],
  'tags': [
    {'id': '9', 'name': 'Outdoor'},
  ],
  'galleries': [galleryJson({'id': '5', 'title': 'Summer'})],
});

class _Repo implements StashRepository {
  _Repo(this.details);

  final ImageDetails details;
  final detailRequests = <String>[];

  @override
  Future<PageResult<ImageItem>> findImages(ImageQuery query, {int page = 1, int perPage = 24}) async => PageResult(
    items: [
      imageFrom({'id': details.id, 'title': details.title}),
    ],
    totalCount: 1,
  );

  @override
  Future<ImageDetails> findImageDetails(String id) async {
    detailRequests.add(id);
    return details;
  }

  // The pages opened from the sheet load from here; they may fail.
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError('${invocation.memberName}');
}

void main() {
  late _Repo repo;

  /// A tab navigator (as in the shell) with the viewer pushed over it on
  /// the root navigator, like the images grid does.
  Future<ProviderContainer> pumpViewer(WidgetTester tester, ImageDetails details, {double textScale = 1}) async {
    repo = _Repo(details);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ...testServer,
        sharedPreferencesProvider.overrideWithValue(prefs),
        stashRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(c.dispose);
    final tabKey = c.read(tabNavigatorKeysProvider)[c.read(currentTabProvider)];
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: Navigator(
            key: tabKey,
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ImageViewerPage(query: ImageQuery(), initialIndex: 0),
                    ),
                  ),
                  child: const Text('grid'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('grid'));
    await tester.pumpAndSettle();
    return c;
  }

  /// Unmounts the viewer and lets the details' short cache run out, so no
  /// timer is left pending.
  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 3));
  }

  /// A view tall enough for the whole sheet.
  void tallView(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> openInfo(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Image info'));
    await tester.pumpAndSettle();
  }

  testWidgets('the viewer has an info button', (tester) async {
    await pumpViewer(tester, _full);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byTooltip('Image info'), findsOneWidget);
    expect(repo.detailRequests, isEmpty, reason: 'details load only when the sheet opens');
  });

  testWidgets('the sheet shows every field that is set', (tester) async {
    tallView(tester);
    await pumpViewer(tester, _full);
    await openInfo(tester);

    expect(repo.detailRequests, ['1']);
    final sheet = find.byType(BottomSheet);
    Finder inSheet(String text) => find.descendant(of: sheet, matching: find.text(text));
    for (final text in [
      'Sunset at the lake',
      'Date',
      'Photographer',
      'Jo Lens',
      'Dimensions',
      '4000 × 3000',
      'Size',
      'Format',
      'JPEG',
      'File',
      'sunset.jpg',
      'Rating',
      'O-counter',
      '3',
      'Organized',
      'Added',
      'Updated',
      'Studio',
      'Lake Studio',
      'Performers',
      'Ada',
      'Tags',
      '#Outdoor',
      'Galleries',
      'Summer',
      'Details',
      'Shot from the pier.',
    ]) {
      expect(inSheet(text), findsOneWidget, reason: text);
    }
    expect(find.bySemanticsLabel(RegExp('Rating.*4 of 5 stars', dotAll: true)), findsOneWidget);
    await finish(tester);
  });

  testWidgets('unset fields are left out', (tester) async {
    await pumpViewer(tester, imageDetailsFrom({'id': '2'}));
    await openInfo(tester);

    final sheet = find.byType(BottomSheet);
    expect(find.descendant(of: sheet, matching: find.text('Image info')), findsOneWidget);
    for (final text in [
      'Date',
      'Photographer',
      'Dimensions',
      'Size',
      'Format',
      'File',
      'Rating',
      'O-counter',
      'Organized',
      'Added',
      'Updated',
      'Studio',
      'Performers',
      'Tags',
      'Galleries',
      'Details',
    ]) {
      expect(find.descendant(of: sheet, matching: find.text(text)), findsNothing, reason: text);
    }
    await finish(tester);
  });

  testWidgets('tapping a performer closes the viewer and opens them in the tab', (tester) async {
    tallView(tester);
    await pumpViewer(tester, _full);
    await openInfo(tester);

    await tester.tap(find.descendant(of: find.byType(ActionChip), matching: find.text('Ada')));
    await tester.pumpAndSettle();

    expect(find.byType(ImageViewerPage), findsNothing);
    expect(find.byType(BottomSheet), findsNothing);
    final page = tester.widget<PerformerPage>(find.byType(PerformerPage));
    expect(page.performerId, '7');
    await finish(tester);
  });

  testWidgets('fits at twice the text size', (tester) async {
    await pumpViewer(tester, _full, textScale: 2);
    await openInfo(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Sunset at the lake'), findsWidgets);
    await finish(tester);
  });
}
