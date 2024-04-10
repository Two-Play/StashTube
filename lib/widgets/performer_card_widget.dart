import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stash_app_mobile/screens/scenes.dart';

import '../screens/performers.dart';

class PerformerCard extends StatelessWidget {

  // final String name;
  // final String image;
  // final String country;
  // final String birthdate;
  // final int rating;
  // final bool favorite;

  final Performers performer;

  const PerformerCard({super.key, required this.performer});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScenesPage(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Stack(
            children: [
              Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: performer.image,
                      height: 550.0,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      fit: BoxFit.cover,
                    ),
                    //
                  ),
                  //SizedBox(height: 16,),
                  Column(children:[
                    Text(performer.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Subtitle')
                  ])
                ],
              ),
            ),
              // County flag
              Positioned(
                top: 20.0,
                right: 20.0,
                child: GestureDetector(
                  onTap: () => {
                    // snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Country: ${performer.country}'),
                        duration: const Duration(seconds: 2),
                      ),
                    ),
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: performer.country != "" ? CountryFlag.fromCountryCode(
                      performer.country,
                      width: 40.0,
                      height: 30.0,
                      ) : null,
                  ),
                ),
              ),

              // studio logo
              Positioned(
                top: 20.0,
                left: 20.0,
                child: GestureDetector(
                  onTap: () => print('Navigate to studio'),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVNSBi6_6uhsx3eDWbg6oLtSNLeSSvXTHkIKW9iHaalw&s',
                      //height: 30.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // rating banner badge
              Positioned(
                bottom: 70.0,
                right: 20.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Badge(
                    backgroundColor: Colors.red,

                    label: Text(
                      performer.rating.toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
