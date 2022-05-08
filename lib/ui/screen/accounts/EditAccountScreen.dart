import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppComponent.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/ChangeUsernameDialog.dart';
import 'package:flutter_app/ui/dialogs/EnterPasswordDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/ProfileTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsTypsWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

class EditAccountScreen extends StatefulWidget {
  static const String PATH = '/accounts-edit';

  EditAccountScreen();

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends BaseStatefulState<EditAccountScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  Map<String, dynamic> location = Map();
  Map<String, dynamic> contacts = Map();

  late AuthResponse authResponse;

  @override
  void initState() {
    authResponse = AuthResponse.fromMap(GetStorage().read('account'));

    try {
      param['username'] = authResponse.data!.user!.username;
    } catch (e) {}

    if (authResponse.data?.contacts != null)
      contacts = {
        'whatsapp_same_as_mobile':
            authResponse.data?.contacts?['whatsapp_same_as_mobile'] ??
                authResponse.data!.contacts['whatsappSameAsMobile'] ??
                null,
        'viber_same_as_mobile':
            authResponse.data?.contacts?['viber_same_as_mobile'] ??
                authResponse.data!.contacts['viberSameAsMobile'] ??
                null
      };

    try {
      location['governorate_id'] =
          authResponse.data!.location['governorate']['id'];
    } catch (e) {}
    param['first_name'] = authResponse.data!.user!.name!.first;

    param['last_name'] = authResponse.data!.user!.name!.last;

    param['mobile'] = authResponse.data!.mobile;

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
              Column(
                children: [
                  SizedBox(
                    height: AppFactory.getDimensions(
                            60, toString() + '-systemNavigationBarMargin')
                        .h,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsetsResponsive.only(top: 5),
                          child: buildMainTitle(AppFactory.getLabel(
                              'edit_account', 'تعديل حسابي')),
                        ),
                      ),
                      buildBackBtn(context,
                          color: AppFactory.getColor('primary', toString())),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(20, toString()).h,
                            ),
                            AppTextField(
                              name: AppFactory.getLabel('name', 'الاسم'),
                              onSaved: (value) {
                                param['first_name'] = value;
                              },
                              value: authResponse.data!.user!.name!.first,
                              validator:
                                  RequiredValidator(errorText: errorText()),
                              icon: Assets.icons.iconFeatherUser.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(10, toString()).h,
                            ),
                            AppTextField(
                              name: AppFactory.getLabel('last_name', 'الكنية'),
                              onSaved: (value) {
                                param['last_name'] = value;
                              },
                              value: authResponse.data!.user!.name!.last,
                              validator:
                                  RequiredValidator(errorText: errorText()),
                              icon: Assets.icons.iconFeatherUser.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(20, toString()).h,
                            ),
                            AppTextField(
                              name: AppFactory.getLabel(
                                  'mobile', ' رقم الموبايل ${getHintMobile()}'),
                              validator:
                                  RequiredValidator(errorText: errorText()),
                              iconEnd: buildMobilePreIcon(),
                              value: authResponse.data?.mobile ??
                                  (!authResponse.data?.user?.usernameType
                                          ?.isSocial()
                                      ? authResponse.data?.user?.username ??
                                          null
                                      : null),
                              keyboardType: TextInputType.number,
                              supportDecoration: true,
                              onSaved: (value) {
                                param['mobile'] = value;
                              },
                              icon: Assets.icons.iconAwesomeMobileAlt.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            ProfileTextFieldWidget(
                              onSelected: (data) {
                                if (data['selected']) {
                                  contacts['whatsapp_same_as_mobile'] = true;
                                  contacts.remove('whatsapp');
                                } else {
                                  contacts['whatsapp_same_as_mobile'] = false;
                                }
                                print(contacts['whatsapp_same_as_mobile']
                                    .toString());
                              },
                              appTextField: AppTextField(
                                name: AppFactory.getLabel(
                                    'whatsapp', 'رقم وتساب ${getHintMobile()}'),

                                iconEnd: buildMobilePreIcon(),
                                onSaved: (value) {
                                  contacts['whatsapp'] = value;
                                },
                                value:
                                    authResponse.data?.contacts?['whatsapp'] ??
                                        null,
                                keyboardType: TextInputType.number,
                                icon: Assets.icons.iconAwesomeWhatsapp.svg(
                                    width:
                                        AppFactory.getDimensions(12, toString())
                                            .w,
                                    height:
                                        AppFactory.getDimensions(14, toString())
                                            .w),
                              ),
                              data: {
                                'name': 'هل لديك وتساب على نفس الرقم ؟',
                                'selected': (contacts['whatsapp_same_as_mobile']??authResponse.data?.contacts?[
                                        'whatsapp_same_as_mobile'] ??
                                    authResponse.data
                                        ?.contacts?['whatsappSameAsMobile'] ??
                                    true),
                              },
                            ),
                            ProfileTextFieldWidget(
                              onSelected: (data) {
                                if (data['selected']) {
                                  contacts['viber_same_as_mobile'] = true;
                                  contacts.remove('viber');
                                } else {
                                  contacts['viber_same_as_mobile'] = false;
                                }
                              },
                              appTextField: AppTextField(
                                name: AppFactory.getLabel(
                                    'viper', 'رقم الفايبر ${getHintMobile()}'),
                                iconEnd: buildMobilePreIcon(),
                                onSaved: (value) {
                                  contacts['viber'] = value;
                                },
                                value: authResponse.data!.contacts?['viber'] ??
                                    null,
                                keyboardType: TextInputType.number,
                                icon: Assets.icons.iconAwesomeViber.svg(
                                    width:
                                        AppFactory.getDimensions(12, toString())
                                            .w,
                                    height:
                                        AppFactory.getDimensions(14, toString())
                                            .w),
                              ),
                              data: {
                                'name': 'هل لديك فايبر على نفس الرقم؟',
                                'selected': (contacts['viber_same_as_mobile']??authResponse.data
                                        ?.contacts?['viber_same_as_mobile'] ??
                                    authResponse
                                        .data?.contacts?['viberSameAsMobile'] ??
                                    true)
                              },
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(20, toString()).h,
                            ),
                            Container(
                                width:
                                    AppFactory.getDimensions(303, toString()).w,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextResponsive(
                                      'العنوان',
                                      style: TextStyle(
                                        fontSize: AppFactory.getFontSize(
                                            18.0, toString()),
                                        color: AppFactory.getColor(
                                            'primary', toString()),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    Assets.icons.addressIc
                                        .svg(width: 53.w, height: 53.w)
                                  ],
                                )),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(10, toString()).h,
                            ),
                            AppTextField(
                              isDropDown: true,
                              onSelectedValue: (city) {
                                location['governorate_id'] = city['id'];
                              },
                              supportDecoration: true,
                              value: authResponse
                                          .data?.location?['governorate'] !=
                                      null
                                  ? authResponse.data?.location['governorate']
                                      ['name']
                                  : '',
                              items:
                                  GetStorage().read('basics')['governorates'],
                              name: AppFactory.getLabel('city', 'المحافظة'),
                              validator:
                                  RequiredValidator(errorText: errorText()),
                              icon: Assets.icons.iconAwesomeCity.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(10, toString()).h,
                            ),
                            AppTextField(
                              name: AppFactory.getLabel('road', 'المنطقة'),
                              value: authResponse.data?.location?['region_desc']??null,
                              onSaved: (value) {
                                location['region_desc'] =
                                    value!.length > 0 ? value : null;
                              },
                              icon: Assets.icons.road.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(10, toString()).h,
                            ),
                            AppTextField(
                              name: AppFactory.getLabel(
                                  'build_number', 'رقم الدار أو البناية'),
                              keyboardType: TextInputType.number,
                              value: authResponse
                                  .data!.location?['building_number']??null,
                              onSaved: (value) {
                                location['building_number'] =
                                    value!.length > 0 ? value : null;
                              },
                              icon: Assets.icons.iconAwesomeMobileAlt.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(10, toString()).h,
                            ),
                            AppTextField(
                              enable: false,
                              name: AppFactory.getLabel(
                                  'flags', 'أقرب نقطة دالة للعنوان'),
                              icon: Assets.icons.iconMaterialLocationOn.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            Container(
                              width: 300.0.w,
                              height: 66.0.w,
                              child: AppTextField(
                                supportUnderLine: false,
                                value: authResponse.data?.location?['landmarks']??null,
                                name: AppFactory.getLabel(
                                    'hint_location', 'أبجد هوز….'),
                                onSaved: (value) {
                                  location['landmarks'] =
                                      value!.length > 0 ? value : null;
                                },
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.0),
                                ),
                                border: Border.all(
                                  width: 0.3,
                                  color:
                                      AppFactory.getColor('gray_1', toString()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(50, toString()).h,
                            ),
                            !authResponse.data!.user!.usernameType!.isSocial()
                                ? buildOrangeBtn('تغيير رقم الدخول للتطبيق',
                                    () {
                                    showDialog(
                                        context: context,
                                        barrierColor: Colors.transparent,
                                        barrierDismissible: true,
                                        useSafeArea: false,
                                        builder: (_) => ChangeUsernameDialog(
                                                BaseStatefulState
                                                    .addServiceInfo(param,
                                                        data: {
                                                  'url': UPDATE_ACCOUNT_API,
                                                  'method': 'post',
                                                  'contacts': contacts,
                                                  'location': location
                                                })));
                                  })
                                : Container(),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(20, toString()).h,
                            ),
                            MainAppButton(
                              name: AppFactory.getLabel('save', 'حفظ'),
                              onClick: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  if (authResponse.data!.user!.usernameType!
                                      .isSocial())
                                    submit(null, goBack: false);
                                  else {
                                    var value = await showDialog(
                                        context: navigatorKey
                                            .currentState!.overlay!.context,
                                        barrierColor: Colors.transparent,
                                        barrierDismissible: true,
                                        useSafeArea: false,
                                        builder: (_) =>
                                            EnterPasswordDialog((password) {
                                              submit(password);
                                            }));

                                    //  if (value != null) {
                                    //   submit(value);

                                    // }
                                  }
                                }
                              },
                              bgColor:
                                  AppFactory.getColor('primary', toString()),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(70, toString()).h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  void submit(value, {bool goBack = true}) {
    apiBloc.doAction(
        param: BaseStatefulState.addServiceInfo(param, data: {
          'url': UPDATE_ACCOUNT_API,
          'method': 'post',
          'current_password': value,
          'contacts': contacts,
          'location': location
        }),
        onResponse: (json) {
          handlerLogin(json, supportRedirect: false);
          if (goBack)
            Navigator.pop(navigatorKey.currentState!.overlay!.context);
          handlerResponseMsg(json);
        },
        supportLoading: true,
        supportErrorMsg: false);
  }
}
