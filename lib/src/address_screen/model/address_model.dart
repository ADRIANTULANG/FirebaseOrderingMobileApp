// To parse this JSON data, do
//
//     final UserAddress = UserAddressFromJson(jsonString);

import 'dart:convert';

List<UserAddress> userAddressFromJson(String str) => List<UserAddress>.from(
    json.decode(str).map((x) => UserAddress.fromJson(x)));

String userAddressToJson(List<UserAddress> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserAddress {
  String id;
  String address;
  String contact;
  String name;
  bool set;

  UserAddress({
    required this.id,
    required this.set,
    required this.address,
    required this.contact,
    required this.name,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json["id"],
        address: json["address"],
        contact: json["contact"],
        name: json["name"],
        set: json["set"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "contact": contact,
        "name": name,
        "set": set,
      };
}
