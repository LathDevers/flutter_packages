import 'package:flutter/services.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Return `Theme.of(context).canvasColor`, if [ist] == [soll].
///
/// Return `Theme.of(context).colorScheme.primary`, if [ist] != [soll].
Color getColorForSegmentedControl<T>(
  BuildContext context,
  T ist,
  T soll, {
  Color? isEqualColor,
  Color? isNotEqualColor,
  bool enable = true,
  Color? disabledColor,
}) {
  if (!enable) return disabledColor ?? Colors.grey;
  return ist == soll ? isEqualColor ?? Theme.of(context).canvasColor : isNotEqualColor ?? Theme.of(context).primaryColor;
}

enum _SegmentedControlType { material, cupertino, adaptive }

class AdaptiveSegmented<T> extends StatelessWidget {
  const AdaptiveSegmented({
    super.key,
    required this.segments,
    required this.value,
    required this.onSelectionChanged,
    this.disable = false,
    this.disabledColor,
  }) : _type = _SegmentedControlType.adaptive;

  const AdaptiveSegmented.material({
    super.key,
    required this.segments,
    required this.value,
    required this.onSelectionChanged,
    this.disable = false,
    this.disabledColor,
  }) : _type = _SegmentedControlType.material;

  const AdaptiveSegmented.cupertino({
    super.key,
    required this.segments,
    required this.value,
    required this.onSelectionChanged,
    this.disable = false,
    this.disabledColor,
  }) : _type = _SegmentedControlType.cupertino;

  final _SegmentedControlType _type;

  final Map<T, Widget> segments;
  final T value;
  final Function(T?) onSelectionChanged;
  final bool disable;
  final Color? disabledColor;

  @override
  Widget build(BuildContext context) {
    return switch (_type) {
      _SegmentedControlType.material => buildMaterial(context),
      _SegmentedControlType.cupertino => buildCupertino(context),
      _SegmentedControlType.adaptive => switch (designPlatform) {
          CitecPlatform.ios => buildCupertino(context),
          CitecPlatform.material => buildMaterial(context),
          _ => throw UnimplementedError(),
        },
    };
  }

  Widget buildMaterial(BuildContext context) {
    return SegmentedButton<T>(
      showSelectedIcon: false,
      segments: segments.keys
          .map((e) => ButtonSegment(
                value: e,
                label: segments[e],
              ))
          .toList(),
      selected: {value},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return Theme.of(context).colorScheme.primary;
          return null;
        }),
        side: MaterialStateProperty.resolveWith((states) {
          return BorderSide(color: Theme.of(context).dividerColor);
        }),
        visualDensity: VisualDensity.compact,
      ),
      onSelectionChanged: (Set<T> i) => onSelectionChanged(i.first),
    );
  }

  Widget buildCupertino(BuildContext context) {
    return CupertinoSlidingSegmentedControl<T>(
      groupValue: value,
      children: segments,
      thumbColor: disable ? disabledColor ?? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).dividerColor.withOpacity(.5),
      onValueChanged: disable
          ? (_) {}
          : (value) {
              HapticFeedback.mediumImpact();
              onSelectionChanged(value);
            },
    );
  }
}
