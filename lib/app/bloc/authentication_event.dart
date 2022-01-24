import 'package:equatable/equatable.dart';
import 'package:ordering_system/infrastructure/authentication_repository.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationCheck extends AuthenticationEvent {}

class AuthenticationStatusChanged extends AuthenticationEvent {
  AuthenticationStatusChanged(
    this.status,
    this.isGuest,
  );

  final AuthenticationStatus status;
  final bool isGuest;

  @override
  List<Object> get props => [
        status,
        isGuest,
      ];
}

class AuthenticationGuestCheck extends AuthenticationEvent {}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
