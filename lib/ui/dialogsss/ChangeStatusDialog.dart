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
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/SignUpScreen.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FilterWidget.dart';
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

class ChangeStatusDialog extends StatefulWidget {
  static const String PATH = '/change-status-dialog';
  final String id;
  final String selectedId;
  ChangeStatusDialog(this.id, {this.selectedId = ''});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _ChangeStatusDialogState createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends BaseStatefulState<ChangeStatusDialog> {
  @override
  void initState() {
    authResponse = AuthResponse.fromMap(GetStorage().read('account'));

    super.initState();
  }

  AuthResponse? authResponse;

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
              Blur(
                  blur: 15,
                  colorOpacity: 0.26,
                  blurColor: AppFactory.getColor('gray_1', toString()),
                  child: SizedBox.expand()),
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        TextResponsive(
                          'هل تريد تغيير الحالة إلى:',
                          style: TextStyle(
                            fontSize: 22,
                            color: const Color(0xff3876ba),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        FilterWidget(
                          onSelected: (data) {
                            print(data);
                            status.value = data;
                            param['status'] = data['id'];
                          },
                          selectedId: widget.selectedId,
                          forChangeState: true,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ValueListenableBuilder(
                            valueListenable: status,
                            builder: (context, value, child) => Visibility(
                                visible: value != null &&
                                    (status.value['id'] == 'sale' ||
                                        status.value['id'] == 'marriage'),
                                child: Container(
                                  margin: EdgeInsetsResponsive.only(bottom: 20),
                                  child: CustomTextFieldWidget(
                                    name: AppFactory.getLabel('price', 'السعر'),
                                    iconBackground: AppFactory.getColor(
                                        'orange', toString()),
                                    borderColor: AppFactory.getColor(
                                        'orange', toString()),
                                    labelColor: AppFactory.getColor(
                                        'orange', toString()),
                                    onSaved: (value) {
                                      param['price'] = value;
                                    },
                                    validator: RequiredValidator(
                                        errorText: errorText()),
                                    keyboardType: TextInputType.number,
                                    supportDecoration: true,
                                    icon: Assets.icons.iconIonicIosPricetag.svg(
                                        width: AppFactory.getDimensions(
                                                12, toString())
                                            .w,
                                        color: Colors.white,
                                        height: AppFactory.getDimensions(
                                                14, toString())
                                            .w),
                                  ),
                                ))),
                        SizedBox(
                          height: 5.h,
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
                                AppTextField(
                                  name: '',
                                  lines: 4,
                                  onSaved: (value) {
                                    param['description'] = value;
                                  },
                                  hint: AppFactory.getLabel(
                                      'note_text', 'نص الملاحظة'),
                                  supportUnderLine: false,
                                ),
                                SizedBox(
                                  height:
                                      AppFactory.getDimensions(40, toString())
                                          .h,
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
                          height: 30.h,
                        ),
                        MainAppButton(
                          name: AppFactory.getLabel(
                              'change_state', 'تغيير الحالة'),
                          onClick: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (param['status'] == null) {
                                showFlash('اختر الحالة الجديدة');
                                return;
                              }
                              apiBloc.doAction(
                                  param: BaseStatefulState.addServiceInfo(param,
                                      data: {
                                        'method': 'post',
                                        'currency_code': 'IQD',
                                        '_method': 'put',
                                        'url': 'v1/animals/${widget.id}/status',
                                      }),
                                  supportLoading: true,
                                  supportErrorMsg: false,
                                  onResponse: (json) {
                                    Future.delayed(
                                        Duration.zero,
                                        () => context
                                            .read(animalsProvider.notifier)
                                            .load(
                                                idBreeder: authResponse
                                                        ?.data?.user?.id
                                                        ?.toString() ??
                                                    null));
                                    Future.delayed(
                                        Duration.zero,
                                        () => context
                                            .read(
                                                animalsDetailsProvider.notifier)
                                            .getDetails(widget.id));
                                    Navigator.pop(context, 'success');
                                  });
                            }
                          },
                          bgColor: AppFactory.getColor('primary', toString()),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        MainAppButton(
                          name: AppFactory.getLabel('cancel', 'إلغاء'),
                          onClick: () {
                            Navigator.pop(context);
                          },
                          bgColor: AppFactory.getColor('primary', toString()),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        /* Container(
                          width: 248.w,
                          child: TextResponsive(
                            'يمكنك تغيير الحالة لاحقاً من فايل الكلب أو القط من قسم قططي و كلابي',
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xff3876ba),
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),*/
                        SizedBox(
                          height: 10.h,
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
}
