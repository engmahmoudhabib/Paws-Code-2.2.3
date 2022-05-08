import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Positioned(
                left: -AppFactory.getDimensions(241 / 3, toString()).w,
                bottom: -AppFactory.getDimensions(241 / 1.7, toString()).w,
                child: Assets.icons.ellipse3.svg(
                    width: AppFactory.getDimensions(241, toString()).w,
                    height: AppFactory.getDimensions(241, toString()).w)),
            Positioned(
                right: -AppFactory.getDimensions(241 / 1.3, toString()).w,
                bottom: -AppFactory.getDimensions(241 / 5, toString()).w,
                child: Assets.icons.ellipse4.svg(
                    width: AppFactory.getDimensions(241, toString()).w,
                    height: AppFactory.getDimensions(241, toString()).w)),
          ],
        ));
  }
}

class RightLeftWidget extends StatelessWidget {
  const RightLeftWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Positioned(
                left: -AppFactory.getDimensions(241 / 1.2, toString()).w,
                bottom: AppFactory.getDimensions(241 / 2, toString()).w,
                child: Assets.icons.ellipse3.svg(
                    width: AppFactory.getDimensions(241, toString()).w,
                    height: AppFactory.getDimensions(241, toString()).w)),
            Positioned(
                right: -AppFactory.getDimensions(241 / 1.3, toString()).w,
                bottom: AppFactory.getDimensions(241 / 1.1, toString()).w,
                child: Assets.icons.ellipse4.svg(
                    width: AppFactory.getDimensions(241, toString()).w,
                    height: AppFactory.getDimensions(241, toString()).w)),
          ],
        ));
  }
}
