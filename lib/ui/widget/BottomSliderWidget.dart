import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';

class BottomSliderWidget extends StatefulWidget {
  BottomSliderWidget();

  @override
  _BottomSliderWidgetState createState() => _BottomSliderWidgetState();
}

class _BottomSliderWidgetState extends BaseStatefulState<BottomSliderWidget> {
  late List<dynamic> data;

  @override
  void initState() {
    data = [
      {
        'id': 'cats',
        'name': AppFactory.getLabel('cats', 'قطط'),
        'icon': Assets.icons.happy.path,
        'height': AppFactory.getDimensions(77, toString()).w
      },
      {
        'id': 'dogs',
        'name': AppFactory.getLabel('dogs', 'كلاب'),
        'icon': Assets.icons.pet.path,
        'height': AppFactory.getDimensions(77, toString()).w
      },
      {
        'id': 'carrier',
        'name': AppFactory.getLabel('carrier', 'تسوق'),
        'icon': Assets.icons.carrier.path,
        'height': AppFactory.getDimensions(60, toString()).w
      },
      {
        'id': 'services',
        'name': AppFactory.getLabel('services', 'خدمات'),
        'icon': Assets.icons.share.path,
        'height': AppFactory.getDimensions(60, toString()).w
      },
      {
        'id': 'document',
        'name': AppFactory.getLabel('document', 'معلومات'),
        'icon': Assets.icons.document.path,
        'height': AppFactory.getDimensions(60, toString()).w
      },
    ];
    _carouselController = CarouselControllerImpl();
    super.initState();
  }

  int index = 0;
  late CarouselControllerImpl _carouselController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /*Row(
      children: [
        InkWell(
          onTap: () {
            _carouselController.nextPage();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 5.w, right: 10.w),
            child: Assets.icons.iconIonicIosArrowDropleftCircle.svg(
                width: AppFactory.getDimensions(15, toString()).w,
                color: index < (data.length - 1)
                    ? Colors.black
                    : Colors.black.withOpacity(0.3),
                height: AppFactory.getDimensions(15, toString()).w),
          ),
        ),
        Expanded(
          child: CarouselSlider.builder(
            itemCount: data.length,
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 120.0.h,
              viewportFraction: 0.32.w,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  this.index = index;
                });
              },
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder: (context, index, realIndex) => buildItem(data[index]),
          ),
        ),
        InkWell(
          onTap: () {
            _carouselController.previousPage();
          },
          child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 5.w),
              child: RotatedBox(
                  quarterTurns: 2,
                  child: Assets.icons.iconIonicIosArrowDropleftCircle.svg(
                      width: AppFactory.getDimensions(15, toString()).w,
                      color: index > 0
                          ? Colors.black
                          : Colors.black.withOpacity(0.3),
                      height: AppFactory.getDimensions(15, toString()).w))),
        ),
      ],
    );*/
        Wrap(
      spacing: 10.w,
      children: data.map((e) => buildItem(e)).toList(),
    );
  }

  Widget buildItem(dynamic data) {
    return InkWell(
      onTap: () {
        if (data['id'] == 'document')
          goTo(ArticlesScreen.generatePath('4'),
              transition: TransitionType.inFromBottom);
        else if (data['id'] == 'services')
          goTo(ArticlesScreen.generatePath('2'),
              transition: TransitionType.inFromBottom);
        else if (data['id'] == 'carrier')
          goTo(
              ArticlesScreen.generatePath(
                '3',
              ),
              transition: TransitionType.inFromBottom);
        else if (data['id'] == 'cats') {
          GetStorage().write('filter-animal-id', 'cat');
          GetStorage().write('filter-animal-name', 'قط');

          goTo(ArticlesScreen.generatePath('0'),
              transition: TransitionType.inFromBottom);
        } else {
          GetStorage().write('filter-animal-id', 'dog');
          GetStorage().write('filter-animal-name', 'كلب');

          goTo(ArticlesScreen.generatePath('1'),
              transition: TransitionType.inFromBottom);
        }
      },
      child: Container(
        width: 150.0.w,
        height: 160.0.h,
        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(data['icon'],
                width: AppFactory.getDimensions(92, toString()).w,
                height: data['height']),
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                Expanded(
                  child: TextResponsive(
                    data['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFactory.getFontSize(18, toString()),
                      color: AppFactory.getColor('primary', toString()),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppFactory.getColor('gray_1', toString()).withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
