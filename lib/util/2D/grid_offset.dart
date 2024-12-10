part of 'two_dimensions.dart';

class GridOffset {
  GridOffset({required this.deltaRow, required this.deltaColumn});
  final int deltaRow;
  final int deltaColumn;

  @override
  String toString() =>
      '{${deltaRow.toString().padLeft(2, '0')}:${deltaColumn.toString().padLeft(2, '0')}}';

  @override
  operator ==(covariant other) =>
      other is GridOffset &&
      deltaRow == other.deltaRow &&
      deltaColumn == other.deltaColumn;

  @override
  int get hashCode => deltaRow.hashCode ^ deltaColumn.hashCode;

  GridOffset get inverse =>
      GridOffset(deltaRow: -deltaRow, deltaColumn: -deltaColumn);

  GridIndex apply(GridIndex index) {
    return GridIndex(
        row: index.row + deltaRow, column: index.column + deltaColumn);
  }
}
