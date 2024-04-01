import 'package:basics/basics.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension IterableExtension<E> on Iterable<E> {
  /// The second to last element.
  ///
  /// Returns null if `this` has lass than two elements.
  E? get secondToLast {
    return length < 2 ? null : elementAt(length - 2);
  }

  Iterable<E> insertSeparator(E separator) {
    if (isEmpty) return this;
    return expand((e) => [e, separator]).take(length * 2 - 1);
  }
}

extension WidgetIterableExtension on Iterable<Widget> {
  Iterable<Widget> insertDividers({
    bool enable = true,
    Color? dividerColor,
    double indent = 20,
  }) {
    if (!enable || isEmpty) return this;
    return expand((e) => [
          e,
          Divider(
            indent: indent,
            height: 1,
            color: dividerColor ?? Colors.grey,
          ),
        ]).take(length * 2 - 1);
  }
}

extension NumIterableBasics<E extends num> on Iterable<E> {
  /// The weighted average of all elements in this iterable weighted with [weights].
  ///
  /// Returns 0 if `this` is empty.
  ///
  /// Returns the average of all elements if [weights] is null.
  ///
  /// [weights] must have the same length as the iterable.
  double weightedAverage([List<E>? weights]) {
    if (isEmpty) return 0;
    if (weights == null) return sum() / length;
    if (weights.length != length) throw Exception('Weights must have the same length as the iterable.');
    return IterableZip<E>([this, weights]).map((els) => els.first * els.last).reduce((a, b) => (a + b) as E) / weights.sum();
  }
}
