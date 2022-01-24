import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/order_event.dart';
import 'package:ordering_system/features/dashboard/admin/bloc/order_state.dart';
import 'package:ordering_system/infrastructure/api.dart';

class OrdersBloc extends Bloc<OrderEvent, OrderState> {
  OrdersBloc({
    required OrderingClient orderingClient,
  })  : _orderingClient = orderingClient,
        super(const OrderState()) {
    on<GetOrders>(_getOrders);
    on<DeleteOrder>(_deleteOrder);
  }

  void _getOrders(GetOrders event, Emitter<OrderState> emit) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      final checkouts = await _orderingClient.getCheckouts();
      return emit(state.copyWith(
          submissionStatus: FormzStatus.submissionSuccess,
          checkouts: checkouts));
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  void _deleteOrder(
    DeleteOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      await _orderingClient.deleteCheckout(checkoutId: event.checkoutId);
      final checkouts = await _orderingClient.getCheckouts();
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionSuccess,
        checkouts: checkouts,
      ));
    } catch (err) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionInProgress,
      ));
    }
  }

  final OrderingClient _orderingClient;
}
