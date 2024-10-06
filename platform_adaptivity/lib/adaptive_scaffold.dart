import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_adaptivity/l10n/app_localizations.dart';

class AdaptiveScaffold extends StatelessWidget {
  /// Creates a visual scaffold for Material or Cupertino widgets.
  ///
  /// On Material returns a normal [Scaffold] widget, while on Cupertino returns a [CupertinoPageScaffold] with slivers.
  const AdaptiveScaffold.single({
    super.key,
    this.title,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    this.previousPageTitle,
    required this.child,
    this.alwaysScrollable = false,
    this.wrapWithCenter = true,
    this.titleWidget,
    this.header,
    this.footer,
    this.backgroundColor,
    required this.locale,
    this.controller,
  })  : _isSingle = true,
        children = const [];

  /// Creates a visual scaffold for Material or Cupertino widgets.
  ///
  /// On Material returns a normal [Scaffold] widget, while on Cupertino returns a [CupertinoPageScaffold] with slivers.
  const AdaptiveScaffold.multiple({
    super.key,
    this.title,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    this.previousPageTitle,
    required this.children,
    this.alwaysScrollable = false,
    this.titleWidget,
    this.header,
    this.footer,
    this.backgroundColor,
    required this.locale,
    this.controller,
  })  : _isSingle = false,
        child = const SizedBox(),
        wrapWithCenter = false;

  /// Only applied on iOS
  final String? previousPageTitle;
  final Widget? leading;
  final String? title;
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
  final Widget? footer;
  final Color? backgroundColor;
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
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            wrapWithCenter: wrapWithCenter,
            titleWidget: titleWidget,
            header: header,
            footer: footer,
            controller: controller,
            child: child,
          );
        else
          return MaterialScaffold.multiple(
            key: key,
            title: title,
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            titleWidget: titleWidget,
            header: header,
            footer: footer,
            controller: controller,
            children: children,
          );
      case CitecPlatform.ios:
        if (_isSingle)
          return BiCupertinoScaffold.single(
            key: key,
            title: title,
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            previousPageTitle: previousPageTitle,
            wrapWithCenter: wrapWithCenter,
            titleWidget: titleWidget,
            header: header,
            footer: footer,
            backgroundColor: backgroundColor,
            locale: locale,
            controller: controller,
            child: child,
          );
        else
          return BiCupertinoScaffold.multiple(
            key: key,
            title: title,
            leading: leading,
            appBarActions: appBarActions,
            automaticallyImplyLeading: automaticallyImplyLeading,
            previousPageTitle: previousPageTitle,
            titleWidget: titleWidget,
            header: header,
            footer: footer,
            backgroundColor: backgroundColor,
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
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    required this.child,
    this.wrapWithCenter = true,
    this.titleWidget,
    this.header,
    this.footer,
    this.controller,
  })  : _isSingle = true,
        children = const [];

  const MaterialScaffold.multiple({
    super.key,
    this.title,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    required this.children,
    this.titleWidget,
    this.header,
    this.footer,
    this.controller,
  })  : _isSingle = false,
        child = const SizedBox(),
        wrapWithCenter = false;

  final Widget? leading;
  final String? title;
  final List<Widget> appBarActions;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (leading != null || titleWidget != null || title != null || appBarActions.isNotEmpty)
          ? AppBar(
              leading: leading,
              title: titleWidget ??
                  Text(
                    title ?? '',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
              actions: appBarActions,
              automaticallyImplyLeading: automaticallyImplyLeading,
            )
          : null,
      body: buildBodyMaterial(),
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
      color: backgroundColor ?? Colors.transparent,
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

class BiCupertinoScaffold extends StatelessWidget {
  const BiCupertinoScaffold.single({
    super.key,
    this.title,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    this.previousPageTitle,
    required this.child,
    this.wrapWithCenter = true,
    this.titleWidget,
    this.header,
    this.footer,
    this.backgroundColor,
    required this.locale,
    this.controller,
  })  : _isSingle = true,
        children = const [];

  const BiCupertinoScaffold.multiple({
    super.key,
    this.title,
    this.leading,
    this.appBarActions = const <Widget>[],
    this.automaticallyImplyLeading = true,
    this.previousPageTitle,
    required this.children,
    this.titleWidget,
    this.header,
    this.footer,
    this.backgroundColor,
    required this.locale,
    this.controller,
  })  : _isSingle = false,
        child = const SizedBox(),
        wrapWithCenter = false;

  final String? previousPageTitle;
  final Widget? leading;
  final String? title;
  final List<Widget> appBarActions;
  final bool automaticallyImplyLeading;
  final bool wrapWithCenter;

  /// If [titleWidget] is not `null`, [title] is overridden.
  final Widget? titleWidget;
  final bool _isSingle;
  final Widget child;
  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final Color? backgroundColor;
  final ScrollController? controller;

  final String locale;

  @override
  Widget build(BuildContext context) {
    String? edited = (previousPageTitle == null && automaticallyImplyLeading) ? PackageLocalizations(locale).back : previousPageTitle;
    if (edited != null && edited.length > 12) edited = '${edited.substring(0, 9)}...';
    return Material(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (titleWidget != null || title != null || appBarActions.isNotEmpty || leading != null)
            ? (context, _) => [
                  CupertinoSliverNavigationBar(
                    brightness: Theme.of(context).brightness,
                    stretch: true,
                    backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                    largeTitle: titleWidget ??
                        Text(
                          title ?? '',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                    leading: leading,
                    previousPageTitle: edited,
                    trailing: appBarActions.isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: appBarActions,
                          )
                        : null,
                    border: null,
                    automaticallyImplyLeading: automaticallyImplyLeading,
                  ),
                ]
            : (context, _) => [
                  const SliverToBoxAdapter(),
                ],
        body: _wrapWithFooter(
          backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            semanticChildCount: _isSingle ? 1 : children.length,
            slivers: <Widget>[
              buildBodyCupertino(),
            ],
          ),
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
      color: backgroundColor ?? Colors.transparent,
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

  Widget buildBodyCupertino() {
    if (_isSingle)
      return SliverSafeArea(
        top: titleWidget == null && title == null && appBarActions.isEmpty && leading == null,
        left: false,
        right: false,
        sliver: SliverFillRemaining(
          hasScrollBody: false,
          child: wrapWithCenter ? Center(child: child) : child,
        ),
      );
    else {
      // create copy if children is immutable
      final List<Widget> childrenCopy = List.from(children);
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
