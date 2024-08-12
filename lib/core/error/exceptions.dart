class ServerException implements Exception {
  final String? message;
  final String? details;

  ServerException([this.message = "An unknown error occurred", this.details]);

  @override
  String toString() {
    return "ServerException: $message\nDetails: $details";
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() {
    return "AuthException: $message";
  }
}

class CacheException implements Exception {}


//petenet001@gmail.com