import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/settings.dart';

class VideoCard extends StatelessWidget {
  final String thumbnail;
  final String title;
  final List<String> performers;
  final int stars;
  final String studio;
  final String date;
  final String duration;
  final String resolution;

  const VideoCard({super.key, required this.thumbnail, required this.title, required this.performers, required this.stars, required this.studio, required this.date, required this.duration, required this.resolution});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // create a new page for the scene with the image
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
            Image.network(thumbnail),
            Text(title),
          ],
        ),
      ),
    );
  }
}
