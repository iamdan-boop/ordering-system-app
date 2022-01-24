import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/features/dashboard/user/products/bloc/product_event.dart';
import 'package:ordering_system/features/dashboard/user/products/bloc/product_state.dart';
import 'package:ordering_system/infrastructure/api.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required OrderingClient orderingClient,
  })  : _orderingClient = orderingClient,
        super(const ProductState()) {
    on<GetProducts>(_getProducts);
  }

  Future<void> _getProducts(
    GetProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      final products = await _orderingClient.getProducts(status: 'SHIPPED');
      return emit(state.copyWith(
        products: products,
        submissionStatus: FormzStatus.submissionSuccess,
      ));
    } catch (e) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionInProgress,
      ));
    }
  }

  final OrderingClient _orderingClient;
}
