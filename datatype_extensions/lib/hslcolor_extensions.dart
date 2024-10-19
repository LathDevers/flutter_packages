import 'package:flutter/material.dart';

extension HSLColorExtension on HSLColor {
  HSLColor withCorrectLightness(double lightness) {
    final double red = toColor().red / 255;
    final double green = toColor().green / 255;
    final double blue = toColor().blue / 255;
    final double blackRed = Colors.black.red / 255;
    final double blackGreen = Colors.black.green / 255;
    final double blackBlue = Colors.black.blue / 255;
    if (red != blackRed || green != blackGreen || blue != blackBlue) return withLightness(lightness);
    return HSLColor.fromAHSL(alpha, hue, 0, lightness);
  }
}
