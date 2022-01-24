import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/inputs/generic_string_input.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_event.dart';
import 'package:ordering_system/features/dashboard/admin/products/bloc/product_state.dart';
import 'package:ordering_system/infrastructure/api.dart';

class AdminProductBloc extends Bloc<ProductEvent, ProductState> {
  AdminProductBloc({
    required OrderingClient orderingClient,
  })  : _orderingClient = orderingClient,
        super(const ProductState()) {
    on<ProductNameChanged>(
      (event, emit) => emit(
        state.copyWith(productName: GenericStringInput.dirty(event.name)),
      ),
    );
    on<ProductPriceChanged>(
      (event, emit) => emit(
        state.copyWith(
            productPrice: GenericStringInput.dirty(event.price.toString())),
      ),
    );
    on<ProductPreviewChanged>(
      (event, emit) => emit(
        state.copyWith(productPreview: event.preview),
      ),
    );
    on<ProductTypeChanged>(
      (event, emit) => emit(
        state.copyWith(type: GenericStringInput.dirty(event.type)),
      ),
    );
    on<ProductSubmitted>(_productSubmitted);
    on<GetProducts>(_getProducts);
    on<DeleteProduct>(_deleteProduct);
    on<ProductUpdateSubmitted>(_updateProduct);
  }

  void _updateProduct(
    ProductUpdateSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    final validate = Formz.validate([
      state.productName,
      state.type,
      state.productName,
      state.productPrice,
    ]);
    if (!validate.isValidated && state.productPreview == null) {
      emit(state.copyWith(submissionStatus: FormzStatus.invalid));
      return;
    }
    try {
      await _orderingClient.updateProduct(
        method: 'PUT',
        productId: event.productId,
        name: state.productName.value,
        price: double.parse(state.productPrice.value),
        preview: state.productPreview!,
        type: state.type.value,
      );
      emit(state.copyWith(
        submissionStatus: FormzStatus.submissionSuccess,
      ));
      return emit(state.copyWith(
        submissionStatus: FormzStatus.pure,
      ));
    } catch (er) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  void _deleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    // print('delete_product');
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      await _orderingClient.deleteProduct(productId: event.productId);
      final products = await _orderingClient.getAdminProducts();
      emit(state.copyWith(
        submissionStatus: FormzStatus.submissionSuccess,
        products: products,
      ));
      return emit(state.copyWith(submissionStatus: FormzStatus.pure));
    } catch (err) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  void _getProducts(
    GetProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    try {
      final products = await _orderingClient.getAdminProducts();
      emit(state.copyWith(
        submissionStatus: FormzStatus.submissionSuccess,
        products: products,
      ));
      return emit(state.copyWith(
        submissionStatus: FormzStatus.pure,
      ));
    } catch (err) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  void _productSubmitted(
    ProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    final validate = Formz.validate([
      state.productName,
      state.productPrice,
      state.type,
    ]);
    emit(state.copyWith(submissionStatus: FormzStatus.submissionInProgress));
    if (!validate.isValidated || state.productPreview == null) {
      emit(state.copyWith(submissionStatus: FormzStatus.invalid));
      return;
    }
    try {
      await _orderingClient.createProduct(
        name: state.productName.value,
        price: double.parse(state.productPrice.value),
        preview: state.productPreview!,
        type: state.type.value,
      );
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionSuccess,
      ));
    } catch (e) {
      return emit(state.copyWith(
        submissionStatus: FormzStatus.submissionFailure,
      ));
    }
  }

  final OrderingClient _orderingClient;
}
