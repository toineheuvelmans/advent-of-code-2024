import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day4 implements Day {
  @override
  Future<int> part1() async {
    const path = 'inputs/day4.txt';
    final input = Grid.stringGridFromFile(File(path));

    final scanner = GridScanner.stringScanner(input);
    var xmasCount = 0;
    const target = 'XMAS';

    for (final (index, _) in input.indexed) {
      for (final direction in Direction.values) {
        final output = scanner.scanAtIndex(
          index,
          nextIndex: (index, step) => direction.mutateIndex(index),
          shouldContinue: (result, _, next) =>
              next != null && result.length < target.length,
        );
        if (output == target) {
          xmasCount++;
        }
      }
    }

    return xmasCount;
  }

  @override
  Future<int> part2() async {
    const path = 'inputs/day4.txt';
    final input = Grid.stringGridFromFile(File(path));

    final scanner = GridScanner.stringScanner(input);
    var xmasCount = 0;
    const target = 'MAS';

    for (final (index, _) in input.indexed) {
      final currentIndex = index;
      // Only diagonals, to get an X.
      for (final direction in [
        Direction.northEast,
        Direction.southEast,
        Direction.southWest,
        Direction.northWest
      ]) {
        final output = scanner.scanAtIndex(
          currentIndex,
          nextIndex: (index, step) => direction.mutateIndex(index),
          shouldContinue: (result, _, next) =>
              next != null &&
              result.length < target.length &&
              target.startsWith(result),
        );
        if (output == target) {
          final (lp, rp) = direction.perpendicular;
          final leftOrigin = currentIndex
              .increment(direction: direction)
              .decrement(direction: lp);
          final rightOrigin = currentIndex
              .increment(direction: direction)
              .decrement(direction: rp);

          for (final (perpendicularDirection, perpendicularOrigin) in [
            (lp, leftOrigin),
            (rp, rightOrigin),
          ]) {
            if (!input.isValidIndex(perpendicularOrigin)) {
              continue;
            }
            // Don't count doubles
            if (perpendicularOrigin < currentIndex) {
              continue;
            }

            final perpendicularOutput = scanner.scanAtIndex(
              perpendicularOrigin,
              nextIndex: (index, step) =>
                  perpendicularDirection.mutateIndex(index),
              shouldContinue: (result, _, next) =>
                  next != null &&
                  result.length < target.length &&
                  target.startsWith(result),
            );
            if (perpendicularOutput == target) {
              xmasCount++;
            }
          }
        }
      }
    }

    return xmasCount;
  }
}
