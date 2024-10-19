import 'package:platform_adaptivity/adaptive_icons.dart';
import 'package:flutter/material.dart';

enum DownloadState { none, inProgress, success, failed }

class DynamicButton extends StatefulWidget {
  const DynamicButton({
    super.key,
    required this.child,
    this.iconColor,
    this.successChild,
    this.failedChild,
    this.inProgressChild,
    this.errorChild,
  });

  final Widget Function(void Function(Future<bool>) wrapper) child;

  final Widget? successChild;
  final Widget? failedChild;
  final Widget? inProgressChild;
  final Widget? errorChild;
  final Color? iconColor;

  @override
  State<DynamicButton> createState() => _DynamicButtonState();
}

class _DynamicButtonState extends State<DynamicButton> {
  DownloadState _state = DownloadState.none;

  @override
  Widget build(BuildContext context) {
    if (_state == DownloadState.none || _state == DownloadState.success)
      return AnimatedCrossFade(
        firstChild: widget.successChild ??
            Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                AdaptiveIcons.thumbsup,
                color: widget.iconColor ?? Theme.of(context).cardColor,
              ),
            ),
        secondChild: widget.child(
          (doThis) async {
            if (mounted) setState(() => _state = DownloadState.inProgress);
            if (await doThis) {
              if (mounted) setState(() => _state = DownloadState.success);
              await Future.delayed(const Duration(milliseconds: 1500));
              if (mounted) setState(() => _state = DownloadState.none);
            } else {
              if (mounted) setState(() => _state = DownloadState.failed);
              await Future.delayed(const Duration(milliseconds: 1500));
              if (mounted) setState(() => _state = DownloadState.none);
            }
          },
        ),
        crossFadeState: _state == DownloadState.success ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 700),
      );
    if (_state == DownloadState.inProgress)
      return widget.inProgressChild ??
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: 20, // activity_indicator.dart > _kDefaultIndicatorRadius (`CupertinoActivityIndicator`)
              height: 20,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: widget.iconColor,
                valueColor: widget.iconColor != null ? AlwaysStoppedAnimation<Color>(widget.iconColor!) : null,
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
              ),
            ),
          );
    if (_state == DownloadState.failed)
      return widget.failedChild ??
          Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              AdaptiveIcons.xmark_circle,
              color: widget.iconColor ?? Theme.of(context).colorScheme.error,
            ),
          );
    return widget.errorChild ??
        Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            AdaptiveIcons.question,
            color: widget.iconColor ?? Theme.of(context).cardColor,
          ),
        );
  }
}

class DynamicFloatingActionButton extends StatefulWidget {
  const DynamicFloatingActionButton.extended({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  final void Function(void Function(Future<bool>) wrapper) onPressed;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  State<DynamicFloatingActionButton> createState() => _DynamicDynamicFloatingActionButtonState();
}

class _DynamicDynamicFloatingActionButtonState extends State<DynamicFloatingActionButton> {
  DownloadState _state = DownloadState.none;

  @override
  Widget build(BuildContext context) {
    if (_state == DownloadState.none || _state == DownloadState.success)
      return _buildFAB(
        onPressed: _state == DownloadState.none
            ? () => widget.onPressed(
                  (doThis) async {
                    if (mounted) setState(() => _state = DownloadState.inProgress);
                    if (await doThis) {
                      if (mounted) setState(() => _state = DownloadState.success);
                      await Future.delayed(const Duration(milliseconds: 1500));
                      if (mounted) setState(() => _state = DownloadState.none);
                    } else {
                      if (mounted) setState(() => _state = DownloadState.failed);
                      await Future.delayed(const Duration(milliseconds: 1500));
                      if (mounted) setState(() => _state = DownloadState.none);
                    }
                  },
                )
            : null,
        child: AnimatedCrossFade(
          firstChild: Icon(
            AdaptiveIcons.thumbsup,
            color: widget.iconColor ?? Theme.of(context).cardColor,
          ),
          secondChild: Icon(
            widget.icon,
            color: widget.iconColor,
          ),
          crossFadeState: _state == DownloadState.success ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 700),
        ),
        backgroundColor: widget.backgroundColor,
      );
    if (_state == DownloadState.inProgress)
      return _buildFAB(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SizedBox(
            width: 20, // activity_indicator.dart > _kDefaultIndicatorRadius (`CupertinoActivityIndicator`)
            height: 20,
            child: CircularProgressIndicator.adaptive(
              backgroundColor: widget.iconColor,
              valueColor: widget.iconColor != null ? AlwaysStoppedAnimation<Color>(widget.iconColor!) : null,
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      );
    if (_state == DownloadState.failed)
      return _buildFAB(
        icon: AdaptiveIcons.xmark,
        iconColor: widget.iconColor ?? Theme.of(context).colorScheme.error,
        backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.2),
      );
    return _buildFAB(
      icon: AdaptiveIcons.question,
      iconColor: widget.iconColor,
    );
  }

  Widget _buildFAB({
    IconData? icon,
    Color? iconColor,
    Widget? child,
    Color? backgroundColor,
    void Function()? onPressed,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: child ??
          Icon(
            icon,
            color: iconColor,
          ),
      backgroundColor: backgroundColor ?? widget.backgroundColor,
      elevation: 0,
    );
  }
}
