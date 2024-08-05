class ServerException implements Exception {
  ServerException([String? message]);
}

class CacheException implements Exception {}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}