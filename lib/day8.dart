import 'package:aoc2024/day.dart';
import 'package:aoc2024/util/utils.dart';

class Day8 implements Day {
  Grid<String> readInput() {
    final path = 'inputs/day8.txt';
    return Grid.stringGridFromFile(File(path));
  }

  List<String> getFrequencies(Grid<String> input) {
    return input.values
        .map((r) => r.join(''))
        .join('')
        .uniqueCharacters()
        .where((c) => c != '.')
        .toList()
      ..sort();
  }

  @override
  Future<int> part1() async {
    final input = readInput();
    final scanner = GridScanner.stringScanner(input);

    final frequencies = getFrequencies(input);
    final antinodes = <GridIndex>{};

    for (final frequency in frequencies) {
      print('Looking for antennas for frequency $frequency');
      final indices = scanner.indicesOf(frequency);
      if (indices.length <= 1) {
        print('$frequency: Too few antennas, skipping');
        continue;
      }
      print('$frequency: Found ${indices.length} antennas');
      print(indices.join('\n'));
      final antennaPairs = indices.uniquePairs();
      print('Antenna pairs: ${antennaPairs.length}');

      for (final (antenna1, antenna2) in antennaPairs) {
        final offset = antenna2 - antenna1;
        final antinode1 = antenna2 + offset;
        final antinode2 = antenna1 + offset.inverse;
        antinodes.add(antinode1);
        antinodes.add(antinode2);
      }
      print('$frequency: Current unique total: ${antinodes.length}');
    }

    final withinBounds = antinodes.where((n) => input.isValidIndex(n)).toList();
    return withinBounds.length;
  }

  @override
  Future<int> part2() async {
    final input = readInput();
    final scanner = GridScanner.stringScanner(input);

    final frequencies = getFrequencies(input);
    final antinodes = <GridIndex>{};

    List<GridIndex> antinodeIndices(GridIndex antenna, GridOffset offset) {
      final antennaAtinodes = <GridIndex>[];
      GridIndex antinodeIndex = antenna + offset;
      while (input.isValidIndex(antinodeIndex)) {
        antennaAtinodes.add(antinodeIndex);
        antinodeIndex += offset;
      }
      return antennaAtinodes;
    }

    for (final frequency in frequencies) {
      print('Looking for antennas for frequency $frequency');
      final indices = scanner.indicesOf(frequency);
      if (indices.length <= 1) {
        print('$frequency: Too few antennas, skipping');
        continue;
      }
      print('$frequency: Found ${indices.length} antennas');
      print(indices.join('\n'));
      final antennaPairs = indices.uniquePairs();
      print('Antenna pairs: ${antennaPairs.length}');

      for (final (antenna1, antenna2) in antennaPairs) {
        final offset = antenna2 - antenna1;
        final antinodesInDirection1 = antinodeIndices(antenna1, offset);
        final antinodesInDirection2 = antinodeIndices(antenna2, offset.inverse);
        antinodes.addAll(antinodesInDirection1);
        antinodes.addAll(antinodesInDirection2);
      }
      print('$frequency: Current unique total: ${antinodes.length}');
    }

    return antinodes.length;
  }
}
