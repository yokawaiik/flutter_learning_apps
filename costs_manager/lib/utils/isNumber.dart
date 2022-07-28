bool isNumber(String data) {
  if (data == null) {
    return false;
  }
  return double.tryParse(data) != null;
}