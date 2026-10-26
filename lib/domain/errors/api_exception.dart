class ApiException implements Exception {
  const ApiException(this.code, {this.retryAfter, this.remaining});

  final String code;
  final int? retryAfter;
  final int? remaining;

  @override
  String toString() => 'ApiException($code)';
}
