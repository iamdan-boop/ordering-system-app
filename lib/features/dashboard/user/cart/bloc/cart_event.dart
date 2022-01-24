import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {}

class GetCartContents extends CartEvent {
  @override
  List<Object?> get props => [];
}

class IncrementProductCart extends CartEvent {
  IncrementProductCart({
    required this.productId,
  });

  final int productId;

  @override
  List<Object?> get props => [];
}

class DecrementProductCart extends CartEvent {
  DecrementProductCart({
    required this.productId,
  });

  final int productId;

  @override
  List<Object?> get props => [];
}

class CheckoutCart extends CartEvent {
  @override
  List<Object?> get props => [];
}
