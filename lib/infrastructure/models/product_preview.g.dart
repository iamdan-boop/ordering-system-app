// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPreview _$ProductPreviewFromJson(Map<String, dynamic> json) =>
    ProductPreview(
      topSelling: (json['top_selling'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      beverages: (json['beverages'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      silog: (json['silog'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductPreviewToJson(ProductPreview instance) =>
    <String, dynamic>{
      'top_selling': instance.topSelling,
      'beverages': instance.beverages,
      'silog': instance.silog,
    };
