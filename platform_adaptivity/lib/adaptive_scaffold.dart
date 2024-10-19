import 'dart:ui';

import 'package:datatype_extensions/hslcolor_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_adaptivity/l10n/app_localizations.dart';

import 'package:platform_adaptivity/adaptive_widgets.dart';

const Color _kCupertinoSurfaceColorLight = Color.fromRGBO(255, 255, 255, .6);
const Color _kCupertinoSurfaceColorDark = Color.fromRGBO(20, 20, 20, .5);

CupertinoDynamicColor _kSurfaceColor = const CupertinoDynamicColor.withBrightness(
  color: _kCupertinoSurfaceColorLight,
  darkColor: _kCupertinoSurfaceColorDark,
);

/// Creates a visual scaffold for Material or Cupertino widgets.
///
/// On Material returns a normal [Scaffold] widget, while on Cupertino returns a [CupertinoPageScaffold] with slivers.
///
/// The [children] argument can be either a `Widget` or `List<Widget>`.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold.single({
    super.key,
    this.title,
    this.titleStyle,
    this.avatar,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    required this.previousPageTitle,
    required this.child,
    this.alwaysScrollable = false,
    this.wrapWithCenter = true,
    this.titleWidget,
    this.header,
    this.headerHeight,
    this.headerColor,
    this.footer,
    this.footerHeight,
    this.footerColor,
    this.backgroundColor,
    this.onSearchChanged,
    required this.locale,
    this.controller,
  })  : _isSingle = true,
        children = const [];
  const AdaptiveScaffold.multiple({
    super.key,
    this.title,
    this.titleStyle,
    this.avatar,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    this.previousPageTitle,
    required this.children,
    this.alwaysScrollable = false,
    this.titleWidget,
    this.header,
    this.headerHeight,
    this.headerColor,
    this.footer,
    this.footerHeight,
    this.footerColor,
    this.backgroundColor,
    this.onSearchChanged,
    required this.locale,
    this.controller,
  })  : _isSingle = false,
        child = const SizedBox(),
        wrapWithCenter = false;

  /// Only applied on iOS
  final String? previousPageTitle;
  final Widget? leading;
  final String? title;
  final TextStyle? titleStyle;
  final ({ImageProvider image, VoidCallback? onPressed})? avatar;
  final List<Widget> appBarActions;
  final bool automaticallyImplyLeading;
  final bool wrapWithCenter;

  /// If [titleWidget] is not `null`, [title] is overridden.
  final Widget? titleWidget;
  final bool _isSingle;
  final Widget child;
  final List<Widget> children;
  final bool alwaysScrollable;
  final Widget? header;
  final double? headerHeight;
  final Color? headerColor;
  final Widget? footer;
  final double? footerHeight;
  final Color? footerColor;
  final Color? backgroundColor;
  final void Function(String?)? onSearchChanged;
  final ScrollController? controller;

  final String locale;

  @override
  Widget build(BuildContext context) {
    switch (designPlatform) {
      case CitecPlatform.material:
        if (_isSingle)
          return MaterialScaffold.single(
            key: key,
            title: title,
            titleStyle: titleStyle,
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            wrapWithCenter: wrapWithCenter,
            titleWidget: titleWidget,
            header: header,
            footer: footer,
            onSearchChanged: onSearchChanged,
            backgroundColor: backgroundColor,
            controller: controller,
            child: child,
          );
        else
          return MaterialScaffold.multiple(
            key: key,
            title: title,
            titleStyle: titleStyle,
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            titleWidget: titleWidget,
            header: header,
            footer: footer,
            onSearchChanged: onSearchChanged,
            backgroundColor: backgroundColor,
            controller: controller,
            children: children,
          );

      case CitecPlatform.ios:
        if (_isSingle)
          return BiCupertinoScaffold.single(
            key: key,
            title: title,
            titleStyle: titleStyle,
            avatar: avatar,
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            previousPageTitle: previousPageTitle,
            wrapWithCenter: wrapWithCenter,
            titleWidget: titleWidget,
            header: header,
            headerHeight: headerHeight,
            headerColor: headerColor,
            footer: footer,
            footerHeight: footerHeight,
            footerColor: footerColor,
            backgroundColor: backgroundColor,
            onSearchChanged: onSearchChanged,
            locale: locale,
            controller: controller,
            child: child,
          );
        else
          return BiCupertinoScaffold.multiple(
            key: key,
            title: title,
            titleStyle: titleStyle,
            avatar: avatar,
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            previousPageTitle: previousPageTitle,
            titleWidget: titleWidget,
            header: header,
            headerHeight: headerHeight,
            headerColor: headerColor,
            footer: footer,
            footerHeight: footerHeight,
            footerColor: footerColor,
            backgroundColor: backgroundColor,
            onSearchChanged: onSearchChanged,
            locale: locale,
            controller: controller,
            children: children,
          );
      case CitecPlatform.macos:
      case CitecPlatform.fluent:
      case CitecPlatform.yaru:
        throw UnimplementedError();
    }
  }
}

class MaterialScaffold extends StatelessWidget {
  const MaterialScaffold.single({
    super.key,
    this.title,
    this.titleStyle,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    required this.child,
    this.wrapWithCenter = true,
    this.titleWidget,
    this.header,
    this.footer,
    this.appBarBackgroundColor,
    this.backgroundColor,
    this.onSearchChanged,
    this.controller,
  })  : _isSingle = true,
        children = const [];

  const MaterialScaffold.multiple({
    super.key,
    this.title,
    this.titleStyle,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    required this.children,
    this.titleWidget,
    this.header,
    this.footer,
    this.appBarBackgroundColor,
    this.backgroundColor,
    this.onSearchChanged,
    this.controller,
  })  : _isSingle = false,
        child = const SizedBox(),
        wrapWithCenter = false;

  final Widget? leading;
  final String? title;
  final TextStyle? titleStyle;
  final List<Widget> appBarActions;
  final Color? appBarBackgroundColor;
  final bool automaticallyImplyLeading;
  final bool wrapWithCenter;

  /// If [titleWidget] is not `null`, [title] is overridden.
  final Widget? titleWidget;
  final bool _isSingle;
  final Widget child;
  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final ScrollController? controller;
  final Color? backgroundColor;
  final void Function(String?)? onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: (leading != null || titleWidget != null || title != null || appBarActions.isNotEmpty)
          ? AppBar(
              leading: leading,
              title: titleWidget ??
                  Text(
                    title ?? '',
                    style: titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                  ),
              actions: appBarActions,
              automaticallyImplyLeading: automaticallyImplyLeading,
              backgroundColor: appBarBackgroundColor ?? backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            )
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: buildBodyMaterial(),
          ),
        ],
      ),
    );
  }

  Widget buildBodyMaterial() {
    if (_isSingle) {
      return SafeArea(
        top: leading == null && titleWidget == null && title == null || appBarActions.isEmpty,
        left: false,
        right: false,
        child: _wrapWithFooter(
          child: wrapWithCenter
              ? Center(
                  child: child,
                )
              : child,
        ),
      );
    } else
      return SafeArea(
        top: leading == null && titleWidget == null && title == null || appBarActions.isEmpty,
        left: false,
        right: false,
        child: _wrapWithFooter(
          child: ListView.builder(
            controller: controller,
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          ),
        ),
      );
  }

  Widget _wrapWithFooter({required Widget child, Color? backgroundColor}) {
    if (header == null && footer == null) return child;
    if (header == null)
      return Material(
        color: backgroundColor ?? Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child),
            footer!,
          ],
        ),
      );
    if (footer == null)
      return Material(
        color: backgroundColor ?? Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header!,
            Expanded(child: child),
          ],
        ),
      );
    return Material(
      color: backgroundColor ?? const Color(0x00000000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header!,
          Expanded(child: child),
          footer!,
        ],
      ),
    );
  }
}

class BiCupertinoScaffold extends StatefulWidget {
  const BiCupertinoScaffold.single({
    super.key,
    this.title,
    this.titleStyle,
    this.avatar,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    this.previousPageTitle,
    required this.child,
    this.wrapWithCenter = true,
    this.titleWidget,
    this.header,
    this.headerHeight,
    this.headerColor,
    this.footer,
    this.footerHeight,
    this.footerColor,
    this.appBarBackgroundColor,
    this.backgroundColor,
    this.onSearchChanged,
    required this.locale,
    this.controller,
  })  : _isSingle = true,
        children = const [];

  const BiCupertinoScaffold.multiple({
    super.key,
    this.title,
    this.titleStyle,
    this.avatar,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    required this.previousPageTitle,
    required this.children,
    this.titleWidget,
    this.header,
    this.headerHeight,
    this.headerColor,
    this.footer,
    this.footerHeight,
    this.footerColor,
    this.appBarBackgroundColor,
    this.backgroundColor,
    this.onSearchChanged,
    required this.locale,
    this.controller,
  })  : _isSingle = false,
        child = const SizedBox(),
        wrapWithCenter = false;

  final String? previousPageTitle;
  final Widget? leading;
  final String? title;

  /// If [titleWidget] is not `null`, [title] is overridden.
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final List<Widget> appBarActions;
  final Color? appBarBackgroundColor;
  final bool automaticallyImplyLeading;
  final bool wrapWithCenter;
  final ({ImageProvider image, VoidCallback? onPressed})? avatar;
  final bool _isSingle;
  final Widget child;
  final List<Widget> children;
  final Widget? header;
  final double? headerHeight;
  final Color? headerColor;
  final Widget? footer;
  final double? footerHeight;
  final Color? footerColor;
  final Color? backgroundColor;
  final void Function(String?)? onSearchChanged;
  final ScrollController? controller;

  final String locale;

  @override
  State<BiCupertinoScaffold> createState() => _BiCupertinoScaffoldState();
}

class _BiCupertinoScaffoldState extends State<BiCupertinoScaffold> {
  double isVisibleSearchBar = 0;
  double previousScrollPosition = 0;
  //bool _isCollapsed = true;
  int prevScrollDirection = 0;
  final ScrollController _backupController = ScrollController();

  bool handleControllerNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.depth != 0) return false;
    if (widget.onSearchChanged == null) return false;
    prevScrollDirection = scrollInfo.metrics.pixels > previousScrollPosition ? 1 : -1;
    if (scrollInfo is ScrollUpdateNotification) {
      if (scrollInfo.dragDetails?.delta.dy != null) {
        if (prevScrollDirection == 1 && isVisibleSearchBar > 0) {
          setState(() => isVisibleSearchBar = (40 - scrollInfo.metrics.pixels).clamp(0, 40));
        } else if (prevScrollDirection == -1 && isVisibleSearchBar < 40) {
          setState(() => isVisibleSearchBar = (-scrollInfo.metrics.pixels).clamp(0, 40));
        }
      } else {
        Future.delayed(Duration.zero, () {
          if (isVisibleSearchBar < 20 && isVisibleSearchBar >= 0) {
            setState(() {
              //_isCollapsed = true;
              isVisibleSearchBar = 0;
            });
          } else if (isVisibleSearchBar >= 20 && isVisibleSearchBar <= 40) {
            setState(() {
              //_isCollapsed = false;
              isVisibleSearchBar = 40;
            });
          }
        });
      }
    }
    previousScrollPosition = scrollInfo.metrics.pixels;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String? edited = (widget.previousPageTitle == null && widget.automaticallyImplyLeading) ? PackageLocalizations(widget.locale).back : widget.previousPageTitle;
    if (edited != null && edited.length > 12) edited = '${edited.substring(0, 9)}...';
    return Material(
      color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: _wrapWithFooter(
        scrollController: widget.controller ?? _backupController,
        backgroundColor: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: CupertinoPageScaffold(
          backgroundColor: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          child: NotificationListener<ScrollNotification>(
            onNotification: handleControllerNotification,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: widget.controller ?? _backupController,
              //anchor: _isCollapsed ? 0.055 : 0,
              anchor: lerpDouble(0, 0.055, isVisibleSearchBar / 40) ?? 0,
              semanticChildCount: widget._isSingle ? 1 : widget.children.length,
              slivers: <Widget>[
                if (widget.titleWidget != null || widget.title != null || widget.appBarActions.isNotEmpty || widget.leading != null)
                  if (widget.onSearchChanged == null)
                    CupertinoSliverNavigationBar(
                      alwaysShowMiddle: false,
                      stretch: true,
                      backgroundColor: (widget.appBarBackgroundColor ?? widget.backgroundColor ?? Theme.of(context).colorScheme.surface).withOpacity(.7),
                      largeTitle: widget.avatar == null
                          ? widget.titleWidget ??
                              Text(
                                widget.title ?? '',
                                style: widget.titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                              )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.titleWidget ??
                                    Text(
                                      widget.title ?? '',
                                      style: widget.titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: InkWell(
                                    onTap: widget.avatar!.onPressed,
                                    child: CircleAvatar(
                                      foregroundImage: widget.avatar!.image,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      middle: widget.titleWidget,
                      leading: widget.leading,
                      previousPageTitle: edited,
                      trailing: widget.appBarActions.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: widget.appBarActions,
                            )
                          : null,
                      border: null,
                      automaticallyImplyLeading: widget.automaticallyImplyLeading,
                    )
                  else
                    CupertinoSliverNavigationBar.search(
                      alwaysShowMiddle: false,
                      stretch: true,
                      backgroundColor: (widget.appBarBackgroundColor ?? widget.backgroundColor ?? Theme.of(context).colorScheme.surface).withOpacity(.7),
                      largeTitle: widget.avatar == null
                          ? widget.titleWidget ??
                              Text(
                                widget.title ?? '',
                                style: widget.titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                              )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.titleWidget ??
                                    Text(
                                      widget.title ?? '',
                                      style: widget.titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: InkWell(
                                    onTap: widget.avatar!.onPressed,
                                    child: CircleAvatar(
                                      foregroundImage: widget.avatar!.image,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      middle: widget.titleWidget,
                      leading: widget.leading,
                      previousPageTitle: edited,
                      trailing: widget.appBarActions.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: widget.appBarActions,
                            )
                          : null,
                      border: null,
                      automaticallyImplyLeading: widget.automaticallyImplyLeading,
                      //onSearchChanged: widget.onSearchChanged, // TODO:
                    ),
                buildBodyCupertino(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapWithFooter({
    required Widget child,
    Color? backgroundColor,
    required ScrollController scrollController,
  }) {
    if (widget.header == null && widget.footer == null) return child;
    if (widget.header == null) {
      assert(widget.footerHeight != null);
      return Material(
        color: backgroundColor ?? const Color(0x00000000),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            child,
            SliverFooter(
              border: null,
              scrollController: scrollController,
              backgroundColor: widget.footerColor,
              height: widget.footerHeight!,
              child: widget.footer!,
            ),
          ],
        ),
      );
    }
    if (widget.footer == null)
      return Material(
        color: backgroundColor ?? Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.header!,
            Expanded(child: child),
          ],
        ),
      );
    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.header!,
          Expanded(child: child),
          widget.footer!,
        ],
      ),
    );
  }

  Widget buildBodyCupertino() {
    if (widget.footer == null) {
      if (widget._isSingle) {
        Widget result = widget.child;
        if (widget.wrapWithCenter) result = Center(child: result);
        return SliverSafeArea(
          top: widget.titleWidget == null && widget.title == null && widget.appBarActions.isEmpty && widget.leading == null,
          left: false,
          right: false,
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: result,
          ),
        );
      } else {
        // create copy if children is immutable
        final List<Widget> childrenCopy = List.from(widget.children);
        final Widget lastWidget = childrenCopy.removeLast();
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              ...childrenCopy,
              SafeArea(
                top: false,
                left: false,
                right: false,
                child: lastWidget,
              ),
            ],
          ),
        );
      }
    } else {
      assert(widget.footerHeight != null);
      if (widget._isSingle) {
        Widget result = widget.child;
        if (widget.wrapWithCenter)
          result = Padding(
            padding: EdgeInsets.only(bottom: widget.footerHeight!),
            child: Center(child: result),
          );
        return SliverSafeArea(
          top: widget.titleWidget == null && widget.title == null && widget.appBarActions.isEmpty && widget.leading == null,
          left: false,
          right: false,
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: result,
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              ...widget.children,
              SafeArea(
                top: false,
                left: false,
                right: false,
                child: SizedBox(
                  height: widget.footerHeight,
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}

class SliverFooter extends StatelessWidget {
  const SliverFooter({
    super.key,
    required this.scrollController,
    this.backgroundColor,
    this.border = const Border(
      top: BorderSide(
        color: Color(0x4D000000),
        width: 0.0, // 0.0 means one physical pixel
      ),
    ),
    required this.height,
    required this.child,
  });

  final ScrollController scrollController;
  final Color? backgroundColor;
  final Border? border;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: _StatefulFooterContent(
            scrollController: scrollController,
            backgroundColor: backgroundColor,
            border: border,
            height: height,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
          child: child,
        ),
      ],
    );
  }
}

class _StatefulFooterContent extends StatefulWidget {
  const _StatefulFooterContent({
    required this.scrollController,
    this.backgroundColor,
    this.border = const Border(
      top: BorderSide(
        color: Color(0x4D000000),
        width: 0.0, // 0.0 means one physical pixel
      ),
    ),
    required this.height,
  });

  final ScrollController scrollController;
  final Color? backgroundColor;
  final Border? border;
  final double height;

  @override
  State<_StatefulFooterContent> createState() => _StatefulFooterContentState();
}

class _StatefulFooterContentState extends State<_StatefulFooterContent> {
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
    initialize();
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent) {
        if (isCollapsed) setState(() => isCollapsed = false);
      } else if (!isCollapsed) {
        setState(() => isCollapsed = true);
      }
    });
  }

  Future<void> initialize() async {
    return Future.doWhile(() async {
      try {
        isCollapsed = widget.scrollController.offset < widget.scrollController.position.maxScrollExtent;
        setState(() {});
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 100));
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = DecoratedBox(
      decoration: BoxDecoration(
        border: widget.border ??
            (isCollapsed
                ? const Border(
                    bottom: BorderSide(
                      color: Color(0x4D000000),
                      width: 0.0, // 0.0 means one physical pixel
                    ),
                  )
                : null),
        color: getBackgroundColor(),
      ),
    );

    if (getBackgroundColor().alpha != 0xFF)
      content = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: content,
        ),
      );

    return content;
  }

  Color getBackgroundColor() {
    if (widget.backgroundColor != null) {
      final HSLColor hslBackgroundColor = HSLColor.fromColor(widget.backgroundColor!);
      final double hue = hslBackgroundColor.hue;
      final double saturation = hslBackgroundColor.saturation;
      final double lightness = hslBackgroundColor.lightness;
      final double alpha = hslBackgroundColor.alpha;
      final double lighterLightness = lightness == 0 ? .2 : (lightness * 1.15).clamp(0, 1);
      if (isCollapsed)
        return hslBackgroundColor.withCorrectLightness(lighterLightness).withAlpha(.7 * alpha).toColor();
      else
        return HSLColor.fromAHSL(alpha, hue, saturation, lightness).toColor();
    } else {
      if (isCollapsed)
        return _kSurfaceColor.resolveFrom(context);
      else
        return Theme.of(context).colorScheme.surface;
    }
  }
}

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({
    super.key,
    required this.mainChild,
    required this.secondaryChild,
    this.width,
    this.dividerColor,
  }) : _enableDivider = true;

  const TabletScaffold.noDivider({
    super.key,
    required this.mainChild,
    required this.secondaryChild,
    this.width,
  })  : dividerColor = null,
        _enableDivider = false;

  /// The left side of the scaffold with width.
  final Widget Function(double) mainChild;

  /// The right side of the scaffold with width.
  final Widget Function(double) secondaryChild;
  final double? width;
  final Color? dividerColor;
  final bool _enableDivider;

  @override
  Widget build(BuildContext context) {
    return _layoutBuilderWrapper(
      width,
      child: (double width) {
        const double minWidth = 300;
        const int biggerFlex = 5;
        const int defaultSmallerFlex = 2;
        final double defaultSmallerWidth = width / (biggerFlex + defaultSmallerFlex) * defaultSmallerFlex;
        final int smallerflex = defaultSmallerWidth > minWidth ? defaultSmallerFlex : (minWidth / (width - minWidth) * biggerFlex).ceil();
        //print('$biggerFlex:$defaultSmallerFlex --- ${width / (biggerFlex + defaultSmallerFlex) * biggerFlex}:$defaultSmallerWidth');
        //print('$biggerFlex:$smallerflex --- ${width / (biggerFlex + smallerflex) * biggerFlex}:${width / (biggerFlex + smallerflex) * smallerflex}');
        return Row(
          children: [
            Expanded(
              flex: biggerFlex,
              child: mainChild(biggerFlex / (biggerFlex + smallerflex) * width),
            ),
            if (_enableDivider)
              Container(
                color: Theme.of(context).brightness == Brightness.light ? const Color(0xFFB3B3B3) : const Color(0xFF3D3D3D),
                width: .8,
              ),
            Expanded(
              flex: smallerflex,
              child: secondaryChild(smallerflex / (biggerFlex + smallerflex) * width),
            ),
          ],
        );
      },
    );
  }

  Widget _layoutBuilderWrapper(
    double? width, {
    required Widget Function(double) child,
  }) {
    if (width != null) return child(width);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return child(constraints.maxWidth);
      },
    );
  }
}
