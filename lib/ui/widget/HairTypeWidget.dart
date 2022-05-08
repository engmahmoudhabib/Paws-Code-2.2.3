import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';

class HairTypeWidget extends StatefulWidget {
  final Function(dynamic) onSelected;
  final String? selectedId;

  HairTypeWidget({required this.onSelected, this.selectedId});

  @override
  _HairTypeWidgetState createState() => _HairTypeWidgetState();
}

class _HairTypeWidgetState extends BaseStatefulState<HairTypeWidget> {
  List<dynamic> data = [];

  @override
  void initState() {
    data = [
      {
        'id': 'short_hair',
        'selected':
            widget.selectedId != null && widget.selectedId == 'short_hair',
        'icon': Assets.icons.borderCollieHead.svg(),
        'title': AppFactory.getLabel('short_hair', 'شعر قصير'),
      },
      {
        'id': 'medium_hair',
        'selected':
            widget.selectedId != null && widget.selectedId == 'medium_hair',
        'icon': Assets.icons.borderCollieDogHead.svg(),
        'title': AppFactory.getLabel('medium_hair', 'شعر وسط'),
      },
      {
        'id': 'long_hair',
        'selected':
            widget.selectedId != null && widget.selectedId == 'long_hair',
        'icon': Assets.icons.longHairedDogHead.svg(),
        'title': AppFactory.getLabel('long_hair', 'شعر طويل'),
      },
      {
        'id': 'without_hair',
        'selected':
            widget.selectedId != null && widget.selectedId == 'without_hair',
        'icon': Assets.icons.dog777.svg(),
        'title': AppFactory.getLabel('without_hair', 'بلا شعر'),
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: AppFactory.getDimensions(90, toString()).w,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: data
              .map((e) => Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        widget.onSelected.call(e);
                        setState(() {
                          data.forEach((element) {
                            element['selected'] = false;
                          });
                          e['selected'] = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsetsResponsive.only(left: 5, right: 5),
                        constraints:
                            BoxConstraints(minWidth: DESIGN_WIDTH / 5.3),
                        child: Column(
                          children: [
                            Container(
                              width: 62.0.w,
                              height: 62.0.w,
                              padding: EdgeInsetsResponsive.all(7),
                              child: e['icon'],
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0.w),
                                color: e['selected']
                                    ? AppFactory.getColor('primary', toString())
                                        .withOpacity(0.2)
                                    : Colors.white,
                                border: Border.all(
                                  width: 1.0,
                                  color:
                                      AppFactory.getColor('gray_1', toString()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            TextResponsive(
                              e['title'],
                              style: TextStyle(
                                fontSize: 15.0,
                                color:
                                    AppFactory.getColor('gray_1', toString()),
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ));
  }
}
