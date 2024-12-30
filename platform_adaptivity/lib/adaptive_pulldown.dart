import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:platform_adaptivity/adaptive_icons.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

ThemeExtension adaptivePullDownTheme(Color iconDestructiveColor) => PullDownButtonTheme(
      itemTheme: PullDownMenuItemTheme(
        destructiveColor: iconDestructiveColor,
      ),
    );

class AdaptivePullDownButton extends StatefulWidget {
  /// Creates a button that shows a popup menu on Material
  /// and a pull-down menu on Cupertino.
  const AdaptivePullDownButton({
    super.key,
    this.onOpen,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(8),
    this.iconColor,
    this.child,
  });

  /// This function is executed directly before opening the menu.
  final void Function()? onOpen;
  final List<AdaptivePullDownEntry> Function(BuildContext) itemBuilder;
  final EdgeInsetsGeometry padding;

  /// Used for <br> <i class="material-icons-round md-36">menu</i> &#x2014; or <i class='cupertino-icons md-36'>ellipsis_circle</i> &#x2014; <br> Only if [child] is omitted.
  final Color? iconColor;

  /// If omitted, defaults to <br> <i class="material-icons-round md-36">menu</i> &#x2014; material icon named "menu" (round). <br> <i class='cupertino-icons md-36'>ellipsis_circle</i> &#x2014; Cupertino icon named "ellipsis_circle".
  final Widget? child;

  @override
  State<AdaptivePullDownButton> createState() => AdaptivePullDownButtonState();
}

class AdaptivePullDownButtonState extends State<AdaptivePullDownButton> {
  static Color _surfaceTintColor(BuildContext context) => Theme.of(context).colorScheme.primary.withValues(alpha: .1);
  static final ShapeBorder _shape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)); // RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // Material 3
  static Color _shadowColor(BuildContext context) => HSLColor.fromColor(Theme.of(context).colorScheme.primary).withLightness(.15).toColor();

  Future<void> Function() _showMenu = Future.value;

  Future<void> showCupertinoMenu() => _showMenu();

  bool _isHovered = false;

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_isHovered)
      setState(() {
        _isHovered = true;
      });
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (_isHovered)
      setState(() {
        _isHovered = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return switch (designPlatform) {
      CitecPlatform.material => PopupMenuButton<String>(
          surfaceTintColor: _surfaceTintColor(context),
          onOpened: widget.onOpen,
          padding: EdgeInsets.zero,
          position: PopupMenuPosition.under,
          shape: _shape,
          splashRadius: 9,
          shadowColor: _shadowColor(context),
          onSelected: (String value) => _onSelect(context, value, widget.itemBuilder(context)),
          itemBuilder: (context) => _convertAdaptiveToMaterial(
            context,
            adaptiveItems: widget.itemBuilder(context),
          ),
          child: Padding(
            padding: widget.padding,
            child: widget.child ??
                Icon(
                  AdaptiveIcons.menu_rounded,
                  color: widget.iconColor ?? Theme.of(context).primaryColor,
                ),
          ),
        ),
      CitecPlatform.ios => PullDownButton(
          itemBuilder: (context) {
            final List<PullDownMenuEntry> items = [];
            for (final AdaptivePullDownEntry item in widget.itemBuilder(context)) {
              if (item.isDivider == true)
                items.add(const PullDownMenuDivider.large());
              else if (item.isGroup) {
                items.addAll(
                  [
                    PullDownMenuTitle(
                      title: Text(item.title),
                      alignment: PullDownMenuTitleAlignment.center,
                    ),
                    PullDownMenuActionsRow.medium(
                      items: List.generate(
                        (item as AdaptivePullDownGroup).items.length,
                        (index) => _convertAdaptiveToCupertino(context, item.items[index]),
                      ),
                    ),
                  ],
                );
              } else
                items.add(_convertAdaptiveToCupertino(context, item));
            }
            return items;
          },
          buttonBuilder: (context, showMenu) {
            _showMenu = showMenu;
            return MouseRegion(
              onEnter: _handleMouseEnter,
              onExit: _handleMouseExit,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _isHovered ? CupertinoColors.secondarySystemFill.resolveFrom(context) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.onOpen?.call();
                    showMenu();
                  },
                  child: Padding(
                    padding: widget.padding,
                    child: widget.child ??
                        Icon(
                          AdaptiveIcons.menu_rounded,
                          color: widget.iconColor ?? Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                  ),
                ),
              ),
            );
          },
        ),
      _ => throw UnimplementedError(),
    };
  }

  List<PopupMenuEntry<String>> _convertAdaptiveToMaterial(BuildContext context, {required List<AdaptivePullDownEntry> adaptiveItems}) {
    final List<PopupMenuEntry<String>> items = [];
    for (final AdaptivePullDownEntry item in adaptiveItems) {
      if (item.isDivider == true)
        items.add(
          CustomPopupMenuDivider(color: Theme.of(context).dividerColor),
        );
      else if (item.isSelectable)
        items.add(
          CheckedPopupMenuItem(
            value: (item as AdaptivePullDownItem).title,
            enabled: item.enabled,
            checked: item.selected,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              horizontalTitleGap: 12,
              enabled: item.enabled,
              leading: item.icon != null ? Icon(item.icon, color: item.iconColor ?? _getMaterialTextColor(context, item.enabled, item.isDestructive)) : null,
              title: Text(
                item.title,
                style: TextStyle(color: _getMaterialTextColor(context, item.enabled, item.isDestructive)),
              ),
              subtitle: item.subtitle != null
                  ? Text(
                      item.subtitle!,
                      style: TextStyle(color: _getMaterialTextColor(context, item.enabled, item.isDestructive)),
                    )
                  : null,
            ),
          ),
        );
      else if (item.isGroup)
        items.add(
          PopupMenuItem<String>(
            value: (item as AdaptivePullDownGroup).title,
            enabled: item.enabled,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              horizontalTitleGap: 12,
              enabled: item.enabled,
              leading: item.icon != null ? Icon(item.icon, color: item.iconColor ?? _getMaterialTextColor(context, item.enabled, false)) : null,
              title: Text(
                item.title,
                style: TextStyle(color: _getMaterialTextColor(context, item.enabled, false)),
              ),
              subtitle: item.subtitle != null
                  ? Text(
                      item.subtitle!,
                      style: TextStyle(color: _getMaterialTextColor(context, item.enabled, false)),
                    )
                  : null,
              trailing: Icon(Icons.arrow_right_rounded, color: item.iconColor ?? _getMaterialTextColor(context, item.enabled, false)),
            ),
          ),
        );
      else
        items.add(
          PopupMenuItem<String>(
            value: (item as AdaptivePullDownItem).title,
            enabled: item.enabled,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              horizontalTitleGap: 12,
              enabled: item.enabled,
              leading: item.icon != null ? Icon(item.icon, color: item.iconColor ?? _getMaterialTextColor(context, item.enabled, item.isDestructive)) : null,
              title: Text(
                item.title,
                style: TextStyle(color: _getMaterialTextColor(context, item.enabled, item.isDestructive)),
              ),
              subtitle: item.subtitle != null
                  ? Text(
                      item.subtitle!,
                      style: TextStyle(color: _getMaterialTextColor(context, item.enabled, item.isDestructive)),
                    )
                  : null,
            ),
          ),
        );
    }
    return items;
  }

  Color _getMaterialTextColor(BuildContext context, bool isEnabled, bool isDestructive) {
    return isDestructive
        ? isEnabled
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.error.withValues(alpha: .3)
        : isEnabled
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor.withValues(alpha: .3);
  }

  void _onSelect(BuildContext context, String value, List<AdaptivePullDownEntry> items) {
    for (final AdaptivePullDownEntry item in items) {
      if (item.title == value) {
        if (item.isGroup)
          showButtonMenu(
            context,
            items: (item as AdaptivePullDownGroup).items,
          );
        else
          (item as AdaptivePullDownItem).onTap?.call();
      }
    }
  }

  void showButtonMenu(BuildContext context, {required List<AdaptivePullDownItem> items, void Function()? onCanceled}) {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final Offset offset = Offset(0.0, button.size.height);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showMenu<String?>(
        surfaceTintColor: _surfaceTintColor(context),
        shape: _shape,
        shadowColor: _shadowColor(context),
        context: context,
        items: _convertAdaptiveToMaterial(
          context,
          adaptiveItems: items,
        ),
        position: position,
      ).then<void>((String? newValue) {
        if (newValue == null) {
          onCanceled?.call();
          return null;
        }
        if (context.mounted) _onSelect(context, newValue, items);
      });
    }
  }

  PullDownMenuItem _convertAdaptiveToCupertino(BuildContext context, AdaptivePullDownEntry item) {
    if (item.isSelectable)
      return PullDownMenuItem.selectable(
        enabled: (item as AdaptivePullDownItem).enabled,
        tapHandler: (context, onTap) {
          if (item.closeAfter)
            Navigator.pop(context, onTap);
          else
            onTap?.call();
        },
        onTap: item.onTap,
        title: item.title,
        subtitle: item.subtitle,
        selected: item.selected,
        icon: item.icon,
        iconColor: item.iconColor,
        isDestructive: item.isDestructive,
      );
    else
      return PullDownMenuItem(
        enabled: (item as AdaptivePullDownItem).enabled,
        tapHandler: (context, onTap) {
          if (item.closeAfter)
            Navigator.pop(context, onTap);
          else
            onTap?.call();
        },
        title: item.title,
        subtitle: item.subtitle,
        icon: item.icon,
        iconColor: item.iconColor,
        isDestructive: item.isDestructive,
        onTap: item.onTap,
      );
  }
}

class CustomPopupMenuDivider extends PopupMenuEntry<Never> {
  const CustomPopupMenuDivider({
    super.key,
    this.thickness = 1,
    this.height = 16,
    this.color,
  });

  final Color? color;
  final double? thickness;

  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  State<CustomPopupMenuDivider> createState() => _CustomPopupMenuDividerState();
}

class _CustomPopupMenuDividerState extends State<CustomPopupMenuDivider> {
  @override
  Widget build(BuildContext context) => Divider(
        thickness: widget.thickness,
        height: widget.height,
        color: widget.color,
      );
}

@immutable
abstract class AdaptivePullDownEntry {
  const AdaptivePullDownEntry({
    required this.enabled,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isDivider,
    required this.isSelectable,
    required this.isGroup,
  });

  /// Whether the user is permitted to tap this item.
  final bool enabled;
  final String title;

  /// Additional content displayed below the title..
  final String? subtitle;

  /// An icon to display before the title on Material and on after on Cupertino.
  final IconData? icon;

  /// The color of [icon].
  final Color? iconColor;
  final bool isSelectable;
  final bool isDivider;
  final bool isGroup;
}

class AdaptivePullDownItem extends AdaptivePullDownEntry {
  /// Creates an item for an [AdaptivePullDownButton].
  const AdaptivePullDownItem({
    super.enabled = true,
    required super.title,
    super.subtitle,
    super.icon,
    super.iconColor,
    this.isDestructive = false,
    this.onTap,
    this.closeAfter = true,
  })  : selected = false,
        super(isDivider: false, isSelectable: false, isGroup: false);

  /// Creates a horizontal divider for a [AdaptivePullDownButton].
  const AdaptivePullDownItem.divider()
      : selected = false,
        isDestructive = false,
        onTap = null,
        closeAfter = true,
        super(
          enabled: true,
          title: 'divider',
          subtitle: null,
          icon: null,
          iconColor: null,
          isDivider: true,
          isSelectable: false,
          isGroup: false,
        );

  /// Creates a selectable item with a checkmark for a [AdaptivePullDownButton].
  const AdaptivePullDownItem.selectable({
    this.selected = false,
    super.enabled = true,
    required super.title,
    super.subtitle,
    super.icon,
    super.iconColor,
    this.isDestructive = false,
    this.onTap,
    this.closeAfter = true,
  }) : super(isDivider: false, isSelectable: true, isGroup: false);

  /// Whether to display a checkmark next to the menu item.
  final bool selected;

  /// If true, the color of [icon], [title], and [subtitle] will be the destructive color.
  final bool isDestructive;

  /// Called when the user taps [AdaptivePullDownItem].
  final void Function()? onTap;

  /// If true, the menu will close after the user taps [AdaptivePullDownItem].
  final bool closeAfter;
}

class AdaptivePullDownGroup extends AdaptivePullDownEntry {
  /// Creates a popup menu or a [PullDownMenuActionsRow.medium] containing [items].
  const AdaptivePullDownGroup({
    super.enabled = true,
    required super.title,
    super.subtitle,
    super.icon,
    super.iconColor,
    this.items = const [],
  }) : super(isDivider: false, isSelectable: false, isGroup: true);

  /// The [items] will be arranged into a popup menu on Material and a [PullDownMenuActionsRow.medium] on Cupertino.
  final List<AdaptivePullDownItem> items;
}
