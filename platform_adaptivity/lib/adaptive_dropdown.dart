import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:platform_adaptivity/adaptive_icons.dart';

const Color lightChartBG = Color(0xffffffff);
const Color darkChartBG = Color(0xff1c1f21);

class MyDDElement {
  const MyDDElement({
    required this.name,
    this.icon,
  });

  final String Function(BuildContext) name;
  final Icon? icon;
}

class AdaptiveDropDown<T> extends StatefulWidget {
  const AdaptiveDropDown({
    super.key,
    this.width = 130,
    this.contentPadding = const EdgeInsets.only(left: 16, right: 16),
    required this.value,
    required this.dropDownElements,
    this.onChanged,
    this.color,
  });

  final double width;
  final EdgeInsetsGeometry contentPadding;
  final T value;
  final Map<T, MyDDElement> dropDownElements;
  final void Function(T?)? onChanged;
  final Color? color;

  @override
  State<AdaptiveDropDown<T>> createState() => AdaptiveDropDownState<T>();
}

class AdaptiveDropDownState<T> extends State<AdaptiveDropDown<T>> {
  final GlobalKey<DropdownButton2State<T>> _dropDownKey = GlobalKey<DropdownButton2State<T>>();

  void openMenu() => _dropDownKey.currentState?.callTap();

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<T>(
      key: _dropDownKey,
      value: widget.value,
      iconStyleData: IconStyleData(
        icon: Icon(AdaptiveIcons.dropdown),
      ),
      buttonStyleData: ButtonStyleData(
        height: 56,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.color ?? (Theme.of(context).brightness == Brightness.light ? lightChartBG : darkChartBG),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: widget.contentPadding,
      ),
      dropdownStyleData: DropdownStyleData(
        width: widget.width,
        isOverButton: true,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      selectedItemBuilder: (context) => widget.dropDownElements.map((k, v) => MapEntry(k, buildDDItem(context, k, v, false))).values.toList(),
      style: TextStyle(color: Theme.of(context).primaryColor),
      underline: Container(),
      onChanged: widget.onChanged,
      items: widget.dropDownElements.map((k, v) => MapEntry(k, buildDDItem(context, k, v, true))).values.toList(),
    );
  }

  DropdownMenuItem<T> buildDDItem(BuildContext context, T value, MyDDElement element, bool showIcon) {
    if (showIcon && element.icon != null)
      return DropdownMenuItem<T>(
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              element.name(context),
              maxLines: 1,
            ),
            element.icon!,
          ],
        ),
      );
    else
      return DropdownMenuItem<T>(
        value: value,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            element.name(context),
            maxLines: 1,
          ),
        ),
      );
  }
}
