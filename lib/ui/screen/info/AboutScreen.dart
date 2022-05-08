import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
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
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldBorderedWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CheckBoxWidget.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/DogCatSelectWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsLargeWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  static const String PATH = '/about';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends BaseStatefulState<AboutScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  dynamic enquiryTypes;

  @override
  void initState() {
    AuthResponse authResponse =
        AuthResponse.fromMap(GetStorage().read('account'));

    enquiryTypes = copy(GetStorage().read('basics')['enums']['enquiry_types']);
    param['mobile'] = authResponse.data?.mobile ?? '';
    param['name'] = authResponse.data?.user?.name?.full ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              SizedBox.expand(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
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
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(bottom: 50),
                            child: Column(
                              children: [
                                buildSectionTitle(
                                    AppFactory.getLabel('about', 'حول التطبيق'),
                                    textAlign: TextAlign.center),
                                Assets.images.aboutLogo
                                    .image(width: 287.w, height: 147.w),
                                buildSectionTitle(
                                    AppFactory.getLabel(
                                        'contact_us', 'الاتصال بالإدارة'),
                                    textAlign: TextAlign.center),
                                Container(
                                  width: 266.w,
                                  child: Column(
                                    children: [
                                      CheckBoxWidget(
                                        onSelected: (item) {
                                          param['enquiry_type'] = item['id'];
                                        },
                                        axis: Axis.horizontal,
                                        data: enquiryTypes,
                                      ),
                                      /*  Container(
                                          width: 226.w,
                                          child: AppTextFieldBorderedWidget(
                                            name: 'الاسم',
                                            supportDecoration: true,
                                            validator: RequiredValidator(
                                                errorText: errorText()),
                                            onSaved: (value) {
                                              param['name'] = value;
                                            },
                                            supportUnderLine: false,
                                          )),
                                      SizedBox(
                                        height: 5.h,
                                      ),*/
                                      Container(
                                          width: 226.w,
                                          child: AppTextFieldBorderedWidget(
                                            name: 'البريد الألكتروني',
                                            supportDecoration: true,
                                            onSaved: (value) {
                                              param['email'] = value;
                                            },
                                            supportUnderLine: false,
                                          )),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      /*  Container(
                                          width: 226.w,
                                          child: AppTextFieldBorderedWidget(
                                            name: 'رقم الموبايل',
                                            supportDecoration: true,
                                            keyboardType: TextInputType.number,
                                            validator: RequiredValidator(
                                                errorText: errorText()),
                                            onSaved: (value) {
                                              param['mobile'] = value;
                                            },
                                            supportUnderLine: false,
                                          )),
                                      SizedBox(
                                        height: 5.h,
                                      ),*/
                                      Container(
                                          width: 226.w,
                                          child: AppTextFieldBorderedWidget(
                                            name: 'عنوان الرسالة ',
                                            supportDecoration: true,
                                            maxLength: 20,
                                            onSaved: (value) {
                                              param['title'] = value;
                                            },
                                            supportUnderLine: false,
                                          )),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Container(
                                          width: 226.w,
                                          child: AppTextFieldBorderedWidget(
                                            name: 'نص الرسالة',
                                            lines: 3,
                                            validator: RequiredValidator(
                                                errorText: errorText()),
                                            onSaved: (value) {
                                              param['message'] = value;
                                            },
                                            supportDecoration: true,
                                            supportUnderLine: false,
                                          )),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Container(
                                        width: 226.w,
                                        child: MainAppButton(
                                            name: AppFactory.getLabel(
                                                'send', 'إرسال'),
                                            bgColor: AppFactory.getColor(
                                                'primary', toString()),
                                            onClick: () {
                                              if (param['enquiry_type'] ==
                                                  null) {
                                                showFlash(AppFactory.getLabel(
                                                    'plz_select_msg_type',
                                                    'الرجاء اختيار سبب الرسالة'));
                                                return;
                                              }
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                apiBloc.doAction(
                                                    param: BaseStatefulState
                                                        .addServiceInfo(param,
                                                            data: {
                                                          'url': ENQUIRIES_API,
                                                          'method': 'post',
                                                        }),
                                                    onResponse: (json) {
                                                      Navigator.pop(context);
                                                      handlerResponseMsg(json);
                                                    },
                                                    supportLoading: true,
                                                    supportErrorMsg: false);
                                              }
                                            }),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0.w),
                                      topRight: Radius.circular(20.0.w),
                                    ),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Container(
                                  width: 220.w,
                                  height: 0.3,
                                  color: Color(0xff707070).withOpacity(0.4),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                TextResponsive(
                                  'رقم النسخة' + ' 1.0',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: const Color(0xff707070),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Container(
                                  width: 239.w,
                                  child: Html(
                                      data: GetStorage()
                                              .read('basics')['about_app']
                                          ['about_us']),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  /*  InkWell(
                                      onTap: () async {
                                        if (await canLaunch(GetStorage().read(
                                                    'basics')['about_app']
                                                ['social_networks']
                                            ['socials_twitter']))
                                          await launch(GetStorage().read(
                                                      'basics')['about_app']
                                                  ['social_networks']
                                              ['socials_twitter']);
                                      },
                                      child: Assets.images.twitterIc
                                          .image(width: 32.w, height: 32.w),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),*/
                                    InkWell(
                                        onTap: () async {
                                          if (await canLaunch(GetStorage().read(
                                                      'basics')['about_app']
                                                  ['social_networks']
                                              ['socials_facebook']))
                                            await launch(GetStorage().read(
                                                        'basics')['about_app']
                                                    ['social_networks']
                                                ['socials_facebook']);
                                        },
                                        child: Assets.images.facebookIc
                                            .image(width: 32.w, height: 32.w)),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          if (await canLaunch(GetStorage().read(
                                                      'basics')['about_app']
                                                  ['social_networks']
                                              ['socials_instagram']))
                                            await launch(GetStorage().read(
                                                        'basics')['about_app']
                                                    ['social_networks']
                                                ['socials_instagram']);
                                        },
                                        child: Assets.images.instagramIcon
                                            .image(width: 32.w, height: 32.w)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )));
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

  Column buildHireType(String name, Widget icon) {
    return Column(
      children: [
        Container(
          width: 62.0.w,
          height: 62.0.w,
          padding: EdgeInsetsResponsive.all(7),
          child: icon,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            border: Border.all(
              width: 1.0,
              color: AppFactory.getColor('gray_1', toString()),
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        TextResponsive(
          name,
          style: TextStyle(
            fontSize: 15.0,
            color: AppFactory.getColor('gray_1', toString()),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class ImagesWidget extends StatefulWidget {
  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 113.0.w,
            width: 309.w,
            child: ClipRect(
                child: Banner(
                    message: AppFactory.getLabel('main_img', 'الصورة الرئيسية'),
                    textStyle: TextStyle(
                      fontFamily: FontFamily.araHamahAlislam,
                      fontSize: 10.0.h,
                      color: Colors.white,
                    ),
                    location: BannerLocation.topEnd,
                    color: AppFactory.getColor('orange', toString()),
                    child: Container(
                      height: 113.0.w,
                      width: 309.w,
                      margin: EdgeInsetsResponsive.all(2),
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
                            blurRadius: 14.0,
                          ),
                        ],
                      ),
                    )))),
        SizedBox(
          height: 25.h,
        ),
        Container(
            width: 309.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [1, 2, 3, 4]
                  .map(
                    (e) => Container(
                      height: 86.0.w,
                      width: 70.w,
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
