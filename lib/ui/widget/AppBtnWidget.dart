import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class MainAppButton extends StatefulWidget {
  final Color? bgColor;
  final Color? textColor;
  final String? name;
  final SvgPicture? icon;
  final bool isProcessing;
  final VoidCallback onClick;
  final bool supportShadow;

  final double? width;
  final double? fontSize;

  MainAppButton(
      {this.bgColor,
      this.fontSize,
      this.width,
      this.supportShadow = true,
      required this.onClick,
      this.isProcessing = false,
      this.icon,
      this.name,
      this.textColor});

  @override
  _MainAppButtonState createState() => _MainAppButtonState();
}

class _MainAppButtonState extends BaseStatefulState<MainAppButton> {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void _tapDown(TapDownDetails details) {
    if (!widget.isProcessing) _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    if (!widget.isProcessing) _controller.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        onTap: !widget.isProcessing ? widget.onClick : null,
        child: Transform.scale(
            scale: _scale,
            child: Container(
              width:
                  widget.width ?? AppFactory.getDimensions(283, toString()).w,
              height: AppFactory.getDimensions(48, toString()).w,
              padding: EdgeInsetsResponsive.only(
                  left: AppFactory.getDimensions(20, toString()),
                  right: AppFactory.getDimensions(20, toString())),
              child: !widget.isProcessing
                  ? Row(
                      children: [
                        widget.icon ?? Container(),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(
                                left: AppFactory.getDimensions(5, toString()),
                                right: AppFactory.getDimensions(5, toString())),
                            child: TextResponsive(
                              widget.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: widget.fontSize ?? 20.0,
                                height: 0.27.w,
                                color: widget.textColor ?? Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        widget.icon != null
                            ? Container(
                                width: widget.icon!.width,
                                height: widget.icon!.height)
                            : Container(),
                      ],
                    )
                  : SpinKitCircle(
                      color: widget.textColor ?? Colors.white,
                      //  lineWidth: 3,
                      duration: Duration(milliseconds: 700),
                      size: AppFactory.getDimensions(48 / 1.5, toString()).w,
                    ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    AppFactory.getDimensions(28, toString()).w),
                color: widget.bgColor ?? Color(0xffFECA2E),
                boxShadow: widget.supportShadow
                    ? [
                        BoxShadow(
                          color: Color(0xff707070).withOpacity(0.16),
                          offset: Offset(0, 3.0),
                          blurRadius: 14.0,
                        ),
                      ]
                    : null,
              ),
            )));
  }
}
