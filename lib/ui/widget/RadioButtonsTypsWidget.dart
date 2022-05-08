import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';

class RadioButtonsTypesWidget extends StatefulWidget {
  final List<dynamic> data;
  final Function(dynamic) onSelected;

  RadioButtonsTypesWidget({required this.data, required this.onSelected});

  @override
  _RadioButtonsTypesState createState() => _RadioButtonsTypesState();
}

class _RadioButtonsTypesState extends State<RadioButtonsTypesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: AppFactory.getDimensions(85, toString()).w,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: widget.data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsResponsive.only(
              left: AppFactory.getDimensions(30, toString()),
              right: AppFactory.getDimensions(30, toString())),
          itemBuilder: (context, index) => Card(
            color: Colors.white,
            child: InkWell(
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
                    left: AppFactory.getDimensions(20, toString()),
                    right: AppFactory.getDimensions(20, toString())),
                child: Row(
                  children: [
                    widget.data[index]['selected'] != null &&
                            widget.data[index]['selected']
                        ? buildFullCircle()
                        : buildEmptyCircle(),
                    SizedBox(
                      width: AppFactory.getDimensions(5, toString()).w,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 130.w),
                      child: TextResponsive(
                        widget.data[index]['title'] ??
                            widget.data[index]['name'] ??
                            '',
                        style: TextStyle(
                          fontSize: AppFactory.getFontSize(14.0, toString()),
                          color: AppFactory.getColor('primary', toString()),
                        ),
                      ),
                    )
                  ],
                ),
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
          width: AppFactory.getDimensions(2, toString()).w,
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
          width: AppFactory.getDimensions(2, toString()).w,
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
