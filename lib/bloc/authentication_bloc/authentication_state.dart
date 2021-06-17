part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final User user;

  AuthenticationSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticationFailure extends AuthenticationState{}
