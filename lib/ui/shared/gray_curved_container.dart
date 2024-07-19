// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';
import 'package:med_minder/utils/screen_util/screen_util.dart';

class CustomCurvedContainer extends StatelessWidget {
  final Color? fillColor;
  Color? borderColor;
  final Widget? child;
  final double? height;
  final double? width;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  CustomCurvedContainer({
    super.key,
    this.fillColor,
    this.borderColor,
    this.child,
    this.height,
    this.width,
    this.topPadding = 4,
    this.bottomPadding = 4,
    this.rightPadding = 12,
    this.leftPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 61,
      width: width ?? screenSize(context).width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(23)),
        border: Border.all(color: borderColor ?? AppColors.transparent),
        color: fillColor ?? AppColors.lightGray,
      ),
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        right: rightPadding,
        left: leftPadding,
      ),
      child: child ?? const SizedBox(),
    );
  }
}
