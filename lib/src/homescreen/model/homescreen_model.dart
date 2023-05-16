// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

List<StoreModel> storeModelFromJson(String str) =>
    List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

String storeModelToJson(List<StoreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreModel {
  String id;

  String image;
  String address;
  String name;

  StoreModel({
    required this.id,
    required this.image,
    required this.address,
    required this.name,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        image: json["image"],
        address: json["address"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "address": address,
        "name": name,
        "id": id,
      };
}
