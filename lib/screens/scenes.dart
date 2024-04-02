import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stash_app_mobile/screens/settings.dart';

class ScenesPage extends StatelessWidget {
  const ScenesPage ({super.key});



  @override
  Widget build(BuildContext context) {

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
            MaterialPageRoute(
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
    );

  }
}
