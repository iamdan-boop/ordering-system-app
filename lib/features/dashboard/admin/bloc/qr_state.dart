import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/infrastructure/models/checkout.dart';

class QRState extends Equatable {
  const QRState({
    this.checkout = Checkout.empty,
    this.submissionStatus = FormzStatus.pure,
    this.message = '',
  });

  QRState copyWith({
    Checkout? checkout,
    FormzStatus? submissionStatus,
    String? message,
  }) {
    return QRState(
      message: message ?? this.message,
      checkout: checkout ?? this.checkout,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  final Checkout checkout;
  final FormzStatus submissionStatus;
  final String message;

  @override
  List<Object?> get props => [checkout, submissionStatus, message];
}
