import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:stash_app_mobile/Model/state.dart';
import 'package:stash_app_mobile/View/screens/performers.dart';
import 'package:stash_app_mobile/View/screens/studios.dart';

import '../../main.dart';
import '../widgets/video_card_widget.dart';

import 'package:media_kit/media_kit.dart';// as media_kit;
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {

  bool loaded = false;

  ScrollController? _scrollController;
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = media_kit_video.VideoController(player);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final stream = ref.read(VideoState.selectedVideoProvider)?.stream;
    player.open(Media(stream!));

  }

  @override
  void dispose() {
    _scrollController?.dispose();
    player.dispose();
    loaded = false;
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
        body:
            Consumer(builder: (context, watch, _) {
              final selectedVideo = watch.watch(VideoState.selectedVideoProvider);
              //print(watch.watch(miniPlayerControllerProvider).value?.height.toString());

              return
                  SafeArea(
                    child: Column(
                      children: [
                        Stack(
                          children: [media_kit_video.Video(controller: controller,
                            height: 220,),

                        IconButton(
                          iconSize: 30.0,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onPressed: () => watch
                              .read(VideoState.miniPlayerControllerProvider.notifier)
                              .state
                              .animateToHeight(state: PanelState.MIN),
                        ),],
                        ),
                        Text("Title: ${selectedVideo!.title}"),
                      ],
                    ),
                  );
            }),


        // body: Container(
        //   color: Theme.of(context).scaffoldBackgroundColor,
        //   child: CustomScrollView(
        //     controller: _scrollController,
        //     shrinkWrap: true,
        //     slivers: [
        //       SliverToBoxAdapter(
        //         child: Consumer(
        //           builder: (context, watch, _) {
        //             final selectedVideo = watch.watch(selectedVideoProvider);
        //             return SafeArea(
        //               child: Column(
        //                 children: [
        //                   Stack(
        //                     children: [
        //                       Image.network(
        //                         selectedVideo!.thumbnail,
        //                         height: 220.0,
        //                         width: double.infinity,
        //                         fit: BoxFit.cover,
        //                       ),
        //                       IconButton(
        //                         iconSize: 30.0,
        //                         icon: const Icon(Icons.keyboard_arrow_down),
        //                         onPressed: () => watch
        //                             .read(miniPlayerControllerProvider.notifier)
        //                             .state
        //                             .animateToHeight(state: PanelState.MIN),
        //                       ),
        //                     ],
        //                   ),
        //                   const LinearProgressIndicator(
        //                     value: 0.4,
        //                     valueColor: AlwaysStoppedAnimation<Color>(
        //                       Colors.red,
        //                     ),
        //                   ),
        //                   //VideoInfo(video: selectedVideo),
        //                 ],
        //               ),
        //             );
        //           },
        //         ),
        //       ),
        //       // SliverList(
        //       //   delegate: SliverChildBuilderDelegate(
        //       //         (context, index) {
        //       //       //final video = suggestedVideos[index];
        //       //       return const VideoCard(
        //       //         video: Video(
        //       //           title: "title",
        //       //           thumbnail: "thumbnail",
        //       //           studio: Studio(
        //       //             name: "name", image: 'image',
        //       //           ),
        //       //           date: "date",
        //       //           duration: 10.0,
        //       //           resolution: "resolution", performers: [
        //       //           Performers(
        //       //             name: "name",
        //       //             image: "image", bio: 'bio',
        //       //           ),
        //       //         ], stars: 5,
        //       //         )
        //       //         //hasPadding: true,
        //       //         // onTap: () => _scrollController!.animateTo(
        //       //         //   0,
        //       //         //   duration: const Duration(milliseconds: 200),
        //       //         //   curve: Curves.easeIn,
        //       //         // ),
        //       //       );
        //       //     },
        //       //     childCount: 3//suggestedVideos.length,
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}