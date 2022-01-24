import 'package:equatable/equatable.dart';
import 'package:ordering_system/infrastructure/authentication_repository.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.isGuest = false,
  });

  const AuthenticationState.unknown() : this();

  const AuthenticationState.authenticated()
      : this(
          status: AuthenticationStatus.authenticated,
        );

  const AuthenticationState.unauthenticated()
      : this(
          status: AuthenticationStatus.unauthenticated,
        );

  const AuthenticationState.badRequest()
      : this(
          status: AuthenticationStatus.badRequest,
        );

  final AuthenticationStatus status;
  final bool isGuest;

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    bool? isGuest,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  List<Object?> get props => [status, isGuest];
}
