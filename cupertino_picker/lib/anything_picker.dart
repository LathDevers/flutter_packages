import 'package:flutter/cupertino.dart';

class AnythingPicker extends StatefulWidget {
  const AnythingPicker({
    super.key,
    required this.values,
    required this.onChanged,
    this.initialIndex = 0,
    required this.valueHeight,
  });

  final List<Widget> values;
  final Function(int) onChanged;
  final int initialIndex;
  final double valueHeight;

  @override
  State<AnythingPicker> createState() => AnythingPickerState();
}

class AnythingPickerState extends State<AnythingPicker> {
  final double magnification = 1.3;
  late FixedExtentScrollController myController;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myController = FixedExtentScrollController(initialItem: widget.initialIndex);
    return CupertinoPicker(
      scrollController: myController,
      onSelectedItemChanged: widget.onChanged,
      itemExtent: magnification * widget.valueHeight,
      useMagnifier: true,
      magnification: magnification,
      children: widget.values,
    );
  }
}
