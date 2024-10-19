import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:datatype_extensions/color_extensions.dart';

const double _kLeadingSize = 28;
const double _kMinLeadingWidth = 24;
const double _kLeadingImageSize = 38;
const EdgeInsetsGeometry _kContentPaddingMaterial = EdgeInsets.symmetric(horizontal: 16);
const EdgeInsetsGeometry _kContentPaddingCupertino = EdgeInsets.symmetric(horizontal: 16, vertical: 13);

class AdaptiveListTile extends StatelessWidget {
  const AdaptiveListTile({
    super.key,
    this.leading,
    this.leadingSize = _kLeadingSize,
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.trailing,
    this.dense = false,
    this.contentPadding,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.splashColor,
  })  : leadingIcon = null,
        leadingImage = null,
        leadingAvatar = null;

  const AdaptiveListTile.icon({
    super.key,
    this.leadingIcon,
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.trailing,
    this.dense = false,
    this.contentPadding,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.splashColor,
  })  : leading = null,
        leadingImage = null,
        leadingAvatar = null,
        leadingSize = null;

  const AdaptiveListTile.image({
    super.key,
    this.leadingImage,
    this.leadingSize = _kLeadingImageSize,
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.trailing,
    this.dense = false,
    this.contentPadding,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.splashColor,
  })  : leading = null,
        leadingIcon = null,
        leadingAvatar = null;

  const AdaptiveListTile.avatar({
    super.key,
    this.leadingAvatar,
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.trailing,
    this.dense = false,
    this.contentPadding,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.splashColor,
  })  : leading = null,
        leadingIcon = null,
        leadingImage = null,
        leadingSize = null;

  final Widget? leading;

  /// An icon to display at the start of the [AdaptiveListTile], before the [title].
  final Icon? leadingIcon;

  /// An image to display at the start of the [AdaptiveListTile], before the [title].
  final Uint8List? leadingImage;

  /// A circle avatar to display at the start of the [AdaptiveListTile], before the [title].
  final CircleAvatar? leadingAvatar;

  /// The [leadingSize] is used to constrain the width and height of [leading] widget.
  final double? leadingSize;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use [Text.maxLines].
  final Widget title;

  /// Additional content displayed below the [title].
  final Widget? subtitle;

  /// An [additionalInfo] is used to display additional information. It is displayed on the right, before [trailing].
  ///
  /// Typically a [Text] widget.
  final Widget? additionalInfo;

  /// A widget to display at the end of the [AdaptiveListTile], after the [title].
  ///
  /// Typically an [Icon] widget (e. g. [CupertinoListTileChevron]).
  final Widget? trailing;

  /// Only for Material
  final bool dense;

  /// The [AdaptiveListTile]'s internal padding.
  ///
  /// Insets [leading], [title], [subtitle], and [trailing] widgets.
  ///
  /// Defaults to `const EdgeInsets.symmetric(horizontal: 16)` on Material.
  ///
  /// Defaults to `const EdgeInsets.symmetric(horizontal: 16, vertical: 13)` on Cupertino.
  final EdgeInsetsGeometry? contentPadding;

  /// Called when the user taps this list tile.
  ///
  /// If this is a Future<void> Function(), then the [CupertinoListTile] remains activated until the returned future is awaited.
  final void Function()? onTap;

  /// Called when the user long-presses on this list tile.
  final void Function()? onLongPress;

  /// Defines the background color of ListTile.
  ///
  /// The [tileColor] of the tile in normal state.
  final Color? tileColor;

  /// The color of splash for the tile's [Material].
  ///
  /// Only Material
  final Color? splashColor;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null || onLongPress != null;
    return switch (designPlatform) {
      CitecPlatform.material => _MaterialListTile(
          key: key,
          leading: _leading,
          title: title,
          subtitle: subtitle,
          trailing: _trailing,
          dense: dense,
          contentPadding: contentPadding ?? _kContentPaddingMaterial,
          enabled: enabled,
          onTap: onTap,
          onLongPress: onLongPress,
          tileColor: tileColor,
          splashColor: splashColor,
        ),
      CitecPlatform.ios => GestureDetector(
          onLongPress: enabled ? onLongPress : null,
          child: _CupertinoListTile(
            key: key,
            title: title,
            subtitle: subtitle,
            additionalInfo: additionalInfo,
            leading: _leading,
            trailing: trailing,
            enabled: enabled,
            onTap: enabled ? onTap : null,
            tileColor: tileColor,
            contentPadding: contentPadding ?? _kContentPaddingCupertino,
            leadingSize: _leadingSize,
          ),
        ),
      CitecPlatform.fluent => GestureDetector(
          onLongPress: enabled ? onLongPress : null,
          child: fluent.ListTile(
            key: key,
            title: title,
            subtitle: subtitle,
            leading: _leading,
            trailing: _trailing,
            onPressed: enabled ? onTap : null,
            tileColor: tileColor != null ? fluent.WidgetStateProperty.all(tileColor!) : null,
            contentPadding: contentPadding ?? _kContentPaddingCupertino,
          ),
        ),
      _ => throw UnimplementedError(),
    };
  }

  double get _leadingSize {
    if (leadingSize != null) return leadingSize!;
    if (leadingImage != null) return leadingSize ?? _kLeadingImageSize;
    if (leadingIcon != null) return leadingIcon!.size ?? _kLeadingSize;
    if (leadingAvatar != null) return leadingAvatar!.radius != null ? leadingAvatar!.radius! * 2 : _kLeadingSize;
    return _kLeadingSize;
  }

  Widget? get _leading {
    if (leading != null) return leading;
    if (leadingIcon != null) return leadingIcon;
    if (leadingImage != null)
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.memory(
            leadingImage!,
            width: leadingSize ?? _kLeadingImageSize,
            height: leadingSize ?? _kLeadingImageSize,
            fit: BoxFit.cover,
          ),
        ),
      );
    if (leadingAvatar != null) return leadingAvatar;
    return null;
  }

  Widget? get _trailing {
    if (additionalInfo == null && trailing == null) return null;
    if (additionalInfo != null && trailing != null)
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          additionalInfo!,
          trailing!,
        ],
      );
    if (additionalInfo != null) return additionalInfo;
    if (trailing != null) return trailing;
    return null;
  }
}

class _MaterialListTile extends StatelessWidget {
  const _MaterialListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.dense = false,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.splashColor,
  });

  final Widget? leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use [Text.maxLines].
  final Widget title;

  /// Additional content displayed below the [title].
  final Widget? subtitle;

  /// A widget to display at the end of the [_MaterialListTile], after the [title].
  ///
  /// Typically an [Icon].
  final Widget? trailing;

  final bool dense;

  /// The [_MaterialListTile]'s internal padding.
  ///
  /// Insets [leading], [title], [subtitle], and [trailing] widgets.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the current [Theme] and the [onTap] and [onLongPress] callbacks are inoperative.
  final bool enabled;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final void Function()? onTap;

  /// Called when the user long-presses on this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final void Function()? onLongPress;

  /// Defines the background color of ListTile.
  ///
  /// The [tileColor] of the tile in normal state.
  final Color? tileColor;

  /// The color of splash for the tile's [Material].
  final Color? splashColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: _subtitle,
      trailing: trailing,
      isThreeLine: _isThreeLine,
      dense: dense,
      visualDensity: dense ? VisualDensity.compact : null,
      titleTextStyle: _titleTextStyle(context),
      subtitleTextStyle: _subtitleTextStyle(context),
      titleAlignment: ListTileTitleAlignment.center,
      contentPadding: contentPadding ?? _kContentPaddingMaterial,
      enabled: enabled,
      selected: false,
      onTap: onTap,
      onLongPress: onLongPress,
      tileColor: tileColor,
      splashColor: splashColor,
      minLeadingWidth: _kMinLeadingWidth,
    );
  }

  TextStyle? _titleTextStyle(BuildContext context) {
    if (title is! Text) return null;
    final TextStyle? defaultTextStyle = Theme.of(context).listTileTheme.titleTextStyle ?? Theme.of(context).textTheme.bodyLarge;
    final TextStyle? userTextStyle = (title as Text).style?.copyWith(inherit: true);
    return defaultTextStyle?.merge(userTextStyle) ?? userTextStyle;
  }

  TextStyle? _subtitleTextStyle(BuildContext context) {
    if (subtitle == null) return null;
    final TextStyle? defaultTextStyle = Theme.of(context).listTileTheme.subtitleTextStyle ?? Theme.of(context).textTheme.bodyMedium;
    if (subtitle is! Text) return defaultTextStyle;
    final TextStyle? userTextStyle = (subtitle! as Text).style;
    return defaultTextStyle?.merge(userTextStyle) ?? userTextStyle;
  }

  Widget? get _subtitle {
    if (subtitle == null) return null;
    if (subtitle is Text) return subtitle! as Text;
    return subtitle;
  }

  bool get _isThreeLine {
    if (subtitle == null) return false;
    if (subtitle is Text) return (subtitle! as Text).data!.split('\n').length > 1;
    return false;
  }
}

class _CupertinoListTile extends StatefulWidget {
  const _CupertinoListTile({
    super.key,
    this.leading,
    this.leadingSize = _kLeadingSize,
    required this.title,
    this.subtitle,
    this.additionalInfo,
    this.trailing,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.tileColor,
  });

  final Widget? leading;

  /// The [leadingSize] is used to constrain the width and height of [leading] widget.
  final double leadingSize;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the [title].
  final Widget? subtitle;

  /// An [additionalInfo] is used to display additional information. It is displayed on the right, before [trailing].
  ///
  /// Typically a [Text] widget.
  final Widget? additionalInfo;

  /// A widget to display at the end of the [_CupertinoListTile], after the [title].
  ///
  /// Typically an [Icon] widget (e. g. [CupertinoListTileChevron]).
  final Widget? trailing;

  /// The [_CupertinoListTile]'s internal padding.
  ///
  /// Insets [leading], [title], [subtitle], and [trailing] widgets.
  ///
  /// Defaults to `const EdgeInsets.symmetric(horizontal: 16, vertical: 13)`.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the current [Theme] and the [onTap] callback is inoperative.
  final bool enabled;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  ///
  /// If this is a Future<void> Function(), then the [_CupertinoListTile] remains activated until the returned future is awaited.
  final void Function()? onTap;

  /// Defines the background color of ListTile.
  ///
  /// The [tileColor] of the tile in normal state.
  final Color? tileColor;

  @override
  State<_CupertinoListTile> createState() => _CupertinoListTileState();
}

class _CupertinoListTileState extends State<_CupertinoListTile> {
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
    final enabled = widget.enabled;
    return MouseRegion(
      onEnter: enabled ? _handleMouseEnter : null,
      onExit: enabled ? _handleMouseExit : null,
      child: CupertinoListTile(
        title: widget.title, // maxLines: 1, overflow: TextOverflow.ellipsis,
        subtitle: _subtitle, // maxLines: 1, overflow: TextOverflow.ellipsis, see Apple Design Guidelines
        additionalInfo: widget.additionalInfo,
        leading: widget.leading,
        trailing: widget.trailing,
        onTap: widget.enabled ? widget.onTap : null,
        backgroundColor: _hovered ? widget.tileColor + CupertinoColors.secondarySystemFill.resolveFrom(context) : widget.tileColor,
        padding: widget.contentPadding ?? _kContentPaddingCupertino,
        leadingSize: widget.leadingSize,
      ),
    );
  }

  Widget? get _subtitle {
    if (widget.subtitle == null) return null;
    if (widget.subtitle is Text) {
      final List<String> rows = (widget.subtitle! as Text).data!.split('\n');
      if (rows.length == 1) return widget.subtitle!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.map(Text.new).toList(),
      );
    }
    return widget.subtitle;
  }
}
