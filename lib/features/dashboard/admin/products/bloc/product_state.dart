import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/domain/inputs/generic_string_input.dart';
import 'package:ordering_system/infrastructure/models/product.dart';

class ProductState extends Equatable {
  const ProductState({
    this.submissionStatus = FormzStatus.pure,
    this.productName = const GenericStringInput.pure(),
    this.productPrice = const GenericStringInput.pure(),
    this.productPreview,
    this.products = const <Product>[],
    this.type = const GenericStringInput.pure(),
  });

  ProductState copyWith({
    FormzStatus? submissionStatus,
    GenericStringInput? productName,
    GenericStringInput? productPrice,
    GenericStringInput? type,
    File? productPreview,
    List<Product>? products,
  }) {
    return ProductState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      type: type ?? this.type,
      productPreview: productPreview ?? this.productPreview,
      products: products ?? this.products,
    );
  }

  final FormzStatus submissionStatus;
  final GenericStringInput productName;
  final GenericStringInput productPrice;
  final File? productPreview;
  final GenericStringInput type;
  final List<Product> products;

  @override
  List<Object?> get props => [
        submissionStatus,
        productName,
        productPrice,
        productPreview,
        type,
        products,
      ];
}
