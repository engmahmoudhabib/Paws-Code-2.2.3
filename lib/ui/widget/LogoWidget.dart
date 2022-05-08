import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';

class LogoWidget extends StatelessWidget {
  final Color? color;
  final double? top;

  const LogoWidget({Key? key, this.color, this.top}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsetsResponsive.only(
            top: top != null ? AppFactory.getDimensions(top!,toString()) : 0),
        child: Assets.images.logo.image(
            color: color,
            width: AppFactory.getDimensions(123,toString()).w,
            height: AppFactory.getDimensions(148,toString()).h));
  }
}
