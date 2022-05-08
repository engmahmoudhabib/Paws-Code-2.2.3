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
import 'package:flutter_app/providers/ReviewsProvider.dart';
import 'package:flutter_app/providers/ServicesProvider.dart';
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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

class AddRatingDialog extends StatefulWidget {
  static const String PATH = '/add-rating-dialog';
  final String id;
  final String type;

  AddRatingDialog(this.id, {this.type = 'service_center'});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AddRatingDialogState createState() => _AddRatingDialogState();
}

class _AddRatingDialogState extends BaseStatefulState<AddRatingDialog> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  @override
  void initState() {
    param['score'] = 1.0;
    param['type'] = widget.type;
    param['reviewable_id'] = widget.id;
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
                      'تقييم',
                      style: TextStyle(
                        fontSize: 22,
                        color: const Color(0xff3876ba),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 30.w,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        param['score'] = rating;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: 266.0.w,
                      child: Padding(
                        padding: EdgeInsetsResponsive.only(left: 10, right: 10),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              AppTextField(
                                name: '',
                                onSaved: (value) {
                                  param['comment'] = value;
                                },
                                lines: 2,
                                hint: '',
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
                      name: AppFactory.getLabel('save', 'حفظ'),
                      onClick: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          apiBloc.doAction(
                              param: BaseStatefulState.addServiceInfo(param,
                                  data: {
                                    'method': 'post',
                                    'url': REVIEWS_LIST_API,
                                  }),
                              supportLoading: true,
                              supportErrorMsg: false,
                              onResponse: (json) {
                                if (isSuccess(json)) {

                                  if(widget.type == 'service_center')
                                  Future.delayed(
                                      Duration.zero,
                                      () => context
                                          .read(
                                              servicesDetailsProvider.notifier)
                                          .getDetails(widget.id));
                                  else
                                    Future.delayed(
                                        Duration.zero,
                                            () => context
                                            .read(reviewsProvider(widget.type)
                                            .notifier)
                                            .load(widget.id));

                                  Navigator.pop(context,'success');
                                  handlerResponseMsg(json);
                                }
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
