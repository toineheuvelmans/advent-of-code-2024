import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day10 implements Day {
  @override
  Future<int> part1() async {
    final input = Grid.intGridFromFile(File('inputs/day10.txt'));

    final trailHeads = <({GridIndex position, List<GridIndex> tops})>[];
    for (final (index, value) in input.indexed) {
      if (value == 0) {
        final startPosition = index;
        final tops = findTops(startPosition, input);
        trailHeads.add((position: startPosition, tops: tops));
      }
    }

    int uniqueTopsSum = 0;
    for (final trailHead in trailHeads) {
      final totalTops = trailHead.tops.length;
      final uniqueTops = trailHead.tops.toSet().length;
      uniqueTopsSum += uniqueTops;
      print(
          'Trail head: ${trailHead.position}, tops: $uniqueTops ($totalTops)');
    }
    return uniqueTopsSum;
  }

  @override
  Future<int> part2() async {
    final input = Grid.intGridFromFile(File('inputs/day10.txt'));

    final trailHeads = <({GridIndex position, List<GridIndex> tops})>[];
    for (final (index, value) in input.indexed) {
      if (value == 0) {
        final startPosition = index;
        final tops = findTops(startPosition, input);
        trailHeads.add((position: startPosition, tops: tops));
      }
    }

    int ratingSum = 0;
    for (final trailHead in trailHeads) {
      final totalTops = trailHead.tops.length;
      final uniqueTops = trailHead.tops.toSet().length;
      ratingSum += totalTops;
      print(
          'Trail head: ${trailHead.position}, tops: $totalTops ($uniqueTops)');
    }
    return ratingSum;
  }

  List<GridIndex> findTops(GridIndex startPosition, Grid<int> grid) {
    final tops = <GridIndex>[];
    final startValue = grid[startPosition];
    if (startValue == null) {
      return [];
    }

    if (startValue == 9) {
      return [startPosition];
    }

    for (final direction in Direction.nonDiagonal) {
      final indexInDirection = direction.mutateIndex(startPosition);
      final valueInDirection = grid[indexInDirection];
      if (valueInDirection != null && valueInDirection == startValue + 1) {
        tops.addAll(findTops(indexInDirection, grid));
      }
    }

    return tops;
  }
}
