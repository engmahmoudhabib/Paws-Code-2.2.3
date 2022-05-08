import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';

class VideoPlayerWidget extends StatefulWidget {
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
  }

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  setup() async {
    videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    try {
      videoPlayerController.dispose();
    } catch (e) {}
    try {
      chewieController.dispose();
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: setup(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return SpinKitFadingCube(
              color: AppFactory.getColor('primary', toString()),
              size: 30.0.w.toDouble(),
            );
          case ConnectionState.done:
            return Chewie(
              controller: chewieController,
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}
