import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/models/api/ServiceDetails.dart';
import 'package:flutter_app/providers/ServicesProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogsss/ChangeStatusDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
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
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as ColorPicker;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MapSample.dart';

class ActivateServicesScreen extends StatefulWidget {
  static const String PATH = '/services-activate';

  String? id;

  ActivateServicesScreen({this.id});

  static String generatePath({String? id}) {
    Map<String, dynamic> parameters = {'id': id};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _ActivateServicesScreenState createState() => _ActivateServicesScreenState();
}

class _ActivateServicesScreenState
    extends BaseStatefulState<ActivateServicesScreen> {
  ValueNotifier<bool> isDog = ValueNotifier(false);
  ValueNotifier<bool> isHybrid = ValueNotifier(false);
  ValueNotifier<List<Color>> colors = ValueNotifier([]);
  late List<dynamic> transferServices;
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();
  List<dynamic> mainImages = [];
  List<dynamic> otherImages = [];

  Map<String, dynamic> contacts = Map();
  Map<String, dynamic> location = Map();
  Map<String, dynamic> opening_hours = Map();
  List<dynamic> images = [];

  Map<String, dynamic> settings = Map();
  late List<dynamic> days;
  Map<String, dynamic> services = Map();
  late List<dynamic> servicesData;
  AuthResponse? accountData;

  @override
  void initState() {
    settings['is_mobile'] = false;
    accountData = AuthResponse.fromMap(GetStorage().read('account'));

    mainImages = [
      {'state': 0, 'url': ''},
    ];
    otherImages = [
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''}
    ];

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
    AuthResponse authResponse =
        AuthResponse.fromMap(GetStorage().read('account'));

    try {
      widget.id =
          authResponse.data!.serviceProvider['service_center']['id'].toString();
    } catch (e) {}
    if (widget.id != null && widget.id!.length > 0) {
      Future.delayed(
          Duration.zero,
          () => context
                  .read(servicesDetailsProvider.notifier)
                  .getDetails(widget.id ?? '', onResponse: (data) {
                try {
                  settings['is_mobile'] =
                      data.data?.settings?.isMobile ?? false;
                } catch (e) {}

                try {
                  mainImages[0]['id'] = data.data?.mainImage?.id.toString();
                  mainImages[0]['url'] =
                      data.data?.mainImage?.conversions?.large?.url ?? null;
                } catch (e) {}

                try {
                  int index = 0;
                  data.data?.images!.forEach((element) {
                    if (!element.properties['is_main']) {
                      otherImages[index]['id'] = element.id.toString();
                      otherImages[index]['url'] =
                          element.conversions?.large?.url ?? null;
                      index++;
                    }
                  });
                } catch (e) {}

                try {
                  data.data?.services!.forEach((element) {
                    for (var service in servicesData) {
                      if (element.type!.id == service['id']) {
                        service['enable'] = element.isEnabled;
                        service['description'] = element.description;
                        //service['name'] = element.description;
                        // service['id'] = element.id;

                        try {
                          element.doctors!.forEach((element) {
                            service['doctors'].add(element['name']);
                          });
                          service['item_count'] = element.doctors!.length + 1;
                        } catch (e) {}
                        break;
                      }
                    }
                  });
                } catch (e) {}

                try {
                  var dateFormat =
                      DateFormat("hh:mm aa"); // you can change the format here

                  data.data?.openingHours?.forEach((element) {
                    if ((element.ranges?.length ?? 0) > 0) {
                      for (var day in days) {
                        if (day['name'] == element.day) {
                          List s = element.ranges![0].split('-');

                          // print(DateFormat.j().format(parseHoursInUtc(s[0]).toLocal())); // 4:52:59 PM

                          //  HH:mm

                          day['from'] = s[0];
                          day['to'] = s[1];
                          break;
                        }
                      }
                    }
                  });
                } catch (e) {}
              }));
      param['id'] = widget.id;
    }

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
        child: Scaffold(
          backgroundColor: AppFactory.getColor('background', toString()),
          body: Stack(
            children: [
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                return !isKeyboardVisible ? RightLeftWidget() : Container();
              }),
              Column(
                children: [
                  SizedBox(
                    height: AppFactory.getDimensions(
                            50, toString() + '-systemNavigationBarMargin')
                        .h,
                  ),
                  AppBarWidget('', (pageId) {
                    goTo(
                        HomeScreen.generatePath(
                          pageId: pageId,
                        ),
                        clearStack: true);
                  }),
                  Expanded(
                      child: widget.id != null && widget.id!.length > 0
                          ? Consumer(
                              builder: (context, watch, child) {
                                final response = watch(servicesDetailsProvider);
                                return response.when(idle: () {
                                  return Container();
                                }, loading: () {
                                  return Center(
                                    child: Container(
                                      width: 270.w,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            /*SpinKitFadingCube(
                              color: Colors.white,
                              size: 30.0.w.toDouble(),
                            )*/
                                            Assets.images.walkingPaws.image()
                                          ]),
                                    ),
                                  );
                                }, data: (map) {
                                  ServiceDetails data =
                                      ServiceDetails.fromMap(map);

                                  return buildBody(data);
                                }, error: (e) {
                                  return Container();
                                });
                              },
                            )
                          : buildBody(null))
                ],
              ),
            ],
          ),
        )));
  }

  buildBody(ServiceDetails? data) {
    return SizedBox.expand(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsResponsive.only(bottom: 50),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        padding: EdgeInsetsResponsive.only(
                            left: 10, right: 10, top: 3, bottom: 5),
                        child: TextResponsive(
                          AppFactory.getLabel(
                              'activate_services', 'تفعيل الخدمات'),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: AppFactory.getColor('primary', toString()),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      AppTextField(
                        name: AppFactory.getLabel('center_name', 'اسم المركز'),
                        value: data?.data?.name ?? null,
                        onSaved: (value) {
                          param['name'] = value;
                        },
                        validator: RequiredValidator(errorText: errorText()),
                        icon: Assets.icons.healthClinic.svg(
                            width: AppFactory.getDimensions(12, toString()).w,
                            height: AppFactory.getDimensions(14, toString()).w),
                      ),
                      buildSectionTitle(AppFactory.getLabel(
                          'contact_numbers', 'أرقام التواصل')),
                      AppTextField(
                        name: AppFactory.getLabel(
                            'mobile', 'رقم الموبايل ${getHintMobile()}'),
                        iconEnd: buildMobilePreIcon(),
                        value: data?.data?.contacts?.mobile ??
                            accountData?.data?.mobile ??
                            null,
                        onSaved: (value) {
                          contacts['mobile'] = value;
                        },
                        validator: RequiredValidator(errorText: errorText()),
                        keyboardType: TextInputType.number,
                        icon: Assets.icons.iconAwesomeMobileAlt.svg(
                            width: AppFactory.getDimensions(12, toString()).w,
                            height: AppFactory.getDimensions(14, toString()).w),
                      ),
                      AppTextField(
                        name: AppFactory.getLabel(
                            'whatsapp', 'رقم وتساب ${getHintMobile()}'),
                        iconEnd: buildMobilePreIcon(),
                        value: data?.data?.contacts?.whatsapp ??
                            accountData?.data?.contacts?['whatsapp'] ??
                            ((accountData?.data
                                        ?.contacts?['whatsappSameAsMobile'] ??
                                    false)
                                ? accountData?.data?.mobile
                                : null) ??
                            null,
                        onSaved: (value) {
                          contacts['whatsapp'] = value;
                        },
                        keyboardType: TextInputType.number,
                        icon: Assets.icons.iconAwesomeWhatsapp.svg(
                            width: AppFactory.getDimensions(12, toString()).w,
                            height: AppFactory.getDimensions(14, toString()).w),
                      ),
                      AppTextField(
                        name: AppFactory.getLabel(
                            'viper', 'رقم الفايبر ${getHintMobile()}'),
                        onSaved: (value) {
                          contacts['viber'] = value;
                        },
                        keyboardType: TextInputType.number,
                        value: data?.data?.contacts?.viber ??
                            accountData?.data?.contacts?['viber'] ??
                            ((accountData?.data
                                        ?.contacts?['viberSameAsMobile'] ??
                                    false)
                                ? accountData?.data?.mobile
                                : null) ??
                            null,
                        iconEnd: buildMobilePreIcon(),
                        icon: Assets.icons.iconAwesomeViber.svg(
                            width: AppFactory.getDimensions(12, toString()).w,
                            height: AppFactory.getDimensions(14, toString()).w),
                      ),
                      buildSectionTitle(
                          AppFactory.getLabel('address', 'العنوان')),
                      Container(
                        width: 300.0.w,
                        height: 66.0.w,
                        child: Padding(
                          padding:
                              EdgeInsetsResponsive.only(left: 10, right: 10),
                          child: AppTextField(
                            supportUnderLine: false,
                            value: data?.data?.location?.address ?? null,
                            onSaved: (value) {
                              location['address'] = value;
                            },
                            name: AppFactory.getLabel(
                                'hint_location', 'أبجد هوز….'),
                            validator:
                                RequiredValidator(errorText: errorText()),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0),
                            ),
                            border: Border.all(
                              width: 0.3,
                              color: AppFactory.getColor('gray_1', toString()),
                            ),
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: 300.0.w,
                        height: 163.0.w,
                        child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0),
                            ),
                            child: MapSample(
                              initLocation: getInitLocation(data),
                              supportClick: true,
                              onTap: (location) {
                                var lat;
                                var long;

                                try {
                                  lat = location.latitude
                                      .toString()
                                      .substring(0, 10);
                                } catch (e) {
                                  lat = location.latitude.toString();
                                }
                                try {
                                  long = location.longitude
                                      .toString()
                                      .substring(0, 10);
                                } catch (e) {
                                  long = location.longitude.toString();
                                }

                                this.location['coordinates'] = lat + ',' + long;
                              },
                            )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0),
                            ),
                            color: Colors.grey[200]),
                      ),
                      Padding(
                        padding: EdgeInsetsResponsive.only(
                            left: 5, right: 5, top: 20, bottom: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SwitchWidget(
                                settings['is_mobile'],
                                AppFactory.getLabel('transfers_services',
                                    'خدمات متنقلة لموقع القط أو الكلب'),
                                (selected) {
                              settings['is_mobile'] = selected;
                            }),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: transferServices
                            .map((e) => InkWell(
                                  onTap: () {
                                    goTo(WorkingHoursScreen.generatePath(),
                                        data: days);
                                  },
                                  child: Container(
                                    height: 80.w,
                                    width: 327.w,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Assets.images.accountElement.image(
                                          height: 80.w,
                                        ),
                                        Row(
                                          textDirection: ui.TextDirection.rtl,
                                          children: [
                                            SizedBox(
                                              width: e['margin-left'],
                                            ),
                                            Container(
                                              child: SvgPicture.asset(e['icon'],
                                                  height: 21.w, width: 25.w),
                                              margin: EdgeInsets.only(
                                                bottom: 13.w,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 35.w,
                                            ),
                                            TextResponsive(
                                              e['name'],
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: AppFactory.getColor(
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
                                ))
                            .toList(),
                      ),
                      buildSectionTitle(AppFactory.getLabel(
                          'center_services_images', 'صور مركز الخدمة')),
                      ImagesWidget((images) {
                        this.images.clear();
                        this.images.addAll(images);
                      }, mainImages, otherImages),
                      SizedBox(
                        height: 5.h,
                      ),
                      buildSectionTitle(
                          AppFactory.getLabel(
                              'center_services', 'خدمات المركز '),
                          bottom: 5),
                      buildSectionTitle(
                          AppFactory.getLabel('center_services_hint',
                              'يمكنكم تفعيل الخدمات التي يقدمها مركزكم لتظهر للزبائن '),
                          color: Color(0xffFECA2E),
                          top: 0,
                          size: 17),
                      ServicesSection(servicesData),
                      SizedBox(
                        height: 15.h,
                      ),
                      MainAppButton(
                        name: AppFactory.getLabel('save', 'حفظ'),
                        onClick: () {
                          //   print(DateFormat.Hm().format(parseHoursInUtc('01:00 PM').toLocal())); // 4:52:59 PM

                          //return

                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            if (location['coordinates'] == null) {
                              showFlash(AppFactory.getLabel(
                                  'plz_select_coordinates',
                                  'الرجاء اختيار عنوان على الخريطة'));
                              return;
                            }

                            if (getOpeningHours().length == 0) {
                              showFlash(AppFactory.getLabel(
                                  'plz_select_OpeningHours',
                                  'الرجاء اختيار مواعيد العمل'));
                              return;
                            }

                            if (getImages().length == 0) {
                              showFlash(AppFactory.getLabel(
                                  'plz_select_images', 'الرجاء اختيار صورة'));
                              return;
                            }

                            /*
                            for (var element in servicesData) {
                              Map<String, dynamic> temp = Map();
                              if (element['enable'] &&
                                  (element['description'] == null ||
                                      element['description'].length == 0)) {
                                showFlash(AppFactory.getLabel(
                                        'plz_enter_desc', 'الرجاء ادخال وصف ') +
                                    element['name']);
                                return;
                              }
                            }*/

                            apiBloc.doAction(
                                param: BaseStatefulState.addServiceInfo(param,
                                    data: {
                                      'method': 'post',
                                      'contacts': contacts,
                                      'location': location,
                                      'settings': settings,
                                      'images': getImages(),
                                      'opening_hours': getOpeningHours(),
                                      'services': getServices(),
                                      'url': SERVICES_CENTER_API,
                                    }),
                                supportLoading: true,
                                supportErrorMsg: false,
                                onResponse: (json) {
                                  try {
                                    var account = GetStorage().read('account');

                                    account['data']['service_provider']
                                        ['service_center'] = {
                                      'id': json['data']['id']
                                    };
                                    GetStorage().write('account', account);
                                  } catch (e) {
                                    print(e.toString());
                                  }

                                  Navigator.pop(context);
                                  handlerResponseMsg(json);
                                });
                          }
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  RegExp _timePattern =
      RegExp(r'(?<hour>\d+):(?<minute>\d+):(?<second>\d+) (?<amPm>AM|PM)');

// timeString must be of the format "3:52:59 PM"
  DateTime parseHoursInUtc(String timeString) {
    final match = _timePattern.firstMatch(timeString);

    final hour = int.parse(match?.namedGroup('hour') ?? '0');
    final minute = int.parse(match?.namedGroup('minute') ?? '0');
    final second = int.parse(match?.namedGroup('second') ?? '0');
    final isPm = (match?.namedGroup('amPm') ?? 'AM') == 'PM';

    final now = DateTime.now().toUtc();
    return DateTime.utc(
        now.year, now.month, now.day, isPm ? hour + 12 : hour, minute, second);
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
        var doctors = element['doctors'] as List;

        //  print(element['doctors'].length.toStrin()+'  dddddddddddddddddddddddddddd');
        Map<String, dynamic> temp1 = Map();

        for (int i = 0; i < doctors.length; i++) {
          // temp['doctors[$i]'] =;
          var items = <String>[];

          print(doctors[i]);
          items.add(doctors[i]);
          temp1[i.toString()] = items;
        }

        temp['doctors'] = temp1;
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
      if (element['from'] != null && element['selected']) {
        var items = <String>[];
        items.add(element['from'] + '-' + element['to']);
        Map<String, dynamic> temp = Map();
        temp['0'] = items;

        openingHours[element['id']] = temp;

        //openingHours[element['id']][element['from']]=element['to'];
      }
    }

    return openingHours;
  }

  getInitLocation(ServiceDetails? data) {
    try {
      if (data?.data?.location?.coordinates != null) {
        return LatLng(data?.data?.location?.coordinates?.latitude ?? 0.0,
            data?.data?.location?.coordinates?.longitude ?? 0.0);
      }
    } catch (e) {}
    return null;
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
            alignment: Alignment.center,
            children: [
              Wrap(
                runSpacing: isServiceClicked()
                    ? 180.w +
                        (getSelectedService()['id'] == 'veterinary_clinic'
                            ? (getSelected()['item_count'] *
                                (45 + getSelected()['item_count'] / 3).w)
                            : 0)
                    : 0,
                children: widget.data
                    .map(
                      (e) => InkWell(
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
                          margin: EdgeInsetsResponsive.only(left: 5, right: 5),
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
                                textDirection: ui.TextDirection.rtl,
                                children: [
                                  SizedBox(
                                    height: 20.w,
                                  ),
                                  Container(
                                    child: SvgPicture.asset(e['icon'],
                                        color: Colors.white.withOpacity(0.8),
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
                      ),
                    )
                    .toList(),
              ),
              isServiceClicked()
                  ? Positioned(
                      top: 110.w, left: 0, right: 0, child: buildContent())
                  : Container()
            ],
          ),
        ),
        isService2RowClicked() ? buildContent() : Container()
      ],
    );
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController _doctor = TextEditingController();
  buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchWidget(getSelected()['enable'],
            AppFactory.getLabel('service_activate', 'تفعيل الخدمة'),
            (selected) {
          getSelected()['enable'] = selected;
        }),
        SizedBox(
          height: 10.w,
        ),
        buildWrapSectionTitle(AppFactory.getLabel('service_desc', 'وصف الخدمة'),
            top: 0),
        Center(
            child: Container(
          height: 66.0.w,
          margin: EdgeInsetsResponsive.only(left: 20, right: 20),
          child: Padding(
            padding: EdgeInsetsResponsive.only(left: 10, right: 10),
            child: AppTextField(
              supportUnderLine: false,
              key: Key(getSelected()['id']),
              onChanged: (value) {
                getSelected()['description'] = value;
              },
              value: getSelected()['description'],
              onSaved: (newValue) {},
              name: AppFactory.getLabel('hint_location', 'أبجد هوز….'),
              validator: RequiredValidator(errorText: errorText()),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0.w),
              ),
              border: Border.all(
                width: 0.3,
                color: AppFactory.getColor('gray_1', toString()),
              ),
              color: Colors.white),
        )),
        SizedBox(
          height: 10.w,
        ),
        getSelectedService()['id'] == 'veterinary_clinic'
            ? Form(
                key: formKey,
                child: ListView.builder(
                    itemCount: getSelected()['item_count'],
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsetsResponsive.only(left: 20, right: 20),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(top: 10.w),
                          child: Row(
                            children: [
                              index != 0
                                  ? InkWell(
                                      onTap: () {
                                        removeDoctor(index);
                                        setState(() {
                                          getSelected()['item_count']--;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsetsResponsive.all(10),
                                        child: SvgPicture.string(
                                          '<svg viewBox="19.0 111.0 20.1 20.1" ><path transform="translate(15.63, 107.63)" d="M 13.4375 3.375 C 7.878936290740967 3.375 3.375 7.878936290740967 3.375 13.4375 C 3.375 18.99606513977051 7.878936290740967 23.5 13.4375 23.5 C 18.99606513977051 23.5 23.5 18.99606513977051 23.5 13.4375 C 23.5 7.878935813903809 18.99606513977051 3.375 13.4375 3.375 Z M 15.98698997497559 17.08031845092773 L 13.4375 14.53082847595215 L 10.88801002502441 17.08031845092773 C 10.58806991577148 17.38025856018066 10.0946216583252 17.38025856018066 9.794681549072266 17.08031845092773 C 9.644710540771484 16.93034934997559 9.567306518554688 16.73200035095215 9.567306518554688 16.53365325927734 C 9.567306518554688 16.33530616760254 9.644710540771484 16.13695907592773 9.794681549072266 15.98698997497559 L 12.34416961669922 13.4375 L 9.794679641723633 10.88801002502441 C 9.644710540771484 10.73804092407227 9.567306518554688 10.53969192504883 9.567306518554688 10.34134674072266 C 9.567306518554688 10.14299774169922 9.644710540771484 9.944650650024414 9.794679641723633 9.794681549072266 C 10.09461975097656 9.494741439819336 10.58806991577148 9.494741439819336 10.88801002502441 9.794681549072266 L 13.43749809265137 12.34417152404785 L 15.98698806762695 9.794681549072266 C 16.28692817687988 9.494741439819336 16.7803783416748 9.494741439819336 17.0803165435791 9.794681549072266 C 17.38025665283203 10.0946216583252 17.38025665283203 10.58806991577148 17.0803165435791 10.88801193237305 L 14.53082847595215 13.4375 L 17.08031845092773 15.98698997497559 C 17.38025856018066 16.28693008422852 17.38025856018066 16.7803783416748 17.08031845092773 17.08031845092773 C 16.7803783416748 17.38509559631348 16.28693008422852 17.38509559631348 15.98698997497559 17.08031845092773 Z" fill="#feca2e" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                          allowDrawingOutsideViewBox: true,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Assets.icons.doctor.svg(
                                width: 19.w,
                                height: 24.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: AppTextField(
                                  name: '',
                                  controller: index == 0 ? _doctor : null,
                                  enable: index == 0,
                                  key: Key(index == 0
                                      ? '-1'
                                      : getSelectedService()['doctors']
                                          [index - 1]),
                                  value: getDoctorName(index),
                                  onSaved: (newValue) {
                                    if (index == 0) {
                                      getSelectedService()['doctors']
                                          .add(newValue);
                                      _doctor.text = '';
                                      setState(() {
                                        getSelected()['item_count']++;
                                      });
                                    }
                                  },
                                  supportUnderLine: false,
                                  hint: AppFactory.getLabel(
                                      'doctor_name', 'اسم الطبيب'),
                                  validator:
                                      RequiredValidator(errorText: errorText()),
                                ),
                              ),
                              index == 0
                                  ? InkWell(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          formKey.currentState!.reset();
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Assets.icons.iconIonicIosAddCircle
                                              .svg(
                                            width: 16.w,
                                            height: 16.w,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          TextResponsive(
                                            'اضافة',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: const Color(0xff707070),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        )))
            : Container(),
        SizedBox(
          height: 15.w,
        ),
        Center(
          child: SvgPicture.string(
            '<svg viewBox="32.5 1349.5 321.0 1.0" ><path transform="translate(32.5, 1349.5)" d="M 321 0 L 0 0" fill="none" fill-opacity="0.45" stroke="#000000" stroke-width="0.20000000298023224" stroke-opacity="0.45" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }

  removeDoctor(int index) {
    try {
      var l = getSelectedService()['doctors'] as List;
      l.removeAt(index - 1);
    } catch (e) {
      print(e.toString());
    }
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
  final List<dynamic> mainImages;

  final List<dynamic> otherImages;

  ImagesWidget(this.onUpdateImages, this.mainImages, this.otherImages);

  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends BaseStatefulState<ImagesWidget> {
  @override
  void initState() {
    super.initState();
    widget.onUpdateImages.call(getImages());
  }

  getImages() {
    List<dynamic> temp = [];
    widget.mainImages.forEach((element) {
      if (element['id'] != null) {
        element['is_main'] = true;
        temp.add(element);
      }
    });
    widget.otherImages.forEach((element) {
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
              children: widget.mainImages
                  .map(
                    (e) => Container(
                      height: 113.0.w,
                      width: 306.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10.0.w),
                          ),
                          child: Banner(
                              message: AppFactory.getLabel(
                                  'main_img', 'الصورة الرئيسية'),
                              textStyle: TextStyle(
                                fontFamily: FontFamily.araHamahAlislam,
                                fontSize: 10.0.h,
                                color: Colors.white,
                              ),
                              location: BannerLocation.topEnd,
                              color: AppFactory.getColor('orange', toString()),
                              child: e['state'] != 1
                                  ? ImagePickerWidget(
                                      url: e['url'],
                                      data: e,
                                      onRemove: (data) {
                                        data['url'] = '';
                                        data.remove('id');
                                        widget.onUpdateImages.call(getImages());
                                        setState(() {});
                                      },
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
                                                'file': await getImageMultiPart(
                                                    file),
                                              }),
                                              supportLoading: true,
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
                                          child: Assets
                                              .icons.iconMaterialFileUpload
                                              .svg(width: 21.w, height: 26.w)),
                                    )
                                  : ImageLoaderPlaceholder())),
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
              children: widget.otherImages
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
                                  data: e,
                                  onRemove: (data) {
                                    data['url'] = '';
                                    data.remove('id');
                                    widget.onUpdateImages.call(getImages());
                                    setState(() {});
                                  },
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
                                          supportLoading: true,
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
  final String label;

  SwitchWidget(this.selected, this.label, this.onChanged);

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends BaseStatefulState<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.selected = !widget.selected;
        });
        widget.onChanged.call(widget.selected);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildWrapSectionTitle(widget.label, top: 0, bottom: 0),
          Container(
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
                          color: widget.selected
                              ? Color(0xfffeca2e)
                              : Colors.grey),
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
                      border: Border.all(
                          width: 1.0, color: const Color(0xffffffff)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
