import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../homescreen/model/homescreen_model.dart';

class SearchScreenController extends GetxController {
  RxString keyword = ''.obs;
  RxList<StoreModel> searched_Store = <StoreModel>[].obs;
  RxList<StoreModel> searched_Store_masterList = <StoreModel>[].obs;
  Timer? debounce;

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
      var storeData =
          await FirebaseFirestore.instance.collection('store').get();
      for (var i = 0; i < storeData.docs.length; i++) {
        Map elementData = {
          "image": storeData.docs[i]['image'],
          "name": storeData.docs[i]['name'],
          "address": storeData.docs[i]['address'],
          "id": storeData.docs[i].id,
        };
        if (storeData.docs[i]['name']
            .toString()
            .toLowerCase()
            .toString()
            .contains(keyword.value.toString().toLowerCase().toLowerCase())) {
          data.add(elementData);
        }
        dataMasterList.add(elementData);
      }
      var encodedData = await jsonEncode(data);
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
