extension ListExt<T> on List<T> {
  Iterable<((int index, T element), (int index, T element))>
      indexedPairs<E>() sync* {
    assert(length > 1, 'Iterable must have at least 2 elements');

    for (var i = 0; i < length - 1; i++) {
      final l = (i, this[i]);
      final r = (i + 1, this[i + 1]);
      yield (l, r);
    }
  }
}
