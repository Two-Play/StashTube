
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/Model/state.dart';

import '../graphql_manager.dart';

class Performers {
  final String name;
  final String image;
  final String bio;
  final String country;
  final String birthdate;
  final int rating;
  final bool favorite;
  final int id;

  const Performers({
    required this.name,
    required this.image,
    required this.id,
    this.bio = "",
    this.country = "",
    this.birthdate = "",
    this.rating = 0,
    this.favorite = false
  });
}

final class PerformersResponseHandler implements GraphQLResponseHandler<List<Performers>, void> {
  @override
  List<Performers> onSuccess(QueryResult<Object?> result) {
    if (kDebugMode) {
      print(result);
    }
    return result.data?['allPerformers']?.map<Performers>((performer) {
      return Performers(
        name: performer['name'],
        image: performer['image_path'],
        country: performer['country'],
        id: int.parse(performer['id']),
        birthdate: performer['birthdate'],
        rating: performer['rating100'],
        favorite: performer['favorite']
      );
    }).toList() ?? <Performers>[];
  }

  @override
  void onError(dynamic error) {
    print(error);
  }
}

class PerformersModel {
  final String _performersQuery = """
    query 
    {
    allPerformers{
      id,
      name,
      birthdate,
      country,
      favorite,
      rating100,
      image_path
    }
  }
  """;

  // Future<bool> fetchPerformers(GraphQLClient client, PerformersResponseHandler responseHandler) async {
  //   return await GraphQLManager.fetchGraphQL(client, performersQuery, responseHandler);
  // }
  void fetchPerformers() {
    GraphQLManager.fetchGraphQL(
      GraphQLState.client.value,
      _performersQuery,
      PerformersResponseHandler(),
    );
  }
}

