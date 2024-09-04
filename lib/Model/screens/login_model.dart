import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stash_app_mobile/Model/state.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/util/observable.dart';
import 'package:http/http.dart' as http;
import 'package:stash_app_mobile/util/ui_helper.dart';

import '../../main.dart';
import '../../util/storage.dart';
import '../../util/validators.dart';
import '../state.dart';

String _errorMessage = "";

final class LoginModel {

  static String get errorMessage => _errorMessage;
  // TODO: correct url: http://stashapp:8080 works but http://stashapp:8080/ does not work
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

  Future<bool> loginSuccess(final String url, final WidgetRef ref) async {
    if (!Validators.validateUrl(url)) {
      _errorMessage = "Invalid URL";
      return false;
    }

    if (!await _canEstablishConnection(url)){
      _errorMessage = "Can't establish connection to the server";
      return false;
    }

    GraphQLState.setNewClientUrl(url);
    final isStatusOk = await _isRequestStatusOk(GraphQLState.client.value);
    // send request to server
    // execute first, if response status ok
    if (isStatusOk) {
      // reset global video state to null
      ref.read(VideoState.selectedVideoProvider.notifier).state = null;
      Storage.saveKey("url", url);
      return true;
    } else {
      _errorMessage = "Server response status is not OK";
      return false;
    }

  }

}