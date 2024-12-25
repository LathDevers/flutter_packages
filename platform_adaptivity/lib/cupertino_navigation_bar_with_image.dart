/// This code extends the existing [CupertinoNavigationBar] widget, so that a image of type [Image] can be added to the background.
/// The necessery parts of the original code were copied and altered.
/// For more information please look at the original code under [CupertinoNavigationBar], that is thouroughly commented.
/// Here I did not include any comment from the original code.
/// ----------------------
/// Lurvig @2022
library;

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:datatype_extensions/color_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;
const double _kNavBarLargeTitleHeightExtension = 52.0;
const double _kNavBarShowLargeTitleThreshold = 10.0;
const double _kNavBarEdgePadding = 16.0;
const double _kNavBarBackButtonTapWidth = 50.0;
const Duration _kNavBarTitleFadeDuration = Duration(milliseconds: 150);
const Color _kDefaultNavBarBorderColor = Color(0x4D000000);
const Border _kDefaultNavBarBorder = Border(
  bottom: BorderSide(
    color: _kDefaultNavBarBorderColor,
    width: 0.0,
  ),
);

const _HeroTag _defaultHeroTag = _HeroTag(null);

@immutable
class _HeroTag {
  const _HeroTag(this.navigator);
  final NavigatorState? navigator;

  @override
  String toString() => 'Default Hero tag for Cupertino navigation bars with navigator $navigator';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is _HeroTag && other.navigator == navigator;
  }

  @override
  int get hashCode => identityHashCode(navigator);
}

class _FixedSizeSlidingTransition extends AnimatedWidget {
  const _FixedSizeSlidingTransition({
    required this.isLTR,
    required this.offsetAnimation,
    required this.size,
    required this.child,
  }) : super(listenable: offsetAnimation);
  final bool isLTR;
  final Size size;
  final Animation<Offset> offsetAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: offsetAnimation.value.dy,
      left: isLTR ? offsetAnimation.value.dx : null,
      right: isLTR ? null : offsetAnimation.value.dx,
      width: size.width,
      height: size.height,
      child: child,
    );
  }
}

Widget _wrapWithBackground({
  Border? border,
  required Color backgroundColor,
  Brightness? brightness,
  required Widget child,
  bool updateSystemUiOverlay = true,
}) {
  Widget result = child;
  if (updateSystemUiOverlay) {
    final bool isDark = backgroundColor.computeLuminance() < 0.179;
    final Brightness newBrightness = brightness ?? (isDark ? Brightness.dark : Brightness.light);
    final SystemUiOverlayStyle overlayStyle;
    switch (newBrightness) {
      case Brightness.dark:
        overlayStyle = SystemUiOverlayStyle.light;
        break;
      case Brightness.light:
        overlayStyle = SystemUiOverlayStyle.dark;
        break;
    }
    result = AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: result,
    );
  }
  final DecoratedBox childWithBackground = DecoratedBox(
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor,
    ),
    child: result,
  );

  if (backgroundColor.alpha == 0xFF) return childWithBackground;

  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: childWithBackground,
    ),
  );
}

bool _isTransitionable(BuildContext context) {
  final ModalRoute<dynamic>? route = ModalRoute.of(context);
  return route is PageRoute && !route.fullscreenDialog;
}

class CupertinoSliverNavigationBarWithImage extends StatefulWidget {
  /// Creates a navigation bar with [backgroundImage] for scrolling lists.
  /// This image will disappear if navigation bar is collapsed and reappear if navigation bar is extended.
  /// The image does not have a hard edge on the bottom, a [LinearGradient] is applied, that washes
  /// the background color on the image, thereby fading the image's edge for better UX.
  ///
  /// The [largeTitle] argument is required and must not be null.
  const CupertinoSliverNavigationBarWithImage({
    super.key,
    this.largeTitle,
    this.userLeading,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyTitle = true,
    this.previousPageTitle,
    this.middle,
    this.trailing,
    this.border = _kDefaultNavBarBorder,
    this.backgroundColor,
    this.brightness,
    this.padding,
    this.transitionBetweenRoutes = true,
    this.heroTag = _defaultHeroTag,
    this.stretch = false,
    this.backgroundImage,
    this.previousPageTitleColor,
  }) : assert(
          automaticallyImplyTitle == true || largeTitle != null,
          'No largeTitle has been provided but automaticallyImplyTitle is also '
          'false. Either provide a largeTitle or set automaticallyImplyTitle to '
          'true.',
        );

  /// The navigation bar's title.
  ///
  /// This text will appear in the top static navigation bar when collapsed and
  /// below the navigation bar, in a larger font, when expanded.
  ///
  /// A suitable [DefaultTextStyle] is provided around this widget as it is
  /// moved around, to change its font size.
  ///
  /// If [middle] is null, then the [largeTitle] widget will be inserted into
  /// the tree in two places when transitioning from the collapsed state to the
  /// expanded state. It is therefore imperative that this subtree not contain
  /// any [GlobalKey]s, and that it not rely on maintaining state (for example,
  /// animations will not survive the transition from one location to the other,
  /// and may in fact be visible in two places at once during the transition).
  ///
  /// If null and [automaticallyImplyTitle] is true, an appropriate [Text]
  /// title will be created if the current route is a [CupertinoPageRoute] and
  /// has a `title`.
  ///
  /// This parameter must either be non-null or the route must have a title
  /// ([CupertinoPageRoute.title]) and [automaticallyImplyTitle] must be true.
  final Widget? largeTitle;

  final UserLeading? userLeading;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.automaticallyImplyLeading}
  final bool automaticallyImplyLeading;

  /// Controls whether we should try to imply the [largeTitle] widget if null.
  ///
  /// If true and [largeTitle] is null, automatically fill in a [Text] widget
  /// with the current route's `title` if the route is a [CupertinoPageRoute].
  /// If [largeTitle] widget is not null, this parameter has no effect.
  ///
  /// This value cannot be null.
  final bool automaticallyImplyTitle;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.previousPageTitle}
  final String? previousPageTitle;

  /// A widget to place in the middle of the static navigation bar instead of
  /// the [largeTitle].
  ///
  /// This widget is visible in both collapsed and expanded states. The text
  /// supplied in [largeTitle] will no longer appear in collapsed state if a
  /// [middle] widget is provided.
  final Widget? middle;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.trailing}
  ///
  /// This widget is visible in both collapsed and expanded states.
  final Widget? trailing;

  /// The background color of the navigation bar. It is used to wash the bottom edge of the navigation bar between the contained image and the scaffold background.
  ///
  /// Defaults to [CupertinoTheme]'s scaffoldBackgroundColor if null.
  final Color? backgroundColor;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.brightness}
  final Brightness Function(bool isExpanded)? brightness;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.padding}
  final EdgeInsetsDirectional? padding;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.border}
  final Border? border;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.transitionBetweenRoutes}
  final bool transitionBetweenRoutes;

  /// {@macro flutter.cupertino.CupertinoNavigationBar.heroTag}
  final Object heroTag;

  /// True if the navigation bar's background color has no transparency.
  bool get opaque => backgroundColor?.alpha == 0xFF;

  /// Whether the nav bar should stretch to fill the over-scroll area.
  ///
  /// The nav bar can still expand and contract as the user scrolls, but it will
  /// also stretch when the user over-scrolls if the [stretch] value is `true`.
  ///
  /// When set to `true`, the nav bar will prevent subsequent slivers from
  /// accessing overscrolls. This may be undesirable for using overscroll-based
  /// widgets like the [CupertinoSliverRefreshControl].
  ///
  /// Defaults to `false`.
  final bool stretch;

  /// This [Image] will be put in the background of the navigation bar.
  ///
  /// If the navigation bar is collapsed, the image disappears.
  final ImageProvider? backgroundImage;

  /// Color of [previousPageTitle]. If this is `null`, `DefaultTextStyle.of(context).style.color` is used.
  ///
  /// If [previousPageTitle] is `null`, this [Color] is applied to the default back chevron button.
  final Color? previousPageTitleColor;

  @override
  State<CupertinoSliverNavigationBarWithImage> createState() => _CupertinoSliverNavigationBarWithImageState();
}

class _CupertinoSliverNavigationBarWithImageState extends State<CupertinoSliverNavigationBarWithImage> {
  late _NavigationBarStaticComponentsKeys keys;

  @override
  void initState() {
    super.initState();
    keys = _NavigationBarStaticComponentsKeys();
  }

  @override
  Widget build(BuildContext context) {
    final _NavigationBarStaticComponents components = _NavigationBarStaticComponents(
      keys: keys,
      route: ModalRoute.of(context),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      automaticallyImplyTitle: widget.automaticallyImplyTitle,
      previousPageTitle: widget.previousPageTitle,
      userMiddle: widget.middle,
      userTrailing: widget.trailing,
      userLargeTitle: widget.largeTitle,
      padding: widget.padding,
      large: true,
      color: widget.previousPageTitleColor,
    );

    return MediaQuery.withNoTextScaling(
      child: SliverPersistentHeader(
        pinned: true,
        delegate: _LargeTitleNavigationBarSliverDelegate(
          keys: keys,
          components: components,
          userLeading: widget.userLeading,
          userMiddle: widget.middle,
          backgroundColor: ColorByBrightness.maybeResolve(widget.backgroundColor, context) ?? CupertinoTheme.of(context).scaffoldBackgroundColor,
          brightness: widget.brightness,
          border: widget.border,
          padding: widget.padding,
          actionsForegroundColor: CupertinoTheme.of(context).primaryColor,
          transitionBetweenRoutes: widget.transitionBetweenRoutes,
          heroTag: widget.heroTag,
          persistentHeight: _kNavBarPersistentHeight + MediaQuery.paddingOf(context).top,
          alwaysShowMiddle: false,
          stretchConfiguration: widget.stretch ? OverScrollHeaderStretchConfiguration() : null,
          backgroundImage: widget.backgroundImage,
        ),
      ),
    );
  }
}

class UserLeading {
  const UserLeading({this.icon, this.text, this.onPressed, this.color1, this.color2});

  /// The icon to display before the [text].
  ///
  /// By default this is an [CupertinoIcons.back].
  final IconData? icon;

  /// The text to display after the [icon], if [icon] is provided.
  final String? text;
  final void Function()? onPressed;
  final Color? color1;
  final Color? color2;
}

class _LargeTitleNavigationBarSliverDelegate extends SliverPersistentHeaderDelegate with DiagnosticableTreeMixin {
  _LargeTitleNavigationBarSliverDelegate({
    required this.keys,
    required this.components,
    required this.userLeading,
    required this.userMiddle,
    required this.backgroundColor,
    required this.brightness,
    required this.border,
    required this.padding,
    required this.actionsForegroundColor,
    required this.transitionBetweenRoutes,
    required this.heroTag,
    required this.persistentHeight,
    required this.alwaysShowMiddle,
    required this.stretchConfiguration,
    required this.backgroundImage,
  });

  final _NavigationBarStaticComponentsKeys keys;
  final _NavigationBarStaticComponents components;
  final UserLeading? userLeading;
  final Widget? userMiddle;
  final Color backgroundColor;
  final Brightness Function(bool isExpanded)? brightness;
  final Border? border;
  final EdgeInsetsDirectional? padding;
  final Color actionsForegroundColor;
  final bool transitionBetweenRoutes;
  final Object heroTag;
  final double persistentHeight;
  final bool alwaysShowMiddle;
  final ImageProvider? backgroundImage;

  @override
  double get minExtent => persistentHeight;

  @override
  double get maxExtent => persistentHeight + _kNavBarLargeTitleHeightExtension;

  @override
  OverScrollHeaderStretchConfiguration? stretchConfiguration;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool showLargeTitle = shrinkOffset < maxExtent - minExtent - _kNavBarShowLargeTitleThreshold;

    final _PersistentNavigationBar persistentNavigationBar = _PersistentNavigationBar(
      components: components,
      padding: padding,
      middleVisible: alwaysShowMiddle ? null : !showLargeTitle,
      userLeadingIcon: userLeading?.icon,
      userLeadingText: userLeading?.text,
      userLeadingOnPressed: userLeading?.onPressed,
      userLeadingColor: showLargeTitle ? userLeading?.color1 : userLeading?.color2,
    );

    final Widget navBar = _wrapWithBackground(
      border: border,
      backgroundColor: ColorByBrightness.resolve(backgroundColor, context),
      brightness: (backgroundImage != null) ? brightness?.call(showLargeTitle) : null,
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (backgroundImage != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: showLargeTitle ? 1.0 : 0.0,
                  duration: _kNavBarTitleFadeDuration,
                  child: Image(
                    image: backgroundImage!,
                    fit: BoxFit.cover,
                    alignment: AlignmentDirectional.topCenter,
                  ),
                ),
              ),
            if (backgroundImage != null)
              AnimatedOpacity(
                opacity: showLargeTitle ? 1.0 : 0.0,
                duration: _kNavBarTitleFadeDuration,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 1],
                      colors: <Color>[
                        backgroundColor.withOpacity(0),
                        backgroundColor,
                      ],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: persistentHeight,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: ClipRect(
                child: OverflowBox(
                  minHeight: 0.0,
                  maxHeight: double.infinity,
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: _kNavBarEdgePadding,
                      bottom: 8.0,
                    ),
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: AnimatedOpacity(
                        opacity: showLargeTitle ? 1.0 : 0.0,
                        duration: _kNavBarTitleFadeDuration,
                        child: Semantics(
                          header: true,
                          child: DefaultTextStyle(
                            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: components.largeTitle!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              child: persistentNavigationBar,
            ),
          ],
        ),
      ),
    );

    if (!transitionBetweenRoutes || !_isTransitionable(context)) {
      return navBar;
    }

    return Hero(
      tag: heroTag == _defaultHeroTag ? _HeroTag(Navigator.of(context)) : heroTag,
      createRectTween: _linearTranslateWithLargestRectSizeTween,
      flightShuttleBuilder: _navBarHeroFlightShuttleBuilder,
      placeholderBuilder: _navBarHeroLaunchPadBuilder,
      transitionOnUserGestures: true,
      child: _TransitionableNavigationBar(
        componentsKeys: keys,
        backgroundColor: ColorByBrightness.resolve(backgroundColor, context),
        backButtonTextStyle: CupertinoTheme.of(context).textTheme.navActionTextStyle,
        titleTextStyle: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        largeTitleTextStyle: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        border: border,
        hasUserMiddle: userMiddle != null,
        largeExpanded: showLargeTitle,
        child: navBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_LargeTitleNavigationBarSliverDelegate oldDelegate) {
    return components != oldDelegate.components ||
        userMiddle != oldDelegate.userMiddle ||
        backgroundColor != oldDelegate.backgroundColor ||
        border != oldDelegate.border ||
        padding != oldDelegate.padding ||
        actionsForegroundColor != oldDelegate.actionsForegroundColor ||
        transitionBetweenRoutes != oldDelegate.transitionBetweenRoutes ||
        persistentHeight != oldDelegate.persistentHeight ||
        alwaysShowMiddle != oldDelegate.alwaysShowMiddle ||
        heroTag != oldDelegate.heroTag;
  }
}

class _PersistentNavigationBar extends StatelessWidget {
  const _PersistentNavigationBar({
    required this.components,
    required this.padding,
    required this.middleVisible,
    required this.userLeadingIcon,
    required this.userLeadingText,
    required this.userLeadingOnPressed,
    required this.userLeadingColor,
  });

  final _NavigationBarStaticComponents components;
  final EdgeInsetsDirectional? padding;
  final bool? middleVisible;
  final IconData? userLeadingIcon;
  final String? userLeadingText;
  final void Function()? userLeadingOnPressed;
  final Color? userLeadingColor;

  @override
  Widget build(BuildContext context) {
    Widget? middle = components.middle;

    if (middle != null) {
      middle = DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        child: Semantics(header: true, child: middle),
      );
      middle = middleVisible == null
          ? middle
          : AnimatedOpacity(
              opacity: middleVisible! ? 1.0 : 0.0,
              duration: _kNavBarTitleFadeDuration,
              child: middle,
            );
    }

    Widget? leading = components.leading;
    if (userLeadingIcon != null || userLeadingText != null) {
      leading = AnimatedSwitcher(
        duration: _kNavBarTitleFadeDuration,
        child: MyCupertinoNavigationBarBackButton._user(
          userLeadingIcon,
          userLeadingText,
          userLeadingOnPressed,
          userLeadingColor,
        ),
      );
    }
    final Widget? backChevron = components.backChevron;
    final Widget? backLabel = components.backLabel;
    if (leading == null && backChevron != null && backLabel != null) {
      leading = MyCupertinoNavigationBarBackButton._assemble(
        backChevron,
        backLabel,
      );
    }

    Widget paddedToolbar = NavigationToolbar(
      leading: leading,
      middle: middle,
      trailing: components.trailing,
      middleSpacing: 6.0,
    );

    if (padding != null) {
      paddedToolbar = Padding(
        padding: EdgeInsets.only(
          top: padding!.top,
          bottom: padding!.bottom,
        ),
        child: paddedToolbar,
      );
    }

    return SizedBox(
      height: _kNavBarPersistentHeight + MediaQuery.paddingOf(context).top,
      child: SafeArea(
        bottom: false,
        child: paddedToolbar,
      ),
    );
  }
}

@immutable
class _NavigationBarStaticComponentsKeys {
  _NavigationBarStaticComponentsKeys()
      : navBarBoxKey = GlobalKey(debugLabel: 'Navigation bar render box'),
        leadingKey = GlobalKey(debugLabel: 'Leading'),
        backChevronKey = GlobalKey(debugLabel: 'Back chevron'),
        backLabelKey = GlobalKey(debugLabel: 'Back label'),
        middleKey = GlobalKey(debugLabel: 'Middle'),
        trailingKey = GlobalKey(debugLabel: 'Trailing'),
        largeTitleKey = GlobalKey(debugLabel: 'Large title');

  final GlobalKey navBarBoxKey;
  final GlobalKey leadingKey;
  final GlobalKey backChevronKey;
  final GlobalKey backLabelKey;
  final GlobalKey middleKey;
  final GlobalKey trailingKey;
  final GlobalKey largeTitleKey;
}

@immutable
class _NavigationBarStaticComponents {
  _NavigationBarStaticComponents({
    required _NavigationBarStaticComponentsKeys keys,
    required ModalRoute<dynamic>? route,
    required bool automaticallyImplyLeading,
    required bool automaticallyImplyTitle,
    required String? previousPageTitle,
    required Widget? userMiddle,
    required Widget? userTrailing,
    required Widget? userLargeTitle,
    required EdgeInsetsDirectional? padding,
    required bool large,
    required Color? color,
  })  : leading = createLeading(
          leadingKey: keys.leadingKey,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
          padding: padding,
        ),
        backChevron = createBackChevron(
          backChevronKey: keys.backChevronKey,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
          color: color,
        ),
        backLabel = createBackLabel(
          backLabelKey: keys.backLabelKey,
          route: route,
          previousPageTitle: previousPageTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          color: color,
        ),
        middle = createMiddle(
          middleKey: keys.middleKey,
          userMiddle: userMiddle,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticallyImplyTitle: automaticallyImplyTitle,
          large: large,
        ),
        trailing = createTrailing(
          trailingKey: keys.trailingKey,
          userTrailing: userTrailing,
          padding: padding,
        ),
        largeTitle = createLargeTitle(
          largeTitleKey: keys.largeTitleKey,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticImplyTitle: automaticallyImplyTitle,
          large: large,
        );

  static Widget? _derivedTitle({
    required bool automaticallyImplyTitle,
    ModalRoute<dynamic>? currentRoute,
  }) {
    if (automaticallyImplyTitle && currentRoute is CupertinoRouteTransitionMixin && currentRoute.title != null) return Text(currentRoute.title!);
    return null;
  }

  final KeyedSubtree? leading;
  static KeyedSubtree? createLeading({
    required GlobalKey leadingKey,
    required ModalRoute<dynamic>? route,
    required bool automaticallyImplyLeading,
    required EdgeInsetsDirectional? padding,
  }) {
    Widget? leadingContent;

    if (automaticallyImplyLeading && route is PageRoute && route.canPop && route.fullscreenDialog) {
      leadingContent = CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => route.navigator!.maybePop(),
        child: const Text('Close'),
      );
    }

    if (leadingContent == null) return null;

    return KeyedSubtree(
      key: leadingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: padding?.start ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 32.0,
          ),
          child: leadingContent,
        ),
      ),
    );
  }

  final KeyedSubtree? backChevron;
  static KeyedSubtree? createBackChevron({
    required GlobalKey backChevronKey,
    required ModalRoute<dynamic>? route,
    required bool automaticallyImplyLeading,
    required Color? color,
  }) {
    if (!automaticallyImplyLeading || route == null || !route.canPop || (route is PageRoute && route.fullscreenDialog)) return null;
    return KeyedSubtree(key: backChevronKey, child: _BackChevron(color: color));
  }

  final KeyedSubtree? backLabel;
  static KeyedSubtree? createBackLabel({
    required GlobalKey backLabelKey,
    required ModalRoute<dynamic>? route,
    required bool automaticallyImplyLeading,
    required String? previousPageTitle,
    required Color? color,
  }) {
    if (!automaticallyImplyLeading || route == null || !route.canPop || (route is PageRoute && route.fullscreenDialog)) return null;
    return KeyedSubtree(
      key: backLabelKey,
      child: _BackLabel(
        specifiedPreviousTitle: previousPageTitle,
        route: route,
        color: color,
      ),
    );
  }

  final KeyedSubtree? middle;
  static KeyedSubtree? createMiddle({
    required GlobalKey middleKey,
    required Widget? userMiddle,
    required Widget? userLargeTitle,
    required bool large,
    required bool automaticallyImplyTitle,
    required ModalRoute<dynamic>? route,
  }) {
    Widget? middleContent = userMiddle;
    if (large) middleContent ??= userLargeTitle;
    middleContent ??= _derivedTitle(
      automaticallyImplyTitle: automaticallyImplyTitle,
      currentRoute: route,
    );
    if (middleContent == null) return null;
    return KeyedSubtree(
      key: middleKey,
      child: middleContent,
    );
  }

  final KeyedSubtree? trailing;
  static KeyedSubtree? createTrailing({
    required GlobalKey trailingKey,
    required Widget? userTrailing,
    required EdgeInsetsDirectional? padding,
  }) {
    if (userTrailing == null) return null;
    return KeyedSubtree(
      key: trailingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: padding?.end ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 25.0,
          ),
          child: userTrailing,
        ),
      ),
    );
  }

  final KeyedSubtree? largeTitle;
  static KeyedSubtree? createLargeTitle({
    required GlobalKey largeTitleKey,
    required Widget? userLargeTitle,
    required bool large,
    required bool automaticImplyTitle,
    required ModalRoute<dynamic>? route,
  }) {
    if (!large) return null;
    final Widget? largeTitleContent = userLargeTitle ??
        _derivedTitle(
          automaticallyImplyTitle: automaticImplyTitle,
          currentRoute: route,
        );
    assert(
      largeTitleContent != null,
      'largeTitle was not provided and there was no title from the route.',
    );
    return KeyedSubtree(
      key: largeTitleKey,
      child: largeTitleContent!,
    );
  }
}

class MyCupertinoNavigationBarBackButton extends StatelessWidget {
  const MyCupertinoNavigationBarBackButton({
    super.key,
    this.color,
    this.previousPageTitle,
    this.onPressed,
  })  : _backChevron = null,
        _backLabel = null,
        iconData = null;
  const MyCupertinoNavigationBarBackButton._assemble(
    this._backChevron,
    this._backLabel,
  )   : previousPageTitle = null,
        color = null,
        onPressed = null,
        iconData = null;
  const MyCupertinoNavigationBarBackButton._user(
    this.iconData,
    this.previousPageTitle,
    this.onPressed,
    this.color,
  )   : _backChevron = null,
        _backLabel = null;

  /// The [Color] of the back button.
  ///
  /// Can be used to override the color of the back button chevron and label.
  ///
  /// Defaults to [CupertinoTheme]'s `primaryColor` if null.
  final Color? color;

  final IconData? iconData;

  /// An override for showing the previous route's title. If null, it will be
  /// automatically derived from [CupertinoPageRoute.title] if the current and
  /// previous routes are both [CupertinoPageRoute]s.
  final String? previousPageTitle;

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  ///
  /// It can, for instance, be used to pop the platform's navigation stack
  /// via [SystemNavigator] instead of Flutter's [Navigator] in add-to-app
  /// situations.
  ///
  /// Defaults to null.
  final VoidCallback? onPressed;

  final Widget? _backChevron;

  final Widget? _backLabel;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
    if (onPressed == null) {
      assert(
        currentRoute?.canPop ?? false,
        'CupertinoNavigationBarBackButton should only be used in routes that can be popped',
      );
    }

    TextStyle actionTextStyle = CupertinoTheme.of(context).textTheme.navActionTextStyle;
    if (color != null) actionTextStyle = actionTextStyle.copyWith(color: ColorByBrightness.maybeResolve(color, context));

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Semantics(
        container: true,
        excludeSemantics: true,
        label: 'Back',
        button: true,
        child: DefaultTextStyle(
          style: actionTextStyle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: _kNavBarBackButtonTapWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(padding: EdgeInsetsDirectional.only(start: 4)),
                if (_backChevron != null || iconData != null) ...[
                  _backChevron ?? _BackChevron(color: color, iconData: iconData!),
                  const Padding(padding: EdgeInsetsDirectional.only(start: 4)),
                ],
                Flexible(
                  child: _backLabel ??
                      _BackLabel(
                        specifiedPreviousTitle: previousPageTitle,
                        route: currentRoute,
                        color: color,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      onPressed: () {
        if (onPressed != null)
          onPressed!();
        else
          Navigator.maybePop(context);
      },
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron({
    required this.color,
    this.iconData = CupertinoIcons.back,
  });

  final Color? color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final TextStyle textStyle = DefaultTextStyle.of(context).style;
    Widget iconWidget = Padding(
      padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
      child: Text.rich(
        TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            inherit: false,
            color: color ?? textStyle.color,
            fontSize: 30.0,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
          ),
        ),
      ),
    );
    switch (textDirection) {
      case TextDirection.rtl:
        iconWidget = Transform(
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
          alignment: Alignment.center,
          transformHitTests: false,
          child: iconWidget,
        );
        break;
      case TextDirection.ltr:
        break;
    }

    return iconWidget;
  }
}

class _BackLabel extends StatelessWidget {
  const _BackLabel({
    required this.specifiedPreviousTitle,
    required this.route,
    required this.color,
  });

  final String? specifiedPreviousTitle;
  final ModalRoute<dynamic>? route;
  final Color? color;

  Widget _buildPreviousTitleWidget(BuildContext context, String? previousTitle, Widget? child) {
    if (previousTitle == null) return const SizedBox.shrink();
    Text textWidget = Text(
      previousTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color),
    );
    if (previousTitle.length > 12) textWidget = const Text('Back');
    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1.0,
      child: textWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (specifiedPreviousTitle != null) {
      return _buildPreviousTitleWidget(context, specifiedPreviousTitle, null);
    } else if (route is CupertinoRouteTransitionMixin<dynamic> && !route!.isFirst) {
      final CupertinoRouteTransitionMixin<dynamic> cupertinoRoute = route! as CupertinoRouteTransitionMixin<dynamic>;
      return ValueListenableBuilder<String?>(
        valueListenable: cupertinoRoute.previousTitle,
        builder: _buildPreviousTitleWidget,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _TransitionableNavigationBar extends StatelessWidget {
  _TransitionableNavigationBar({
    required this.componentsKeys,
    required this.backgroundColor,
    required this.backButtonTextStyle,
    required this.titleTextStyle,
    required this.largeTitleTextStyle,
    required this.border,
    required this.hasUserMiddle,
    required this.largeExpanded,
    required this.child,
  })  : assert(!largeExpanded || largeTitleTextStyle != null),
        super(key: componentsKeys.navBarBoxKey);

  final _NavigationBarStaticComponentsKeys componentsKeys;
  final Color? backgroundColor;
  final TextStyle backButtonTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle? largeTitleTextStyle;
  final Border? border;
  final bool hasUserMiddle;
  final bool largeExpanded;
  final Widget child;

  RenderBox get renderBox {
    final RenderBox box = componentsKeys.navBarBoxKey.currentContext!.findRenderObject()! as RenderBox;
    assert(
      box.attached,
      '_TransitionableNavigationBar.renderBox should be called when building '
      'hero flight shuttles when the from and the to nav bar boxes are already '
      'laid out and painted.',
    );
    return box;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      bool inHero = false;
      context.visitAncestorElements((Element ancestor) {
        if (ancestor is ComponentElement) {
          assert(
            ancestor.widget.runtimeType != _NavigationBarTransition,
            '_TransitionableNavigationBar should never re-appear inside '
            '_NavigationBarTransition. Keyed _TransitionableNavigationBar should '
            'only serve as anchor points in routes rather than appearing inside '
            'Hero flights themselves.',
          );
          if (ancestor.widget.runtimeType == Hero) {
            inHero = true;
          }
        }
        return true;
      });
      assert(
        inHero,
        '_TransitionableNavigationBar should only be added as the immediate '
        'child of Hero widgets.',
      );
      return true;
    }());
    return child;
  }
}

class _NavigationBarTransition extends StatelessWidget {
  _NavigationBarTransition({
    required this.animation,
    required this.topNavBar,
    required this.bottomNavBar,
  })  : heightTween = Tween<double>(
          begin: bottomNavBar.renderBox.size.height,
          end: topNavBar.renderBox.size.height,
        ),
        backgroundTween = ColorTween(
          begin: bottomNavBar.backgroundColor,
          end: topNavBar.backgroundColor,
        ),
        borderTween = BorderTween(
          begin: bottomNavBar.border,
          end: topNavBar.border,
        );

  final Animation<double> animation;
  final _TransitionableNavigationBar topNavBar;
  final _TransitionableNavigationBar bottomNavBar;

  final Tween<double> heightTween;
  final ColorTween backgroundTween;
  final BorderTween borderTween;

  @override
  Widget build(BuildContext context) {
    final _NavigationBarComponentsTransition componentsTransition = _NavigationBarComponentsTransition(
      animation: animation,
      bottomNavBar: bottomNavBar,
      topNavBar: topNavBar,
      directionality: Directionality.of(context),
    );

    final List<Widget> children = <Widget>[
      AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return _wrapWithBackground(
            updateSystemUiOverlay: false,
            backgroundColor: backgroundTween.evaluate(animation)!,
            border: borderTween.evaluate(animation),
            child: SizedBox(
              height: heightTween.evaluate(animation),
              width: double.infinity,
            ),
          );
        },
      ),
      if (componentsTransition.bottomBackChevron != null) componentsTransition.bottomBackChevron!,
      if (componentsTransition.bottomBackLabel != null) componentsTransition.bottomBackLabel!,
      if (componentsTransition.bottomLeading != null) componentsTransition.bottomLeading!,
      if (componentsTransition.bottomMiddle != null) componentsTransition.bottomMiddle!,
      if (componentsTransition.bottomLargeTitle != null) componentsTransition.bottomLargeTitle!,
      if (componentsTransition.bottomTrailing != null) componentsTransition.bottomTrailing!,
      if (componentsTransition.topLeading != null) componentsTransition.topLeading!,
      if (componentsTransition.topBackChevron != null) componentsTransition.topBackChevron!,
      if (componentsTransition.topBackLabel != null) componentsTransition.topBackLabel!,
      if (componentsTransition.topMiddle != null) componentsTransition.topMiddle!,
      if (componentsTransition.topLargeTitle != null) componentsTransition.topLargeTitle!,
      if (componentsTransition.topTrailing != null) componentsTransition.topTrailing!,
    ];

    return SizedBox(
      height: math.max(heightTween.begin!, heightTween.end!) + MediaQuery.paddingOf(context).top,
      width: double.infinity,
      child: Stack(
        children: children,
      ),
    );
  }
}

@immutable
class _NavigationBarComponentsTransition {
  _NavigationBarComponentsTransition({
    required this.animation,
    required _TransitionableNavigationBar bottomNavBar,
    required _TransitionableNavigationBar topNavBar,
    required TextDirection directionality,
  })  : bottomComponents = bottomNavBar.componentsKeys,
        topComponents = topNavBar.componentsKeys,
        bottomNavBarBox = bottomNavBar.renderBox,
        topNavBarBox = topNavBar.renderBox,
        bottomBackButtonTextStyle = bottomNavBar.backButtonTextStyle,
        topBackButtonTextStyle = topNavBar.backButtonTextStyle,
        bottomTitleTextStyle = bottomNavBar.titleTextStyle,
        topTitleTextStyle = topNavBar.titleTextStyle,
        bottomLargeTitleTextStyle = bottomNavBar.largeTitleTextStyle,
        topLargeTitleTextStyle = topNavBar.largeTitleTextStyle,
        bottomHasUserMiddle = bottomNavBar.hasUserMiddle,
        topHasUserMiddle = topNavBar.hasUserMiddle,
        bottomLargeExpanded = bottomNavBar.largeExpanded,
        topLargeExpanded = topNavBar.largeExpanded,
        transitionBox = bottomNavBar.renderBox.paintBounds.expandToInclude(topNavBar.renderBox.paintBounds),
        forwardDirection = directionality == TextDirection.ltr ? 1.0 : -1.0;

  static final Animatable<double> fadeOut = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );
  static final Animatable<double> fadeIn = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  final Animation<double> animation;
  final _NavigationBarStaticComponentsKeys bottomComponents;
  final _NavigationBarStaticComponentsKeys topComponents;

  final RenderBox bottomNavBarBox;
  final RenderBox topNavBarBox;

  final TextStyle bottomBackButtonTextStyle;
  final TextStyle topBackButtonTextStyle;
  final TextStyle bottomTitleTextStyle;
  final TextStyle topTitleTextStyle;
  final TextStyle? bottomLargeTitleTextStyle;
  final TextStyle? topLargeTitleTextStyle;

  final bool bottomHasUserMiddle;
  final bool topHasUserMiddle;
  final bool bottomLargeExpanded;
  final bool topLargeExpanded;
  final Rect transitionBox;
  final double forwardDirection;
  RelativeRect positionInTransitionBox(
    GlobalKey key, {
    required RenderBox from,
  }) {
    final RenderBox componentBox = key.currentContext!.findRenderObject()! as RenderBox;
    assert(componentBox.attached);

    return RelativeRect.fromRect(
      componentBox.localToGlobal(Offset.zero, ancestor: from) & componentBox.size,
      transitionBox,
    );
  }

  _FixedSizeSlidingTransition slideFromLeadingEdge({
    required GlobalKey fromKey,
    required RenderBox fromNavBarBox,
    required GlobalKey toKey,
    required RenderBox toNavBarBox,
    required Widget child,
  }) {
    final RenderBox fromBox = fromKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox toBox = toKey.currentContext!.findRenderObject()! as RenderBox;

    final bool isLTR = forwardDirection > 0;

    final Offset fromAnchorLocal = Offset(
      isLTR ? 0 : fromBox.size.width,
      fromBox.size.height / 2,
    );
    final Offset toAnchorLocal = Offset(
      isLTR ? 0 : toBox.size.width,
      toBox.size.height / 2,
    );
    final Offset fromAnchorInFromBox = fromBox.localToGlobal(fromAnchorLocal, ancestor: fromNavBarBox);
    final Offset toAnchorInToBox = toBox.localToGlobal(toAnchorLocal, ancestor: toNavBarBox);

    final Offset translation = isLTR
        ? toAnchorInToBox - fromAnchorInFromBox
        : Offset(toNavBarBox.size.width - toAnchorInToBox.dx, toAnchorInToBox.dy) - Offset(fromNavBarBox.size.width - fromAnchorInFromBox.dx, fromAnchorInFromBox.dy);

    final RelativeRect fromBoxMargin = positionInTransitionBox(fromKey, from: fromNavBarBox);
    final Offset fromOriginInTransitionBox = Offset(
      isLTR ? fromBoxMargin.left : fromBoxMargin.right,
      fromBoxMargin.top,
    );

    final Tween<Offset> anchorMovementInTransitionBox = Tween<Offset>(
      begin: fromOriginInTransitionBox,
      end: fromOriginInTransitionBox + translation,
    );

    return _FixedSizeSlidingTransition(
      isLTR: isLTR,
      offsetAnimation: animation.drive(anchorMovementInTransitionBox),
      size: fromBox.size,
      child: child,
    );
  }

  Animation<double> fadeInFrom(double t, {Curve curve = Curves.easeIn}) {
    return animation.drive(fadeIn.chain(
      CurveTween(curve: Interval(t, 1.0, curve: curve)),
    ));
  }

  Animation<double> fadeOutBy(double t, {Curve curve = Curves.easeOut}) {
    return animation.drive(fadeOut.chain(
      CurveTween(curve: Interval(0.0, t, curve: curve)),
    ));
  }

  Widget? get bottomLeading {
    final KeyedSubtree? bottomLeading = bottomComponents.leadingKey.currentWidget as KeyedSubtree?;

    if (bottomLeading == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.leadingKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.4),
        child: bottomLeading.child,
      ),
    );
  }

  Widget? get bottomBackChevron {
    final KeyedSubtree? bottomBackChevron = bottomComponents.backChevronKey.currentWidget as KeyedSubtree?;

    if (bottomBackChevron == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.backChevronKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: DefaultTextStyle(
          style: bottomBackButtonTextStyle,
          child: bottomBackChevron.child,
        ),
      ),
    );
  }

  Widget? get bottomBackLabel {
    final KeyedSubtree? bottomBackLabel = bottomComponents.backLabelKey.currentWidget as KeyedSubtree?;

    if (bottomBackLabel == null) return null;

    final RelativeRect from = positionInTransitionBox(bottomComponents.backLabelKey, from: bottomNavBarBox);

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: from.shift(
        Offset(
          forwardDirection * (-bottomNavBarBox.size.width / 2.0),
          0.0,
        ),
      ),
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeOutBy(0.2),
        child: DefaultTextStyle(
          style: bottomBackButtonTextStyle,
          child: bottomBackLabel.child,
        ),
      ),
    );
  }

  Widget? get bottomMiddle {
    final KeyedSubtree? bottomMiddle = bottomComponents.middleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topBackLabel = topComponents.backLabelKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topLeading = topComponents.leadingKey.currentWidget as KeyedSubtree?;
    if (!bottomHasUserMiddle && bottomLargeExpanded) return null;
    if (bottomMiddle != null && topBackLabel != null) {
      return slideFromLeadingEdge(
        fromKey: bottomComponents.middleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyleTransition(
              style: animation.drive(TextStyleTween(
                begin: bottomTitleTextStyle,
                end: topBackButtonTextStyle,
              )),
              child: bottomMiddle.child,
            ),
          ),
        ),
      );
    }
    if (bottomMiddle != null && topLeading != null) {
      return Positioned.fromRelativeRect(
        rect: positionInTransitionBox(bottomComponents.middleKey, from: bottomNavBarBox),
        child: FadeTransition(
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          child: DefaultTextStyle(
            style: bottomTitleTextStyle,
            child: bottomMiddle.child,
          ),
        ),
      );
    }
    return null;
  }

  Widget? get bottomLargeTitle {
    final KeyedSubtree? bottomLargeTitle = bottomComponents.largeTitleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topBackLabel = topComponents.backLabelKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topLeading = topComponents.leadingKey.currentWidget as KeyedSubtree?;

    if (bottomLargeTitle == null || !bottomLargeExpanded) return null;

    if (topBackLabel != null) {
      return slideFromLeadingEdge(
        fromKey: bottomComponents.largeTitleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          opacity: fadeOutBy(0.6),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyleTransition(
              style: animation.drive(TextStyleTween(
                begin: bottomLargeTitleTextStyle,
                end: topBackButtonTextStyle,
              )),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: bottomLargeTitle.child,
            ),
          ),
        ),
      );
    }

    if (topLeading != null) {
      final RelativeRect from = positionInTransitionBox(bottomComponents.largeTitleKey, from: bottomNavBarBox);
      final RelativeRectTween positionTween = RelativeRectTween(
        begin: from,
        end: from.shift(
          Offset(
            forwardDirection * bottomNavBarBox.size.width / 4.0,
            0.0,
          ),
        ),
      );
      return PositionedTransition(
        rect: animation.drive(positionTween),
        child: FadeTransition(
          opacity: fadeOutBy(0.4),
          child: DefaultTextStyle(
            style: bottomLargeTitleTextStyle!,
            child: bottomLargeTitle.child,
          ),
        ),
      );
    }
    return null;
  }

  Widget? get bottomTrailing {
    final KeyedSubtree? bottomTrailing = bottomComponents.trailingKey.currentWidget as KeyedSubtree?;
    if (bottomTrailing == null) return null;
    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.trailingKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: bottomTrailing.child,
      ),
    );
  }

  Widget? get topLeading {
    final KeyedSubtree? topLeading = topComponents.leadingKey.currentWidget as KeyedSubtree?;
    if (topLeading == null) return null;
    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(topComponents.leadingKey, from: topNavBarBox),
      child: FadeTransition(
        opacity: fadeInFrom(0.6),
        child: topLeading.child,
      ),
    );
  }

  Widget? get topBackChevron {
    final KeyedSubtree? topBackChevron = topComponents.backChevronKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? bottomBackChevron = bottomComponents.backChevronKey.currentWidget as KeyedSubtree?;
    if (topBackChevron == null) return null;
    final RelativeRect to = positionInTransitionBox(topComponents.backChevronKey, from: topNavBarBox);
    RelativeRect from = to;

    if (bottomBackChevron == null) {
      final RenderBox topBackChevronBox = topComponents.backChevronKey.currentContext!.findRenderObject()! as RenderBox;
      from = to.shift(
        Offset(
          forwardDirection * topBackChevronBox.size.width * 2.0,
          0.0,
        ),
      );
    }

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(bottomBackChevron == null ? 0.7 : 0.4),
        child: DefaultTextStyle(
          style: topBackButtonTextStyle,
          child: topBackChevron.child,
        ),
      ),
    );
  }

  Widget? get topBackLabel {
    final KeyedSubtree? bottomMiddle = bottomComponents.middleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? bottomLargeTitle = bottomComponents.largeTitleKey.currentWidget as KeyedSubtree?;
    final KeyedSubtree? topBackLabel = topComponents.backLabelKey.currentWidget as KeyedSubtree?;
    if (topBackLabel == null) return null;
    final RenderAnimatedOpacity? topBackLabelOpacity = topComponents.backLabelKey.currentContext?.findAncestorRenderObjectOfType<RenderAnimatedOpacity>();
    Animation<double>? midClickOpacity;
    if (topBackLabelOpacity != null && topBackLabelOpacity.opacity.value < 1.0) {
      midClickOpacity = animation.drive(Tween<double>(
        begin: 0.0,
        end: topBackLabelOpacity.opacity.value,
      ));
    }

    if (bottomLargeTitle != null && bottomLargeExpanded) {
      return slideFromLeadingEdge(
        fromKey: bottomComponents.largeTitleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.4),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomLargeTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: topBackLabel.child,
          ),
        ),
      );
    }

    if (bottomMiddle != null) {
      return slideFromLeadingEdge(
        fromKey: bottomComponents.middleKey,
        fromNavBarBox: bottomNavBarBox,
        toKey: topComponents.backLabelKey,
        toNavBarBox: topNavBarBox,
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.3),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            child: topBackLabel.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget? get topMiddle {
    final KeyedSubtree? topMiddle = topComponents.middleKey.currentWidget as KeyedSubtree?;
    if (topMiddle == null) return null;
    if (!topHasUserMiddle && topLargeExpanded) return null;
    final RelativeRect to = positionInTransitionBox(topComponents.middleKey, from: topNavBarBox);
    final RenderBox toBox = topComponents.middleKey.currentContext!.findRenderObject()! as RenderBox;

    final bool isLTR = forwardDirection > 0;

    final Offset toAnchorInTransitionBox = Offset(
      isLTR ? to.left : to.right,
      to.top,
    );

    final Tween<Offset> anchorMovementInTransitionBox = Tween<Offset>(
      begin: Offset(
        topNavBarBox.size.width - toBox.size.width / 2,
        to.top,
      ),
      end: toAnchorInTransitionBox,
    );

    return _FixedSizeSlidingTransition(
      isLTR: isLTR,
      offsetAnimation: animation.drive(anchorMovementInTransitionBox),
      size: toBox.size,
      child: FadeTransition(
        opacity: fadeInFrom(0.25),
        child: DefaultTextStyle(
          style: topTitleTextStyle,
          child: topMiddle.child,
        ),
      ),
    );
  }

  Widget? get topTrailing {
    final KeyedSubtree? topTrailing = topComponents.trailingKey.currentWidget as KeyedSubtree?;
    if (topTrailing == null) return null;
    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(topComponents.trailingKey, from: topNavBarBox),
      child: FadeTransition(
        opacity: fadeInFrom(0.4),
        child: topTrailing.child,
      ),
    );
  }

  Widget? get topLargeTitle {
    final KeyedSubtree? topLargeTitle = topComponents.largeTitleKey.currentWidget as KeyedSubtree?;
    if (topLargeTitle == null || !topLargeExpanded) return null;
    final RelativeRect to = positionInTransitionBox(topComponents.largeTitleKey, from: topNavBarBox);
    final RelativeRectTween positionTween = RelativeRectTween(
      begin: to.shift(
        Offset(
          forwardDirection * topNavBarBox.size.width,
          0.0,
        ),
      ),
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(0.3),
        child: DefaultTextStyle(
          style: topLargeTitleTextStyle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: topLargeTitle.child,
        ),
      ),
    );
  }
}

RectTween _linearTranslateWithLargestRectSizeTween(Rect? begin, Rect? end) {
  final Size largestSize = Size(
    math.max(begin!.size.width, end!.size.width),
    math.max(begin.size.height, end.size.height),
  );
  return RectTween(
    begin: begin.topLeft & largestSize,
    end: end.topLeft & largestSize,
  );
}

Widget _navBarHeroLaunchPadBuilder(
  BuildContext context,
  Size heroSize,
  Widget child,
) {
  assert(child is _TransitionableNavigationBar);
  return Visibility(
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: false,
    child: child,
  );
}

Widget _navBarHeroFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  assert(fromHeroContext.widget is Hero);
  assert(toHeroContext.widget is Hero);

  final Hero fromHeroWidget = fromHeroContext.widget as Hero;
  final Hero toHeroWidget = toHeroContext.widget as Hero;

  assert(fromHeroWidget.child is _TransitionableNavigationBar);
  assert(toHeroWidget.child is _TransitionableNavigationBar);

  final _TransitionableNavigationBar fromNavBar = fromHeroWidget.child as _TransitionableNavigationBar;
  final _TransitionableNavigationBar toNavBar = toHeroWidget.child as _TransitionableNavigationBar;

  assert(
    fromNavBar.componentsKeys.navBarBoxKey.currentContext!.owner != null,
    'The from nav bar to Hero must have been mounted in the previous frame',
  );
  assert(
    toNavBar.componentsKeys.navBarBoxKey.currentContext!.owner != null,
    'The to nav bar to Hero must have been mounted in the previous frame',
  );

  switch (flightDirection) {
    case HeroFlightDirection.push:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: fromNavBar,
        topNavBar: toNavBar,
      );
    case HeroFlightDirection.pop:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: toNavBar,
        topNavBar: fromNavBar,
      );
  }
}
