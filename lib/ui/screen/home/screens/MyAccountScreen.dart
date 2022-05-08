import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/orders/OrdersScreen.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/EditAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/RatingResultScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/info/AboutScreen.dart';
import 'package:flutter_app/ui/screen/offers/OffersScreen.dart';
import 'package:flutter_app/ui/screen/services/ActivateServicesScreen.dart';
import 'package:flutter_app/ui/screen/startup/LanguageScreen.dart';
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

class MyAccountScreen extends StatefulWidget {
  static const String PATH = '/home-account';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends BaseStatefulState<MyAccountScreen> {
  late List<dynamic> data;

  @override
  void initState() {
    AuthResponse authResponse =
        AuthResponse.fromMap(GetStorage().read('account'));

    if (authResponse.data!.accountType!.id == '3' ||
        authResponse.data!.accountType!.id == 'service_provider')
      data = [
        {
          'id': 'edit_account',
          'margin-left': 42.w,
          'name': AppFactory.getLabel('edit_account', 'تعديل حسابي'),
          'icon': Assets.icons.iconAwesomeUserEdit.path
        },
        {
          'id': 'activate_services',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('activate_services', 'تفعيل الخدمات'),
          'icon': Assets.icons.technicalSupport.path
        },
        {
          'id': 'offers',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('offers', 'العروض'),
          'icon': Assets.icons.discount.path
        },
        {
          'id': 'my_orders',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('my_orders', 'طلباتي'),
          'icon': Assets.icons.choices.path
        },
        {
          'id': 'share_account',
          'margin-left': 45.w,
          'name': AppFactory.getLabel('share_account', 'مشاركة الحساب'),
          'icon': Assets.icons.iconOpenShareBoxed.path
        },
        {
          'id': 'review',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('review', 'تقيم وتعليقات زبائن المركز'),
          'icon': Assets.icons.review.path
        },
        {
          'id': 'about',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('about', 'حول التطبيق'),
          'icon': Assets.icons.about.path
        },
        /*  {
          'id': 'change_lang',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('change_lang', 'تغيير اللغة'),
          'icon': Assets.icons.about.path
        },*/
        {
          'id': 'logout',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('logout', 'تسجيل الخروج'),
          'icon': Assets.icons.logout.path
        }
      ];
    else
      data = [
        {
          'id': 'edit_account',
          'margin-left': 42.w,
          'name': AppFactory.getLabel('edit_account', 'تعديل حسابي'),
          'icon': Assets.icons.iconAwesomeUserEdit.path
        },
        {
          'id': 'my_orders',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('my_orders', 'طلباتي'),
          'icon': Assets.icons.choices.path
        },
        {
          'id': 'about',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('about', 'حول التطبيق'),
          'icon': Assets.icons.about.path
        },
        /* {
          'id': 'change_lang',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('change_lang', 'تغيير اللغة'),
          'icon': Assets.icons.about.path
        },*/
        {
          'id': 'logout',
          'margin-left': 48.w,
          'name': AppFactory.getLabel('logout', 'تسجيل الخروج'),
          'icon': Assets.icons.logout.path
        }
      ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsResponsive.only(bottom: 50),
          child: Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  Expanded(
                      child: buildMainTitle('رقم الحساب: ' +
                          AuthResponse.fromMap(GetStorage().read('account'))
                              .data!
                              .user!
                              .id
                              .toString())),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: data
                    .map((e) => InkWell(
                          onTap: () {
                            if (e['id'] == 'my_orders')
                              goTo(OrdersScreen.generatePath(),
                                  transition: TransitionType.inFromRight);
                            else if (e['id'] == 'edit_account')
                              goTo(EditAccountScreen.generatePath(),
                                  transition: TransitionType.inFromRight);
                            else if (e['id'] == 'about')
                              goTo(AboutScreen.generatePath(),
                                  transition: TransitionType.inFromRight);
                            else if (e['id'] == 'activate_services')
                              goTo(ActivateServicesScreen.generatePath(),
                                  transition: TransitionType.inFromRight);
                            else if (e['id'] == 'review') {
                              if (getServiceCenterId() != null) {
                                goTo(RatingResultScreen.generatePath(),
                                    transition: TransitionType.inFromRight);
                              } else {
                                goTo(ActivateServicesScreen.generatePath(),
                                    transition: TransitionType.inFromRight);
                              }
                            } else if (e['id'] == 'offers')
                              goTo(OffersScreen.generatePath(),
                                  transition: TransitionType.inFromRight);
                            else if (e['id'] == 'logout') {
                              apiBloc.doAction(
                                  param: BaseStatefulState.addServiceInfo(Map(),
                                      data: {
                                        'url': LOGOUT_API,
                                        'method': 'post',
                                      }),
                                  supportLoading: true,
                                  supportErrorMsg: false,
                                  onResponse: (json) {
                                    GetStorage().remove('token');
                                    GetStorage().remove('account');
                                    context
                                        .read(cartActionsProvider.notifier)
                                        .removeCart();
                                    goTo(LoginScreen.generatePath(),
                                        transition: TransitionType.inFromRight,
                                        clearStack: true);
                                  });
                            } else if (e['id'] == 'change_lang')
                              goTo(LanguageScreen.generatePath(),
                                  transition: TransitionType.inFromRight);
                          },
                          child: Container(
                            height: 80.w,
                            width: 327.w,
                            margin: EdgeInsetsResponsive.only(top: 15),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Assets.images.accountElement.image(
                                  height: 80.w,
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    SizedBox(
                                      width: e['margin-left'],
                                    ),
                                    Container(
                                      child: SvgPicture.asset(e['icon'],
                                          height: 25.w, width: 25.w),
                                      margin: EdgeInsets.only(
                                        bottom: 13.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 35.w,
                                    ),
                                    TextResponsive(
                                      e['name'],
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: AppFactory.getColor(
                                            'primary', toString()),
                                        height: 0.47,
                                      ),
                                      textAlign: TextAlign.right,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
