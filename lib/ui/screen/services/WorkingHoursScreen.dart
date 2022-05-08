import 'dart:async';

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
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
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
import 'package:time_range_picker/time_range_picker.dart';

class WorkingHoursScreen extends StatefulWidget {
  static const String PATH = '/working-hours';
  final List<dynamic> data;

  const WorkingHoursScreen({Key? key, required this.data}) : super(key: key);

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _WorkingHoursScreenState createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends BaseStatefulState<WorkingHoursScreen> {
  @override
  void initState() {
    super.initState();
  }

  isServiceClicked() {
    int index = -1;
    for (var d in widget.data) {
      index++;

      if (d['selected'] && index <= 2) {
        return true;
      }
    }
    return false;
  }

  isService2RowClicked() {
    int index = -1;
    for (var d in widget.data) {
      index++;
      if (d['selected'] && index > 2) {
        return true;
      }
    }
    return false;
  }

  getSelectedService() {
    for (var d in widget.data) {
      if (d['selected']) {
        return d;
      }
    }
    return null;
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
                          child: buildMainTitle(AppFactory.getLabel(
                              'working_hours', 'مواعيد العمل')),
                        ),
                      ),
                      buildBackBtn(context,
                          color: AppFactory.getColor('primary', toString())),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsetsResponsive.only(left: 20, right: 20, top: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: widget.data
                            .map(
                              (e) => Container(
                                margin: EdgeInsetsResponsive.only(top: 10),
                                padding: EdgeInsetsResponsive.only(
                                    left: AppFactory.getDimensions(
                                        10, toString()),
                                    right: AppFactory.getDimensions(
                                        10, toString())),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          selectTime(e);
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: TextResponsive(
                                                e['title'] ?? e['name'] ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      AppFactory.getFontSize(
                                                          16.0, toString()),
                                                  color: AppFactory.getColor(
                                                      'primary', toString()),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: TextResponsive(
                                                e['from'] != null
                                                    ? (e['from'] ?? '') +
                                                        '-' +
                                                        (e['to'] ?? '')
                                                    : 'انقر لتحديد الوقت',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize:
                                                      AppFactory.getFontSize(
                                                          15.0, toString()),
                                                  fontWeight: FontWeight.bold,
                                                  color: AppFactory.getColor(
                                                      'primary', toString()),
                                                ),
                                              ),
                                            ),
                                            e['from'] != null
                                                ? InkWell(
                                                    onTap: () {
                                                      widget.data
                                                          .forEach((element) {
                                                        element['from'] =
                                                            e['from'];
                                                        element['to'] = e['to'];
                                                      });
                                                      setState(() {});
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsResponsive
                                                              .all(5),
                                                      child: TextResponsive(
                                                        'تطبيق\nعلى الكل',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: AppFactory
                                                              .getFontSize(12.0,
                                                                  toString()),
                                                          color: AppFactory
                                                              .getColor(
                                                                  'primary',
                                                                  toString()),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          e['selected'] =
                                              !(e['selected'] ?? false);
                                          setState(() {});
                                        },
                                        child: e['selected'] != null &&
                                                e['selected']
                                            ? buildFullCircle()
                                            : buildEmptyCircle())
                                  ],
                                ),
                              ),
                            )
                            .toList()),
                  )
                ],
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

  buildFullCircle() {
    return Container(
      width: AppFactory.getDimensions(24, toString()).w,
      height: AppFactory.getDimensions(24, toString()).w,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: const Color(0xffffffff),
              border: Border.all(width: 0.5, color: const Color(0xff707070)),
            ),
          ),
          Container(
            margin: EdgeInsetsResponsive.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: const Color(0xff3876ba),
              border: Border.all(width: 0.5, color: const Color(0xff3876ba)),
            ),
          ),
        ],
      ),
    );
    ;
  }

  getSelected() {
    for (var element in widget.data) {
      if (element['selected']) {
        return element;
      }
    }
  }

  addZero(String msg) {
    if (msg.length == 1) {
      msg = '0' + msg;
    }
    return msg;
  }

  buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextResponsive(
          'البداية:',
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xff3876ba),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 10.w,
        ),
        InkWell(
            onTap: () {},
            child: Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  TextResponsive(
                    getSelected()['from'] ?? '--:--',
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xff3876ba),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SvgPicture.string(
                    '<svg viewBox="218.6 194.0 7.4 4.3" ><path transform="translate(212.37, 182.75)" d="M 9.906986236572266 14.21653747558594 L 12.71873950958252 11.40256977081299 C 12.92685413360596 11.19445610046387 13.26337909698486 11.19445610046387 13.46928024291992 11.40256977081299 C 13.67517948150635 11.61068344116211 13.67517948150635 11.94720840454102 13.46928024291992 12.15532207489014 L 10.28336238861084 15.34345436096191 C 10.08189010620117 15.54492568969727 9.758647918701172 15.54935455322266 9.550535202026367 15.35895156860352 L 6.34247875213623 12.15753650665283 C 6.238421440124512 12.05348014831543 6.1875 11.9162130355835 6.1875 11.78116035461426 C 6.1875 11.64610767364502 6.238421440124512 11.5088415145874 6.34247875213623 11.40478420257568 C 6.550592422485352 11.19667053222656 6.887117385864258 11.19667053222656 7.093018054962158 11.40478420257568 L 9.906986236572266 14.21653747558594 Z" fill="#3876ba" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
              padding: EdgeInsetsResponsive.only(top: 3, bottom: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.0),
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xff3876ba)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            )),
        SizedBox(
          width: 20.w,
        ),
        TextResponsive(
          'النهاية:',
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xff3876ba),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          width: 10.w,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                TextResponsive(
                  getSelected()['to'] ?? '--:--',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3876ba),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 10.w,
                ),
                SvgPicture.string(
                  '<svg viewBox="218.6 194.0 7.4 4.3" ><path transform="translate(212.37, 182.75)" d="M 9.906986236572266 14.21653747558594 L 12.71873950958252 11.40256977081299 C 12.92685413360596 11.19445610046387 13.26337909698486 11.19445610046387 13.46928024291992 11.40256977081299 C 13.67517948150635 11.61068344116211 13.67517948150635 11.94720840454102 13.46928024291992 12.15532207489014 L 10.28336238861084 15.34345436096191 C 10.08189010620117 15.54492568969727 9.758647918701172 15.54935455322266 9.550535202026367 15.35895156860352 L 6.34247875213623 12.15753650665283 C 6.238421440124512 12.05348014831543 6.1875 11.9162130355835 6.1875 11.78116035461426 C 6.1875 11.64610767364502 6.238421440124512 11.5088415145874 6.34247875213623 11.40478420257568 C 6.550592422485352 11.19667053222656 6.887117385864258 11.19667053222656 7.093018054962158 11.40478420257568 L 9.906986236572266 14.21653747558594 Z" fill="#3876ba" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  allowDrawingOutsideViewBox: true,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
            padding: EdgeInsetsResponsive.only(top: 3, bottom: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.0),
              color: const Color(0xffffffff),
              border: Border.all(width: 1.0, color: const Color(0xff3876ba)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
        getSelected()['from'] != null
            ? Container(
                margin: EdgeInsetsResponsive.only(left: 5, right: 5),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getSelected()['from'] = null;
                        getSelected()['to'] = null;
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsetsResponsive.all(10),
                        child: SvgPicture.string(
                          '<svg viewBox="19.0 111.0 20.1 20.1" ><path transform="translate(15.63, 107.63)" d="M 13.4375 3.375 C 7.878936290740967 3.375 3.375 7.878936290740967 3.375 13.4375 C 3.375 18.99606513977051 7.878936290740967 23.5 13.4375 23.5 C 18.99606513977051 23.5 23.5 18.99606513977051 23.5 13.4375 C 23.5 7.878935813903809 18.99606513977051 3.375 13.4375 3.375 Z M 15.98698997497559 17.08031845092773 L 13.4375 14.53082847595215 L 10.88801002502441 17.08031845092773 C 10.58806991577148 17.38025856018066 10.0946216583252 17.38025856018066 9.794681549072266 17.08031845092773 C 9.644710540771484 16.93034934997559 9.567306518554688 16.73200035095215 9.567306518554688 16.53365325927734 C 9.567306518554688 16.33530616760254 9.644710540771484 16.13695907592773 9.794681549072266 15.98698997497559 L 12.34416961669922 13.4375 L 9.794679641723633 10.88801002502441 C 9.644710540771484 10.73804092407227 9.567306518554688 10.53969192504883 9.567306518554688 10.34134674072266 C 9.567306518554688 10.14299774169922 9.644710540771484 9.944650650024414 9.794679641723633 9.794681549072266 C 10.09461975097656 9.494741439819336 10.58806991577148 9.494741439819336 10.88801002502441 9.794681549072266 L 13.43749809265137 12.34417152404785 L 15.98698806762695 9.794681549072266 C 16.28692817687988 9.494741439819336 16.7803783416748 9.494741439819336 17.0803165435791 9.794681549072266 C 17.38025665283203 10.0946216583252 17.38025665283203 10.58806991577148 17.0803165435791 10.88801193237305 L 14.53082847595215 13.4375 L 17.08031845092773 15.98698997497559 C 17.38025856018066 16.28693008422852 17.38025856018066 16.7803783416748 17.08031845092773 17.08031845092773 C 16.7803783416748 17.38509559631348 16.28693008422852 17.38509559631348 15.98698997497559 17.08031845092773 Z" fill="#feca2e" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsetsResponsive.all(5),
                        child: Icon(
                          Icons.done_all_outlined,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container()
      ],
    );
  }

  selectTime(item) async {
    TimeRange result = await showTimeRangePicker(
      context: context,
      fromText: 'البداية',
      autoAdjustLabels: true,
      toText: 'النهاية',
      interval: Duration(minutes: 30),
      minDuration: Duration(minutes: 30),
      use24HourFormat: false,
      padding: 30,
      strokeWidth: 20,
      handlerRadius: 14,
      strokeColor: AppFactory.getColor('primary', toString()),
      handlerColor: AppFactory.getColor('primary', toString()).withOpacity(0.5),
      selectedColor: AppFactory.getColor('primary', toString()),
      backgroundColor: Colors.black.withOpacity(0.3),
      ticks: 12,
      ticksColor: Colors.white,
      snap: true,
      labelStyle: TextStyle(
          fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
      timeTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      activeTimeTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
    );
    item['from'] = addZero(result.startTime.hour.toString()) +
        ':' +
        addZero(result.startTime.minute.toString());
    item['to'] = addZero(result.endTime.hour.toString()) +
        ':' +
        addZero(result.endTime.minute.toString());
    setState(() {});
  }
}
