import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart';


// Interface for Callback-Methoden
abstract class GraphQLResponseHandler<T, A> {
  T onSuccess(QueryResult<Object?> result);
  A onError(dynamic error);
}

class GraphQLManager {
  GraphQLManager._();

  /*
   * Methode zum Ausführen von GraphQL-Queries
   *
   * @param client GraphQLClient
   * @param query String
   * @param responseHandler GraphQLResponseHandler
   * @return Future<bool>
   */
  static Future<bool> fetchGraphQL(
       GraphQLClient client,
       String query,
       GraphQLResponseHandler responseHandler,
      ) async {
    final statusQueryResult =
    QueryOptions(document: gql(query));
    try {
      final QueryResult result = await client.query(statusQueryResult);

      if (result.hasException) {
        responseHandler.onError(result.exception);
        return false;
      }

      responseHandler.onSuccess(result);
      return true;

    } catch (e) {
      responseHandler.onError(e);
      return false;
    }
  }
}