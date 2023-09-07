// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

List<StoreModel> storeModelFromJson(String str) =>
    List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

String storeModelToJson(List<StoreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreModel {
  String image;
  String name;
  String address;
  String id;
  String geopointid;
  List<double> location;
  List<Rate> rate;

  StoreModel({
    required this.image,
    required this.name,
    required this.address,
    required this.id,
    required this.geopointid,
    required this.location,
    required this.rate,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        image: json["image"],
        name: json["name"],
        address: json["address"],
        id: json["id"],
        geopointid: json["geopointid"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        rate: List<Rate>.from(json["rate"].map((x) => Rate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "address": address,
        "id": id,
        "geopointid": geopointid,
        "location": List<dynamic>.from(location.map((x) => x)),
        "rate": List<dynamic>.from(rate.map((x) => x.toJson())),
      };
}

class Rate {
  double rate;
  String userid;
  String id;

  Rate({
    required this.rate,
    required this.userid,
    required this.id,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        rate: json["rate"].toDouble(),
        userid: json["userid"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "userid": userid,
        "id": id,
      };
}
