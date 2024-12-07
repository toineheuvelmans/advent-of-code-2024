import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day6 implements Day {
  @override
  Future<int> part1() async {
    const path = 'inputs/day6.txt';
    final input = await readFileAsGrid(path);

    // Find index of ^ in input
    final start = () {
      for (var row = 0; row < input.length; row++) {
        for (var column = 0; column < input[row].length; column++) {
          if (input[row][column] == '^') {
            print('Found start at $row, $column');
            return Index2D(row: row, column: column);
          }
        }
      }
    }();
    if (start == null) {
      throw Exception('No start found');
    }

    final watchPath = <Index2D>[start];
    Direction2D currentDirection = Direction2D.north;
    bool isOnGrid = true;
    while (isOnGrid) {
      final scanner = StringScanner2D(input: input);
      final currentIndex = watchPath.last;
      final charAtIndex = input.getAt(currentIndex);
      print(
          'new scan from $currentIndex ($charAtIndex) in direction $currentDirection');
      scanner.scanAtIndex(currentIndex,
          nextIndex: (index, step) => currentDirection.mutateIndex(index),
          shouldContinue: (result, nextIndex, next) {
            if (next == null) {
              isOnGrid = false;
              return false;
            }
            if (next == '#') {
              return false;
            }
            watchPath.add(nextIndex);

            return true;
          });
      // print('turning right from $currentDirection');
      currentDirection = currentDirection.turnRight();
      // print('new direction: $currentDirection');
    }

    final distinctPositions = watchPath.toSet().length;

    return distinctPositions;
  }

  @override
  Future<int> part2() {
    throw UnimplementedError();
  }
}
