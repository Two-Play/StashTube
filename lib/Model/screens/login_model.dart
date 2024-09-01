import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/util/observable.dart';
import 'package:http/http.dart' as http;
import 'package:stash_app_mobile/util/ui_helper.dart';

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
    final statusQueryResult = QueryOptions(document: gql(requestQuery));
    try {
      final QueryResult result = await client.query(statusQueryResult);

      if (result.hasException) {
        //print(result.exception.toString());
        return false;
      }
      if (result.data?['systemStatus']['status'] == 'OK') {
        return true;
      }
      if (kDebugMode) {
        print("Status: ${result.data!['systemStatus']['status']}");
      }
      return false;
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<bool> _canEstablishConnection(final String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> setCurrentUrlToTextField(
      final TextEditingController controller) async {
    String? value = await Storage.readKey("url");
    controller.text = value ?? "";
  }

  void handleLogin(final String url, final BuildContext context) async {
    if (!Validators.validateUrl(url)) {
      if (!context.mounted) return;
      snackBarHelper(context, "Invalid URL");
      return;
    }

    if (!await _canEstablishConnection(url)){
      if (!context.mounted) return;
      snackBarHelper(context, "Can't establish connection to the server");
      return;
    }

    GraphQLState.setNewClientUrl(url);
    final isStatusOk = await _isRequestStatusOk(GraphQLState.client.value);
    if (!context.mounted) return;
    // send request to server
    // execute first, if response status ok
    if (isStatusOk) {
      //TODO: reset global video state to null
      Storage.saveKey("url", url);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()), (route) => false);
    } else {
      snackBarHelper(context, "Server response status is not OK");
    }


  }

}