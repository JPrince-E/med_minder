// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final bool? styleBoolValue;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final void Function()? onPressed;

  const CustomButton(
      {Key? key,
      this.styleBoolValue,
      required this.width,
      this.height,
      this.child,
      this.color,
      this.onPressed,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ??
          () {
            print('Custom Button pressed');
          },
      style: TextButton.styleFrom(
        fixedSize: Size(width!, height ?? 60),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 28),
        ),
        backgroundColor: color ?? AppColors.kPrimaryColor,
      ),
      child: child ?? const SizedBox(),
    );
  }
}
