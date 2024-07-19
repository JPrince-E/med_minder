import 'package:flutter/material.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

showCustomSnackBar(
    BuildContext context, content, onpressed, Color color, int milliseconds) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: milliseconds),
      backgroundColor: color,
      content: content is String ? Text(content) : content,
      // margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: '',
        textColor: AppColors.plainWhite,
        onPressed: () {
          // Some code to undo the change.
          onpressed;
        },
      ),
    ),
  );
}
