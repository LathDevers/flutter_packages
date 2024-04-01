// ignore_for_file: file_names

import 'dart:collection';

extension ListQueueExtension<E> on ListQueue<E> {
  /// Removes the object at position [index] from this listqueue.
  ///
  /// This method pops the first items until [index], removes item at
  /// [index] and puts the rest back at the start of 'this'.
  ///
  /// Returns the removed value.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  E removeAt(int index) {
    assert(index >= 0 && index < length, 'Index $index out of bounds');
    final List<E> removed = [];
    for (int i = 0; i < index; i++) {
      removed.add(removeFirst());
    }
    final E result = removeFirst();
    for (final E item in removed.reversed) {
      addFirst(item);
    }
    return result;
  }
}
