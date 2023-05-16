// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  String id;
  String customerId;
  double deliveryFee;
  String orderStatus;
  String orderStoreId;
  double orderSubtotal;
  double orderTotal;
  StoreDetails storeDetails;
  int item_count_in_order;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.deliveryFee,
    required this.orderStatus,
    required this.orderStoreId,
    required this.orderSubtotal,
    required this.orderTotal,
    required this.storeDetails,
    required this.item_count_in_order,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        customerId: json["customer_id"],
        deliveryFee: json["delivery_fee"],
        orderStatus: json["order_status"],
        orderStoreId: json["order_store_id"],
        orderSubtotal: json["order_subtotal"],
        orderTotal: json["order_total"],
        item_count_in_order: json["item_count_in_order"],
        storeDetails: StoreDetails.fromJson(json["store_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "delivery_fee": deliveryFee,
        "order_status": orderStatus,
        "order_store_id": orderStoreId,
        "order_subtotal": orderSubtotal,
        "order_total": orderTotal,
        "item_count_in_order": item_count_in_order,
        "store_details": storeDetails.toJson(),
      };
}

class StoreDetails {
  String image;
  String address;
  String name;
  bool popular;

  StoreDetails({
    required this.image,
    required this.address,
    required this.name,
    required this.popular,
  });

  factory StoreDetails.fromJson(Map<String, dynamic> json) => StoreDetails(
        image: json["image"],
        address: json["address"],
        name: json["name"],
        popular: json["popular"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "address": address,
        "name": name,
        "popular": popular,
      };
}
