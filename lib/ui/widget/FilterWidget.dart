import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:get_storage/get_storage.dart';

class FilterWidget extends StatefulWidget {
  final Function(dynamic) onSelected;
  final bool forChangeState;
  final String? selectedId;
  FilterWidget(
      {required this.onSelected, this.forChangeState = false, this.selectedId});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends BaseStatefulState<FilterWidget> {
  List<dynamic> data = [];

  @override
  void initState() {
    data.addAll(getStates());
    super.initState();
  }

  getStates() {
    try {
      List t = copy(GetStorage().read('basics')['enums']['animal_statuses']);
      for (var element in t)
        if (element['id'] == (widget.selectedId ?? '')) {
          element['selected'] = true;
        }

      /* t.insert(0, {
        'id': 'all',
        'margin-left': 48.w,
        'selected': context.read(animalsProvider.notifier).tags == null,
        'name': AppFactory.getLabel('all', 'الكل'),
      });*/

      if (widget.forChangeState)
        t.insert(0, {
          "id": "normal",
          "name": "مخفي",
          "selected": (widget.selectedId ?? '') == 'normal'
        });

      return t;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: AppFactory.getDimensions(33, toString()).w,
        alignment: Alignment.center,
        child: ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsResponsive.only(
              left: AppFactory.getDimensions(30, toString()),
              right: AppFactory.getDimensions(30, toString())),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              widget.onSelected.call(data[index]);
              setState(() {
                data.forEach((element) {
                  element['selected'] = false;
                });
                data[index]['selected'] = true;
              });
            },
            child: Container(
              margin: EdgeInsetsResponsive.only(left: 5, right: 5),
              constraints: BoxConstraints(minWidth: 69.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23.0.w),
                color:
                    data[index]['selected'] != null && data[index]['selected']
                        ? AppFactory.getColor('primary', toString())
                        : Colors.transparent,
                border:
                    data[index]['selected'] != null && data[index]['selected']
                        ? null
                        : Border.all(
                            width: 1,
                            color: AppFactory.getColor('primary', toString()),
                          ),
              ),
              child: Center(
                child: TextResponsive(
                  data[index]['title'] ?? data[index]['name'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFactory.getFontSize(16.0, toString()),
                    fontWeight: FontWeight.w700,
                    color: data[index]['selected'] != null &&
                            data[index]['selected']
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
