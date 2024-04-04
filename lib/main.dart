import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/functions/storage.dart';
import 'package:stash_app_mobile/screens/home.dart';
import 'package:stash_app_mobile/screens/login.dart';
import 'package:stash_app_mobile/screens/settings.dart';
import 'package:stash_app_mobile/screens/performers.dart';
import 'package:stash_app_mobile/screens/scenes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stash_app_mobile/widgets/video_card_widget.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

String graphqlUri = "";
final selectedVideoProvider = StateProvider<Video?>((ref) => null);

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized(); // Required
  await initHiveForFlutter();
  graphqlUri = (await readKey("url"))!;

  //runApp(const NavigationBarApp());
  runApp(const ProviderScope(
      child: MyApp()
  )
  );
}

// final HttpLink httpLink = HttpLink(
//   'http://192.168.44.5:9999/graphql',
// );

final HttpLink httpLink = HttpLink(
  '$graphqlUri/graphql',
);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: httpLink,
    // The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(store: HiveStore()),
  ),
);

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
          client: client,
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
  int currentPageIndex = 0;
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
    _pageController = PageController(initialPage: currentPageIndex, keepPage: true);
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
    const ScenesPage(),
    const HomePage(),
    const PerformersPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            // calculate the difference between the current page and the new page
            int calc = currentPageIndex - index;
            if (calc == 1 || calc == -1) {
              _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
            } else {
              _pageController.jumpToPage(index);
            }
            currentPageIndex = index;
            //HapticFeedback.mediumImpact();

            // if key url emtpy, push over to login page, no back button
            _checkLogin();

          });
        },
        //indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.play_arrow),
            icon: Icon(Icons.play_arrow_outlined),
            label: 'Scenes',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Messages',
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (int index) {
          setState(() {
            currentPageIndex = index;
            HapticFeedback.lightImpact();
          });
        },
        //physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
      ),
    );
  }
}
