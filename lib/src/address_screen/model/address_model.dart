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
  String geopointid;
  List<double> location;

  UserAddress({
    required this.id,
    required this.set,
    required this.address,
    required this.contact,
    required this.name,
    required this.geopointid,
    required this.location,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json["id"],
        address: json["address"],
        contact: json["contact"],
        name: json["name"],
        set: json["set"],
        geopointid: json["geopointid"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "contact": contact,
        "name": name,
        "set": set,
        "geopointid": geopointid,
        "location": List<dynamic>.from(location.map((x) => x)),
      };
}
