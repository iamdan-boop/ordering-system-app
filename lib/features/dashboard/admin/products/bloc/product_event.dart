import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {}

class ProductNameChanged extends ProductEvent {
  ProductNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ProductPriceChanged extends ProductEvent {
  ProductPriceChanged(this.price);

  final double price;

  @override
  List<Object?> get props => [price];
}

class ProductTypeChanged extends ProductEvent {
  ProductTypeChanged(this.type);

  final String type;

  @override
  List<Object?> get props => [type];
}

class ProductPreviewChanged extends ProductEvent {
  ProductPreviewChanged(this.preview);

  final File preview;

  @override
  List<Object?> get props => [preview];
}

class ProductSubmitted extends ProductEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductUpdateSubmitted extends ProductEvent {
  ProductUpdateSubmitted(this.productId);

  final int productId;

  @override
  List<Object?> get props => [];
}

class GetProducts extends ProductEvent {
  @override
  List<Object?> get props => [];
}

class DeleteProduct extends ProductEvent {
  DeleteProduct({required this.productId});

  final int productId;

  @override
  List<Object?> get props => [];
}
