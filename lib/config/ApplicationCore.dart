import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

import '../tools/abstracts/Application.dart';
import 'AppComponent.dart';
import 'AppConstants.dart';
import 'AppRoutes.dart';
import 'env/Env.dart';

class ApplicationCore implements Application {
  late ApiBloc apiBloc;

  @override
  Future<void> onCreate() async {
    if (!GetStorage().hasData('uuid')) {
      var uuid = Uuid();
      GetStorage().write('uuid', uuid.v1());
    }
    initLog();
    initRouter();
    setupLocator();
    try {
      apiBloc = GetIt.I.get<ApiBloc>();
    } catch (e) {}

    onStartAppRequests();
  }

  onStartAppRequests() async {
    apiBloc.doAction(
        param: {
          'method': 'get',
          'url': BASICS,
        },
        supportLoading: false,
        onResponse: (json) {
          try {
            GetStorage().write('basics', json);
          } catch (e) {}
        },
        supportErrorMsg: false);

    var deviceId;

    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId; // unique ID on Android
    }

    apiBloc.doAction(param: {
      'method': 'post',
      'url': REGISTRATIONS_API,
      'reg_id': GetStorage().read('fcm_token'),
      'os': Platform.isIOS ? 'ios' : 'android',
      'lang': GetStorage().read('lang'),
      'device_id': deviceId,
      'instance_uuid': GetStorage().read('uuid')
    }, supportLoading: false, supportErrorMsg: false);
  }

  @override
  initState() async {}

  setupLanguage(BuildContext context) {
    if (!GetStorage().hasData('lang')) {
      GetStorage().write('lang', DEFAULT_LANG);
      return;
    }
  }

  changeLanguage(String lang) {
    try {
      navigatorKey.currentState!.overlay!.context.setLocale(Locale(lang));
    } catch (e) {}
  }

  getContext() {
    try {
      return navigatorKey.currentState!.overlay!.context;
    } catch (e) {}
  }

  Future<void> setupLocator() async {
    GetIt.I.registerSingleton(APIRepository());
    /*   GetIt.I.registerFactory<ApiBloc>(() {
   //   print('[ApiBloc][created]');
      return ApiBloc();
    });*/
    GetIt.I.registerSingleton(ApiBloc());

    //
    GetIt.I.registerSingleton(Connectivity());
    GetIt.I.registerSingleton(this);

    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      GetIt.I.registerSingleton(androidInfo);
    } catch (e) {}
  }

  @override
  Future<void> onTerminate() async {
    apiBloc.dispose();
    GetIt.I.reset(dispose: true);
  }

  @override
  void build(context) {
    setupLanguage(context);
  }

  void initLog() {
    switch (Env.value.environmentType) {
      case EnvType.STAGING:
        {
          break;
        }
      case EnvType.PRODUCTION:
        {
          break;
        }
    }
  }

  goTo(path,
      {bool clearStack = false,
      bool replace = false,
      TransitionType transition = TransitionType.native,
      dynamic data,
      Function(dynamic)? onResponse}) {
    try {
      GetIt.I
          .get<FluroRouter>()
          .navigateTo(getContext(), path,
              routeSettings: RouteSettings(arguments: data),
              replace: replace,
              clearStack: clearStack,
              transition: transition)
          .then((value) {
        if (onResponse != null) {
          onResponse.call(value);
        }
      });
    } catch (e) {}
  }

  void initRouter() {
    FluroRouter router = new FluroRouter();
    AppRoutes.configureRoutes(router);
    GetIt.I.registerSingleton(router);
  }
}
