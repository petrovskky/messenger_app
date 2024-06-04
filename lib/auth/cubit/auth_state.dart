import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {}

class NotAuthenticatedState extends AuthState {}

class AuthenticatedState extends AuthState {}