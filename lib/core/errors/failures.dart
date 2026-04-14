import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});

  factory ServerFailure.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ServerFailure('Bad request', statusCode: statusCode);
      case 401:
        return ServerFailure('Unauthorized', statusCode: statusCode);
      case 403:
        return ServerFailure('Forbidden', statusCode: statusCode);
      case 404:
        return ServerFailure('Not found', statusCode: statusCode);
      case 500:
        return ServerFailure('Internal server error', statusCode: statusCode);
      default:
        return ServerFailure('Server error', statusCode: statusCode);
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No Internet Connection');
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure(super.message, {this.fieldErrors = const {}});

  @override
  List<Object?> get props => [message, statusCode, fieldErrors];
}
