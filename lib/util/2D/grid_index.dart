part of 'two_dimensions.dart';

class GridIndex {
  GridIndex({required this.row, required this.column});
  final int row;
  final int column;

  @override
  String toString() =>
      '[${row.toString().padLeft(4, '0')}:${column.toString().padLeft(4, '0')}]';

  @override
  operator ==(covariant other) =>
      other is GridIndex && row == other.row && column == other.column;

  @override
  int get hashCode => row.hashCode ^ column.hashCode;
}

extension CompareGridIndexExt on GridIndex {
  operator <(GridIndex other) =>
      row < other.row || (row == other.row && column < other.column);
}
