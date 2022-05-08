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
import 'package:flutter_app/providers/RemindersProvider.dart';
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

class AddReminderDialog extends StatefulWidget {
  static const String PATH = '/add-note-dialog';
  final String id;
  AddReminderDialog(this.id);

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AddReminderDialogState createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends BaseStatefulState<AddReminderDialog> {
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Blur(
                      blur: 15,
                      colorOpacity: 0.26,
                      blurColor: AppFactory.getColor('gray_1', toString()),
                      child: SizedBox.expand())),
              SizedBox.expand(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextResponsive(
                        'إضافة تذكير',
                        style: TextStyle(
                          fontSize: 22,
                          color: const Color(0xff3876ba),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        width: 266.0.w,
                        child: Padding(
                          padding:
                              EdgeInsetsResponsive.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              /*Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Assets.icons.iconIonicMdTimer
                                          .svg(width: 22.w, height: 24.w),
                                      SizedBox(
                                        width: 14.w,
                                      ),
                                      TextResponsive(
                                        '09:00 am',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: const Color(0xff707070),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Assets.icons.dateRange
                                          .svg(width: 22.w, height: 24.w),
                                      SizedBox(
                                        width: 14.w,
                                      ),
                                      TextResponsive(
                                        '20/2/2021',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: const Color(0xff707070),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  )
                                ],
                              ),*/
                              Center(
                                child: AppTextField(
                                  width: 200.w,
                                  forDate: true,
                                  isDropDown: true,
                                  onSelectedValue: (value) {
                                    param['send_at'] = value.substring(0, 16);
                                  },
                                  name: AppFactory.getLabel(
                                      'send_at', 'تاريخ التذكير'),
                                  validator:
                                      RequiredValidator(errorText: errorText()),
                                  icon: Assets.icons.iconMaterialDateRange.svg(
                                      width: AppFactory.getDimensions(
                                              12, toString())
                                          .w,
                                      color: Colors.black,
                                      height: AppFactory.getDimensions(
                                              14, toString())
                                          .w),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Padding(
                                padding: EdgeInsetsResponsive.all(10),
                                child: Container(
                                  padding: EdgeInsetsResponsive.only(
                                      top: 5, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0.w),
                                      topRight: Radius.circular(20.0.w),
                                    ),
                                    border: Border.all(
                                        width: 0.2,
                                        color: const Color(0xff707070)),
                                  ),
                                  child: AppTextField(
                                    name: '',
                                    lines: 4,
                                    onSaved: (value) {
                                      param['text'] = value;
                                    },
                                    hint: AppFactory.getLabel(
                                        'reminder_text', 'نص التذكير'),
                                    validator: RequiredValidator(
                                        errorText: errorText()),
                                    supportUnderLine: false,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    AppFactory.getDimensions(10, toString()).h,
                              ),
                            ],
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
                        height: 70.h,
                      ),
                      MainAppButton(
                        name: AppFactory.getLabel('change', 'موافق'),
                        onClick: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            if (param['send_at'] == null) {
                              showFlash(AppFactory.getLabel(
                                  'plz_select_send_at',
                                  'الرجاء اختيار تاريخ التذكير'));
                              return;
                            }

                            apiBloc.doAction(
                                param: BaseStatefulState.addServiceInfo(param,
                                    data: {
                                      'method': 'post',
                                      'url':
                                          'v1/animals/${widget.id}/reminders',
                                    }),
                                supportLoading: true,
                                supportErrorMsg: false,
                                onResponse: (json) {
                                  if (isSuccess(json)) {
                                    Future.delayed(
                                        Duration.zero,
                                        () => context
                                            .read(remindersProvider(widget.id)
                                                .notifier)
                                            .load());
                                    Navigator.pop(context, 'success');
                                  }
                                  handlerResponseMsg(json);
                                });
                          }
                        },
                        bgColor: AppFactory.getColor('primary', toString()),
                      ),
                    ],
                  ),
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
