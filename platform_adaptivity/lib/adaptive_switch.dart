import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:platform_adaptivity/adaptive_widgets.dart';

Color _primaryColor(BuildContext context, bool isDestructive) {
  if (isDestructive) return Theme.of(context).colorScheme.error;
  return Theme.of(context).colorScheme.primary;
}

Color _thumbColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (Theme.of(context).brightness == Brightness.light) {
    return _lightThumbColor(context, states, isDestructive, isEnabled);
  } else {
    return _darkThumbColor(context, states, isDestructive, isEnabled);
  }
}

Color _lightThumbColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (states.contains(WidgetState.selected)) {
    if (isEnabled)
      return const Color(0xFFFFFFFF);
    else
      return const Color(0xFFFFFFFF);
  } else {
    if (isEnabled) {
      return HSLColor.fromColor(_primaryColor(context, isDestructive)).withSaturation(.1).toColor().withOpacity(.8);
    } else {
      return HSLColor.fromColor(_primaryColor(context, isDestructive)).withSaturation(.1).withLightness(.6).toColor().withOpacity(.7);
    }
  }
}

Color _darkThumbColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (isEnabled) {
    if (states.contains(WidgetState.selected)) return _primaryColor(context, isDestructive);
    return HSLColor.fromColor(_primaryColor(context, isDestructive)).withSaturation(.1).withLightness(.6).toColor();
  } else {
    if (states.contains(WidgetState.selected)) return Theme.of(context).colorScheme.surface;
    return HSLColor.fromColor(_primaryColor(context, isDestructive)).withSaturation(.15).withLightness(.6).toColor().withOpacity(.5);
  }
}

Color _trackColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (Theme.of(context).brightness == Brightness.light) {
    return _lightTrackColor(context, states, isDestructive, isEnabled);
  } else {
    return _darkTrackColor(context, states, isDestructive, isEnabled);
  }
}

Color _lightTrackColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (states.contains(WidgetState.selected)) {
    if (isEnabled)
      return _primaryColor(context, isDestructive);
    else
      return _primaryColor(context, isDestructive).withOpacity(.2);
  }
  if (isEnabled)
    return _primaryColor(context, isDestructive).withOpacity(.05);
  else
    return Colors.transparent;
}

Color _darkTrackColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (states.contains(WidgetState.selected)) {
    if (isEnabled)
      return HSLColor.fromColor(_primaryColor(context, isDestructive)).withLightness(.75).withSaturation(.5).toColor();
    else
      return HSLColor.fromColor(_primaryColor(context, isDestructive)).withLightness(.6).withSaturation(.2).toColor().withOpacity(.15);
  }
  if (isEnabled)
    return _primaryColor(context, isDestructive).withOpacity(.1);
  else
    return Colors.transparent;
}

Color _trackOutlineColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (Theme.of(context).brightness == Brightness.light) {
    return _lightTrackOutlineColor(context, states, isDestructive, isEnabled);
  } else {
    return _darkTrackOutlineColor(context, states, isDestructive, isEnabled);
  }
}

Color _lightTrackOutlineColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (states.contains(WidgetState.selected)) return Colors.transparent;
  if (isEnabled)
    return _lightThumbColor(context, states, isDestructive, isEnabled);
  else
    return _lightThumbColor(context, states, isDestructive, isEnabled).withOpacity(.25);
}

Color _darkTrackOutlineColor(BuildContext context, Set<WidgetState> states, bool isDestructive, bool isEnabled) {
  if (states.contains(WidgetState.selected)) return Colors.transparent;
  if (isEnabled)
    return _darkThumbColor(context, states, isDestructive, isEnabled);
  else
    return _darkThumbColor(context, states, isDestructive, isEnabled).withOpacity(.25);
}

class AdaptiveSwitch extends StatelessWidget {
  /// Creates a platform adaptive toggle widget.
  const AdaptiveSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.isDestructive = false,
  }) : _enabled = onChanged != null;

  /// Whether this switch is on or off.
  final bool value;

  /// Whether this switch is enabled or disabled.
  ///
  /// If this is false, [onChanged] will be ignored and the color of the switch will be changed to indicate that it is disabled.
  final bool _enabled;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// AdaptiveSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final void Function(bool)? onChanged;

  /// This shows the user that the action of this switch is destructive.
  ///
  /// If true, the switch uses the error color.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return switch (designPlatform) {
      CitecPlatform.material => Switch(
          thumbColor: WidgetStateProperty.resolveWith((states) => _thumbColor(context, states, isDestructive, _enabled)),
          trackColor: WidgetStateProperty.resolveWith((states) => _trackColor(context, states, isDestructive, _enabled)),
          trackOutlineColor: WidgetStateProperty.resolveWith((states) => _trackOutlineColor(context, states, isDestructive, _enabled)),
          value: value,
          onChanged: _enabled ? (bool newValue) => onTapHaptic(onChanged, newValue) : null,
        ),
      CitecPlatform.ios => Switch.adaptive(
          thumbColor: WidgetStateProperty.resolveWith((states) => Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return _primaryColor(context, isDestructive);
            return _inactiveTrackColor(context);
          }),
          value: value,
          onChanged: _enabled ? (bool newValue) => onTapHaptic(onChanged, newValue) : null,
        ),
      CitecPlatform.fluent => fluent.ToggleSwitch(
          checked: value,
          onChanged: _enabled ? onChanged : null,
        ),
      _ => throw UnimplementedError(),
    };
  }
}

Color _inactiveTrackColor(BuildContext context) {
  const Color kInactiveTrackColor = Color(0xFF787880);
  if (Theme.of(context).brightness == Brightness.light)
    return kInactiveTrackColor.withOpacity(.16);
  else
    return kInactiveTrackColor.withOpacity(.32);
}
