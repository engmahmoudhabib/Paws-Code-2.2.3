import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/models/api/AnimalDetailsModel.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/ImagePickerWidget.dart';
import 'package:flutter_app/ui/widget/gallery.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimalsDetailsScreen2 extends StatefulWidget {
  static const String PATH = '/animal-details';
  final VoidCallback? onBack;
  final String id;

  AnimalsDetailsScreen2(this.id, {this.onBack});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AnimalsDetailsScreen2State createState() => _AnimalsDetailsScreen2State();
}

class _AnimalsDetailsScreen2State
    extends BaseStatefulState<AnimalsDetailsScreen2> {
  ValueNotifier<bool> isDog = ValueNotifier(false);
  ValueNotifier<bool> isHybrid = ValueNotifier(false);
  ValueNotifier<List<Color>> colors = ValueNotifier([]);
  late List<dynamic> transferServices;
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  Map<String, dynamic> contacts = Map();
  Map<String, dynamic> location = Map();
  Map<String, dynamic> opening_hours = Map();
  List<dynamic> images = [];

  Map<String, dynamic> settings = Map();
  Map<String, dynamic> services = Map();

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => context
            .read(animalsDetailsProvider.notifier)
            .getDetails(widget.id));

    settings['is_mobile'] = false;

    super.initState();
   
  }

  @override
  void dispose() {
    colors.dispose();
    isDog.dispose();
    isHybrid.dispose();
    super.dispose();
  }

  getTarget() {
    return isDog.value ? 'الكلب' : 'القط';
  }

  Map<String, Color> statusColor = {
    'adoption': Colors.blue,
    'normal': Colors.orange,
    'sale': Colors.deepOrangeAccent,
    'marriage': Colors.green,
    'missing': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    //final arg = ModalRoute.of(context)!.settings.arguments as String;
    preBuild(context);
    return handledWidget(AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white),
        child: WillPopScope(
            onWillPop: () {
              if (widget.onBack != null) {
                widget.onBack!.call();
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Scaffold(
              backgroundColor: AppFactory.getColor('background', toString()),
              body: Stack(
                children: [
                  KeyboardVisibilityBuilder(
                      builder: (context, isKeyboardVisible) {
                    return !isKeyboardVisible ? RightLeftWidget() : Container();
                  }),
                  Consumer(
                    builder: (context, watch, child) {
                      final response = watch(animalsDetailsProvider);
                      return response.when(idle: () {
                        return Container();
                      }, loading: () {
                        return LoaderWidget();
                      }, data: (map) {
                        AnimalsDetails data = AnimalsDetails.fromJson(map);
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(bottom: 50),
                            child: Column(
                              children: [
                                buildBanner(data, context, animation: false),
                                Container(
                                  width: 327.w,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          data.data?.status?.id == 'normal'
                                              ? SizedBox()
                                              : Row(
                                                  children: [
                                                    Container(
                                                      width: 7.0.w,
                                                      height: 8.0.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        3.5.w,
                                                                        4.0.w)),
                                                        color: statusColor[data
                                                                .data
                                                                ?.status
                                                                ?.id] ??
                                                            Colors.green,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    TextResponsive(
                                                      data.data?.status?.desc ??
                                                          '',
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                        fontSize: AppFactory
                                                            .getFontSize(16.0,
                                                                toString()),
                                                        color: statusColor[data
                                                                .data
                                                                ?.status
                                                                ?.id] ??
                                                            Colors.green,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          data.data?.status?.id == 'sale' ||
                                                  data.data?.status?.id ==
                                                      'marriage'
                                              ? Flexible(
                                                    child: TextResponsive(
                                                      'السعر: ${data.data?.offer?.price?.formatted ?? ''}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'roboto',
                                                        color: const Color(
                                                            0xff3EC62C),
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  )
                                              : SizedBox()
                                        ],
                                      ),
                                      /*    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: TextResponsive(
                                              data.data?.name ?? '',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: const Color(0xff707070),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        ],
                                      ),
                                      */
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: buildKeyValue('',
                                                data.data?.offer?.desc ?? ''),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Container(
                                        width: 327.w,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue('الاسم:',
                                                      data.data?.name ?? ''),
                                                ),
                                                data.data?.properties
                                                            ?.isHybrid !=
                                                        null
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: buildKeyValue(
                                                            'النقاوة:',
                                                            (data.data?.properties
                                                                        ?.isHybrid ??
                                                                    false)
                                                                ? 'هجين'
                                                                : 'نقي'),
                                                      )
                                                    : SizedBox()
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                data.data?.species != null
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: buildKeyValue(
                                                            'الفصيلة الأولى :',
                                                            data.data?.species
                                                                    ?.name ??
                                                                ''),
                                                      )
                                                    : SizedBox(),
                                                data.data?.hybridSpecies != null
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: buildKeyValue(
                                                            'الفصيلة الثانية :',
                                                            data
                                                                    .data
                                                                    ?.hybridSpecies
                                                                    ?.name ??
                                                                ''),
                                                      )
                                                    : SizedBox()
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'العمر :',
                                                      data.data?.age
                                                              ?.friendly ??
                                                          '',
                                                      forceView: true),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'الجنس :',
                                                      data.data?.gender?.desc ??
                                                          ''),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                data.data?.properties
                                                            ?.isSterilized !=
                                                        null
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: buildKeyValue(
                                                            'القابلية للتكاثر :',
                                                            (data.data?.properties
                                                                        ?.isSterilized ??
                                                                    false)
                                                                ? 'معقم'
                                                                : 'طبيعي'),
                                                      )
                                                    : SizedBox(),
                                                Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'اللون :',
                                                      data.data?.color?.name ??
                                                          ''),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                data.data?.properties
                                                            ?.hairStyle !=
                                                        null
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: buildKeyValue(
                                                            'طول الشعر :',
                                                            data
                                                                    .data
                                                                    ?.properties
                                                                    ?.hairStyle
                                                                    ?.desc ??
                                                                ''),
                                                      )
                                                    : SizedBox(),
                                                Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'نمط توزيع لون الفرو :',
                                                      data.data?.colorPattern
                                                              ?.name ??
                                                          ''),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        width: 320.w,
                                        child: ExpandablePanel(
                                          theme: ExpandableThemeData(
                                              hasIcon: true,
                                              iconColor: AppFactory.getColor(
                                                  'primary', toString()),
                                              iconPadding: EdgeInsets.zero,
                                              bodyAlignment:
                                                  ExpandablePanelBodyAlignment
                                                      .center,
                                              headerAlignment:
                                                  ExpandablePanelHeaderAlignment
                                                      .center,
                                              iconPlacement:
                                                  ExpandablePanelIconPlacement
                                                      .right),
                                          header: Padding(
                                            padding: EdgeInsetsResponsive.only(
                                                left: 20, right: 20),
                                            child: TextResponsive(
                                              'قراءة المزيد',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: AppFactory.getColor(
                                                    'primary', toString()),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          collapsed: Container(),
                                          expanded: Column(
                                            children: [
                                              data.data?.fatherImage != null
                                                  ? Column(
                                                      children: [
                                                        buildSectionTitle(
                                                            AppFactory.getLabel(
                                                                'father_img',
                                                                'صورة الأب'),
                                                            top: 0,
                                                            right: 0,
                                                            left: 0),
                                                        buildImageWidget(data
                                                                .data
                                                                ?.fatherImage
                                                                ?.conversions
                                                                ?.large
                                                                ?.url ??
                                                            ''),
                                                      ],
                                                    )
                                                  : Container(),
                                              data.data?.motherImage != null
                                                  ? Column(
                                                      children: [
                                                        buildSectionTitle(
                                                            AppFactory.getLabel(
                                                                'mother_img',
                                                                'صورة الأم'),
                                                            top: 10.w,
                                                            right: 0,
                                                            left: 0),
                                                        buildImageWidget(data
                                                                .data
                                                                ?.motherImage
                                                                ?.conversions
                                                                ?.large
                                                                ?.url ??
                                                            ''),
                                                      ],
                                                    )
                                                  : Container(),
                                              data.data?.documents != null &&
                                                      (data.data?.documents
                                                                  ?.length ??
                                                              0) >
                                                          0
                                                  ? Column(
                                                      children: [
                                                        buildSectionTitle(
                                                            AppFactory.getLabel(
                                                                'doc_pdf',
                                                                'وثائق ( صور أو pdf )'),
                                                            right: 0,
                                                            left: 0),
                                                        DocumentsWidget(data
                                                                .data
                                                                ?.documents ??
                                                            [])
                                                      ],
                                                    )
                                                  : Container(),
                                              data.data?.extraDescription !=
                                                          null &&
                                                      (data.data?.extraDescription
                                                                  ?.length ??
                                                              0) >
                                                          0
                                                  ? Column(
                                                      children: [
                                                        buildSectionTitle(
                                                            AppFactory.getLabel(
                                                                'others_desc',
                                                                'تفاصيل أخرى'),
                                                            bottom: 0,
                                                            right: 0,
                                                            left: 0),
                                                        Html(
                                                            data: data.data
                                                                    ?.extraDescription ??
                                                                ''),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Container(
                                        height: 0.2.w,
                                        color: Color(0xff707070),
                                      ),
                                      buildSectionTitle(
                                          AppFactory.getLabel('publish_call',
                                              'الاتصال بالمعلن'),
                                          bottom: 0,
                                          right: 0,
                                          top: 10.w,
                                          left: 0),
                                      data.data!.breeder != null
                                          ? Column(
                                              children: [
                                                BreederWidget(
                                                    data.data!.breeder!),
                                                SizedBox(
                                                  height: 15.w,
                                                ),
                                                Container(
                                                  width: 300.w,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      IconBtnWidget(
                                                        icon: Assets.icons
                                                            .iconAwesomeRocketchat
                                                            .svg(
                                                          width: 29.w,
                                                          height: 25.w,
                                                        ),
                                                      ),
                                                      data.data!.breeder!
                                                                  .mobile !=
                                                              null
                                                          ? InkWell(
                                                              onTap: () {
                                                                launchCaller(data
                                                                        .data!
                                                                        .breeder
                                                                        ?.mobile
                                                                        .toString() ??
                                                                    '');
                                                              },
                                                              child:
                                                                  IconBtnWidget(
                                                                color: Colors
                                                                    .green,
                                                                icon: Assets
                                                                    .icons
                                                                    .iconIonicIosCall
                                                                    .svg(
                                                                        width: 29
                                                                            .w,
                                                                        color: Colors
                                                                            .green,
                                                                        height:
                                                                            25.w),
                                                              ),
                                                            )
                                                          : Container(),
                                                      (data.data?.breeder?.getWhatsapp() ??
                                                                      '')
                                                                  .length >
                                                              0
                                                          ? InkWell(
                                                              onTap: () {
                                                                launchWhatsApp(
                                                                    phone: (data
                                                                            .data
                                                                            ?.breeder
                                                                            ?.getWhatsapp() ??
                                                                        ''),
                                                                    message:
                                                                        'hi');
                                                              },
                                                              child:
                                                                  IconBtnWidget(
                                                                color: Colors
                                                                    .green,
                                                                icon: Assets
                                                                    .icons
                                                                    .iconSimpleWhatsapp
                                                                    .svg(
                                                                        color: Colors
                                                                            .green,
                                                                        width: 29
                                                                            .w,
                                                                        height:
                                                                            25.w),
                                                              ),
                                                            )
                                                          : Container(),
                                                      (data.data?.breeder?.getViber() ??
                                                                      '')
                                                                  .length >
                                                              0
                                                          ? InkWell(
                                                              onTap: () {
                                                                launchViber((data
                                                                        .data
                                                                        ?.breeder
                                                                        ?.getViber() ??
                                                                    ''));
                                                              },
                                                              child:
                                                                  IconBtnWidget(
                                                                color: Colors
                                                                    .deepPurple,
                                                                icon: Assets
                                                                    .icons
                                                                    .iconAwesomeViber
                                                                    .svg(
                                                                  width: 29.w,
                                                                  height: 25.w,
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 30.w,
                                      ),
                                      /* InkWell(
                                        onTap: () {
                                          if (GetStorage().hasData('token'))
                                            ;
                                          else
                                            goTo(LoginScreen.generatePath(),
                                                transition:
                                                    TransitionType.inFromTop);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0.w),
                                              topRight: Radius.circular(10.0.w),
                                            ),
                                            color: AppFactory.getColor(
                                                'orange', toString()),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x29000000),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: TextResponsive(
                                              'طلب شراء',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: const Color(0xffffffff),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          height: 62.w,
                                        ),
                                      ),*/
                                      SizedBox(
                                        height: 20.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }, error: (e) {
                        return Container();
                      });
                    },
                  ),
                ],
              ),
            ))));
  }
}

class BreederWidget extends StatelessWidget {
  final AnimalsDetailsDataBreeder data;

  BreederWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsetsResponsive.only(top: 15),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Assets.images.box1.image(),
            Positioned(
              right: 0.w,
              top: 12.w,
              child: Container(
                width: 73.w,
                height: 73.w,
                child: SizedBox.expand(
                  child: CircularProfileAvatar(
                    data.user?.avatar?.conversions?.large?.url ?? '',
                    backgroundColor: Colors.transparent,
                    borderWidth: 0,
                    radius: 1000.w,
                    placeHolder: (context, url) => ImageLoaderPlaceholder(),
                    borderColor: Colors.transparent,
                    elevation: 3.0,
                    foregroundColor: Colors.transparent,
                    cacheImage: true,
                    showInitialTextAbovePicture:
                        true, // setting it true will show initials text above profile picture, default false
                  ),
                ),
              ),
            ),
            Positioned.fill(
              right: 90.w,
              bottom: 15.w,
              left: 20.w,
              top: 9.w,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextResponsive(
                    data.user?.name?.full ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xff707070),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DocumentsWidget extends StatefulWidget {
  final List<AnimalsDetailsDataDocuments> documents;

  DocumentsWidget(this.documents);

  @override
  _DocumentWidgetState createState() => _DocumentWidgetState();
}

class _DocumentWidgetState extends BaseStatefulState<DocumentsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late CarouselControllerImpl _carouselController = CarouselControllerImpl();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsResponsive.only(left: 5, right: 5),
      padding:
          EdgeInsetsResponsive.only(top: 10, bottom: 10, left: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.w),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppFactory.getColor('gray_1', toString()).withOpacity(0.16),
            offset: Offset(0, 3.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _carouselController.nextPage();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 5.w, right: 10.w),
              child: Assets.icons.iconIonicIosArrowDropleftCircle.svg(
                  width: AppFactory.getDimensions(15, toString()).w,
                  color: index < (widget.documents.length - 1)
                      ? Colors.black
                      : Colors.black.withOpacity(0.3),
                  height: AppFactory.getDimensions(15, toString()).w),
            ),
          ),
          Expanded(
            child: CarouselSlider.builder(
                itemCount: widget.documents.length,
                carouselController: _carouselController,
                options: CarouselOptions(
                  viewportFraction: 0.32.w,
                  initialPage: 0,
                  height: 90.w,
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
                itemBuilder: (context, index, realIndex) => InkWell(
                      onTap: () {
                        if (widget.documents[index].url
                                ?.toLowerCase()
                                .endsWith('.pdf') ??
                            false) {
                          try {
                            launch(widget.documents[index].url ?? '');
                          } catch (e) {}
                        } else {
                          showDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              barrierDismissible: true,
                              useSafeArea: false,
                              builder: (_) => PhotoViewGalleryFragment([
                                    {'url': widget.documents[index].url ?? ''}
                                  ]));
                        }
                      },
                      child: buildDocumentType(
                          widget.documents[index].name ?? '',
                          widget.documents[index].type == 'pdf'
                              ? Assets.icons.file.svg()
                              : Assets.icons.image.svg()),
                    )),
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
      ),
    );
  }
}

class IconBtnWidget extends StatelessWidget {
  final Widget icon;
  final Color? color;

  const IconBtnWidget({Key? key, this.color, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0.w),
        border: Border.all(width: 1.0, color: color ?? const Color(0xff3876ba)),
      ),
      margin: EdgeInsetsResponsive.only(right: 5, left: 5),
      constraints: BoxConstraints(minWidth: 64.w, minHeight: 36.w),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [icon],
        ),
      ),
    );
  }
}

class ServicesSection extends StatefulWidget {
  final List<dynamic> data;

  ServicesSection(this.data);

  @override
  _ServicesSectionState createState() => _ServicesSectionState();
}

class _ServicesSectionState extends BaseStatefulState<ServicesSection> {
  @override
  void initState() {
    super.initState();
  }

  isServiceClicked() {
    int index = -1;
    for (var d in widget.data) {
      index++;
      if (d['selected'] && index <= 2) {
        return true;
      }
    }
    return false;
  }

  getSelected() {
    for (var d in widget.data) {
      if (d['selected']) {
        return d;
      }
    }
  }

  isService2RowClicked() {
    int index = -1;
    for (var d in widget.data) {
      index++;
      if (d['selected'] && index > 2) {
        return true;
      }
    }
    return false;
  }

  getSelectedService() {
    for (var d in widget.data) {
      if (d['selected']) {
        return d;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Wrap(
                runSpacing: isServiceClicked()
                    ? 180.h +
                        (getSelectedService()['id'] == 'veterinary_clinic'
                            ? (getSelected()['item_count'] *
                                (45 + getSelected()['item_count'] / 3).h)
                            : 0)
                    : 0,
                spacing: 0,
                children: widget.data
                    .map(
                      (e) => e['enable']
                          ? InkWell(
                              onTap: () {
                                widget.data.forEach((element) {
                                  element['selected'] = false;
                                });
                                e['selected'] = true;
                                setState(() {});
                              },
                              child: Container(
                                height: 109.w,
                                width: 102.w,
                                margin: EdgeInsetsResponsive.only(
                                    left: 5, right: 5),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Assets.images.boxC.image(
                                        height: 109.w,
                                        color: e['selected']
                                            ? AppFactory.getColor(
                                                'primary', toString())
                                            : null),
                                    Column(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        SizedBox(
                                          height: 20.w,
                                        ),
                                        Container(
                                          child: SvgPicture.asset(e['icon'],
                                              height: 21.w, width: 22.w),
                                        ),
                                        SizedBox(
                                          height: 25.w,
                                        ),
                                        TextResponsive(
                                          e['name'],
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: e['selected']
                                                ? Colors.white
                                                : AppFactory.getColor(
                                                    'primary', toString()),
                                            height: 0.47,
                                          ),
                                          textAlign: TextAlign.right,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                    )
                    .toList(),
              ),
              isServiceClicked()
                  ? Container(
                      margin: EdgeInsets.only(top: 90.w), child: buildContent())
                  : Container()
            ],
          ),
        ),
        isService2RowClicked() ? buildContent() : Container()
      ],
    );
  }

  var formKey = GlobalKey<FormState>();

  buildContent() {
    return Container(
      width: 300.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(AppFactory.getLabel('service_desc', 'وصف الخدمة'),
              left: 0, right: 0),
          TextResponsive(
            getSelectedService()['description'],
            style: TextStyle(
              fontSize: 17,
              color: const Color(0xff707070),
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            height: 10.h,
          ),
          getSelectedService() != null &&
                  getSelectedService()['id'] == 'veterinary_clinic'
              ? Column(
                  children: [
                    buildSectionTitle('الأطباء البيطريين'),
                    ListView.builder(
                        itemCount: getSelected()['item_count'],
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsetsResponsive.only(left: 20, right: 20),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(top: 10.w),
                              child: Row(
                                children: [
                                  Assets.icons.doctor.svg(
                                    width: 19.w,
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                    height: 24.w,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: TextResponsive(
                                      getSelected()['doctors'][index]['name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color(0xff707070),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ],
                )
              : Container(),
          SizedBox(
            height: 15.w,
          ),
        ],
      ),
    );
  }

  getDoctorName(int index) {
    try {
      return getSelectedService()['doctors'][index - 1];
    } catch (e) {}
    return null;
  }
}

class ImagesWidget extends StatefulWidget {
  final Function(List<dynamic>) onUpdateImages;

  ImagesWidget(this.onUpdateImages);

  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends BaseStatefulState<ImagesWidget> {
  List<dynamic> mainImages = [];
  List<dynamic> otherImages = [];

  @override
  void initState() {
    mainImages = [
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''}
    ];
    otherImages = [
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''}
    ];
    super.initState();
  }

  getImages() {
    List<dynamic> temp = [];
    mainImages.forEach((element) {
      if (element['id'] != null) {
        element['is_main'] = true;
        temp.add(element);
      }
    });
    otherImages.forEach((element) {
      if (element['id'] != null) {
        element['is_main'] = false;
        temp.add(element);
      }
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 309.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: mainImages
                  .map(
                    (e) => Container(
                      height: 113.0.w,
                      width: 144.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10.0.w),
                          ),
                          child: e['state'] != 1
                              ? ImagePickerWidget(
                                  url: e['url'],
                                  onResult: (files) {
                                    setState(() {
                                      e['state'] = 1;
                                    });
                                    files.forEach((file) async {
                                      apiBloc.doAction(
                                          param: BaseStatefulState
                                              .addServiceInfo(Map(), data: {
                                            'url': ATTACHMENTS_API,
                                            'method': 'post',
                                            'file':
                                                await getImageMultiPart(file),
                                          }),
                                          supportLoading: false,
                                          supportErrorMsg: false,
                                          onResponse: (json) {
                                            e['url'] = json['data']['url'];
                                            e['id'] = json['data']['id'];
                                            widget.onUpdateImages
                                                .call(getImages());
                                            setState(() {
                                              e['state'] = 2;
                                            });
                                          });
                                    });
                                  },
                                  emptyWidget: Center(
                                      child: Assets.icons.iconMaterialFileUpload
                                          .svg(width: 21.w, height: 26.w)),
                                )
                              : ImageLoaderPlaceholder()),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0.w),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppFactory.getColor('gray_1', toString())
                                .withOpacity(0.12),
                            offset: Offset(0, 2.0),
                            blurRadius: 12.0,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )),
        SizedBox(
          height: 25.h,
        ),
        Container(
            width: 309.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: otherImages
                  .map(
                    (e) => Container(
                      height: 113.0.w,
                      width: 100.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10.0.w),
                          ),
                          child: e['state'] != 1
                              ? ImagePickerWidget(
                                  url: e['url'],
                                  onResult: (files) {
                                    setState(() {
                                      e['state'] = 1;
                                    });
                                    files.forEach((file) async {
                                      apiBloc.doAction(
                                          param: BaseStatefulState
                                              .addServiceInfo(Map(), data: {
                                            'url': ATTACHMENTS_API,
                                            'method': 'post',
                                            'file':
                                                await getImageMultiPart(file),
                                          }),
                                          supportLoading: false,
                                          supportErrorMsg: false,
                                          onResponse: (json) {
                                            e['url'] = json['data']['url'];
                                            e['id'] = json['data']['id'];
                                            widget.onUpdateImages
                                                .call(getImages());
                                            setState(() {
                                              e['state'] = 2;
                                            });
                                          });
                                    });
                                  },
                                  emptyWidget: Center(
                                      child: Assets.icons.iconMaterialFileUpload
                                          .svg(width: 21.w, height: 26.w)),
                                )
                              : ImageLoaderPlaceholder()),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0.w),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppFactory.getColor('gray_1', toString())
                                .withOpacity(0.12),
                            offset: Offset(0, 2.0),
                            blurRadius: 12.0,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ))
      ],
    );
  }
}

class OtherMediaWidget extends StatefulWidget {
  @override
  _OtherMediaWidgetState createState() => _OtherMediaWidgetState();
}

class _OtherMediaWidgetState extends BaseStatefulState<OtherMediaWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSectionTitle('رفع فيديو'),
        Container(
          margin: EdgeInsetsResponsive.only(left: 5, right: 5),
          height: 113.0.w,
          width: 309.w,
          child: Stack(
            children: [
              Center(
                child: Assets.icons.iconMetroYoutubePlay
                    .svg(width: 35.w, height: 34.w),
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    AppFactory.getColor('gray_1', toString()).withOpacity(0.12),
                offset: Offset(0, 2.0),
                blurRadius: 14.0,
              ),
            ],
          ),
        ),
        buildSectionTitle('رفع صورة للأم'),
        Container(
          margin: EdgeInsetsResponsive.only(left: 5, right: 5),
          height: 113.0.w,
          width: 309.w,
          child: Stack(
            children: [],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    AppFactory.getColor('gray_1', toString()).withOpacity(0.12),
                offset: Offset(0, 2.0),
                blurRadius: 14.0,
              ),
            ],
          ),
        ),
        buildSectionTitle('رفع صورة للأب'),
        Container(
          margin: EdgeInsetsResponsive.only(left: 5, right: 5),
          height: 113.0.w,
          width: 309.w,
          child: Stack(
            children: [],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    AppFactory.getColor('gray_1', toString()).withOpacity(0.12),
                offset: Offset(0, 2.0),
                blurRadius: 14.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SwitchWidget extends StatefulWidget {
  bool selected;
  final Function(bool) onChanged;

  SwitchWidget(this.selected, this.onChanged);

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.selected = !widget.selected;
        });
        widget.onChanged.call(widget.selected);
      },
      child: Container(
        width: 38.w,
        height: 17.w,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 7.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.0),
                  color: widget.selected ? Color(0xfffeca2e) : Colors.grey,
                  border: Border.all(
                      width: 1.0,
                      color: widget.selected ? Color(0xfffeca2e) : Colors.grey),
                ),
              ),
            ),
            Align(
              alignment: !widget.selected
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 17.w,
                height: 17.w,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                  color: widget.selected ? Color(0xfffeca2e) : Colors.grey,
                  border:
                      Border.all(width: 1.0, color: const Color(0xffffffff)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsetsResponsive.only(top: 10),
            height: 158.w,
            width: 307.w,
            child: SizedBox.expand(
              child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0.w),
                  ),
                  child: Shimmer.fromColors(
                      baseColor: getBaseColor(),
                      highlightColor: getHighlightColor(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          color: Colors.white,
                        ),
                      ))),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0.w),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppFactory.getColor('gray_1', toString())
                      .withOpacity(0.12),
                  offset: Offset(0, 2.0),
                  blurRadius: 12.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: EdgeInsetsResponsive.only(top: 3),
            height: 20.w,
            width: 307.w,
            child: SizedBox.expand(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0.w),
                  ),
                  child: Shimmer.fromColors(
                      baseColor: getBaseColor(),
                      highlightColor: getHighlightColor(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ))),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0.w),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppFactory.getColor('gray_1', toString())
                      .withOpacity(0.12),
                  offset: Offset(0, 2.0),
                  blurRadius: 12.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Container(
                width: 60.w,
                height: 60.w,
                child: SizedBox.expand(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000.0.w),
                      ),
                      child: Shimmer.fromColors(
                          baseColor: getBaseColor(),
                          highlightColor: getHighlightColor(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ))),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
              ),
              SizedBox(
                width: 20.w,
              ),
              Container(
                margin: EdgeInsetsResponsive.only(top: 3),
                height: 15.w,
                width: 200.w,
                child: SizedBox.expand(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0.w),
                      ),
                      child: Shimmer.fromColors(
                          baseColor: getBaseColor(),
                          highlightColor: getHighlightColor(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ))),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0.w),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppFactory.getColor('gray_1', toString())
                          .withOpacity(0.12),
                      offset: Offset(0, 2.0),
                      blurRadius: 12.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Column(
            children: [1, 2, 3, 4]
                .map((e) => Container(
                      margin: EdgeInsetsResponsive.only(top: 15),
                      height: 5.w,
                      width: 300.w,
                      child: SizedBox.expand(
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0.w),
                            ),
                            child: Shimmer.fromColors(
                                baseColor: getBaseColor(),
                                highlightColor: getHighlightColor(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ))),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0.w),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppFactory.getColor('gray_1', toString())
                                .withOpacity(0.12),
                            offset: Offset(0, 2.0),
                            blurRadius: 12.0,
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: EdgeInsetsResponsive.only(top: 3),
            height: 158.w,
            width: 307.w,
            child: SizedBox.expand(
              child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0.w),
                  ),
                  child: Shimmer.fromColors(
                      baseColor: getBaseColor(),
                      highlightColor: getHighlightColor(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          color: Colors.white,
                        ),
                      ))),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0.w),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppFactory.getColor('gray_1', toString())
                      .withOpacity(0.12),
                  offset: Offset(0, 2.0),
                  blurRadius: 12.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
