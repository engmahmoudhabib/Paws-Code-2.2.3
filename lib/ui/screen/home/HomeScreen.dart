import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/CompleteAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MainScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyAccountScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyDogsCatsScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/NotificationsScreen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static const String PATH = '/home';
  String pageId;

  HomeScreen({required this.pageId});

  static String generatePath({required String pageId}) {
    Map<String, dynamic> parameters = {'pageId': pageId};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulState<HomeScreen> {
  String pageId = 'home';

  @override
  void initState() {
    pageId = widget.pageId;
    Future(() {
      if (pageId == 'favorite') {
        if (GetStorage().hasData('token'))
          goTo(ArticlesScreen.generatePath('3', favorite: 'yes'),
              replace: true);
        else
          goTo(LoginScreen.generatePath(),
              transition: TransitionType.inFromTop);
      }
    });

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
                    AppBarWidget(this.pageId, (pageId) {
                      if (pageId == 'favorite') {
                        if (GetStorage().hasData('token'))
                          goTo(
                              ArticlesScreen.generatePath('3', favorite: 'yes'),
                              replace: true);
                        else
                          goTo(LoginScreen.generatePath(),
                              transition: TransitionType.inFromTop);

                        //    goTo(CompleteAccountScreen.generatePath(),
                        //  data: AuthResponse.fromMap(
                        //    GetStorage().read('account')));

                        return;
                      }

                      setState(() {
                        this.pageId = pageId;
                      });
                    }),
                    pageId == 'home'
                        ? MainScreen()
                        : pageId == 'my_accounts'
                            ? GetStorage().hasData('token')
                                ? MyAccountScreen()
                                : LoginRedirectWidget()
                            : pageId == 'cats_dogs'
                                ? GetStorage().hasData('token')
                                    ? MyDogsCatsScreen()
                                    : LoginRedirectWidget()
                                : pageId == 'notifications'
                                    ? NotificationsScreen()
                                    : Container()
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}

class LoginRedirectWidget extends StatefulWidget {
  @override
  _LoginRedirectWidgetState createState() => _LoginRedirectWidgetState();
}

class _LoginRedirectWidgetState extends BaseStatefulState<LoginRedirectWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsResponsive.all(20),
      child: Container(
        height: DESIGN_HEIGHT / 2.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildMainTitle('هذة الخدمة بحاجة ل تسجيل دخول , سجل دخول للمتابعة'),
            SizedBox(
              height: 65.h,
            ),
            MainAppButton(
                bgColor: AppFactory.getColor('primary', toString()),
                name: 'تسجيل دخول',
                onClick: () {
                  goTo(LoginScreen.generatePath(),
                      transition: TransitionType.inFromBottom);
                }),
          ],
        ),
      ),
    );
  }
}
