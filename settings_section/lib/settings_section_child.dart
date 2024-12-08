import 'package:datatype_extensions/string_extensions.dart';
import 'package:datatype_extensions/color_extensions.dart';
import 'package:datatype_extensions/iterable_extensions.dart';
import 'package:platform_adaptivity/adaptive_checkbox.dart';
import 'package:platform_adaptivity/adaptive_dropdown.dart';
import 'package:platform_adaptivity/adaptive_pulldown.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:platform_adaptivity/adaptive_listtile.dart';
import 'package:platform_adaptivity/adaptive_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsSectionDefaults {
  static const double radius = 10;
  static const double margin = 8;
  static const TextStyle explanationTextStyle = TextStyle(fontSize: 12, color: Colors.grey, height: 1);
}

abstract class SettingsSectionChild extends Widget {
  const SettingsSectionChild({super.key});
}

class SettingsSectionSubColumn extends StatelessWidget implements SettingsSectionChild {
  const SettingsSectionSubColumn({
    super.key,
    this.elevation = 0,
    this.color,
    required this.subsections,
  });

  final Iterable<SettingsSectionChild> subsections;
  final double elevation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SettingsSectionDefaults.radius),
      ),
      margin: EdgeInsets.zero,
      color: color,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SettingsSectionDefaults.radius),
        child: Column(
          children: subsections.insertSeparator(const SectionDivider()).toList(),
        ),
      ),
    );
  }
}

class SettingsSectionSubRow extends StatelessWidget implements SettingsSectionChild {
  const SettingsSectionSubRow({
    super.key,
    required this.subsections,
  });

  final Iterable<SettingsSectionChild> subsections;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subsections
            .map(
              (e) => Flexible(
                child: e,
              ),
            )
            .insertSeparator(SizedBox(width: SettingsSectionDefaults.margin))
            .toList(),
      ),
    );
  }
}

extension _WidgetListExtension on Iterable<Flexible> {
  Iterable<Widget> insertSeparator(Widget separator) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    yield iterator.current;
    while (iterator.moveNext()) {
      yield separator;
      yield iterator.current;
    }
  }
}

class SectionDivider extends StatelessWidget implements SettingsSectionChild {
  const SectionDivider({super.key}) : _margin = const EdgeInsets.only(left: 65);

  const SectionDivider.symmetric({super.key}) : _margin = const EdgeInsets.symmetric(horizontal: 10);

  final EdgeInsetsGeometry _margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin,
      width: double.infinity,
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}

class SettingsListTile extends StatelessWidget implements SettingsSectionChild {
  const SettingsListTile({
    super.key,
    this.dense = false,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.leadingSize = 35,
    this.leadingIcon,
    this.leadingWidget,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.subtitle,
    this.additionalInfo,
    this.backgroundColor,
    this.primaryColor,
    this.trailing,
    this.trailingIcon,
    this.onTap,
    this.isDestructive = false,
  })  : _isSwitch = false,
        _isCheckbox = false,
        value = false,
        onChanged = null;

  const SettingsListTile.switchAdaptive({
    super.key,
    this.dense = false,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.leadingSize = 35,
    this.leadingIcon,
    this.leadingWidget,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.subtitle,
    this.backgroundColor,
    this.primaryColor,
    required this.value,
    this.onChanged,
    this.isDestructive = false,
    this.trailing,
  })  : additionalInfo = null,
        trailingIcon = null,
        _isSwitch = true,
        _isCheckbox = false,
        onTap = null;

  const SettingsListTile.checkboxAdaptive({
    super.key,
    this.dense = false,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.leadingSize = 35,
    this.leadingIcon,
    this.leadingWidget,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.subtitle,
    this.backgroundColor,
    this.primaryColor,
    required this.value,
    this.onChanged,
    this.isDestructive = false,
    this.trailing,
  })  : additionalInfo = null,
        trailingIcon = null,
        _isSwitch = false,
        _isCheckbox = true,
        onTap = null;

  final bool dense;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final double leadingSize;
  final IconData? leadingIcon;
  final Widget? leadingWidget;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final String? subtitle;
  final String? additionalInfo;
  final Widget? trailing;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final Color? primaryColor;
  final bool value;
  final void Function(bool?)? onChanged;
  final void Function()? onTap;
  final bool isDestructive;

  final bool _isSwitch;
  final bool _isCheckbox;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Wrapped in Material widget is needed to be correctly clipped
      child: AdaptiveListTile(
        dense: dense,
        leadingSize: leadingSize,
        leading: leadingWidget ?? (leadingIcon == null ? null : _buildLeadingIcon(context)),
        contentPadding: contentPadding,
        tileColor: backgroundColor,
        title: titleWidget ??
            (title == null
                ? const SizedBox.shrink()
                : Text(
                    title!.capitalizeTitleCupertino,
                    style: _titleStyle(context),
                  )),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!.capitalizeTitleCupertino,
                style: TextStyle(color: _secondaryTextColor(context)),
              ),
        additionalInfo: additionalInfo == null
            ? null
            : Text(
                additionalInfo!,
                style: TextStyle(color: _secondaryTextColor(context)),
              ),
        trailing: _buildTrailing(context),
        onTap: enabled ? _onTap : null,
      ),
    );
  }

  void Function()? get _onTap {
    if (onTap == null && onChanged == null) return null;
    return () {
      _emitVibration();
      onTap?.call();
      onChanged?.call(!value);
    };
  }

  void _emitVibration({bool android = true, bool ios = true}) {
    switch (designPlatform) {
      case CitecPlatform.ios:
        if (ios) HapticFeedback.mediumImpact();
      case CitecPlatform.material:
        if (android) HapticFeedback.mediumImpact();
      case CitecPlatform.yaru:
      case CitecPlatform.macos:
      case CitecPlatform.fluent:
        break;
    }
  }

  TextStyle _titleStyle(BuildContext context) {
    if (titleStyle == null) return TextStyle(color: _titleColor(context));
    return titleStyle!.copyWith(color: _titleColor(context));
  }

  Color _titleColor(BuildContext context) {
    if (!enabled) return _textColor(context, isDestructive).withOpacity(.5);
    return _textColor(context, isDestructive);
  }

  Color _textColor(BuildContext context, bool isDestructive) {
    if (isDestructive) return Theme.of(context).colorScheme.error;
    return primaryColor ?? Theme.of(context).primaryColor;
  }

  Color _secondaryTextColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light)
      return _titleColor(context).withOpacity(.6).makeDarker(0.06);
    else
      return _titleColor(context).withOpacity(.6).makeLighter(0.25);
  }

  Widget _buildLeadingIcon(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: _iconBackgroundColor(context),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          leadingIcon,
          color: backgroundColor ?? Theme.of(context).cardColor,
        ),
      ),
    );
  }

  Color _iconBackgroundColor(BuildContext context) {
    if (!enabled) return _primaryColor(context).withOpacity(.5);
    return _primaryColor(context);
  }

  Color _iconColor(BuildContext context) {
    if (!enabled) return _textColor(context, isDestructive).withOpacity(.5);
    return _textColor(context, isDestructive);
  }

  Color _primaryColor(BuildContext context) {
    if (isDestructive) return Theme.of(context).colorScheme.error;
    return primaryColor ?? Theme.of(context).colorScheme.primary;
  }

  Widget? _buildTrailing(BuildContext context) {
    if (trailing != null) return trailing!;
    if (_isSwitch)
      return AdaptiveSwitch(
        value: value,
        isDestructive: isDestructive,
        onChanged: enabled ? onChanged : null,
      );
    if (_isCheckbox)
      return AdaptiveCheckbox(
        value: value,
        onChanged: onChanged,
        enabled: enabled,
        activeColor: _primaryColor(context),
        inactiveColor: _primaryColor(context),
        deactivatedColor: Theme.of(context).disabledColor,
        tickColor: Theme.of(context).scaffoldBackgroundColor,
        splashRadius: 16,
      );
    if (trailingIcon == null) return null;
    return Icon(
      trailingIcon,
      color: _iconColor(context),
    );
  }
}

enum _SettingsTileType { tile, switchTile, checkboxTile }

class SettingsTile extends StatefulWidget implements SettingsSectionChild {
  const SettingsTile({
    super.key,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.child,
    this.label,
    this.elevation = 0,
    this.backgroundColor,
    this.primaryColor,
    this.onTap,
    this.isDestructive = false,
  })  : assert(child != null),
        _type = _SettingsTileType.tile,
        value = false,
        onChanged = null;

  const SettingsTile.switchAdaptive({
    super.key,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.label,
    this.elevation = 0,
    this.backgroundColor,
    this.primaryColor,
    required this.value,
    this.onChanged,
    this.isDestructive = false,
  })  : _type = _SettingsTileType.switchTile,
        onTap = null,
        child = null;

  const SettingsTile.checkboxAdaptive({
    super.key,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.label,
    this.elevation = 0,
    this.backgroundColor,
    this.primaryColor,
    required this.value,
    this.onChanged,
    this.isDestructive = false,
  })  : _type = _SettingsTileType.checkboxTile,
        onTap = null,
        child = null;

  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final String? label;
  final double elevation;
  final Color? backgroundColor;
  final Color? primaryColor;
  final Widget? child;
  final bool value;
  final void Function(bool?)? onChanged;
  final void Function()? onTap;
  final bool isDestructive;

  final _SettingsTileType _type;

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  bool _hovered = false;

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_hovered) {
      setState(() {
        _hovered = true;
      });
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (_hovered) {
      setState(() {
        _hovered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _enabled ? _handleMouseEnter : null,
      onExit: _enabled ? _handleMouseExit : null,
      child: GestureDetector(
        onTap: widget.enabled ? _onTap : null,
        child: Card(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SettingsSectionDefaults.radius),
          ),
          margin: EdgeInsets.zero,
          color: _backgroundColor(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SettingsSectionDefaults.radius),
            child: Container(
              constraints: BoxConstraints(minHeight: 45),
              child: Center(
                child: _labelWrapper(
                  context,
                  child: switch (widget._type) {
                    _SettingsTileType.tile => widget.child!,
                    _SettingsTileType.switchTile => AdaptiveSwitch(
                        value: widget.value,
                        isDestructive: widget.isDestructive,
                        onChanged: widget.enabled ? widget.onChanged : null,
                      ),
                    _SettingsTileType.checkboxTile => AdaptiveCheckbox(
                        value: widget.value,
                        onChanged: widget.onChanged,
                        enabled: widget.enabled,
                        activeColor: _primaryColor(context),
                        inactiveColor: _primaryColor(context),
                        deactivatedColor: Theme.of(context).disabledColor,
                        tickColor: Theme.of(context).scaffoldBackgroundColor,
                        splashRadius: 16,
                      ),
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _enabled {
    if (!widget.enabled) return false;
    if (widget.onTap == null && widget.onChanged == null) return false;
    return true;
  }

  Widget _labelWrapper(
    BuildContext context, {
    required Widget child,
  }) {
    if (widget.label == null) return child;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        child,
        Text(
          widget.label!.capitalizeTitleCupertino,
          style: TextStyle(
            color: _primaryColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void Function()? get _onTap {
    if (widget.onTap == null && widget.onChanged == null) return null;
    return () {
      _emitVibration();
      widget.onTap?.call();
      widget.onChanged?.call(!widget.value);
    };
  }

  void _emitVibration({bool android = true, bool ios = true}) {
    switch (designPlatform) {
      case CitecPlatform.ios:
        if (ios) HapticFeedback.mediumImpact();
      case CitecPlatform.material:
        if (android) HapticFeedback.mediumImpact();
      case CitecPlatform.yaru:
      case CitecPlatform.macos:
      case CitecPlatform.fluent:
        break;
    }
  }

  Color? _backgroundColor(BuildContext context) {
    if (!_enabled) return (widget.backgroundColor ?? Theme.of(context).cardColor).withOpacity(.5);
    return widget.backgroundColor;
  }

  Color _primaryColor(BuildContext context) {
    if (widget.isDestructive) return Theme.of(context).colorScheme.error;
    return widget.primaryColor ?? Theme.of(context).primaryColor;
  }
}

class SettingsListTileDropDown<T> extends StatelessWidget implements SettingsSectionChild {
  SettingsListTileDropDown({
    super.key,
    this.dense = false,
    required this.value,
    this.toText,
    this.onChanged,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.leadingSize = 35,
    this.leadingIcon,
    this.leadingWidget,
    this.title,
    this.titleWidget,
    this.subtitle,
    required this.elements,
    this.backgroundColor,
    this.primaryColor,
    this.isDestructive = false,
  });

  final bool dense;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final double leadingSize;
  final IconData? leadingIcon;
  final Widget? leadingWidget;
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Color? backgroundColor;
  final Color? primaryColor;
  final T value;
  final String Function(T)? toText;
  final void Function(T?)? onChanged;
  final bool isDestructive;
  final Map<T, MyDDElement> elements;

  final GlobalKey<AdaptiveDropDownState<T>> _materialDropDownKey = GlobalKey();
  final GlobalKey<AdaptivePullDownButtonState> _cupertinoPullDownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Wrapped in Material widget is needed to be correctly clipped
      child: AdaptiveListTile(
        leadingSize: leadingSize,
        leading: leadingWidget ?? (leadingIcon == null ? null : _buildLeadingIcon(context)),
        contentPadding: contentPadding,
        tileColor: backgroundColor,
        title: titleWidget ??
            (title == null
                ? const SizedBox.shrink()
                : Text(
                    title!.capitalizeTitleCupertino,
                    style: TextStyle(
                      color: enabled
                          ? isDestructive
                              ? Theme.of(context).colorScheme.error
                              : primaryColor ?? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                    ),
                  )),
        subtitle: subtitle == null ? null : Text(subtitle!),
        additionalInfo: _additionalInfo,
        onTap: switch (designPlatform) {
          CitecPlatform.material => _materialDropDownKey.currentState?.openMenu,
          CitecPlatform.ios => _cupertinoPullDownKey.currentState?.showCupertinoMenu,
          _ => throw UnimplementedError(),
        },
        trailing: _buildTrailing(context),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: isDestructive ? Theme.of(context).colorScheme.error : primaryColor ?? Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          leadingIcon,
          color: backgroundColor ?? Theme.of(context).canvasColor,
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return switch (designPlatform) {
      CitecPlatform.material => AdaptiveDropDown<T>(
          key: _materialDropDownKey,
          value: value,
          contentPadding: EdgeInsets.zero,
          color: const Color(0x00000000),
          dropDownElements: elements,
          onChanged: onChanged,
        ),
      CitecPlatform.ios => AdaptivePullDownButton(
          key: _cupertinoPullDownKey,
          padding: EdgeInsets.zero,
          itemBuilder: (context) => elements.keys
              .map(
                (key) => AdaptivePullDownItem(
                  title: elements[key]!.name(context),
                  icon: elements[key]!.icon?.icon,
                  iconColor: elements[key]!.icon?.color,
                  onTap: () => onChanged?.call(key),
                ),
              )
              .toList(),
        ),
      _ => throw UnimplementedError(),
    };
  }

  Widget? get _additionalInfo {
    switch (designPlatform) {
      case CitecPlatform.material:
        return null;
      case CitecPlatform.ios:
        if (elements[value]?.icon != null)
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(toText?.call(value) ?? value.toString()),
              const SizedBox(width: 8),
              elements[value]!.icon!,
            ],
          );
        return Text(toText?.call(value) ?? value.toString());
      case CitecPlatform.macos:
      case CitecPlatform.fluent:
      case CitecPlatform.yaru:
        throw UnimplementedError();
    }
  }
}

class SettingsTileDropDown<T> extends StatefulWidget implements SettingsSectionChild {
  const SettingsTileDropDown({
    super.key,
    this.label,
    this.elevation = 0,
    this.backgroundColor,
    this.primaryColor,
    this.onChanged,
    required this.elements,
    this.isDestructive = false,
  });

  final String? label;
  final double elevation;
  final Color? backgroundColor;
  final Color? primaryColor;
  final void Function(T?)? onChanged;
  final Map<T, MyDDElement> elements;
  final bool isDestructive;

  @override
  State<SettingsTileDropDown<T>> createState() => _SettingsTileDropDownState<T>();
}

class _SettingsTileDropDownState<T> extends State<SettingsTileDropDown<T>> {
  final GlobalKey<AdaptivePullDownButtonState> _pullDownKey = GlobalKey();
  bool _hovered = false;

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_hovered) {
      setState(() {
        _hovered = true;
      });
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (_hovered) {
      setState(() {
        _hovered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _enabled ? _handleMouseEnter : null,
      onExit: _enabled ? _handleMouseExit : null,
      child: GestureDetector(
        onTap: switch (designPlatform) {
          CitecPlatform.material => null,
          CitecPlatform.ios => _pullDownKey.currentState?.showCupertinoMenu,
          _ => throw UnimplementedError(),
        },
        child: Card(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SettingsSectionDefaults.radius),
          ),
          margin: EdgeInsets.zero,
          color: _backgroundColor(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SettingsSectionDefaults.radius),
            child: Container(
              constraints: BoxConstraints(minHeight: 45),
              child: Center(
                child: _buildDropDown(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _enabled => widget.onChanged != null;

  Widget _buildDropDown(BuildContext context) {
    return AdaptivePullDownButton(
      key: _pullDownKey,
      padding: EdgeInsets.zero,
      iconColor: _primaryColor(context),
      itemBuilder: (context) => widget.elements.keys
          .map(
            (key) => AdaptivePullDownItem(
              title: widget.elements[key]!.name(context),
              icon: widget.elements[key]!.icon?.icon,
              iconColor: widget.elements[key]!.icon?.color,
              onTap: () => widget.onChanged?.call(key),
            ),
          )
          .toList(),
      child: widget.label == null
          ? null
          : Text(
              widget.label!.capitalizeTitleCupertino,
              style: TextStyle(
                color: _primaryColor(context),
              ),
            ),
    );
  }

  Color? _backgroundColor(BuildContext context) {
    if (!_enabled) return (widget.backgroundColor ?? Theme.of(context).cardColor).withOpacity(.5);
    return widget.backgroundColor;
  }

  Color _primaryColor(BuildContext context) {
    if (widget.isDestructive) return Theme.of(context).colorScheme.error;
    return widget.primaryColor ?? Theme.of(context).primaryColor;
  }
}

class SettingsFooter extends StatelessWidget implements SettingsSectionChild {
  const SettingsFooter({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SettingsSectionDefaults.margin),
      child: Text(
        text,
        style: SettingsSectionDefaults.explanationTextStyle,
      ),
    );
  }
}
