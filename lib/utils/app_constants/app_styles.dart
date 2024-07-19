// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

class AppStyles {
  ///TextStyles
  static const FontWeight _lightWeight = FontWeight.w300;
  static const FontWeight _semiBoldWeight = FontWeight.w600;
  static const FontWeight _extraBoldWeight = FontWeight.w800;
  static const FontWeight _normalWeight = FontWeight.w400;
  static const FontWeight _regularWeight = FontWeight.w500;
  static const FontWeight _boldWeight = FontWeight.w700;

  static TextStyle navBarStringStyle(Color color) => _base(
        10,
        _regularWeight,
        color,
      );

  static TextStyle defaultKeyStringStyle(double fontSize) => _base(
        fontSize,
        _semiBoldWeight,
        AppColors.deepBlueGray,
      );

  static TextStyle keyStringStyle(double fontSize, Color textcolor) => _base(
        fontSize,
        _boldWeight,
        textcolor,
      );

  static TextStyle regularStringStyle(double fontSize, Color textcolor) =>
      _base(
        fontSize,
        _semiBoldWeight,
        textcolor,
      );

  static TextStyle subStringStyle(double fontSize, Color textcolor) => _base(
        fontSize,
        _normalWeight,
        textcolor,
      );

  static TextStyle inputStringStyle(Color textcolor) => _base(
        16,
        _semiBoldWeight,
        textcolor,
      );

  static TextStyle hintStringStyle(double fontSize, {Color? color}) => _base(
        fontSize,
        _regularWeight,
        color ?? AppColors.darkGray,
      );

  static TextStyle floatingHintStringStyle(double fontSize, {Color? color}) =>
      _base(
        fontSize,
        _regularWeight,
        color ?? AppColors.lightGray.withOpacity(0.4),
      );

  static TextStyle normalStringStyle(double fontSize, {Color? color}) => _base(
        fontSize,
        _regularWeight,
        color ?? AppColors.plainWhite,
      );

  static TextStyle floatingHintStringStyleColored(
          double fontSize, Color color) =>
      _base(
        fontSize,
        _normalWeight,
        color,
      );

  //#base style
  static TextStyle _base(
    double size,
    FontWeight? fontWeight,
    Color? color,
  ) {
    return baseStyle(fontSize: size, fontWeight: fontWeight, color: color);
  }

  static TextStyle baseStyle({
    double fontSize = 10,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Roboto',
      fontWeight: fontWeight ?? _normalWeight,
      color: color ?? AppColors.darkGray,
    );
  }
}
