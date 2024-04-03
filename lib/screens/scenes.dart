import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/screens/login.dart';

import 'package:stash_app_mobile/screens/settings.dart';
import 'package:stash_app_mobile/widgets/video_card_widget.dart';


class ScenesPage extends StatefulWidget {
  const ScenesPage({super.key});

  @override
  State<ScenesPage> createState() => _ScenesPageState();
}

class _ScenesPageState extends State<ScenesPage> with AutomaticKeepAliveClientMixin<ScenesPage>{

  final String scenesQuery = """
    query {
    sceneWall{
      title,
      paths {
      screenshot,
      stream,
      preview
      }
    }
  }
  """;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
      ),

      // scroll view vertical with placeholder images and text for loop
      // body: ListView.builder(
      //   itemCount: 20,
      //   itemBuilder: (context, index) {
      //     return InkWell(
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           CupertinoPageRoute(
      //             builder: (context) => const SettingsPage(),
      //           ),
      //         );
      //       },
      //       child: Card(
      //         child: Column(
      //           children: <Widget>[
      //             //Image.asset('assets/images/placeholder.jpg'),
      //             Image.network('https://picsum.photos/250?image=9'),
      //             Text('Placeholder'),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
      
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
                return VideoCard(thumbnail: sceneList[index]['paths']['screenshot'], title: sceneList[index]['title'], performers: [sceneList],);
              },
            );
        },
      ),
      
    );
  }
  @override
  bool get wantKeepAlive => true;

}
