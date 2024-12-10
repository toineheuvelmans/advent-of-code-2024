import 'package:aoc2024/util/2D/two_dimensions.dart';

class GridScanner<T, R> {
  GridScanner({
    required this.input,
    required this.initialResult,
    required this.addToResult,
  });

  static GridScanner<String, String> stringScanner(Grid<String> input) {
    return GridScanner(
      input: input,
      initialResult: '',
      addToResult: (result, next) => result + next,
    );
  }

  final Grid<T> input;

  final R initialResult;
  final R Function(R, T) addToResult;

  R scanAtIndex(
    GridIndex index, {
    /// Function to get the next index based on the current index and the
    /// length of the result.
    required GridIndex Function(GridIndex index, int step) nextIndex,

    /// Function to determine if the scan should continue based on the current
    /// result string, the next index, and the next character.
    required bool Function(R result, GridIndex nextIndex, T? next)
        shouldContinue,
  }) {
    var result = initialResult;
    if (!input.isValidIndex(index)) {
      return result;
    }
    var next = input[index];
    int resultLength = 0;

    while (shouldContinue(result, index, next)) {
      if (next == null) {
        break;
      }
      result = addToResult(result, next);
      resultLength++;
      index = nextIndex(index, resultLength);
      next = input[index];
    }

    return result;
  }

  List<GridIndex> indicesOf(T entry) {
    final indices = <GridIndex>[];
    for (var element in input.indexed) {
      if (element.$2 == entry) {
        indices.add(element.$1);
      }
    }
    return indices;
  }
}
