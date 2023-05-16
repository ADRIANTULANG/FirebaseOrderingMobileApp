// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

List<OrderDetailModel> orderDetailModelFromJson(String str) =>
    List<OrderDetailModel>.from(
        json.decode(str).map((x) => OrderDetailModel.fromJson(x)));

String orderDetailModelToJson(List<OrderDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderDetailModel {
  String id;
  String orderId;
  String productId;
  String productImage;
  String productName;
  double productPrice;
  double productQty;
  String productStore;

  OrderDetailModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productQty,
    required this.productStore,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        id: json["id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        productImage: json["product_image"],
        productName: json["product_name"],
        productPrice: double.parse(json["product_price"].toString()),
        productQty: double.parse(json["product_qty"].toString()),
        productStore: json["product_store"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "product_id": productId,
        "product_image": productImage,
        "product_name": productName,
        "product_price": productPrice,
        "product_qty": productQty,
        "product_store": productStore,
      };
}
