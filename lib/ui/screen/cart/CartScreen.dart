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
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_app/providers/CartDataProvider.dart';
import 'package:flutter_app/providers/PromoCodeProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/ChangeUsernameDialog.dart';
import 'package:flutter_app/ui/dialogs/EnterPasswordDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
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

class CartScreen extends StatefulWidget {
  static const String PATH = '/cart-screen';

  CartScreen();

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends BaseStatefulState<CartScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  late AuthResponse authResponse;
  final shippingFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    authResponse = AuthResponse.fromMap(GetStorage().read('account'));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read(cartActionsProvider.notifier).hiddenCart();
      context.read(cartDataProvider.notifier).load();
      context
              .read(cartActionsProvider.notifier)
              .shippingParam['governorate_id'] =
          authResponse.data?.location?['governorate'] != null
              ? authResponse.data?.location['governorate']['id']
              : null;
    });
    super.initState();
  }

  TextEditingController? promoCode;

  @override
  void dispose() {
    promoCode?.dispose();
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
                                60, toString() + '-systemNavigationBarMargin')
                            .h,
                      ),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsetsResponsive.only(top: 5),
                              child: buildMainTitle(
                                  AppFactory.getLabel('cart', 'السلة')),
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
                                    final response = watch(cartDataProvider);
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
                                      CartData data = CartData.fromJson(map);
                                      try {
                                        if (!context
                                            .read(cartActionsProvider.notifier)
                                            .shippingParam
                                            .containsKey('governorate_id'))
                                          context
                                              .read(
                                                  cartActionsProvider.notifier)
                                              .shippingParam['governorate_id'] = (data
                                                          .data
                                                          ?.shippingAddress ??
                                                      null) !=
                                                  null
                                              ? data.data?.shippingAddress[
                                                  'governorate']['id']
                                              : authResponse.data?.location?[
                                                          'governorate'] !=
                                                      null
                                                  ? authResponse.data
                                                          ?.location['governorate']
                                                      ['id']
                                                  : null;

                                        try {
                                          if (promoCode == null) {
                                            promoCode = TextEditingController();
                                            promoCode?.text =
                                                data.data?.promocode?['code'] ??
                                                    '';
                                          }
                                        } catch (e) {}
                                        return (data.data?.items?.length ?? 0) >
                                                0
                                            ? Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Form(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsResponsive
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                            child: buildMainTitle(
                                                                'عنوان التوصيل'),
                                                          ),
                                                          SizedBox(
                                                            height: 20.w,
                                                          ),
                                                          Center(
                                                            child: AppTextField(
                                                              isDropDown: true,
                                                              width: 329.w,
                                                              onSelectedValue:
                                                                  (city) {
                                                                context
                                                                    .read(cartActionsProvider
                                                                        .notifier)
                                                                    .shippingParam['governorate_id'] = city['id'];
                                                              },
                                                              supportDecoration:
                                                                  true,
                                                              value: (data.data
                                                                              ?.shippingAddress ??
                                                                          null) !=
                                                                      null
                                                                  ? (data.data?.shippingAddress ??
                                                                              null)[
                                                                          'governorate']
                                                                      ['name']
                                                                  : authResponse.data?.location?[
                                                                              'governorate'] !=
                                                                          null
                                                                      ? authResponse
                                                                          .data
                                                                          ?.location['governorate']['name']
                                                                      : '',
                                                              items: GetStorage()
                                                                      .read(
                                                                          'basics')[
                                                                  'governorates'],
                                                              name: AppFactory
                                                                  .getLabel(
                                                                      'city',
                                                                      'المحافظة'),
                                                              validator:
                                                                  RequiredValidator(
                                                                      errorText:
                                                                          errorText()),
                                                              icon: Assets.icons
                                                                  .iconAwesomeCity
                                                                  .svg(
                                                                      width:
                                                                          12.w,
                                                                      height:
                                                                          14.w),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20.w,
                                                          ),
                                                          Center(
                                                            child: AppTextField(
                                                              name: AppFactory
                                                                  .getLabel(
                                                                      'road',
                                                                      'المنطقة'),
                                                              value: (data.data
                                                                              ?.shippingAddress ??
                                                                          null) !=
                                                                      null
                                                                  ? data.data
                                                                          ?.shippingAddress[
                                                                      'region_desc']
                                                                  : authResponse
                                                                          .data
                                                                          ?.location?['region_desc'] ??
                                                                      null,
                                                              validator:
                                                                  RequiredValidator(
                                                                      errorText:
                                                                          errorText()),
                                                              onSaved: (value) {
                                                                context
                                                                    .read(cartActionsProvider
                                                                        .notifier)
                                                                    .shippingParam['region'] = value!
                                                                            .length >
                                                                        0
                                                                    ? value
                                                                    : null;
                                                              },
                                                              icon: Assets.icons.road.svg(
                                                                  width: AppFactory
                                                                          .getDimensions(
                                                                              12,
                                                                              toString())
                                                                      .w,
                                                                  height: AppFactory
                                                                          .getDimensions(
                                                                              14,
                                                                              toString())
                                                                      .w),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20.w,
                                                          ),
                                                          Center(
                                                            child: AppTextField(
                                                              enable: false,
                                                              name: AppFactory
                                                                  .getLabel(
                                                                      'flags',
                                                                      'أقرب نقطة دالة للعنوان'),
                                                              icon: Assets.icons.iconMaterialLocationOn.svg(
                                                                  width: AppFactory
                                                                          .getDimensions(
                                                                              12,
                                                                              toString())
                                                                      .w,
                                                                  height: AppFactory
                                                                          .getDimensions(
                                                                              14,
                                                                              toString())
                                                                      .w),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Container(
                                                              width: 300.0.w,
                                                              height: 66.0.w,
                                                              child:
                                                                  AppTextField(
                                                                supportUnderLine:
                                                                    false,
                                                                value: (data.data?.shippingAddress ??
                                                                            null) !=
                                                                        null
                                                                    ? data.data
                                                                            ?.shippingAddress[
                                                                        'address']
                                                                    : authResponse
                                                                            .data
                                                                            ?.location?['landmarks'] ??
                                                                        null,
                                                                validator:
                                                                    RequiredValidator(
                                                                        errorText:
                                                                            errorText()),
                                                                name: AppFactory
                                                                    .getLabel(
                                                                        'hint_location',
                                                                        'أبجد هوز….'),
                                                                onSaved:
                                                                    (value) {
                                                                  context
                                                                      .read(cartActionsProvider
                                                                          .notifier)
                                                                      .shippingParam['address'] = value!
                                                                              .length >
                                                                          0
                                                                      ? value
                                                                      : null;
                                                                },
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10.0),
                                                                ),
                                                                border:
                                                                    Border.all(
                                                                  width: 0.3,
                                                                  color: AppFactory
                                                                      .getColor(
                                                                          'gray_1',
                                                                          toString()),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20.w,
                                                          ),
                                                          Center(
                                                            child: AppTextField(
                                                              name: AppFactory
                                                                  .getLabel(
                                                                      'mobile',
                                                                      ' رقم الموبايل ${getHintMobile()}'),
                                                              validator:
                                                                  RequiredValidator(
                                                                      errorText:
                                                                          errorText()),
                                                              iconEnd:
                                                                  buildMobilePreIcon(),
                                                              value: (data.data
                                                                              ?.shippingAddress ??
                                                                          null) !=
                                                                      null
                                                                  ? data.data
                                                                          ?.shippingAddress[
                                                                      'mobile']
                                                                  : authResponse
                                                                          .data
                                                                          ?.mobile ??
                                                                      (!authResponse
                                                                              .data
                                                                              ?.user
                                                                              ?.usernameType
                                                                              ?.isSocial()
                                                                          ? authResponse.data?.user?.username ??
                                                                              null
                                                                          : null),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              supportDecoration:
                                                                  true,
                                                              onSaved: (value) {
                                                                context
                                                                    .read(cartActionsProvider
                                                                        .notifier)
                                                                    .shippingParam['mobile'] = value!
                                                                            .length >
                                                                        0
                                                                    ? value
                                                                    : null;
                                                              },
                                                              icon: Assets.icons.iconAwesomeMobileAlt.svg(
                                                                  width: AppFactory
                                                                          .getDimensions(
                                                                              12,
                                                                              toString())
                                                                      .w,
                                                                  height: AppFactory
                                                                          .getDimensions(
                                                                              14,
                                                                              toString())
                                                                      .w),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 25.w,
                                                          ),
                                                          MainAppButton(
                                                            onClick: () {
                                                              if (shippingFormKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                shippingFormKey
                                                                    .currentState!
                                                                    .save();
                                                                context
                                                                    .read(cartActionsProvider
                                                                        .notifier)
                                                                    .setShippingAddress();
                                                              }
                                                            },
                                                            name: 'حفظ العنوان',
                                                          )
                                                        ],
                                                      ),
                                                      key: shippingFormKey,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            10.0.w),
                                                      ),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Color(0xff707070)
                                                                  .withOpacity(
                                                                      0.12),
                                                          offset:
                                                              Offset(0, 2.0),
                                                          blurRadius: 14.0,
                                                        ),
                                                      ],
                                                    ),
                                                    margin: EdgeInsetsResponsive
                                                        .all(20),
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .all(20),
                                                  ),
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
                                                            : CartItem(
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
                                                            fontSize: 14,
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
                                                                          14,
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
                                                                  fontSize: 14,
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
                                                    child: Row(
                                                      children: [
                                                        TextResponsive(
                                                          'أدخل الكوبون:',
                                                          style: TextStyle(
                                                            fontSize: 19,
                                                            color: const Color(
                                                                0xff3876ba),
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          width: 20.w,
                                                        ),
                                                        Expanded(
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Color(0xff3876ba)),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Color(0xff3876ba)),
                                                                    ),
                                                                    isDense:
                                                                        true),
                                                            controller:
                                                                promoCode,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color(
                                                                  0xff3876ba),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 30.w,
                                                        ),
                                                        InkWell(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.w),
                                                              color: data.data
                                                                          ?.promocode !=
                                                                      null
                                                                  ? Colors.red
                                                                  : Color(
                                                                      0xff3876ba),
                                                              border: Border.all(
                                                                  width: 1.0,
                                                                  color: data
                                                                              .data
                                                                              ?.promocode !=
                                                                          null
                                                                      ? Colors
                                                                          .red
                                                                      : Color(
                                                                          0xff3876ba)),
                                                            ),
                                                            child:
                                                                TextResponsive(
                                                              data.data?.promocode !=
                                                                      null
                                                                  ? 'حذف'
                                                                  : 'تأكيد',
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                                color: const Color(
                                                                    0xffffffff),
                                                                height: 1,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            padding:
                                                                EdgeInsetsResponsive
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            7,
                                                                        top: 7),
                                                          ),
                                                          onTap: () {
                                                            if (data.data
                                                                    ?.promocode !=
                                                                null) {
                                                              promoCode!.text =
                                                                  '';
                                                              context
                                                                  .read(promoCodeProvider
                                                                      .notifier)
                                                                  .removeFromCart(
                                                                      {});
                                                            } else if (promoCode!
                                                                    .text
                                                                    .length >
                                                                0)
                                                              context
                                                                  .read(promoCodeProvider
                                                                      .notifier)
                                                                  .applyToCart({
                                                                'code':
                                                                    promoCode!
                                                                        .text,
                                                              });
                                                            else
                                                              showFlash(
                                                                  'ادخل الكود');
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 20.w,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.w,
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 0.1.w,
                                                      color: Color(0xff707070),
                                                      width: 309.w,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.w,
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 0.1.w,
                                                      color: Color(0xff707070),
                                                      width: 309.w,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20.w,
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsetsResponsive
                                                              .only(
                                                                  left: 20,
                                                                  right: 20),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          buildMainTitle(
                                                              'الدفع'),
                                                          SizedBox(
                                                            height: 15.w,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsResponsive
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Assets
                                                                    .images.cash
                                                                    .image(
                                                                        width: 30
                                                                            .w,
                                                                        height:
                                                                            28.w),
                                                                SizedBox(
                                                                  width: 20.w,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      TextResponsive(
                                                                    'عند الاستلام',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: const Color(
                                                                          0xff211d18),
                                                                      height:
                                                                          1.5625,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                                buildFullCircle()
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30.w,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              if (shippingFormKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                if (data.data
                                                                        ?.shippingAddress ==
                                                                    null) {
                                                                  showFlash(
                                                                      'احفظ العنوان اولا بالاعلى');
                                                                  return;
                                                                }

                                                                shippingFormKey
                                                                    .currentState!
                                                                    .save();
                                                                context
                                                                    .read(cartActionsProvider
                                                                        .notifier)
                                                                    .submitCart();
                                                              }
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
                                                                  'إتمام الطلب',
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
                                                        ],
                                                      )),
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

class CartItem extends StatelessWidget {
  final VoidCallback onTap;
  final CartDataDataItems item;
  final Function(String) onCall;

  CartItem(this.onTap, this.item, this.onCall);

  @override
  Widget build(BuildContext context) {
    return (item.isDeleted ?? false) || !(item.isQuantityAvailable ?? true)
        ? ClipRect(
            child: Banner(
                message: (item.isDeleted ?? false) ? 'محذوف' : 'غير متاح',
                child: buildBody(item),
                color: AppFactory.getColor('primary', toString()),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: FontFamily.araHamahAlislam,
                  color: Colors.white,
                ),
                location: BannerLocation.topStart))
        : buildBody(item);
  }

  InkWell buildBody(CartDataDataItems item) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
              bottom: 10.w,
              left: 10.w,
              top: 8.w,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsResponsive.only(top: 2, bottom: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextResponsive(
                            item.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17,
                              height: 0.8,
                              color: const Color(0xff3876ba),
                            ),
                            textAlign: TextAlign.right,
                          ),
                          TextResponsive(
                            'السعر: ${item.unitPrice?.formatted}',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'roboto',
                              color: const Color(0xff707070),
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Container(
                            margin:
                                EdgeInsetsResponsive.only(top: 0, bottom: 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    TextResponsive(
                                      'الكمية:',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color(0xff707070),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        (GetIt.I<ApplicationCore>().getContext()
                                                as BuildContext)
                                            .read(cartActionsProvider.notifier)
                                            .addToCart({
                                          'product_id': item.productId,
                                          'quantity': (int.parse(
                                                      item.totalQuantity ??
                                                          '0') -
                                                  1)
                                              .toString(),
                                        });
                                      },
                                      child: Assets.icons.iconFeatherMinusCircle
                                          .svg(width: 22.w, height: 22.w),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    TextResponsive(
                                      item.totalQuantity ?? '',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: const Color(0xfffeca2e),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          (GetIt.I<ApplicationCore>()
                                                  .getContext() as BuildContext)
                                              .read(
                                                  cartActionsProvider.notifier)
                                              .addToCart({
                                            'product_id': item.productId,
                                            'quantity': (int.parse(
                                                        item.totalQuantity ??
                                                            '0') +
                                                    1)
                                                .toString(),
                                          });
                                        },
                                        child: Assets.icons.addcart
                                            .svg(width: 22.w, height: 22.w)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextResponsive(
                            'السعر الكلي:${item.totalPrice?.formatted}',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'roboto',
                              color: const Color(0xff707070),
                            ),
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      (GetIt.I<ApplicationCore>().getContext() as BuildContext)
                          .read(cartActionsProvider.notifier)
                          .removeFromCart(item.id);
                    },
                    child: Container(
                      width: 30.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.delete_solid),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff3876ba),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                        'هذا السعر متغير حسب منطقة الشحن',
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color(0xff707070),
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
