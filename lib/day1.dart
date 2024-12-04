import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/read_file.dart';

class Day1 implements Day {
  Future<(List<int> list1, List<int> list2)> readLists(String path) async {
    final columns = await readFileAsLines(path, createColumnReader(int.parse));
    final list1 = columns.first;
    final list2 = columns.last;
    return (list1, list2);
  }

  @override
  Future<int> part1() async {
    final path = 'inputs/day1_1.txt';
    final (list1, list2) = await readLists(path);

    list1.sort();
    list2.sort();

    final distances = <int>[];
    for (var i = 0; i < list1.length; i++) {
      distances.add((list2[i] - list1[i]).abs());
    }
    final total = distances.reduce((value, element) => value + element);

    return total;
  }

  @override
  Future<int> part2() async {
    final path = 'inputs/day1_1.txt';
    final (list1, list2) = await readLists(path);
    final similarities = <int>[];

    for (final entry in list1) {
      final matches = list2.where((element) => element == entry);
      final matchCount = matches.length;
      similarities.add(entry * matchCount);
    }

    final total = similarities.reduce((value, element) => value + element);
    return total;
  }
}
