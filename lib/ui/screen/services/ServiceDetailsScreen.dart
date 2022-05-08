import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/Reviews.dart';
import 'package:flutter_app/models/api/ServiceDetails.dart';
import 'package:flutter_app/providers/ReviewsProvider.dart';
import 'package:flutter_app/providers/ServicesProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/AddRatingDialog.dart';
import 'package:flutter_app/ui/dialogsss/ChangeStatusDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MainScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyAccountScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/products/ProductDetailsScreen.dart';
import 'package:flutter_app/ui/screen/services/WorkingHoursScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/DogCatSelectWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/HairTypeWidget.dart';
import 'package:flutter_app/ui/widget/ImagePickerWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsLargeWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as ColorPicker;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

import 'FullScreenMapScreen.dart';
import 'MapSample.dart';

class ServiceDetailsScreen extends StatefulWidget {
  static const String PATH = '/service-details';
  final VoidCallback? onBack;
  final String id;

  ServiceDetailsScreen(this.id, {this.onBack});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState
    extends BaseStatefulState<ServiceDetailsScreen> {
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
  late List<dynamic> days;
  Map<String, dynamic> services = Map();
  late List<dynamic> servicesData;

  getLocalService(String id) {
    for (var temp in servicesData) {
      if (temp['id'] == id) return temp;
    }
  }

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => context
            .read(servicesDetailsProvider.notifier)
            .getDetails(widget.id));

    servicesData = [
      {
        'id': 'veterinary_clinic',
        'margin-left': 42.w,
        'selected': false,
        'enable': false,
        'description': '',
        'item_count': 1,
        'doctors': [],
        'name': AppFactory.getLabel('veterinary_clinic', 'بيطرة'),
        'icon': Assets.icons.clinic.path
      },
      {
        'id': 'hotel',
        'margin-left': 48.w,
        'selected': false,
        'description': '',
        'enable': false,
        'name': AppFactory.getLabel('hotels', 'فندقة'),
        'icon': Assets.icons.hote546.path
      },
      {
        'id': 'shaving',
        'margin-left': 48.w,
        'description': '',
        'selected': false,
        'enable': false,
        'name': AppFactory.getLabel('shaving', 'حلاقة'),
        'icon': Assets.icons.dog5443.path
      },
      {
        'id': 'shower',
        'selected': false,
        'enable': false,
        'description': '',
        'margin-left': 48.w,
        'name': AppFactory.getLabel('bathroom', 'حمام'),
        'icon': Assets.icons.dog43445.path
      },
      {
        'id': 'walk',
        'margin-left': 45.w,
        'selected': false,
        'description': '',
        'enable': false,
        'name': AppFactory.getLabel('hike_and_walk', 'تنزه'),
        'icon': Assets.icons.blind.path
      },
      {
        'id': 'training',
        'margin-left': 48.w,
        'enable': false,
        'selected': false,
        'description': '',
        'name': AppFactory.getLabel('training', 'تدريب'),
        'icon': Assets.icons.outlineA.path
      },
      {
        'id': 'relief',
        'margin-left': 48.w,
        'enable': false,
        'selected': false,
        'description': '',
        'name': AppFactory.getLabel('relief', 'إغاثة'),
        'icon': Assets.icons.animalCharitySvgrepoCom.path
      },
      {
        'id': 'transport',
        'margin-left': 48.w,
        'enable': false,
        'selected': false,
        'description': '',
        'name': AppFactory.getLabel('transport', 'نقل'),
        'icon': Assets.icons.animalPadlockSvgrepoCom.path
      }
    ];
    settings['is_mobile'] = false;
    days = [
      {
        'id': 'friday',
        'margin-left': 42.w,
        'selected': false,
        'name': AppFactory.getLabel('friday', 'الجمعة'),
        'icon': Assets.icons.clinic.path
      },
      {
        'id': 'saturday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('saturday', 'السبت'),
        'icon': Assets.icons.hote546.path
      },
      {
        'id': 'sunday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('sunday', 'الأحد'),
        'icon': Assets.icons.dog5443.path
      },
      {
        'id': 'monday',
        'selected': false,
        'margin-left': 48.w,
        'name': AppFactory.getLabel('monday', 'الاثنين'),
        'icon': Assets.icons.dog43445.path
      },
      {
        'id': 'tuesday',
        'margin-left': 45.w,
        'selected': false,
        'name': AppFactory.getLabel('tuesday', 'الثلاثاء'),
        'icon': Assets.icons.blind.path
      },
      {
        'id': 'wednesday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('wednesday', 'الأربعاء'),
        'icon': Assets.icons.outlineA.path
      },
      {
        'id': 'thursday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('thursday', 'الخميس'),
        'icon': Assets.icons.outlineA.path
      }
    ];
    transferServices = [
      {
        'id': 'working_hours',
        'margin-left': 50.w,
        'name': AppFactory.getLabel('working_hours', 'مواعيد العمل'),
        'icon': Assets.icons.calendarA.path
      }
    ];

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

  @override
  Widget build(BuildContext context) {
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
                      final response = watch(servicesDetailsProvider);
                      return response.when(idle: () {
                        return Container();
                      }, loading: () {
                        return LoaderWidget();
                      }, data: (map) {
                        ServiceDetails data = ServiceDetails.fromMap(map);
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(bottom: 50),
                            child: Column(
                              children: [
                                Container(
                                  child: MainSliderWidget(
                                    data: data.data!.images!
                                        .map((e) => {
                                              'url': e.conversions!.large!.url,
                                              'id': e.id
                                            })
                                        .toList(),
                                    supportRound: true,
                                  ),
                                  margin: EdgeInsetsResponsive.only(
                                      left: 20, right: 20),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                    width: 300.0.w,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Expanded(
                                          child: TextResponsive(
                                            data.data!.name ?? '',
                                            style: TextStyle(
                                              fontSize: 19,
                                              color: const Color(0xff707070),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        InkWell(
                                          child: Padding(
                                              padding:
                                                  EdgeInsetsResponsive.all(5),
                                              child: buildCircleIconBtnSmall(
                                                Assets.icons.iconAwesomeHeart
                                                    .svg(
                                                  width: 11.w,
                                                  height: 11.w,
                                                  color: (data
                                                              .data
                                                              ?.userReactions
                                                              ?.isFavorited ??
                                                          false)
                                                      ? Colors.red
                                                      : Colors.white,
                                                ),
                                                color: AppFactory.getColor(
                                                    'primary', toString()),
                                              )),
                                          onTap: () {
                                            if (GetStorage().hasData('token'))
                                              apiBloc.doAction(
                                                  param: BaseStatefulState
                                                      .addServiceInfo(Map(),
                                                          data: {
                                                        'method': 'post',
                                                        'url': FAVORITE_API,
                                                        'type':
                                                            'service_center',
                                                        'favoriateable_id': data
                                                            .data?.id
                                                            .toString(),
                                                        'status': !(data
                                                                .data
                                                                ?.userReactions
                                                                ?.isFavorited ??
                                                            false)
                                                      }),
                                                  supportLoading: true,
                                                  supportErrorMsg: false,
                                                  onResponse: (json) {
                                                    if (isSuccess(json)) {
                                                      context
                                                          .read(servicesProvider
                                                              .notifier)
                                                          .updateFavoriteState(
                                                              data.data?.id
                                                                      ?.toString() ??
                                                                  '-1',
                                                              !(data
                                                                      .data
                                                                      ?.userReactions
                                                                      ?.isFavorited ??
                                                                  false));
                                                      context
                                                          .read(
                                                              servicesDetailsProvider
                                                                  .notifier)
                                                          .updateFavoriteState(
                                                              data.data?.id
                                                                      ?.toString() ??
                                                                  '-1',
                                                              !(data
                                                                      .data
                                                                      ?.userReactions
                                                                      ?.isFavorited ??
                                                                  false));
                                                    }
                                                  });
                                            else
                                              goTo(LoginScreen.generatePath(),
                                                  transition:
                                                      TransitionType.inFromTop);
                                          },
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        InkWell(
                                          child: buildCircleIconBtnSmall(
                                            Padding(
                                              padding:
                                                  EdgeInsetsResponsive.all(5),
                                              child: Assets
                                                  .icons.iconAwesomeShareAlt
                                                  .svg(
                                                width: 11.w,
                                                height: 11.w,
                                              ),
                                            ),
                                            color: AppFactory.getColor(
                                                'primary', toString()),
                                          ),
                                          onTap: () {
                                            Share.share(
                                                'check out my website ${data.data?.shareUrl ?? ''}',
                                                subject: 'Look what I made!');
                                          },
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 15.w,
                                ),
                                (data.data!.settings!.isMobile ?? false)
                                    ? Container(
                                        width: 300.0.w,
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.elliptical(
                                                        9999.0, 9999.0)),
                                                color: const Color(0xff3876ba),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0x29000000),
                                                    offset: Offset(0, 3),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  EdgeInsetsResponsive.all(10),
                                              child: Assets
                                                  .icons.iconAwesomeCarAlt
                                                  .svg(),
                                              width: 46.w,
                                              height: 46.w,
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Flexible(
                                              child: TextResponsive(
                                                'يوجد خدمة متنقلة للمنزل',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0xff3876ba),
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 15.w,
                                ),
                                Container(
                                  width: 300.0.w,
                                  child: Row(
                                    children: [
                                      TextResponsive(
                                        'العنوان:',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: const Color(0xff707070),
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Flexible(
                                        child: TextResponsive(
                                          (data.data?.location?.governorate
                                                      ?.name ??
                                                  '') +
                                              ' - ' +
                                              (data.data?.location?.address ??
                                                  ''),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: const Color(0xff707070),
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  child: buildSectionTitle(AppFactory.getLabel(
                                      'map_click',
                                      'اضغط هنا لعرض الخريطة بشكل اكبر')),
                                  onTap: () {
                                    goTo(FullScreenMapScreen.generatePath(),
                                        data: getStartLocation(data));
                                  },
                                ),
                                Container(
                                  width: 300.0.w,
                                  height: 163.0.w,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                      child: MapSample(
                                        supportClick: false,
                                        initLocation: getStartLocation(data),
                                        onTap: (location) {},
                                      )),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0),
                                      ),
                                      color: Colors.grey[200]),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                buildSectionTitle(
                                    AppFactory.getLabel(
                                        'for_contact', 'للتواصل:'),
                                    bottom: 5),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Container(
                                  width: 300.w,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconBtnWidget(
                                        icon: Assets.icons.iconAwesomeRocketchat
                                            .svg(
                                          width: 29.w,
                                          height: 25.w,
                                        ),
                                      ),
                                      data.data!.contacts!.mobile != null
                                          ? InkWell(
                                              onTap: () {
                                                launchCaller(data
                                                    .data!.contacts!.mobile
                                                    .toString());
                                              },
                                              child: IconBtnWidget(
                                                color: Colors.green,
                                                icon: Assets
                                                    .icons.iconIonicIosCall
                                                    .svg(
                                                        width: 29.w,
                                                        color: Colors.green,
                                                        height: 25.w),
                                              ),
                                            )
                                          : Container(),
                                      data.data!.contacts!.whatsapp != null
                                          ? InkWell(
                                              onTap: () {
                                                launchWhatsApp(
                                                    phone: data.data!.contacts!
                                                        .whatsapp
                                                        .toString(),
                                                    message: 'hi');
                                              },
                                              child: IconBtnWidget(
                                                color: Colors.green,
                                                icon: Assets
                                                    .icons.iconSimpleWhatsapp
                                                    .svg(
                                                        color: Colors.green,
                                                        width: 29.w,
                                                        height: 25.w),
                                              ),
                                            )
                                          : Container(),
                                      data.data!.contacts!.viber != null
                                          ? InkWell(
                                              onTap: () {
                                                launchViber(data
                                                    .data!.contacts!.viber
                                                    .toString());
                                              },
                                              child: IconBtnWidget(
                                                color: Colors.deepPurple,
                                                icon: Assets
                                                    .icons.iconAwesomeViber
                                                    .svg(
                                                  width: 29.w,
                                                  height: 25.w,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                buildSectionTitle(
                                    AppFactory.getLabel(
                                        'services', 'الخدمات: '),
                                    bottom: 5),
                                ServicesSection(data.data!.services!.map((e) {
                                  var temp = getLocalService(e.type?.id ?? '');
                                  return {
                                    'id': e.type!.id,
                                    'enable': e.isEnabled,
                                    'item_count': e.doctors != null
                                        ? e.doctors!.length
                                        : 0,
                                    'doctors': e.doctors,
                                    'icon': temp?['icon'] ?? '',
                                    'name': temp?['name'] ?? '',
                                    'selected': temp?['selected'] ?? false,
                                    'description': e.description
                                  };
                                }).toList()),
                                Container(
                                  width: 310.w,
                                  child: ExpandablePanel(
                                    theme: ExpandableThemeData(
                                        hasIcon: true,
                                        iconColor: AppFactory.getColor(
                                            'primary', toString()),
                                        iconPadding: EdgeInsets.zero,
                                        bodyAlignment:
                                            ExpandablePanelBodyAlignment.center,
                                        headerAlignment:
                                            ExpandablePanelHeaderAlignment
                                                .center,
                                        iconPlacement:
                                            ExpandablePanelIconPlacement.right),
                                    header: Padding(
                                      padding: EdgeInsetsResponsive.only(
                                          left: 20, right: 20),
                                      child: TextResponsive(
                                        'المزيد',
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
                                        (data.data?.offers ?? []).length > 0
                                            ? buildSectionTitle(
                                                AppFactory.getLabel(
                                                    'offers', 'العروض: '),
                                                bottom: 5,
                                                right: 0,
                                                left: 0)
                                            : Container(),
                                        (data.data?.offers ?? []).length > 0
                                            ? Container(
                                                child: MainSliderWidget(
                                                data: data.data?.offers
                                                        ?.map((e) => {
                                                              'url': e
                                                                      .image
                                                                      ?.conversions
                                                                      ?.large
                                                                      ?.url ??
                                                                  '',
                                                              'id': e.id,
                                                              'text': e.text
                                                            })
                                                        .toList() ??
                                                    [],
                                                supportRound: true,
                                              ))
                                            : Container(),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Container(
                                          height: 0.2.w,
                                          color: Color(0xff707070),
                                        ),
                                        buildSectionTitle(
                                            AppFactory.getLabel(
                                                'times', 'مواعيد العمل: '),
                                            bottom: 5,
                                            right: 0,
                                            left: 0),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Wrap(
                                          children: data.data!.openingHours!
                                              .map((e) => e.ranges != null &&
                                                      e.ranges!.length > 0
                                                  ? Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextResponsive(
                                                          (e.day ?? '') + ':',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: const Color(
                                                                0xff707070),
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        TextResponsive(
                                                          e.ranges![0],
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: const Color(
                                                                0xff707070),
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        )
                                                      ],
                                                    )
                                                  : Container())
                                              .toList(),
                                          alignment: WrapAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          spacing: 10.w,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (GetStorage().hasData('token'))
                                              showDialog(
                                                      context: context,
                                                      barrierColor:
                                                          Colors.transparent,
                                                      barrierDismissible: true,
                                                      useSafeArea: false,
                                                      builder: (_) =>
                                                          AddRatingDialog(data
                                                              .data!.id
                                                              .toString()))
                                                  .then((value) {
                                                if (value != null &&
                                                    value == 'success') {
                                                  context
                                                      .read(
                                                          servicesDetailsProvider
                                                              .notifier)
                                                      .updateRatingState(true);
                                                }
                                              });
                                            else
                                              goTo(LoginScreen.generatePath(),
                                                  transition:
                                                      TransitionType.inFromTop);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(10.0.w),
                                                topRight:
                                                    Radius.circular(10.0.w),
                                              ),
                                              color: AppFactory.getColor(
                                                  'orange', toString()),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color(0x29000000),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: TextResponsive(
                                                (data.data?.userReactions
                                                            ?.is_reviewed ??
                                                        false)
                                                    ? 'تعديل تقييمك'
                                                    : 'أضف تقييم',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            height: 62.w,
                                          ),
                                        ),
                                        buildSectionTitle(
                                            AppFactory.getLabel(
                                                'rating', 'التقييمات:'),
                                            bottom: 5,
                                            right: 0,
                                            left: 0),
                                        SizedBox(
                                          height: 5.w,
                                        ),
                                        Row(
                                          children: [
                                            RatingBar(
                                              initialRating: data.data!.stats!
                                                      .reviewsAvg ??
                                                  0.0,
                                              minRating: 5,
                                              textDirection: TextDirection.ltr,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              ignoreGestures: true,
                                              itemSize: 14.w,
                                              ratingWidget: RatingWidget(
                                                full: Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                half: Icon(
                                                  Icons.star_half_sharp,
                                                  color: Colors.amber,
                                                ),
                                                empty: Icon(
                                                  Icons.star_border,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 2.w),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            TextResponsive(
                                              '[${data.data!.stats!.reviewsCount.toString()}]',
                                              style: TextStyle(
                                                fontSize:
                                                    AppFactory.getFontSize(
                                                        15.0, toString()),
                                                color: AppFactory.getColor(
                                                    'gray_1', toString()),
                                              ),
                                              textAlign: TextAlign.right,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.w,
                                        ),
                                        RatingSFWidget(
                                            data.data?.id?.toString() ?? '-1'),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
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

  Column buildDocumentType(String name, Widget icon) {
    return Column(
      children: [
        Container(
          width: 47.0.w,
          height: 43.0.w,
          child: icon,
        ),
        SizedBox(
          height: 5.h,
        ),
        TextResponsive(
          name,
          style: TextStyle(
            fontSize: 15.0,
            color: AppFactory.getColor('primary', toString()),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Map<String, dynamic> getServices() {
    Map<String, dynamic> servicesMap = Map();

    for (var element in servicesData) {
      Map<String, dynamic> temp = Map();
      temp['description'] = element['description'];
      temp['is_enabled'] = element['enable'];
      if (element['doctors'] != null) {
        temp['doctors'] = [];
        for (int i = 0; i < element['doctors'].length; i++) {
          temp['doctors[$i]'] = element['doctors'][i];
        }
      }
      servicesMap[element['id']] = temp;
      //openingHours[element['id']][element['from']]=element['to'];

    }

    return servicesMap;
  }

  Map<String, dynamic> getImages() {
    Map<String, dynamic> imagesData = Map();

    for (var element in images) {
      Map<String, dynamic> temp = Map();
      temp['is_main'] = element['is_main'];
      imagesData[element['id'].toString()] = temp;
    }

    return imagesData;
  }

  Map<String, dynamic> getOpeningHours() {
    Map<String, dynamic> openingHours = Map();

    for (var element in days) {
      if (element['from'] != null) {
        Map<String, dynamic> temp = Map();
        temp[element['from']] = element['to'];
        openingHours[element['id']] = temp;
        //openingHours[element['id']][element['from']]=element['to'];
      }
    }

    return openingHours;
  }

  getStartLocation(ServiceDetails data) {
    try {
      return LatLng(
          double.parse(
              (data.data!.location!.coordinates!.latitude ?? 0.0).toString()),
          double.parse(
              (data.data!.location!.coordinates!.longitude ?? 0.0).toString()));
    } catch (e) {}
    return null;
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
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              height: 21.w,
                                              width: 22.w),
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
