import 'package:json_annotation/json_annotation.dart';
import 'package:ordering_system/infrastructure/models/product_image.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.fileName,
    required this.type,
    required this.folderName,
    this.daily,
    this.yearly,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  final int id;
  final String name;
  final double price;
  final String type;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'folder_name')
  final String folderName;
  final int? quantity;
  @JsonKey(name: 'today')
  final String? daily;
  final String? yearly;
}
