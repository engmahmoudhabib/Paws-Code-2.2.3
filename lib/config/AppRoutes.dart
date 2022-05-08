import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/ui/orders/OrderDetailsScreen.dart';
import 'package:flutter_app/ui/orders/OrdersScreen.dart';
import 'package:flutter_app/ui/screen/NotFoundPage.dart';
import 'package:flutter_app/ui/screen/accounts/CompleteAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/EditAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/OTPScreen.dart';
import 'package:flutter_app/ui/screen/accounts/RatingResultScreen.dart';
import 'package:flutter_app/ui/screen/accounts/SignUpScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ResetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/cart/CartScreen.dart';
import 'package:flutter_app/ui/screen/chat/MessagesScreen.dart';
import 'package:flutter_app/ui/screen/dogs/AddDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/dogs/DetailsScreen.dart';
import 'package:flutter_app/ui/screen/dogs/OwnershipChangeScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticleDetailsScreen.dart';
import 'package:flutter_app/ui/screen/info/AboutScreen.dart';
import 'package:flutter_app/ui/screen/info/InfoScreen.dart';
import 'package:flutter_app/ui/screen/offers/AddOfferScreen.dart';
import 'package:flutter_app/ui/screen/offers/OffersScreen.dart';
import 'package:flutter_app/ui/screen/services/ActivateServicesScreen.dart';
import 'package:flutter_app/ui/screen/services/FullScreenMapScreen.dart';
import 'package:flutter_app/ui/screen/services/ServiceDetailsScreen.dart';
import 'package:flutter_app/ui/screen/services/WorkingHoursScreen.dart';
import 'package:flutter_app/ui/screen/startup/LanguageScreen.dart';
import 'package:flutter_app/ui/screen/startup/SplashScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';

//handlerFunc: (BuildContext context, Map<String, List<String>> params)

/*
var homeHandler = Handler(
  handlerFunc: (context, params) {
    final args = context.settings.arguments as MyArgumentsDataClass;

    return HomeComponent(args);
  },
  FluroRouter.appRouter.navigateTo(
  context,
  'home',
  routeSettings: RouteSettings(
    arguments: MyArgumentsDataClass('foo!'),
  ),
);
);*/

var rootHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return SplashScreen();
});

var languageHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return LanguageScreen();
});

var ownershipChangeHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return OwnershipChangeScreen();
});

var aboutHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return AboutScreen();
});

var messagesHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return MessagesScreen();
});

var serviceDetailsHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return ServiceDetailsScreen(
    params['id'][0],
  );
});

var activateServicesHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  var id;
  try {
    id = params['id'][0];
  } catch (e) {}
  return ActivateServicesScreen(
    id: id,
  );
});

var fullScreenMapHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  var args = context!.settings!.arguments as LatLng;

  return FullScreenMapScreen(args);
});

var workingHoursHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  var args = context!.settings!.arguments as List<dynamic>;

  return WorkingHoursScreen(data: args);
});

var offersHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return OffersScreen();
});

var articlesHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  try {
    return ArticlesScreen(
      params['initPage'][0] ?? '0',
      favorite: params['favorite'][0],
      initialId: params['initialId'] != null ? params['initialId'][0] : null,
    );
  } catch (e) {
    return ArticlesScreen(
      '0',
      favorite: params['favorite'][0],
      initialId: params['initialId'] != null ? params['initialId'][0] : null,
    );
  }
});

var articleDetailsHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  var args = context!.settings!.arguments as DataBeanArticle;

  return ArticleDetailsScreen(args);
});

var infoHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return InfoScreen(
    params['title'][0],
    params['desc'][0],
  );
});
var addOfferHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return AddOfferScreen();
});
var cartHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return CartScreen();
});

var SignInHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return LoginScreen(
    username: params['username'][0],
    password: params['password'][0],
  );
});
var homeHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return HomeScreen(
    pageId: params['pageId'][0],
  );
});

var ordersHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return OrdersScreen();
});

var detailsHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return DetailsScreen(
    params['id'][0],
  );
});

var addDogsCatsHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return AddDogsCatsScreen(
    id: params['id'][0],
  );
});

var SignUpHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return SignUpScreen(params['isServiceProvider'][0] == '1');
});

var forgetPasswordHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return ForgetPasswordScreen();
});

var orderDetailsHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return OrderDetailsScreen(
    params['id'][0],
  );
});

var resetPasswordHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return ResetPasswordScreen(
    params['userId'][0],
  );
});
var otpHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return OTPScreen(
    password: params['password'][0],
    username: params['username'][0],
  );
});

var editAccountHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return EditAccountScreen();
});

var ratingResultHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  return RatingResultScreen();
});

var completeAccountHandler =
    Handler(handlerFunc: (context, Map<String, dynamic> params) {
  try {
    final args = context?.settings?.arguments as AuthResponse;

    return CompleteAccountScreen(
      authResponse: args,
    );
  } catch (e) {}
});

class AppRoutes {
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler =
        Handler(handlerFunc: (context, Map<String, List<String>> params) {
      return NotFoundPage();
    });

    //startup
    router.define(SplashScreen.PATH, handler: rootHandler);
    router.define(LanguageScreen.PATH, handler: languageHandler);

    //cart

    router.define(CartScreen.PATH, handler: cartHandler);

    //accounts
    router.define(LoginScreen.PATH, handler: SignInHandler);
    router.define(SignUpScreen.PATH, handler: SignUpHandler);
    router.define(CompleteAccountScreen.PATH, handler: completeAccountHandler);
    router.define(ForgetPasswordScreen.PATH, handler: forgetPasswordHandler);
    router.define(OTPScreen.PATH, handler: otpHandler);
    router.define(ResetPasswordScreen.PATH, handler: resetPasswordHandler);
    router.define(EditAccountScreen.PATH, handler: editAccountHandler);
    router.define(RatingResultScreen.PATH, handler: ratingResultHandler);

    //home
    router.define(HomeScreen.PATH, handler: homeHandler);
//orders
    router.define(OrdersScreen.PATH, handler: ordersHandler);

    router.define(OrderDetailsScreen.PATH, handler: orderDetailsHandler);

    //dogs cats
    router.define(AddDogsCatsScreen.PATH, handler: addDogsCatsHandler);
    router.define(DetailsScreen.PATH, handler: detailsHandler);
    router.define(OwnershipChangeScreen.PATH, handler: ownershipChangeHandler);

    //info
    router.define(AboutScreen.PATH, handler: aboutHandler);
    router.define(InfoScreen.PATH, handler: infoHandler);

    //chat
    router.define(MessagesScreen.PATH, handler: messagesHandler);

    //services
    router.define(ActivateServicesScreen.PATH,
        handler: activateServicesHandler);
    router.define(ServiceDetailsScreen.PATH, handler: serviceDetailsHandler);
    router.define(FullScreenMapScreen.PATH, handler: fullScreenMapHandler);

    router.define(WorkingHoursScreen.PATH, handler: workingHoursHandler);

    //offers
    router.define(OffersScreen.PATH, handler: offersHandler);
    router.define(AddOfferScreen.PATH, handler: addOfferHandler);

    //Articles
    router.define(ArticlesScreen.PATH, handler: articlesHandler);
    router.define(ArticleDetailsScreen.PATH, handler: articleDetailsHandler);
  }
}
