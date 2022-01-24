import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {}

class GetOrders extends OrderEvent {
  @override
  List<Object?> get props => [];
}

class DeleteOrder extends OrderEvent {
  DeleteOrder({
    required this.checkoutId,
  });

  final int checkoutId;
  @override
  List<Object?> get props => [checkoutId];
}
