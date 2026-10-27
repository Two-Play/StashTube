import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/settings/theme_welcome.dart';
import 'package:stash_app_mobile/features/whats_new/whats_new.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('en'));
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  /// A screen that asks for "what's new" like the shell does.
  Future<ProviderContainer> pump(WidgetTester tester, {bool firstLogin = false, double textScale = 1}) async {
    final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
    addTearDown(c.dispose);
    if (firstLogin) await c.read(themeWelcomeProvider.notifier).request();
    late WidgetRef widgetRef;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Consumer(builder: (context, ref, _) {
          widgetRef = ref;
          return const Scaffold();
        }),
      ),
    ));
    showWhatsNewIfPending(tester.element(find.byType(Scaffold)), widgetRef);
    await tester.pumpAndSettle();
    return c;
  }

  test('every announcement has a title and bullets in both languages; ids rise', () {
    for (final locale in const [Locale('en'), Locale('de')]) {
      final entries = changelog(lookupAppLocalizations(locale));
      expect(entries, isNotEmpty);
      for (final entry in entries) {
        expect(entry.title, isNotEmpty);
        expect(entry.items.length, inInclusiveRange(2, 8), reason: 'only the highlights up front');
        for (final item in [...entry.items, ...entry.more]) {
          expect(item.icon, isNot(Icons.circle), reason: 'an icon per line (${locale.languageCode}): ${item.text}');
        }
      }
      final ids = [for (final e in entries) e.id];
      expect(ids, [...ids]..sort((a, b) => b - a), reason: 'newest first');
    }
  });

  testWidgets('after an update: shown once', (tester) async {
    final c = await pump(tester);
    expect(find.text(l.whatsNewTitle), findsOneWidget);
    expect(find.text(l.whatsNew1Title), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome), findsNothing);
    expect(find.byIcon(Icons.loop), findsOneWidget, reason: 'the loops item has its icon');
    final entry = changelog(l).first;
    expect(find.text(entry.more.first.text), findsNothing, reason: 'the rest behind "show more"');
    await tester.ensureVisible(find.text(l.whatsNewShowMore(entry.more.length)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.whatsNewShowMore(entry.more.length)));
    await tester.pumpAndSettle();
    expect(find.text(entry.more.first.text, skipOffstage: false), findsOneWidget);
    expect(find.text(l.whatsNewShowLess, skipOffstage: false), findsOneWidget);
    expect(c.read(whatsNewSeenProvider), latestChangelogId(l));
    expect(prefs.getInt('whats_new_seen'), latestChangelogId(l), reason: 'stored');

    await tester.tap(find.text(l.whatsNewDone));
    await tester.pumpAndSettle();
    expect(find.text(l.whatsNewTitle), findsNothing);

    await pump(tester);
    expect(find.text(l.whatsNewTitle), findsNothing, reason: 'not again');
  });

  testWidgets('after the first login nothing is new: the tour explains the app', (tester) async {
    final c = await pump(tester, firstLogin: true);
    expect(find.text(l.whatsNewTitle), findsNothing);
    expect(c.read(whatsNewSeenProvider), latestChangelogId(l), reason: 'counts as seen');
  });

  testWidgets('fits with 2× text', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 780)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pump(tester, textScale: 2);
    expect(find.text(l.whatsNewTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
