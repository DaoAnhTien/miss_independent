import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoItemView extends StatefulWidget {
  const VideoItemView({super.key, this.url});
  final String? url;

  @override
  State<VideoItemView> createState() => _VideoItemViewState();
}

class _VideoItemViewState extends State<VideoItemView> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url ?? ""),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: flickManager.flickVideoManager
                        ?.videoPlayerController?.value.aspectRatio ??
                    1.0,
                child: FlickVideoPlayer(flickManager: flickManager),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
