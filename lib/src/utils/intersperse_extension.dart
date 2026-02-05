extension IterableUtils<T> on Iterable<T> {
  /// Insert [separator] between items, with optional [start]/[end] items.
  List<T> intersperse(T separator, {T? start, T? end}) {
    final result = <T>[];
    final iterator = this.iterator;
    if (!iterator.moveNext()) return result;

    if (start != null) {
      result.add(start);
    }

    result.add(iterator.current);

    while (iterator.moveNext()) {
      result.add(separator);
      result.add(iterator.current);
    }

    if (end != null) {
      result.add(end);
    }
    return result;
  }
}
