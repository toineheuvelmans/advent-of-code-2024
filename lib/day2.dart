import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/list.dart';
import 'package:aoc2024/util/read_file.dart';

class Day2 implements Day {
  Future<List<List<int>>> readReports(String path) {
    return readFileAsLines(path, createRowReader(int.parse));
  }

  @override
  Future<int> part1() async {
    final path = 'inputs/day2_1.txt';
    final rows = await readReports(path);

    int safeCount = 0;
    for (final row in rows) {
      int? lastDelta;
      int lastEntry = row.first;
      final rest = row.skip(1);
      bool rowIsSafe = true;
      for (final entry in rest) {
        final delta = entry - lastEntry;
        if (lastDelta != null && delta.sign != lastDelta.sign) {
          rowIsSafe = false;
          print('Row is not safe, changing order: $row');
          break;
        }
        if (delta.abs() < 1 || delta.abs() > 3) {
          print('Row is not safe, higher delta ($delta): $row');
          rowIsSafe = false;
          break;
        }
        lastDelta = delta;
        lastEntry = entry;
      }
      if (rowIsSafe) {
        safeCount++;
      }
    }
    return safeCount;
  }

  @override
  Future<int> part2() async {
    final path = 'inputs/day2_1.txt';
    final rows = await readReports(path);

    int safeCount = 0;
    for (final row in rows) {
      final rowIsGood = this.rowIsGood(row);
      if (rowIsGood) {
        safeCount++;
      } else {
        for (final index in row.indexed) {
          final (i, _) = index;
          final rowWithoutIsGood = this.rowIsGood([...row]..removeAt(i));
          if (rowWithoutIsGood) {
            safeCount++;
            break;
          }
        }
      }
    }
    return safeCount;
  }

  bool rowIsGood(List<int> row) {
    final pairs = row.indexedPairs();
    if (pairs.isEmpty) {
      return false;
    }
    final List<(int sign, int delta)> diffs = pairs.map((e) {
      final (li, l) = e.$1;
      final (ri, r) = e.$2;
      final delta = r - l;
      return (delta.sign, delta.abs());
    }).toList();

    final uniqueSigns = diffs.map((e) => e.$1).toSet();
    if (uniqueSigns.length > 1) {
      return false;
    }

    final highestDelta = diffs.reduce((value, element) {
      if (element.$2 > value.$2) {
        return element;
      }
      return value;
    });
    if (highestDelta.$2 > 3) {
      return false;
    }

    final lowestDelta = diffs.reduce((value, element) {
      if (element.$2 < value.$2) {
        return element;
      }
      return value;
    });
    if (lowestDelta.$2 <= 0) {
      return false;
    }

    return true;
  }
}
