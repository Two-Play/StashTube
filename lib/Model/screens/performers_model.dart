
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

List<Performers> _performers = <Performers>[];
bool _isLinkException = false;
String _errorMessage = "";

final class PerformersResponseHandler implements GraphQLResponseHandler {
  @override
  List<Performers> onSuccess(QueryResult<Object?> result) {
    if (kDebugMode) {
      print(result);
    }
    _performers = result.data?['allPerformers']?.map<Performers>((performer) {
      // important to check for null values
      return Performers(
        name: performer['name'] ?? '',
        image: performer['image_path'] ?? '',
        country: performer['country'] ?? '',
        id: int.tryParse(performer['id'] ?? '0') ?? 0,
        birthdate: performer['birthdate'] ?? '',
        rating: performer['rating100'] ?? 0,
        favorite: performer['favorite'] ?? false
      );
    }).toList() ?? <Performers>[];
    return _performers;
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
      _errorMessage = error.exception.toString();
    }
  }
}

final class PerformersModel {
  static List<Performers> get performers => _performers;
  static bool get isLinkException => _isLinkException;
  static String get errorMessage => _errorMessage;

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

  Future<bool> fetchPerformers() async {
    bool value = await GraphQLManager.fetchGraphQL(
      GraphQLState.client.value,
      _performersQuery,
      PerformersResponseHandler(),
    );
    return value;
  }
}

