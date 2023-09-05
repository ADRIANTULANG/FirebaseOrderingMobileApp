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

import '../../productscreen/view/productscreen_view.dart';
import '../model/homescreen_model.dart';
import '../model/homescreen_model_order.dart';
import '../model/homescreen_model_popular_products.dart';

class HomeScreenController extends GetxController {
  final CollectionReference storesReference =
      FirebaseFirestore.instance.collection('store');

  RxList<StoreModel> storeList = <StoreModel>[].obs;
  RxList<StoreModel> storeListPopular = <StoreModel>[].obs;
  RxList<OrderModel> orderList = <OrderModel>[].obs;
  RxList<PopularProducts> popularProductsList = <PopularProducts>[].obs;
  TextEditingController searchController = TextEditingController();

  RxInt cartCount = 0.obs;
  Timer? debounce;
  RxInt pageindex = 0.obs;

  final Completer<GoogleMapController> googleMapController = Completer();

  GoogleMapController? camera_controller;

  RxList<Marker> marker = <Marker>[].obs;
  @override
  void onInit() async {
    await getRadius();
    getStores();
    getStoresPopular();
    getOrders();
    getCartItemCount();
    getPopularProducts();
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

  RxDouble setRadius = 0.0.obs;

  getRadius() async {
    var res = await FirebaseFirestore.instance
        .collection('radius')
        .where('isActive', isEqualTo: true)
        .get();
    var radius = res.docs;
    for (var i = 0; i < radius.length; i++) {
      setRadius.value = radius[i].get('radius');
    }
    print(setRadius.value);
  }

  getCartItemCount() async {
    if (Get.find<StorageServices>().storage.read('cart') != null) {
      List cartList = Get.find<StorageServices>().storage.read('cart');
      cartCount.value = cartList.length;
    }
  }

  getPopularProducts() async {
    var res = await FirebaseFirestore.instance
        .collection('products')
        .where('isPopular', isEqualTo: true)
        .get();
    var products = res.docs;
    List data = [];
    for (var product in products) {
      Map map = product.data();
      map['product_store_id'] = product.get('product_store_id').id;
      map['product_id'] = product.id;
      data.add(map);
    }
    popularProductsList
        .assignAll(await popularProductsFromJson(await jsonEncode(data)));
  }

  getStores() async {
    List data = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      GeoFirestore geoFirestore = GeoFirestore(firestore.collection('store'));
      final curreny_location = GeoPoint(
          Get.find<LocationServices>().locationData!.latitude!,
          Get.find<LocationServices>().locationData!.longitude!);

      List<DocumentSnapshot> documents =
          await geoFirestore.getAtLocation(curreny_location, setRadius.value);
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
          position: LatLng(Get.find<LocationServices>().locationData!.latitude!,
              Get.find<LocationServices>().locationData!.longitude!),
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

  get_store_details_navigate_to_store_product_screen(
      {required String storeID, required String product_id}) async {
    print(storeID);
    print(product_id);
    var storeDetail =
        await FirebaseFirestore.instance.collection('store').doc(storeID).get();
    List<StoreModel> storeTempList = <StoreModel>[];
    storeTempList.assignAll(await storeModelFromJson(jsonEncode([
      {
        "image": storeDetail.get('image'),
        "name": storeDetail.get('name'),
        "address": storeDetail.get('address'),
        "id": storeDetail.id,
        "geopointid": storeDetail.get('g'),
        "location": storeDetail.get('l'),
      }
    ])));
    if (storeTempList.isNotEmpty || storeTempList.length > 0) {
      Get.to(() => ProductScreenView(),
          arguments: {"store": storeTempList[0], "product_id": product_id});
    }
  }
}
