import 'package:json_annotation/json_annotation.dart';
import 'package:ordering_system/infrastructure/models/product.dart';

part 'product_preview.g.dart';

@JsonSerializable()
class ProductPreview {
  const ProductPreview({
    required this.topSelling,
    required this.beverages,
    required this.silog,
  });

  factory ProductPreview.fromJson(Map<String, dynamic> json) =>
      _$ProductPreviewFromJson(json);

  static const empty = ProductPreview(
    topSelling: <Product>[],
    beverages: <Product>[],
    silog: <Product>[],
  );

  @JsonKey(name: 'top_selling')
  final List<Product> topSelling;
  
  final List<Product> beverages;

  final List<Product> silog;
}
