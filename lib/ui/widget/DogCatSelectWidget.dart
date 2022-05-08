import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_svg/svg.dart';

class DogCatSelectWidget extends StatefulWidget {
  final List<dynamic> data;
  final Function(dynamic) onSelected;

  DogCatSelectWidget({required this.data, required this.onSelected});

  @override
  _DogCatSelectWidgetState createState() => _DogCatSelectWidgetState();
}

class _DogCatSelectWidgetState extends State<DogCatSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140.0.h,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: widget.data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              widget.data.forEach((element) {
                element['selected'] = false;
              });
              setState(() {
                widget.data[index]['selected'] =
                    !widget.data[index]['selected'];
              });
              widget.onSelected.call(widget.data[index]);
            },
            child: Container(
              width: 90.0.w,
              height: 100.0.h,
              margin: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 5.w, right: 5.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(widget.data[index]['icon'],
                      width: AppFactory.getDimensions(62, toString()).h,
                      height: widget.data[index]['height']),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextResponsive(
                          widget.data[index]['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFactory.getFontSize(22, toString()),
                            color: AppFactory.getColor('primary', toString()),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: widget.data[index]['selected']
                    ? AppFactory.getColor('primary', toString())
                        .withOpacity(0.29)
                    : Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: widget.data[index]['selected']
                      ? AppFactory.getColor('primary', toString())
                      : Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppFactory.getColor('gray_1', toString())
                        .withOpacity(
                            widget.data[index]['selected'] ? 0.08 : 0.2),
                    offset: Offset(0, 2.0),
                    blurRadius: 5.0,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Container buildEmptyCircle() {
    return Container(
      width: AppFactory.getDimensions(14, toString()).w,
      height: AppFactory.getDimensions(14, toString()).w,
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
      width: AppFactory.getDimensions(14, toString()).w,
      height: AppFactory.getDimensions(14, toString()).w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: AppFactory.getDimensions(0.3, toString()).w,
          color: AppFactory.getColor('gray_1', toString()),
        ),
      ),
      child: Container(
        width: AppFactory.getDimensions(10, toString()).w,
        height: AppFactory.getDimensions(10, toString()).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppFactory.getColor('orange', toString()),
        ),
      ),
    );
  }
}
