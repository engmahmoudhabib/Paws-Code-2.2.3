import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

import '../AppComponent.dart';
import '../AppFactory.dart';
import '../ApplicationCore.dart';
import 'package:flutter/foundation.dart';

import '../ConstantsWidget.dart';

enum EnvType { STAGING, PRODUCTION }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//---------------NOTIFICATIONS --------------------------

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  var params = <String, dynamic>{
    'id': 'klj87hgkjgh',
    'nameCaller': 'Hien Nguyen',
    'appName': 'Callkit',
    'avatar': 'https://i.pravatar.cc/100',
    'handle': '0123456789',
    'type': 0,
    'duration': 30000,
    'extra': <String, dynamic>{'userId': '1a2b3c4d'},
    'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    'android': <String, dynamic>{
      'isCustomNotification': true,
      'isShowLogo': false,
      'ringtonePath': 'ringtone_default',
      'backgroundColor': '#0955fa',
      'backgroundUrl': 'https://i.pravatar.cc/500',
      'actionColor': '#4CAF50'
    },
    'ios': <String, dynamic>{
      'iconName': 'AppIcon40x40',
      'handleType': 'generic',
      'supportsVideo': true,
      'maximumCallGroups': 2,
      'maximumCallsPerCallGroup': 1,
      'audioSessionMode': 'default',
      'audioSessionActive': true,
      'audioSessionPreferredSampleRate': 44100.0,
      'audioSessionPreferredIOBufferDuration': 0.005,
      'supportsDTMF': true,
      'supportsHolding': true,
      'supportsGrouping': false,
      'supportsUngrouping': false,
      'ringtonePath': 'Ringtone.caf'
    }
  };

  await FlutterCallkitIncoming.showCallkitIncoming(params);
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class Env {
  static late Env value;

  late String appName;
  late String baseUrl;
  late Color primarySwatch;
  EnvType environmentType = EnvType.STAGING;

  // Database Config
  int dbVersion = 1;
  late String dbName;

  Env() {
    value = this;
    initApp();
  }

  void initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (EnvType.STAGING == environmentType) {
        //  return ErrorWidget(details.exception);
      }
      return Material(
        color: Colors.transparent,
        child: Card(
          color: Colors.white,
          elevation: 5,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Assets.images.notFound.image(),
                    margin: EdgeInsets.only(left: 50, right: 50, top: 50),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      details.exception.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };

    if (EnvType.STAGING == environmentType) {}
    await GetStorage.init();
    if (!GetStorage().hasData('lang')) GetStorage().write('lang', DEFAULT_LANG);
    await setupNotifications();

    var application = ApplicationCore();
    await application.onCreate();
    try {
      HttpOverrides.global = MyHttpOverrides();
    } catch (e) {}

    runApp(EasyLocalization(
        supportedLocales:
            AppFactory.getSupportedLang().map((e) => Locale(e)).toList(),
        path: 'assets/translations',
        fallbackLocale: Locale(DEFAULT_LANG),
        startLocale: Locale(DEFAULT_LANG),
        useOnlyLangCode: true,
        child: ConstantsWidget(child: AppComponent(application))));
  }

  setupNotifications() async {
    await Firebase.initializeApp();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Note: permissions aren't requested here just to demonstrate that can be
      /// done later
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: false,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          try {
            showDialog(
              context: navigatorKey.currentState!.overlay!.context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(title ?? ''),
                content: Text(body ?? ''),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Ok'),
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  )
                ],
              ),
            );
          } catch (e) {}
        },
      );

      const MacOSInitializationSettings initializationSettingsMacOS =
          MacOSInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: false,
              requestSoundPermission: true);
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS,
              macOS: initializationSettingsMacOS);

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      try {
        // GetIt.I.get<Logger>().i(message.data);
      } catch (e) {}

      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: '@mipmap/launcher_icon',
              ),
            ));
      }
    });
  }
}
