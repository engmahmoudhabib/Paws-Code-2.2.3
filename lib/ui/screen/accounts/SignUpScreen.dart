import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppComponent.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/config/ConstantsWidget.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/OTPScreen.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'CompleteAccountScreen.dart';

class SignUpScreen extends StatefulWidget {
  static const String PATH = '/accounts-sign-up';
  late final bool isServiceProvider;

  SignUpScreen(this.isServiceProvider);

  static String generatePath(bool isServiceProvider) {
    Map<String, dynamic> parameters = {
      'isServiceProvider': isServiceProvider ? '1' : '0'
    };
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseStatefulState<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  @override
  void initState() {
    param['account_type'] = widget.isServiceProvider
        ? ConstantsWidget.of(GetIt.I<ApplicationCore>().getContext())!
            .getAccountsType()[1]['id']
        : ConstantsWidget.of(GetIt.I<ApplicationCore>().getContext())!
            .getAccountsType()[0]['id'];
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
            systemNavigationBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: AppFactory.getColor('background', toString()),
          body: Stack(
            children: [
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                return !isKeyboardVisible ? FooterWidget() : Container();
              }),
              Container(
                margin: EdgeInsetsResponsive.only(
                    top: AppFactory.getDimensions(120, toString())),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Assets.images.feet.image(
                      width: AppFactory.getDimensions(95, toString()).w,
                      height: AppFactory.getDimensions(65, toString()).h),
                ),
              ),
              SizedBox.expand(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: AppFactory.getDimensions(
                                  60, toString() + '-systemNavigationBarMargin')
                              .h,
                        ),
                        buildMainTitle(widget.isServiceProvider
                            ? AppFactory.getLabel(
                                'provider-account', 'مقدم الخدمة')
                            : AppFactory.getLabel(
                                'breeder-account', 'مستخدم/مربي')),
                        SizedBox(
                          height: AppFactory.getDimensions(30, toString()).h,
                        ),
                        AppTextField(
                          name: AppFactory.getLabel('name', 'الاسم'),
                          onSaved: (value) {
                            param['first_name'] = value;
                          },
                          validator: RequiredValidator(errorText: errorText()),
                          icon: Assets.icons.iconFeatherUser.svg(
                              width: AppFactory.getDimensions(12, toString()).w,
                              height:
                                  AppFactory.getDimensions(14, toString()).w),
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(10, toString()).h,
                        ),
                        AppTextField(
                          name: AppFactory.getLabel('last_name', 'الكنية'),
                          onSaved: (value) {
                            param['last_name'] = value;
                          },
                          validator: RequiredValidator(errorText: errorText()),
                          icon: Assets.icons.iconFeatherUser.svg(
                              width: AppFactory.getDimensions(12, toString()).w,
                              height:
                                  AppFactory.getDimensions(14, toString()).w),
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(10, toString()).h,
                        ),
                        AppTextField(
                          name: AppFactory.getLabel(
                              'mobile', 'رقم الموبايل ${getHintMobile()}'),
                          onSaved: (value) {
                            param['username'] = value;
                          },
                          iconEnd: buildMobilePreIcon(),
                          validator: RequiredValidator(errorText: errorText()),
                          keyboardType: TextInputType.number,
                          supportDecoration: true,
                          icon: Assets.icons.iconAwesomeMobileAlt.svg(
                              width: AppFactory.getDimensions(12, toString()).w,
                              height:
                                  AppFactory.getDimensions(14, toString()).w),
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(10, toString()).h,
                        ),
                        AppTextField(
                          obscureText: true,
                          onSaved: (value) {
                            param['password'] = value;
                          },
                          onChanged: (value) {
                            param['password'] = value;
                          },
                          name: AppFactory.getLabel('password', 'كلمة المرور'),
                          validator: RequiredValidator(errorText: errorText()),
                          icon: Assets.icons.iconFeatherLock.svg(
                              width: AppFactory.getDimensions(12, toString()).w,
                              height:
                                  AppFactory.getDimensions(14, toString()).w),
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(10, toString()).h,
                        ),
                        AppTextField(
                          obscureText: true,
                          name: AppFactory.getLabel(
                              'password_confirm', 'تأكيد كلمة المرور'),
                          validator: (val) =>
                              MatchValidator(errorText: errorNotMatch())
                                  .validateMatch(val!, param['password'] ?? ''),
                          icon: Assets.icons.iconFeatherLock.svg(
                              width: AppFactory.getDimensions(12, toString()).w,
                              height:
                                  AppFactory.getDimensions(14, toString()).w),
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(10, toString()).h,
                        ),
                        AppTextField(
                          isDropDown: true,
                          onSelectedValue: (city) {
                            param['governorate_id'] = city['id'];
                          },
                          items: GetStorage().read('basics')?['governorates'] ??
                              [],
                          name: AppFactory.getLabel('city', 'المحافظة'),
                          validator: RequiredValidator(errorText: errorText()),
                          icon: Assets.icons.iconAwesomeCity.svg(
                              width: AppFactory.getDimensions(12, toString()).w,
                              height:
                                  AppFactory.getDimensions(14, toString()).w),
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(50, toString()).h,
                        ),
                        MainAppButton(
                          name: AppFactory.getLabel('register', 'تسجيل'),
                          onClick: () {
                            //  goTo(OTPScreen.generatePath(),  transition: TransitionType.inFromRight);
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              apiBloc.doAction(
                                  param: BaseStatefulState.addServiceInfo(param,
                                      data: {
                                        'url': REGISTER_API,
                                        'method': 'post',
                                      }),
                                  onResponse: (json) {
                                    handlerLogin(json,
                                        username: param['username'],
                                        password: param['password'],isRegister: true);
                                  },
                                  supportLoading: true,
                                  supportErrorMsg: false);
                            }
                          },
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(20, toString()).h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
