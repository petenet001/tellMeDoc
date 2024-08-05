import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class AuthFailure extends Failure {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  final String field;
  final String message;

  ValidationFailure(this.field, this.message);

  @override
  List<Object> get props => [field, message];
}