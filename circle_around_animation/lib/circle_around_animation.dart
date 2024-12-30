import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CircleAroundIcon extends StatefulWidget {
  const CircleAroundIcon(
    this.icon, {
    super.key,
    required this.radius,
    this.phase = 0,
    this.tween,
    this.colorTween,
    required this.circleDuration,
    required this.scaleDuration,
    this.startCircleMotionAutomatically = true,
    this.iconSize = 24,
    this.iconFill,
    this.iconWeight,
    this.iconGrade,
    this.iconOpticalSize,
    this.iconColor,
    this.iconShadows,
    this.semanticLabel,
    this.textDirection,
  });

  /// The icon to display. The available icons are described in [Icons].
  ///
  /// The icon can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  final IconData? icon;

  final double radius;

  /// Should be between 0 and 1
  final double phase;

  /// Scale animation
  final Tween<double>? tween;
  final Tween<double>? colorTween;

  /// Whole circle duration;
  final Duration circleDuration;

  /// Inflate duration and deflate duration
  final Duration scaleDuration;

  final bool startCircleMotionAutomatically;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.size].
  ///
  /// If this [Icon] is being placed inside an [IconButton], then use
  /// [IconButton.iconSize] instead, so that the [IconButton] can make the splash
  /// area the appropriate size as well. The [IconButton] uses an [IconTheme] to
  /// pass down the size to the [Icon].
  final double iconSize;

  /// The fill for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `FILL` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be between 0.0 (unfilled) and 1.0 (filled),
  /// inclusive.
  ///
  /// Can be used to convey a state transition for animation or interaction.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.fill].
  ///
  /// See also:
  ///  * [weight], for controlling stroke weight.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * [opticalSize], for controlling optical size.
  final double? iconFill;

  /// The stroke weight for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `wght` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be greater than 0.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.weight].
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * [opticalSize], for controlling optical size.
  ///  * https://fonts.google.com/knowledge/glossary/weight_axis
  final double? iconWeight;

  /// The grade (granular stroke weight) for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `GRAD` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Can be negative.
  ///
  /// Grade and [weight] both affect a symbol's stroke weight (thickness), but
  /// grade has a smaller impact on the size of the symbol.
  ///
  /// Grade is also available in some text fonts. One can match grade levels
  /// between text and symbols for a harmonious visual effect. For example, if
  /// the text font has a -25 grade value, the symbols can match it with a
  /// suitable value, say -25.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.grade].
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [weight], for controlling stroke weight in a less granular way.
  ///  * [opticalSize], for controlling optical size.
  ///  * https://fonts.google.com/knowledge/glossary/grade_axis
  final double? iconGrade;

  /// The optical size for drawing the icon.
  ///
  /// Requires the underlying icon font to support the `opsz` [FontVariation]
  /// axis, otherwise has no effect. Variable font filenames often indicate
  /// the supported axes. Must be greater than 0.
  ///
  /// For an icon to look the same at different sizes, the stroke weight
  /// (thickness) must change as the icon size scales. Optical size offers a way
  /// to automatically adjust the stroke weight as icon size changes.
  ///
  /// Defaults to nearest [IconTheme]'s [IconThemeData.opticalSize].
  ///
  /// See also:
  ///  * [fill], for controlling fill.
  ///  * [weight], for controlling stroke weight.
  ///  * [grade], for controlling stroke weight in a more granular way.
  ///  * https://fonts.google.com/knowledge/glossary/optical_size_axis
  final double? iconOpticalSize;

  /// The color to use when drawing the icon.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.color].
  ///
  /// The color (whether specified explicitly here or obtained from the
  /// [IconTheme]) will be further adjusted by the nearest [IconTheme]'s
  /// [IconThemeData.opacity].
  ///
  /// {@tool snippet}
  /// Typically, a Material Design color will be used, as follows:
  ///
  /// ```dart
  /// Icon(
  ///   Icons.widgets,
  ///   color: Colors.blue.shade400,
  /// )
  /// ```
  /// {@end-tool}
  final Color? iconColor;

  /// A list of [Shadow]s that will be painted underneath the icon.
  ///
  /// Multiple shadows are supported to replicate lighting from multiple light
  /// sources.
  ///
  /// Shadows must be in the same order for [Icon] to be considered as
  /// equivalent as order produces differing transparency.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.shadows].
  final List<Shadow>? iconShadows;

  /// Semantic label for the icon.
  ///
  /// Announced in accessibility modes (e.g TalkBack/VoiceOver).
  /// This label does not show in the UI.
  ///
  ///  * [SemanticsProperties.label], which is set to [semanticLabel] in the
  ///    underlying	 [Semantics] widget.
  final String? semanticLabel;

  /// The text direction to use for rendering the icon.
  ///
  /// If this is null, the ambient [Directionality] is used instead.
  ///
  /// Some icons follow the reading direction. For example, "back" buttons point
  /// left in left-to-right environments and right in right-to-left
  /// environments. Such icons have their [IconData.matchTextDirection] field
  /// set to true, and the [Icon] widget uses the [textDirection] to determine
  /// the orientation in which to draw the icon.
  ///
  /// This property has no effect if the [icon]'s [IconData.matchTextDirection]
  /// field is false, but for consistency a text direction value must always be
  /// specified, either directly using this property or using [Directionality].
  final TextDirection? textDirection;

  void startCircleMotion() {
    GlobalKey<CircleAroundState>().currentState!._controller3.forward();
  }

  void stopCircleMotion() {
    GlobalKey<CircleAroundState>().currentState!._controller3.stop();
  }

  @override
  State<CircleAroundIcon> createState() => CircleAroundState();
}

class CircleAroundState extends State<CircleAroundIcon> with TickerProviderStateMixin {
  // Scale animation
  late final AnimationController _controller1;
  late final Tween<double> _tween1;
  late final Animation<double> _animation1 = CurvedAnimation(
    parent: _controller1,
    curve: Curves.easeInOutCubic,
  );

  // Move in circle animation
  late final AnimationController _controller2;

  // Start and stop circle animateion
  late final AnimationController _controller3;
  late final Tween<double> _tween3;
  late final Animation<double> _animation3 = CurvedAnimation(
    parent: _controller3,
    curve: Curves.easeInCubic,
  );

  late final AnimationController _controller4;
  late final Tween<double> _tween4;
  late final Animation<double> _animation4 = CurvedAnimation(
    parent: _controller4,
    curve: Curves.easeInOutCubic,
  );

  void startCircleMotion() {
    _controller1
      ..forward()
      ..repeat(reverse: true);
    _controller3.forward();
  }

  void stopCircleMotion() {
    _controller1.reverse();
    _controller3.reverse();
  }

  @override
  void initState() {
    super.initState();
    _tween1 = widget.tween ?? Tween(begin: 1, end: 1);
    _controller1 = AnimationController(
      duration: widget.scaleDuration,
      vsync: this,
    );
    if (widget.phase < 0 || widget.phase > 1) throw Exception('Phase must be between 0 and 1');
    _controller2 = AnimationController(
      vsync: this,
      duration: widget.circleDuration,
    )..repeat();
    _tween3 = Tween(begin: widget.startCircleMotionAutomatically ? widget.radius : 0, end: widget.radius);
    _controller3 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller4 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _tween4 = widget.colorTween ?? Tween(begin: 0, end: 0);
    if (widget.startCircleMotionAutomatically) {
      startCircleMotion();
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2 + widget.iconSize,
      height: widget.radius * 2 + widget.iconSize,
      child: AnimatedBuilder(
        animation: _controller2,
        builder: (context, child) {
          return Center(
            child: Stack(
              children: [
                Positioned(
                  left: _calculateOffset().dx,
                  top: _calculateOffset().dy,
                  child: ScaleTransition(
                    scale: _tween1.animate(_animation1),
                    child: Icon(
                      widget.icon,
                      size: widget.iconSize,
                      fill: widget.iconFill,
                      weight: widget.iconWeight,
                      grade: widget.iconGrade,
                      opticalSize: widget.iconOpticalSize,
                      color: _calculateAnimatedColor(),
                      shadows: widget.iconShadows,
                      semanticLabel: widget.semanticLabel,
                      textDirection: widget.textDirection,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Offset _calculateOffset() {
    final double radius = _tween3.animate(_animation3).value;
    final double angle = (_controller2.value + widget.phase) * 2 * pi;
    final double x = cos(angle) * radius;
    final double y = sin(angle) * radius;
    return Offset(widget.radius + x, widget.radius + y);
  }

  Color? _calculateAnimatedColor() {
    if (widget.iconColor == null && widget.colorTween == null) {
      // Icon default color without animation
      return Theme.of(context).primaryColor;
    }
    if (widget.iconColor == null && widget.colorTween != null) {
      //  Icon default color with animation
      if (_tween4.begin == null || _tween4.end == null) throw Exception('The [begin] and [end] properties must be non-null before the tween is first used.');
      return Theme.of(context).primaryColor.withValues(alpha: _tween4.animate(_animation4).value);
    }
    if (widget.iconColor != null && widget.colorTween == null) {
      // User color without animation
      return widget.iconColor;
    }
    if (widget.iconColor != null && widget.colorTween != null) {
      // User color with animation
      return widget.iconColor!.withValues(alpha: _tween4.animate(_animation4).value);
    }
    return null;
  }
}
