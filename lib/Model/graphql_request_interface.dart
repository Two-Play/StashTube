import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlReques {

}

abstract class GraphqlRequestInterface<T> {

  final String query;

  GraphqlRequestInterface({required this.query});

  Future<bool> sendGraphQLRequest(GraphQLClient client) async {
    final QueryOptions options = QueryOptions(
      document: gql(query),
    );

    try {
      final QueryResult result = await client.query(options);

      if (result.hasException) {
        //print(result.exception.toString());
        onException(result.exception.toString());
        return false;
      } else {
        onSucess(result.data as T);
      }

    } catch (e) {
      onException(e);
      return false;
    }
    return true;
  }

  void onException(Object e) {
    print(e);
  }

  void onSucess(T data) {

  }

  void onError() {

  }
}