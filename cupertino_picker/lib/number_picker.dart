import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberPicker<T> extends StatefulWidget {
  NumberPicker({
    super.key,
    this.min,
    this.max,
    this.interval,
    this.fontSize = 15,
    this.onChanged,
    required this.initialValue,
    this.textColor,
    this.formatting,
    this.valueStream,
  }) {
    if (this is! NumberPicker<int> && this is! NumberPicker<double>) throw Exception('NumberPicker only supports int and double types');
  }

  final T? min;
  final T? max;
  final double fontSize;
  final void Function(T)? onChanged;
  final T initialValue;
  final T? interval;
  final Color? textColor;
  final String Function(T number)? formatting;
  final Stream<T>? valueStream;

  @override
  State<NumberPicker<T>> createState() => NumberPickerState();
}

class NumberPickerState<T> extends State<NumberPicker<T>> {
  final double magnification = 1.3;
  late FixedExtentScrollController myController;
  late T min;
  late T max;
  late T interval;

  @override
  void initState() {
    if (this is NumberPickerState<double>) {
      min = widget.min ?? 0.0 as T;
      max = widget.max ?? 100.0 as T;
      interval = widget.interval ?? 1.0 as T;
    } else if (this is NumberPickerState<int>) {
      min = widget.min ?? 0 as T;
      max = widget.max ?? 100 as T;
      interval = widget.interval ?? 1 as T;
    } else {
      throw Exception('NumberPicker only supports int and double types');
    }
    myController = FixedExtentScrollController(initialItem: revert(widget.initialValue));
    widget.valueStream?.listen((value) {
      myController.jumpToItem(revert(value));
    });
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            widget.formatting == null ? convert(index).toString() : widget.formatting!(convert(index)),
            style: TextStyle(
              fontSize: widget.fontSize / magnification,
              color: widget.onChanged == null ? Theme.of(context).disabledColor : widget.textColor,
            ),
          ),
        );
      },
      childCount: childCount(),
      scrollController: myController,
      onSelectedItemChanged: (index) => widget.onChanged?.call(convert(index)),
      itemExtent: 2.2 * widget.fontSize / magnification,
      useMagnifier: true,
      magnification: magnification,
    );
  }

  int childCount() {
    if (this is NumberPickerState<double>) return (((max as double) - (min as double)) / (interval as double) + 1).round();
    if (this is NumberPickerState<int>) return (((max as int) - (min as int)) / (interval as int) + 1).round();
    throw Exception('NumberPicker only supports int and double types');
  }

  T convert(int index) {
    if (this is NumberPickerState<double>) return (-index * (interval as double) + (max as double)) as T;
    if (this is NumberPickerState<int>) return (-index * (interval as int) + (max as int)) as T;
    throw Exception('NumberPicker only supports int and double types');
  }

  int revert(T value) {
    if (this is NumberPickerState<double>) return ((-(value as double) + (max as double)) / (interval as double)).round();
    if (this is NumberPickerState<int>) return ((-(value as int) + (max as int)) / (interval as int)).round();
    throw Exception('NumberPicker only supports int and double types');
  }
}
