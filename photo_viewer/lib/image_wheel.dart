import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The duration of the tap-to-scroll gesture's animation when a picker item is tapped.
///
/// Eyeballed from an iPhone 15 Pro simulator running iOS 17.5.
const Duration _kCupertinoPickerTapToScrollDuration = Duration(milliseconds: 300);

/// The curve of the tap-to-scroll gesture's animation when a picker item is tapped.
///
/// Eyeballed from an iPhone 15 Pro simulator running iOS 17.5.
const Curve _kCupertinoPickerTapToScrollCurve = Curves.easeInOut;

List<double> _calculateItemExtents(List<int> children) {
  return children
      .map((s) {
        final List<double> result = List.generate(s, (i) => 21.21 + 2 * 1.5)
          ..first += 7.5
          ..last += 7.5;
        return result;
      })
      .expand((e) => e)
      .toList();
}

int _offsetToIndex(double offset, List<double> itemExtents) {
  if (offset < 0) return 0;
  for (int i = 0; i < itemExtents.length; i++) {
    offset -= itemExtents[i];
    if (offset < 0) return i;
  }
  return itemExtents.length - 1;
}

double _indexToOffset(int index, List<double> itemExtents) {
  assert(index >= 0 && index < itemExtents.length);
  if (itemExtents.sublist(0, index).isEmpty) return 15;
  return itemExtents.sublist(0, index).reduce((a, b) => a + b) + 15;
}

extension _ScrollMetricsExtensions on ScrollMetrics {
  int get item => _offsetToIndex(pixels, _calculateItemExtents());
}

class ImageWheelScrollController extends ScrollController {
  ImageWheelScrollController({
    int initialItem = 0,
    List<int> images = const [],
  })  : itemExtents = _calculateItemExtents(images),
        super(initialScrollOffset: _indexToOffset(initialItem, _calculateItemExtents(images)));

  final List<double> itemExtents;

  /// Defaults to 0.
  int get initialItem => _offsetToIndex(initialScrollOffset, itemExtents);

  Future<void> animateToItem(int index, {required Duration duration, required Curve curve}) => animateTo(_indexToOffset(index, itemExtents), duration: duration, curve: curve);
}

/// An iOS-styled picker.
///
/// Displays its children widgets on a wheel for selection and
/// calls back when the currently selected item changes.
///
/// By default, the first child in `children` will be the initially selected child.
/// The index of a different child can be specified in [controller], to make
/// that child the initially selected child.
///
/// Can be used with [showCupertinoModalPopup] to display the picker modally at the
/// bottom of the screen. When calling [showCupertinoModalPopup], be sure to set
/// `semanticsDismissible` to true to enable dismissing the modal via semantics.
///
/// By default, descendent texts are shown with [CupertinoTextThemeData.pickerTextStyle].
///
/// {@tool dartpad}
/// This example shows a [ImageWheel] that displays a list of fruits on a wheel for
/// selection.
///
/// ** See code in examples/api/lib/cupertino/picker/cupertino_picker.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ListWheelScrollView], the generic widget backing this picker without
///    the iOS design specific chrome.
///  * <https://developer.apple.com/design/human-interface-guidelines/pickers/>
class ImageWheel extends StatefulWidget {
  /// Creates a picker from an [IndexedWidgetBuilder] callback where the builder
  /// is dynamically invoked during layout.
  ///
  /// A child is lazily created when it starts becoming visible in the viewport.
  /// All of the children provided by the builder are cached and reused, so
  /// normally the builder is only called once for each index (except when
  /// rebuilding - the cache is cleared).
  ///
  /// The [backgroundColor] defaults to null, which disables background painting entirely.
  /// (i.e. the picker is going to have a completely transparent background), to match
  /// the native UIPicker and UIDatePicker.
  ImageWheel({super.key, this.backgroundColor, this.controller, required this.onSelectedItemChanged, required this.children})
      : itemWidths = List.generate(children.length, (i) {
          final List<double> result = List.generate(children[i].length, (_) => 21.21 + 2 * 1.5)
            ..first += 7.5
            ..last += 7.5;
          return result;
        }).expand((e) => e).toList();

  /// Background color behind the children.
  ///
  /// Defaults to null, which disables background painting entirely.
  /// (i.e. the picker is going to have a completely transparent background), to match
  /// the native UIPicker and UIDatePicker.
  ///
  /// Any alpha value less 255 (fully opaque) will cause the removal of the
  /// wheel list edge fade gradient from rendering of the widget.
  final Color? backgroundColor;

  /// A [ImageWheelScrollController] to read and control the current item, and
  /// to set the initial item.
  ///
  /// If null, an implicit one will be created internally.
  final ImageWheelScrollController? controller;

  /// An option callback when the currently centered item changes.
  ///
  /// Value changes when the item closest to the center changes.
  ///
  /// This can be called during scrolls and during ballistic flings. To get the
  /// value only when the scrolling settles, use a [NotificationListener],
  /// listen for [ScrollEndNotification] and read its [ScrollMetrics].
  final ValueChanged<int>? onSelectedItemChanged;

  final List<List<Widget>> children;

  final List<double> itemWidths;

  @override
  State<StatefulWidget> createState() => _ImageWheelState();
}

class _ImageWheelState extends State<ImageWheel> {
  int? _lastHapticIndex;
  ImageWheelScrollController? _controller;
  int _lastReportedItemIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ImageWheelScrollController();
    _lastReportedItemIndex = _controller?.initialItem ?? 0;
  }

  @override
  void didUpdateWidget(ImageWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && oldWidget.controller == null) {
      _controller?.dispose();
      _controller = null;
    } else if (widget.controller == null && oldWidget.controller != null) {
      assert(_controller == null);
      _controller = ImageWheelScrollController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      final ScrollMetrics metrics = notification.metrics;
      final int currentItemIndex = metrics.item;
      if (currentItemIndex != _lastReportedItemIndex) {
        _lastReportedItemIndex = currentItemIndex;
        final int trueIndex = currentItemIndex;
        //widget.childDelegate.trueIndexOf(currentItemIndex);
        _handleSelectedItemChanged(trueIndex);
      }
    }
    return false;
  }

  void _handleSelectedItemChanged(int index) {
    // Only the haptic engine hardware on iOS devices would produce the intended effects.
    setState(() {});
    final bool hasSuitableHapticHardware;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        hasSuitableHapticHardware = true;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        hasSuitableHapticHardware = false;
    }
    if (hasSuitableHapticHardware && index != _lastHapticIndex) {
      _lastHapticIndex = index;
      HapticFeedback.selectionClick();
    }

    widget.onSelectedItemChanged?.call(index);
  }

  void _handleChildTap(ImageWheelScrollController controller, {required int index}) {
    controller.animateToItem(index, duration: _kCupertinoPickerTapToScrollDuration, curve: _kCupertinoPickerTapToScrollCurve);
  }

  @override
  Widget build(BuildContext context) {
    final ImageWheelScrollController controller = widget.controller ?? _controller!;
    return LayoutBuilder(
      builder: (context, constraints) {
        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: widget.children.length + 2,
            itemBuilder: (context, idx) {
              if (idx == 0 || idx == widget.children.length + 1) {
                return SizedBox(width: constraints.maxWidth / 2 - 15);
              }
              final int index = idx - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.children[index].length, (i) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        _lastReportedItemIndex == _concatenatedIndex(index, i) ? 13 : 1.5,
                        9,
                        _lastReportedItemIndex == _concatenatedIndex(index, i) ? 13 : 1.5,
                        13,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: GestureDetector(
                          onTap: () => _handleChildTap(controller, index: _concatenatedIndex(index, i)),
                          child: AnimatedContainer(
                            height: 30,
                            width: _lastReportedItemIndex == _concatenatedIndex(index, i) ? 30 : 21.21,
                            duration: Duration(milliseconds: 300),
                            child: widget.children[index][i],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _concatenatedIndex(int i, int j) {
    assert(i >= 0 && j >= 0);
    if (i == 0) return j;
    return widget.children.sublist(0, i).map((e) => e.length).reduce((a, b) => a + b) + j;
  }
}
