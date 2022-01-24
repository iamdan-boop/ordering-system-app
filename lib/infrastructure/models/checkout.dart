import 'package:json_annotation/json_annotation.dart';
import 'package:ordering_system/infrastructure/models/product.dart';

part 'checkout.g.dart';

@JsonSerializable()
class Checkout {
  const Checkout({
    required this.id,
    required this.status,
    required this.referenceNumber,
    required this.date,
    required this.email,
    required this.products,
  });

  factory Checkout.fromJson(Map<String, dynamic> json) =>
      _$CheckoutFromJson(json);

  static const empty = Checkout(
    id: 0,
    status: '',
    referenceNumber: '',
    date: '',
    email: '',
    products: <Product>[],
  );

  final int id;
  final String status;
  @JsonKey(name: 'reference_number')
  final String referenceNumber;
  @JsonKey(name: 'created_at')
  final String date;
  final String email;
  final List<Product> products;
}
