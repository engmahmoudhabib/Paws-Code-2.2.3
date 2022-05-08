import 'dart:async';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppComponent.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/models/api/CartData.dart';
import 'package:flutter_app/models/api/OrderDetailsResponse.dart';
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_app/providers/CartDataProvider.dart';
import 'package:flutter_app/providers/OrdersProvider.dart';
import 'package:flutter_app/providers/PromoCodeProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/ChangeUsernameDialog.dart';
import 'package:flutter_app/ui/dialogs/EnterPasswordDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_app/ui/screen/info/InfoScreen.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/ProfileTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsTypsWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_app/ui/widget/date_piker/src/i18n_model.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String PATH = '/order-details-screen';
  final String id;

  OrderDetailsScreen(this.id);

  static String generatePath(String id) {
    Map<String, dynamic> parameters = {'id': id};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends BaseStatefulState<OrderDetailsScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  late AuthResponse authResponse;
  final shippingFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    authResponse = AuthResponse.fromMap(GetStorage().read('account'));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read(ordersDetailsProvider.notifier).getDetails(widget.id);
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
        child: WillPopScope(
            onWillPop: () {
              context.read(cartActionsProvider.notifier).showCart();
              return Future.value(true);
            },
            child: Scaffold(
              backgroundColor: AppFactory.getColor('background', toString()),
              body: Stack(
                children: [
                  KeyboardVisibilityBuilder(
                      builder: (context, isKeyboardVisible) {
                    return !isKeyboardVisible ? RightLeftWidget() : Container();
                  }),
                  Column(
                    children: [
                      SizedBox(
                        height: AppFactory.getDimensions(
                                40, toString() + '-systemNavigationBarMargin')
                            .h,
                      ),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsetsResponsive.only(top: 5),
                              child: buildMainTitle(AppFactory.getLabel(
                                      'order_details', 'فاتورة التسوق')
                                  //+
                                  // ' ( ${widget.id} )'
                                  ),
                            ),
                          ),
                          buildBackBtn(context, beforBackAction: () {
                            context
                                .read(cartActionsProvider.notifier)
                                .showCart();
                          }, color: AppFactory.getColor('primary', toString())),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Consumer(
                                  builder: (context, watch, child) {
                                    final response =
                                        watch(ordersDetailsProvider);
                                    return response.when(idle: () {
                                      return Container();
                                    }, loading: () {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsetsResponsive.only(
                                            bottom: 10, top: 10),
                                        itemBuilder: (context, index) =>
                                            ArticleLoaderItem(),
                                        itemCount: 10,
                                      );
                                    }, data: (map) {
                                      OrderDetailsResponse data =
                                          OrderDetailsResponse.fromJson(map);
                                      try {
                                        return (data.data?.items?.length ?? 0) >
                                                0
                                            ? Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .all(15),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Column(
                                                      children: [
                                                        index ==
                                                                (data
                                                                        .data
                                                                        ?.items
                                                                        ?.length ??
                                                                    0)
                                                            ? DeliveryItem(data
                                                                    .data
                                                                    ?.shippingCosts
                                                                    ?.formatted ??
                                                                '')
                                                            : ServiceItem(
                                                                () {},
                                                                data.data!
                                                                        .items![
                                                                    index],
                                                                (number) {
                                                                  launchCaller(
                                                                      number);
                                                                },
                                                              )
                                                      ],
                                                    ),
                                                    itemCount: (data.data?.items
                                                                ?.length ??
                                                            0) +
                                                        1,
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 0.1.w,
                                                      color: Color(0xff707070),
                                                      width: 309.w,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.w,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(
                                                                left: 30,
                                                                right: 30),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextResponsive(
                                                          'السعر النهائي:  IQD${(double.parse(data.data?.productsPrice?.value ?? '0') + double.parse(data.data?.shippingCosts?.value ?? '0')).toString()}',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'roboto',
                                                            color: const Color(
                                                                0xff707070),
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                        SizedBox(
                                                          height: 15.w,
                                                        ),
                                                        double.parse(data
                                                                        .data
                                                                        ?.promocodeDiscountAmount
                                                                        ?.value ??
                                                                    '0') >
                                                                0
                                                            ? Column(
                                                                children: [
                                                                  TextResponsive(
                                                                    'السعر النهائي بعد الخصم:  IQD${double.parse(data.data?.totalAmount?.value ?? '0').toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'roboto',
                                                                      color: const Color(
                                                                          0xffe31414),
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        10.w,
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox(),
                                                        double.parse(data
                                                                        .data
                                                                        ?.promocodeDiscountAmount
                                                                        ?.value ??
                                                                    '0') >
                                                                0
                                                            ? TextResponsive(
                                                                'قيمة خصم الكوبون:  ${data.data?.promocodeDiscountAmount?.formatted}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'roboto',
                                                                  color: const Color(
                                                                      0xffe31414),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              )
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.w,
                                                  ),
                                                  Center(
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsResponsive
                                                                .all(20),
                                                        child: TextResponsive(
                                                          'سياسة البيع',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: const Color(
                                                                0xff3876ba),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        goTo(InfoScreen.generatePath(
                                                            'سياسة البيع',
                                                            GetStorage().read(
                                                                        'basics')[
                                                                    'about_app']
                                                                [
                                                                'selling_policy']));
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 50.w,
                                                  ),
                                                  data.data?.state?.id ==
                                                          'pending'
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsetsResponsive
                                                                  .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                          child: InkWell(
                                                            onTap: () {
                                                              context
                                                                  .read(ordersDetailsProvider
                                                                      .notifier)
                                                                  .cancelOrder(
                                                                      widget
                                                                          .id);
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.0.w),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10.0.w),
                                                                ),
                                                                color: AppFactory
                                                                    .getColor(
                                                                        'orange',
                                                                        toString()),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(
                                                                        0x29000000),
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            3),
                                                                    blurRadius:
                                                                        6,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    TextResponsive(
                                                                  'الغاء الطلب',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: const Color(
                                                                        0xffffffff),
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                              ),
                                                              height: 62.w,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 100.w,
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      } catch (e) {
                                        print(e.toString());
                                        return Container();
                                      }
                                    }, error: (e) {
                                      return Container();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))));
  }

  Container buildEmptyCircle() {
    return Container(
      width: AppFactory.getDimensions(24, toString()).w,
      height: AppFactory.getDimensions(24, toString()).w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: AppFactory.getDimensions(0.3, toString()).w,
          color: AppFactory.getColor('gray', toString()),
        ),
      ),
    );
  }

  Container buildFullCircle() {
    return Container(
      alignment: Alignment.center,
      width: AppFactory.getDimensions(24, toString()).w,
      height: AppFactory.getDimensions(24, toString()).w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: AppFactory.getDimensions(0.3, toString()).w,
          color: AppFactory.getColor('gray_1', toString()),
        ),
      ),
      child: Container(
        width: AppFactory.getDimensions(18, toString()).w,
        height: AppFactory.getDimensions(18, toString()).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppFactory.getColor('orange', toString()),
        ),
      ),
    );
  }
}

class DeliveryItem extends StatelessWidget {
  final String price;

  DeliveryItem(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsResponsive.only(top: 10),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            margin: EdgeInsets.only(right: 70.w),
            child: Assets.images.servicesIcBack.image(),
          ),
          Positioned(
            right: 8.w,
            top: 20.w,
            child: Container(
                width: 90.w,
                height: 90.w,
                child: CircularProfileAvatar(
                  // item.mainImage?.conversions?.large?.url ?? '',
                  '',
                  child: Padding(
                    padding: EdgeInsetsResponsive.all(15),
                    child: Assets.images.cartIc.image(),
                  ),
                  backgroundColor: AppFactory.getColor('primary', toString()),
                  borderWidth: 0,
                  radius: 1000.w,
                  placeHolder: (context, url) => ImageLoaderPlaceholder(),
                  borderColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.transparent,
                  cacheImage: true,
                  showInitialTextAbovePicture:
                      false, // setting it true will show initials text above profile picture, default false
                )),
          ),
          Positioned.fill(
            right: 130.w,
            bottom: 10.w,
            left: 10.w,
            top: 8.w,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextResponsive(
                        'سعر التوصيل',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color(0xff3876ba),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      TextResponsive(
                        'السعر:  ${price}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'roboto',
                          color: const Color(0xff707070),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final VoidCallback onTap;
  final OrderDetailsResponseDataItems item;
  final Function(String) onCall;

  ServiceItem(this.onTap, this.item, this.onCall);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsResponsive.only(top: 15),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              margin: EdgeInsets.only(right: 70.w),
              child: Assets.images.servicesIcBack.image(),
            ),
            Positioned(
              right: 6.w,
              top: 20.w,
              child: Container(
                  width: 90.w,
                  height: 90.w,
                  child: CircularProfileAvatar(
                    item.image?.conversions?.large?.url ?? '',

                    initialsText: TextResponsive(
                      item.title?.substring(0, 1) ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    backgroundColor: AppFactory.getColor('primary', toString()),
                    borderWidth: 0,
                    radius: 1000.w,
                    placeHolder: (context, url) => ImageLoaderPlaceholder(),
                    borderColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.transparent,
                    cacheImage: true,
                    showInitialTextAbovePicture:
                        false, // setting it true will show initials text above profile picture, default false
                  )),
            ),
            Positioned.fill(
              right: 120.w,
              bottom: 15.w,
              left: 20.w,
              top: 9.w,
              child: Padding(
                padding: EdgeInsetsResponsive.only(top: 5, bottom: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextResponsive(
                            item.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1,
                              fontSize:
                                  AppFactory.getFontSize(18.0, toString()),
                              color: AppFactory.getColor('primary', toString()),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        /*  Flexible(
                          child: Row(
                            children: [
                              Container(
                                width: 7.0.w,
                                height: 8.0.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(3.5.w, 4.0.w)),
                                    color: Colors.green),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextResponsive(
                                  item. ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Flexible(
                          child: TextResponsive(
                            'السعر :${item.unitPrice?.formatted?.toString()}',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'roboto',
                              fontSize:
                                  AppFactory.getFontSize(13.0, toString()),
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Flexible(
                          child: TextResponsive(
                            'الكمية:${item.totalQuantity?.toString()}',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'roboto',
                              fontSize:
                                  AppFactory.getFontSize(13.0, toString()),
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Flexible(
                          child: TextResponsive(
                            'السعر الكلي:${item.totalPrice?.formatted?.toString()}',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'roboto',
                              fontSize:
                                  AppFactory.getFontSize(13.0, toString()),
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
