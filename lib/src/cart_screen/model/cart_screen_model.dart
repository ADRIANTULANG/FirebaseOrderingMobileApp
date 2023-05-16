// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<CartModel> cartModelFromJson(String str) =>
    List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  String storeId;
  String productId;
  String productName;
  double productPrice;
  RxInt productQuantity;
  String productImage;

  CartModel({
    required this.storeId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productImage,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        storeId: json["store_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        productPrice: double.parse(json["product_price"].toString()),
        productQuantity: int.parse(json["product_quantity"].toString()).obs,
        productImage: json["product_image"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_quantity": productQuantity,
        "product_image": productImage,
      };
}
