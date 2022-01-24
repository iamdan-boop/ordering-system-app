import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/features/dashboard/user/cart/bloc/cart_event.dart';
import 'package:ordering_system/features/dashboard/user/cart/bloc/cart_state.dart';
import 'package:ordering_system/infrastructure/api.dart';
import 'package:ordering_system/infrastructure/models/cart.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required OrderingClient orderingClient})
      : _orderingClient = orderingClient,
        super(const CartState()) {
    on<GetCartContents>(_getCart);
    on<IncrementProductCart>(_incrementCartProductQuantity);
    on<DecrementProductCart>(_decrementCartProductQuantity);
    on<CheckoutCart>(_checkoutCart);
  }

  void _incrementCartProductQuantity(
    IncrementProductCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      await _orderingClient.incrementCartProductQuantity(
        productId: event.productId,
      );
      final cart = await _orderingClient.getCart();
      return emit(state.copyWith(
          submissionStatus: FormzStatus.submissionSuccess, cart: cart));
    } catch (err) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  void _decrementCartProductQuantity(
    DecrementProductCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      await _orderingClient.decrementCartProductQuantity(
        productId: event.productId,
      );
      final cart = await _orderingClient.getCart();
      return emit(state.copyWith(
          submissionStatus: FormzStatus.submissionSuccess, cart: cart));
    } catch (err) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  Future<void> _getCart(
    GetCartContents event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
      final cart = await _orderingClient.getCart();
      return emit(
        state.copyWith(
          submissionStatus: FormzStatus.submissionSuccess,
          cart: cart,
        ),
      );
    } catch (e) {
      print(e);
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  Future<void> _checkoutCart(
    CheckoutCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      final referenceNumber = await _orderingClient.checkout();
      return emit(
        state.copyWith(
          submissionStatus: FormzStatus.submissionSuccess,
          referenceNumber: referenceNumber,
          cart: Cart.empty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(submissionStatus: FormzStatus.submissionFailure),
      );
    }
  }

  final OrderingClient _orderingClient;
}
