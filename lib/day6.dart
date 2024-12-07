import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day6 implements Day {
  Index2D findStart(List<String> input) {
    for (var row = 0; row < input.length; row++) {
      for (var column = 0; column < input[row].length; column++) {
        if (input[row][column] == '^') {
          return Index2D(row: row, column: column);
        }
      }
    }
    throw Exception('No start found');
  }

  @override
  Future<int> part1() async {
    const path = 'inputs/day6.txt';
    final input = await readFileAsGrid(path);

    // Find index of ^ in input
    final start = findStart(input);

    return distinctPositions(start, input, 10000000);
  }

  int distinctPositions(Index2D start, List<String> input, int breakLength) {
    final path = watchPath(start, input, breakLength);
    return path.toSet().length;
  }

  List<Index2D> watchPath(Index2D start, List<String> input, int breakLength) {
    final watchPath = <Index2D>[start];
    Direction2D currentDirection = Direction2D.north;
    bool isOnGrid = true;
    while (isOnGrid) {
      final scanner = StringScanner2D(input: input);
      final currentIndex = watchPath.last;
      // final charAtIndex = input.getAt(currentIndex);
      // print(
      //     'new scan from $currentIndex ($charAtIndex) in direction $currentDirection');
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
            // Avoid infinite loops
            if (watchPath.length > breakLength) {
              isOnGrid = false;
              return false;
            }
            return true;
          });
      // print('turning right from $currentDirection');
      currentDirection = currentDirection.turnRight();
      // print('new direction: $currentDirection');
    }
    return watchPath;
  }

  @override
  Future<int> part2() async {
    const path = 'inputs/day6.txt';
    final input = await readFileAsGrid(path);
    const breakLimit = 100000;
    const loopLimit = breakLimit - 10;

    // Find index of ^ in input
    final start = findStart(input);
    // Brute-force check for possible positions.
    // Wherever it exceeds loop limit
    // the watcher is probably in a loop.

    List<Index2D> invalidPositions = [start];
    while (true) {
      final current = invalidPositions.last;
      final nextIndex = Direction2D.north.mutateIndex(current);
      final nextChar = input.getAt(nextIndex);
      if (nextChar == null || nextChar == '#') {
        break;
      }
      invalidPositions.add(nextIndex);
      // Break after first position, the watcher doesn't actually
      // look that far. This was the final fix.
      break;
    }

    int loopCount = 0;

    for (var row = 0; row < input.length; row++) {
      for (var column = 0; column < input[row].length; column++) {
        if (invalidPositions.contains(Index2D(row: row, column: column))) {
          continue;
        }
        final adjustedInput = [...input];
        adjustedInput[row] =
            adjustedInput[row].replaceRange(column, column + 1, '#');

        final positions = watchPath(start, adjustedInput, breakLimit).length;
        if (positions > loopLimit) {
          print('[$loopCount] Found loop ($positions) at $row, $column');
          loopCount++;
        }
      }
    }

    return loopCount;
  }
}
