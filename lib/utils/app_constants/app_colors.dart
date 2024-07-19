import 'package:flutter/material.dart';

class AppColors {
  static Color scaffoldBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color amber = Colors.amber;

  static Color deepBlue = Colors.blue.shade900;

  static Color opaqueDark = fromHex('#7e000000');

  static Color lightGray = fromHex('#161a1818').withOpacity(0.05);

  static Color coolRed = fromHex('#ff4550');

  static Color plainGray = fromHex('#661a1818');

  static Color black = fromHex('#1a1818');

  static Color lighterGray = fromHex('#0c000000').withOpacity(0.02);

  static Color regularGray = fromHex('#28252021');

  // static Color kPrimaryColor = fromHex("#02055A");
  static Color kPrimaryColor = Colors.blue;

  static Color anotherLightGray = fromHex("#D3DDE7");

  static Color fullBlack = fromHex('#000000');

  static Color darkGray = fromHex('#7e1a1818');

  static Color blueGray = fromHex('#6cd3dde7');

  static Color plainWhite = fromHex('#ffffff');

  static Color regularBlue = fromHex('#00A3FF');

  static Color inputFieldBlack = fromHex('#1A1819');

  static Color gold = fromHex('#FFD700');

  static Color silver = fromHex('#C0C0C0');

  static Color bronze = fromHex('#CD7F32');

  static Color? deepBlueGray = Colors.blueGrey[900];

  static Color transparent = Colors.transparent;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
