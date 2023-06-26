// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

List<AddressModel> addressModelFromJson(String str) => List<AddressModel>.from(
    json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
  String id;
  String address;
  String contact;
  String name;
  bool set;
  List<double> latlng;

  AddressModel({
    required this.id,
    required this.address,
    required this.contact,
    required this.name,
    required this.set,
    required this.latlng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        address: json["address"],
        contact: json["contact"],
        name: json["name"],
        set: json["set"],
        latlng: List<double>.from(json["latlng"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "contact": contact,
        "name": name,
        "set": set,
        "latlng": List<dynamic>.from(latlng.map((x) => x)),
      };
}
