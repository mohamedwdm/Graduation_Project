abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class ServerException extends AppException {
  final int? statusCode;
  final dynamic responseBody;

  const ServerException(
    super.message, {
    this.statusCode,
    this.responseBody,
  });
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No Internet Connection']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache Error']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Forbidden']);
}
