import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class AddProductState extends Equatable {
  const AddProductState({
    this.productId = 0,
    this.productQuantity = 1,
    this.submissionStatus = FormzStatus.pure,
    this.message = '',
  });

  AddProductState copyWith({
    int? productQuantity,
    int? productId,
    FormzStatus? submissionStatus,
    String? message,
  }) {
    return AddProductState(
      productId: productId ?? this.productId,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      productQuantity: productQuantity ?? this.productQuantity,
      message: message ?? this.message,
    );
  }

  final int productId;
  final int productQuantity;
  final FormzStatus submissionStatus;
  final String message;

  @override
  List<Object?> get props =>
      [productId, productQuantity, submissionStatus, message];
}
