import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
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
import 'package:flutter_app/models/api/AnimalDetailsModel.dart';
import 'package:flutter_app/models/api/ProductsReponse.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
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
import 'package:flutter_app/ui/widget/flutter_xlider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as ColorPicker;
import 'package:flutter_html/flutter_html.dart';
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
import 'package:url_launcher/url_launcher.dart';

class AnimalsFilterScreen extends StatefulWidget {
  static const String PATH = '/animal-filter';
  final VoidCallback? onBack;
  final bool forDog;
  AnimalsFilterScreen({this.onBack, this.forDog = false});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AnimalsFilterScreenState createState() => _AnimalsFilterScreenState();
}

class _AnimalsFilterScreenState extends BaseStatefulState<AnimalsFilterScreen> {
  @override
  void initState() {
    year = GetStorage().read('filter-year') ?? 0;
    month = GetStorage().read('filter-month') ?? 0;
    filterData['species_id'] = GetStorage().read('filter-species-id');
    filterData['species'] = GetStorage().read('filter-species-name');

    filterData['governorate_id'] = GetStorage().read('filter-city-id');
    filterData['governorate'] = GetStorage().read('filter-city-name');

    super.initState();
  }

  late double year;
  late double month;

  Map<String, dynamic> filterData = Map();

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
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextResponsive(
                                'الفلترة',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: const Color(0xff3876ba),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        buildSectionTitle(
                            'نوع ${widget.forDog ? 'الكلب' : 'القط'} :',
                            right: 30.w,
                            left: 30.w,
                            top: 10.w),
                        AppTextField(
                          isDropDown: true,
                          onSelectedValue: (item) {
                            if (item['id'] == -1) {
                              filterData.remove('species_id');
                              filterData.remove('species');
                            } else {
                              filterData['species_id'] = item['id'];
                              filterData['species'] = item['name'];
                            }
                          },
                          width: 327.w,
                          supportDecoration: true,
                          value: filterData['species'],
                          items: copy(
                                  GetStorage().read('basics')?['species'] ?? [])
                              .where((element) =>
                                 // !element['is_hybrid'] &&
                                  element['animal_type'] ==
                                      (widget.forDog ? 'dog' : 'cat'))
                              .toList()
                                ..insert(0, {'name': 'الكل', 'id': -1}),
                          name: AppFactory.getLabel('city', ''),
                          validator: RequiredValidator(errorText: errorText()),
                          icon: Assets.icons.iconAwesomeCity.svg(
                              width: 12.w,
                              height: 14.w,
                              color: Colors.transparent),
                        ),
                        buildSectionTitle('المحافظة :',
                            right: 30.w, left: 30.w),
                        AppTextField(
                          isDropDown: true,
                          onSelectedValue: (city) {
                            if (city['id'] == -1) {
                              filterData.remove('governorate_id');
                              filterData.remove('governorate');
                            } else {
                              filterData['governorate_id'] = city['id'];
                              filterData['governorate'] = city['name'];
                            }
                          },
                          width: 327.w,
                          supportDecoration: true,
                          value: filterData['governorate'],
                          items: List.from(
                              GetStorage().read('basics')['governorates'])
                            ..insert(0, {'name': 'الكل', 'id': -1}),
                          name: AppFactory.getLabel('city', ''),
                          validator: RequiredValidator(errorText: errorText()),
                          icon: Assets.icons.iconAwesomeCity.svg(
                              width: 12.w,
                              height: 14.w,
                              color: Colors.transparent),
                        ),
                        buildSectionTitle(
                            'عمر ${widget.forDog ? 'الكلب' : 'القط'} :',
                            right: 30.w,
                            left: 30.w),
                        buildRangeTitle('الشهر :'),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 20.h,
                          width: 333.w,
                          child: FlutterSlider(
                            values: [month, month],
                            max: 12,
                            step: FlutterSliderStep(
                              step: 1,
                            ),
                            min: 0,
                            tooltip: FlutterSliderTooltip(
                                alwaysShowTooltip: true,
                                format: (value) {
                                  if (value == '0.0') {
                                    value = 'off';
                                  }
                                  return value.replaceFirst('.0', '');
                                },
                                boxStyle: FlutterSliderTooltipBox(
                                    decoration: BoxDecoration()),
                                positionOffset:
                                    FlutterSliderTooltipPositionOffset(
                                        top: 25.h),
                                textStyle: TextStyle(
                                  fontSize: 20.w,
                                  color: const Color(0xFFE5B428),
                                )),
                            rangeSlider: false,
                            rightHandler: FlutterSliderHandler(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Material(
                                type: MaterialType.circle,
                                color:
                                    AppFactory.getColor('primary', toString()),
                                elevation: 3,
                                child: Container(
                                  width: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xffE5B428), width: 3.w),
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                  ),
                                  height: 22.w,
                                ),
                              ),
                            ),
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 7.h,
                              inactiveTrackBarHeight: 7.h,
                              inactiveTrackBar: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.09),
                                    offset: Offset(0, 3.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              activeTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppFactory.getColor(
                                      'primary', toString())),
                            ),
                            handler: FlutterSliderHandler(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Material(
                                type: MaterialType.circle,
                                color:
                                    AppFactory.getColor('primary', toString()),
                                elevation: 3,
                                child: Container(
                                  width: 22.w,
                                  height: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xffE5B428), width: 3.w),
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                  ),
                                ),
                              ),
                            ),
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              month = lowerValue;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        buildRangeTitle('السنة :'),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 20.h,
                          width: 333.w,
                          child: FlutterSlider(
                            values: [year, year],
                            max: 15,
                            step: FlutterSliderStep(
                              step: 1,
                            ),
                            min: 0,
                            tooltip: FlutterSliderTooltip(
                                alwaysShowTooltip: true,
                                boxStyle: FlutterSliderTooltipBox(
                                    decoration: BoxDecoration()),
                                positionOffset:
                                    FlutterSliderTooltipPositionOffset(
                                        top: 25.h),
                                format: (value) {
                                  if (value == '0.0') {
                                    value = 'off';
                                  }
                                  return value.replaceFirst('.0', '');
                                },
                                textStyle: TextStyle(
                                  fontSize: 20.w,
                                  color: const Color(0xFFE5B428),
                                )),
                            rangeSlider: false,
                            rightHandler: FlutterSliderHandler(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Material(
                                type: MaterialType.circle,
                                color:
                                    AppFactory.getColor('primary', toString()),
                                elevation: 3,
                                child: Container(
                                  width: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xffE5B428), width: 3.w),
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                  ),
                                  height: 22.w,
                                ),
                              ),
                            ),
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 7.h,
                              inactiveTrackBarHeight: 7.h,
                              inactiveTrackBar: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.09),
                                    offset: Offset(0, 3.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              activeTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppFactory.getColor(
                                      'primary', toString())),
                            ),
                            handler: FlutterSliderHandler(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Material(
                                type: MaterialType.circle,
                                color:
                                    AppFactory.getColor('primary', toString()),
                                elevation: 3,
                                child: Container(
                                  width: 22.w,
                                  height: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color(0xffE5B428), width: 3.w),
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                  ),
                                ),
                              ),
                            ),
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              year = lowerValue;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        buildInkWellBtn(() {
                          if (year > 0)
                            GetStorage().write('filter-year', year);
                          else
                            GetStorage().remove('filter-year');

                          if (month > 0)
                            GetStorage().write('filter-month', month);
                          else
                            GetStorage().remove('filter-month');

                          GetStorage().write(
                              'filter-city-name', filterData['governorate']);
                          GetStorage().write(
                              'filter-city-id', filterData['governorate_id']);
                          GetStorage().write(
                              'filter-species-name', filterData['species']);
                          GetStorage().write(
                              'filter-species-id', filterData['species_id']);
                          widget.onBack!.call();
                        }, 'تطبيق الفلترة',
                            bgColor:
                                AppFactory.getColor('primary', toString())),
                        SizedBox(
                          height: 10.h,
                        ),
                        buildInkWellBtn(() {
                          year = 0.0;
                          month = 0.0;
                          GetStorage().remove('filter-year');
                          GetStorage().remove('filter-month');
                          GetStorage().remove('filter-city-name');
                          GetStorage().remove('filter-city-id');
                          GetStorage().remove('filter-species-id');
                          GetStorage().remove('filter-species-name');
                          filterData.clear();
                          widget.onBack!.call();
                          setState(() {});
                        }, 'استعادة الافتراضي'),
                        SizedBox(
                          height: 50.h,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ))));
  }

  InkWell buildInkWellBtn(VoidCallback onClick, String msg, {Color? bgColor}) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: 322.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0.w),
            topRight: Radius.circular(10.0.w),
          ),
          color: bgColor ?? AppFactory.getColor('orange', toString()),
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
            msg,
            style: TextStyle(
              fontSize: 17,
              color: const Color(0xffffffff),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        height: 62.w,
      ),
    );
  }

  Padding buildRangeTitle(String msg) {
    return Padding(
      padding: EdgeInsetsResponsive.only(left: 50.w, right: 50.w),
      child: Row(
        children: [
          Expanded(
            child: TextResponsive(
              msg,
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xfffeca2e),
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
