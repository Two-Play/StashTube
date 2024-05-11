import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/Model/screens/login_model.dart';
import 'package:stash_app_mobile/Model/state.dart';
import 'package:stash_app_mobile/util/storage.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  //   testWidgets('Test if the LoginModel handleLogin method saves the url', (WidgetTester tester) async {
  //     final client = MockClient();
  //
  //     when(client.get(Uri.parse('http://localhost/graphql'))).thenAnswer((_) async => http.Response('''
  //     {
  //     "data": {
  //     "systemStatus": {
  //     "status": "OK"
  //     }
  //     }
  //     }
  //     ''', 200));
  //
  //   // final client = GraphQLClient(
  //   //   cache: GraphQLCache(),
  //   //   link: HttpLink('http://localhost/graphql'),
  //   // );
  //
  //   final loginModel = LoginModel();
  //   const url = 'http://localhost/graphql';
  //
  //   // Erstellen und rendern Sie ein Widget, um einen BuildContext zu erhalten
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Scaffold(
  //         body: Builder(
  //           builder: (BuildContext context) {
  //             // Verwenden Sie den BuildContext, um die handleLogin-Methode aufzurufen
  //             loginModel.handleLogin(url, context);
  //             return Container();
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   final result = await Storage.readKey('url');
  //
  //   expect(result, url);
  // });

  test("Test if the LoginModel setCurrentUrlToTextField method sets the url", () async {
    // works in the real app, but not in the test
    final controller = TextEditingController();
    const url = 'http://localhost/graphql';

    await Storage.saveKey('url', url);

    final loginModel = LoginModel();
    await loginModel.setCurrentUrlToTextField(controller);

    expect(controller.text, url);
  });
}