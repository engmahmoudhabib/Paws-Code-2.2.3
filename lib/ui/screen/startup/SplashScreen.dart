import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/startup/LanguageScreen.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends StatefulWidget {
  static const String PATH = '/';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseStatefulState<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read(cartActionsProvider.notifier).hiddenCart();
    });
    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    timer = new Timer(const Duration(seconds: 3), () {
      FullScreen.exitFullScreen();
      context.read(cartActionsProvider.notifier).showCart();
      // if (GetStorage().read('token') == null)
      // GetIt.I<ApplicationCore>()
      // .goTo(LanguageScreen.generatePath(), replace: true);
      // else
      GetIt.I<ApplicationCore>().goTo(
        HomeScreen.generatePath(pageId: 'home'),
        clearStack: true,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    preBuild(context);
    return handledWidget(Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: LogoWidget(
                top: 300,
              )),
          FooterWidget(),
          SplashIconsWidget()
        ],
      ),
    ));
  }
}

class SplashIconsWidget extends StatelessWidget {
  const SplashIconsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: EdgeInsetsResponsive.only(
                bottom: AppFactory.getDimensions(30, toString())),
            child: Assets.icons.splashIcons.svg(
                width: AppFactory.getDimensions(245, toString()).w,
                height: AppFactory.getDimensions(512, toString()).h)));
  }
}
