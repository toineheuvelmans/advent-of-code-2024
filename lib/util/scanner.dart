import 'package:aoc2024/util/two_dimensions.dart';

class StringScanner2D {
  StringScanner2D({required this.input});
  final List<String> input;

  String scanAtIndex(
    Index2D index, {
    required Index2D Function(Index2D index, int step) nextIndex,
    required bool Function(String result, String? next) shouldContinue,
  }) {
    var result = '';
    if (!input.isValidIndex(index)) {
      return result;
    }
    var next = input.getAt(index);

    while (shouldContinue(result, next)) {
      if (next == null) {
        break;
      }
      result += next;
      index = nextIndex(index, result.length);
      next = input.getAt(index);
    }

    return result;
  }
}
