import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:stash_app_mobile/Model/main_model.dart';
import 'package:stash_app_mobile/Model/state.dart';
import 'package:stash_app_mobile/util/observable.dart';
import 'package:stash_app_mobile/util/storage.dart';
import 'package:stash_app_mobile/View/screens/home.dart';
import 'package:stash_app_mobile/View/screens/login.dart';
import 'package:stash_app_mobile/View/screens/settings.dart';
import 'package:stash_app_mobile/View/screens/performers.dart';
import 'package:stash_app_mobile/View/screens/scenes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/View/screens/video_screen.dart';
import 'package:stash_app_mobile/View/widgets/video_card_widget.dart';
import 'package:theme_manager/theme_manager.dart';

import 'Controler/main_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await initHiveForFlutter();

  GraphQLState();

  //runApp(const NavigationBarApp());
  runApp(const ProviderScope(
      child: MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      /// WidgetsBinding.instance.window.platformBrightness is used because a
      /// Material BuildContext will not be available outside of the Material app
      defaultBrightnessPreference: BrightnessPreference.system,
      data: (Brightness brightness) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: brightness),
        brightness: brightness,
      ),
      themeChangeListener: (ThemeState state) {
        debugPrint('ThemeState: ${state.brightnessPreference}');
        // Could post updates to a state manager here.
      },
      themedBuilder: (BuildContext context, ThemeState state) {
        return GraphQLProvider(
          client: GraphQLState.client,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: state.brightnessPreference == BrightnessPreference.light ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: BrightnessPreference.light == state.brightnessPreference ? Theme.of(context).colorScheme.onInverseSurface : const Color.fromRGBO(10, 10, 20, 10),
            ),
              child: MaterialApp(
                title: 'Stash',
                theme: state.themeData,
                home: const NavigationExample(),
              ),
          ),
        );
      },
    );
  }
}



// class NavigationBarApp extends StatelessWidget {
//   const NavigationBarApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: const NavigationExample(),
//       title: "Stash",
//     );
//   }
// }


class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> implements Observer {
  final MainController _controller = MainController();
  
  late PageController _pageController;

  late WidgetRef _ref;

// init state
  @override
  void initState() {
    super.initState();
    _controller.addListener(this);
    _pageController = PageController(initialPage: MainModel.currentPageIndex, keepPage: true);
    _controller.checkLogin();
  }
  
  @override
  void dispose() {
    _controller.removeListener(this);
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const ScenesPage(),
    const PerformersPage(),
    const SettingsPage(),
  ];

  NavigationDestination barItemBuilder(String label, Icon icon, Icon selectedIcon) {
    return NavigationDestination(
      selectedIcon: selectedIcon,
      icon: icon,
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    const double playerMinHeight = 60.0;
    const bool blockPanelSlide = false;
    bool isMiniplayerOpened = false;

    return Scaffold(
      bottomNavigationBar: isMiniplayerOpened ? null : NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _controller.barTapManagement(index);
          });
        },
        //indicatorColor: Colors.amber,
        selectedIndex: MainModel.currentPageIndex,
        destinations: <Widget>[
          barItemBuilder("Home", const Icon(Icons.home_outlined), const Icon(Icons.home)),
          barItemBuilder("Scenes", const Icon(Icons.play_arrow_outlined), const Icon(Icons.play_arrow)),
          barItemBuilder("Performers", const Icon(Icons.person_outline), const Icon(Icons.person)),
          barItemBuilder("Settings", const Icon(Icons.settings_outlined), const Icon(Icons.settings)),
        ],
      ),
      body: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {

        _ref = ref;
        final selectedVideo = ref.watch(VideoState.selectedVideoProvider);
        final miniPlayerController = ref.watch(VideoState.miniPlayerControllerProvider);

        return Stack(
          children: <Widget>[PageView(
            onPageChanged: (int index) {
              setState(() {
                _controller.swipeManagement(index);
              });
            },
            physics: blockPanelSlide ? const NeverScrollableScrollPhysics() : null,
            controller: _pageController,
            children: _pages,
          ),
            Offstage(
              offstage: selectedVideo == null,
              child: Miniplayer(
                  controller: miniPlayerController,
                  minHeight: playerMinHeight,
                  maxHeight: MediaQuery.of(context).size.height,
                  builder: (height, percentage) {
                    if (selectedVideo == null) {
                      return const SizedBox.shrink();
                    }
                    if (height >= playerMinHeight + 10.0) {
                      // not working
                      isMiniplayerOpened = true;

                        return const VideoScreen();
                    }

                    return Container(
                      color: Theme.of(context).colorScheme.background,
                      height: height,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(/*8.0*/ 0.0),
                                child: Image.network(
                                    selectedVideo.thumbnail,
                                height: playerMinHeight - 4.0,
                                  width: 120.0,
                                  fit: BoxFit.cover,
                                )
                                // child: VideoCard(video: Video(
                                //   id: "1",
                                //   title: "Title",
                                //   thumbnail: "https://via.placeholder.com/150",
                                //   duration: 0,
                                //   views: 0,
                                //   createdAt: DateTime.now(),
                                //   updatedAt: DateTime.now(),
                                // )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          selectedVideo.title,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          selectedVideo.performers[0].name,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                                              fontWeight:
                                              FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  ref.read(VideoState.selectedVideoProvider.notifier).state = null;
                                },
                              ),
                            ],
                          ),
                          const LinearProgressIndicator(
                            value: 0.4,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ]
                      ),
                    );
                  }
              ),
            ),
          ],
        );
      },
      )
    );
  }

  @override
  void update(ObserverEvent event) {
    print("Event: ${event}");
    switch (event) {
      case MainEvents.initFinished:
        break;
        
      case MainEvents.jumpAnimation:
        _pageController.jumpToPage(MainModel.index);
        print("Jumping to page: ${MainModel.index}");
      break;

      case MainEvents.swipeAnimation:
        _pageController.animateToPage(MainModel.index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
        print("Swiping to page: ${MainModel.index}");

      break;

      case MainEvents.swiped:

        break;

      case MainEvents.pageChanged:
        _ref.read(VideoState.miniPlayerControllerProvider.notifier).state.animateToHeight(
            state: PanelState.MIN);
      break;

      case MainEvents.loginChecked:
        break;

      case MainEvents.loginSuccess:
        break;

      case MainEvents.loginFailed:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        break;

      default:
        break;
    }
  }
}
