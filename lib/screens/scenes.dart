import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stash_app_mobile/screens/settings.dart';


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
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  //Image.asset('assets/images/placeholder.jpg'),
                  Image.network('https://picsum.photos/250?image=9'),
                  Text('Placeholder'),
                ],
              ),
            ),
          );
        },
      ),
      
  // get scene list and return card widgets
  //     body: Query(
  //       options: QueryOptions(
  //         document: gql(scenesQuery),
  //       ),
  //       builder: (result, {fetchMore, refetch}) {
  //         if (result.hasException) {
  //           return Text(result.exception.toString());
  //         }
  //
  //         if (result.isLoading) {
  //           return const Center(
  //           child: CircularProgressIndicator(),
  //           );
  //         }
  //
  //         final sceneList = result.data?['sceneWall'];
  //
  //           return ListView.builder(
  //             itemCount: sceneList.length,
  //             itemBuilder: (context, index) {
  //               return InkWell(
  //                 onTap: () {
  //                   // create a new page for the scene with the image
  //                   Navigator.push(
  //                     context,
  //                     CupertinoPageRoute(
  //                       builder: (context) => Scaffold(
  //                         appBar: AppBar(
  //                           title: Text(sceneList[index]['title']),
  //                           centerTitle: true,
  //                         ),
  //                         body: Center(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.stretch,
  //                             children: <Widget>[
  //                               Padding(
  //                                 padding: const EdgeInsets.symmetric(vertical: 30),
  //                                 child: Image.network(sceneList[index]['paths']['screenshot']),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 child: Card(
  //                   child: Column(
  //                     children: <Widget>[
  //                       //Image.asset('assets/images/placeholder.jpg'),
  //                       Image.network(sceneList[index]['paths']['screenshot']),
  //                       Text(sceneList[index]['title']),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //       },
  //     ),
      
    );
  }
  @override
  bool get wantKeepAlive => true;

}
