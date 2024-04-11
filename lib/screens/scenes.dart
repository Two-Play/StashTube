import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/screens/login.dart';
import 'package:stash_app_mobile/screens/performers.dart';

import 'package:stash_app_mobile/screens/settings.dart';
import 'package:stash_app_mobile/screens/studios.dart';
import 'package:stash_app_mobile/widgets/video_card_widget.dart';

import '../main.dart';


class ScenesPage extends StatefulWidget {
  const ScenesPage({super.key});

  @override
  State<ScenesPage> createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> with AutomaticKeepAliveClientMixin<ScenesPage>{

  bool _loaded = false;
  final _scrollController = ScrollController();
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
        image_path
      }
      
    }
  }

}
  """;

  // scroll method
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    print('end of list');
    }
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);

    // if (!_loaded) {
    //   _loaded = true;
    //   _scrollController.addListener(_scrollListener);
    // }
    
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
            icon: const Icon(Icons.search),
            onPressed: () {
            print("search");
            },
          ),
        ],
      ),


  // get scene list and return card widgets
      body: Consumer(
        builder: (context, ref, _) {
          final selectedVideo = ref.watch(selectedVideoProvider);
          if (kDebugMode) {
            print("SELECTED VIDEO: ${selectedVideo?.title}");
          }
          return ValueListenableBuilder(
              valueListenable: client,
              builder: (context, value, child) => child!,
              child: Query(
                options: QueryOptions(
                  document: gql(_scenesQuery),
                ),
                builder: (result, {fetchMore, refetch}) {

                  if (result.hasException) {
                    if (kDebugMode) {
                      print("LINK ERROR: ${result.exception!.linkException?.originalException.toString()}");
                      print("ERROR: ${result.exception.toString()}");
                    }

                    if (result.exception!.linkException != null) {
                      // alert dialog and push to login page
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(result.exception!.linkException!.originalException.toString()),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    //Navigator.of(context).pop();
                                    Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const LoginPage()), (route) => false);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      });
                    }
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final sceneList = result.data?['findScenes']['scenes'];

                  if (sceneList.isEmpty) {
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
                                    child: Text('No scenes found',
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
                          //controller: _scrollController,
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

                            // fetchMore!(FetchMoreOptions(updateQuery: (existing, next) {
                            //   // final List scenes = [
                            //   //   ...existing?['findScenes']['scenes'],
                            //   //   ...next?['findScenes']['scenes'],
                            //   // ];
                            //   // return existing
                            //   //   ..['findScenes']['scenes'] = scenes;
                            //   print("Fetch");
                            //   return existing;
                            // }));


                            return VideoCard(video:
                            Video(thumbnail: sceneList[index]['paths']['screenshot'],
                              title: sceneList[index]['title'],
                              performers: [
                                Performers(name: performers[0].name,
                                    image: performers[0].image,
                                    bio: performers[0].bio
                                ),
                              ],
                              stream: sceneList[index]['paths']['stream'],
                              stars: 5,
                              studio: Studio(
                                  name: "TEST",//sceneList[index]['studio']['name'],
                                  image: "http://192.168.44.5:9999/studio/3/image?t=1641002641"
                                //url: sceneList[index]['studio']['url'],
                              ),
                              date: sceneList[index]['date']?? "date",
                              //convert dur double seconds to duration minutes and seconds
                              duration: dur,
                              resolution: "resolution",
                            )
                            );
                          },
                        ),

                  );
                },
              ),

          );
        },

      ),

    );
  }
  @override
  bool get wantKeepAlive => true;

}