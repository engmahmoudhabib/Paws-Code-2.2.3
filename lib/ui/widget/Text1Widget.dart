import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';

class Text1Widget extends StatelessWidget {
  final String text;

  const Text1Widget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsResponsive.all(AppFactory.getDimensions(3, toString())),
      child: TextResponsive(
        text,
        style: TextStyle(
            fontSize: AppFactory.getFontSize(18.0, toString()),
            color: AppFactory.getColor('on_primary', toString())),
      ),
    );
  }
}
