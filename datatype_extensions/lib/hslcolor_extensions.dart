import 'package:flutter/material.dart';

extension HSLColorExtension on HSLColor {
  HSLColor withCorrectLightness(double lightness) {
    final double red = toColor().r / 255;
    final double green = toColor().g / 255;
    final double blue = toColor().b / 255;
    final double blackRed = Colors.black.r / 255;
    final double blackGreen = Colors.black.g / 255;
    final double blackBlue = Colors.black.b / 255;
    if (red != blackRed || green != blackGreen || blue != blackBlue) return withLightness(lightness);
    return HSLColor.fromAHSL(alpha, hue, 0, lightness);
  }
}
