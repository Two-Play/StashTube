import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/main.dart';

import '../widgets/performer_card_widget.dart';

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

class PerformersPage extends StatefulWidget {

  const PerformersPage({super.key});

  @override
  State<PerformersPage> createState() => _PerformersPageState();
}

class _PerformersPageState extends State<PerformersPage>  with AutomaticKeepAliveClientMixin<PerformersPage>{

  final String performersQuery = """
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Performers'),
      ),
      body: ValueListenableBuilder(
        valueListenable: client,
        builder: (context, value, child) => child!,
        child: Query(
          options: QueryOptions(
            document: gql(performersQuery),
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final performers = result.data!['allPerformers'];

            if (performers.isEmpty) {
              return RefreshIndicator(
                  onRefresh: () async {
                    await refetch!();
                  },
                  child: ListView(
                    children: [
                      // center heding title text and image
                      Center(
                        child: Column(
                          children:  [
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 88.0),
                                child: Text('No performers found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(),
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 58.0),
                              child: SvgPicture.asset(
                                height: 300.0,
                                'assets/images/images.svg',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await refetch!();
              },
              child: ListView.builder(
                itemCount: performers.length,
                itemBuilder: (context, index) {
                  final performer = performers[index];
                  return PerformerCard(
                    performer: Performers(
                      name: performer['name'],
                      image: performer['image_path'],
                      country: performer['country'],
                      id: int.parse(performer['id']),
                      // birthdate: performer['birthdate'],
                      // rating: performer['rating100'],
                      // favorite: performer['favorite']
                    ),
                  );
                },
              ),
            );
          }
      )
    )
    );
  }
  @override
  bool get wantKeepAlive => true;
}
