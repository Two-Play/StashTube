import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:stash_app_mobile/Model/state.dart';
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

class _NavigationExampleState extends State<NavigationExample> {
  int _currentPageIndex = 0;
  late PageController _pageController;

  Future<void> _checkLogin() async {
    // if key url emtpy, go to login use readkey function
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('url') == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

// init state
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex, keepPage: true);
    _checkLogin();

// SharedPreferences.getInstance().then((prefs) {
//       if (prefs.getString('url') == null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//         );
//       }
//    });
  }

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const ScenesPage(),
    const PerformersPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    const double playerMinHeight = 60.0;
    const bool blockPanelSlide = false;
    bool isMiniplayerOpened = false;

    const NavigationDestination home = NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    );

    const NavigationDestination scenes = NavigationDestination(
      selectedIcon: Icon(Icons.play_arrow),
      icon: Icon(Icons.play_arrow_outlined),
      label: 'Scenes',
    );

    const NavigationDestination performers = NavigationDestination(
      selectedIcon: Icon(Icons.person),
      icon: Icon(Icons.person_outline),
      label: 'Performers',
    );

    const NavigationDestination settings = NavigationDestination(
      selectedIcon: Icon(Icons.settings),
      icon: Icon(Icons.settings_outlined),
      label: 'Settings',
    );

    return Scaffold(
      bottomNavigationBar: isMiniplayerOpened ? null : NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            // calculate the difference between the current page and the new page
            int calc = _currentPageIndex - index;
            if (calc == 1 || calc == -1) {
              _pageController.animateToPage(index, duration: const Duration(
                  milliseconds: 300), curve: Curves.ease);
            } else {
              _pageController.jumpToPage(index);
            }
            _currentPageIndex = index;
            //HapticFeedback.mediumImpact();

            // if key url empty, push over to login page, no back button
            _checkLogin();
          });
        },
        //indicatorColor: Colors.amber,
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          home,
          scenes,
          performers,
          settings,
        ],
      ),
      body: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {

        final selectedVideo = ref.watch(VideoState.selectedVideoProvider);
        final miniPlayerController = ref.watch(VideoState.miniPlayerControllerProvider);

        return Stack(
          children: <Widget>[PageView(
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
                ref.read(VideoState.miniPlayerControllerProvider.notifier).state.animateToHeight(
                    state: PanelState.MIN
                );
                HapticFeedback.lightImpact();
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

                        return VideoScreen();
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
}
