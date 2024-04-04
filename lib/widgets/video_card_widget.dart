import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    const bool fitThumbnail = false;

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
                child: CachedNetworkImage(
                  imageUrl: video.thumbnail,
                  placeholder: (context, url) => const Center(
                   child: CircularProgressIndicator(),
                  ),
                  height: 220.0,
                  width: double.infinity,
                  fit: fitThumbnail ? BoxFit.scaleDown : BoxFit.cover,
                  errorWidget: (context, url, error) {
                    // error icon with text center overlay gray background min height
                    return Container(
                      height: 220.0,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]: Colors.grey[200],
                      child:  Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.error, size: 40.0,
                              color: Colors.red,),
                            ),
                            const Text('Error loading thumbnail'),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(error.toString(),
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ),
                    );

                  },
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
                    color: const Color.fromRGBO(100, 100, 100, 100),
                    child: SvgPicture.network(
                      video.studio.image,
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
                    foregroundImage: (video.performers[0].image != "") ?
                    Image(image: CachedNetworkImageProvider(
                      video.performers[0].image,
                      //fit: BoxFit.cover,
                    )).image :
                    const AssetImage("assets/images/default-avatar.jpg"),
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
