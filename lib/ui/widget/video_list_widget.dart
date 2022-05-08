/*import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoListWidget extends StatefulWidget {
  final VideoListData? videoListData;

  const VideoListWidget({Key? key, this.videoListData}) : super(key: key);

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  VideoListData? get videoListData => widget.videoListData;
  BetterPlayerConfiguration? betterPlayerConfiguration;
  BetterPlayerListVideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    controller = BetterPlayerListVideoPlayerController();
    betterPlayerConfiguration = BetterPlayerConfiguration(autoPlay: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayerListVideoPlayer(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoListData!.videoUrl,
        bufferingConfiguration: BetterPlayerBufferingConfiguration(
            minBufferMs: 2000,
            maxBufferMs: 10000,
            bufferForPlaybackMs: 1000,
            bufferForPlaybackAfterRebufferMs: 2000),
      ),
      configuration: BetterPlayerConfiguration(
        autoPlay: false,
      ),
      key: Key(videoListData.hashCode.toString()),
      playFraction: 0.8,
      betterPlayerListVideoPlayerController: controller,
    );
  }
}

class VideoListData {
  final String videoTitle;
  final String videoUrl;
  Duration? lastPosition;
  bool? wasPlaying = false;

  VideoListData(this.videoTitle, this.videoUrl);
}*/
