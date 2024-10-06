import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:datatype_extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';

const double _height = 4;
BorderSide _kTopBorder(BuildContext context) => BorderSide(
      // Only Cupertino
      color: const ColorByBrightness(
        lightColor: Color(0x4D000000),
        darkColor: Color(0x26FFFFFF),
      ).resolveFrom(context),
      width: .33,
    );
const Duration _duration = Duration(milliseconds: 250);
const int _kIndeterminateLinearDuration = 1800;

class AdaptiveProgressBar extends StatelessWidget {
  /// Creates a platform adaptive determinate linear progress indicator following Material 3 or Cupertino (iOS 17) design guidelines.
  ///
  /// Progress indicators inform users about the status of ongoing processes, such as loading an app, submitting a form, or saving updates.
  /// They communicate an app’s state and indicate available actions, such as whether users can navigate away from the current screen.
  const AdaptiveProgressBar.determinate({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = _height,
  }) : _isDeterminate = true;

  /// Creates a platform adaptive indeterminate linear progress indicator following Material 3 or Cupertino (iOS 17) design guidelines.
  ///
  /// Progress indicators inform users about the status of ongoing processes, such as loading an app, submitting a form, or saving updates.
  /// They communicate an app’s state and indicate available actions, such as whether users can navigate away from the current screen.
  ///
  /// Note that there is no official guidelines for a Cupertino implementation.
  /// Defining this widget, the Cupertino determinate color design and Material indeterminate animation design were used.
  const AdaptiveProgressBar.indeterminate({
    super.key,
    this.color,
    this.backgroundColor,
    this.height = _height,
  })  : value = 1,
        _isDeterminate = false;

  final double value;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  final bool _isDeterminate;

  @override
  Widget build(BuildContext context) {
    return switch (_isDeterminate) {
      true => switch (designPlatform) {
          CitecPlatform.material => _Material3DeterminateLinearProgressIndicator(
              key: key,
              color: color,
              secondaryColor: backgroundColor,
              duration: _duration,
              progress: value,
              height: height,
            ),
          CitecPlatform.ios => _CupertinoDeterminateLinearProgressBar(
              key: key,
              color: color,
              backgroundColor: backgroundColor,
              duration: _duration,
              progress: value,
              height: height,
            ),
          CitecPlatform.fluent => fluent.ProgressBar(
              key: key,
              activeColor: color,
              backgroundColor: backgroundColor,
              value: value,
              strokeWidth: height,
            ),
          _ => throw UnimplementedError(),
        },
      false => switch (designPlatform) {
          CitecPlatform.material => _Material3IndeterminateLinearProgressIndicator(
              key: key,
              color: color,
              backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary.withOpacity(.2),
              height: height,
            ),
          CitecPlatform.ios => _CupertinoIndeterminateLinearProgressBar(
              key: key,
              color: color,
              backgroundColor: backgroundColor,
              duration: _duration,
              height: height,
            ),
          CitecPlatform.fluent => fluent.ProgressBar(
              key: key,
              activeColor: color,
              backgroundColor: backgroundColor,
              strokeWidth: height,
            ),
          _ => throw UnimplementedError(),
        },
    };
  }
}

class _Material3IndeterminateLinearProgressIndicator extends ProgressIndicator {
  /// Creates an indeterminate linear progress indicator following Material 3 design guidelines.
  const _Material3IndeterminateLinearProgressIndicator({
    super.key,
    super.color,
    super.backgroundColor,
    this.height = _height,
  }) : assert(height > 0);

  /// Defaults to [ThemeData.colorScheme.primary]
  @override
  Color? get color => super.color;

  /// Color of the track being filled by the linear indicator.
  ///
  /// If [backgroundColor] is null then the
  /// ambient [ProgressIndicatorThemeData.linearTrackColor] will be used.
  /// If that is null, then the ambient theme's [ColorScheme.surface]
  /// will be used to draw the track.
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// The height of the line used to draw the linear indicator.
  final double height;

  @override
  State<_Material3IndeterminateLinearProgressIndicator> createState() => _Material3IndeterminateLinearProgressIndicatorState();
}

class _Material3IndeterminateLinearProgressIndicatorState extends State<_Material3IndeterminateLinearProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_Material3IndeterminateLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double animationValue, TextDirection textDirection) {
    final ProgressIndicatorThemeData indicatorTheme = ProgressIndicatorTheme.of(context);
    final Color trackColor = widget.backgroundColor ?? indicatorTheme.linearTrackColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final double minHeight = widget.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.height),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(minHeight / 2)),
        ),
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: minHeight,
        ),
        child: CustomPaint(
          painter: _LinearProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor: widget.color ?? Theme.of(context).colorScheme.primary,
            animationValue: animationValue,
            gap: minHeight,
            textDirection: textDirection,
            indicatorBorderRadius: BorderRadius.circular(minHeight / 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

class _LinearProgressIndicatorPainter extends CustomPainter {
  const _LinearProgressIndicatorPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.animationValue,
    required this.textDirection,
    required this.indicatorBorderRadius,
    required this.gap,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double animationValue;
  final TextDirection textDirection;
  final BorderRadiusGeometry indicatorBorderRadius;
  final double gap;

  // The indeterminate progress animation displays two lines whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    void drawBar(Paint paint, double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
        case TextDirection.ltr:
          left = x;
      }

      final Rect rect = Offset(left, 0.0) & Size(width, size.height);
      if (indicatorBorderRadius != BorderRadius.zero) {
        final RRect rrect = indicatorBorderRadius.resolve(textDirection).toRRect(rect);
        canvas.drawRRect(rrect, paint);
      } else {
        canvas.drawRect(rect, paint);
      }
    }

    final double x1 = size.width * line1Tail.transform(animationValue);
    final double width1 = size.width * line1Head.transform(animationValue) - x1;

    final double y0 = x1 + width1 + gap;

    final double x2 = size.width * line2Tail.transform(animationValue);
    final double width2 = size.width * line2Head.transform(animationValue) - x2;

    final double y1 = x2 + width2 + (width2 == 0 ? 0 : gap);

    drawBar(
        Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
        y0,
        size.width - y0);
    drawBar(
        Paint()
          ..style = PaintingStyle.fill
          ..color = valueColor,
        x1,
        width1);
    drawBar(
        Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
        y1,
        x1 - gap - y1);
    drawBar(
        Paint()
          ..style = PaintingStyle.fill
          ..color = valueColor,
        x2,
        width2);
    drawBar(
        Paint()
          ..style = PaintingStyle.fill
          ..color = backgroundColor,
        0,
        x2 - gap - 0);
  }

  @override
  bool shouldRepaint(_LinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection ||
        oldPainter.indicatorBorderRadius != indicatorBorderRadius;
  }
}

class _Material3DeterminateLinearProgressIndicator extends StatelessWidget {
  /// Creates a determinate linear progress indicator following Material 3 design guidelines.
  const _Material3DeterminateLinearProgressIndicator({
    super.key,
    this.color,
    this.secondaryColor,
    this.duration = const Duration(milliseconds: 250),
    required this.progress,
    this.height = _height,
  });

  /// Defaults to [ThemeData.colorScheme.primary]
  final Color? color;

  /// Defaults to [color] with 20% opacity
  final Color? secondaryColor;
  final Duration duration;
  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(
        begin: 0,
        end: progress,
      ),
      builder: (BuildContext context, double value, _) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double maxWidth = constraints.maxWidth - 2 * height;
            return SizedBox(
              height: height,
              width: constraints.maxWidth,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: height,
                    child: Container(
                      width: max(0, maxWidth * value - ((value == 0 || value == 1) ? 0 : height / 2)),
                      decoration: BoxDecoration(
                        color: color ?? Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                      height: height,
                    ),
                  ),
                  Positioned(
                    right: height,
                    child: Container(
                      width: max(0, maxWidth * (1 - value) - ((value == 0 || value == 1) ? 0 : height / 2)),
                      decoration: BoxDecoration(
                        color: secondaryColor ?? (color ?? Theme.of(context).colorScheme.primary).withOpacity(.2),
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                      height: height,
                    ),
                  ),
                  Positioned(
                    right: height,
                    child: Container(
                      width: height,
                      height: height,
                      decoration: BoxDecoration(
                        color: color ?? Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CupertinoIndeterminateLinearProgressBar extends StatelessWidget {
  /// Creates an indeterminate linear progress indicator following Cupertino (iOS 17) design guidelines.
  const _CupertinoIndeterminateLinearProgressBar({
    super.key,
    this.color,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 250),
    this.height = _height,
  }) : assert(height > .33);

  /// Defaults to [ColorScheme.primary]
  final Color? color;

  /// Defaults to [Colors.transparent]
  final Color? backgroundColor;
  final Duration duration;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border(
              top: _kTopBorder(context),
            ),
          ),
        ),
        LinearProgressIndicator(
          minHeight: height,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context).colorScheme.primary),
          backgroundColor: backgroundColor ?? Colors.transparent,
        ),
      ],
    );
  }
}

class _CupertinoDeterminateLinearProgressBar extends StatelessWidget {
  /// Creates a determinate linear progress indicator following Cupertino (iOS 17) design guidelines.
  const _CupertinoDeterminateLinearProgressBar({
    super.key,
    this.color,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 250),
    required this.progress,
    this.height = _height,
  }) : assert(height > .33);

  /// Defaults to [ThemeData.colorScheme.primary]
  final Color? color;

  /// Defaults to [Colors.transparent]
  final Color? backgroundColor;
  final Duration duration;
  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(
        begin: 0,
        end: progress,
      ),
      builder: (BuildContext context, double value, _) {
        return Stack(
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border(
                  top: _kTopBorder(context),
                ),
              ),
            ),
            LinearProgressIndicator(
              value: value,
              minHeight: height,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context).colorScheme.primary),
              backgroundColor: backgroundColor ?? Colors.transparent,
            ),
          ],
        );
      },
    );
  }
}
