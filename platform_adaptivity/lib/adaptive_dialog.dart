import 'dart:ui';

import 'package:datatype_extensions/text_extensions.dart';
import 'package:platform_adaptivity/adaptive_icons.dart';
import 'package:platform_adaptivity/adaptive_navigator.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

const EdgeInsets _kInsetPadding = EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);
const EdgeInsets _kContentPadding = EdgeInsets.all(20);
const double _kBorderRadius = 20;
ImageFilter _blurFilter = ImageFilter.blur(sigmaX: 20, sigmaY: 20);

const Color _kOpaqueBackgroundLight = Color(0xFFEEEDED); // Color(0xCCEEEDED);
const Color _kOpaqueBackgroundDark = Color(0xFF1B1D1C); // Color(0xB31B1D1C);

Color _kOpaqueBackground(BuildContext context) => Theme.of(context).brightness == Brightness.light ? _kOpaqueBackgroundLight : _kOpaqueBackgroundDark;

/// Displays either a Material or Cupertino dialog depending on platform.
///
/// On most platforms this function will act the same as [showDialog], except
/// for iOS and macOS, in which case it will act the same as
/// [showCupertinoDialog].
///
/// On Cupertino platforms, [barrierColor], [useSafeArea], and
/// [traversalEdgeBehavior] are ignored.
Future<T?> showBIVitalDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
  // Dialog contents
  Key? key,
  Widget? title,
  Widget Function(BuildContext)? content,
  List<AdaptiveDialogAction<T>>? actions,
  Color? backgroundColor,
  EdgeInsets? insetPadding,
  EdgeInsets? contentPadding,
  double? borderRadius,
}) {
  late Widget Function(BuildContext) builder;
  late bool enableCupertino;
  if (actions == null) {
    enableCupertino = false;
    builder = (context) => BiVitalDialog.closeButton(
          key: key,
          title: title,
          content: content?.call(context),
          actions: actions,
          backgroundColor: backgroundColor,
          insetPadding: insetPadding ?? _kInsetPadding,
          contentPadding: contentPadding ?? _kContentPadding,
          borderRadius: borderRadius ?? _kBorderRadius,
        );
  } else if (backgroundColor != null || insetPadding != null || contentPadding != null || borderRadius != null) {
    enableCupertino = false;
    builder = (context) => BiVitalDialog.override(
          key: key,
          title: title,
          content: content?.call(context),
          actions: actions,
          backgroundColor: backgroundColor,
          insetPadding: insetPadding ?? _kInsetPadding,
          contentPadding: contentPadding ?? _kContentPadding,
          borderRadius: borderRadius ?? _kBorderRadius,
        );
  } else {
    enableCupertino = true;
    builder = (context) => BiVitalDialog(
          key: key,
          title: title,
          content: content?.call(context),
          actions: actions,
        );
  }
  if (!enableCupertino)
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
      builder: builder,
    );
  return switch (designPlatform) {
    CitecPlatform.ios => showCupertinoDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useRootNavigator: useRootNavigator,
        anchorPoint: anchorPoint,
        routeSettings: routeSettings,
        builder: builder,
      ),
    CitecPlatform.material => showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        traversalEdgeBehavior: traversalEdgeBehavior,
        builder: builder,
      ),
    CitecPlatform.fluent => showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        traversalEdgeBehavior: traversalEdgeBehavior,
        builder: (context) => fluent.ContentDialog(
          key: key,
          title: title,
          content: content?.call(context),
          actions: actions,
        ),
      ),
    _ => throw UnimplementedError(),
  };
}

/// Creates a Material or Cupertino alert dialog.
class BiVitalDialog<T> extends StatelessWidget {
  /// Returns AlertDialog on Material and CupertinoAlertDialog on Cupertino.
  const BiVitalDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
  })  : _enableCupertino = true,
        _showCloseButton = false,
        backgroundColor = null,
        insetPadding = _kInsetPadding,
        contentPadding = _kContentPadding,
        borderRadius = _kBorderRadius;

  /// Creates a Material dialog. Can define padding and radius.
  const BiVitalDialog.override({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.backgroundColor,
    this.insetPadding = _kInsetPadding,
    this.contentPadding = _kContentPadding,
    this.borderRadius = _kBorderRadius,
  })  : _enableCupertino = false,
        _showCloseButton = false;

  const BiVitalDialog.closeButton({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.backgroundColor,
    this.insetPadding = _kInsetPadding,
    this.contentPadding = _kContentPadding,
    this.borderRadius = _kBorderRadius,
  })  : _enableCupertino = false,
        _showCloseButton = true;

  /// The (optional) title of the dialog is displayed in a large font at the top of the dialog.
  ///
  /// Typically a [Text] widget.
  final Widget? title;
  final Widget? content;

  /// The (optional) set of actions that are displayed at the bottom of the dialog.
  final List<AdaptiveDialogAction<T>>? actions;

  /// This is only respected on Material
  final Color? backgroundColor;

  final bool _enableCupertino;
  final bool _showCloseButton;

  /// This is only respected on Material
  final EdgeInsets insetPadding;

  /// This is only respected on Material
  final EdgeInsets contentPadding;

  /// This is only respected on Material
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (_showCloseButton)
      return Stack(
        alignment: Alignment.topLeft,
        children: [
          MaterialDialog(
            title: title,
            content: content,
            actions: actions,
            backgroundColor: backgroundColor,
            insetPadding: insetPadding,
            contentPadding: contentPadding,
            borderRadius: borderRadius,
          ),
          Positioned(
            top: insetPadding.top / 2,
            left: insetPadding.left / 2,
            child: FloatingActionButton(
              heroTag: 'close',
              backgroundColor: Theme.of(context).colorScheme.background,
              onPressed: () => AdaptiveNavigator.pop(context),
              child: Icon(
                AdaptiveIcons.xmark,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      );
    if (!_enableCupertino)
      return MaterialDialog(
        title: title,
        content: content,
        actions: actions,
        backgroundColor: backgroundColor,
        insetPadding: insetPadding,
        contentPadding: contentPadding,
        borderRadius: borderRadius,
      );
    return switch (designPlatform) {
      CitecPlatform.material => MaterialDialog(
          title: title,
          content: content,
          actions: actions,
          backgroundColor: backgroundColor,
          insetPadding: insetPadding,
          contentPadding: contentPadding,
          borderRadius: borderRadius,
        ),
      CitecPlatform.ios => BackdropFilter(
          filter: _blurFilter,
          child: CupertinoAlertDialog(
            title: title,
            content: content,
            actions: actions ?? [],
          ),
        ),
      _ => throw UnimplementedError(),
    };
  }
}

class MaterialDialog<T> extends StatelessWidget {
  const MaterialDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.backgroundColor,
    this.insetPadding = _kInsetPadding,
    this.contentPadding = const EdgeInsets.all(20),
    this.borderRadius = 20,
  });

  final Widget? title;
  final Widget? content;
  final List<AdaptiveDialogAction<T>>? actions;
  final Color? backgroundColor;
  final EdgeInsets insetPadding;
  final EdgeInsets contentPadding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: _blurFilter,
      child: AlertDialog(
        title: title,
        actions: actions,
        backgroundColor: backgroundColor ?? _kOpaqueBackground(context),
        insetPadding: insetPadding,
        contentPadding: contentPadding,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        content: SizedBox(
          width: double.maxFinite,
          child: content,
        ),
      ),
    );
  }
}

/// Creates an action for a Material or Cupertino dialog.
class AdaptiveDialogAction<T> extends StatelessWidget {
  const AdaptiveDialogAction({
    super.key,
    this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.isClosingAction = false,
    this.onCloseReturn,
    required this.child,
  });

  final void Function(BuildContext)? onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final Widget child;
  final bool isClosingAction;
  final T? onCloseReturn;

  @override
  Widget build(BuildContext context) {
    switch (designPlatform) {
      case CitecPlatform.ios:
        Widget content = child;
        if (content is Text) {
          content = content.copyWith(textAlign: TextAlign.end);
          if (isDestructiveAction) {
            content = content.copyWith(
              style: content.style?.copyWith(color: Theme.of(context).colorScheme.error) ?? TextStyle(color: Theme.of(context).colorScheme.error),
            );
          }
        }
        return CupertinoDialogAction(
          onPressed: () {
            if (isClosingAction) Navigator.of(context).pop();
            onPressed?.call(context);
          },
          isDefaultAction: isDefaultAction,
          isDestructiveAction: content is! Text && isDestructiveAction,
          child: content,
        );
      case CitecPlatform.material:
        Widget content = child;
        if (content is Text) {
          content = content.copyWith(textAlign: TextAlign.end);
          if (isDestructiveAction) {
            content = content.copyWith(
              style: content.style?.copyWith(color: Theme.of(context).colorScheme.error) ?? TextStyle(color: Theme.of(context).colorScheme.error),
            );
          }
        }
        return TextButton(
          onPressed: () {
            if (isClosingAction) Navigator.of(context).pop(onCloseReturn);
            onPressed?.call(context);
          },
          child: content,
        );
      case CitecPlatform.fluent:
        if (isDefaultAction) {
          return fluent.FilledButton(
            onPressed: () {
              if (isClosingAction) Navigator.of(context).pop(onCloseReturn);
              onPressed?.call(context);
            },
            child: child,
          );
        } else {
          return fluent.Button(
            onPressed: () {
              if (isClosingAction) Navigator.of(context).pop(onCloseReturn);
              onPressed?.call(context);
            },
            child: child,
          );
        }
      case CitecPlatform.macos:
      case CitecPlatform.yaru:
        throw UnimplementedError();
    }
  }
}
