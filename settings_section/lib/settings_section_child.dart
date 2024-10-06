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

const double kDefaultMargin = 8;
const TextStyle _kExplanationTextStyle = TextStyle(fontSize: 12, color: Colors.grey, height: 1);

abstract class SettingsSectionChild extends Widget {
  const SettingsSectionChild({super.key});
}

class SettingsSectionSubGroup extends StatelessWidget implements SettingsSectionChild {
  const SettingsSectionSubGroup({
    super.key,
    this.elevation = 0,
    this.color,
    required this.subsections,
  });

  static const double kDefaultRadius = 10;

  final Iterable<SettingsSectionChild> subsections;
  final double elevation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      margin: EdgeInsets.zero,
      color: color,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        child: Column(
          children: subsections.insertSeparator(const SectionDivider()).toList(),
        ),
      ),
    );
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        if (ios) HapticFeedback.mediumImpact();
      case TargetPlatform.android:
        if (android) HapticFeedback.mediumImpact();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
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

class SettingsFooter extends StatelessWidget implements SettingsSectionChild {
  const SettingsFooter({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      child: Text(
        text,
        style: _kExplanationTextStyle,
      ),
    );
  }
}
