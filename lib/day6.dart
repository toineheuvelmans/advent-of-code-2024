import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day6 implements Day {
  GridIndex findStart(Grid<String> input) {
    return input.indexed.firstWhere((element) => element.$2 == '^').$1;
  }

  @override
  Future<int> part1() async {
    const path = 'inputs/day6.txt';
    final input = Grid.stringGridFromFile(File(path));

    // Find index of ^ in input
    final start = findStart(input);

    return distinctPositions(start, input, 10000000);
  }

  int distinctPositions(GridIndex start, Grid<String> input, int breakLength) {
    final path = watchPath(start, input, breakLength);
    return path.toSet().length;
  }

  List<GridIndex> watchPath(
      GridIndex start, Grid<String> input, int breakLength) {
    final watchPath = <GridIndex>[start];
    Direction currentDirection = Direction.north;
    bool isOnGrid = true;
    while (isOnGrid) {
      final scanner = GridScanner.stringScanner(input);
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
    final input = Grid.stringGridFromFile(File(path));
    const breakLimit = 100000;
    const loopLimit = breakLimit - 10;

    // Find index of ^ in input
    final start = findStart(input);
    // Brute-force check for possible positions.
    // Wherever it exceeds loop limit
    // the watcher is probably in a loop.

    List<GridIndex> invalidPositions = [start];
    while (true) {
      final current = invalidPositions.last;
      final nextIndex = Direction.north.mutateIndex(current);
      final nextChar = input[nextIndex];
      if (nextChar == null || nextChar == '#') {
        break;
      }
      invalidPositions.add(nextIndex);
      // Break after first position, the watcher doesn't actually
      // look that far. This was the final fix.
      break;
    }

    int loopCount = 0;

    for (final (index, _) in input.indexed) {
      if (invalidPositions.contains(index)) {
        continue;
      }
      final adjustedInput = [...input.values];
      final row = adjustedInput[index.row].join('');
      row.replaceRange(index.column, index.column + 1, '#');
      adjustedInput[index.row] = row.split('');

      final positions =
          watchPath(start, Grid(adjustedInput), breakLimit).length;
      if (positions > loopLimit) {
        print(
            '[$loopCount] Found loop ($positions) at ${index.row}, ${index.column}');
        loopCount++;
      }
    }

    return loopCount;
  }
}
