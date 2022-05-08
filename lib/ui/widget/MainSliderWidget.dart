import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/models/api/BascisResponse.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_app/ui/widget/VideoPayerWidget.dart';
import 'package:flutter_app/ui/widget/video_items.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'ImagePickerWidget.dart';
import 'gallery.dart';

class MainSliderWidget extends StatefulWidget {
  final bool supportRound;
  late List<dynamic>? data;
  final bool supportAuto;

  MainSliderWidget(
      {this.supportRound = false, this.data, this.supportAuto = true});

  @override
  _MainSliderWidgetState createState() => _MainSliderWidgetState();
}

class _MainSliderWidgetState extends BaseStatefulState<MainSliderWidget> {
  getData() {
    BasicResponse response =
        BasicResponse.fromMap(GetStorage().read('basics') ?? {});
    widget.data = [];
    widget.data?.clear();
    for (var v in (response.ads ?? [])) {
      widget.data?.add(v.toJson());
    }
  }

  @override
  void initState() {
    if (widget.data == null) getData();

    //   {
    //  'id': 'cats',
    //   'icon': Assets.images.test1.path,
    // },

    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) getData();

    return Column(
      children: [
        Container(
          margin: EdgeInsetsResponsive.only(top: 20, bottom: 10),
          child: CarouselSlider.builder(
            itemCount: widget.data?.length ?? 0,
            options: CarouselOptions(
              height: 158.w,
              viewportFraction: 1.w,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  this.index = index;
                });
              },
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: widget.supportAuto,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder: (context, index, realIndex) =>
                buildItem(widget.data![index], widget.supportRound),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: (widget.data ?? [])
              .map((e) => e['id'] == widget.data![this.index]['id']
                  ? Container(
                      width: 20.0.w,
                      margin: EdgeInsetsResponsive.only(left: 2, right: 2),
                      height: 5.0.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppFactory.getColor('orange', toString()),
                      ),
                    )
                  : Container(
                      width: 5.0.w,
                      height: 5.0.w,
                      margin: EdgeInsetsResponsive.only(left: 2, right: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppFactory.getColor('orange', toString())
                            .withOpacity(0.4),
                      ),
                    ))
              .toList(),
        ),
        SizedBox(
          height: 10.h,
        ),
        widget.data != null &&
                widget.data!.length > 0 &&
                widget.data?[this.index]?['text'] != null
            ? TextResponsive(
                widget.data![this.index]['text'],
                style: TextStyle(
                  fontSize: 17,
                  color: const Color(0xff707070),
                ),
                textAlign: TextAlign.start,
              )
            : Container()
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final key = GlobalKey();

  Widget buildItem(dynamic data, bool supportRound) {
    return Container(
      height: 148.w,
      width: 300.w,
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(supportRound ? 20.0.w : 0),
        ),
      ),
      child: data['url'] != null
          ? data['type'] != null && data['type'] == 'video'
              ? VideoViewer(
                  data['url'],
                  key: key,
                )
              : InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        barrierDismissible: true,
                        useSafeArea: false,
                        builder: (_) => PhotoViewGalleryFragment([
                              {'url': data['url']}
                            ]));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(supportRound ? 20.0.w : 0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: data['url'],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => ImageLoaderPlaceholder(),
                        errorWidget: (context, url, error) =>
                            ImageLoaderErrorWidget(),
                      )),
                )
          : InkWell(
              onTap: () async {
                if (SliderAds.fromJson(data).target == 'website') {
                  try {
                    await launch(SliderAds.fromJson(data).targetUrl ?? '');
                  } catch (e) {}
                } else if (SliderAds.fromJson(data).target ==
                    'service_center') {
                  goTo(
                      ArticlesScreen.generatePath('2',
                          initialId: SliderAds.fromJson(data).targetId),
                      transition: TransitionType.inFromBottom);
                } else if (SliderAds.fromJson(data).target == 'product') {
                  goTo(
                      ArticlesScreen.generatePath('3',
                          initialId: SliderAds.fromJson(data).targetId),
                      transition: TransitionType.inFromBottom);
                }
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(supportRound ? 20.0.w : 0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: SliderAds.fromJson(data)
                            .image
                            ?.conversions
                            ?.large
                            ?.url ??
                        '',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => ImageLoaderPlaceholder(),
                    errorWidget: (context, url, error) =>
                        ImageLoaderErrorWidget(),
                  )),
            ),
    );
  }
}
