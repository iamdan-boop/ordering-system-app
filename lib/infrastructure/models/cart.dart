import 'package:json_annotation/json_annotation.dart';
import 'package:ordering_system/infrastructure/models/product.dart';

part 'cart.g.dart';

@JsonSerializable()
class Cart {
  const Cart({
    required this.id,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  static const empty = Cart(id: 0, products: <Product>[]);

  final int id;
  final List<Product> products;
}
