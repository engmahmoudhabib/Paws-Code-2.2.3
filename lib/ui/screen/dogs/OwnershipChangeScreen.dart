import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:expandable/expandable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MainScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyAccountScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyDogsCatsScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CheckBoxWidget.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/DogCatSelectWidget.dart';
import 'package:flutter_app/ui/widget/FilterWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsLargeWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

import 'DetailsScreen.dart';

class OwnershipChangeScreen extends StatefulWidget {
  static const String PATH = '/dogs-cat-ownership';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _OwnershipChangeScreenState createState() => _OwnershipChangeScreenState();
}

class _OwnershipChangeScreenState
    extends BaseStatefulState<OwnershipChangeScreen> {
  @override
  void initState() {
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
                                  'نقل الملكية',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              TextResponsive(
                                AppFactory.getLabel('ownership',
                                    'نقل ملكية القط أو الكلب إلى مستخدم مسجل في التطبيق'),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xff3876ba),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildSubTitle(AppFactory.getLabel(
                                      'enter_account_number',
                                      'أدخل رقم حساب المستخدم')),
                                  SizedBox(
                                    width:
                                        AppFactory.getDimensions(20, toString())
                                            .w,
                                  ),
                                  AppTextField(
                                    name: '',
                                    textColor: AppFactory.getColor(
                                        'primary', toString()),
                                    supportUnderLine: false,
                                    width: 142.w,
                                    textAlign: TextAlign.center,
                                    validator: RequiredValidator(
                                        errorText: errorText()),
                                    keyboardType: TextInputType.number,
                                    supportDecoration: true,
                                  ),
                                ],
                              ),
                              Container(
                                width: 310.w,
                                child: ListView.builder(
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      goTo(DetailsScreen.generatePath('1'),
                                          transition:
                                              TransitionType.inFromRight);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsetsResponsive.only(top: 15),
                                      child: Opacity(
                                          opacity: index == 3 ? 0.6 : 1,
                                          child: Stack(
                                            fit: StackFit.passthrough,
                                            children: [
                                              Assets.images.box1.image(),
                                              Positioned(
                                                right: 0.w,
                                                top: 11.5.w,
                                                child: Container(
                                                  width: 68.w,
                                                  height: 68.w,
                                                  child: index != 0
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsetsResponsive
                                                                  .all(5),
                                                          child: Assets
                                                              .images.testdog
                                                              .image(),
                                                        )
                                                      : SizedBox.expand(
                                                          child:
                                                              CircularProfileAvatar(
                                                            'https://avatars0.githubusercontent.com/u/8400449?s=460&v=4',
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            borderWidth: 0,
                                                            borderColor: Colors
                                                                .transparent,
                                                            elevation: 0.0,
                                                            foregroundColor:
                                                                Colors
                                                                    .transparent,
                                                            cacheImage: true,
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  verticalDirection: index == 1
                                                      ? VerticalDirection.up
                                                      : VerticalDirection.down,
                                                  children: [
                                                    Visibility(
                                                      child: TextResponsive(
                                                        'حازم حسن',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: const Color(
                                                              0xff707070),
                                                        ),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                      visible: index == 0,
                                                    ),
                                                    TextResponsive(
                                                      index == 0
                                                          ? '+٩٦٤٠٠٠٠٠٠٠٠٠٠'
                                                          : 'هاسكي',
                                                      style: TextStyle(
                                                        fontSize: AppFactory
                                                            .getFontSize(21.0,
                                                                toString()),
                                                        color:
                                                            AppFactory.getColor(
                                                                'primary',
                                                                toString()),
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  itemCount: 2,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                              ),
                              CheckBoxWidget(
                                onSelected: (item) {},
                                data: [
                                  {
                                    'selected': true,
                                    'title':
                                        'استلمت مبلغ البيع و عملية البيع او الاهداء للتبني قد تمت بشكل كامل',
                                    'id': 'ar'
                                  },
                                  {
                                    'selected': false,
                                    'title':
                                        'تم تسليم القط أو الكلب إلى الطرف المشتري أو المتبني',
                                    'id': 'ku'
                                  }
                                ],
                              ),
                              SizedBox(
                                height: 25.w,
                              ),
                              TextResponsive(
                                'العملية ستتم بعد تاكيد الاستلام من المشتري او المتبني',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xfffeca2e),
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(
                                height: 15.w,
                              ),
                              MainAppButton(
                                onClick: () {},
                                supportShadow: false,
                                bgColor:
                                    AppFactory.getColor('orange', toString())
                                        .withOpacity(0.3),
                                name: 'تأكيد نقل الملكية',
                              ),
                              SizedBox(
                                height: 25.w,
                              ),
                              Container(
                                width: 309.w,
                                height: 0.1,
                                color:
                                    AppFactory.getColor('primary', toString()),
                              ),
                              SizedBox(
                                height: 15.w,
                              ),
                              TextResponsive(
                                'بيع أو إهداء  لشخص غير مستخدم ل paws',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: const Color(0xff707070),
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                width: 277.w,
                                child: TextResponsive(
                                  'في حالة بيعك أو اهدائك القط او الكلب لشخص غير مسجل في تطبيق Paws , يفضل نصح المشتري او المتبني الجديد بتنزيل التطبيق للحفاظ على فايل ونقل ملكية القط او الكلب  بطريقة صحيحة. في حالة عدم الحاجة للنقل او حالة وفاة القط او الكلب, يمكنك الضغط على الاختيار التالي لوضع فايل القط او الكلب في ارشيف قططك وكلابك',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: const Color(0xff707070),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              MainAppButton(
                                onClick: () {},
                                bgColor:
                                    AppFactory.getColor('primary', toString()),
                                name: 'أرشفة الملف',
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
            ],
          ),
        )));
  }

  Container buildCircleIconBtn(Widget icon) {
    return Container(
      width: 35.w,
      margin: EdgeInsetsResponsive.all(7),
      height: 35.w,
      child: Center(
        child: icon,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
        color: const Color(0xff3876ba),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
    );
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
            color: AppFactory.getColor('gray_1', toString()),
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

class InfoSLWidget extends StatelessWidget {
  final String title;
  final String desc;
  final Color? bgColor;
  final Color? txtColor;
  final List<Widget>? actions;

  const InfoSLWidget(
      {Key? key,
      this.txtColor,
      this.actions,
      required this.title,
      required this.desc,
      this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 311.w,
      height: 86.w,
      child: Stack(
        children: [
          Positioned.fill(
            top: 20.w,
            right: 5.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: bgColor ?? Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xfffeca2e)),
              ),
              child: Container(
                padding: EdgeInsetsResponsive.only(right: 25, top: 16),
                child: TextResponsive(
                  desc,
                  style: TextStyle(
                    fontSize: 17,
                    color: txtColor ?? Color(0xff707070),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
          Container(
            width: 48.w,
            height: 43.w,
            child: Stack(
              children: [
                Assets.icons.group730.svg(),
                Positioned(
                  top: 10.w,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextResponsive(
                          title,
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xfffeca2e),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions != null
              ? Positioned(
                  top: 10.w,
                  left: 5.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ))
              : Container()
        ],
      ),
    );
  }
}

class ImagesWidget extends StatefulWidget {
  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends BaseStatefulState<ImagesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 309.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [1, 2]
                  .map(
                    (e) => Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle(
                          e == 1
                              ? AppFactory.getLabel('father_img', 'صورة الأب')
                              : AppFactory.getLabel('mother_img', 'صورة الأم'),
                        ),
                        Container(
                          height: 101.0.w,
                          width: 136.w,
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
