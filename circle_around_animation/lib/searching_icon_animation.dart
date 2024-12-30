import 'package:platform_adaptivity/adaptive_icons.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:widget_mask/widget_mask.dart';

import 'package:circle_around_animation/circle_around_animation.dart';

class SearchingDocAnimatedWidget extends StatelessWidget {
  const SearchingDocAnimatedWidget({
    super.key,
    required this.icon,
    this.size = 70,
  }) : _diff = .43 * size;

  final IconData icon;
  final double size;

  final double _diff;

  @override
  Widget build(BuildContext context) {
    final double offset = _diff / 2;
    final double magnifierSize = switch (designPlatform) {
      CitecPlatform.material => size,
      CitecPlatform.ios || CitecPlatform.macos => size * .86,
      _ => throw UnimplementedError(),
    };
    final double circleSize = switch (designPlatform) {
      CitecPlatform.material => magnifierSize * .55,
      CitecPlatform.ios || CitecPlatform.macos => magnifierSize * .68,
      _ => throw UnimplementedError(),
    };
    final double circleOffset = switch (designPlatform) {
      CitecPlatform.material => circleSize / 2 + magnifierSize * .07,
      CitecPlatform.ios || CitecPlatform.macos => circleSize / 2 + magnifierSize * -.1,
      _ => throw UnimplementedError(),
    };
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Padding(
          padding: EdgeInsets.only(right: offset, bottom: offset),
          child: Icon(
            icon,
            color: Colors.grey,
            size: size,
          ),
        ),
        WidgetMask(
          blendMode: BlendMode.dstIn,
          childSaveLayer: true,
          mask: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: EdgeInsets.only(bottom: circleOffset, right: circleOffset),
              child: CircleAroundIcon(
                CupertinoIcons.circle_fill,
                radius: 10,
                tween: Tween(begin: 1, end: .9),
                circleDuration: const Duration(seconds: 3),
                scaleDuration: const Duration(seconds: 2),
                iconSize: circleSize,
              ),
            ),
          ),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: EdgeInsets.only(right: offset - _diff / 2, bottom: offset - _diff / 2),
              child: Icon(
                icon,
                color: Colors.grey,
                size: size + _diff,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: circleOffset, right: circleOffset),
          child: CircleAroundIcon(
            CupertinoIcons.circle_fill,
            radius: 10,
            tween: Tween(begin: 1, end: .9),
            circleDuration: const Duration(seconds: 3),
            scaleDuration: const Duration(seconds: 2),
            iconColor: Colors.white.withValues(alpha: .2),
            iconSize: circleSize,
          ),
        ),
        CircleAroundIcon(
          AdaptiveIcons.search,
          radius: 10,
          tween: Tween(begin: 1, end: .9),
          circleDuration: const Duration(seconds: 3),
          scaleDuration: const Duration(seconds: 2),
          iconColor: Colors.grey.shade700,
          iconSize: magnifierSize,
        ),
      ],
    );
  }
}
