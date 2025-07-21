class ApiException implements Exception {
  final String code; // ejemplo: 'forbidden', 'invalidData'
  final String message; // mensaje opcional, puede venir del backend

  ApiException(this.code, [this.message = '']);

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}
