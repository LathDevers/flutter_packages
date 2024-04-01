import 'dart:ui';

extension BrightnessExtension on Brightness {
  Brightness operator -() => switch (this) {
        Brightness.light => Brightness.dark,
        Brightness.dark => Brightness.light,
      };
}
