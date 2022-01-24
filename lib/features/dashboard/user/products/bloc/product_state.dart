import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/infrastructure/models/product.dart';
import 'package:ordering_system/infrastructure/models/product_preview.dart';

class ProductState extends Equatable {
  const ProductState({
    this.products = ProductPreview.empty,
    this.submissionStatus = FormzStatus.pure,
  });

  ProductState copyWith({
    ProductPreview? products,
    FormzStatus? submissionStatus,
  }) {
    return ProductState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      products: products ?? this.products,
    );
  }

  final ProductPreview products;
  final FormzStatus submissionStatus;

  @override
  List<Object?> get props => [products, submissionStatus];
}
