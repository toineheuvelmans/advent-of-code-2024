part of 'two_dimensions.dart';

class Grid<T> {
  Grid(this.values);
  final List<List<T>> values;

  factory Grid.fromFile(File file, List<T> Function(String) lineParser) {
    final lines = file.readAsLinesSync();
    final values = lines.map((line) => lineParser(line)).toList();
    return Grid(values);
  }

  static Grid<String> stringGridFromFile(File file) {
    return Grid.fromFile(file, (line) => line.split(''));
  }

  static Grid<int> intGridFromFile(File file) {
    return Grid.fromFile(file, (line) {
      return line.split('').map(int.parse).toList();
    });
  }

  bool isValidIndex(GridIndex index) {
    return index.row >= 0 &&
        index.row < values.length &&
        index.column >= 0 &&
        index.column < values[index.row].length;
  }

  T? operator [](GridIndex index) {
    if (!isValidIndex(index)) return null;
    return values[index.row][index.column];
  }

  void operator []=(GridIndex index, T value) {
    if (!isValidIndex(index)) return;
    values[index.row][index.column] = value;
  }

  Iterable<(GridIndex, T)> get indexed sync* {
    for (var row = 0; row < values.length; row++) {
      for (var column = 0; column < values[row].length; column++) {
        yield (GridIndex(row: row, column: column), values[row][column]);
      }
    }
  }
}
