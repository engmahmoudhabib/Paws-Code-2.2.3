import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/providers/OffersProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/ChangeUsernameDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/ImagePickerWidget.dart';
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

class AddOfferScreen extends StatefulWidget {
  static const String PATH = '/offers-add';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends BaseStatefulState<AddOfferScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();
  File? imageFile;

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
                              AppFactory.getLabel('add_offer', 'إضافة عرض')),
                        ),
                      ),
                      buildBackBtn(context,
                          color: AppFactory.getColor('primary', toString())),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              width: 310.w,
                              margin: EdgeInsetsResponsive.only(
                                  top: 3, left: 20, right: 20),
                              height: 113.0.w,
                              child: ImagePickerWidget(
                                emptyWidget: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Assets.icons.upload
                                        .svg(width: 50.w, height: 47.w),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    TextResponsive(
                                      'رفع صورة',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color(0xff3876ba),
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                                onResult: (files) {
                                  files.forEach((file) async {
                                    imageFile = file;
                                  });
                                },
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.0.w),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppFactory.getColor(
                                            'gray_1', toString())
                                        .withOpacity(0.12),
                                    offset: Offset(0, 2.0),
                                    blurRadius: 12.0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: 310.w,
                                child: buildSectionTitle(
                                    AppFactory.getLabel(
                                        'enter_text', 'إدخال نص'),
                                    left: 0,
                                    right: 0)),
                            Container(
                              width: 310.0.w,
                              height: 101.0.w,
                              padding: EdgeInsetsResponsive.all(5),
                              child: AppTextField(
                                supportUnderLine: false,
                                onSaved: (value) {
                                  param['text'] = value;
                                },
                                name: AppFactory.getLabel(
                                    'hint_location', 'أبجد هوز….'),
                                validator:
                                    RequiredValidator(errorText: errorText()),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.0.w),
                                ),
                                color: Colors.white,
                                border: Border.all(
                                  width: 0.3,
                                  color:
                                      AppFactory.getColor('gray_1', toString()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(20, toString()).h,
                            ),
                            // Group: Group 675
                            AppTextField(
                              width: 310.w,
                              forDate: true,
                              isDropDown: true,
                              onSelectedValue: (value) {
                                param['expires_at'] = value.substring(0, 16);
                              },
                              name: AppFactory.getLabel(
                                  'expired', 'تاريخ الانتهاء'),
                              validator:
                                  RequiredValidator(errorText: errorText()),
                              icon: Assets.icons.iconMaterialDateRange.svg(
                                  width:
                                      AppFactory.getDimensions(12, toString())
                                          .w,
                                  color: Colors.black,
                                  height:
                                      AppFactory.getDimensions(14, toString())
                                          .w),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(100, toString()).h,
                            ),
                            MainAppButton(
                              width: 310.w,
                              name:
                                  AppFactory.getLabel('add_offer', 'إضافة عرض'),
                              onClick: () async {
                                if (imageFile == null) {
                                  showFlash(AppFactory.getLabel(
                                      'plz_select_image',
                                      'الرجاء اختيار صورة'));
                                  return;
                                }

                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  if (param['expires_at'] == null) {
                                    showFlash(AppFactory.getLabel(
                                        'plz_select_expires_at',
                                        'الرجاء اختيار تاريخ الانتهاء'));
                                    return;
                                  }

                                  apiBloc.doAction(
                                      param: BaseStatefulState.addServiceInfo(
                                          param,
                                          data: {
                                            'method': 'post',
                                            'image': imageFile != null
                                                ? await getImageMultiPart(
                                                    imageFile!)
                                                : null,
                                            'url': OFFERS_API,
                                          }),
                                      supportLoading: true,
                                      supportErrorMsg: false,
                                      onResponse: (json) {
                                        if (isSuccess(json)) {

                                          Navigator.pop(context,'success');
                                        }
                                        handlerResponseMsg(json);
                                      });
                                }
                              },
                              bgColor:
                                  AppFactory.getColor('primary', toString()),
                            ),
                            SizedBox(
                              height:
                                  AppFactory.getDimensions(70, toString()).h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}
