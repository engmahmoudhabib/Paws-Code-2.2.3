import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';

class RadioButtonsWidget extends StatefulWidget {
  final List<dynamic> data;
  final Function(dynamic) onSelected;

  RadioButtonsWidget({required this.data,required this.onSelected});

  @override
  _RadioButtonsState createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: AppFactory.getDimensions(50, toString()).w,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: widget.data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsResponsive.only(
              left: AppFactory.getDimensions(30, toString()),
              right: AppFactory.getDimensions(30, toString())),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              widget.onSelected.call(widget.data[index]);
              setState(() {
                widget.data.forEach((element) {
                  element['selected'] = false;
                });
                widget.data[index]['selected'] = true;
              });
            },
            child: Container(
              padding: EdgeInsetsResponsive.only(
                  left: AppFactory.getDimensions(10, toString()),
                  right: AppFactory.getDimensions(10, toString())),
              child: Row(
                children: [
                  widget.data[index]['selected'] != null &&
                      widget.data[index]['selected']
                      ? buildFullCircle()
                      : buildEmptyCircle(),
                  SizedBox(
                    width: AppFactory.getDimensions(5, toString()).w,
                  ),
                  TextResponsive(
                    widget.data[index]['title'] ??
                        widget.data[index]['name'] ??
                        '',
                    style: TextStyle(
                      fontSize: AppFactory.getFontSize(20.0, toString()),
                      color: AppFactory.getColor('on_primary', toString()),
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
      width: AppFactory.getDimensions(14, toString()).w,
      height: AppFactory.getDimensions(14, toString()).w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: AppFactory.getDimensions(0.7, toString()).w,
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
          width: AppFactory.getDimensions(0.7, toString()).w,
          color: AppFactory.getColor('on_primary', toString()),
        ),
      ),
      child: Container(
        width: AppFactory.getDimensions(10, toString()).w,
        height: AppFactory.getDimensions(10, toString()).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppFactory.getColor('on_primary', toString()),
        ),
      ),
    );
  }
}
