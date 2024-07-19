// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';

class ScreenSize {
  double width;
  double height;

  ScreenSize(this.height, this.width);
}

ScreenSize screenSize(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  ScreenSize thisSize = ScreenSize(size.height, size.width);
  print('height: ${size.height}\t width: ${size.width}');
  return thisSize;
}
