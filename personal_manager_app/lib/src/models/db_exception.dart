class DBException implements Exception {
  final String message;

  DBException(this.message);

  @override
  String toString() {
    return message.toString();
  }
}
