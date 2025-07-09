class ProviderCreationException implements Exception {
  final String message;
  ProviderCreationException(this.message);

  @override
  String toString() => message;
}
