import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:stash_app_mobile/Model/state.dart';
import 'package:stash_app_mobile/View/screens/login.dart';
import 'package:stash_app_mobile/View/screens/performers.dart';
import 'package:stash_app_mobile/View/screens/settings.dart';
import 'package:stash_app_mobile/View/screens/studios.dart';
import 'package:stash_app_mobile/View/widgets/video_card_widget.dart';
import 'package:stash_app_mobile/util/navigator_shorter.dart';

import '../../Controler/screens/scenes_controller.dart';
import '../../Model/screens/scenes_model.dart'; // Import ScenesModel

class ScenesPage extends StatefulWidget {
  const ScenesPage({super.key});

  @override
  State<ScenesPage> createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> with AutomaticKeepAliveClientMixin<ScenesPage>{

  bool _loaded = false;
  final _scrollController = ScrollController();
  final _scenesController = ScenesController();
  final ScenesModel _scenesModel = ScenesModel(); // Create an instance of ScenesModel

  @override
  void initState() {
    super.initState();
    _fetchScenes();
  }

  Future<void> _fetchScenes() async {
    await _scenesModel.fetchScenesAlt(GraphQLState.client.value);
    setState(() {
      _loaded = true;
    });
  }

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
              NavigatorShorter.push(context, const SettingsPage());
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

      body: Consumer(
        builder: (context, ref, _) {
          final selectedVideo = ref.watch(VideoState.selectedVideoProvider);
          if (kDebugMode) {
            print("SELECTED VIDEO: ${selectedVideo?.title}");
          }
          return ValueListenableBuilder(
              valueListenable: GraphQLState.client,
              builder: (context, value, child) => child!,
              child: _loaded ? FutureBuilder<List<dynamic>>(
                future: _scenesModel.fetchScenesAlt(GraphQLState.client.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  final sceneList = snapshot.data ?? [];

                  if (sceneList.isEmpty) {
                    return RefreshIndicator(
                        onRefresh: () async {
                          await _fetchScenes();
                          HapticFeedback.mediumImpact();
                        },
                        child: ListView(
                          children: [
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
                      await _fetchScenes();
                      HapticFeedback.mediumImpact();
                    },
                    child: ListView.builder(
                          itemCount: sceneList.length,
                          itemBuilder: (context, index) {

                            double dur = (sceneList[index]['files'][0]['duration']+.0);
                            List<Performers> performers = [];
                            for (var performer in sceneList[index]['performers']) {
                              performers.add(Performers(
                                name: performer['name'],
                                image: performer['image_path'],
                                bio: "bio",
                                id: int.parse(performer['id']),
                              ));
                            }
                            if (performers.isEmpty) {
                              performers.add(const Performers(
                                name: "Unknown",
                                image: "",
                                bio: "",
                                id: -1,
                              ));
                            }

                            return VideoCard(video:
                            Video(thumbnail: sceneList[index]['paths']['screenshot'],
                              title: sceneList[index]['title'],
                              performers: [
                                Performers(name: performers[0].name,
                                    image: performers[0].image,
                                    bio: performers[0].bio,
                                    id: performers[0].id,
                                ),
                              ],
                              stream: sceneList[index]['paths']['stream'],
                              stars: 5,
                              studio: Studio(
                                  name: "TEST",
                                  image: "http://192.168.44.5:9999/studio/3/image?t=1641002641"
                              ),
                              date: sceneList[index]['date']?? "date",
                              duration: dur,
                              resolution: "resolution",
                            )
                            );
                          },
                        ),
                  );
                },
              ) : const Center(
                child: CircularProgressIndicator(),
              ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}