import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day4 implements Day {
  @override
  Future<int> part1() async {
    const path = 'inputs/day4.txt';
    final input = await readFileAsGrid(path);

    final scanner = StringScanner2D(input: input);
    var xmasCount = 0;
    const target = 'XMAS';

    for (var row = 0; row < input.length; row++) {
      for (var column = 0; column < input[row].length; column++) {
        for (final direction in Direction2D.values) {
          final output = scanner.scanAtIndex(
            Index2D(row: row, column: column),
            nextIndex: (index, step) => direction.mutateIndex(index),
            shouldContinue: (result, _, next) =>
                next != null && result.length < target.length,
          );
          if (output == target) {
            xmasCount++;
          }
        }
      }
    }
    return xmasCount;
  }

  @override
  Future<int> part2() async {
    const path = 'inputs/day4.txt';
    final input = await readFileAsGrid(path);

    final scanner = StringScanner2D(input: input);
    var xmasCount = 0;
    const target = 'MAS';

    for (var row = 0; row < input.length; row++) {
      for (var column = 0; column < input[row].length; column++) {
        final currentIndex = Index2D(row: row, column: column);
        // Only diagonals, to get an X.
        for (final direction in [
          Direction2D.northEast,
          Direction2D.southEast,
          Direction2D.southWest,
          Direction2D.northWest
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
    }
    return xmasCount;
  }
}
