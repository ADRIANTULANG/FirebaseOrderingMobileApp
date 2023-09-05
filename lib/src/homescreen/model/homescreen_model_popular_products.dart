// To parse this JSON data, do
//
//     final popularProducts = popularProductsFromJson(jsonString);

import 'dart:convert';

List<PopularProducts> popularProductsFromJson(String str) =>
    List<PopularProducts>.from(
        json.decode(str).map((x) => PopularProducts.fromJson(x)));

String popularProductsToJson(List<PopularProducts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopularProducts {
  String productImage;
  bool isPopular;
  double productPrice;
  String productName;
  String productStoreId;
  String productId;

  PopularProducts({
    required this.productImage,
    required this.isPopular,
    required this.productPrice,
    required this.productName,
    required this.productStoreId,
    required this.productId,
  });

  factory PopularProducts.fromJson(Map<String, dynamic> json) =>
      PopularProducts(
        productImage: json["product_image"],
        isPopular: json["isPopular"],
        productPrice: json["product_price"].toDouble(),
        productName: json["product_name"],
        productStoreId: json["product_store_id"],
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_image": productImage,
        "isPopular": isPopular,
        "product_price": productPrice,
        "product_name": productName,
        "product_store_id": productStoreId,
        "product_id": productId,
      };
}
