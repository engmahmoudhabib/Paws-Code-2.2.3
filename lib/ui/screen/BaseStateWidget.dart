import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/NetworkExceptions.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/models/api/AnimalDetailsModel.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_app/providers/CartDataProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/accounts/CompleteAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/OTPScreen.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/gallery.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'accounts/LoginScreen.dart';
import 'home/HomeScreen.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseStatefulState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  late ApiBloc apiBloc;
  ValueNotifier<dynamic> status = ValueNotifier(null);
  ValueNotifier<List<dynamic>> dataModel = ValueNotifier([]);

  Stack buildBanner(AnimalsDetails data, BuildContext context,
      {bool animation = true}) {
    return Stack(
      children: [
        data.data?.getMedia().length > 0
            ? MainSliderWidget(
                data: data.data?.getMedia(),
                supportRound: true,
                supportAuto: animation,
              )
            : SizedBox(),
        Positioned(
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: EdgeInsetsResponsive.all(5),
                  child: data.data?.reactions?.isFavorited ?? false
                      ? SvgPicture.string(
                          '<svg viewBox="26.3 361.0 15.8 13.9" ><path transform="translate(26.27, 358.75)" d="M 14.30443096160889 3.195546627044678 C 12.60875797271729 1.750511884689331 10.08691024780273 2.010432481765747 8.530481338500977 3.61637020111084 L 7.920905590057373 4.244511604309082 L 7.31132984161377 3.61637020111084 C 5.75799560546875 2.010432481765747 3.233052492141724 1.750511884689331 1.53738009929657 3.195546627044678 C -0.4058356583118439 4.854087352752686 -0.5079473853111267 7.830796241760254 1.231045126914978 9.628580093383789 L 7.218501091003418 15.81097793579102 C 7.605287551879883 16.21014213562012 8.233428955078125 16.21014213562012 8.62021541595459 15.81097793579102 L 14.60767078399658 9.628581047058105 C 16.34976005554199 7.83079719543457 16.24764633178711 4.854088306427002 14.30443000793457 3.195547580718994 Z" fill="#e31414" stroke="#e31414" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                          width: 16.w,
                          height: 14.w,
                        )
                      : // Adobe XD layer: 'Icon awesome-heart' (shape)
                      SvgPicture.string(
                          '<svg viewBox="24.0 490.1 15.8 13.9" ><path transform="translate(24.0, 487.89)" d="M 14.30443096160889 3.195546627044678 C 12.60875797271729 1.750511884689331 10.08691024780273 2.010432481765747 8.530481338500977 3.61637020111084 L 7.920905590057373 4.244511604309082 L 7.31132984161377 3.61637020111084 C 5.75799560546875 2.010432481765747 3.233052492141724 1.750511884689331 1.53738009929657 3.195546627044678 C -0.4058356583118439 4.854087352752686 -0.5079473853111267 7.830796241760254 1.231045126914978 9.628580093383789 L 7.218501091003418 15.81097793579102 C 7.605287551879883 16.21014213562012 8.233428955078125 16.21014213562012 8.62021541595459 15.81097793579102 L 14.60767078399658 9.628581047058105 C 16.34976005554199 7.83079719543457 16.24764633178711 4.854088306427002 14.30443000793457 3.195547580718994 Z" fill="none" stroke="#e31414" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                          width: 16.w,
                          height: 14.w,
                        ),
                ),
                onTap: () {
                  if (GetStorage().hasData('token'))
                    apiBloc.doAction(
                        param: BaseStatefulState.addServiceInfo(Map(), data: {
                          'method': 'post',
                          'url': FAVORITE_API,
                          'type': 'animal',
                          'favoriateable_id': data.data?.id.toString(),
                          'status':
                              !(data.data?.reactions?.isFavorited ?? false)
                        }),
                        supportLoading: true,
                        supportErrorMsg: false,
                        onResponse: (json) {
                          if (isSuccess(json)) {
                            context
                                .read(animalsProvider.notifier)
                                .updateFavoriteState(
                                    data.data?.id?.toString() ?? '-1',
                                    !(data.data?.reactions?.isFavorited ??
                                        false));
                            context
                                .read(animalsDetailsProvider.notifier)
                                .updateFavoriteState(
                                    data.data?.id?.toString() ?? '-1',
                                    !(data.data?.reactions?.isFavorited ??
                                        false));
                          }
                        });
                  else
                    goTo(LoginScreen.generatePath(),
                        transition: TransitionType.inFromTop);
                },
              ),
              SizedBox(
                height: 10.w,
              ),
              InkWell(
                child: buildCircleIconBtnSmall(
                  Padding(
                    padding: EdgeInsetsResponsive.all(0),
                    child: Assets.icons.iconAwesomeShareAlt.svg(
                      width: 15.w,
                      height: 15.w,
                    ),
                  ),
                  color: Colors.transparent,
                ),
                onTap: () {
                  Share.share(
                      'check out my website ${data.data?.shareUrl ?? ''}',
                      subject: 'Look what I made!');
                },
              ),
            ],
          ),
          left: 30.w,
          top: 50.w,
        )
      ],
    );
  }

  getStates() {
    try {
      List t = copy(GetStorage().read('basics')['enums']['animal_statuses']);
      if (context.read(animalsProvider.notifier).tags != null)
        for (var element in t) {
          element['selected'] = false;

          for (var tag in context.read(animalsProvider.notifier).tags) {
            if ((tag['id'] == element['id']) && tag['selected']) {
              // element['selected'] = true;
            }
          }
        }

      /* t.insert(0, {
        'id': 'all',
        'margin-left': 48.w,
        'selected': context.read(animalsProvider.notifier).tags == null,
        'name': AppFactory.getLabel('all', 'الكل'),
      });*/
      return t;
    } catch (e) {
      return [];
    }
  }

  uploadFile(file) async {
    Completer completer = Completer<dynamic>();
    apiBloc.doAction(
        param: BaseStatefulState.addServiceInfo(Map(), data: {
          'url': ATTACHMENTS_API,
          'method': 'post',
          'file': await getImageMultiPart(file),
        }),
        supportLoading: true,
        supportErrorMsg: false,
        onResponse: (json) {
          completer
              .complete({'id': json['data']['id'], 'url': json['data']['url']});
        });
    return completer.future;
  }

  Widget buildDocumentType(String name, Widget icon) {
    return Container(
      margin: EdgeInsetsResponsive.only(left: 5, right: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 47.0.w,
            height: 43.0.w,
            child: icon,
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 100.w),
            child: TextResponsive(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.0,
                color: AppFactory.getColor('primary', toString()),
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  buildKeyValue(String key, String value, {bool forceView = false}) {
    return value.length > 0 || forceView
        ? Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextResponsive(
                key,
                style: TextStyle(
                  fontSize: AppFactory.getFontSize(18, toString()),
                  color: const Color(0xff707070),
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 5.w,
              ),
              TextResponsive(
                value,
                style: TextStyle(
                    fontSize: AppFactory.getFontSize(16, toString()),
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              )
            ],
          )
        : SizedBox();
  }

  getImageMultiPart(File file) async {
    return MultipartFile(file.openRead(), await file.length(),
        filename: path.basename(file.path));
  }

  getServiceCenterId() {
    try {
      return AuthResponse.fromMap(GetStorage().read('account'))
              .data
              ?.serviceProvider['service_center']['id']
              .toString() ??
          null;
    } catch (e) {
      return null;
    }
  }

  launchCaller(String number) async {
    var url = "tel:${number}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchViber(String number) async {
    var url = "viber://contact?number=${number}";
    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch("viber://chat?number=${number}")) {
      await launch("viber://chat?number=${number}");
    } else {
      throw 'Could not launch $url';
    }
  }

  /*

  For IOS only : Add this code to info.plist under Runner folder in ios folder
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>whatsapp</string>
</array>
   */

  void launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  Container buildCircleIconBtnSmall(Widget icon, {Color? color}) {
    return Container(
      width: 22.w,
      margin: EdgeInsetsResponsive.all(2),
      height: 22.w,
      child: Center(
        child: icon,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
        color: color ?? AppFactory.getColor('orange', toString()),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }

  Container buildCircleIconBtn(Widget icon) {
    return Container(
      width: 35.w,
      margin: EdgeInsetsResponsive.all(7),
      height: 35.w,
      child: Center(
        child: icon,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
        color: const Color(0xff3876ba),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }

  List<dynamic> copy(List<dynamic> list) {
    List<dynamic> copyList = [];
    for (var item in list) {
      var betItems = {
        'id': item['id'],
        'is_hybrid': item['is_hybrid'],
        'animal_type': item['animal_type'],
        'children': item['children'],
        'name': item['title'] ?? item['name'] ?? item['value'] ?? item['desc']
      };
      copyList.add(betItems);
    }
    return copyList;
  }

  InkWell buildOrangeBtn(String name, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 303.0.w,
        height: 56.0.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
          color: AppFactory.getColor('orange', toString()),
          boxShadow: [
            BoxShadow(
              color: AppFactory.getColor('gray', toString()).withOpacity(0.12),
              offset: Offset(0, 2.0),
              blurRadius: 14.0,
            ),
          ],
        ),
        child: Center(
          child: TextResponsive(
            name,
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static Map<String, dynamic> addServiceInfo(Map<String, dynamic> map,
      {Map<String, dynamic>? data}) {
    data!.forEach((key, value) {
      map[key] = value;
    });
    return map;
  }

  showFlash(String msg) {
    // GetIt.I<APIRepository>().topFlash(msg);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor:
            AppFactory.getColor('primary', toString()).withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0.h);
  }

  String errorText() => '   ' + AppFactory.getLabel('required', 'مطلوب');

  String errorNotMatch() =>
      '   ' + AppFactory.getLabel('not_match', 'كلمتا المرور غير متطابقتين');

  String getHintMobile() {
    return '(07xxxxxxxxx)';
  }

  TextResponsive buildMobilePreIcon() {
    return TextResponsive(
      '٩٦٤' + '+',
      style: TextStyle(
          fontSize: AppFactory.getFontSize(20, toString()),
          height: 2,
          color: AppFactory.getColor('primary', toString())),
      textAlign: TextAlign.center,
    );
  }

  TextResponsive buildMainTitle(String msg) {
    return TextResponsive(
      msg,
      style: TextStyle(
          fontSize: AppFactory.getFontSize(25, toString()),
          color: AppFactory.getColor('primary', toString())),
      textAlign: TextAlign.center,
    );
  }

  isSuccess(json) {
    try {
      return json['message']['type'] == 'success';
    } catch (e) {}
    return false;
  }

  handlerResponseMsg(json) {
    try {
      json['message']['type'] == 'success'
          ? GetIt.I<APIRepository>().showSuccessDialog(json['message']['text'])
          : GetIt.I<APIRepository>().showErrorDialog(json['message']['text']);
    } catch (e) {}
  }

  handlerLogin(json,
      {bool supportRedirect = true, String? username, String? password,bool isRegister=false}) {
    var authResponse;

    authResponse = AuthResponse.fromMap(json);

    GetStorage().write('account', json);

    if (authResponse.token != null) {
      GetStorage().write('token', authResponse.token);
    }
    if (supportRedirect) if (authResponse.message!.isSuccess()) {
      if (authResponse.data!.user!.status!.id == 'unverified') {
        // goTo(OTPScreen.generatePath(password: password, username: username),
        //   data: authResponse);
        //  goTo(
        //  LoginScreen.generatePath(password: password, username: username),
        // );
        goTo(HomeScreen.generatePath(pageId: 'home'), clearStack: true);
      } else if (authResponse.data!.user!.status!.id == 'uncompleted') {
        // goTo(CompleteAccountScreen.generatePath(), data: authResponse);
        if(isRegister)
        goTo(
            LoginScreen.generatePath(password: password, username: username),
           );
        else
        goTo(CompleteAccountScreen.generatePath(),
            data: authResponse, clearStack: true);
      } else {
        context.read(cartDataProvider.notifier).load();

        goTo(HomeScreen.generatePath(pageId: 'home'), clearStack: true);
      }
    }
  }

  buildWrapSectionTitle(String msg,
      {TextAlign? textAlign, double? top, double? bottom, double? size}) {
    return Container(
      margin: EdgeInsetsResponsive.only(
          top: top ?? 20, bottom: bottom ?? 20, left: 15, right: 15),
      child: TextResponsive(
        msg,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: AppFactory.getColor('primary', toString()),
        ),
        textAlign: textAlign ?? TextAlign.start,
      ),
    );
  }

  buildImageWidget(String url) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            barrierColor: Colors.transparent,
            barrierDismissible: true,
            useSafeArea: false,
            builder: (_) => PhotoViewGalleryFragment([
                  {'url': url}
                ]));
      },
      child: Container(
          height: 113.0.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    AppFactory.getColor('gray_1', toString()).withOpacity(0.12),
                offset: Offset(0, 2.0),
                blurRadius: 12.0,
              ),
            ],
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0.w),
              ),
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => ImageLoaderPlaceholder(),
                errorWidget: (context, url, error) => ImageLoaderErrorWidget(),
              ))),
    );
  }

  buildSectionTitle(String msg,
      {TextAlign? textAlign,
      Color? color,
      double? top,
      double? left,
      double? right,
      double? bottom,
      double? size}) {
    return Container(
      margin: EdgeInsetsResponsive.only(
          top: top ?? 25,
          bottom: bottom ?? 15,
          left: left ?? 20,
          right: right ?? 20),
      child: Row(
        children: [
          Expanded(
            child: TextResponsive(
              msg,
              style: TextStyle(
                fontSize: size ?? 20.0,
                fontWeight: FontWeight.w500,
                color: color ?? AppFactory.getColor('primary', toString()),
              ),
              textAlign: textAlign ?? TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Align buildBackBtn(BuildContext context,
      {Color? color, VoidCallback? beforBackAction}) {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () {
          if (beforBackAction != null) {
            beforBackAction.call();
          }
          Navigator.pop(context);
        },
        child: Container(
          margin:
              EdgeInsetsResponsive.only(left: 20, right: 0, top: 5, bottom: 5),
          padding: EdgeInsetsResponsive.all(10),
          child: Assets.icons.iconIonicIosArrowRoundBack.svg(
              color: color,
              width: AppFactory.getDimensions(20, toString()).w,
              height: AppFactory.getDimensions(14, toString()).h),
        ),
      ),
    );
  }

  TextResponsive buildSubTitle(String msg) {
    return TextResponsive(
      msg,
      style: TextStyle(
          fontSize: AppFactory.getFontSize(20, toString()),
          color: AppFactory.getColor('gray_1', toString())),
      textAlign: TextAlign.center,
    );
  }

  goTo(path,
      {bool clearStack = false,
      bool replace = false,
      TransitionType transition = TransitionType.none,
      dynamic data,
      Function(dynamic)? onResponse}) {
    try {
      GetIt.I.get<ApplicationCore>().goTo(path,
          replace: replace,
          clearStack: clearStack,
          transition: transition,
          data: data,
          onResponse: onResponse);
    } catch (e) {}
  }

  errorWidget(NetworkExceptions error) {
    return Column(
      children: [
        Image.asset(
          'assets/images/error_ic.png',
        ),
        Center(
          child: Text(
            NetworkExceptions.getErrorMessage(error),
          ),
        )
      ],
    );
  }

  Widget handledWidget(widget) {
    return ResponsiveWidgets.builder(
        height: DESIGN_HEIGHT, // Optional
        width: DESIGN_WIDTH, // Optional
        allowFontScaling: false, // Optional
        child: widget);
  }

  preBuild(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: DESIGN_HEIGHT, // Optional
      width: DESIGN_WIDTH, // Optional
      allowFontScaling: false, // Optional
    );
  }

  emptyWidget({String msg = ''}) {
    return Container(
        margin: EdgeInsetsResponsive.only(top: 100),
        child: buildMainTitle(msg));
  }

  @override
  void dispose() {
    apiBloc.dispose();
    status.dispose();
    dataModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    try {
      apiBloc = GetIt.I.get<ApiBloc>();
    } catch (e) {}
    super.initState();
  }
}

class ImageLoaderErrorWidget extends StatelessWidget {
  const ImageLoaderErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.error);
  }
}

getBaseColor() {
  return Colors.grey[300];
}

getHighlightColor() {
  return Colors.grey[100];
}

class ImageLoaderPlaceholder extends StatelessWidget {
  const ImageLoaderPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Shimmer.fromColors(
            baseColor: getBaseColor(),
            highlightColor: getHighlightColor(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.white,
              ),
            )));
  }
}
