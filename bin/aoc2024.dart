import 'package:aoc2024/day1.dart';
import 'package:aoc2024/day2.dart';
import 'package:aoc2024/day3.dart';
import 'package:aoc2024/day4.dart';
import 'package:aoc2024/day5.dart';
import 'package:aoc2024/day6.dart';
import 'package:aoc2024/day7.dart';
import 'package:aoc2024/day8.dart';
import 'package:aoc2024/util/parse.dart';

Future<void> main(List<String> arguments) async {
  final days = [
    () => Day1(),
    () => Day2(),
    () => Day3(),
    () => Day4(),
    () => Day5(),
    () => Day6(),
    () => Day7(),
    () => Day8(),
  ];

  final dayNum = stringToInt(arguments[0]);
  if (dayNum == null) {
    print('Invalid or missing day');
    return;
  }
  final day = days[dayNum - 1]();
  final part = stringToInt(arguments[1]);
  if (part == null) {
    print('Invalid or missing part');
    return;
  }
  if (part == 1) {
    print(await day.part1());
  } else {
    print(await day.part2());
  }
}
