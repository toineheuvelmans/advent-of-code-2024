import 'dart:math' as math;

import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class RuleResult {
  final int value1;
  final int value2;
  final bool hasTwo;

  const RuleResult.single(this.value1)
      : value2 = 0,
        hasTwo = false;
  const RuleResult.pair(this.value1, this.value2) : hasTwo = true;
}

class Day11 implements Day {
  final Map<(int, int), int> _cache = {};

  int _digitCount(int n) {
    if (n == 0) return 1;
    return (n > 0 ? (math.log(n) / math.ln10).floor() + 1 : 0);
  }

  (int, int) _splitNumber(int n, int digits) {
    final halfDigits = digits ~/ 2;
    final divisor = math.pow(10, halfDigits).toInt();
    return (n ~/ divisor, n % divisor);
  }

  RuleResult applyRules(int stone) {
    if (stone == 0) {
      return const RuleResult.single(1);
    }

    final digits = _digitCount(stone);
    if (digits % 2 == 0) {
      final (left, right) = _splitNumber(stone, digits);
      return RuleResult.pair(left, right);
    }

    return RuleResult.single(stone * 2024);
  }

  @override
  Future<int> part1() async {
    final input = await readFileAsString('inputs/day11.txt');
    final stones = input.split(' ').map((n) => int.parse(n.trim())).toList();

    List<int> current = stones;
    for (var blink = 0; blink < 25; blink++) {
      final output = <int>[];
      for (final stone in current) {
        final result = applyRules(stone);
        output.add(result.value1);
        if (result.hasTwo) {
          output.add(result.value2);
        }
      }
      current = output;
    }

    return current.length;
  }

  @override
  Future<int> part2() async {
    final input = await readFileAsString('inputs/day11.txt');
    final stones = input.split(' ').map((n) => int.parse(n.trim())).toList();

    _cache.clear();

    int totalStones = 0;
    for (var i = 0; i < stones.length; i++) {
      final stone = stones[i];
      print('Processing stone $i');
      totalStones += countTotalStonesAfterBlinks(stone, 75, 0);
      print('Finished stone $i. Current total: $totalStones');
    }

    return totalStones;
  }

  int countTotalStonesAfterBlinks(
      int initialStoneValue, int totalBlinks, int initialBlink) {
    // Base case
    if (initialBlink == totalBlinks) {
      return 1;
    }

    // Check cache
    final key = (initialStoneValue, initialBlink);
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    // Calculate result
    final result = applyRules(initialStoneValue);
    final count = !result.hasTwo
        ? countTotalStonesAfterBlinks(
            result.value1, totalBlinks, initialBlink + 1)
        : countTotalStonesAfterBlinks(
                result.value1, totalBlinks, initialBlink + 1) +
            countTotalStonesAfterBlinks(
                result.value2, totalBlinks, initialBlink + 1);

    // Cache result
    _cache[key] = count;
    return count;
  }
}
