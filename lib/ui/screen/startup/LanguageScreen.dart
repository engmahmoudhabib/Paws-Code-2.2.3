import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

import 'SplashScreen.dart';

class LanguageScreen extends StatefulWidget {
  static const String PATH = '/startup-language';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends BaseStatefulState<LanguageScreen> {
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
            systemNavigationBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: AppFactory.getColor('primary', toString()),
          body: Stack(
            children: [
              Container(
                margin: EdgeInsetsResponsive.only(
                    top: AppFactory.getDimensions(100, toString())),
                child: Align(
                  alignment: Alignment.center,
                  child: Assets.images.feets.image(
                      width: AppFactory.getDimensions(337, toString()).w,
                      height: AppFactory.getDimensions(321, toString()).h),
                ),
              ),
              SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: AppFactory.getDimensions(
                              60, toString() + '-systemNavigationBarMargin')
                          .h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LogoWidget(
                              color:
                                  AppFactory.getColor('on_primary', toString()),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(30, toString()).h,
                            ),
                            Text1Widget(
                              text: 'اختر اللغة',
                            ),
                            Text1Widget(
                              text: 'Select language',
                            ),
                            Text1Widget(
                              text: 'زمان ديارى بكه',
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(30, toString()).h,
                            ),
                            RadioButtonsWidget(
                              onSelected: (item) {
                                //GetStorage().write('uuid'

                                apiBloc.doAction(
                                    param: {
                                      'method': 'post',
                                      'url': UPDATE_DEVICE_API,
                                      'lang': item['id'],
                                      'is_notifiable': 1,
                                      'instance_uuid':GetStorage().read('uuid')
                                    },
                                    supportLoading: true,
                                    onResponse: (json) {
                                      if(GetStorage().hasData('token'))
                                        Navigator.pop(context);
                                        else
                                      goTo(LoginScreen.generatePath(),
                                          transition:
                                              TransitionType.inFromBottom);
                                    },
                                    supportErrorMsg: true);
                              },
                              data: [
                                {
                                  'selected': true,
                                  'title': 'العربية',
                                  'id': 'ar'
                                },
                                {
                                  'selected': false,
                                  'title': 'كوردى',
                                  'id': 'ku'
                                },
                                {
                                  'selected': false,
                                  'title': 'English',
                                  'id': 'en'
                                }
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Assets.images.dog2.image(
                              width:
                                  AppFactory.getDimensions(106, toString()).w,
                              height:
                                  AppFactory.getDimensions(57, toString()).h),
                          Assets.images.dog1.image(
                              width: AppFactory.getDimensions(79, toString()).w,
                              height:
                                  AppFactory.getDimensions(98, toString()).h),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
