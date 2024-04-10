import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:stash_app_mobile/screens/performers.dart';
import 'package:stash_app_mobile/screens/studios.dart';

import '../main.dart';
import '../widgets/video_card_widget.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => context
      //     .read(miniPlayerControllerProvider)
      //     .state
      //     .animateToHeight(state: PanelState.MAX),
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: _scrollController,
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, watch, _) {
                    final selectedVideo = watch.watch(selectedVideoProvider);
                    return SafeArea(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                selectedVideo!.thumbnail,
                                height: 220.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                iconSize: 30.0,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: () => watch
                                    .read(miniPlayerControllerProvider.notifier)
                                    .state
                                    .animateToHeight(state: PanelState.MIN),
                              ),
                            ],
                          ),
                          const LinearProgressIndicator(
                            value: 0.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                          //VideoInfo(video: selectedVideo),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    //final video = suggestedVideos[index];
                    return const VideoCard(
                      video: Video(
                        title: "title",
                        thumbnail: "thumbnail",
                        studio: Studio(
                          name: "name", image: 'image',
                        ),
                        date: "date",
                        duration: 10.0,
                        resolution: "resolution", performers: [
                        Performers(
                          name: "name",
                          image: "image", bio: 'bio',
                        ),
                      ], stars: 5,
                      )
                      //hasPadding: true,
                      // onTap: () => _scrollController!.animateTo(
                      //   0,
                      //   duration: const Duration(milliseconds: 200),
                      //   curve: Curves.easeIn,
                      // ),
                    );
                  },
                  childCount: 3//suggestedVideos.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}