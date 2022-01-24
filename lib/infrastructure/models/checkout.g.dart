// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Checkout _$CheckoutFromJson(Map<String, dynamic> json) => Checkout(
      id: json['id'] as int,
      status: json['status'] as String,
      referenceNumber: json['reference_number'] as String,
      date: json['created_at'] as String,
      email: json['email'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CheckoutToJson(Checkout instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'reference_number': instance.referenceNumber,
      'created_at': instance.date,
      'email': instance.email,
      'products': instance.products,
    };
