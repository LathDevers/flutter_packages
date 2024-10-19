extension IntExtension on int {
  String pluralAware(String unit, [bool isTwoDigit = false]) {
    String text = toString();
    if (isTwoDigit) text = text.padLeft(2, '0');
    return abs() == 1 ? '$text $unit' : '$text ${unit}s';
  }
}
