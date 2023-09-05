import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';

import '../../../services/location_services.dart';
import '../../homescreen/model/homescreen_model.dart';

class SearchScreenController extends GetxController {
  RxString keyword = ''.obs;
  RxList<StoreModel> searched_Store = <StoreModel>[].obs;
  RxList<StoreModel> searched_Store_masterList = <StoreModel>[].obs;
  Timer? debounce;

  RxDouble radius = Get.find<HomeScreenController>().setRadius;

  @override
  void onInit() async {
    keyword.value = await Get.arguments['keyword'];
    getStoreSearch();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getStoreSearch() async {
    List data = [];
    List dataMasterList = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      GeoFirestore geoFirestore = GeoFirestore(firestore.collection('store'));
      final curreny_location_static_for_now = GeoPoint(
          Get.find<LocationServices>().locationData!.latitude!,
          Get.find<LocationServices>().locationData!.longitude!);

      List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(
          curreny_location_static_for_now, radius.value);
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
          if (document
              .get('name')
              .toString()
              .toLowerCase()
              .toString()
              .contains(keyword.value.toString().toLowerCase().toLowerCase())) {
            data.add(elementData);
          }
          dataMasterList.add(elementData);
        }
      });
      var encodedData = jsonEncode(data);
      var encodedDataMasterList = await jsonEncode(dataMasterList);
      searched_Store.assignAll(await storeModelFromJson(encodedData));
      searched_Store_masterList
          .assignAll(await storeModelFromJson(encodedDataMasterList));
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  search_in_screen({required String keyword}) async {
    searched_Store.clear();
    for (var i = 0; i < searched_Store_masterList.length; i++) {
      if (searched_Store_masterList[i]
          .name
          .toLowerCase()
          .toString()
          .contains(keyword)) {
        searched_Store.add(searched_Store_masterList[i]);
      }
    }
  }
}
