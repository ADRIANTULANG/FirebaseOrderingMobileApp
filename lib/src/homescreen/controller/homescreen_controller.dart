import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/services/location_services.dart';
import 'package:orderingapp/src/homescreen/widget/homescreen_home.dart';
import 'package:orderingapp/src/homescreen/widget/homescreen_map.dart';
import 'package:orderingapp/src/homescreen/widget/homescreen_orders.dart';
import 'package:sizer/sizer.dart';

import '../model/homescreen_model.dart';
import '../model/homescreen_model_order.dart';

class HomeScreenController extends GetxController {
  final CollectionReference storesReference =
      FirebaseFirestore.instance.collection('store');

  RxList<StoreModel> storeList = <StoreModel>[].obs;
  RxList<StoreModel> storeListPopular = <StoreModel>[].obs;
  RxList<OrderModel> orderList = <OrderModel>[].obs;

  TextEditingController searchController = TextEditingController();

  RxInt cartCount = 0.obs;
  Timer? debounce;
  RxInt pageindex = 0.obs;

  final Completer<GoogleMapController> googleMapController = Completer();

  GoogleMapController? camera_controller;

  RxList<Marker> marker = <Marker>[].obs;
  @override
  void onInit() {
    getStores();
    getStoresPopular();
    getOrders();
    getCartItemCount();
    super.onInit();
  }

  List<Widget> screens = [
    HomeScreenHome(),
    HomeScreenMap(),
    HomeScreenOrders()
  ];

  @override
  void onClose() {
    super.onClose();
  }

  getCartItemCount() async {
    if (Get.find<StorageServices>().storage.read('cart') != null) {
      List cartList = Get.find<StorageServices>().storage.read('cart');
      cartCount.value = cartList.length;
    }
  }

  getStores() async {
    List data = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      GeoFirestore geoFirestore = GeoFirestore(firestore.collection('store'));
      final curreny_location_static_for_now = GeoPoint(
          Get.find<LocationServices>().locationData!.latitude!,
          Get.find<LocationServices>().locationData!.longitude!);

      List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(
          curreny_location_static_for_now, 0.6);
      documents.forEach((document) {
        if (document.data() != null) {
          Map elementData = {
            "image": document.get('image'),
            "name": document.get('name'),
            "address": document.get('address'),
            "id": document.id,
            "geopointid": document.get('g'),
            "location": document.get('l'),
          };
          data.add(elementData);
        }
      });
      var encodedData = jsonEncode(data);
      storeList.assignAll(await storeModelFromJson(encodedData));
      marker.clear();
      for (var i = 0; i < storeList.length; i++) {
        marker.add(Marker(
            position:
                LatLng(storeList[i].location[0], storeList[i].location[1]),
            markerId: MarkerId(storeList[i].id.toString()),
            infoWindow: InfoWindow(title: storeList[i].name)));
      }
      marker.add(Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: LatLng(8.244297997423898, 124.25594209192478),
          markerId: MarkerId("My Location"),
          infoWindow: InfoWindow(title: "My Location")));
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  animateToStoreLocation({required LatLng latlng}) async {
    var coordinate1 = LatLng(
        Get.find<LocationServices>().locationData!.latitude!,
        Get.find<LocationServices>().locationData!.longitude!);
    var coordinate2 = latlng;
    double minLat = coordinate1.latitude < coordinate2.latitude
        ? coordinate1.latitude
        : coordinate2.latitude;
    double maxLat = coordinate1.latitude > coordinate2.latitude
        ? coordinate1.latitude
        : coordinate2.latitude;
    double minLng = coordinate1.longitude < coordinate2.longitude
        ? coordinate1.longitude
        : coordinate2.longitude;
    double maxLng = coordinate1.longitude > coordinate2.longitude
        ? coordinate1.longitude
        : coordinate2.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    await camera_controller!
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 15.h));
  }

  getStoresPopular() async {
    List data = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      GeoFirestore geoFirestore = GeoFirestore(firestore.collection('store'));
      final curreny_location_static_for_now = GeoPoint(
          Get.find<LocationServices>().locationData!.latitude!,
          Get.find<LocationServices>().locationData!.longitude!);

      List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(
          curreny_location_static_for_now, 0.6);
      documents.forEach((document) {
        if (document.data() != null) {
          if (document.get("popular") == true) {
            Map elementData = {
              "image": document.get('image'),
              "name": document.get('name'),
              "address": document.get('address'),
              "id": document.id,
              "geopointid": document.get('g'),
              "location": document.get('l'),
            };
            data.add(elementData);
          }
        }
      });
      var encodedData = jsonEncode(data);
      storeListPopular.assignAll(await storeModelFromJson(encodedData));
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  getOrders() async {
    List data = [];
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      var ordersData = await FirebaseFirestore.instance
          .collection("orders")
          .where("customer_id", isEqualTo: userDocumentReference)
          .where("order_status", whereIn: [
        'Pending',
        'Preparing',
        'Accepted',
        'Checkout',
        'On Delivery'
      ]).get();
      for (var i = 0; i < ordersData.docs.length; i++) {
        var storeData = await FirebaseFirestore.instance
            .collection("store")
            .doc(ordersData.docs[i]['order_store_id'].id)
            .get();
        var itemsOrdered = await FirebaseFirestore.instance
            .collection("order_products")
            .where("order_id", isEqualTo: ordersData.docs[i].id)
            .get();
        Map elementData = {
          "id": ordersData.docs[i].id,
          "customer_id": ordersData.docs[i]['customer_id'].id,
          "delivery_fee": ordersData.docs[i]['delivery_fee'],
          "order_status": ordersData.docs[i]['order_status'],
          "order_store_id": ordersData.docs[i]['order_store_id'].id,
          "order_subtotal": ordersData.docs[i]['order_subtotal'],
          "order_total": ordersData.docs[i]['order_total'],
          "store_details": storeData.data(),
          "item_count_in_order": itemsOrdered.docs.length
        };
        data.add(elementData);
      }

      var encodedData = await jsonEncode(data);
      orderList.assignAll(await orderModelFromJson(encodedData));
    } catch (e) {
      print(e.toString() + " ERROR");
    }
  }

  putMessageIdentifier({required String order_id}) async {
    for (var i = 0; i < orderList.length; i++) {
      if (order_id == orderList[i].id) {
        orderList[i].hasMessage.value = true;
      }
    }
  }
}
