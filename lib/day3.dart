import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/read_file.dart';

class Day3 implements Day {
  @override
  Future<int> part1() async {
    final input = await readFileAsString('inputs/day3_1.txt');

    // Capture only sequences of "mul(\d+,\d+)"
    final mulRegex = RegExp(r'mul\((\d+),(\d+)\)');
    final matches = mulRegex.allMatches(input);
    final values = matches.map((match) {
      final x = int.parse(match.group(1)!);
      final y = int.parse(match.group(2)!);
      return x * y;
    });
    // sum up
    return values.reduce((a, b) => a + b);
  }

  @override
  Future<int> part2() async {
    final input = await readFileAsString('inputs/day3_1.txt');

    // Capture "do()"
    final doRegex = RegExp(r'do\(\)');

    // Find indices at which "do()" occurs
    final doIndices = <int>[];
    doRegex.allMatches(input).forEach((match) {
      doIndices.add(match.start);
    });

    // Capture "don't()"
    final dontRegex = RegExp(r"don't\(\)");
    final dontIndices = <int>[];
    dontRegex.allMatches(input).forEach((match) {
      dontIndices.add(match.start);
    });

    // Combine do's and dont's, converting them too bool (true/false)
    // sorting them on their occurence index.
    final actions = [
      ...doIndices.map((index) => (index, true)),
      ...dontIndices.map((index) => (index, false))
    ]..sort((a, b) => a.$1.compareTo(b.$1));
    actions.insert(0, (0, true));

    // Capture only sequences of "mul(\d+,\d+)"
    final mulRegex = RegExp(r'mul\((\d+),(\d+)\)');
    final matches = mulRegex.allMatches(input);
    final values = matches.map((match) {
      // Check whether the index follows a "do()" or "don't()"
      final index = match.start;
      final action = actions.reversed
          .firstWhere((action) => action.$1 <= index, orElse: () => (0, true));

      if (action.$2) {
        final x = int.parse(match.group(1)!);
        final y = int.parse(match.group(2)!);
        return x * y;
      } else {
        return 0;
      }
    });
    // sum up
    return values.reduce((a, b) => a + b);
  }
}
