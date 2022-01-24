import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {}

class RegisterEmailChanged extends RegisterEvent {
  RegisterEmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class RegisterSubmitted extends RegisterEvent {
  @override
  List<Object?> get props => [];
}
