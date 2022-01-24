// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      fileName: json['file_name'] as String,
      type: json['type'] as String,
      folderName: json['folder_name'] as String,
      daily: json['today'] as String?,
      yearly: json['yearly'] as String?,
      quantity: json['quantity'] as int?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'type': instance.type,
      'file_name': instance.fileName,
      'folder_name': instance.folderName,
      'quantity': instance.quantity,
      'today': instance.daily,
      'yearly': instance.yearly,
    };
