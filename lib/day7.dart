import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

enum Operator {
  add,
  multiply;

  @override
  String toString() => this == add ? '+' : '*';

  T apply<T extends num>(T a, T b) {
    return (this == add ? a + b : a * b) as T;
  }
}

typedef OperationSet = ({int outcome, List<int> components});

class Day7 implements Day {
  @override
  Future<int> part1() async {
    final path = 'inputs/day7.txt';
    final entries = await readFileAsLines(path, (lines) {
      return lines.map((line) {
        final parts = line.split(': ');
        final outcome = int.parse(parts[0].trim());
        final components =
            parts[1].split(' ').map((p) => int.parse(p.trim())).toList();
        return (outcome: outcome, components: components);
      }).toList();
    });

    final correctEntries = <OperationSet>[];
    for (final entry in entries) {
      final outcome = entry.outcome;
      final components = entry.components;
      final operatorPermutations =
          permutations(Operator.values, components.length - 1);

      for (final operations in operatorPermutations) {
        int result = components[0];
        for (var i = 0; i < operations.length; i++) {
          final operation = operations[i];
          final component = components[i + 1];
          result = operation.apply(result, component);
        }
        if (result == outcome) {
          correctEntries.add(entry);
          break;
        }
      }
    }

    print('Found ${correctEntries.length} correct entries');

    // Return sum of correct entries outcomes
    return correctEntries.fold<int>(
        0, (previousValue, element) => previousValue + element.outcome);
  }

  @override
  Future<int> part2() {
    throw UnimplementedError();
  }
}
