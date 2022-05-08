import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:select_dialog/select_dialog.dart';

import 'date_piker/flutter_datetime_picker.dart';
import 'date_piker/src/datetime_picker_theme.dart';
import 'date_piker/src/i18n_model.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final SvgPicture? icon;
  final bool supportDecoration;
  final String name;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enable;
  final bool isDropDown;
  final bool supportUnderLine;
  final Color? iconBackground;
  final Color? borderColor;
  final Color? labelColor;
  final VoidCallback? onTap;
  final bool isBtn;
  final FormFieldSetter<String>? onSaved;
  final List<dynamic>? items;
  final Function(dynamic)? onSelectedValue;
  final ValueChanged<String>? onChanged;
  final String? value;
  final Color? textColor;
  final bool forDate;
  ValueNotifier<bool>? shouldChange;

  CustomTextFieldWidget(
      {this.icon,
      this.keyboardType,
      this.shouldChange,
      this.onTap,
      this.forDate = false,
      this.textColor,
      this.value,
      this.onSelectedValue,
      this.items,
      this.onChanged,
      this.labelColor,
      this.onSaved,
      this.iconBackground,
      this.borderColor,
      this.validator,
      this.isBtn = false,
      this.supportUnderLine = true,
      this.isDropDown = false,
      this.enable = true,
      this.obscureText = false,
      required this.name,
      this.supportDecoration = false});

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.value != null) {
      controller.text = widget.value ?? '';
    }
    widget.shouldChange?.addListener(() {
      controller.text = '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.items != null) {
          SelectDialog.showModal<dynamic>(
            context,
            label: widget.name,
            alwaysShowScrollBar: false,
            showSearchBox: false,
            backgroundColor: Colors.white,
            itemBuilder: (context, item, isSelected) => Padding(
              padding: EdgeInsetsResponsive.only(left: 10, right: 10, top: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextResponsive(
                    item['name'] ??
                        item['title'] ??
                        item['value'] ??
                        item['desc'],
                    style: TextStyle(
                        fontFamily: FontFamily.araHamahAlislam,
                        fontSize: AppFactory.getFontSize(20, toString()),
                        color: widget.textColor ?? Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    height: 0.1,
                    margin:
                        EdgeInsetsResponsive.only(left: 10, right: 10, top: 10),
                    color: AppFactory.getColor('gray_1', toString()),
                  )
                ],
              ),
            ),
            items: widget.items,
            onChange: (dynamic item) {
              FocusScope.of(context)
                  .requestFocus(new FocusNode()); //remove focus
              controller.text = item['name'] ??
                  item['title'] ??
                  item['value'] ??
                  item['desc'] ??
                  '';
              if (widget.onSelectedValue != null) {
                widget.onSelectedValue!.call(item);
              }
            },
          );
        } else if (widget.forDate) {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: DatePickerTheme(
                doneStyle: TextStyle(
                    fontFamily: FontFamily.araHamahAlislam,
                    fontSize: AppFactory.getFontSize(20, toString()),
                    color: AppFactory.getColor('primary', toString())),
                itemStyle: TextStyle(
                    fontFamily: FontFamily.araHamahAlislam,
                    fontSize: AppFactory.getFontSize(20, toString()),
                    color: Colors.black),
                cancelStyle: TextStyle(
                    fontFamily: FontFamily.araHamahAlislam,
                    fontSize: AppFactory.getFontSize(20, toString()),
                    color: Colors.red),
              ),
              minTime: DateTime(1800, 3, 5),
              maxTime: DateTime(2222, 6, 7), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
            controller.text = date.toString().substring(0, 10);
            if (widget.onSelectedValue != null) {
              widget.onSelectedValue!.call(date.toString().substring(0, 10));
            }
            print('confirm' + date.toString().substring(0, 10));
          }, currentTime: DateTime.now(), locale: LocaleType.ar);
        } else if (widget.onTap != null) {
          widget.onTap!.call();
        }
      },
      child: Container(
        height: 58.0.w,
        decoration: widget.supportDecoration
            ? widget.isDropDown
                ? BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0.w),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff707070).withOpacity(0.12),
                        offset: Offset(0, 2.0),
                        blurRadius: 14.0,
                      ),
                    ],
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0.w),
                    ),
                    border: Border.all(
                      width: widget.borderColor != null ? 1 : 0.5,
                      color: widget.borderColor ??
                          AppFactory.getColor('primary', toString()),
                    ),
                  )
            : null,
        margin: EdgeInsetsResponsive.only(
            left: widget.supportDecoration ? 5 : 0,
            right: widget.supportDecoration ? 5 : 0),
        width: AppFactory.getDimensions(303, toString()).w,
        child: Row(
          children: [
            Container(
              width: 28.0.w,
              height: 58.0.w,
              padding: EdgeInsetsResponsive.all(6),
              child: widget.icon,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
                color: widget.iconBackground ??
                    AppFactory.getColor('primary', toString()),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
                child: TextFormField(
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              controller: controller,
              autocorrect: true,
              onSaved: widget.onSaved,
              enabled: widget.enable && !widget.isDropDown,
              obscureText: widget.obscureText,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(
                  fontFamily: FontFamily.araHamahAlislam,
                  fontSize: AppFactory.getFontSize(20, toString()),
                  color: Colors.black),
              decoration: InputDecoration(
                labelText: !widget.supportUnderLine ? '' : widget.name,
                suffixIcon: widget.isDropDown && !widget.isBtn
                    ? Container(
                        margin: EdgeInsetsResponsive.only(
                            right: AppFactory.getDimensions(3, toString()),
                            left: AppFactory.getDimensions(3, toString())),
                        alignment: GetStorage().read('lang') == 'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        width: AppFactory.getDimensions(39, toString()).w,
                        child: SvgPicture.string(
                          '<svg viewBox="57.86 452.0 15.31 8.75" ><path transform="translate(51.67, 440.75)" d="M 13.84339427947998 17.35980606079102 L 19.63088417053223 11.56775856018066 C 20.05924987792969 11.1393928527832 20.75192642211914 11.1393928527832 21.17573547363281 11.56775856018066 C 21.59954452514648 11.99612426757813 21.59954261779785 12.68880081176758 21.17573547363281 13.11716651916504 L 14.61809825897217 19.67936134338379 C 14.20340442657471 20.09405517578125 13.53806972503662 20.10316848754883 13.10970497131348 19.71125984191895 L 6.506495475769043 13.12172317504883 C 6.292312622070313 12.90753936767578 6.1875 12.62500190734863 6.1875 12.34701919555664 C 6.1875 12.06903648376465 6.292312622070313 11.7864990234375 6.506495475769043 11.57231521606445 C 6.934861183166504 11.14395046234131 7.627537727355957 11.14395046234131 8.051345825195313 11.57231521606445 L 13.84339427947998 17.35980606079102 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          width: 15.31.w,
                          color: Colors.black,
                          height: 8.75.w,
                        ))
                    : null,
                prefixIconConstraints: BoxConstraints(
                  maxWidth: AppFactory.getDimensions(39, toString()).w,
                  maxHeight: AppFactory.getDimensions(14, toString()).w,
                ),
                isDense: true,
                errorStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: FontFamily.araHamahAlislam,
                    fontSize: AppFactory.getFontSize(15, toString()).h,
                    color: Colors.red),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: FontFamily.araHamahAlislam,
                    fontSize: AppFactory.getFontSize(20, toString()).h,
                    color: widget.labelColor != null
                        ? widget.labelColor
                        : widget.enable
                            ? AppFactory.getColor('gray', toString())
                            : AppFactory.getColor('gray_1', toString())),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0.1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
