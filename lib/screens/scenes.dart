import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/screens/login.dart';
import 'package:stash_app_mobile/screens/performers.dart';

import 'package:stash_app_mobile/screens/settings.dart';
import 'package:stash_app_mobile/screens/studios.dart';
import 'package:stash_app_mobile/widgets/video_card_widget.dart';


class ScenesPage extends StatefulWidget {
  const ScenesPage({super.key});

  @override
  State<ScenesPage> createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> with AutomaticKeepAliveClientMixin<ScenesPage>{

  final String scenesQuery = """
    query 
    {
    sceneWall{
      title,
      date,
      rating100,
      files{
        duration,
        width
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
        image_path
      }
    }
}
  """;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scenes'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),

      
  // get scene list and return card widgets
      body: Query(
        options: QueryOptions(
          document: gql(scenesQuery),
        ),
        builder: (result, {fetchMore, refetch}) {

          if (result.hasException) {
            if (kDebugMode) {
              print("LINK ERROR: ${result.exception!.linkException?.originalException.toString()}");
              print("ERROR: ${result.exception.toString()}");
            }

            if (result.exception!.linkException != null) {
              // alert dialog and push to login page
              //Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const LoginPage()));
            }

            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(
            child: CircularProgressIndicator(),
            );
          }

          final sceneList = result.data?['sceneWall'];


            return ListView.builder(
              itemCount: sceneList.length,
              itemBuilder: (context, index) {

                double dur = (sceneList[index]['files'][0]['duration']+.0);
                // filter non null performers to list
                List<Performers> performers = [];
                for (var performer in sceneList[index]['performers']) {
                    performers.add(Performers(
                      name: performer['name'],
                      image: performer['image_path'],
                      bio: "bio",
                    ));
                }
                if (performers.isEmpty) {
                  performers.add(const Performers(
                    name: "Unknown",
                    image: "",
                    bio: "",
                  ));
                }



                return VideoCard(video:
                Video(thumbnail: sceneList[index]['paths']['screenshot'],
                  title: sceneList[index]['title'],
                  performers: [
                    Performers(name: performers[0].name,
                        image: performers[0].image,
                        bio: performers[0].bio
                    ),
                  ],

                  stars: 5,
                  studio: Studio(
                    name: "TEST",//sceneList[index]['studio']['name'],
                    image: "http://192.168.44.5:9999/studio/3/image?t=1641002641"
                    //url: sceneList[index]['studio']['url'],
                  ),
                  date: sceneList[index]['date']?? "date",
                  //convert dur double seconds to duration minutes and seconds
                  duration: "${(dur/60).floor()}m ${(dur%60).floor()}s",
                  resolution: "resolution",
                )
                );
              },
            );
        },
      ),
      
    );
  }
  @override
  bool get wantKeepAlive => true;

}
