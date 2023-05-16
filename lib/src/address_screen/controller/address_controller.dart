import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/placeorder_screen/controller/placeorderscreen_controller.dart';

import '../../../services/getstorage_services.dart';
import '../model/address_model.dart';

class AddressController extends GetxController {
  RxList<UserAddress> customer_Address = <UserAddress>[].obs;
  @override
  void onInit() {
    getAddress();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getAddress() async {
    List data = [];
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      await FirebaseFirestore.instance
          .collection('address')
          .where('user', isEqualTo: userDocumentReference)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Map elementData = {
            "id": element.id,
            "address": element['address'],
            "contact": element['contact'],
            "name": element['name'],
            "set": element['set'],
          };
          data.add(elementData);
        });
      });
      var encodedData = await jsonEncode(data);
      customer_Address.assignAll(await userAddressFromJson(encodedData));
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  set_Address(
      {required String addressID,
      required String name,
      required String address,
      required String contact}) async {
    var userDocumentReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read("id"));
    final addressBatchRef = await FirebaseFirestore.instance
        .collection('address')
        .where("user", isEqualTo: userDocumentReference)
        .get();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (final address in addressBatchRef.docs) {
      batch.update(address.reference, {'set': false});
    }
    await batch.commit();
    await FirebaseFirestore.instance
        .collection('address')
        .doc(addressID)
        .update({"set": true});
    getAddress();
    if (Get.isRegistered<PlaceOrderScreenController>() == true) {
      print("age dre");
      Get.find<PlaceOrderScreenController>().address_contact.value = contact;
      Get.find<PlaceOrderScreenController>().address_name.value = name;
      Get.find<PlaceOrderScreenController>().address_full.value = address;
      Get.back();
    }
  }

  add_Address(
      {required String name,
      required String contact,
      required String full_Address}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      await FirebaseFirestore.instance.collection("address").add({
        "address": full_Address,
        "contact": contact,
        "name": name,
        "set": false,
        "user": userDocumentReference
      });

      getAddress();
      Get.back();
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
