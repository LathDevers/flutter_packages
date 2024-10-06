import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:platform_adaptivity/adaptive_widgets.dart';

class AdaptiveSlider extends StatelessWidget {
  /// Creates a platform adaptive slider, following Material 3 and iOS 17 guidelines.
  const AdaptiveSlider({
    super.key,
    required this.value,
    this.leading,
    this.trailing,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  })  : assert(min <= max),
        _useFillStyle = false;

  /// This constructor replicates Apple Music playback progress and volume control sliders.
  ///
  /// On Material, it still uses the Material 3 slider.
  const AdaptiveSlider.fillStyle({
    super.key,
    required this.value,
    this.leading,
    this.trailing,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  })  : assert(min <= max),
        _useFillStyle = true;

  final bool _useFillStyle;
  final Widget Function(bool)? leading;
  final Widget Function(bool)? trailing;

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// Called during a drag when the user is selecting a new value for the slider
  /// by dragging.
  ///
  /// The slider passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the slider with the new
  /// value.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// AdaptiveSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when the user starts
  ///    changing the value.
  ///  * [onChangeEnd] for a callback that is called when the user stops
  ///    changing the value.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use
  /// [onChanged] for that), but rather to be notified when the user has started
  /// selecting a new value by starting a drag or with a tap.
  ///
  /// The value passed will be the last [value] that the slider had before the
  /// change began.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// AdaptiveSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  ///   onChangeStart: (double startValue) {
  ///     print('Started change at $startValue');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeEnd] for a callback that is called when the value change is
  ///    complete.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  ///
  /// This callback shouldn't be used to update the slider [value] (use
  /// [onChanged] for that), but rather to know when the user has completed
  /// selecting a new [value] by ending a drag or a click.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// AdaptiveSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  ///   onChangeEnd: (double newValue) {
  ///     print('Ended change on $newValue');
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [onChangeStart] for a callback that is called when a value change
  ///    begins.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than or equal to [max].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double min;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [min].
  ///
  /// If the [max] is equal to the [min], then the slider is disabled.
  final double max;

  /// The color to use for the portion of the slider track that is active.
  ///
  /// The "active" side of the slider is the side between the thumb and the
  /// minimum value.
  ///
  /// If null, [SliderThemeData.activeTrackColor] of the ambient
  /// [SliderTheme] is used. If that is null, [ColorScheme.primary] of the
  /// surrounding [ThemeData] is used.
  ///
  /// Using a [SliderTheme] gives much more fine-grained control over the
  /// appearance of various components of the slider.
  final Color? activeColor;

  /// The color for the inactive portion of the slider track.
  ///
  /// The "inactive" side of the slider is the side between the thumb and the
  /// maximum value.
  ///
  /// If null, [SliderThemeData.inactiveTrackColor] of the ambient [SliderTheme]
  /// is used. If that is null and [ThemeData.useMaterial3] is true,
  /// [ColorScheme.surfaceContainerHighest] will be used, otherwise [ColorScheme.primary]
  /// with an opacity of 0.24 will be used.
  ///
  /// Using a [SliderTheme] gives much more fine-grained control over the
  /// appearance of various components of the slider.
  ///
  /// Ignored on Cupertino if not using [AdaptiveSlider.fillStyle] and [CupertinoColors.systemFill] is used instead.
  final Color? inactiveColor;

  /// The color of the thumb.
  ///
  /// If this color is null, [AdaptiveSlider] will use [activeColor], If [activeColor]
  /// is also null, [AdaptiveSlider] will use [SliderThemeData.thumbColor].
  ///
  /// If that is also null, defaults to [ColorScheme.primary].
  ///
  /// The default on Cupertino is [CupertinoColors.white].
  final Color? thumbColor;

  @override
  Widget build(BuildContext context) {
    switch (designPlatform) {
      case CitecPlatform.material:
        return Row(
          children: [
            if (leading != null) leading!(true),
            Flexible(
              child: Slider.adaptive(
                value: value,
                onChanged: onChanged,
                onChangeStart: onChangeStart,
                onChangeEnd: onChangeEnd,
                min: min,
                max: max,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                thumbColor: thumbColor,
              ),
            ),
            if (trailing != null) trailing!(true),
          ],
        );
      case CitecPlatform.ios:
        if (_useFillStyle)
          return FillStyleSlider(
            value: value,
            leading: leading,
            trailing: trailing,
            onChanged: onChanged,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
            min: min,
            max: max,
            activeColor: activeColor,
            tappedActiveColor: thumbColor,
            inactiveColor: inactiveColor,
          );
        else
          return Row(
            children: [
              if (leading != null) leading!(true),
              Flexible(
                child: Slider.adaptive(
                  value: value,
                  onChanged: onChanged,
                  onChangeStart: onChangeStart,
                  onChangeEnd: onChangeEnd,
                  min: min,
                  max: max,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  thumbColor: thumbColor,
                ),
              ),
              if (trailing != null) trailing!(true),
            ],
          );
      case CitecPlatform.fluent:
        return Row(
          children: [
            if (leading != null) leading!(true),
            Flexible(
              child: fluent.Slider(
                value: value,
                onChanged: onChanged,
                onChangeStart: onChangeStart,
                onChangeEnd: onChangeEnd,
                min: min,
                max: max,
                style: fluent.SliderThemeData(
                  activeColor: fluent.ButtonState.all(activeColor),
                  inactiveColor: fluent.ButtonState.all(inactiveColor),
                  thumbColor: fluent.ButtonState.all(thumbColor),
                ),
              ),
            ),
            if (trailing != null) trailing!(true),
          ],
        );
      case CitecPlatform.macos:
      case CitecPlatform.yaru:
        throw UnimplementedError();
    }
  }
}

const double _kTappedHeight = 12;
const double _kUntappedHeight = 6;

class FillStyleSlider extends StatefulWidget {
  const FillStyleSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.leading,
    this.trailing,
    this.min = 0.0,
    this.max = 1.0,
    this.activeColor,
    this.tappedActiveColor,
    this.inactiveColor,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final Widget Function(bool)? leading;
  final Widget Function(bool)? trailing;
  final double min;
  final double max;
  final Color? activeColor;
  final Color? tappedActiveColor;
  final Color? inactiveColor;

  @override
  State<FillStyleSlider> createState() => _FillStyleSliderState();
}

class _FillStyleSliderState extends State<FillStyleSlider> with TickerProviderStateMixin {
  bool tapped = false;
  double value = 0;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    value = widget.value;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(seconds: 1),
    );
    animation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
        reverseCurve: Curves.elasticIn,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Row(
        children: [
          if (widget.leading != null) widget.leading!(tapped),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: widget.leading != null ? 10 : 0, right: widget.trailing != null ? 10 : 0),
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  widget.onChangeStart?.call(value);
                  animationController.forward();
                  setState(() => tapped = true);
                },
                onHorizontalDragUpdate: (details) {
                  final double newValue = min(max(widget.min, value + (details.primaryDelta ?? 0) / multiplier), widget.max);
                  if (value != newValue) {
                    setState(() => value = newValue);
                    widget.onChanged?.call(value);
                  }
                },
                onHorizontalDragEnd: (details) {
                  widget.onChangeEnd?.call(value);
                  animationController.reverse();
                  setState(() => tapped = false);
                },
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Row(
                        children: [
                          Flexible(
                            flex: convert(value).toInt(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: tapped ? _kTappedHeight : _kUntappedHeight,
                              color: tapped ? widget.tappedActiveColor : widget.activeColor,
                            ),
                          ),
                          Flexible(
                            flex: (100 - convert(value)).toInt(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: tapped ? _kTappedHeight : _kUntappedHeight,
                              color: widget.inactiveColor?.withOpacity(.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.trailing != null) widget.trailing!(tapped),
        ],
      ),
    );
  }

  double convert(double value) => (value - widget.min) / widget.max * 100;

  double get multiplier => -.4 * (widget.max - widget.min) + 200.4;
}
