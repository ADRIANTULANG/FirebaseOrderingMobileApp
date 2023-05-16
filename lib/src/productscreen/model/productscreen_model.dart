// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String productId;
  String productImage;
  double productPrice;
  String productName;
  RxBool isSelected;
  RxInt quantity;

  ProductModel({
    required this.productImage,
    required this.productId,
    required this.productPrice,
    required this.productName,
    required this.isSelected,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      productImage: json["product_image"],
      productId: json["product_id"],
      productPrice: double.parse(json["product_price"].toString()),
      productName: json["product_name"],
      quantity: 0.obs,
      isSelected: false.obs);

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_image": productImage,
        "product_price": productPrice,
        "product_name": productName,
        "quantity": quantity,
        "isSelected": isSelected,
      };
}
