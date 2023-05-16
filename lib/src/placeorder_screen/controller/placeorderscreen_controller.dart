import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';
import 'package:orderingapp/src/productscreen/controller/productscreen_controller.dart';
import 'package:orderingapp/src/search_screen/controller/search_screen_controller.dart';

import '../../homescreen/widget/homescreen_alertdialog.dart';
import '../../productscreen/model/productscreen_model.dart';
import '../model/placeorder_screen_address_model.dart';

class PlaceOrderScreenController extends GetxController {
  RxList<ProductModel> orders = <ProductModel>[].obs;
  RxList<AddressModel> customer_Address = <AddressModel>[].obs;
  double deliveryFee = 50.0;
  RxString address_name = ''.obs;
  RxString address_contact = ''.obs;
  RxString address_full = ''.obs;
  RxString store_id = ''.obs;

  @override
  void onInit() async {
    var dataorders = await Get.arguments['orders'];
    store_id.value = await Get.arguments['store_id'];
    orders.assignAll(dataorders);
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
      customer_Address.assignAll(await addressModelFromJson(encodedData));

      if (customer_Address.isNotEmpty) {
        for (var i = 0; i < customer_Address.length; i++) {
          if (customer_Address[i].set == true) {
            address_name.value = customer_Address[i].name;
            address_contact.value = customer_Address[i].contact;
            address_full.value = customer_Address[i].address;
          }
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  increment_quantity({required String id}) async {
    for (var i = 0; i < orders.length; i++) {
      if (orders[i].productId == id) {
        orders[i].quantity.value++;
        Get.find<ProductScreenController>().item_count++;
        Get.find<ProductScreenController>().isShow.value = true;
      }
    }
  }

  decrement_quantity({required String id}) async {
    for (var i = 0; i < orders.length; i++) {
      if (orders[i].productId == id) {
        if (orders[i].quantity.value > 0) {
          orders[i].quantity.value--;
          Get.find<ProductScreenController>().item_count.value--;
          if (Get.find<ProductScreenController>().item_count.value <= 0) {
            Get.find<ProductScreenController>().isShow.value = false;
          }
        }
      }
    }
  }

  RxDouble total_amount() {
    double total = 0.0;
    for (var i = 0; i < orders.length; i++) {
      total = total + (orders[i].quantity.value * orders[i].productPrice);
    }
    total = total + deliveryFee;
    return total.obs;
  }

  RxDouble subtotal_amount() {
    double total = 0.0;
    for (var i = 0; i < orders.length; i++) {
      total = total + (orders[i].quantity.value * orders[i].productPrice);
    }
    return total.obs;
  }

  add_Address(
      {required String name,
      required String contact,
      required String full_Address}) async {
    try {
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
      await FirebaseFirestore.instance.collection("address").add({
        "address": full_Address,
        "contact": contact,
        "name": name,
        "user": userDocumentReference,
        "set": true
      });
      Get.back();
      getAddress();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  place_order() async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      var storeDocumentReference = await FirebaseFirestore.instance
          .collection('store')
          .doc(store_id.value);
      var orderDocRef =
          await FirebaseFirestore.instance.collection("orders").add({
        "customer_id": userDocumentReference,
        "delivery_fee": deliveryFee,
        "order_status": "Pending",
        "order_store_id": storeDocumentReference,
        "order_subtotal": subtotal_amount().value,
        "order_total": total_amount().value
      });

      for (var i = 0; i < orders.length; i++) {
        if (orders[i].quantity.value > 0) {
          await FirebaseFirestore.instance.collection('order_products').add({
            "order_id": orderDocRef.id,
            "product_id": orders[i].productId,
            "product_image": orders[i].productImage,
            "product_name": orders[i].productName,
            "product_price": orders[i].productPrice,
            "product_qty": orders[i].quantity.value,
            "product_store": storeDocumentReference
          });
        }
      }
      Get.back();
      Get.back();
      if (Get.isRegistered<SearchScreenController>() == true) {
        Get.back();
      }
      if (Get.isRegistered<HomeScreenController>() == true) {
        HomeScreenAlertDialog.showSuccessOrderPlace();
        Get.find<HomeScreenController>().getOrders();

        if (Get.find<StorageServices>().storage.read("cart") != null) {
          List cartList = Get.find<StorageServices>().storage.read("cart");

          for (var i = 0; i < orders.length; i++) {
            for (var x = 0; x < cartList.length; x++) {
              if (cartList[x]['product_id'] == orders[i].productId &&
                  cartList[x]['store_id'] == store_id.value) {
                cartList[x]['product_quantity'] =
                    cartList[x]['product_quantity'] - orders[i].quantity.value;
              }
            }
          }
          cartList.removeWhere((element) => element['product_quantity'] == 0);
          Get.find<StorageServices>().save_to_cart(cartList: cartList);
          Get.find<HomeScreenController>().getCartItemCount();
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
