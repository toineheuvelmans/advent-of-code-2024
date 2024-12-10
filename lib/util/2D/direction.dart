part of 'two_dimensions.dart';

enum Direction {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest;

  static const nonDiagonal = [
    Direction.north,
    Direction.east,
    Direction.south,
    Direction.west
  ];

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

  /// Change the given index in this direction
  GridIndex mutateIndex(GridIndex index) {
    switch (this) {
      case Direction.north:
        return GridIndex(row: index.row - 1, column: index.column);
      case Direction.northEast:
        return GridIndex(row: index.row - 1, column: index.column + 1);
      case Direction.east:
        return GridIndex(row: index.row, column: index.column + 1);
      case Direction.southEast:
        return GridIndex(row: index.row + 1, column: index.column + 1);
      case Direction.south:
        return GridIndex(row: index.row + 1, column: index.column);
      case Direction.southWest:
        return GridIndex(row: index.row + 1, column: index.column - 1);
      case Direction.west:
        return GridIndex(row: index.row, column: index.column - 1);
      case Direction.northWest:
        return GridIndex(row: index.row - 1, column: index.column - 1);
    }
  }

  Direction get opposite => Direction.values[(index + 4) % 8];

  /// Turns 90° clockwise
  Direction turnRight() {
    return Direction.values[(index + 2) % 8];
  }

  /// Returns the directions at
  /// 90° counter-clockwise (left)
  /// and 90° clockwise (right)
  (Direction left, Direction right) get perpendicular {
    switch (this) {
      case Direction.north:
        return (Direction.west, Direction.east);
      case Direction.northEast:
        return (Direction.northWest, Direction.southEast);
      case Direction.east:
        return (Direction.north, Direction.south);
      case Direction.southEast:
        return (Direction.northEast, Direction.southWest);
      case Direction.south:
        return (Direction.east, Direction.west);
      case Direction.southWest:
        return (Direction.southEast, Direction.northWest);
      case Direction.west:
        return (Direction.south, Direction.north);
      case Direction.northWest:
        return (Direction.southWest, Direction.northEast);
    }
  }
}
