import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'AppTextFieldWidget.dart';

class ProfileTextFieldWidget extends StatefulWidget {
  final dynamic data;
  final Function(dynamic) onSelected;
  final AppTextField appTextField;

  ProfileTextFieldWidget({required this.data,required this.appTextField, required this.onSelected});

  @override
  _ProfileTextFieldState createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends BaseStatefulState<ProfileTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:
      AppFactory.getDimensions(303, toString()).w,
      alignment: Alignment.center,
      padding: EdgeInsetsResponsive.only(
          top: AppFactory.getDimensions(25, toString() )),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextResponsive(
                  widget.data['title'] ?? widget.data['name'] ?? '',
                  style: TextStyle(
                    fontSize: AppFactory.getFontSize(15.0, toString()),
                    color: AppFactory.getColor('gray_1', toString()),
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.data['selected'] = true;
                      });
                      widget.onSelected.call(widget.data);
                    },
                    child: Container(
                      padding: EdgeInsetsResponsive.all(5),
                      child: Row(
                        children: [
                          TextResponsive(
                            AppFactory.getLabel('yes', 'نعم'),
                            style: TextStyle(
                              fontSize:
                                  AppFactory.getFontSize(15.0, toString()),
                              color: AppFactory.getColor('gray_1', toString()),
                            ),
                          ),
                          SizedBox(
                            width: AppFactory.getDimensions(5, toString()).w,
                          ),
                          widget.data['selected'] != null &&
                                  widget.data['selected']
                              ? buildFullCircle()
                              : buildEmptyCircle(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppFactory.getDimensions(10, toString()).w,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.data['selected'] = false;
                      });
                      widget.onSelected.call(widget.data);
                    },
                    child: Container(
                      padding: EdgeInsetsResponsive.all(5),
                      child: Row(
                        children: [
                          TextResponsive(
                            AppFactory.getLabel('no', 'لا'),
                            style: TextStyle(
                              fontSize:
                                  AppFactory.getFontSize(15.0, toString()),
                              color: AppFactory.getColor('gray_1', toString()),
                            ),
                          ),
                          SizedBox(
                            width: AppFactory.getDimensions(5, toString()).w,
                          ),
                          widget.data['selected'] != null &&
                                  !widget.data['selected']
                              ? buildFullCircle()
                              : buildEmptyCircle(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          !widget.data['selected']
              ? widget.appTextField
              : Container()
        ],
      ),
    );
  }

  buildEmptyCircle() {
    return Container(
      width: 15.0.w,
      height: 15.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: Colors.white,
        border: Border.all(
          width: 0.3,
          color: AppFactory.getColor('gray_1', toString()),
        ),
      ),
    );
    ;
  }

  buildFullCircle() {
    return SvgPicture.string(
      '<svg viewBox="85.0 271.0 14.61 14.61" ><path transform="translate(85.0, 268.75)" d="M 13.0440845489502 16.859375 L 1.565290212631226 16.859375 C 0.7007935047149658 16.859375 0 16.1585807800293 0 15.2940845489502 L 0 3.815289974212646 C 0 2.950793266296387 0.7007935047149658 2.25 1.565290212631226 2.25 L 13.0440845489502 2.25 C 13.90858173370361 2.25 14.609375 2.950793266296387 14.609375 3.815289974212646 L 14.609375 15.2940845489502 C 14.609375 16.1585807800293 13.90858173370361 16.859375 13.0440845489502 16.859375 Z M 6.369231224060059 13.66165065765381 L 12.36951065063477 7.66137170791626 C 12.5732593536377 7.457622528076172 12.5732593536377 7.127248287200928 12.36951065063477 6.923500061035156 L 11.63163948059082 6.185627937316895 C 11.42789077758789 5.981879234313965 11.0975170135498 5.981846809387207 10.8937349319458 6.185627937316895 L 6.000278949737549 11.07905292510986 L 3.715640068054199 8.794414520263672 C 3.511891603469849 8.590664863586426 3.181517362594604 8.590664863586426 2.977736473083496 8.794414520263672 L 2.239865064620972 9.532285690307617 C 2.036116600036621 9.736034393310547 2.036116600036621 10.06640815734863 2.239865064620972 10.27015686035156 L 5.631327152252197 13.66161823272705 C 5.835108757019043 13.86543273925781 6.165449619293213 13.86543273925781 6.369231224060059 13.66165065765381 Z" fill="#3876ba" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
      width: 14.61.w,
      height: 14.61.w,
    );
  }
}
