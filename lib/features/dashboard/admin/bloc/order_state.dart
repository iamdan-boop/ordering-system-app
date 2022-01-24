import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/infrastructure/models/checkout.dart';

class OrderState extends Equatable {
  const OrderState({
    this.submissionStatus = FormzStatus.pure,
    this.checkouts = const <Checkout>[],
  });

  final FormzStatus submissionStatus;
  final List<Checkout> checkouts;

  OrderState copyWith({
    FormzStatus? submissionStatus,
    List<Checkout>? checkouts,
  }) {
    return OrderState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      checkouts: checkouts ?? this.checkouts,
    );
  }

  @override
  List<Object?> get props => [
        checkouts,
        submissionStatus,
      ];
}
