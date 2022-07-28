class ApiException with Exception {
  final String message;

  ApiException(this.message);
}