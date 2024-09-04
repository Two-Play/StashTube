import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/Model/state.dart';

import '../graphql_manager.dart';

bool _isLinkException = false;
String _errorMessage = "";
dynamic _performer;

final class PerformerDetailViewResponseHandler implements GraphQLResponseHandler {
  @override
  dynamic onSuccess(QueryResult<Object?> result) {
    if (kDebugMode) {
      print(result);
    }
    _performer = result.data?['findPerformer'];
    return _performer;
  }

  @override
  void onError(dynamic error) {
    if (kDebugMode) {
      //print(error);
      print("LINK ERROR: ${error is OperationException ? error.linkException?.originalException.toString() : "N/A"}");
      print("ERROR: ${error.toString()}");
    }

    if (error is OperationException && error.linkException != null) {
      _isLinkException = true;
      _errorMessage = error.linkException!.originalException.toString();
    } else {
      _isLinkException = false;
      _errorMessage = error.toString();
    }
  }
}

class PerformerDetailViewModel {
  PerformerDetailViewModel({
    required this.performerId,

  }) {
    query = '''
      query {
        findPerformer(id: "$performerId") {
          id
          name
          country
          birthdate
          rating100
          favorite
          image_path
        }
      }
    ''';
  }

  static bool get isLinkException => _isLinkException;
  static String get errorMessage => _errorMessage;
  static dynamic get performer => _performer;

  final String performerId;

  late final String query;

  Future<bool> fetchPerformer() async {
    return await GraphQLManager.fetchGraphQL(
      GraphQLState.client.value,
      query,
      PerformerDetailViewResponseHandler(),
    );
  }
}