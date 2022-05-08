import 'dart:io';

import 'package:badges/badges.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/CartAction.dart';
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/cart/CartScreen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_storage/get_storage.dart';
import 'ApplicationCore.dart';
import 'env/Env.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppComponent extends StatefulWidget {
  final ApplicationCore application;

  AppComponent(this.application);

  @override
  State createState() {
    return new AppComponentState(application);
  }
}

class AppComponentState extends BaseStatefulState<AppComponent> {
  final ApplicationCore application;

  AppComponentState(this.application);

  // return DataConnectionChecker().onStatusChange;

  sendTokenToServer(token) async {
    var deviceId;

    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId; // unique ID on Android
    }
    GetStorage().write('fcm_token', token);
    if (token != null) {
      print('[${token}]');
      Future.delayed(Duration.zero, () {
        if (GetStorage().hasData('token'))
          apiBloc.doAction(param: {
            'method': 'post',
            'url': REGISTRATIONS_API,
            'reg_id': token,
            'os': Platform.isIOS ? 'ios' : 'android',
            'lang': GetStorage().read('lang'),
            'device_id': deviceId,
            'instance_uuid': GetStorage().read('uuid')
          }, supportLoading: false, supportErrorMsg: false);
      });
    }
  }

  @override
  void initState() {
    application.initState();
    Future.delayed(const Duration(milliseconds: 10), () {
      application.build(context);
    });

    FirebaseMessaging.instance.getToken().then((token) {
      print(token);
      sendTokenToServer(token);
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      sendTokenToServer(token);
    });
    Future.delayed(const Duration(milliseconds: 10), () {
      application.build(context);
    });
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await application.onTerminate();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: KeyboardDismissOnTap(
            child: MaterialApp(
      title: Env.value.appName,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return Stack(
          children: [
            child ?? SizedBox(),
            Consumer(
              builder: (context, watch, child) {
                final response = watch(cartActionsProvider);
                return response.when(idle: () {
                  return Container();
                }, loading: () {
                  return SizedBox();
                }, data: (data) {
                  return (data as CartAction).shouldShow()
                      ? Positioned(
                          bottom: 50.h,
                          left: 20.w,
                          child: Material(
                              color: Colors.transparent,
                              child: FloatingActionButton(
                                onPressed: () {
                                  GetIt.I
                                      .get<ApplicationCore>()
                                      .goTo(CartScreen.generatePath());
                                },
                                child: Badge(
                                    badgeContent: TextResponsive(
                                        data.data?.cart?.totalItems ?? '0'),
                                    badgeColor: Colors.white,
                                    child: Icon(CupertinoIcons.cart)),
                                backgroundColor:
                                    AppFactory.getColor('primary', toString()),
                              )),
                        )
                      : SizedBox();
                }, error: (e) {
                  return SizedBox();
                });
              },
            )
          ],
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
                bodyText1: TextStyle(),
                bodyText2: TextStyle(),
                headline6: TextStyle(),
                caption: TextStyle())
            .apply(
          bodyColor: AppFactory.getColor('primary', toString()),
          displayColor: Colors.blue,
          //  fontFamily: FontFamily.araHamahAlislam
        ),
        brightness: Brightness.dark,
        primaryColor: AppFactory.getColor('primary', toString()),
        accentColor: Colors.cyan[600],
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: GetIt.instance<FluroRouter>().generator,
    )));
  }
}
