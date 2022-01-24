import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/infrastructure/models/cart.dart';

class CartState extends Equatable {
  const CartState({
    this.cart = Cart.empty,
    this.submissionStatus = FormzStatus.pure,
    this.referenceNumber = '',
  });

  final Cart cart;
  final FormzStatus submissionStatus;
  final String referenceNumber;

  CartState copyWith({
    Cart? cart,
    FormzStatus? submissionStatus,
    String? referenceNumber,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        cart,
        submissionStatus,
        referenceNumber,
      ];
}
