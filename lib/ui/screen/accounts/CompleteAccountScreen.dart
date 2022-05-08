import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/config/ConstantsWidget.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/models/api/BascisResponse.dart';
import 'package:flutter_app/providers/ProfileProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
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
import 'package:select_dialog/select_dialog.dart';

class CompleteAccountScreen extends StatefulWidget {
  static const String PATH = '/accounts-complete';
  final AuthResponse? authResponse;

  CompleteAccountScreen({this.authResponse});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _CompleteAccountScreenState createState() => _CompleteAccountScreenState();
}

class _CompleteAccountScreenState
    extends BaseStatefulState<CompleteAccountScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();
  Map<String, dynamic> contacts = Map();

  @override
  void initState() {
    if (widget.authResponse!.data!.user!.usernameType!.isSocial())
      param = {'account_type': 'breeder'};
    contacts = {
      'whatsapp_same_as_mobile': false,
      'viber_same_as_mobile': false
    };
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
                        buildMainTitle(AppFactory.getLabel(
                            'complete_account', 'إكمال إنشاء حساب')),
                        SizedBox(
                          height: AppFactory.getDimensions(20, toString()).h,
                        ),
                        widget.authResponse!.data!.user!.usernameType!
                                .isSocial()
                            ? RadioButtonsTypesWidget(
                                onSelected: (item) {
                                  param['account_type'] = item['id'];
                                },
                                data: ConstantsWidget.of(context)!
                                    .getAccountsType(),
                              )
                            : Container(),
                        SizedBox(
                          height: AppFactory.getDimensions(20, toString()).h,
                        ),
                        AppTextField(
                          name: AppFactory.getLabel(
                              'mobile', 'رقم الموبايل ${getHintMobile()}'),
                          validator: RequiredValidator(errorText: errorText()),
                          iconEnd: buildMobilePreIcon(),
                          keyboardType: TextInputType.number,
                          value: !widget.authResponse?.data?.user?.usernameType
                                  ?.isSocial()
                              ? widget.authResponse?.data?.user?.username ??
                                  null
                              : null,
                          supportDecoration: true,
                          onSaved: (value) {
                            param['mobile'] = value;
                          },
                          icon: Assets.icons.iconAwesomeMobileAlt.svg(
                              width: AppFactory.getDimensions(12, toString()).w,
                              height:
                                  AppFactory.getDimensions(14, toString()).w),
                        ),
                        ProfileTextFieldWidget(
                          onSelected: (data) {
                            if (data['selected']) {
                              contacts['whatsapp_same_as_mobile'] = true;
                              contacts.remove('whatsapp');
                            } else {
                              contacts['whatsapp_same_as_mobile'] = false;
                            }
                          },
                          appTextField: AppTextField(
                            name: AppFactory.getLabel(
                                'whatsapp', 'رقم وتساب ${getHintMobile()}'),
                            iconEnd: buildMobilePreIcon(),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              contacts['whatsapp'] = value;
                            },
                            icon: Assets.icons.iconAwesomeWhatsapp.svg(
                                width:
                                    AppFactory.getDimensions(12, toString()).w,
                                height:
                                    AppFactory.getDimensions(14, toString()).w),
                          ),
                          data: {
                            'name': 'هل لديك وتساب على نفس الرقم ؟',
                            'selected': contacts['whatsapp_same_as_mobile']
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
                            keyboardType: TextInputType.number,
                            icon: Assets.icons.iconAwesomeViber.svg(
                                width:
                                    AppFactory.getDimensions(12, toString()).w,
                                height:
                                    AppFactory.getDimensions(14, toString()).w),
                          ),
                          data: {
                            'name': 'هل لديك فايبر على نفس الرقم؟',
                            'selected': contacts['viber_same_as_mobile']
                          },
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(10, toString()).h,
                        ),
                        widget.authResponse!.data!.user!.usernameType!
                                .isSocial()
                            ? AppTextField(
                                isDropDown: true,
                                onSelectedValue: (city) {
                                  param['governorate_id'] = city['id'];
                                },
                                items:
                                    GetStorage().read('basics')?['governorates']??[],
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
                              )
                            : Container(),
                        SizedBox(
                          height: AppFactory.getDimensions(50, toString()).h,
                        ),
                        MainAppButton(
                          name: AppFactory.getLabel('confirm', 'تأكيد'),
                          onClick: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              apiBloc.doAction(
                                  param: BaseStatefulState.addServiceInfo(param,
                                      data: {
                                        'url': COMPLETE_ACCOUNT_API,
                                        'method': 'post',
                                        'contacts': contacts,
                                      }),
                                  supportLoading: true,
                                  supportErrorMsg: false,
                                  onResponse: (json) {
                                    if (isSuccess(json)) {
                                      handlerLogin(json,
                                          supportRedirect: false);
                                      context
                                          .read(profileProvider.notifier)
                                          .load();
                                      goTo(
                                          HomeScreen.generatePath(
                                              pageId: 'home'),
                                          clearStack: true);
                                    }
                                  });
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
