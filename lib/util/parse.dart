int? stringToInt(String value) {
  try {
    return int.parse(value);
  } catch (e) {
    print('Failed to parse $value as int');
    return null;
  }
}
