import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stash_app_mobile/core/config/server_config.dart';
import 'package:stash_app_mobile/data/connection_status.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/data/repositories/stash_session.dart';
import 'package:stash_app_mobile/widgets/connection_banner.dart';

class _Profiles extends ServerProfilesNotifier {
  @override
  ServerProfiles build() => const ServerProfiles(
        profiles: [ServerProfile(id: 'test-server', name: 'Home server', baseUrl: 'http://test')],
        activeId: 'test-server',
      );
}

void main() {
  late bool online;
  late ProviderContainer c;

  Future<void> pump(WidgetTester tester) async {
    online = false;
    c = ProviderContainer(overrides: [
      serverProfilesProvider.overrideWith(_Profiles.new),
      stashHttpClientProvider.overrideWithValue(MockClient((_) async => http.Response('', 500))),
      graphQLClientProvider.overrideWithValue(GraphQLClient(
        cache: GraphQLCache(),
        link: Link.function((request, [forward]) => online
            ? Stream.value(const Response(data: {
                '__typename': 'Query',
                'version': {'__typename': 'Version', 'version': 'v0.31.1'},
              }, response: {}))
            : Stream.error(const ServerException(originalException: 'Connection refused'))),
      )),
    ]);
    addTearDown(c.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(home: Scaffold(body: ConnectionBannerScope(child: Text('tab content')))),
    ));
  }

  testWidgets('shows while the server is unreachable and hides after a successful call', (tester) async {
    await pump(tester);
    expect(find.byType(ConnectionBanner), findsNothing);
    expect(find.text('tab content'), findsOneWidget);

    c.read(connectionStatusProvider.notifier).report(reachable: false);
    await tester.pumpAndSettle();
    expect(find.text('Server not reachable'), findsOneWidget);
    expect(find.textContaining('Home server'), findsOneWidget);
    expect(find.text('Switch server'), findsOneWidget);
    final semantics = tester.getSemantics(find.text('Server not reachable'));
    expect(semantics.getSemanticsData().flagsCollection.isLiveRegion, isTrue);

    c.read(connectionStatusProvider.notifier).report(reachable: true);
    await tester.pumpAndSettle();
    expect(find.byType(ConnectionBanner), findsNothing);
    expect(find.text('tab content'), findsOneWidget);
  });

  testWidgets('"Retry" checks the server and hides the banner once it answers', (tester) async {
    await pump(tester);
    await tester.runAsync(() => c.read(stashRepositoryProvider).serverVersion().catchError((_) => null));
    await tester.pumpAndSettle();
    expect(find.text('Server not reachable'), findsOneWidget);

    // Still offline: the banner stays.
    await tester.runAsync(() async {
      await tester.tap(find.text('Retry'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
    expect(find.text('Server not reachable'), findsOneWidget);

    online = true;
    await tester.runAsync(() async {
      await tester.tap(find.text('Retry'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
    expect(find.byType(ConnectionBanner), findsNothing);
    expect(c.read(connectionStatusProvider), ServerReachability.reachable);
  });

  testWidgets('shows at once with reduced motion', (tester) async {
    await pump(tester);
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.pump();

    c.read(connectionStatusProvider.notifier).report(reachable: false);
    await tester.pump();
    expect(tester.getSize(find.byType(ConnectionBanner)).height, greaterThan(0));
    expect(tester.hasRunningAnimations, isFalse);
  });
}
