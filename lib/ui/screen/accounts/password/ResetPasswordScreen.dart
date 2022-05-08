import 'dart:async';

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
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/PinCodeWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String PATH = '/accounts-password-reset';
  final String userId;

  ResetPasswordScreen(this.userId);

  static String generatePath(String userId) {
    Map<String, dynamic> parameters = {'userId': userId};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends BaseStatefulState<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

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
                child: Column(
                  children: [
                    SizedBox(
                      height: AppFactory.getDimensions(
                              60, toString() + '-systemNavigationBarMargin')
                          .h,
                    ),
                    buildBackBtn(context),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height:
                                    AppFactory.getDimensions(50, toString()).h,
                              ),
                              buildSubTitle(AppFactory.getLabel('enter_code',
                                  'أدخل الرمز المكون من أربعة أرقام الذي أرسل إلى جوالك')),
                              SizedBox(
                                height:
                                    AppFactory.getDimensions(50, toString()).h,
                              ),
                              PinCodeWidget((value) {
                                param['verification_code'] = value;
                              }),
                              SizedBox(
                                height:
                                    AppFactory.getDimensions(10, toString()).h,
                              ),
                              AppTextField(
                                obscureText: true,
                                name: AppFactory.getLabel(
                                    'password', 'كلمة المرور الجديدة'),
                                onSaved: (value) {
                                  param['password'] = value;
                                },
                                onChanged: (value) {
                                  param['password'] = value;
                                },
                                validator:
                                    RequiredValidator(errorText: errorText()),
                                icon: Assets.icons.iconFeatherLock.svg(
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
                                obscureText: true,
                                name: AppFactory.getLabel('password_confirm',
                                    'تأكيد كلمة المرور الجديدة'),
                                validator: (val) =>
                                    MatchValidator(errorText: errorNotMatch())
                                        .validateMatch(
                                            val!, param['password'] ?? ''),
                                icon: Assets.icons.iconFeatherLock.svg(
                                    width:
                                        AppFactory.getDimensions(12, toString())
                                            .w,
                                    height:
                                        AppFactory.getDimensions(14, toString())
                                            .w),
                              ),
                              SizedBox(
                                height:
                                    AppFactory.getDimensions(50, toString()).h,
                              ),
                              MainAppButton(
                                name: AppFactory.getLabel('confirm', 'تأكيد'),
                                onClick: () {

                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    apiBloc.doAction(
                                        param: BaseStatefulState.addServiceInfo(
                                            param,
                                            data: {
                                              'url': RESET_PASSWORD_API +
                                                  widget.userId +
                                                  '/reset-password',
                                              'method': 'post',
                                            }),
                                        supportLoading: true,
                                        supportErrorMsg: false,
                                        onResponse: (json) {
                                           handlerLogin(json);
                                           handlerResponseMsg(json);
                                        });
                                  }
                                },
                              ),
                              SizedBox(
                                height:
                                    AppFactory.getDimensions(20, toString()).h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) {
                      return !isKeyboardVisible
                          ? Assets.images.dog4.image(
                              width: AppFactory.getDimensions(83, toString()).w,
                              height:
                                  AppFactory.getDimensions(124, toString()).h)
                          : Container();
                    }),
                    SizedBox(
                      height: AppFactory.getDimensions(20, toString()).h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
