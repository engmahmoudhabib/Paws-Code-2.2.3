import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_svg/svg.dart';

class CheckBoxWidget extends StatefulWidget {
  final List<dynamic> data;
  final Function(dynamic) onSelected;
  final Axis axis;

  CheckBoxWidget({required this.data,this.axis=Axis.vertical, required this.onSelected});

  @override
  _CheckBoxWidgetState createState() =>
      _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {

  @override
  void initState() {
    widget.data.forEach((element) {
      if (element['selected'] == null) {
        element['selected'] = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
         alignment: Alignment.centerRight,
        height: widget.axis.index==Axis.horizontal.index? 50.w:null,
        child: ListView.builder(
          itemCount: widget.data.length,
          shrinkWrap: true,
          scrollDirection: widget.axis,
          padding: EdgeInsetsResponsive.only(
              left: AppFactory.getDimensions(15, toString()),
              right: AppFactory.getDimensions(15, toString())),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              widget.data.forEach((element) {
                element['selected'] = false;
              });
              setState(() {

                widget.data[index]['selected'] = ! widget.data[index]['selected'];
              });
              widget.onSelected.call(widget.data[index]);

            },
            child: Container(
              margin: EdgeInsetsResponsive.only(top: 10),
              padding: EdgeInsetsResponsive.only(
                  left: AppFactory.getDimensions(widget.axis.index==Axis.horizontal.index? 5:15, toString()),
                  right: AppFactory.getDimensions(widget.axis.index==Axis.horizontal.index? 5:15, toString())),
              child: Row(
                children: [
                  widget.data[index]['selected'] != null &&
                          widget.data[index]['selected']
                      ? buildFullCircle()
                      : buildEmptyCircle(),
                  SizedBox(
                    width: AppFactory.getDimensions(10, toString()).w,
                  ),
                   TextResponsive(
                      widget.data[index]['title'] ??
                          widget.data[index]['name'] ??
                          widget.data[index]['value'] ??'',
                      style: TextStyle(
                        fontSize: AppFactory.getFontSize(13.0, toString()),
                        color: AppFactory.getColor('primary', toString()),
                      ),

                  )
                ],
              ),
            ),
          ),
        ));
  }

  Container buildEmptyCircle() {
    return Container(
      width: 13.98.w,
      height: 13.98.w,
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
      '<svg viewBox="323.81 265.84 27.98 27.98" ><path transform="translate(323.81, 263.59)" d="M 24.97773551940918 30.22515296936035 L 2.997328519821167 30.22515296936035 C 1.341928958892822 30.22515296936035 0 28.88321876525879 0 27.22781562805176 L 0 5.247337818145752 C 0 3.591932773590088 1.341928958892822 2.25 2.997328519821167 2.25 L 24.97773551940918 2.25 C 26.63313674926758 2.25 27.97506523132324 3.591932773590088 27.97506523132324 5.247337818145752 L 27.97506523132324 27.22781562805176 C 27.97506523132324 28.88321876525879 26.63313674926758 30.22515296936035 24.97773551940918 30.22515296936035 Z M 12.19625377655029 24.10190391540527 L 23.68601417541504 12.61211013793945 C 24.0761661529541 12.22195625305176 24.0761661529541 11.58933067321777 23.68601417541504 11.19917678833008 L 22.27308464050293 9.78624153137207 C 21.88293266296387 9.396089553833008 21.25031089782715 9.396026611328125 20.86009407043457 9.78624153137207 L 11.48975849151611 19.15654754638672 L 7.114970207214355 14.78174781799316 C 6.724818706512451 14.39159202575684 6.092194557189941 14.39159202575684 5.701980113983154 14.78174781799316 L 4.28905200958252 16.19467926025391 C 3.898900270462036 16.5848331451416 3.898900270462036 17.21745872497559 4.28905200958252 17.60761260986328 L 10.78326416015625 24.10184478759766 C 11.1734790802002 24.49212265014648 11.80603885650635 24.49212265014648 12.19625377655029 24.10190391540527 Z" fill="#3876ba" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
      width: 13.98.w,
      height: 13.98.w,
    );
  }
}
