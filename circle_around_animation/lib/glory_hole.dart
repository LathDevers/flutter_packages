import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:circle_around_animation/circle_around_animation.dart';

class GloryHole extends StatefulWidget {
  const GloryHole({
    super.key,
    this.radius,
    this.bandWidth = 20,
    this.dotSaturation = .2,
  });

  final double? radius;
  final double bandWidth;
  final double dotSaturation;

  @override
  State<GloryHole> createState() => _GloryHoleState();
}

class _GloryHoleState extends State<GloryHole> with TickerProviderStateMixin {
  // Pulsating animation
  late final AnimationController _controller1;
  final Tween<double> _tween1 = Tween(begin: .95, end: 1.05);
  late final Animation<double> _animation1 = CurvedAnimation(
    parent: _controller1,
    curve: Curves.easeInOutCubic,
  );

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double maxRadius = min(constraints.maxWidth, constraints.maxHeight) / 2 - widget.bandWidth;
      if (widget.radius == null && maxRadius.isInfinite) throw Exception('Unconstrainted widget. Define radius or use inside a constrained widget.');
      final double restrictedRadius = widget.radius ?? maxRadius;
      final double bandArea = pow(restrictedRadius + widget.bandWidth / 2, 2) * pi - pow(restrictedRadius - widget.bandWidth / 2, 2) * pi;
      final double size = restrictedRadius / 5;
      final int length = ((bandArea / size) * widget.dotSaturation).round();
      final List<
          ({
            double radius,
            double size,
            double phase,
            double opacity,
            double speed,
          })> dots = List.generate(
          length,
          (_) => (
                radius: _getRandom(restrictedRadius - widget.bandWidth / 2, restrictedRadius + widget.bandWidth / 2),
                size: _getRandom(size * .95, size * 1.05),
                phase: _getRandom(0, 1),
                opacity: _getRandom(.3, .9),
                speed: _getRandom(.7, 1.3),
              )).toList();
      return ScaleTransition(
        scale: _tween1.animate(_animation1),
        child: Stack(
          alignment: Alignment.center,
          children: dots
              .map(
                (d) => CircleAroundIcon(
                  CupertinoIcons.circle_fill,
                  radius: d.radius,
                  iconSize: d.size,
                  phase: d.phase,
                  iconColor: HSLColor.fromColor(Theme.of(context).colorScheme.primary).withHue(_getRandom(160, 200)).toColor(),
                  colorTween: Tween<double>(begin: d.opacity - _getRandom(.1, .3), end: d.opacity + _getRandom(0, .1)),
                  circleDuration: Duration(milliseconds: (20000 / d.speed).round()),
                  scaleDuration: Duration(seconds: _getRandom(3, 7).round()),
                  tween: Tween<double>(begin: _getRandom(.5, 1), end: _getRandom(.5, 1)),
                ),
              )
              .toList(),
        ),
      );
    });
  }

  static double _getRandom(double start, double end) => Random().nextDouble() * (end - start) + start;
}
