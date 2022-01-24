import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/features/dashboard/user/products/cubit/add_product_state.dart';
import 'package:ordering_system/infrastructure/api.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit({
    required OrderingClient orderingClient,
  })  : _orderingClient = orderingClient,
        super(const AddProductState());

  void setProductId({required int productId}) =>
      emit(state.copyWith(productId: productId));

  void incrementProductQuantity() {
    return emit(state.copyWith(productQuantity: state.productQuantity + 1));
  }

  void decrementProductQuantity() {
    if (state.productQuantity == 1) {
      return;
    }
    return emit(state.copyWith(productQuantity: state.productQuantity - 1));
  }

  void addProductToCart() async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      await _orderingClient.addProductToCart(
        productId: state.productId,
        productQuantity: state.productQuantity,
      );
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionSuccess,
        message: 'Product Added to Cart',
      ));
    } on DioError {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
        message: 'Product Could not added to cart.',
      ));
    }
  }

  final OrderingClient _orderingClient;
}
