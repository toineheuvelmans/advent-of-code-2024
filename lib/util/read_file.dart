import 'dart:io';

/// Read a file and return a list of lines
Future<T> readFileAsLines<T>(
    String path, T Function(List<String>) parser) async {
  final file = File(path);
  final lines = await file.readAsLines();
  return parser(lines);
}

Future<String> readFileAsString(String path) async {
  final file = File(path);
  return file.readAsString();
}

Future<List<String>> readFileAsGrid(String path) async {
  final file = File(path);
  final lines = await file.readAsLines();
  return lines;
}

List<List<T>> Function(List<String>) createColumnReader<T>(
    T Function(String) cellParser) {
  return (List<String> lines) {
    final columns = <List<T>>[];

    /// Regex for capturing groups of non-whitespace characters
    final regex = RegExp(r'\S+');

    for (final (index, line) in lines.indexed) {
      if (!regex.hasMatch(line)) {
        print('Empty line found at line $index');
        continue;
      }
      final matches = regex.allMatches(line);
      for (var i = 0; i < matches.length; i++) {
        final match = matches.elementAt(i).group(0);
        if (match != null) {
          if (columns.length <= i) {
            columns.add([]);
          }
          columns[i].add(cellParser(match));
        }
      }
    }
    return columns;
  };
}

List<List<T>> Function(List<String>) createRowReader<T>(
    T Function(String) cellParser) {
  return (List<String> lines) {
    final rows = <List<T>>[];

    /// Regex for capturing groups of non-whitespace characters
    final regex = RegExp(r'\S+');

    for (final (index, line) in lines.indexed) {
      if (!regex.hasMatch(line)) {
        print('Empty line found at line $index');
        continue;
      }
      final matches = regex.allMatches(line);
      final row = <T>[];
      for (final match in matches) {
        final value = match.group(0);
        if (value != null) {
          row.add(cellParser(value));
        }
      }
      rows.add(row);
    }
    return rows;
  };
}
