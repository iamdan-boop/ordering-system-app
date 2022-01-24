import 'package:json_annotation/json_annotation.dart';
import 'package:ordering_system/infrastructure/models/product.dart';

part 'sales.g.dart';

@JsonSerializable()
class Sales {
  const Sales({
    required this.sales,
    required this.topBeverages,
    required this.yearDailySales,
    required this.topSilogs,
  });

  factory Sales.fromJson(Map<String, dynamic> json) => _$SalesFromJson(json);

  static const empty = Sales(
    sales: <Product>[],
    topBeverages: <Product>[],
    topSilogs: <Product>[],
    yearDailySales: <Product>[],
  );

  @JsonKey(name: 'top_products')
  final List<Product> sales;
  @JsonKey(name: 'today_yearly_sales')
  final List<Product> yearDailySales;
  @JsonKey(name: 'top_beverages')
  final List<Product> topBeverages;
  @JsonKey(name: 'top_silogs')
  final List<Product> topSilogs;
}
