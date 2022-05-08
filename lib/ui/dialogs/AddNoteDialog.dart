import 'dart:async';

import 'package:blur/blur.dart';
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
import 'package:flutter_app/providers/AnimalsProvider.dart';
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

class AddNoteDialog extends StatefulWidget {
  static const String PATH = '/add-note-dialog';

  AddNoteDialog(this.animalId);
  String animalId;

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends BaseStatefulState<AddNoteDialog> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  @override
  void initState() {
    param['animal_id'] = widget.animalId;
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
                  onTap: () {
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
                    TextResponsive(
                      'إضافة ملاحظة',
                      style: TextStyle(
                        fontSize: 22,
                        color: const Color(0xff3876ba),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        width: 266.0.w,
                        child: Padding(
                          padding:
                              EdgeInsetsResponsive.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              AppTextField(
                                name: '',
                                lines: 4,
                                onSaved: (value) {
                                  param['text'] = value;
                                },
                                hint: AppFactory.getLabel(
                                    'note_text', 'نص الملاحظة'),
                                validator:
                                    RequiredValidator(errorText: errorText()),
                                supportUnderLine: false,
                              ),
                              SizedBox(
                                height:
                                    AppFactory.getDimensions(40, toString()).h,
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
                    ),
                    SizedBox(
                      height: 70.h,
                    ),
                    MainAppButton(
                      name: AppFactory.getLabel('change', 'موافق'),
                      onClick: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          apiBloc.doAction(
                              param: BaseStatefulState.addServiceInfo(param,
                                  data: {
                                    'method': 'post',
                                    'url': ANIMALS_NOTE_API,
                                  }),
                              supportLoading: true,
                              supportErrorMsg: false,
                              onResponse: (json) {
                                Future.delayed(
                                    Duration.zero,
                                    () => context
                                        .read(animalsDetailsProvider.notifier)
                                        .getDetails(widget.animalId));
                                Navigator.pop(context, 'success');
                              });
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
