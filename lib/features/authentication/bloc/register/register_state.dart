import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/inputs/email.dart';
import 'package:ordering_system/domain/inputs/generic_string_input.dart';
import 'package:ordering_system/domain/inputs/password.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.submissionStatus = FormzStatus.pure,
    this.name = const GenericStringInput.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.message = '',
  });

  RegisterState copyWith({
    FormzStatus? submissionStatus,
    Email? email,
    Password? password,
    GenericStringInput? name,
    String? message,
  }) {
    return RegisterState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      message: message ?? this.message,
    );
  }

  final FormzStatus submissionStatus;
  final GenericStringInput name;
  final Email email;
  final Password password;
  final String message;

  @override
  List<Object?> get props => [
        submissionStatus,
        email,
        password,
        message,
      ];
}
