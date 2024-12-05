import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/read_file.dart';

class Day5 implements Day {
  @override
  Future<int> part1() async {
    final rules = await readFileAsLines('inputs/day5_order.txt', (lines) {
      return lines.map((line) {
        final components = line.split('|');
        return (int.parse(components[0]), int.parse(components[1]));
      }).toList();
    });

    final updates = await readFileAsLines('inputs/day5_updates.txt', (lines) {
      return lines.map((line) {
        final components = line.split(',').map(int.parse).toList();
        return components;
      }).toList();
    });

    final validUpdates = <List<int>>[];

    for (final update in updates) {
      bool updateIsValid = true;
      for (final rule in rules) {
        final leftIndex = update.indexOf(rule.$1);
        final rightIndex = update.indexOf(rule.$2);

        if (leftIndex >= 0 && rightIndex >= 0) {
          if (rightIndex < leftIndex) {
            updateIsValid = false;
            break;
          }
        }
      }
      if (updateIsValid) {
        validUpdates.add(update);
      }
    }

    // Find middle value in each update
    final middleValues = validUpdates.map((update) {
      final centerIndex = update.length ~/ 2;
      return update[centerIndex];
    }).toList();

    final sum = middleValues.reduce((value, element) => value + element);
    return sum;
  }

  @override
  Future<int> part2() async {
    final rules = await readFileAsLines('inputs/day5_order.txt', (lines) {
      return lines.map((line) {
        final components = line.split('|');
        return (int.parse(components[0]), int.parse(components[1]));
      }).toList();
    });

    final updates = await readFileAsLines('inputs/day5_updates.txt', (lines) {
      return lines.map((line) {
        final components = line.split(',').map(int.parse).toList();
        return components;
      }).toList();
    });

    final incorrectUpdates = <List<int>>[];

    for (final update in updates) {
      for (final rule in rules) {
        final leftIndex = update.indexOf(rule.$1);
        final rightIndex = update.indexOf(rule.$2);

        if (leftIndex >= 0 && rightIndex >= 0) {
          if (rightIndex < leftIndex) {
            incorrectUpdates.add(update);
            break;
          }
        }
      }
    }

    final sortedUpdates = incorrectUpdates.map((update) {
      return update
        ..sort((a, b) {
          final sorting = () {
            for (final rule in rules) {
              if (a == rule.$1 && b == rule.$2) {
                return -1;
              }
              if (a == rule.$2 && b == rule.$1) {
                return 1;
              }
            }
            for (final rule in rules) {
              if (a == rule.$1) {
                return -1;
              }
              if (b == rule.$1) {
                return 1;
              }
              if (a == rule.$2) {
                return 1;
              }
              if (b == rule.$2) {
                return -1;
              }
            }
            return 0;
          }();
          // print('Sorting $a and $b: $sorting');
          return sorting;
        });
    }).toList();
    print(sortedUpdates.map((u) => u.join(',')).join('\n'));

    // Find middle value in each update
    final middleValues = sortedUpdates.map((update) {
      final centerIndex = update.length ~/ 2;
      return update[centerIndex];
    }).toList();

    final sum = middleValues.reduce((value, element) => value + element);
    return sum;
  }
}
