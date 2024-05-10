import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PerformerDetailsPage extends StatelessWidget {
  const PerformerDetailsPage({super.key, required this.performerId});

  final int performerId;


  @override
  Widget build(BuildContext context) {

    final perforemerQuery = """
    query 
    {
      findPerformer(id: $performerId){
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

    return Query(
      options: QueryOptions(
        document: gql(perforemerQuery),
      ),
      builder: (QueryResult result, {refetch, fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final performer = result.data!['findPerformer'];

        return Scaffold(
          appBar: AppBar(
            title: Text(performer['name']),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CachedNetworkImage(
                  height: 550,
                  //color: Colors.blue,
                  imageUrl: performer['image_path'],
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  fit: BoxFit.cover,

                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ListTile(
                      title: Text('Performer ID: ${performer['id']}'),
                    ),
                    ListTile(
                      title: Text('Performer Name: ${performer['name']}'),
                    ),
                    ListTile(
                      title: Text('Performer Country: ${performer['country']}'),
                    ),
                    ListTile(
                      title: Text('Performer Birthdate: ${performer['birthdate']}'),
                    ),
                    ListTile(
                      title: Text('Performer Rating: ${performer['rating100']}'),
                    ),
                    ListTile(
                      title: Text('Performer Favorite: ${performer['favorite']}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },

    );
  }
}
