import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day10 implements Day {
  Future<List<List<int>>> readInput() async {
    final grid = await readFileAsGrid('inputs/day10.txt');
    return grid.map((line) => line.split('').map(int.parse).toList()).toList();
  }

  @override
  Future<int> part1() async {
    final input = await readInput();

    final trailHeads = <({Index2D position, List<Index2D> tops})>[];
    for (var row = 0; row < input.length; row++) {
      for (var column = 0; column < input[row].length; column++) {
        if (input[row][column] == 0) {
          final startPosition = Index2D(row: row, column: column);
          final tops = findTops(startPosition, input);
          trailHeads.add((position: startPosition, tops: tops));
        }
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
    final input = await readInput();

    final trailHeads = <({Index2D position, List<Index2D> tops})>[];
    for (var row = 0; row < input.length; row++) {
      for (var column = 0; column < input[row].length; column++) {
        if (input[row][column] == 0) {
          final startPosition = Index2D(row: row, column: column);
          final tops = findTops(startPosition, input);
          trailHeads.add((position: startPosition, tops: tops));
        }
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

  List<Index2D> findTops(Index2D startPosition, List<List<int>> grid) {
    final tops = <Index2D>[];
    final startValue = grid.getAt(startPosition);
    if (startValue == null) {
      return [];
    }

    if (startValue == 9) {
      return [startPosition];
    }

    for (final direction in Direction2D.nonDiagonal) {
      final indexInDirection = direction.mutateIndex(startPosition);
      final valueInDirection = grid.getAt(indexInDirection);
      if (valueInDirection != null && valueInDirection == startValue + 1) {
        tops.addAll(findTops(indexInDirection, grid));
      }
    }

    return tops;
  }
}
