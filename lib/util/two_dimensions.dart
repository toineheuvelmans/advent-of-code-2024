class Index2D {
  Index2D({required this.row, required this.column});
  final int row;
  final int column;

  @override
  String toString() =>
      '[${row.toString().padLeft(4, '0')}:${column.toString().padLeft(4, '0')}]';
}

extension CompareIndex2DExt on Index2D {
  operator <(Index2D other) =>
      row < other.row || (row == other.row && column < other.column);
}

extension ChangeIndex2DExt on Index2D {
  Index2D increment({required Direction2D direction}) {
    final newIndex = direction.mutateIndex(this);
    return Index2D(row: newIndex.row, column: newIndex.column);
  }

  Index2D decrement({required Direction2D direction}) {
    final newIndex = direction.opposite.mutateIndex(this);
    return Index2D(row: newIndex.row, column: newIndex.column);
  }
}

enum Direction2D {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest;

  @override
  String toString() => switch (this) {
        north => 'N',
        northEast => 'NE',
        east => 'E',
        southEast => 'SE',
        south => 'S',
        southWest => 'SW',
        west => 'W',
        northWest => 'NW'
      };

  Index2D mutateIndex(Index2D index) {
    switch (this) {
      case Direction2D.north:
        return Index2D(row: index.row - 1, column: index.column);
      case Direction2D.northEast:
        return Index2D(row: index.row - 1, column: index.column + 1);
      case Direction2D.east:
        return Index2D(row: index.row, column: index.column + 1);
      case Direction2D.southEast:
        return Index2D(row: index.row + 1, column: index.column + 1);
      case Direction2D.south:
        return Index2D(row: index.row + 1, column: index.column);
      case Direction2D.southWest:
        return Index2D(row: index.row + 1, column: index.column - 1);
      case Direction2D.west:
        return Index2D(row: index.row, column: index.column - 1);
      case Direction2D.northWest:
        return Index2D(row: index.row - 1, column: index.column - 1);
    }
  }

  Direction2D get opposite => Direction2D.values[(index + 4) % 8];

  (Direction2D left, Direction2D right) get perpendicular {
    switch (this) {
      case Direction2D.north:
        return (Direction2D.west, Direction2D.east);
      case Direction2D.northEast:
        return (Direction2D.northWest, Direction2D.southEast);
      case Direction2D.east:
        return (Direction2D.north, Direction2D.south);
      case Direction2D.southEast:
        return (Direction2D.northEast, Direction2D.southWest);
      case Direction2D.south:
        return (Direction2D.east, Direction2D.west);
      case Direction2D.southWest:
        return (Direction2D.southEast, Direction2D.northWest);
      case Direction2D.west:
        return (Direction2D.south, Direction2D.north);
      case Direction2D.northWest:
        return (Direction2D.southWest, Direction2D.northEast);
    }
  }
}

extension String2DExt on List<String> {
  bool isValidIndex(Index2D index) {
    return index.row >= 0 &&
        index.row < length &&
        index.column >= 0 &&
        index.column < this[index.row].length;
  }

  String? getAt(Index2D index) {
    if (!isValidIndex(index)) {
      return null;
    }
    return this[index.row][index.column];
  }
}
