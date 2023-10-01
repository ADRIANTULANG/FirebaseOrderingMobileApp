import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/services/location_services.dart';
import 'package:orderingapp/src/homescreen/widget/homescreen_home.dart';
import 'package:orderingapp/src/homescreen/widget/homescreen_map.dart';
import 'package:orderingapp/src/homescreen/widget/homescreen_orders.dart';
import 'package:sizer/sizer.dart';

import '../../loginscreen/view/loginscreen_view.dart';
import '../../productscreen/view/productscreen_view.dart';
import '../model/homescreen_model.dart';
import '../model/homescreen_model_order.dart';
import '../model/homescreen_model_popular_products.dart';
import '../widget/homescreen_alertdialog.dart';

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
      setRadius.value = double.parse(radius[i].get('radius').toString());
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
      for (var i = 0; i < documents.length; i++) {
        var query = await FirebaseFirestore.instance
            .collection('store')
            .doc(documents[i].id)
            .collection('rate')
            .get();
        List rateList = [];
        for (var x = 0; x < query.docs.length; x++) {
          Map rateListMap = query.docs[x].data();
          rateListMap['id'] = query.docs[x].id;
          rateList.add(rateListMap);
        }
        Map elementData = {
          "image": documents[i].get('image'),
          "name": documents[i].get('name'),
          "address": documents[i].get('address'),
          "id": documents[i].id,
          "geopointid": documents[i].get('g'),
          "location": documents[i].get('l'),
          "rate": rateList,
        };
        data.add(elementData);
      }
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
      final current_location = GeoPoint(
          Get.find<LocationServices>().locationData!.latitude!,
          Get.find<LocationServices>().locationData!.longitude!);

      List<DocumentSnapshot> documents =
          await geoFirestore.getAtLocation(current_location, setRadius.value);
      for (var i = 0; i < documents.length; i++) {
        if (documents[i].get("popular") == true) {
          var query = await FirebaseFirestore.instance
              .collection('store')
              .doc(documents[i].id)
              .collection('rate')
              .get();
          List rateList = [];
          for (var x = 0; x < query.docs.length; x++) {
            Map rateListMap = query.docs[x].data();
            rateListMap['id'] = query.docs[x].id;
            rateList.add(rateListMap);
          }
          Map elementData = {
            "image": documents[i].get('image'),
            "name": documents[i].get('name'),
            "address": documents[i].get('address'),
            "id": documents[i].id,
            "geopointid": documents[i].get('g'),
            "location": documents[i].get('l'),
            "rate": rateList,
          };
          data.add(elementData);
        }
      }
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
    var storeDetail =
        await FirebaseFirestore.instance.collection('store').doc(storeID).get();
    List<StoreModel> storeTempList = <StoreModel>[];
    var query = await FirebaseFirestore.instance
        .collection('store')
        .doc(storeDetail.id)
        .collection('rate')
        .get();
    List rateList = [];
    for (var x = 0; x < query.docs.length; x++) {
      Map rateListMap = query.docs[x].data();
      rateListMap['id'] = query.docs[x].id;
      rateList.add(rateListMap);
    }
    storeTempList.assignAll(await storeModelFromJson(jsonEncode([
      {
        "image": storeDetail.get('image'),
        "name": storeDetail.get('name'),
        "address": storeDetail.get('address'),
        "id": storeDetail.id,
        "geopointid": storeDetail.get('g'),
        "location": storeDetail.get('l'),
        "rate": rateList
      }
    ])));
    if (storeTempList.isNotEmpty || storeTempList.length > 0) {
      Get.to(() => ProductScreenView(),
          arguments: {"store": storeTempList[0], "product_id": product_id});
    }
  }

  logout() async {
    Get.find<StorageServices>().removeStorageCredentials();
    Get.offAll(() => LoginScreenView());
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      await GoogleSignIn().signOut();
    } else {}
  }

  on_will_pop_navigation({required HomeScreenController controller}) async {
    if (pageindex.value == 0) {
      HomeScreenAlertDialog.showLogoutConfirmation(controller: controller);
    } else {
      pageindex.value = pageindex.value - 1;
    }
  }

  RxString getRate({required List<Rate> rates}) {
    double rate_total = 0.0;
    double final_rate = 0.0;
    for (var i = 0; i < rates.length; i++) {
      rate_total = rate_total + rates[i].rate;
    }
    final_rate = rate_total / rates.length;
    return final_rate.toString().obs;
  }

  // setRate() async {
  //   try {
  //     var res = await FirebaseFirestore.instance.collection('store').get();
  //     WriteBatch batch = FirebaseFirestore.instance.batch();
  //     for (final store in res.docs) {
  //       final DocumentReference storeDocRef = store.reference;
  //       final CollectionReference rateCollection =
  //           storeDocRef.collection('sample');
  //       rateCollection.add({"rates": "", "userid": ""});
  //       // final rateDocRef = rateCollection.doc();
  //       // await rateDocRef.update({});
  //       // batch.update(storeDocRef, {'rate': rateDocRef});
  //     }
  //     await batch.commit();
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  // setsubcollection() async {
  //   var res = await FirebaseFirestore.instance.collection("store").add({
  //     "address": "",
  //     "image": "",
  //     "name": "",
  //     "password": "",
  //     "popular": false,
  //     "username": "",
  //   });
  //   final CollectionReference rateCollection = res.collection('rates');
  //   rateCollection.add({"rate": 0.0, "userid": ""});
  // }
}
