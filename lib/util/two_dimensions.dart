typedef Index2D = ({int row, int column});

extension CompareExt on Index2D {
  operator <(Index2D other) =>
      row < other.row || (row == other.row && column < other.column);
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

  Index2D mutateIndex(Index2D index) {
    switch (this) {
      case Direction2D.north:
        return (row: index.row - 1, column: index.column);
      case Direction2D.northEast:
        return (row: index.row - 1, column: index.column + 1);
      case Direction2D.east:
        return (row: index.row, column: index.column + 1);
      case Direction2D.southEast:
        return (row: index.row + 1, column: index.column + 1);
      case Direction2D.south:
        return (row: index.row + 1, column: index.column);
      case Direction2D.southWest:
        return (row: index.row + 1, column: index.column - 1);
      case Direction2D.west:
        return (row: index.row, column: index.column - 1);
      case Direction2D.northWest:
        return (row: index.row - 1, column: index.column - 1);
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
