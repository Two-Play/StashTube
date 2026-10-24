import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stash_app_mobile/data/repositories/stash_repository.dart';
import 'package:stash_app_mobile/widgets/status_views.dart';

void main() {
  Future<void> pump(WidgetTester tester, Object error, {VoidCallback? onRetry}) => tester.pumpWidget(MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ErrorView(error: error, onRetry: onRetry))),
      ));

  testWidgets('an unreachable server: headline, plain advice, retry; the technical text behind "Details"',
      (tester) async {
    var retried = 0;
    const error = StashApiException(
      'Could not reach the server: SocketException: Connection refused (errno = 111)',
      isNetworkError: true,
      kind: StashErrorKind.unreachable,
      detail: 'SocketException: Connection refused (errno = 111)',
    );
    await pump(tester, error, onRetry: () => retried++);

    expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    expect(find.text("Can't reach the server"), findsOneWidget);
    expect(find.textContaining('VPN'), findsOneWidget);
    expect(find.textContaining('errno'), findsNothing, reason: 'no technical text up front');

    await tester.tap(find.text('Retry'));
    expect(retried, 1);

    await tester.tap(find.text('Details'));
    await tester.pump();
    final details = find.byType(SelectableText);
    expect(details, findsOneWidget);
    expect(tester.widget<SelectableText>(details).data, contains('errno = 111'));

    await tester.tap(find.text('Hide details'));
    await tester.pump();
    expect(find.byType(SelectableText), findsNothing);
  });

  testWidgets('each kind has its own symbol and headline', (tester) async {
    final cases = <StashApiException, (IconData, String)>{
      const StashApiException('401', kind: StashErrorKind.unauthorized): (Icons.lock_outline, 'Access denied'),
      const StashApiException('bad login', kind: StashErrorKind.invalidCredentials): (
        Icons.lock_outline,
        'Sign-in failed'
      ),
      const StashApiException('x', isNetworkError: true, kind: StashErrorKind.localNetworkDenied): (
        Icons.wifi_off,
        'No access to the local network'
      ),
      const StashApiException('setup', kind: StashErrorKind.notReady, detail: 'SETUP'): (
        Icons.error_outline,
        'Server not ready'
      ),
      const StashApiException('Performer not found.', kind: StashErrorKind.notFound): (
        Icons.search_off,
        'Not found'
      ),
      const StashApiException('Cannot query field "x"'): (Icons.error_outline, 'Something went wrong'),
    };
    for (final MapEntry(key: error, value: (icon, headline)) in cases.entries) {
      await pump(tester, error);
      expect(find.byIcon(icon), findsOneWidget, reason: '${error.kind}');
      expect(find.text(headline), findsOneWidget, reason: '${error.kind}');
      expect(find.text('Retry'), findsNothing, reason: 'no callback, no button');
    }
  });

  testWidgets('a blocked local network says where to allow it, in the explanation itself', (tester) async {
    await pump(tester, const StashApiException('x', isNetworkError: true, kind: StashErrorKind.localNetworkDenied));
    expect(find.textContaining('Privacy & Security → Local Network → StashTube'), findsOneWidget);
  });

  testWidgets('other errors show their text only under "Details"', (tester) async {
    await pump(tester, Exception('boom'));
    expect(find.textContaining('boom'), findsNothing);
    await tester.tap(find.text('Details'));
    await tester.pump();
    expect(find.textContaining('boom'), findsOneWidget);
  });
}
