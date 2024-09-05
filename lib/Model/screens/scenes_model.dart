import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/Model/graphql_manager.dart';

import '../state.dart';

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

final class ScenesModel {
  static bool get isLinkException => _isLinkException;
  static String get errorMessage => _errorMessage;
  static List<dynamic> get scenes => _scenes;
  
  static String getThumbnail(int index) => _scenes[index]['paths']['screenshot'];
  static String getStream(int index) => _scenes[index]['paths']['stream'];
  static String getPreview(int index) => _scenes[index]['paths']['preview'];
  static String getTitle(int index) => _scenes[index]['title'] == "" ? _scenes[index]['files'][0]['basename'] : _scenes[index]['title'];
  static int getHeigth(int index) => _scenes[index]['files'][0]['height'];
  static int getWidth(int index) => _scenes[index]['files'][0]['width'];
  static String getDuration(int index) {
    double duration = _scenes[index]['files'][0]['duration'];
    if (duration == 0) {
      return "0:00";
    }
    String hours = (duration ~/ 3600).floor().toString();
    String minutes = ((duration % 3600) ~/ 60).floor().toString();
    String seconds = (duration % 60).floor().toString().padLeft(2, '0');
    if (hours == "0") {
      return "$minutes:$seconds";
    }
    minutes = minutes.padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

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
        height,
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

  Future<bool> fetchScenes() async {
    bool value = await GraphQLManager.fetchGraphQL(
      GraphQLState.client.value,
      _scenesQuery,
      ScenesResponseHandler(),
    );
    return value;
  }

  void scrollListener(ScrollController scrollController) {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
      if (kDebugMode) {
        print('end of list');
      }
    }
  }
}