import 'dart:async';
import 'dart:io';

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
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String PATH = '/accounts-login';
  final String? username;
  final String? password;

  LoginScreen({this.username, this.password});

  static String generatePath({String? username, String? password}) {
    Map<String, dynamic> parameters = {
      'username': username,
      'password': password
    };
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStatefulState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  @override
  void initState() {
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
            systemNavigationBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: AppFactory.getColor('background', toString()),
          body: Stack(
            children: [
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                return !isKeyboardVisible ? FooterWidget() : Container();
              }),
              Container(
                margin: EdgeInsetsResponsive.only(
                    top: AppFactory.getDimensions(120, toString())),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Assets.images.feet.image(
                      width: AppFactory.getDimensions(95, toString()).w,
                      height: AppFactory.getDimensions(65, toString()).h),
                ),
              ),
              SizedBox.expand(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: AppFactory.getDimensions(
                                  60, toString() + '-systemNavigationBarMargin')
                              .h,
                        ),
                        buildMainTitle(
                            AppFactory.getLabel('login', 'تسجيل الدخول')),
                        SizedBox(
                          height: AppFactory.getDimensions(30, toString()).h,
                        ),
                        MainAppButton(
                          onClick: () async {
                            GoogleSignIn _googleSignIn = GoogleSignIn(
                              scopes: [
                                'email',
                                //  'https://www.googleapis.com/auth/contacts.readonly',
                              ],
                            );
                            try {
                              GoogleSignInAccount? googleSignInAccount =
                                  await _googleSignIn.signIn();
                              var result =
                                  await googleSignInAccount!.authentication;
                              apiBloc.doAction(
                                  param: {
                                    'method': 'post',
                                    'url': SOCIAL_LOGIN_API,
                                    'access_token': result.accessToken,
                                    'provider': 'google'
                                  },
                                  supportLoading: true,
                                  onResponse: (json) {
                                    try {
                                      _googleSignIn.signOut();
                                    } catch (e) {}
                                    handlerLogin(json);
                                  },
                                  supportErrorMsg: true);
                            } catch (error) {
                              print(error);
                            }
                          },
                          name: AppFactory.getLabel(
                              'google_sign_in', 'تسجيل باستخدام غوغل'),
                          bgColor: Colors.white,
                          icon: Assets.icons.googleIc.svg(
                              width: AppFactory.getDimensions(21, toString()).w,
                              height:
                                  AppFactory.getDimensions(21, toString()).w),
                          textColor: AppFactory.getColor('gray_1', toString()),
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(15, toString()).h,
                        ),
                        MainAppButton(
                          onClick: () async {
                            final LoginResult result = await FacebookAuth
                                .instance
                                .login(); // by default we request the email and the public profile
                            if (result.status == LoginStatus.success) {
                              final AccessToken accessToken =
                                  result.accessToken!;
                              apiBloc.doAction(
                                  param: {
                                    'method': 'post',
                                    'url': SOCIAL_LOGIN_API,
                                    'access_token': accessToken.token,
                                    'provider': 'facebook'
                                  },
                                  supportLoading: true,
                                  onResponse: (json) async {
                                    try {
                                      await FacebookAuth.instance.logOut();
                                    } catch (e) {}
                                    handlerLogin(json);
                                  },
                                  supportErrorMsg: true);
                            }
                          },
                          name: AppFactory.getLabel(
                              'facebook_sign_in', 'تسجيل باستخدام فيسبوك'),
                          bgColor: AppFactory.getColor('primary', toString()),
                          icon: Assets.icons.facebookIc.svg(
                              width: AppFactory.getDimensions(21, toString()).w,
                              height:
                                  AppFactory.getDimensions(21, toString()).w),
                          textColor: Colors.white,
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(20, toString()).h,
                        ),
                        Platform.isIOS
                            ? MainAppButton(
                                onClick: () async {
                                  final credential = await SignInWithApple
                                      .getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                    /* webAuthenticationOptions:   WebAuthenticationOptions(
                                      // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                      clientId:
                                      'com.aboutyou.dart_packages.sign_in_with_apple.example',
                                      redirectUri: Uri.parse(
                                        'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                      ),
                                )*/
                                  );

                                  apiBloc.doAction(
                                      param: {
                                        'method': 'post',
                                        'first_name': credential.givenName,
                                        'last_name': credential.familyName,
                                        'url': SOCIAL_LOGIN_API,
                                        'access_token':
                                            credential.identityToken,
                                        'provider': 'apple'
                                      },
                                      supportLoading: true,
                                      onResponse: (json) async {
                                        handlerLogin(json);
                                      },
                                      supportErrorMsg: true);
                                },
                                name: AppFactory.getLabel(
                                    'facebook_sign_in', 'تسجيل باستخدام أبل'),
                                icon: SvgPicture.asset(
                                    'assets/icons/apple_ic.svg',
                                    width:
                                        AppFactory.getDimensions(21, toString())
                                            .w,
                                    height:
                                        AppFactory.getDimensions(21, toString())
                                            .w),
                                textColor: Colors.black,
                                bgColor: Colors.white,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: Platform.isIOS
                              ? AppFactory.getDimensions(20, toString()).h
                              : 0,
                        ),
                        Column(
                          children: [
                            AppTextField(
                              name: AppFactory.getLabel(
                                  'mobile', 'رقم الموبايل ${getHintMobile()}'),
                              validator:
                                  RequiredValidator(errorText: errorText()),
                              iconEnd: buildMobilePreIcon(),
                              keyboardType: TextInputType.number,
                              supportDecoration: true,
                              value: widget.username ?? null,
                              onSaved: (value) {
                                param['username'] = value;
                              },
                              icon: Assets.icons.iconAwesomeMobileAlt.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(20, toString()).h,
                            ),
                            AppTextField(
                              obscureText: true,
                              value: widget.password ?? null,
                              name: AppFactory.getLabel(
                                  'password', 'كلمة المرور'),
                              validator:
                                  RequiredValidator(errorText: errorText()),
                              onSaved: (value) {
                                param['password'] = value;
                              },
                              icon: Assets.icons.iconFeatherLock.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            /*  SizedBox(
                              height:
                                  AppFactory.getDimensions(10, toString()).h,
                            ),
                             Container(
                                width:
                                    AppFactory.getDimensions(303, toString()).w,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: buildForgetPBtn(),
                                )),*/
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(20, toString()).h,
                            ),
                            MainAppButton(
                              name: AppFactory.getLabel('register', 'تسجيل'),
                              onClick: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  apiBloc.doAction(
                                      param: BaseStatefulState.addServiceInfo(
                                          param,
                                          data: {
                                            'method': 'post',
                                            'url': LOGIN_API,
                                          }),
                                      supportLoading: true,
                                      supportErrorMsg: false,
                                      onResponse: (json) {
                                        handlerLogin(json);
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppFactory.getDimensions(20, toString()).h,
                        ),
                        buildSignUpWidget(),
                        buildSkipBtn(),
                        SizedBox(
                          height: AppFactory.getDimensions(20, toString()).h,
                        ),
                        Assets.images.dog3.image(
                            width: AppFactory.getDimensions(83, toString()).w,
                            height:
                                AppFactory.getDimensions(124, toString()).h),
                        SizedBox(
                          height: AppFactory.getDimensions(10, toString()).h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  Widget buildSkipBtn() {
    return InkWell(
      onTap: () {
        goTo(
          HomeScreen.generatePath(pageId: 'home'),
          clearStack: true,
        );
      },
      child: Container(
        padding: EdgeInsetsResponsive.all(5),
        child: TextResponsive(
          AppFactory.getLabel('skip', 'تخطي'),
          style: TextStyle(
            fontSize: AppFactory.getFontSize(18, toString()),
            color: AppFactory.getColor('orange', toString()),
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget buildForgetPBtn() {
    return InkWell(
      onTap: () {
        goTo(ForgetPasswordScreen.generatePath(),
            transition: TransitionType.inFromRight);
      },
      child: Container(
        padding: EdgeInsetsResponsive.all(10),
        child: TextResponsive(
          AppFactory.getLabel('forget_password', 'نسيان كلمة المرور ؟'),
          style: TextStyle(
            fontSize: AppFactory.getFontSize(14, toString()),
            color: AppFactory.getColor('gray_1', toString()),
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  InkWell buildSignUpWidget() {
    return InkWell(
      onTap: () {
        apiBloc.doAction(
            param: {
              'method': 'get',
              'url': BASICS,
            },
            supportLoading: true,
            onResponse: (json) {
              try {
                GetStorage().write('basics', json);
              } catch (e) {}
              showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                  useSafeArea: false,
                  builder: (_) => AccountTypeDialog(
                        onSelected: (item) {
                          // goTo(SignInScreen.generatePath() );
                        },
                        data: [
                          {
                            'selected': true,
                            'title': AppFactory.getLabel(
                                'breeder-account', 'مستخدم/مربي'),
                            'id': 'breeder',
                          },
                          {
                            'selected': false,
                            'title': AppFactory.getLabel(
                                'provider-account', 'مقدم خدمة'),
                            'id': 'service-provider',
                            'hint':
                                '(بيطرة، فندقة، حلاقة، حمام، تنزه وتمشي، تدريب, نقل واغاثة)'
                          },
                        ],
                      )).then((value) {
                if (value == null) return;
                bool isProvider = false;
                if (value['id'] == 'service-provider') {
                  isProvider = true;
                }
                goTo(SignUpScreen.generatePath(isProvider),
                    transition: TransitionType.inFromRight);
              });
            },
            supportErrorMsg: false);
      },
      child: Padding(
        padding: EdgeInsetsResponsive.all(10),
        child: Wrap(
          children: [
            TextResponsive(
              AppFactory.getLabel('no_account', 'ليس لديك حساب؟'),
              style: TextStyle(
                fontSize: AppFactory.getFontSize(16, toString()),
                color: AppFactory.getColor('gray_1', toString()),
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 5.w,
            ),
            TextResponsive(
              AppFactory.getLabel('sign_up', 'إنشاء حساب'),
              style: TextStyle(
                fontSize: AppFactory.getFontSize(16, toString()),
                color: AppFactory.getColor('primary', toString()),
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.right,
            )
          ],
        ),
      ),
    );
  }
}
