import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/features/shell/navigation.dart';

/// The relevant part of AppShell: a tab navigator keyed from
/// tabNavigatorKeysProvider, inside a shell keyed by server (as in StashApp).
class _Shell extends ConsumerWidget {
  const _Shell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Navigator(
        key: ref.watch(tabNavigatorKeysProvider)[AppTab.studios],
        onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => const Text('studios root')),
      );
}

void main() {
  testWidgets('pages opened on the old server are gone after switching', (tester) async {
    final c = (await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final c = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
      await c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://a'));
      return c;
    }))!;
    addTearDown(c.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(
        home: Consumer(builder: (_, ref, _) => _Shell(key: ValueKey(ref.watch(activeServerIdProvider)))),
      ),
    ));
    c.read(tabNavigatorKeysProvider)[AppTab.studios]!.currentState!.push(
          MaterialPageRoute<void>(builder: (_) => const Text('studio of server A')),
        );
    await tester.pumpAndSettle();
    expect(find.text('studio of server A'), findsOneWidget);

    await tester.runAsync(() => c.read(serverProfilesProvider.notifier).add(const ServerConfig(baseUrl: 'http://b')));
    await tester.pumpAndSettle();
    expect(find.text('studio of server A'), findsNothing);
    expect(find.text('studios root'), findsOneWidget);
  });

  testWidgets('re-selecting a tab goes back to its root, then scrolls to the top', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
      home: Navigator(
        key: navigatorKey,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => PrimaryScrollController(
            controller: controller,
            // Like the tab pages' lists: no controller of their own.
            child: ListView(children: [for (var i = 0; i < 100; i++) SizedBox(height: 50, child: Text('row $i'))]),
          ),
        ),
      ),
    ));
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    navigatorKey.currentState!.push(MaterialPageRoute<void>(builder: (_) => const Text('a page')));
    await tester.pumpAndSettle();

    reselectTab(navigatorKey.currentState, controller);
    await tester.pumpAndSettle();
    expect(find.text('a page'), findsNothing);
    expect(controller.offset, greaterThan(0), reason: 'first back to the root, as it was');

    reselectTab(navigatorKey.currentState, controller);
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });
}
