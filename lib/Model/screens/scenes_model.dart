import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/Model/graphql_manager.dart';
import 'package:stash_app_mobile/Model/state.dart';
import 'package:stash_app_mobile/util/observable.dart';
import 'package:stash_app_mobile/util/ui_helper.dart';

import '../../View/screens/login.dart';

List<dynamic> _scenes = <dynamic>[];
bool _isLinkException = false;
String _errorMessage = "";

final class ScenesResponseHandler implements GraphQLResponseHandler {


  @override
  void onError(dynamic error) {
    if (kDebugMode) {
      print(error);
      print("LINK ERROR: ${error.linkException?.originalException.toString()}");
      print("ERROR: ${error.toString()}");
    }

    if (error is OperationException && error.linkException != null) {
     _isLinkException = true;
     _errorMessage = error.linkException!.originalException.toString();
    } else {
      _isLinkException = false;
      _errorMessage = error.exception.toString();
    }
  }

  @override
  Future<List<dynamic>> onSuccess(QueryResult<Object?> result) async {
    if (kDebugMode) {
      print("Scene_model: $result");
    }
    _scenes = result.data?['findScenes']['scenes'] ?? <dynamic>[];
    return _scenes;
  }
}

class ScenesModel {
  static bool get isLinkException => _isLinkException;
  static String get errorMessage => _errorMessage;
  static List<dynamic> get scenes => _scenes;

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

  // Future<List<dynamic>> fetchScenesAlt(GraphQLClient client) async {
  //   final QueryOptions options = QueryOptions(
  //     document: gql(_scenesQuery),
  //   );
  //
  //   final QueryResult result = await client.query(options);
  //
  //   if (result.hasException) {
  //     print(result.exception.toString());
  //     return <dynamic>[];
  //   }
  //
  //   return result.data?['findScenes']['scenes'] ?? <dynamic>[];
  // }

  Future<bool> fetchScenes() async {
    bool value = await GraphQLManager.fetchGraphQL(
      GraphQLState.client.value,
      _scenesQuery,
      ScenesResponseHandler(),
    );
    return value;
  }

  void scrollListener(ScrollController scrollController) {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (kDebugMode) {
        print('end of list');
      }
    }
  }
}