// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricesProduct _$PricesProductFromJson(Map<String, dynamic> json) =>
    PricesProduct(
      pointTypeId: (json['point_type_id'] as num).toInt(),
      pointsSum: (json['points_sum'] as num).toInt(),
    );

Map<String, dynamic> _$PricesProductToJson(PricesProduct instance) =>
    <String, dynamic>{
      'point_type_id': instance.pointTypeId,
      'points_sum': instance.pointsSum,
    };

ProductStore _$ProductStoreFromJson(Map<String, dynamic> json) => ProductStore(
  id: (json['id'] as num).toInt(),
  description: json['description'] as String,
  vendorCode: json['vendor_code'] as String,
  status: (json['status'] as num).toInt(),
  dynamicPriceStatus: (json['dynamic_price_status'] as num).toInt(),
  title: json['title'] as String,
  quantity: (json['quantity'] as num).toInt(),
  fileName: json['file_name'] as String,
  url: json['url'] as String,
  prices: (json['prices'] as List<dynamic>?)
      ?.map((e) => PricesProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductStoreToJson(ProductStore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'vendor_code': instance.vendorCode,
      'status': instance.status,
      'dynamic_price_status': instance.dynamicPriceStatus,
      'title': instance.title,
      'quantity': instance.quantity,
      'file_name': instance.fileName,
      'url': instance.url,
      'prices': instance.prices,
    };
