List<List<T>> permutations<T>(List<T> options, int length) {
  if (length == 1) {
    return options.map((e) => [e]).toList();
  }
  final result = <List<T>>[];
  for (var i = 0; i < options.length; i++) {
    final current = options[i];
    final subPermutations = permutations(options, length - 1);
    for (final subPermutation in subPermutations) {
      result.add([current, ...subPermutation]);
    }
  }
  return result;
}
