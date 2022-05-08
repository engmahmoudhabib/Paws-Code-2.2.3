import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeWidget extends StatefulWidget {
  final Function(String) onSelected;
  final String resendUrl;
  final String? username;

  PinCodeWidget(this.onSelected, {this.resendUrl = '', this.username = ''});

  @override
  _PinCodeWidgetState createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends BaseStatefulState<PinCodeWidget> {
  startTimer() {
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    controller = CountdownTimerController(
        endTime: endTime,
        onEnd: () {
          if (mounted) setState(() {});
        });
  }

  late CountdownTimerController controller;

  @override
  void initState() {
    widget.resendUrl.length > 0 ? startTimer() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppFactory.getDimensions(283, toString()).w,
      child: Column(
        children: [
          Directionality(
              textDirection: TextDirection.ltr,
              child: PinCodeTextField(
                length: 5,
                appContext: context,
                obscureText: false,
                boxShadows: [
                  BoxShadow(
                    color: AppFactory.getColor('gray_1', toString())
                        .withOpacity(0.16),
                    offset: Offset(0, 3.0),
                    blurRadius: 6.0,
                  ),
                ],
                cursorColor: Colors.white,
                animationType: AnimationType.fade,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                textStyle: TextStyle(
                  fontFamily: FontFamily.araHamahAlislam,
                  fontSize: AppFactory.getFontSize(24.0, toString()),
                  color: const Color(0xFF505050),
                ),
                validator: RequiredValidator(errorText: '\n' + errorText()),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(9.0.w),
                  ),
                  fieldHeight: 56.w,
                  inactiveFillColor: Colors.white,
                  fieldWidth: 40.w,
                  selectedColor: AppFactory.getColor('orange', toString()),
                  selectedFillColor: AppFactory.getColor('orange', toString()),
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  borderWidth: 0,
                  activeFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                onCompleted: (v) {
                  widget.onSelected.call(v);
                },
                onChanged: (value) {},
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              )),
          widget.resendUrl.length > 0
              ? CountdownTimer(
                  widgetBuilder: (_, CurrentRemainingTime? time) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (!controller.isRunning) {
                              apiBloc.doAction(
                                  param: {
                                    'url': widget.resendUrl,
                                    'method': 'post',
                                    'username': widget.username!.length > 0
                                        ? widget.username
                                        : null
                                  },
                                  supportLoading: true,
                                  onResponse: (json) {
                                    handlerResponseMsg(json);
                                  },
                                  supportErrorMsg: false);
                              setState(() {
                                startTimer();
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsetsResponsive.all(3),
                            child: TextResponsive(
                              'إعادة إرسال',
                              style: TextStyle(
                                fontSize:
                                    AppFactory.getFontSize(16.0, toString()),
                                color: controller.isRunning
                                    ? Color(0xFFBCBCBC).withOpacity(0.55)
                                    : AppFactory.getColor(
                                        'primary', toString()),
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsResponsive.all(3),
                          child: TextResponsive(
                            time != null
                                ? '00:${(time.sec.toString().length == 1) ? '0' : ''}${time.sec}'
                                : '00:00',
                            style: TextStyle(
                              fontSize:
                                  AppFactory.getFontSize(16.0, toString()),
                              color: AppFactory.getColor('primary', toString()),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    );
                  },
                  controller: controller,
                  textStyle: TextStyle(
                    fontSize: AppFactory.getFontSize(16.0, toString()),
                    color: AppFactory.getColor('primary', toString()),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
