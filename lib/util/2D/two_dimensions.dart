import 'dart:io';

export 'dart:io' show File;

part 'direction.dart';
part 'grid.dart';
part 'grid_index.dart';
part 'grid_offset.dart';

extension ChangeGridIndexExt on GridIndex {
  GridIndex increment({required Direction direction}) {
    final newIndex = direction.mutateIndex(this);
    return GridIndex(row: newIndex.row, column: newIndex.column);
  }

  GridIndex decrement({required Direction direction}) {
    final newIndex = direction.opposite.mutateIndex(this);
    return GridIndex(row: newIndex.row, column: newIndex.column);
  }
}

extension GridIndexGridOffsetExt on GridIndex {
  GridOffset operator -(GridIndex other) =>
      GridOffset(deltaRow: row - other.row, deltaColumn: column - other.column);

  GridIndex operator +(GridOffset offset) => offset.apply(this);
}
