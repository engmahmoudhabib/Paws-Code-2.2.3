import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/tools/FlickVideoPlayer.dart' as Flick;
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/widget/video_items.dart';
import 'package:flutter_app/ui/widget/video_list_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ImagePickerWidget extends StatefulWidget {
  final Widget? emptyWidget;
  final Function(List<File>)? onResult;
  String? url;
  final dynamic data;
  final bool isVideo;
  final Function(dynamic)? onRemove;
  final bool supportCropper;

  ImagePickerWidget(
      {Key? key,
      this.supportCropper = false,
      this.isVideo = false,
      this.emptyWidget,
      this.url,
      this.onResult,
      this.data,
      this.onRemove})
      : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<PickedFile>? _imageFileList;

  @override
  void initState() {
    isVideo = widget.isVideo;

    super.initState();
  }

  set _imageFile(PickedFile? value) {
    _imageFileList = value == null ? null : [value];
    widget.onResult!.call(_imageFileList!.map((e) => File(e.path)).toList());
  }

  dynamic _pickImageError;
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(PickedFile? file, {String? url}) async {
    if ((file != null || url != null) && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (url != null) {
        controller = VideoPlayerController.network(url);
      } else if (kIsWeb) {
        controller = VideoPlayerController.network(file?.path ?? '');
      } else {
        controller = VideoPlayerController.file(File(file?.path ?? ''));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      final double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(false);
      await controller.play();
      if (url == null) setState(() {});
    }
  }

  File? videoFile;

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final PickedFile? file = await _picker.getVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      widget.onResult!.call([File(file!.path)]);
      videoFile = File(file.path);
      await _playVideo(file);
    } else if (isMultiImage) {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final pickedFileList = await _picker.getMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    } else {
      try {
        var pickedFile = await _picker.getImage(
          source: source,
          imageQuality: 60,
        );
        File? croppedFile;
        if (widget.supportCropper && pickedFile != null) {
          croppedFile = await ImageCropper.cropImage(
              sourcePath: pickedFile.path,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
              androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Paws',
                  toolbarColor: AppFactory.getColor('primary', toString()),
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.square,
                  lockAspectRatio: true),
              iosUiSettings: IOSUiSettings(
                minimumAspectRatio: 1.0,
              ));
        }
        setState(() {
          if (croppedFile != null) pickedFile = PickedFile(croppedFile.path);
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return widget.emptyWidget ??
          TextResponsive(
            'You have not yet picked a video',
            textAlign: TextAlign.center,
          );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
                height: _controller!.value.size.height,
                width: _controller!.value.size.width,
                child: VideoPlayer(_controller!))),
      ),
    );
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null && _imageFileList!.length > 0) {
      return Container(
        child: kIsWeb
            ? Image.network(
                _imageFileList![0].path,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(_imageFileList![0].path),
                fit: BoxFit.cover,
              ),
      );
    } else if (_pickImageError != null) {
      return TextResponsive(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return widget.emptyWidget ??
          const TextResponsive(
            'You have not yet picked an image.',
            textAlign: TextAlign.center,
          );
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (context, index) {
              // Why network for web?
              // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(
                        _imageFileList![index].path,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_imageFileList![index].path),
                        fit: BoxFit.cover,
                      ),
              );
            },
            itemCount: _imageFileList!.length,
          ),
          label: 'image_picker_example_picked_images');
    } else if (_pickImageError != null) {
      return TextResponsive(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return widget.emptyWidget ??
          const TextResponsive(
            'You have not yet picked an image.',
            textAlign: TextAlign.center,
          );
    }
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImage();
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                barrierColor: Colors.transparent,
                barrierDismissible: true,
                useSafeArea: false,
                builder: (_) => AccountTypeDialog(
                      onSelected: (item) {},
                      data: [
                        {
                          'selected': true,
                          'title': AppFactory.getLabel('camera', 'كاميرا'),
                          'id': 'camera',
                          'hint':
                              '(التقط ${widget.isVideo ? 'فيديو' : 'صورة'} مباشرة)'
                        },
                        {
                          'selected': false,
                          'title': AppFactory.getLabel('gallery', 'معرض'),
                          'id': 'gallery',
                          'hint':
                              '(اختر ${widget.isVideo ? 'فيديو' : 'صورة'} من معرض الجهاز)'
                        },
                      ],
                    )).then((value) {
              if (value == null) return;

              if (value['id'] == 'camera') {
                if (widget.isVideo)
                  takeVideo();
                else
                  takePhoto();
              } else {
                if (widget.isVideo)
                  videoGallery();
                else
                  imageGallery();
              }
            });
          },
          child: widget.url != null && (widget.url?.length ?? 0) > 0
              ? !widget.isVideo
                  ? CachedNetworkImage(
                      imageUrl: widget.url ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.contain),
                        ),
                      ),
                      placeholder: (context, url) => ImageLoaderPlaceholder(),
                      errorWidget: (context, url, error) =>
                          ImageLoaderErrorWidget(),
                    )
                  : VideoViewer(
                      widget.url ?? '',
                      key: key,
                    )
              : Center(
                  child:
                      !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                          ? FutureBuilder<void>(
                              future: retrieveLostData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return widget.emptyWidget ??
                                        const TextResponsive(
                                          'You have not yet picked an image.',
                                          textAlign: TextAlign.center,
                                        );
                                  case ConnectionState.done:
                                    return _handlePreview();
                                  default:
                                    if (snapshot.hasError) {
                                      return TextResponsive(
                                        'Pick image/video error: ${snapshot.error}}',
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return widget.emptyWidget ??
                                          const TextResponsive(
                                            'You have not yet picked an image.',
                                            textAlign: TextAlign.center,
                                          );
                                    }
                                }
                              },
                            )
                          : _handlePreview(),
                ),
        ),
        getUrl().length > 0 ||
                videoFile != null ||
                (_imageFileList != null && _imageFileList!.length > 0)
            ? Positioned(
                right: 2,
                top: 2,
                child: InkWell(
                  onTap: () {
                    try {
                      widget.data['url'] = '';
                    } catch (e) {}
                    videoFile = null;
                    widget.url = '';
                    _imageFileList?.clear();
                    //  widget.data.remove('id') ;
                    try {
                      _disposeVideoController();
                    } catch (e) {}
                    if (widget.onRemove != null) {
                      widget.onRemove!.call(widget.data);
                    }
                    setState(() {});
                  },
                  child: SvgPicture.string(
                    '<svg viewBox="19.0 111.0 20.1 20.1" ><path transform="translate(15.63, 107.63)" d="M 13.4375 3.375 C 7.878936290740967 3.375 3.375 7.878936290740967 3.375 13.4375 C 3.375 18.99606513977051 7.878936290740967 23.5 13.4375 23.5 C 18.99606513977051 23.5 23.5 18.99606513977051 23.5 13.4375 C 23.5 7.878935813903809 18.99606513977051 3.375 13.4375 3.375 Z M 15.98698997497559 17.08031845092773 L 13.4375 14.53082847595215 L 10.88801002502441 17.08031845092773 C 10.58806991577148 17.38025856018066 10.0946216583252 17.38025856018066 9.794681549072266 17.08031845092773 C 9.644710540771484 16.93034934997559 9.567306518554688 16.73200035095215 9.567306518554688 16.53365325927734 C 9.567306518554688 16.33530616760254 9.644710540771484 16.13695907592773 9.794681549072266 15.98698997497559 L 12.34416961669922 13.4375 L 9.794679641723633 10.88801002502441 C 9.644710540771484 10.73804092407227 9.567306518554688 10.53969192504883 9.567306518554688 10.34134674072266 C 9.567306518554688 10.14299774169922 9.644710540771484 9.944650650024414 9.794679641723633 9.794681549072266 C 10.09461975097656 9.494741439819336 10.58806991577148 9.494741439819336 10.88801002502441 9.794681549072266 L 13.43749809265137 12.34417152404785 L 15.98698806762695 9.794681549072266 C 16.28692817687988 9.494741439819336 16.7803783416748 9.494741439819336 17.0803165435791 9.794681549072266 C 17.38025665283203 10.0946216583252 17.38025665283203 10.58806991577148 17.0803165435791 10.88801193237305 L 14.53082847595215 13.4375 L 17.08031845092773 15.98698997497559 C 17.38025856018066 16.28693008422852 17.38025856018066 16.7803783416748 17.08031845092773 17.08031845092773 C 16.7803783416748 17.38509559631348 16.28693008422852 17.38509559631348 15.98698997497559 17.08031845092773 Z" fill="#feca2e" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                    width: 25.w,
                    color: Colors.red,
                    height: 25.w,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  String getUrl() {
    return widget.data?['url'] ?? widget.url ?? '';
  }

  imageGallery() {
    isVideo = false;
    _onImageButtonPressed(ImageSource.gallery, context: context);
  }

  multipleImageGallery() {
    isVideo = false;
    _onImageButtonPressed(
      ImageSource.gallery,
      context: context,
      isMultiImage: true,
    );
  }

  takePhoto() {
    isVideo = false;
    _onImageButtonPressed(ImageSource.camera, context: context);
  }

  takeVideo() {
    isVideo = true;
    _onImageButtonPressed(ImageSource.camera);
  }

  videoGallery() {
    isVideo = true;
    _onImageButtonPressed(ImageSource.gallery);
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxWidth if desired"),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxHeight if desired"),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: "Enter quality if desired"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

/*
class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}
*/

class VideoViewer extends StatefulWidget {
  final String url;

  VideoViewer(this.url, {Key? key}) : super(key: key);

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  FlickManager? flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url),
    );
    super.initState();
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return VisibilityDetector(
        key: ObjectKey(flickManager),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && this.mounted) {
            flickManager?.flickControlManager?.autoPause();
          } else if (visibility.visibleFraction == 1) {
            flickManager?.flickControlManager?.autoResume();
          }
        },
        child: FlickVideoPlayer(
          flickManager: flickManager!,

          /* preferredDeviceOrientationFullscreen: [
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],*/
          flickVideoWithControls: FlickVideoWithControls(
            videoFit: BoxFit.contain,
            controls: FlickPortraitControls(),
          ),
          flickVideoWithControlsFullscreen: FlickVideoWithControls(
            videoFit: BoxFit.scaleDown,
            controls: FlickPortraitControls(),
          ),
        ),
      );
    } catch (e) {
      return Container();
    }
  }
/* @override
  Widget build(BuildContext context) {
    /*return BetterPlayer.network(
      widget.url,
      betterPlayerConfiguration:
          BetterPlayerConfiguration(aspectRatio: 16 / 9, autoDispose: true),
    );*/
    /* return VideoListWidget(
      videoListData: VideoListData('', widget.url),
    );*/
  }*/
}

class DataManager {
  DataManager({required this.flickManager, required this.urls});

  int currentPlaying = 0;
  final FlickManager flickManager;
  final List<String> urls;

  late Timer videoChangeTimer;

  String getNextVideo() {
    currentPlaying++;
    return urls[currentPlaying];
  }

  bool hasNextVideo() {
    return currentPlaying != urls.length - 1;
  }

  bool hasPreviousVideo() {
    return currentPlaying != 0;
  }

  skipToNextVideo([Duration? duration]) {
    if (hasNextVideo()) {
      flickManager.handleChangeVideo(
          VideoPlayerController.network(urls[currentPlaying + 1]),
          videoChangeDuration: duration);

      currentPlaying++;
    }
  }

  skipToPreviousVideo() {
    if (hasPreviousVideo()) {
      currentPlaying--;
      flickManager.handleChangeVideo(
          VideoPlayerController.network(urls[currentPlaying]));
    }
  }

  cancelVideoAutoPlayTimer({required bool playNext}) {
    if (playNext != true) {
      currentPlaying--;
    }

    flickManager.flickVideoManager
        ?.cancelVideoAutoPlayTimer(playNext: playNext);
  }
}
