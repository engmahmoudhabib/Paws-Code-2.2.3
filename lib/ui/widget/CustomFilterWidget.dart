import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';

class CustomFilterWidget extends StatefulWidget {
  final Function(dynamic) onSelected;
  final List<dynamic> data;
  final bool isMulti;

  CustomFilterWidget(
      {required this.onSelected, required this.data, this.isMulti = false});

  @override
  _CustomFilterWidgetState createState() => _CustomFilterWidgetState();
}

class _CustomFilterWidgetState extends BaseStatefulState<CustomFilterWidget> {
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
        height: AppFactory.getDimensions(33, toString()).w,
        alignment: Alignment.topRight,
        child: ListView.builder(
          itemCount: widget.data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsResponsive.only(
              left: AppFactory.getDimensions(10, toString()),
              right: AppFactory.getDimensions(10, toString())),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                if (widget.isMulti) {
                  widget.data[index]['selected'] =
                      widget.data[index]['selected'] != null
                          ? !widget.data[index]['selected']
                          : false;
                  widget.onSelected.call(widget.data);
                } else {
                  widget.data.forEach((element) {
                    element['selected'] = false;
                  });
                  widget.data[index]['selected'] = true;
                  widget.onSelected.call(widget.data[index]);
                }
              });
            },
            child: Container(
              margin: EdgeInsetsResponsive.only(left: 5, right: 5),
              constraints: BoxConstraints(minWidth: 75.w),
              padding: EdgeInsetsResponsive.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23.0.w),
                color: widget.data[index]['selected'] != null &&
                        widget.data[index]['selected']
                    ? AppFactory.getColor('primary', toString())
                    : Colors.transparent,
                border: widget.data[index]['selected'] != null &&
                        widget.data[index]['selected']
                    ? null
                    : Border.all(
                        width: 1,
                        color: AppFactory.getColor('primary', toString()),
                      ),
              ),
              child: Center(
                child: TextResponsive(
                  widget.data[index]['title'] ??
                      widget.data[index]['name'] ??
                      widget.data[index]['value'] ??
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFactory.getFontSize(16.0, toString()),
                    fontWeight: FontWeight.w700,
                    color: widget.data[index]['selected'] != null &&
                            widget.data[index]['selected']
                        ? Colors.white
                        : AppFactory.getColor('primary', toString()),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
