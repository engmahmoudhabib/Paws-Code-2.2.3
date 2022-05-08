import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppComponent.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'ApiResult.dart';
import 'DioClient.dart';
import 'NetworkExceptions.dart';

const SERVICES_CENTER_API = 'v1/service-centers';
const BASICS = 'v1/basics';
const LOGIN_API = 'v1/login';
const REGISTER_API = 'v1/users';
const SOCIAL_LOGIN_API = 'v1/login-provider';
const COMPLETE_ACCOUNT_API = 'v1/user/complete';
const VERIFICATIONS_API = 'v1/users/';
const FORGET_PASSWORD_API = 'v1/verifications/reset-password';
const RESET_PASSWORD_API = 'v1/users/';
const UPDATE_ACCOUNT_API = 'v1/user/update';
const ARTICLES_API = 'v1/articles';
const NOTIFICATIONS_API = 'v1/notifications';
const PROFILE_API = 'v1/user';
const ENQUIRIES_API = 'v1/enquiries';
const UPDATE_USER_NAME_API = 'v1/user/update-username';
const LOGOUT_API = 'v1/logout';
const UPDATE_DEVICE_API = 'v1/registrations/update';
const REGISTRATIONS_API = 'v1/registrations';
const SERVICES_LIST_API = 'v1/service-centers';
const REVIEWS_LIST_API = 'v1/reviews';
const PRODUCTS_LIST_API = 'v1/products';
const FAVORITE_API = 'v1/favorites';
const ANIMALS_LIST_API = 'v1/animals';
const CART_API = 'v1/cart-items';
const CART_DATA_API = 'v1/cart';
const PROMO_CODE_API = 'v1/cart/promocode';
const SHIPPING_ADDRESS_API = 'v1/cart/shipping-address';
const ORDERS_LIST_API = 'v1/orders';

const REMOVE_ITEM_CART_API = 'v1/cart-items/';

const CART_SUBMIT_API = 'v1/cart/submit';

const ANIMALS_NOTE_API = 'v1/animal-notes';

const ATTACHMENTS_API = 'v1/attachments';
const SERVICE_DETAILS_API = 'v1/service-centers/';
const OFFERS_API = 'v1/offers';

class APIRepository {
  late DioClient dioClient;
  final GlobalKey<State> globalKeyAlertDialog = new GlobalKey<State>();
  bool isLoading = false;

  APIRepository() {
    var dio = Dio();
    dioClient = DioClient(dio);
  }

  Future<void> showLoadingDialog() async {
    isLoading = true;
    try {
      return showDialog<void>(
          context: GetIt.I<ApplicationCore>().getContext(),
          barrierDismissible: true,
          barrierColor: Colors.white.withOpacity(0.6),
          builder: (BuildContext context) {
            return new WillPopScope(
                onWillPop: () {
                  isLoading = false;
                  return Future.value(true);
                },
                child: SimpleDialog(
                    key: globalKeyAlertDialog,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    children: <Widget>[
                      Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /*SpinKitFadingCube(
                            color: Colors.white,
                            size: 30.0.w.toDouble(),
                          )*/
                              Assets.images.walkingPaws.image()
                            ]),
                      )
                    ]));
          }).then((value) => isLoading = false);
    } catch (e) {
      isLoading = false;
    }
  }

  stopLoadingDialog() {
    if (isLoading) {
      try {
        Navigator.pop(navigatorKey.currentState!.overlay!.context);
        isLoading = false;
      } catch (e) {}
    }
  }

  setHeader(String key, String value) {
    dioClient.setHeader(key, value);
  }

  removeHeader(String key) {
    dioClient.removeHeader(key);
  }

  Future<ApiResult<dynamic>> doAction(
      {required Map<String, dynamic> param,
      bool supportLoading = false,
      bool supportErrorMsg = true}) async {
    /*  if ( Provider.of<DataConnectionStatus>(
                GetIt.I<ApplicationCore>().getContext(),
                listen: false) ==
            DataConnectionStatus.disconnected &&
        param['method'] == 'post') {
      //GetIt.I<AppStoreApplication>().showWarningDialog('لايوجد اتصال انترنت');
      return ApiResult.failure(error: NetworkExceptions.noInternetConnection());
    } else*/
    try {
      var response;
      Map<String, dynamic> queryParameters = Map();

      if (supportLoading && !isLoading) showLoadingDialog();
      if (param['method'] == 'get')
        response = await dioClient.get(param['url'] ?? param['full-url'],
            queryParameters: param);
      else if (param['method'] == 'put')
        response = await dioClient.put(param['url'],
            data: param, queryParameters: queryParameters);
      else if (param['method'] == 'delete')
        response = await dioClient.delete(param['url'],
            data: param, queryParameters: queryParameters);
      else
        response = await dioClient.post(param['url'],
            data: param, queryParameters: queryParameters);

      stopLoadingDialog();
      try {
        if (response['code'] == '-401' &&
            param['url'] != 'user/authentication/signIn') {
        } else if (response['code'] == '-18') {
        } else if (response['code'] == -2) {}

        if (supportErrorMsg) {
          // GetIt.I<AppStoreApplication>().showErrorDialog(response['msg']);
        }
      } catch (e) {
        print(e.toString());
      }
      return ApiResult.success(data: response);
    } catch (e) {
      var msg = NetworkExceptions.getDioException(e);
      stopLoadingDialog();
      try {
        if (NetworkExceptions.getErrorMessage(msg).length > 0)
          showErrorDialog(NetworkExceptions.getErrorMessage(msg));
      } catch (e) {}
      return ApiResult.failure(error: msg);
    }
  }

  showErrorDialog(String msg) {
    AwesomeDialog(
      width: (DESIGN_WIDTH / 1.1).w,
      context: GetIt.I<ApplicationCore>().getContext(),
      dialogType: DialogType.ERROR,
      headerAnimationLoop: false,
      dialogBackgroundColor: Colors.white,
      animType: AnimType.SCALE,
      title: AppFactory.getLabel('error', 'حدث خطأ ما'),
      desc: msg,
      btnOkColor: AppFactory.getColor('primary', toString()),
      btnOkOnPress: () {},
    )..show();
  }

  showConfirmDialog(String msg, {VoidCallback? onDone}) {
    AwesomeDialog(
      width: (DESIGN_WIDTH / 1.1).w,
      context: GetIt.I<ApplicationCore>().getContext(),
      dialogType: DialogType.QUESTION,
      headerAnimationLoop: false,
      dialogBackgroundColor: Colors.white,
      animType: AnimType.SCALE,
      title: '',
      desc: msg,
      btnOkText: AppFactory.getLabel('cancel', 'موافق'),
      btnCancelOnPress: () {},
      btnCancelText: AppFactory.getLabel('cancel', 'الغاء'),
      btnOkColor: AppFactory.getColor('primary', toString()),
      btnOkOnPress: () {
        if (onDone != null) {
          onDone.call();
        }
      },
    )..show();
  }

  showSuccessDialog(String msg) {
    AwesomeDialog(
      width: (DESIGN_WIDTH / 1.1).w,
      context: GetIt.I<ApplicationCore>().getContext(),
      dialogType: DialogType.SUCCES,
      headerAnimationLoop: false,
      dialogBackgroundColor: Colors.white,
      animType: AnimType.SCALE,
      title: AppFactory.getLabel('success', 'تم بنجاح'),
      desc: msg,
      btnOkColor: AppFactory.getColor('primary', toString()),
      btnOkOnPress: () {},
    )..show();
  }

  void topFlash(String msg, {FlashBehavior style = FlashBehavior.floating}) {
    showFlash(
      context: GetIt.I<ApplicationCore>().getContext(),
      duration: const Duration(seconds: 5),
      persistent: true,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: style,
          position: FlashPosition.top,
          child: FlashBar(
            title: TextResponsive(AppFactory.getLabel('error', 'حدث خطأ ما'),
                style: TextStyle(color: Colors.red)),
            content: Padding(
              padding: EdgeInsetsResponsive.only(left: 10, right: 10),
              child: TextResponsive(msg),
            ),
            showProgressIndicator: false,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: TextResponsive(AppFactory.getLabel('dismiss', 'اخفاء'),
                  style: TextStyle(
                      fontFamily: FontFamily.araHamahAlislam,
                      color: AppFactory.getColor('primary', toString()))),
            ),
          ),
        );
      },
    );
  }
}
