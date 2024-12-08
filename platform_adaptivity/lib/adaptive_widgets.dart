/// General platform adaptive widgets
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Returns true if the platform is iOS or macOS, returns false otherwise.
bool get isCupertino {
  //if (kIsWeb) return false;
  // in the case of a web app, [defaultTargetPlatform] returns the platform the application's browser is running in
  switch (designPlatform) {
    case CitecPlatform.material:
    case CitecPlatform.yaru:
    case CitecPlatform.fluent:
      return false;
    case CitecPlatform.ios:
    case CitecPlatform.macos:
      return true;
  }
}

CitecPlatform designPlatform = switch (defaultTargetPlatform) {
  TargetPlatform.android => CitecPlatform.material,
  TargetPlatform.fuchsia => CitecPlatform.material,
  TargetPlatform.linux => CitecPlatform.yaru,
  TargetPlatform.windows => CitecPlatform.fluent,
  TargetPlatform.iOS => CitecPlatform.ios,
  TargetPlatform.macOS => CitecPlatform.macos,
};

enum CitecPlatform {
  /// Google defines Material design guidelines for Android devices
  ///
  /// [Material 3 Design](https://m3.material.io)
  material,

  /// Apple defines design guidelines for iOS and iPadOS
  ///
  /// [Apple HIG - Designing for iOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-ios)\
  /// [Apple HIG - Designing for iPadOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados)
  ios,

  /// Microsoft defines Fluent design guidelines for Windows
  ///
  /// [Fluent 2 UI for Windows](https://fluent2.microsoft.design/components/windows)
  fluent,

  /// Apple defines design guidelines for macOS
  ///
  /// [Apple HIG - Designing for macOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-macos)
  macos,

  /// Yaru is the default theme for Ubuntu
  ///
  /// [Yaru](https://github.com/ubuntu/yaru)
  yaru
}

/// This relies on calling `WidgetsFlutterBinding.ensureInitialized()` in `main()`
bool get isPhone {
  final double physicalShortestSide = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.shortestSide;
  final double devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  final double shortestSize = physicalShortestSide / devicePixelRatio;
  return shortestSize < 600;
}

void onTapHaptic<T>(void Function(T)? fct, T value) {
  if (fct == null) return;
  switch (designPlatform) {
    case CitecPlatform.ios:
    case CitecPlatform.material:
      HapticFeedback.mediumImpact();
    case CitecPlatform.yaru:
    case CitecPlatform.macos:
    case CitecPlatform.fluent:
      break;
  }
  return fct(value);
}

void Function()? onTapHapticFeedback(void Function()? fct) {
  if (fct == null) return null;
  switch (designPlatform) {
    case CitecPlatform.ios:
    case CitecPlatform.material:
      HapticFeedback.mediumImpact();
    case CitecPlatform.yaru:
    case CitecPlatform.macos:
    case CitecPlatform.fluent:
      break;
  }
  return fct;
}

class BiLayoutBuilder extends StatelessWidget {
  const BiLayoutBuilder({
    super.key,
    required this.phone,
    required this.tablet,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints) phone;
  final Widget Function(BuildContext context, BoxConstraints constraints) tablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600)
          return phone(context, constraints);
        else
          return tablet(context, constraints);
      },
    );
  }
}

/// This widget detects the platform the app is running on and returns a widget accordingly.
///
/// If widget is not provided for some platforms, a default widget is returned.
///
/// Returns [android] on Android, returns [ios] on iOS, returns [web] on the web, returns [windows] on Windows, returns [macos] on macOS, returns [linux] on Linux,
/// returns [fuchsia] on Google Fuchsia.
class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({super.key, this.android, this.ios, this.web, this.windows, this.macos, this.linux});
  final Widget? android;
  final Widget? ios;
  final Widget? web;
  final Widget? windows;
  final Widget? macos;
  final Widget? linux;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return web ?? notImplementedPlatform(context);
    switch (designPlatform) {
      case CitecPlatform.material:
        return android ?? notImplementedPlatform(context);
      case CitecPlatform.yaru:
        return linux ?? notImplementedPlatform(context);
      case CitecPlatform.fluent:
        return windows ?? notImplementedPlatform(context);
      case CitecPlatform.ios:
        return ios ?? notImplementedPlatform(context);
      case CitecPlatform.macos:
        return macos ?? notImplementedPlatform(context);
    }
  }

  Widget notImplementedPlatform(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              FittedBox(
                child: Image.asset(Theme.of(context).brightness == Brightness.light ? 'assets/images/broken_robot_light.png' : 'assets/images/broken_robot_dark.png'),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text('This widget is not provided by the developer for this platform'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
