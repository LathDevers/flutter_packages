import 'dart:ui';

import 'package:flutter_map/flutter_map.dart' as flutter_map;

class Polyline extends flutter_map.Polyline {
  Polyline({
    required super.points,
    super.strokeWidth = 1.0,
    super.color = const Color(0xFF00FF00),
    super.borderStrokeWidth = 0.0,
    super.borderColor = const Color(0xFFFFFF00),
    super.gradientColors,
    super.colorsStop,
    super.isDotted = false,
    super.strokeCap = StrokeCap.round,
    super.strokeJoin = StrokeJoin.round,
    super.useStrokeWidthInMeter = false,
  });
}
