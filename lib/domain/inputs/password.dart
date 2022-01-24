import 'package:formz/formz.dart';

enum PasswordValidationError { empty, invalid, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value)) {
      return PasswordValidationError.invalid;
    }
    if (value.length < 6) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}
