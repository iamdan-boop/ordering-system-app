import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/inputs/email.dart';
import 'package:ordering_system/domain/inputs/generic_string_input.dart';
import 'package:ordering_system/domain/inputs/password.dart';
import 'package:ordering_system/features/authentication/bloc/register/register_event.dart';
import 'package:ordering_system/features/authentication/bloc/register/register_state.dart';
import 'package:ordering_system/infrastructure/authentication_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterEmailChanged>(
      (event, emit) => emit(state.copyWith(email: Email.dirty(event.email))),
    );
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: FormzStatus.submissionInProgress,
      message: '',
    ));
    final validate = Formz.validate([
      state.email,
    ]);
    if (!validate.isValidated) {
      emit(
        state.copyWith(
          submissionStatus: FormzStatus.invalid,
          message: 'Fields cannot be empty',
        ),
      );
      return;
    }
    try {
      await _authenticationRepository.loginAsGuest(guest: state.email.value);
      return emit(
        state.copyWith(
          submissionStatus: FormzStatus.submissionSuccess,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  final AuthenticationRepository _authenticationRepository;
}
