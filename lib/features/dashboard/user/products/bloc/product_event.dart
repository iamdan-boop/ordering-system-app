import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {}

class GetProducts extends ProductEvent {
  @override
  List<Object?> get props => [];
}
