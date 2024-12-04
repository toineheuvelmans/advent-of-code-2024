import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/read_file.dart';
import 'package:aoc2024/util/scanner.dart';
import 'package:aoc2024/util/two_dimensions.dart';

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
            (row: row, column: column),
            nextIndex: (index, step) => direction.mutateIndex(index),
            shouldContinue: (result, next) =>
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
  Future<int> part2() {
    // TODO: implement part2
    throw UnimplementedError();
  }
}
