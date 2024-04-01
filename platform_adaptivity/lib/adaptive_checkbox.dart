import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:platform_adaptivity/adaptive_widgets.dart';

class AdaptiveCheckbox extends StatelessWidget {
  /// Creates a Material or iOS-style checkbox.
  ///
  /// On Material returns a normal [Checkbox] with the additional option of removing padding, by editing [isPadding].
  /// On Cupertino returns an iOS-style checkbox, i. e., circle with a Cupertino-style check mark [CupertinoIcons.check_mark_circled_solid].
  const AdaptiveCheckbox({
    super.key,
    this.value = false,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.tickColor,
    this.splashRadius,
    this.shape,
    this.enabled = true,
    this.deactivatedColor,
    this.isPadding = true,
  });

  final bool value;
  final Function(bool?)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? tickColor;
  final double? splashRadius;
  final OutlinedBorder? shape;
  final bool enabled;
  final Color? deactivatedColor;
  final bool isPadding;

  @override
  Widget build(BuildContext context) {
    switch (designPlatform) {
      case CitecPlatform.material:
        return _wrapperMaterial(
          isPadding: isPadding,
          child: Checkbox(
            key: key,
            value: value,
            onChanged: !enabled ? null : (newValue) => onTapHaptic(onChanged, newValue),
            splashRadius: enabled ? splashRadius : 0,
            shape: shape,
            tristate: false,
            checkColor: tickColor,
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (!enabled) return deactivatedColor;
              if (states.contains(MaterialState.selected)) return activeColor;
              return Colors.transparent;
            }),
          ),
        );
      case CitecPlatform.ios:
        return _CupertinoCheckbox(
          key: key,
          value: value,
          onChanged: !enabled ? null : onChanged,
          splashRadius: splashRadius,
          isPadding: isPadding,
          activeColor: enabled ? activeColor : deactivatedColor,
          inactiveColor: enabled ? inactiveColor : deactivatedColor,
          tickColor: tickColor,
        );
      case CitecPlatform.macos:
        return CupertinoCheckbox(
          key: key,
          value: value,
          tristate: false,
          onChanged: onChanged,
          activeColor: enabled ? activeColor : deactivatedColor,
          checkColor: tickColor,
          shape: shape,
        );
      case CitecPlatform.fluent:
        return fluent.Checkbox(
          key: key,
          checked: value,
          onChanged: onChanged,
        );
      case CitecPlatform.yaru:
        throw UnimplementedError();
    }
  }

  Widget _wrapperMaterial({
    required bool isPadding,
    required Widget child,
  }) {
    if (isPadding) return child;
    return SizedBox(
      height: 24,
      width: 24,
      child: child,
    );
  }
}

/// This draws an iOS-style checkbox, i. e., circle with a Cupertino-style check mark [CupertinoIcons.check_mark_circled_solid].
///
/// *[Checkbox.adaptive] draws in contrast a MacOS-style checkbox.*
class _CupertinoCheckbox extends StatelessWidget {
  const _CupertinoCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.tickColor = Colors.transparent,
    this.splashRadius,
    this.isPadding = true,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? tickColor;
  final double? splashRadius;
  final bool isPadding;

  @override
  Widget build(BuildContext context) {
    final double size = Theme.of(context).iconTheme.size ?? 24;
    return IconButton(
      onPressed: onTapHapticFeedback(() => onChanged?.call(!value)),
      padding: isPadding ? null : EdgeInsets.zero,
      splashRadius: splashRadius,
      icon: value
          ? Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(
                  CupertinoIcons.circle_fill,
                  color: tickColor ?? Colors.transparent,
                  size: size - 5,
                ),
                Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: activeColor ?? Theme.of(context).colorScheme.primary,
                  size: size,
                ),
              ],
            )
          : Icon(
              CupertinoIcons.circle,
              color: inactiveColor ?? Theme.of(context).colorScheme.primary,
              size: size,
            ),
    );
  }
}
