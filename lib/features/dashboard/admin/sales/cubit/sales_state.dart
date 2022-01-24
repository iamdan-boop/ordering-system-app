import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ordering_system/infrastructure/models/product.dart';
import 'package:ordering_system/infrastructure/models/sales.dart';

class SalesState extends Equatable {
  const SalesState({
    this.sales = Sales.empty,
    this.submissionStatus = FormzStatus.pure,
  });

  SalesState copyWith({
    Sales? sales,
    FormzStatus? submissionStatus,
  }) {
    return SalesState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      sales: sales ?? this.sales,
    );
  }

  final Sales sales;
  final FormzStatus submissionStatus;

  @override
  List<Object?> get props => [sales, submissionStatus];
}
