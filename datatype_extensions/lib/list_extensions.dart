import 'package:flutter/material.dart';

extension ListExtension on List<Widget> {
  List<Widget> insertDivider(BuildContext context) {
    final List<Widget> newList = [];
    for (int i = 0; i < length; i++) {
      newList.add(this[i]);
      if (i != length - 1) {
        newList.add(Container(
          height: .33,
          color: Theme.of(context).dividerColor,
        ));
      }
    }
    return newList;
  }

  List<Widget> insertWidget({required Widget widget}) {
    final List<Widget> newList = [];
    for (int i = 0; i < length; i++) {
      newList.add(this[i]);
      if (i != length - 1) {
        newList.add(widget);
      }
    }
    return newList;
  }
}
