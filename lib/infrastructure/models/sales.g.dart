// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sales _$SalesFromJson(Map<String, dynamic> json) => Sales(
      sales: (json['top_products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      topBeverages: (json['top_beverages'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      yearDailySales: (json['today_yearly_sales'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      topSilogs: (json['top_silogs'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesToJson(Sales instance) => <String, dynamic>{
      'top_products': instance.sales,
      'today_yearly_sales': instance.yearDailySales,
      'top_beverages': instance.topBeverages,
      'top_silogs': instance.topSilogs,
    };
