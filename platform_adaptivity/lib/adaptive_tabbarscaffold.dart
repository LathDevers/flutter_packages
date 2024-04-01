import 'dart:math';

import 'package:datatype_extensions/color_extensions.dart';
import 'package:flutter/services.dart';
import 'package:platform_adaptivity/cupertino_navigation_bar_with_image.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

const double _kNavBarElevation = 3;

class LeadingButton {
  const LeadingButton({this.icon, this.text, this.onPressed, this.color1, this.color2});

  final IconData? icon;
  final String? text;
  final void Function(void Function(int))? onPressed;
  final Color? color1;
  final Color? color2;
}

class TabPageAppBar {
  const TabPageAppBar({
    required this.title,
    this.titleStyle,
    this.backgroundImage,
    this.backgroundColor,
    this.leadingButton,
    this.actions = const [],
  });

  final String title;
  final TextStyle? titleStyle;
  final String? backgroundImage;
  final Color? backgroundColor;
  final LeadingButton? leadingButton;
  final List<Widget> actions;
}

class TabPageNavigationBar {
  const TabPageNavigationBar({
    required this.icon,
    this.selectedIcon,
    this.label,
    this.tooltip,
  });

  /// The icon of the item.
  ///
  /// Typically the icon is an [Icon] or an [ImageIcon] widget. If another type
  /// of widget is provided then it should configure itself to match the current
  /// [IconTheme] size and color.
  ///
  /// If a particular icon doesn't have a stroked or filled version, then don't
  /// pair unrelated icons. Instead, make sure to use a
  /// [BottomNavigationBarType.shifting].
  final IconData icon;

  /// An alternative icon displayed when this bottom navigation item is
  /// selected.
  ///
  /// If this icon is not provided, the bottom navigation bar will display
  /// [icon] in either state.
  ///
  /// See also:
  ///
  ///  * [BottomNavigationBarItem.icon], for a description of how to pair icons.
  final IconData? selectedIcon;

  /// The text label for this [BottomNavigationBarItem].
  ///
  /// This will be used to create a [Text] widget to put in the bottom navigation bar.
  final String? label;

  /// The text to display in the [Tooltip] for this [BottomNavigationBarItem].
  ///
  /// A [Tooltip] will only appear on this item if [tooltip] is set to a non-empty string.
  ///
  /// Defaults to null, in which case the tooltip is not shown.
  final String? tooltip;
}

class TabPagePersistantHeader {
  const TabPagePersistantHeader({
    this.leftWidget,
    this.middleWidget,
    this.rightWidget,
    this.backgroundColor,
    this.height = 80,
  });

  final Widget? leftWidget;
  final Widget? middleWidget;
  final Widget? rightWidget;
  final Color? backgroundColor;
  final double height;
}

class AdaptiveTabPage<T> {
  const AdaptiveTabPage({
    required this.appBar,
    required this.navigationBar,
    this.persistantHeader,
    this.onPullToRefresh,
    this.body,
    this.persistantFooter,
    this.onPop,
  });

  final TabPageAppBar appBar;
  final TabPageNavigationBar navigationBar;
  final TabPagePersistantHeader? persistantHeader;
  final Future<void> Function()? onPullToRefresh;
  final List<Widget> Function(BuildContext, int, void Function(int))? body;
  final Widget? persistantFooter;
  final void Function(void Function(int))? onPop;
}

class AdaptiveTabScaffoldWithBottomNavigation extends StatelessWidget {
  const AdaptiveTabScaffoldWithBottomNavigation({
    super.key,
    required this.pages,
    this.backgroundColor,
    this.selectedColor,
    this.selectedIconColor,
    this.tabColor,
    this.footerColor,
  });

  final List<AdaptiveTabPage<Type>> pages;

  final Color? backgroundColor;

  /// On Android, this is the color of the indicatorShape of selected item.
  /// On iOS, this is the icon color of the selected item.
  ///
  /// Defaults to [ThemeData.colorScheme.primary] if null.
  final Color? selectedColor;

  /// On Android, this is the color of the icon of selected item.
  /// Disregarded on iOS.
  ///
  /// Defaults to [ThemeData.disabledColor] if null.
  final Color? selectedIconColor;

  /// On Android, this is the background color of the bottom navigation bar.
  /// On iOS, this is the background color of the tab bar. If it contains transparency, the tab bar will automatically produce a blurring effect to the content behind it.

  /// Defaults to [ThemeData.disabledColor] if null.
  final Color? tabColor;
  final Color? footerColor;

  @override
  Widget build(BuildContext context) {
    switch (designPlatform) {
      case CitecPlatform.material:
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
              tabColor ?? Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.primary,
              _kNavBarElevation,
            ),
          ),
          child: MaterialTabScaffold(
            key: key,
            pages: pages,
            backgroundColor: backgroundColor,
            selectedShadeColor: selectedColor,
            tabColor: tabColor,
            footerColor: footerColor,
          ),
        );
      case CitecPlatform.ios:
        return MyCupertinoTabScaffold(
          key: key,
          pages: pages,
          backgroundColor: backgroundColor,
          selectedColor: selectedColor,
          tabColor: tabColor,
          footerColor: footerColor,
        );
      case CitecPlatform.macos:
      case CitecPlatform.fluent:
      case CitecPlatform.yaru:
        throw UnimplementedError();
    }
  }
}

class MaterialTabScaffold extends StatefulWidget {
  const MaterialTabScaffold({
    super.key,
    required this.pages,
    this.backgroundColor,
    this.selectedShadeColor,
    this.tabColor,
    this.footerColor,
  });

  final List<AdaptiveTabPage<Type>> pages;
  final Color? backgroundColor;

  /// The color of the indicatorShape when this destination is selected.
  ///
  /// If null, [ThemeData.colorScheme.primary] is used. If that is null, [NavigationBarThemeData.indicatorColor] is used. If that
  /// is also null and [ThemeData.useMaterial3] is true, [ColorScheme.secondaryContainer]
  /// is used. Otherwise, [ColorScheme.secondary] with an opacity of 0.24 is used.
  final Color? selectedShadeColor;

  /// The color of the [NavigationBar] itself.
  final Color? tabColor;
  final Color? footerColor;

  @override
  State<MaterialTabScaffold> createState() => _MaterialTabScaffoldState();
}

class _MaterialTabScaffoldState extends State<MaterialTabScaffold> {
  int currentPageIndex = 0;
  final ScrollController scrollController = ScrollController();

  void _changePage(value) => setState(() => currentPageIndex = value);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.pages[currentPageIndex].onPop == null,
      onPopInvoked: (didPop) {
        // if popped, pop request must be coming from somewhere else in the code. onPop actions must be implemented there
        if (!didPop) widget.pages[currentPageIndex].onPop?.call(_changePage);
      },
      child: Scaffold(
        body: Material(
          color: Colors.transparent,
          child: _TabSwitchingView(
            currentTabIndex: currentPageIndex,
            tabCount: widget.pages.length,
            tabBuilder: (BuildContext context, int index) {
              return CupertinoPageScaffoldWithFooter(
                backgroundColor: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                footerHeight: 82,
                footer: widget.pages[index].persistantFooter,
                footerColor: widget.footerColor ?? widget.tabColor ?? Theme.of(context).scaffoldBackgroundColor,
                child: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder: (BuildContext context, _) => [
                    if (widget.pages[index].appBar.backgroundImage != null)
                      CupertinoSliverNavigationBarWithImage(
                        stretch: widget.pages[index].onPullToRefresh == null,
                        largeTitle: Text(
                          widget.pages[index].appBar.title,
                          style: widget.pages[index].appBar.titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        border: null,
                        brightness: (bool isExpanded) => isExpanded ? Brightness.dark : Theme.of(context).brightness,
                        backgroundColor: widget.pages[index].appBar.backgroundColor ?? widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                        backgroundImage: Image.asset(
                          widget.pages[index].appBar.backgroundImage!,
                          fit: BoxFit.cover,
                        ),
                        userLeading: UserLeading(
                          icon: widget.pages[index].appBar.leadingButton?.icon,
                          text: widget.pages[index].appBar.leadingButton?.text,
                          color1: widget.pages[index].appBar.leadingButton?.color1,
                          color2: widget.pages[index].appBar.leadingButton?.color2,
                          onPressed: () => widget.pages[index].appBar.leadingButton?.onPressed?.call(_changePage),
                        ),
                        trailing: (widget.pages[index].appBar.actions.isNotEmpty)
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: widget.pages[index].appBar.actions,
                              )
                            : null,
                      ),
                    if (widget.pages[index].appBar.backgroundImage == null)
                      SliverAppBar(
                        stretch: true,
                        title: Text(
                          widget.pages[index].appBar.title,
                          style: widget.pages[index].appBar.titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        backgroundColor: widget.pages[index].appBar.backgroundColor ?? widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                        leading: IconButton(
                          icon: Icon(
                            widget.pages[index].appBar.leadingButton?.icon,
                            color: widget.pages[index].appBar.leadingButton?.color1,
                          ),
                          onPressed: () => widget.pages[index].appBar.leadingButton?.onPressed?.call(_changePage),
                        ),
                        actions: widget.pages[index].appBar.actions,
                      ),
                    if (widget.pages[index].persistantHeader?.leftWidget != null ||
                        widget.pages[index].persistantHeader?.middleWidget != null ||
                        widget.pages[index].persistantHeader?.rightWidget != null)
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: Delegate(
                          leftWidget: widget.pages[index].persistantHeader!.leftWidget,
                          middleWidget: widget.pages[index].persistantHeader!.middleWidget,
                          rightWidget: widget.pages[index].persistantHeader!.rightWidget,
                          backgroundColor: widget.pages[index].persistantHeader!.backgroundColor ?? widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                          layoutExtent: widget.pages[index].persistantHeader!.height,
                        ),
                      ),
                  ],
                  body: wrapWithRefreshIndicator(
                    index,
                    children: widget.pages[index].body?.call(
                      context,
                      index,
                      _changePage,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: NavigationBar(
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          elevation: _kNavBarElevation,
          indicatorColor: widget.selectedShadeColor ?? Theme.of(context).colorScheme.primary.withOpacity(.15),
          backgroundColor: widget.tabColor ?? Theme.of(context).scaffoldBackgroundColor,
          onDestinationSelected: (int index) {
            if (index == currentPageIndex)
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuad,
              );
            _changePage(index);
          },
          selectedIndex: currentPageIndex,
          destinations: widget.pages
              .map(
                (e) => NavigationDestination(
                  icon: Icon(e.navigationBar.icon),
                  label: e.navigationBar.label ?? '',
                  selectedIcon: Icon(
                    e.navigationBar.selectedIcon ?? e.navigationBar.icon,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: e.navigationBar.tooltip,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget wrapWithSliver({required List<Widget> children}) {
    if (children.length == 1)
      return SliverFillRemaining(
        hasScrollBody: false,
        fillOverscroll: false,
        child: children.first,
      );
    return SliverList(
      delegate: SliverChildListDelegate(
        children,
      ),
    );
  }

  Widget wrapWithSliverFutureBuilder<T>({Future<T>? future, required Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) builder}) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: false,
      child: FutureBuilder<T>(
        future: future,
        builder: builder,
      ),
    );
  }

  Widget wrapWithRefreshIndicator(int index, {List<Widget>? children}) {
    if (widget.pages[index].onPullToRefresh == null) {
      if (children == null) return const SizedBox.shrink();
      if (children.length == 1) return children.first;
      return ListView(
        padding: EdgeInsets.zero,
        children: children,
      );
    } else {
      return RefreshIndicator(
        onRefresh: widget.pages[index].onPullToRefresh!,
        child: CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            wrapWithSliver(
              children: children ?? [const SizedBox.shrink()],
            ),
          ],
        ),
      );
    }
  }
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTabIndex,
    required this.tabCount,
    required this.tabBuilder,
  }) : assert(tabCount > 0);

  final int currentTabIndex;
  final int tabCount;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  final List<bool> shouldBuildTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];

  // When focus nodes are no longer needed, we need to dispose of them, but we
  // can't be sure that nothing else is listening to them until this widget is
  // disposed of, so when they are no longer needed, we move them to this list,
  // and dispose of them when we dispose of this widget.
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];

  @override
  void initState() {
    super.initState();
    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only partially invalidate the tabs cache to avoid breaking the current
    // behavior. We assume that the only possible change is either:
    // - new tabs are appended to the tab list, or
    // - some trailing tabs are removed.
    // If the above assumption is not true, some tabs may lose their state.
    final int lengthDiff = widget.tabCount - shouldBuildTab.length;
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount, shouldBuildTab.length);
    }
    _focusActiveTab();
  }

  // Will focus the active tab if the FocusScope above it has focus already. If
  // not, then it will just mark it as the preferred focus for that scope.
  void _focusActiveTab() {
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount));
        tabFocusNodes.removeRange(widget.tabCount, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount - tabFocusNodes.length,
            (int index) => FocusScopeNode(debugLabel: '$CupertinoTabScaffold Tab ${index + tabFocusNodes.length}'),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    for (final FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final FocusScopeNode focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List<Widget>.generate(
        widget.tabCount,
        (int index) {
          final bool active = index == widget.currentTabIndex;
          shouldBuildTab[index] = active || shouldBuildTab[index];
          return HeroMode(
            enabled: active,
            child: Offstage(
              offstage: !active,
              child: TickerMode(
                enabled: active,
                child: FocusScope(
                  node: tabFocusNodes[index],
                  child: Builder(
                    builder: (BuildContext context) {
                      return shouldBuildTab[index] ? widget.tabBuilder(context, index) : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyCupertinoTabScaffold extends StatefulWidget {
  const MyCupertinoTabScaffold({
    super.key,
    required this.pages,
    this.backgroundColor,
    this.selectedColor,
    this.tabColor,
    this.footerColor,
  });

  final List<AdaptiveTabPage<Object?>> pages;
  final Color? backgroundColor;

  /// The icon color of the selected item.
  ///
  /// Defaults to [ThemeData.colorScheme.primary] if null.
  final Color? selectedColor;

  /// The background color of the tab bar. If it contains transparency, the tab bar will automatically produce a blurring effect to the content behind it.
  final Color? tabColor;
  final Color? footerColor;

  @override
  State<MyCupertinoTabScaffold> createState() => _MyCupertinoTabScaffoldState();
}

class _MyCupertinoTabScaffoldState extends State<MyCupertinoTabScaffold> {
  CupertinoTabController controller = CupertinoTabController();
  ScrollController scrollController = ScrollController();
  static const double _kTabBarHeight = 50.0; // Source: bottom_tab_bar.dart
  static const double _kFooterHeight = 82.0;

  void _changePage(int value) => setState(() => controller.index = value);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double tabBarHeight = MediaQuery.paddingOf(context).bottom + _kTabBarHeight;
    final double insetBottomPadding = EdgeInsets.fromViewPadding(View.of(context).viewInsets, View.of(context).devicePixelRatio).bottom;
    final double bottomPadding = insetBottomPadding > tabBarHeight ? _kFooterHeight : tabBarHeight;
    final Color inactiveColor = HSLColor.fromColor(Theme.of(context).disabledColor).withLightness(.45).toColor();
    return PopScope(
      canPop: widget.pages[controller.index].onPop == null,
      onPopInvoked: (didPop) {
        // if popped, pop request must be coming from somewhere else in the code. onPop actions must be implemented there
        if (!didPop) widget.pages[controller.index].onPop?.call(_changePage);
      },
      child: CupertinoTabScaffold(
        controller: controller,
        backgroundColor: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        tabBar: CupertinoTabBar(
          backgroundColor: widget.tabColor ?? _getBackgroundColor(context, widget.pages[controller.index].persistantFooter == null),
          border: (widget.pages[controller.index].persistantFooter != null)
              ? const Border()
              : Border(
                  top: BorderSide(
                    color: const ColorByBrightness(
                      lightColor: Color(0x4D000000),
                      darkColor: Color(0x29000000),
                    ).resolveFrom(context),
                    width: 0.0, // 0.0 means one physical pixel
                  ),
                ),
          inactiveColor: inactiveColor,
          activeColor: widget.selectedColor ?? Theme.of(context).colorScheme.primary,
          items: widget.pages
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Icon(
                    e.navigationBar.icon,
                    color: inactiveColor,
                    size: 25,
                  ),
                  label: e.navigationBar.label,
                  activeIcon: Icon(
                    e.navigationBar.selectedIcon ?? e.navigationBar.icon,
                    color: widget.selectedColor ?? Theme.of(context).colorScheme.primary,
                    size: 25,
                  ),
                  tooltip: e.navigationBar.tooltip,
                ),
              )
              .toList(),
          onTap: (int index) {
            if (index == controller.index) {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutQuad,
              );
            }
            _changePage(index);
          },
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return CupertinoPageScaffoldWithFooter(
                backgroundColor: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                footerColor: widget.footerColor ?? widget.tabColor ?? _getBackgroundColor(context, false),
                tabBarHeight: tabBarHeight,
                footerHeight: _kFooterHeight,
                footer: widget.pages[index].persistantFooter,
                child: CustomScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(
                    parent: widget.pages[index].onPullToRefresh != null ? const AlwaysScrollableScrollPhysics() : null,
                  ),
                  slivers: [
                    CupertinoSliverNavigationBarWithImage(
                      stretch: widget.pages[index].onPullToRefresh == null,
                      largeTitle: Text(
                        widget.pages[index].appBar.title,
                        style: widget.pages[index].appBar.titleStyle ?? TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      border: null,
                      brightness: (bool isExpanded) => isExpanded ? Brightness.dark : Theme.of(context).brightness,
                      backgroundColor: widget.pages[index].appBar.backgroundColor ?? widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                      backgroundImage: widget.pages[index].appBar.backgroundImage != null
                          ? Image.asset(
                              widget.pages[index].appBar.backgroundImage!,
                              fit: BoxFit.cover,
                            )
                          : null,
                      userLeading: UserLeading(
                        icon: widget.pages[index].appBar.leadingButton?.icon,
                        text: widget.pages[index].appBar.leadingButton?.text,
                        color1: widget.pages[index].appBar.leadingButton?.color1,
                        color2: widget.pages[index].appBar.leadingButton?.color2,
                        onPressed: () => widget.pages[index].appBar.leadingButton?.onPressed?.call(_changePage),
                      ),
                      trailing: (widget.pages[index].appBar.actions.isNotEmpty)
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: widget.pages[index].appBar.actions,
                            )
                          : null,
                    ),
                    if (widget.pages[index].persistantHeader?.leftWidget != null ||
                        widget.pages[index].persistantHeader?.middleWidget != null ||
                        widget.pages[index].persistantHeader?.rightWidget != null)
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: Delegate(
                          leftWidget: widget.pages[index].persistantHeader!.leftWidget,
                          middleWidget: widget.pages[index].persistantHeader!.middleWidget,
                          rightWidget: widget.pages[index].persistantHeader!.rightWidget,
                          backgroundColor: widget.pages[index].persistantHeader!.backgroundColor ?? widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                          layoutExtent: widget.pages[index].persistantHeader!.height,
                        ),
                      ),
                    if (widget.pages[index].onPullToRefresh != null)
                      CupertinoSliverRefreshControl(
                        onRefresh: widget.pages[index].onPullToRefresh,
                      ),
                    if (widget.pages[index].body != null)
                      wrapWithSliver(
                        bottomPadding: bottomPadding,
                        children: widget.pages[index].body!(
                          context,
                          index,
                          _changePage,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget wrapWithSliver({required List<Widget> children, required double bottomPadding}) {
    if (children.length == 1)
      return SliverFillRemaining(
        hasScrollBody: false,
        fillOverscroll: false,
        child: Column(
          children: [
            Expanded(child: children.first),
            SizedBox(
              height: bottomPadding,
            ),
          ],
        ),
      );
    else
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            ...children,
            SizedBox(
              height: bottomPadding,
            ),
          ],
        ),
      );
  }

  Widget wrapWithSliverFutureBuilder<T>({Future<T>? future, required Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) builder}) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: false,
      child: FutureBuilder<T>(
        future: future,
        builder: builder,
      ),
    );
  }
}

Color _getBackgroundColor(BuildContext context, [bool withOpacity = true]) {
  final HSLColor systemBackgroundColor = HSLColor.fromColor(Theme.of(context).scaffoldBackgroundColor);
  final double hue = systemBackgroundColor.hue;
  final double saturation = systemBackgroundColor.saturation;
  final double lightness = systemBackgroundColor.lightness;
  final double newSaturation = Theme.of(context).scaffoldBackgroundColor == Colors.black ? 0 : max(saturation - .18, 0);
  // Colors.black has a saturation of 1, which, with higher lightness, would result in red.
  final double newLightness = Theme.of(context).brightness == Brightness.light ? min(lightness + .1, 1) : max(lightness - .1, .05);
  return HSLColor.fromAHSL(withOpacity ? .85 : 1, hue, newSaturation, newLightness).toColor();
}

class CupertinoPageScaffoldWithFooter extends StatelessWidget {
  const CupertinoPageScaffoldWithFooter({
    super.key,
    this.navigationBar,
    this.backgroundColor,
    required this.child,
    required this.footerColor,
    this.tabBarHeight = 0,
    required this.footerHeight,
    required this.footer,
  });

  final ObstructingPreferredSizeWidget? navigationBar;
  final Color? backgroundColor;
  final Color footerColor;
  final double tabBarHeight;
  final double footerHeight;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
              backgroundColor: backgroundColor,
              navigationBar: navigationBar,
              child: child,
            ),
          ),
        ),
        if (footer != null) ...[
          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: switch (designPlatform) {
                  CitecPlatform.material => ElevationOverlay.applySurfaceTint(footerColor, Theme.of(context).colorScheme.primary, _kNavBarElevation),
                  CitecPlatform.ios => footerColor,
                  _ => throw UnimplementedError(),
                },
                border: Border(
                  top: BorderSide(
                    color: const ColorByBrightness(
                      lightColor: Color(0x4D000000),
                      darkColor: Color(0x29000000),
                    ).resolveFrom(context),
                    width: 0.0, // 0.0 means one physical pixel
                  ),
                ),
              ),
              height: footerHeight,
              child: footer,
            ),
          ),
        ],
      ],
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  const Delegate({
    this.leftWidget,
    this.middleWidget,
    this.rightWidget,
    this.backgroundColor,
    this.layoutExtent = 80,
  });

  final Widget? leftWidget;
  final Widget? middleWidget;
  final Widget? rightWidget;
  final Color? backgroundColor;
  final double layoutExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (leftWidget == null && middleWidget != null && rightWidget == null) return middleWidget!;
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: leftWidget ??
                ((rightWidget != null)
                    ? Visibility(
                        visible: false,
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        child: rightWidget!,
                      )
                    : null),
          ),
          middleWidget != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: middleWidget,
                  ),
                )
              : const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: rightWidget ??
                ((leftWidget != null)
                    ? Visibility(
                        visible: false,
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        child: leftWidget!,
                      )
                    : null),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => layoutExtent;

  @override
  double get minExtent => layoutExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
