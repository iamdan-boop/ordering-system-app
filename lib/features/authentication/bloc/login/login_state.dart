import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/inputs/email.dart';
import 'package:ordering_system/domain/inputs/generic_string_input.dart';

class LoginState extends Equatable {
  const LoginState({
    this.submissionStatus = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const GenericStringInput.pure(),
    this.message = '',
  });

  final FormzStatus submissionStatus;
  final Email email;
  final GenericStringInput password;
  final String message;

  LoginState copyWith({
    FormzStatus? submissionStatus,
    Email? email,
    GenericStringInput? password,
    String? message,
  }) {
    return LoginState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        submissionStatus,
        email,
        password,
        message,
      ];
}
