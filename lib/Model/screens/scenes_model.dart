
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/Model/graphql_manager.dart';
import 'package:stash_app_mobile/Model/state.dart';
import 'package:stash_app_mobile/util/ui_helper.dart';

import '../../View/screens/login.dart';

final class ScenesResponseHandler implements GraphQLResponseHandler {

  List<dynamic> _scenes = [];

  get context => null;

  @override
  void onError(dynamic error) {
    if (kDebugMode) {
      print(error);
      print("LINK ERROR: ${error.exception!.linkException?.originalException.toString()}");
      print("ERROR: ${error.exception.toString()}");
    }

    if (error.exception!.linkException != null) {
      // alert dialog and push to login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(error.exception!.linkException!.originalException.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const LoginPage()), (route) => false);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } else {
      // snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        snackBarHelper(context, error.exception.toString());
      });
    }
  }

  @override
  Future<List<dynamic>> onSuccess(QueryResult<Object?> result) async {
    if (kDebugMode) {
      print(result);
    }
    return result.data?['findScenes']['scenes'] ?? <dynamic>[];
  }
}


class ScenesModel {
  final String _scenesQuery = """
    query 
    {
  findScenes(filter:{
    sort:"date", 
    direction:DESC,
  })
  {
    scenes{
      title,
      date,
      rating100,
      files{
        duration,
        width,
        basename
      }
      studio
      {
        name,
        url,
        image_path
      }
      paths {
        screenshot,
        stream,
        preview
        }
      performers{
        name,
        image_path,
        id
      }
      
    }
  }

}
  """;

  Future<List<dynamic>> fetchScenesAlt(GraphQLClient client) async {
    final QueryOptions options = QueryOptions(
      document: gql(_scenesQuery),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      return <dynamic>[];
    }

    return result.data?['findScenes']['scenes'] ?? <dynamic>[];
  }

  void fetchScenes() {
    GraphQLManager.fetchGraphQL(
      GraphQLState.client.value,
      _scenesQuery,
      ScenesResponseHandler(),
    );
  }

  void scrollListener(ScrollController scrollController) {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (kDebugMode) {
        print('end of list');
      }
    }
  }
}