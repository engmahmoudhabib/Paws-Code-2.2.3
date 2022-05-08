import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';

class CustomFilterWidgetWrap extends StatefulWidget {
  final Function(dynamic) onSelected;
  final List<dynamic> data;
  final bool isMulti;

  CustomFilterWidgetWrap(
      {required this.onSelected, required this.data, this.isMulti = false});

  @override
  _CustomFilterWidgetWrapState createState() => _CustomFilterWidgetWrapState();
}

class _CustomFilterWidgetWrapState
    extends BaseStatefulState<CustomFilterWidgetWrap> {
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
    return Wrap(
      children: widget.data
          .map((e) => InkWell(
                onTap: () {
                  setState(() {
                    if (widget.isMulti) {
                      e['selected'] = !e['selected'];
                      widget.onSelected.call(widget.data);
                    } else {
                      widget.data.forEach((element) {
                        element['selected'] = false;
                      });
                      e['selected'] = true;
                      widget.onSelected.call(e);
                    }
                  });
                },
                child: Wrap(
                  children: [
                    Container(
                      padding: EdgeInsetsResponsive.all(5),
                      margin: EdgeInsetsResponsive.all(5),
                      constraints: BoxConstraints(minWidth: 69.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23.0.w),
                        color: e['selected'] != null && e['selected']
                            ? AppFactory.getColor('primary', toString())
                            : Colors.transparent,
                        border: e['selected'] != null && e['selected']
                            ? null
                            : Border.all(
                                width: 1,
                                color:
                                    AppFactory.getColor('primary', toString()),
                              ),
                      ),
                      child: TextResponsive(
                        e['title'] ?? e['name'] ?? e['value'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFactory.getFontSize(16.0, toString()),
                          fontWeight: FontWeight.w700,
                          color: e['selected'] != null && e['selected']
                              ? Colors.white
                              : AppFactory.getColor('primary', toString()),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
