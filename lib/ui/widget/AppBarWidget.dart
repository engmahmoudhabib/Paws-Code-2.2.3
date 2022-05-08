import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class AppBarWidget extends StatefulWidget {
  final String initId;
  final Function(String) onPageChange;

  AppBarWidget(this.initId, this.onPageChange);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends BaseStatefulState<AppBarWidget> {
  late List<dynamic> data;

  @override
  void initState() {
    data = [
      {
        'id': 'home',
        'name': AppFactory.getLabel('name', 'الرئيسية'),
        'selected': widget.initId == 'home',
        'icon': Assets.icons.homeIc.path
      },
      {
        'id': 'favorite',
        'name': AppFactory.getLabel('favorite', 'المفضلة'),
        'selected': widget.initId == 'favorite',
        'icon': Assets.icons.iconFeatherHeart.path
      },
      {
        'id': 'cats_dogs',
        'name': AppFactory.getLabel('cats_dogs', 'قططي و كلابي'),
        'selected': widget.initId == 'cats_dogs',
        'icon': Assets.icons.outline.path
      },
      {
        'id': 'notifications',
        'name': AppFactory.getLabel('notifications', 'الإشعارات'),
        'selected': widget.initId == 'notifications',
        'icon': Assets.icons.iconIonicMdNotifications.path
      },
      {
        'id': 'my_accounts',
        'name': AppFactory.getLabel('my_accounts', 'حسابي'),
        'selected': widget.initId == 'my_accounts',
        'icon': Assets.icons.userIc.path
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.0.w,
      margin: EdgeInsetsResponsive.only(left: 20, right: 20),
      padding:
          EdgeInsetsResponsive.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: data.map((e) => buildItem(e)).toList(),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0.w),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppFactory.getColor('gray_1', toString()).withOpacity(0.2),
            offset: Offset(0, 2.0),
            blurRadius: 14.0,
          ),
        ],
      ),
    );
  }

  Widget buildItem(dynamic data) {
    return InkWell(
      onTap: () {
        if (!data['selected']) {
          for (var value in this.data) {
            value['selected'] = false;
          }
          setState(() {
            data['selected'] = true;
          });
        }
        widget.onPageChange.call(data['id']);
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(data['icon'],
                color: !data['selected']
                    ? AppFactory.getColor('gray_1', toString())
                    : AppFactory.getColor('primary', toString()),
                width: AppFactory.getDimensions(30, toString()).w,
                height: AppFactory.getDimensions(24, toString()).w),
            SizedBox(
              height: 5.h,
            ),
            TextResponsive(
              data['name'],
              style: TextStyle(
                fontSize: AppFactory.getFontSize(13, toString()),
                color: !data['selected']
                    ? AppFactory.getColor('gray_1', toString())
                    : AppFactory.getColor('primary', toString()),
              ),
              textAlign: TextAlign.right,
            )
          ],
        ),
        padding: EdgeInsetsResponsive.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: data['selected']
              ? AppFactory.getColor('primary', toString()).withOpacity(0.19)
              : Colors.transparent,
        ),
      ),
    );
  }
}
