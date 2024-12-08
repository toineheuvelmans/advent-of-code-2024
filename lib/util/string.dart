extension StringExt on String {
  List<String> uniqueCharacters() {
    return split('').toSet().toList();
  }
}
