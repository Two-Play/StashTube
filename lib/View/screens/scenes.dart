import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'package:stash_app_mobile/Model/state.dart';

import 'package:stash_app_mobile/View/screens/settings.dart';
import 'package:stash_app_mobile/View/screens/studios.dart';
import 'package:stash_app_mobile/View/widgets/video_card_widget.dart';
import 'package:stash_app_mobile/util/navigator_shorter.dart';

import '../../Controler/screens/scenes_controller.dart';
import '../../Model/screens/performers_model.dart';
import '../../Model/screens/scenes_model.dart';
import '../../util/observable.dart';
import '../../util/ui_helper.dart';
import 'login.dart'; // Import ScenesModel

class ScenesPage extends StatefulWidget {
  const ScenesPage({super.key});

  @override
  State<ScenesPage> createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> with
    AutomaticKeepAliveClientMixin<ScenesPage> implements Observer {

  bool _loaded = false;
  final _scrollController = ScrollController();
  final _scenesController = ScenesController();

  @override
  void initState() {
    super.initState();
    _scenesController.addListener(this);
    _scenesController.fetchScenes();
  }

  @override
  void dispose() {
    _scenesController.removeListener(this);
    super.dispose();
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
            child: _loaded
                ? _buildSceneList()
                : const Center(child: CircularProgressIndicator()),
          );
          },),
    );
  }

  Widget _buildSceneList() {
    final sceneList = ScenesModel.scenes;

    if (sceneList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _scenesController.fetchScenes();
          HapticFeedback.mediumImpact();
        },
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 88.0),
                    child: Text(
                      'No scenes found',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
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
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _scenesController.fetchScenes();
        HapticFeedback.mediumImpact();
      },
      child: ListView.builder(
        itemCount: sceneList.length,
        itemBuilder: (context, index) {
          double dur = sceneList[index]['files'][0]['duration'] + .0;
          List<Performers> performers = sceneList[index]['performers']
              .map<Performers>((performer) => Performers(
            name: performer['name'],
            image: performer['image_path'],
            bio: "bio",
            id: int.parse(performer['id']),
          ))
              .toList();

          if (performers.isEmpty) {
            performers.add(const Performers(
              name: "Unknown",
              image: "",
              bio: "",
              id: -1,
            ));
          }

          return VideoCard(
            video: Video(
              thumbnail: sceneList[index]['paths']['screenshot'],
              title: sceneList[index]['title'],
              performers: [performers[0]],
              stream: sceneList[index]['paths']['stream'],
              stars: 5,
              studio: Studio(
                name: "TEST",
                image: "http://192.168.44.5:9999/studio/3/image?t=1641002641",
              ),
              date: sceneList[index]['date'] ?? "date",
              duration: dur,
              resolution: "resolution",
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void update(ObserverEvent event) {
    print("UPDATE SCENES EVENT: $event");
    switch (event){
      case ScenesEvents.fetchScenes:
        print("UPDATE Scenes: $ScenesModel.scenes");
        setState(() {
          _loaded = true;
        });
        break;

      case ScenesEvents.fetchScenesSuccess:
        print("UPDATE Scenes: $ScenesModel.scenes");
        setState(() {
          _loaded = true;
        });
        break;

      case ScenesEvents.fetchScenesFailed:
        if (ScenesModel.isLinkException) {
          // alert dialog and push to login page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(ScenesModel.errorMessage),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) => const LoginPage()),
                                (route) => false);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          });
        } else {
          // snackbar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            snackBarHelper(context, ScenesModel.errorMessage);
          });
        }
        break;

      default:
        print("default event");
        break;
    }
  }
}