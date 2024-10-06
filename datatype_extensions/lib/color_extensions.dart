import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension ColorExtension on Color {
  Color makeDarker(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  Color makeLighter(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color operator +(Color other) => Color.alphaBlend(this, other);
}

extension NullableColorExtension on Color? {
  Color operator +(Color? other) {
    if (this == null && other == null) return Colors.transparent;
    if (this == null) return other!;
    if (other == null) return this!;
    return Color.alphaBlend(this!, other);
  }
}

@immutable
class ColorByBrightness extends Color with Diagnosticable {
  /// Creates an adaptive [Color] that changes its effective color based on the
  /// [BuildContext] given. The default effective color is [lightColor].
  const ColorByBrightness({
    String? debugLabel,
    required Color lightColor,
    required Color darkColor,
  }) : this._(
          lightColor,
          lightColor,
          darkColor,
          null,
          debugLabel,
        );

  const ColorByBrightness._(
    this._effectiveColor,
    this.lightColor,
    this.darkColor,
    this._debugResolveContext,
    this._debugLabel,
  ) : // The super constructor has to be called with a dummy value in order to mark
        // this constructor const.
        // The field `value` is overridden in the class implementation.
        super(0);

  /// The current effective color.
  ///
  /// Defaults to [lightColor] if this [ColorByBrightness] has never been
  /// resolved.
  final Color _effectiveColor;

  @override
  int get value => _effectiveColor.value;

  final String? _debugLabel;

  final Element? _debugResolveContext;

  /// The color to use when the [BuildContext] implies a combination of light mode,
  /// normal contrast, and base interface elevation.
  ///
  /// In other words, this color will be the effective color of the [ColorByBrightness]
  /// after it is resolved against a [BuildContext] that:
  /// - has a [Theme] whose [ThemeData.brightness] is [Brightness.light],
  /// or a [MediaQuery] whose [MediaQueryData.platformBrightness] is [Brightness.light].
  final Color lightColor;

  /// The color to use when the [BuildContext] implies a combination of dark mode,
  /// normal contrast, and base interface elevation.
  ///
  /// In other words, this color will be the effective color of the [ColorByBrightness]
  /// after it is resolved against a [BuildContext] that:
  /// - has a [Theme] whose [ThemeData.brightness] is [Brightness.dark],
  /// or a [MediaQuery] whose [MediaQueryData.platformBrightness] is [Brightness.dark].
  final Color darkColor;

  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is a [ColorByBrightness], but the given [BuildContext]
  /// lacks the dependencies required to the color resolution, the default trait
  /// value will be used ([Brightness.light] platform brightness.
  ///
  /// See also:
  ///
  ///  * [maybeResolve], which is similar to this function, but will allow a
  ///    null `resolvable` color.
  static Color resolve(Color resolvable, BuildContext context) {
    return (resolvable is ColorByBrightness) ? resolvable.resolveFrom(context) : resolvable;
  }

  /// Resolves the given [Color] by calling [resolveFrom].
  ///
  /// If the given color is already a concrete [Color], it will be returned as is.
  /// If the given color is null, returns null.
  /// If the given color is a [ColorByBrightness], but the given [BuildContext]
  /// lacks the dependencies required to the color resolution, the default trait
  /// value will be used ([Brightness.light] platform brightness.
  ///
  /// See also:
  ///
  ///  * [resolve], which is similar to this function, but returns a
  ///    non-nullable value, and does not allow a null `resolvable` color.
  static Color? maybeResolve(Color? resolvable, BuildContext context) {
    if (resolvable == null) {
      return null;
    }
    return (resolvable is ColorByBrightness) ? resolvable.resolveFrom(context) : resolvable;
  }

  /// Resolves this [ColorByBrightness] using the provided [BuildContext].
  ///
  /// Calling this method will create a new [ColorByBrightness] that is
  /// almost identical to this [ColorByBrightness], except the effective
  /// color is changed to adapt to the given [BuildContext].
  ///
  /// Calling this function may create dependencies on the closest instance of
  /// some [InheritedWidget]s that enclose the given [BuildContext]. E.g., if
  /// [darkColor] is different from [lightColor], this method will call
  /// [ThemeData.brightness] in an effort to determine the
  /// brightness.
  ColorByBrightness resolveFrom(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    final Color resolved;
    switch (brightness) {
      case Brightness.light:
        resolved = lightColor;
      case Brightness.dark:
        resolved = darkColor;
    }

    Element? debugContext;
    assert(() {
      debugContext = context as Element;
      return true;
    }());
    return ColorByBrightness._(
      resolved,
      lightColor,
      darkColor,
      debugContext,
      _debugLabel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ColorByBrightness && other.value == value && other.lightColor == lightColor && other.darkColor == darkColor;
  }

  @override
  int get hashCode => Object.hash(
        value,
        lightColor,
        darkColor,
      );

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    String toString(String name, Color color) {
      final String marker = color == _effectiveColor ? '*' : '';
      return '$marker$name = $color$marker';
    }

    final List<String> xs = <String>[
      toString('color', lightColor),
      toString('darkColor', darkColor),
    ];

    return '${_debugLabel ?? objectRuntimeType(this, 'ColorByBrightness')}(${xs.join(', ')}, resolved by: ${_debugResolveContext?.widget ?? "UNRESOLVED"})';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (_debugLabel != null) {
      properties.add(MessageProperty('debugLabel', _debugLabel!));
    }
    properties
      ..add(createColorByBrightnessProperty('color', lightColor))
      ..add(createColorByBrightnessProperty('darkColor', darkColor));
    if (_debugResolveContext != null) {
      properties.add(DiagnosticsProperty<Element>('last resolved', _debugResolveContext));
    }
  }
}

/// Creates a diagnostics property for [ColorByBrightness].
DiagnosticsProperty<Color> createColorByBrightnessProperty(
  String name,
  Color? value, {
  bool showName = true,
  Object? defaultValue = kNoDefaultValue,
  DiagnosticsTreeStyle style = DiagnosticsTreeStyle.singleLine,
  DiagnosticLevel level = DiagnosticLevel.info,
}) {
  if (value is ColorByBrightness) {
    return DiagnosticsProperty<ColorByBrightness>(
      name,
      value,
      description: value._debugLabel,
      showName: showName,
      defaultValue: defaultValue,
      style: style,
      level: level,
    );
  } else {
    return ColorProperty(
      name,
      value,
      showName: showName,
      defaultValue: defaultValue,
      style: style,
      level: level,
    );
  }
}
