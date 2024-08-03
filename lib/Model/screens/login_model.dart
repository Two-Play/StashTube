import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/util/observable.dart';

import '../../main.dart';
import '../../util/storage.dart';
import '../../util/validators.dart';
import '../state.dart';

class LoginModel extends Observable {

  Future<bool> _isRequestStatusOk(final GraphQLClient client) async {
    const requestQuery = """
          {
            systemStatus
            {
              status
            }
          }
          """;

    // request to the server
    final statusQueryResult =
    QueryOptions(document: gql(requestQuery));
    try {
      final QueryResult result = await client.query(statusQueryResult);

      if (result.hasException) {
        //print(result.exception.toString());
        return false;
      }
      if (result.data?['systemStatus']['status'] == 'OK') {
        return true;
      }
      print("HALLO Status: ${result.data!['systemStatus']['status']}");
      return false;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<void> setCurrentUrlToTextField(
      final TextEditingController controller) async {
    String? value = await Storage.readKey("url");
    controller.text = value ?? "";
  }

  void handleLogin(final String url, final BuildContext context) async {

    if (Validators.validateUrl(url)) {

      GraphQLState.setNewClientUrl(url);

      //send request to the server
      // execute firt if response status ok
      if (await _isRequestStatusOk(GraphQLState.client.value)) {
        //TODO: reset global video state to null
        Storage.saveKey("url", url);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()), (route) => false);
      } else {
        notifyListeners(LoginEvents.loginFailed);
      }
    } else {
      notifyListeners(LoginEvents.loginFailed);
    }

  }

}