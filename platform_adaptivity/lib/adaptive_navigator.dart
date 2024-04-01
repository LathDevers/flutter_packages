import 'package:flutter/material.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

/// A widget that manages a set of child widgets with a stack discipline.
///
/// ## Using the Pages API
///
/// By Default, the [AdaptiveNavigator] will use either [CupertinoPageRoute] or
/// [MaterialPageRoute] to transition routes in or out of the screen.
///
/// To push a new route on the stack provide a builder function that creates whatever you
/// want to appear on the screen. For example:
///
/// ```dart
/// AdaptiveNavigator.push(
///   context,
///   builder: (BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: const Text('My Page')),
///       body: Center(
///         child: TextButton(
///           child: const Text('POP'),
///           onPressed: () {
///             Navigator.of(context).pop();
///           },
///         ),
///       ),
///     );
///   },
/// );
/// ```
///
/// As you can see, the new route can be popped, revealing the app's home
/// page, with the Navigator's pop method:
///
/// ```dart
/// Navigator.of(context).pop();
/// ```
///
/// It usually isn't necessary to provide a widget that pops the Navigator
/// in a route with a [Scaffold] because the Scaffold automatically adds a
/// 'back' button to its AppBar. Pressing the back button causes
/// [Navigator.pop] to be called. On Android, pressing the system back
/// button does the same thing.
///
/// ### Using named navigator routes
///
/// Mobile apps often manage a large number of routes and it's often
/// easiest to refer to them by name. Route names, by convention,
/// use a path-like structure (for example, '/a/b/c').
/// The app's home page route is named '/' by default.
///
/// The [MaterialApp] can be created
/// with a [NamedRoutes.allRoutes] which maps from a route's name to
/// a builder function that will create it.
///
/// To show a route by name:
///
/// ```dart
/// AdaptiveNavigator.pushNamed(context, NamedRoutes.gallery);
/// ```
class AdaptiveNavigator {
  /// Push the given route onto the navigator that most tightly encloses the
  /// given context.
  ///
  /// {@template flutter.widgets.navigator.push}
  /// The new route and the previous route (if any) are notified (see
  /// [Route.didPush] and [Route.didChangeNext]). If the [Navigator] has any
  /// [Navigator.observers], they will be notified as well (see
  /// [NavigatorObserver.didPush]).
  ///
  /// Ongoing gestures within the current route are canceled when a new route is
  /// pushed.
  ///
  /// The `T` type argument is the type of the return value of the route.
  /// {@endtemplate}
  ///
  /// {@macro flutter.widgets.navigator.pushNamed.returnValue}
  ///
  /// {@tool snippet}
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _openMyPage() {
  ///   AdaptiveNavigator.push<void>(
  ///     context,
  ///     builder: (BuildContext context) => const MyPage(),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [restorablePush], which pushes a route that can be restored during
  ///    state restoration.
  static Future<T?> push<T extends Object?>(
    BuildContext context, {
    /// A title string for this route.
    ///
    /// Used to auto-populate [CupertinoNavigationBar] and
    /// [CupertinoSliverNavigationBar]'s `middle`/`largeTitle` widgets when
    /// one is not manually supplied.
    String? title,

    /// Whether this page route is a full-screen dialog.
    ///
    /// In Material and Cupertino, being fullscreen has the effects of making
    /// the app bars have a close button instead of a back button. On
    /// iOS, dialogs transitions animate differently and are also not closeable
    /// with the back swipe gesture.
    bool fullscreenDialog = false,

    /// Builds the primary contents of the route.
    required Widget Function(BuildContext) builder,
  }) {
    return Navigator.push(
      context,
      switch (designPlatform) {
        CitecPlatform.material => MaterialPageRoute(
            fullscreenDialog: fullscreenDialog,
            builder: builder,
          ),
        CitecPlatform.ios => CupertinoPageRoute(
            title: title,
            fullscreenDialog: fullscreenDialog,
            builder: builder,
          ),
        CitecPlatform.fluent => fluent.FluentPageRoute(
            barrierLabel: title,
            fullscreenDialog: fullscreenDialog,
            builder: builder,
          ),
        _ => throw UnimplementedError(),
      },
    );
  }

  /// Push a named route onto the navigator that most tightly encloses the given
  /// context.
  ///
  /// {@tool snippet}
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _didPushButton() {
  ///   AdaptiveNavigator.pushNamed(context, NamedRoutes.plotter);
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// {@tool snippet}
  ///
  /// The following example shows how to pass additional `arguments` to the
  /// route:
  ///
  /// ```dart
  /// void _showBerlinWeather() {
  ///   Navigator.pushNamed(
  ///     context,
  ///     NamedRoutes.plotter,
  ///     arguments: <String, String>{
  ///       'city': 'Berlin',
  ///       'country': 'Germany',
  ///     },
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    NamedRouteData newRoute, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context, newRoute.name, arguments: arguments);
  }

  /// Push the given route onto the navigator that most tightly encloses the
  /// given context, and then remove all the previous routes.
  ///
  /// {@tool snippet}
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _finishAccountCreation() {
  ///   Navigator.pushAndRemoveUntil<void>(
  ///     context,
  ///     builder: (BuildContext context) => const MyHomePage()
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  static Future<T?> pushAndRemoveAll<T extends Object?>(
    BuildContext context, {
    String? title,
    required Widget Function(BuildContext) builder,
  }) {
    return Navigator.pushAndRemoveUntil(
      context,
      switch (designPlatform) {
        CitecPlatform.material => PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, animationTime, child) {
              animation = CurvedAnimation(parent: animation, curve: Curves.ease);
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, animationTime) => builder(context),
          ),
        CitecPlatform.ios => CupertinoPageRoute(
            title: title,
            builder: builder,
          ),
        CitecPlatform.fluent => fluent.FluentPageRoute(
            barrierLabel: title,
            builder: builder,
          ),
        _ => throw UnimplementedError(),
      },
      (route) => false,
    );
  }

  /// Push the route with the given name onto the navigator that most tightly
  /// encloses the given context, and then remove all the previous routes.
  ///
  /// The removed routes are removed without being completed, so this method
  /// does not take a return value argument.
  ///
  /// The `T` type argument is the type of the return value of the new route.
  static Future<T?> pushNamedAndRemoveAll<T extends Object?>(
    BuildContext context,
    NamedRouteData newRoute, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      newRoute.name,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    return Navigator.pop(context, result);
  }

  /// Calls [pop] repeatedly on the navigator that most tightly encloses the
  /// given context until [newRoute].
  ///
  /// {@tool snippet}
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _logout() {
  ///   AdaptiveNavigator.popUntil(context, NamedRoutes.login));
  /// }
  /// ```
  /// {@end-tool}
  static void popUntilNamed(
    BuildContext context,
    NamedRouteData newRoute,
  ) {
    return Navigator.popUntil(
      context,
      ModalRoute.withName(newRoute.name),
    );
  }
}

@immutable
class NamedRouteData {
  /// ```dart
  /// abstract final class NamedRoutes {
  ///   static NamedRouteData gallery = NamedRouteData(name: '/gallery', builder: (context) => const Gallery());
  ///   static NamedRouteData plotter = NamedRouteData(name: '/plotter', builder: (context) => const Plot());
  ///   static NamedRouteData sonic = NamedRouteData(name: '/sonic', builder: (context) => const SonicCoach());
  ///   static NamedRouteData survey = NamedRouteData(name: '/survey', builder: (context) => const SurveyToolPage());
  ///   static NamedRouteData manual = NamedRouteData(name: '/manual', builder: (context) => const ManualPdfViewer());
  ///
  ///   static Map<String, WidgetBuilder> get allRoutes => {
  ///     gallery.name: gallery.builder,
  ///     plotter.name: plotter.builder,
  ///     sonic.name: sonic.builder,
  ///     survey.name: survey.builder,
  ///     manual.name: manual.builder,
  ///   };
  /// }
  /// ```
  /// Don't forget to add routes to allRoutes
  const NamedRouteData({
    required this.name,
    required this.builder,
  });

  final String name;
  final WidgetBuilder builder;
}
