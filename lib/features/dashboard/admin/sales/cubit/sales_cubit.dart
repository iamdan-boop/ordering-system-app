import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/features/dashboard/admin/sales/cubit/sales_state.dart';
import 'package:ordering_system/infrastructure/api.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit({
    required OrderingClient orderingClient,
  })  : _orderingClient = orderingClient,
        super(const SalesState());

  void getSales() async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      final sales = await _orderingClient.getSales();
      print(sales);
      return emit(state.copyWith(
        sales: sales,
        submissionStatus: FormzStatus.submissionSuccess,
      ));
    } catch (e) {
      return emit(
          state.copyWith(submissionStatus: FormzStatus.submissionFailure));
    }
  }

  final OrderingClient _orderingClient;
}
