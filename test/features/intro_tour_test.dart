import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/features/intro/intro_tour.dart';
import 'package:stash_app_mobile/l10n/gen/app_localizations.dart';

void main() {
  Future<void> open(WidgetTester tester, {Locale locale = const Locale('en'), double textScale = 1}) async {
    tester.view
      ..physicalSize = const Size(360, 780)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(onPressed: () => showIntroTour(context), child: const Text('open')),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('steps through to the end, then closes', (tester) async {
    await open(tester);
    final l = lookupAppLocalizations(const Locale('en'));
    final steps = introSteps(l);
    expect(steps, hasLength(6));
    for (var i = 0; i < steps.length; i++) {
      expect(find.text(steps[i].title), findsOneWidget);
      expect(find.bySemanticsLabel('Step ${i + 1} of ${steps.length}'), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
    }
    expect(find.byType(IntroTourPage), findsNothing);
  });

  testWidgets('shorts and loops are explained; skip ends it at once', (tester) async {
    await open(tester);
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Shorts and loops'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.byType(IntroTourPage), findsNothing);
  });

  for (final locale in const [Locale('en'), Locale('de')]) {
    testWidgets('every step fits with 2× text (${locale.languageCode})', (tester) async {
      await open(tester, locale: locale, textScale: 2);
      for (var i = 0; i < 6; i++) {
        expect(tester.takeException(), isNull, reason: 'step ${i + 1}');
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
      }
    });
  }
}
