import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'dart:math' as math;

const double _kMinCircularProgressIndicatorSize = 36.0;
const int _kIndeterminateCircularDuration = 1333 * 2222;
const double _kDefaultIndicatorSize = 20.0;
const Duration _kTweenDuration = Duration(milliseconds: 250);
const double _kDefaultStrokeWidth = 4.0;

class AdaptiveCircularProgressIndicator extends StatelessWidget {
  /// Creates a platform adaptive determinate circular progress indicator following Material 3 or Cupertino (iOS 17) design guidelines.
  ///
  /// Note that there is no official guidelines for a Cupertino implementation.
  /// Defining this widget, the Cupertino indeterminate color design was used.
  const AdaptiveCircularProgressIndicator.determinate({
    super.key,
    required this.value,
    this.color,
    this.size = _kDefaultIndicatorSize,
  })  : assert(size > 0),
        assert(value >= 0 && value <= 1),
        _isDeterminate = true;

  /// Creates a platform adaptive indeterminate circular progress indicator following Material 3 or Cupertino (iOS 17) design guidelines.
  const AdaptiveCircularProgressIndicator.indeterminate({
    super.key,
    this.color,
    this.size = _kDefaultIndicatorSize,
  })  : assert(size > 0),
        value = 1,
        _isDeterminate = false;

  final double value;
  final Color? color;
  final double size;

  final bool _isDeterminate;

  @override
  Widget build(BuildContext context) {
    return switch (_isDeterminate) {
      true => switch (designPlatform) {
          CitecPlatform.ios => SizedBox(
              width: size,
              height: size,
              child: AspectRatio(
                aspectRatio: 1,
                child: _CupertinoDeterminateCircularProgressIndicator(
                  key: key,
                  value: value,
                  color: color,
                  strokeWidth: size / 5,
                ),
              ),
            ),
          CitecPlatform.material => SizedBox(
              width: size,
              height: size,
              child: AspectRatio(
                aspectRatio: 1,
                child: _Material3DeterminateCircularProgressIndicator(
                  key: key,
                  value: value,
                  color: color,
                  strokeWidth: size / 5,
                ),
              ),
            ),
          CitecPlatform.fluent => SizedBox(
              width: size,
              height: size,
              child: AspectRatio(
                aspectRatio: 1,
                child: fluent.ProgressRing(
                  key: key,
                  value: value,
                  strokeWidth: size / 5,
                  activeColor: color,
                ),
              ),
            ),
          _ => throw UnimplementedError(),
        },
      false => switch (designPlatform) {
          CitecPlatform.ios => _CupertinoIndeterminateCircularProgressIndicator(
              key: key,
              color: color,
              radius: size / 2,
            ),
          CitecPlatform.material => SizedBox(
              width: size,
              height: size,
              child: AspectRatio(
                aspectRatio: 1,
                child: _Material3IndeterminateCircularProgressIndicator(
                  key: key,
                  color: color,
                  strokeWidth: size / 5,
                ),
              ),
            ),
          CitecPlatform.fluent => SizedBox(
              width: size,
              height: size,
              child: AspectRatio(
                aspectRatio: 1,
                child: fluent.ProgressRing(
                  key: key,
                  strokeWidth: size / 5,
                  activeColor: color,
                ),
              ),
            ),
          _ => throw UnimplementedError(),
        },
    };
  }
}

class _Material3IndeterminateCircularProgressIndicator extends StatefulWidget {
  const _Material3IndeterminateCircularProgressIndicator({
    super.key,
    this.color,
    this.strokeWidth = _kDefaultStrokeWidth,
  });

  final Color? color;
  final double strokeWidth;

  @override
  State<_Material3IndeterminateCircularProgressIndicator> createState() => _Material3IndeterminateCircularProgressIndicatorState();
}

class _Material3IndeterminateCircularProgressIndicatorState extends State<_Material3IndeterminateCircularProgressIndicator> with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  late AnimationController _controller;
  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _offsetTween = CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween = CurveTween(curve: const SawTooth(_rotationCount));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void didUpdateWidget(_Material3IndeterminateCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controller.isAnimating) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          constraints: const BoxConstraints(
            minWidth: _kMinCircularProgressIndicatorSize,
            minHeight: _kMinCircularProgressIndicatorSize,
          ),
          child: CustomPaint(
            painter: _CircularProgressIndicatorPainter(
              backgroundColor: Colors.transparent,
              value: null,
              valueColor: widget.color ?? ProgressIndicatorTheme.of(context).color ?? Theme.of(context).colorScheme.primary,
              headValue: _strokeHeadTween.evaluate(_controller),
              tailValue: _strokeTailTween.evaluate(_controller),
              offsetValue: _offsetTween.evaluate(_controller),
              rotationValue: _rotationTween.evaluate(_controller),
              strokeWidth: widget.strokeWidth,
              strokeAlign: 0.0,
              strokeCap: StrokeCap.round,
            ),
          ),
        );
      },
    );
  }
}

class _Material3DeterminateCircularProgressIndicator extends StatelessWidget {
  const _Material3DeterminateCircularProgressIndicator({
    super.key,
    required this.value,
    this.color,
    this.strokeWidth = _kDefaultStrokeWidth,
  });

  /// The value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  final double value;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: _kTweenDuration,
      tween: Tween<double>(
        begin: 0,
        end: value,
      ),
      builder: (BuildContext context, double value, _) {
        return Container(
          constraints: const BoxConstraints(
            minWidth: _kMinCircularProgressIndicatorSize,
            minHeight: _kMinCircularProgressIndicatorSize,
          ),
          child: CustomPaint(
            painter: _CircularProgressIndicatorPainter(
              backgroundColor: (color ?? ProgressIndicatorTheme.of(context).color ?? Theme.of(context).colorScheme.primary).withOpacity(.2),
              value: value,
              valueColor: color ?? ProgressIndicatorTheme.of(context).color ?? Theme.of(context).colorScheme.primary,
              headValue: 0,
              tailValue: 0,
              offsetValue: 0,
              rotationValue: 0,
              strokeWidth: strokeWidth,
              strokeAlign: 0.0,
              strokeCap: StrokeCap.round,
            ),
          ),
        );
      },
    );
  }
}

class _CircularProgressIndicatorPainter extends CustomPainter {
  _CircularProgressIndicatorPainter({
    this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
    required this.strokeWidth,
    required this.strokeAlign,
    this.strokeCap,
  })  : arcStart = value != null ? _startAngle : _startAngle + tailValue * 3 / 2 * math.pi + rotationValue * math.pi * 2.0 + offsetValue * 0.5 * math.pi,
        arcSweep = value != null ? clampDouble(value, 0.0, 1.0) * _sweep : math.max(headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi, _epsilon),
        _gap = .35;

  final Color? backgroundColor;
  final Color valueColor;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double strokeWidth;
  final double strokeAlign;
  final double arcStart;
  final double arcSweep;
  final StrokeCap? strokeCap;
  final double _gap;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Use the negative operator as intended to keep the exposed constant value
    // as users are already familiar with.
    final double strokeOffset = strokeWidth / 2 * -strokeAlign;
    final Offset arcBaseOffset = Offset(strokeOffset, strokeOffset);
    final Size arcActualSize = Size(
      size.width - strokeOffset * 2,
      size.height - strokeOffset * 2,
    );

    if (backgroundColor != null) {
      final Paint backgroundPaint = Paint()
        ..color = backgroundColor!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      if (value == null && strokeCap == null) {
        // Indeterminate
        backgroundPaint.strokeCap = StrokeCap.square;
      } else {
        // Butt when determinate (value != null) && strokeCap == null;
        backgroundPaint.strokeCap = strokeCap ?? StrokeCap.butt;
      }

      canvas.drawArc(
        arcBaseOffset & arcActualSize,
        _startAngle + arcSweep + _gap,
        2 * math.pi - arcSweep - 2 * _gap,
        false,
        backgroundPaint,
      );
    }

    if (value == null && strokeCap == null) {
      // Indeterminate
      paint.strokeCap = StrokeCap.square;
    } else {
      // Butt when determinate (value != null) && strokeCap == null;
      paint.strokeCap = strokeCap ?? StrokeCap.butt;
    }

    canvas.drawArc(
      arcBaseOffset & arcActualSize,
      arcStart + _gap,
      arcSweep - 2 * _gap,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.offsetValue != offsetValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth ||
        oldPainter.strokeAlign != strokeAlign ||
        oldPainter.strokeCap != strokeCap;
  }
}

class _CupertinoIndeterminateCircularProgressIndicator extends StatelessWidget {
  const _CupertinoIndeterminateCircularProgressIndicator({
    super.key,
    this.color,
    this.radius = _kDefaultIndicatorSize / 2,
  });

  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      key: key,
      color: color ?? Theme.of(context).colorScheme.primary,
      radius: 14,
    );
  }
}

class _CupertinoDeterminateCircularProgressIndicator extends StatelessWidget {
  const _CupertinoDeterminateCircularProgressIndicator({
    super.key,
    required this.value,
    this.color,
    this.strokeWidth = _kDefaultStrokeWidth,
  });

  final double value;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: _kTweenDuration,
      tween: Tween<double>(
        begin: 0,
        end: value,
      ),
      builder: (BuildContext context, double value, _) {
        return CircularProgressIndicator(
          key: key,
          value: value,
          color: color ?? Theme.of(context).colorScheme.primary,
          strokeWidth: strokeWidth,
          backgroundColor: (color ?? Theme.of(context).colorScheme.primary).withOpacity(.2),
          strokeCap: StrokeCap.round,
        );
        /*return CupertinoActivityIndicator.partiallyRevealed(
          key: key,
          progress: value,
          color: color ?? Theme.of(context).colorScheme.primary,
          radius: 14,
        );*/
      },
    );
  }
}
