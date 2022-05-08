import 'dart:async';

import 'package:blur/blur.dart';
import 'package:fluro/fluro.dart';
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
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/SignUpScreen.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

class AccountTypeDialog extends StatefulWidget {
  static const String PATH = '/accounts-type';
  final List<dynamic> data;
  final Function(dynamic) onSelected;

  AccountTypeDialog({required this.data, required this.onSelected});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AccountTypeDialogState createState() => _AccountTypeDialogState();
}

class _AccountTypeDialogState extends BaseStatefulState<AccountTypeDialog> {
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
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
              onTap: (){
        Navigator.pop(context);
        },
          child: Blur(
                  blur: 15,
                  colorOpacity: 0.26,
                  blurColor: AppFactory.getColor('gray_1', toString()),
                  child: SizedBox.expand())),
              SizedBox.expand(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 266.0.w,
                      child: ListView.builder(
                        itemCount: widget.data.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsetsResponsive.only(
                            left: AppFactory.getDimensions(20, toString()),
                            top: AppFactory.getDimensions(20, toString()),
                            bottom: AppFactory.getDimensions(20, toString()),
                            right: AppFactory.getDimensions(20, toString())),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            widget.onSelected.call(widget.data[index]);
                            setState(() {
                              widget.data.forEach((element) {
                                element['selected'] = false;
                              });
                              widget.data[index]['selected'] = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsetsResponsive.only(
                                top: AppFactory.getDimensions(10, toString()),
                                bottom:
                                    AppFactory.getDimensions(10, toString()),
                                left: AppFactory.getDimensions(10, toString()),
                                right:
                                    AppFactory.getDimensions(10, toString())),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: AppFactory.getDimensions(
                                              5, toString())
                                          .w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextResponsive(
                                            widget.data[index]['title'] ??
                                                widget.data[index]['name'] ??
                                                '',
                                            style: TextStyle(
                                              fontSize: AppFactory.getFontSize(
                                                  20.0, toString()),
                                              color: AppFactory.getColor(
                                                  'primary', toString()),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: widget.data[index]
                                                        ['hint'] !=
                                                    null
                                                ? 4.h
                                                : 0,
                                          ),
                                          TextResponsive(
                                            widget.data[index]['hint'] ?? '',
                                            style: TextStyle(
                                              fontSize: AppFactory.getFontSize(
                                                  12.0, toString()),
                                              color: AppFactory.getColor(
                                                  'primary_1', toString()),
                                            ),
                                            textAlign: TextAlign.start,
                                          )
                                        ],
                                      ),
                                    ),
                                    widget.data[index]['selected'] != null &&
                                            widget.data[index]['selected']
                                        ? buildFullCircle()
                                        : buildEmptyCircle(),
                                  ],
                                ),
                                Container(
                                  height: 0.1,
                                  margin: EdgeInsetsResponsive.only(top: 20),
                                  color: Colors.black.withOpacity(0.45),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0.w),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppFactory.getColor('gray_1', toString())
                                .withOpacity(0.16),
                            offset: Offset(0, 3.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.w,
                    ),
                    MainAppButton(
                      name: AppFactory.getLabel('continues', 'متابعة'),
                      onClick: () {
                        dynamic result;
                        widget.data.forEach((element) {
                          if (element['selected']) {
                            result = element;
                          }
                        });
                        if (result != null) {
                          Navigator.pop(context, result);
                        }
                      },
                      bgColor: AppFactory.getColor('primary', toString()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
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
