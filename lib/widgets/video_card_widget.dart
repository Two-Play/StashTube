import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stash_app_mobile/screens/performers.dart';
import 'package:stash_app_mobile/screens/studios.dart';

import '../screens/settings.dart';

class Video {
  final String thumbnail;
  final String title;
  final List<Performers> performers;
  final int stars;
  final Studio studio;
  final String date;
  final String duration;
  final String resolution;

  const Video({
    required this.thumbnail,
    required this.title,
    required this.performers,
    required this.stars,
    required this.studio,
    required this.date,
    required this.duration,
    required this.resolution,
  });


}

class VideoCard extends StatelessWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    const bool hasPadding = false;
    return GestureDetector(
      onTap: () {
        print("TAP");
      },
      child: Column(
        children: [
          Stack(
            children: [
              // Video Thumbnail
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: hasPadding ? 12.0 : 0,
                ),
                child: Image.network(
                  video.thumbnail,
                  height: 220.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Video Duration
              Positioned(
                bottom: 8.0,
                right: hasPadding ? 20.0 : 8.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: Colors.black,
                  child: Text(
                    video.duration,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              // Studio Logo
              Positioned(
                top: 8.0,
                left: hasPadding ? 20.0 : 8.0,
                child: GestureDetector(
                  onTap: () => print('Navigate to studio'),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    //color: Colors.black,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/default-avatar.jpg',
                      image: video.studio.image,
                      //height: 30.0,
                      width: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => print('Navigate to profile'),
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(video.performers[0].image),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 15.0),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${video.performers[0].name} • ${video.stars} views • ${/*timeago.format(video.timestamp)*/ video.date}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.more_vert, size: 20.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
