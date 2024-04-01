import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class AdaptiveScrollbar extends StatelessWidget {
  /// Creates an iOS style scrollbar on Cupertino and a Material Design scrollbar on Material that wraps the given [child].
  const AdaptiveScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.scrollbarOrientation,
    this.thicknessWhileDragging = defaultThicknessWhileDragging,
    this.radiusWhileDragging = defaultRadiusWhileDragging,
  });

  /// Default value for [thickness] if it's not specified in [CupertinoScrollbar].
  static const double defaultThickness = 3;

  /// Default value for [thicknessWhileDragging] if it's not specified in
  /// [CupertinoScrollbar].
  static const double defaultThicknessWhileDragging = 8.0;

  /// Default value for [radius] if it's not specified in [CupertinoScrollbar].
  static const Radius defaultRadius = Radius.circular(1.5);

  /// Default value for [radiusWhileDragging] if it's not specified in
  /// [CupertinoScrollbar].
  static const Radius defaultRadiusWhileDragging = Radius.circular(4.0);

  /// The thickness of the scrollbar when it's being dragged by the user.
  ///
  /// Only on Cupertino.
  final double thicknessWhileDragging;

  /// The radius of the scrollbar edges when the scrollbar is being dragged by
  /// the user.
  ///
  /// Only on Cupertino.
  final Radius radiusWhileDragging;

  /// {@macro flutter.widgets.Scrollbar.child}
  final Widget child;

  /// {@macro flutter.widgets.Scrollbar.controller}
  final ScrollController? controller;

  /// {@macro flutter.widgets.Scrollbar.thumbVisibility}
  ///
  /// If this property is null, then [ScrollbarThemeData.thumbVisibility] of
  /// [ThemeData.scrollbarTheme] is used. If that is also null, the default value
  /// is false.
  ///
  /// If the thumb visibility is related to the scrollbar's material state,
  /// use the global [ScrollbarThemeData.thumbVisibility] or override the
  /// sub-tree's theme data.
  final bool? thumbVisibility;

  /// {@macro flutter.widgets.Scrollbar.trackVisibility}
  ///
  /// Only on Material.
  final bool? trackVisibility;

  /// The thickness of the scrollbar in the cross axis of the scrollable.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// the default thickness is 4.0 pixels. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultThickness] is used. The remaining platforms have a
  /// default thickness of 8.0 pixels.
  final double? thickness;

  /// The [Radius] of the scrollbar thumb's rounded rectangle corners.
  ///
  /// If null, the default value is platform dependent. On [TargetPlatform.android],
  /// no radius is applied to the scrollbar thumb. On [TargetPlatform.iOS],
  /// [CupertinoScrollbar.defaultRadius] is used. The remaining platforms have a
  /// default [Radius.circular] of 8.0 pixels.
  final Radius? radius;

  /// {@macro flutter.widgets.Scrollbar.notificationPredicate}
  final ScrollNotificationPredicate? notificationPredicate;

  /// {@macro flutter.widgets.Scrollbar.scrollbarOrientation}
  final ScrollbarOrientation? scrollbarOrientation;

  @override
  Widget build(BuildContext context) {
    return switch (designPlatform) {
      CitecPlatform.material => Scrollbar(
          key: key,
          interactive: true,
          controller: controller,
          thumbVisibility: thumbVisibility,
          trackVisibility: trackVisibility,
          thickness: thickness,
          radius: radius,
          notificationPredicate: notificationPredicate,
          scrollbarOrientation: scrollbarOrientation,
          child: child,
        ),
      CitecPlatform.ios => CupertinoScrollbar(
          key: key,
          controller: controller,
          thumbVisibility: thumbVisibility,
          thickness: thickness ?? defaultThickness,
          thicknessWhileDragging: thicknessWhileDragging,
          radius: radius ?? defaultRadius,
          radiusWhileDragging: radiusWhileDragging,
          notificationPredicate: notificationPredicate,
          scrollbarOrientation: scrollbarOrientation,
          child: child,
        ),
      CitecPlatform.fluent => fluent.Scrollbar(
          key: key,
          controller: controller,
          thumbVisibility: thumbVisibility,
          scrollbarOrientation: scrollbarOrientation,
          child: child,
        ),
      _ => throw UnimplementedError(),
    };
  }
}
