import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_system/app/bloc/authentication_event.dart';
import 'package:ordering_system/app/bloc/authentication_state.dart';
import 'package:ordering_system/infrastructure/authentication_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationLogoutRequested>(
      (event, emit) => _authenticationRepository.logout(),
    );
    on<AuthenticationGuestCheck>(
        (event, emit) => _authenticationRepository.guestCheck());
    on<AuthenticationStatusChanged>(_mapAuthenticationStatusChangedToState);
    _authenticationStatusSubscription =
        _authenticationRepository.status.listen((status) {
      add(
        AuthenticationStatusChanged(
          status.authenticationStatus,
          status.isGuest,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthenticationStatusState>?
      _authenticationStatusSubscription;

  Future<void> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(
          state.copyWith(
            status: AuthenticationStatus.unauthenticated,
          ),
        );
      case AuthenticationStatus.authenticated:
        return emit(
          state.copyWith(
            isGuest: event.isGuest,
            status: AuthenticationStatus.authenticated,
          ),
        );
      // ignore: no_default_cases
      default:
        return emit(const AuthenticationState.unknown());
    }
  }
}
