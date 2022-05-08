import 'dart:async';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/ChangeUsernameDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/ProfileTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsTypsWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

class MessagesScreen extends StatefulWidget {
  static const String PATH = '/chat-messages';

  MessagesScreen();

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends BaseStatefulState<MessagesScreen> {
  final formKey = GlobalKey<FormState>();

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
            systemNavigationBarColor: Colors.white),
        child: Scaffold(
          backgroundColor: AppFactory.getColor('background', toString()),
          body: Stack(
            children: [
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                return !isKeyboardVisible ? RightLeftWidget() : Container();
              }),
              Positioned.fill(
                bottom: 90.w,
                child: Column(
                  children: [
                    SizedBox(
                      height: AppFactory.getDimensions(
                              60, toString() + '-systemNavigationBarMargin')
                          .h,
                    ),
                    Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsetsResponsive.only(top: 5),
                              child: buildMainTitle(AppFactory.getLabel(
                                  'edit_account', 'حسن محمد')),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Container(
                                width: 39.w,
                                height: 39.w,
                                child: CircularProfileAvatar(
                                  'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4',
                                  backgroundColor: Colors.transparent,
                                  borderWidth: 0,
                                  borderColor: Colors.transparent,
                                  elevation: 3.0,
                                  foregroundColor: Colors.transparent,
                                  //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                                  cacheImage: true,
                                  // allow widget to cache image against provided url
                                  onTap: () {
                                    print('adil');
                                  },
                                  // sets on tap
                                  showInitialTextAbovePicture:
                                      true, // setting it true will show initials text above profile picture, default false
                                )),
                            buildBackBtn(context,
                                color:
                                    AppFactory.getColor('primary', toString())),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: 310.w,
                        child: ListView.builder(
                          itemBuilder: (context, index) => index % 2 == 0
                              ? LeftMessageWidget()
                              : RightMessageWidget(),
                          itemCount: 20,
                          shrinkWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 40.w,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 44.w,
                      width: 327.w,
                      child: Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsetsResponsive.only(left: 25, right: 25),
                            child: Assets.icons.iconFeatherSend
                                .svg(width: 17.w, height: 17.w),
                          ),
                          Expanded(
                            child: AppTextField(
                              name: '',
                              lines: 1,
                              hint: AppFactory.getLabel(
                                  'type_here', 'اكتب شيئاً'),
                              supportUnderLine: false,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.0),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x14000000),
                            offset: Offset(0, 3),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
  }
}

class RightMessageWidget extends StatelessWidget {
  const RightMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0.w),
              bottomRight: Radius.circular(15.0.w),
              bottomLeft: Radius.circular(15.0.w),
            ),
            color: const Color(0xff3876ba),
            boxShadow: [
              BoxShadow(
                color: const Color(0x14000000),
                offset: Offset(0, 3),
                blurRadius: 14,
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: 249.w),
          padding: EdgeInsetsResponsive.all(14),
          margin: EdgeInsetsResponsive.all(10),
          child: TextResponsive(
            'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextResponsive(
              '01:24 PM',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0x54000000),
              ),
              textAlign: TextAlign.left,
            )
          ],
        ),
      ],
    );
  }
}

class LeftMessageWidget extends StatelessWidget {
  const LeftMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextResponsive(
              '01:24 PM',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0x54000000),
              ),
              textAlign: TextAlign.left,
            ),
            TextResponsive(
              'Me',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xff000000),
              ),
              textAlign: TextAlign.left,
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0x14000000),
                offset: Offset(0, 3),
                blurRadius: 14,
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: 249.w),
          padding: EdgeInsetsResponsive.all(14),
          margin: EdgeInsetsResponsive.all(10),
          child: TextResponsive(
            'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xff000000),
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
