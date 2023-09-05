import 'dart:convert';

import 'package:get/get.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';

import '../model/cart_screen_model.dart';
import '../widget/cart_screen_alertdialog.dart';

class CartScreenController extends GetxController {
  RxList<CartModel> cart = <CartModel>[].obs;
  @override
  void onInit() {
    getCartItems();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getCartItems() async {
    if (Get.find<StorageServices>().storage.read("cart") != null) {
      List cartList = Get.find<StorageServices>().storage.read("cart");
      // print(jsonEncode(cartList));
      cart.assignAll(await cartModelFromJson(await jsonEncode(cartList)));
    }
  }

  increment_quantity({required String id}) async {
    for (var i = 0; i < cart.length; i++) {
      if (cart[i].productId == id) {
        cart[i].productQuantity.value++;
      }
    }
  }

  decrement_quantity({required String id}) async {
    for (var i = 0; i < cart.length; i++) {
      if (cart[i].productId == id) {
        if (cart[i].productQuantity.value > 0) {
          cart[i].productQuantity.value--;
          if (cart[i].productQuantity.value <= 0) {
            cart.removeWhere((element) => element.productId == id);
          }
        }
      }
    }
  }

  save_cart() async {
    List cartList = [];
    for (var i = 0; i < cart.length; i++) {
      Map dataMap = {
        "store_id": cart[i].storeId,
        "product_id": cart[i].productId,
        "product_name": cart[i].productName,
        "product_price": cart[i].productPrice,
        "product_quantity": cart[i].productQuantity.value,
        "product_image": cart[i].productImage,
      };
      cartList.add(dataMap);
    }
    Get.find<StorageServices>().save_to_cart(cartList: cartList);
    await CartScreenAlertDialog.showSuccessSavingCart();
    if (Get.isRegistered<HomeScreenController>()) {
      Get.find<HomeScreenController>().getCartItemCount();
    }
  }
}
