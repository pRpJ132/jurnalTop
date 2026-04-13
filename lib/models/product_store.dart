import 'package:json_annotation/json_annotation.dart';
part 'product_store.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PricesProduct {
  final int pointTypeId;
  final int pointsSum;

  PricesProduct({
    required this.pointTypeId,
    required this.pointsSum,
  });

  factory PricesProduct.fromJson(Map<String, dynamic> json) =>
      _$PricesProductFromJson(json);

  Map<String, dynamic> toJson() => _$PricesProductToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductStore {
  final int id;
  final String description;
  final String vendorCode;
  final int status;
  final int dynamicPriceStatus;
  final String title;
  int quantity;
  final String fileName;
  final String url;
  List<PricesProduct>? prices;

  ProductStore({
    required this.id,
    required this.description,
    required this.vendorCode,
    required this.status,
    required this.dynamicPriceStatus,
    required this.title,
    required this.quantity,
    required this.fileName,
    required this.url,
    this.prices,
  });

  factory ProductStore.fromJson(Map<String, dynamic> json) =>
      _$ProductStoreFromJson(json);

  Map<String, dynamic> toJson() => _$ProductStoreToJson(this);

  ProductStore copyWith({
    int? id,
    String? description,
    String? vendorCode,
    int? status,
    int? dynamicPriceStatus,
    String? title,
    int? quantity,
    String? fileName,
    String? url,
    List<PricesProduct>? prices,
  }) {
    return ProductStore(
      id: id ?? this.id,
      description: description ?? this.description,
      vendorCode: vendorCode ?? this.vendorCode,
      status: status ?? this.status,
      dynamicPriceStatus: dynamicPriceStatus ?? this.dynamicPriceStatus,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      prices: prices ?? this.prices,
    );
  }
}