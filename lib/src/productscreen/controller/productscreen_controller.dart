import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';
import '../../homescreen/model/homescreen_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../placeorder_screen/view/placeorderscreen_view.dart';
import '../model/productscreen_model.dart';

class ProductScreenController extends GetxController {
  StoreModel store = StoreModel(
      rate: [],
      address: "",
      image: "",
      name: "",
      id: "",
      geopointid: "",
      location: []);
  RxDouble final_rate = 0.0.obs;

  RxBool isLoading = true.obs;
  final CollectionReference productsReference =
      FirebaseFirestore.instance.collection('products');
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxInt item_count = 0.obs;
  RxBool isShow = false.obs;
  String? product_id;
  AutoScrollController scrollController = AutoScrollController();
  @override
  void onInit() async {
    store = await Get.arguments['store'];
    product_id = await Get.arguments['product_id'];
    await getProducts();
    getRate();
    isLoading(false);
    sync_products_to_cart();
    if (product_id != null) {
      jump_to_popular_products();
    }
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getRate() {
    double rate_total = 0.0;
    var rates = store.rate;
    for (var i = 0; i < rates.length; i++) {
      rate_total = rate_total + rates[i].rate;
    }
    final_rate.value = rate_total / rates.length;
  }

  jump_to_popular_products() async {
    for (var i = 0; i < productList.length; i++) {
      if (product_id == productList[i].productId) {
        await Future.delayed(Duration(milliseconds: 500), () {
          scrollController.scrollToIndex(i,
              preferPosition: AutoScrollPosition.middle);
        });
      }
    }
  }

  getProducts() async {
    List data = [];
    try {
      var userDocumentReference =
          await FirebaseFirestore.instance.collection('store').doc(store.id);
      await productsReference
          .where('product_store_id', isEqualTo: userDocumentReference)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Map elementData = {
            "product_id": element.id,
            "product_image": element['product_image'],
            "product_price": element['product_price'],
            "product_name": element['product_name'],
          };
          data.add(elementData);
        });
      });
      var encodedData = await jsonEncode(data);

      productList.assignAll(await productModelFromJson(encodedData));
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  sync_products_to_cart() async {
    if (Get.find<StorageServices>().storage.read("cart") == null) {
    } else {
      List cartList = Get.find<StorageServices>().storage.read("cart");
      for (var i = 0; i < productList.length; i++) {
        for (var x = 0; x < cartList.length; x++) {
          if (productList[i].productId == cartList[x]['product_id'] &&
              cartList[x]['store_id'] == store.id) {
            productList[i].quantity.value = cartList[x]['product_quantity'];
          }
        }
        item_count.value = item_count.value + productList[i].quantity.value;
      }
      if (item_count.value > 0) {
        isShow.value = true;
      }
    }
  }

  increment_quantity({required String id}) async {
    for (var i = 0; i < productList.length; i++) {
      if (productList[i].productId == id) {
        productList[i].quantity.value++;
        item_count.value++;
        isShow.value = true;
      }
    }
  }

  decrement_quantity({required String id}) async {
    for (var i = 0; i < productList.length; i++) {
      if (productList[i].productId == id) {
        if (productList[i].quantity.value > 0) {
          productList[i].quantity.value--;
          item_count.value--;
          if (item_count.value <= 0) {
            isShow.value = false;
          }
        }
      }
    }
  }

  navigate_to_place_order() async {
    RxList<ProductModel> orders = <ProductModel>[].obs;
    for (var i = 0; i < productList.length; i++) {
      if (productList[i].quantity.value > 0) {
        orders.add(productList[i]);
      }
    }
    Get.to(() => PlaceOrderScreenView(),
        arguments: {"orders": orders, "store_id": store.id});
  }

  add_to_cart() async {
    if (Get.find<StorageServices>().storage.read("cart") == null) {
      List cartList = [];
      for (var i = 0; i < productList.length; i++) {
        if (productList[i].quantity.value > 0) {
          Map dataMap = {
            "store_id": store.id,
            "product_id": productList[i].productId,
            "product_name": productList[i].productName,
            "product_price": productList[i].productPrice,
            "product_quantity": productList[i].quantity.value,
            "product_image": productList[i].productImage
          };
          cartList.add(dataMap);
        }
      }
      Get.find<StorageServices>().save_to_cart(cartList: cartList);
    } else {
      List cartList = Get.find<StorageServices>().storage.read("cart");
      for (var i = 0; i < productList.length; i++) {
        bool isExist = false;
        for (var x = 0; x < cartList.length; x++) {
          if (productList[i].quantity.value > 0) {
            if (cartList[x]['store_id'] == store.id &&
                cartList[x]['product_id'] == productList[i].productId) {
              productList[i].quantity.value = cartList[x]['product_quantity'];
              isExist = true;
            }
          }
        }
        if (isExist == false && productList[i].quantity.value > 0) {
          Map dataMap = {
            "store_id": store.id,
            "product_id": productList[i].productId,
            "product_name": productList[i].productName,
            "product_price": productList[i].productPrice,
            "product_quantity": productList[i].quantity.value,
            "product_image": productList[i].productImage
          };
          cartList.add(dataMap);
        }
      }
      Get.find<StorageServices>().save_to_cart(cartList: cartList);
    }
    Get.back();
    if (Get.isRegistered<HomeScreenController>() == true) {
      Get.find<HomeScreenController>().getCartItemCount();
    }
  }

  addRating({required double rate}) async {
    var isUserExist = await FirebaseFirestore.instance
        .collection('store')
        .doc(store.id)
        .collection('rate')
        .where('userid',
            isEqualTo: Get.find<StorageServices>().storage.read('id'))
        .get();
    if (isUserExist.docs.length == 0) {
      await FirebaseFirestore.instance
          .collection('store')
          .doc(store.id)
          .collection('rate')
          .add({
        "rate": rate,
        "userid": Get.find<StorageServices>().storage.read('id').toString()
      });
    } else {
      await FirebaseFirestore.instance
          .collection('store')
          .doc(store.id)
          .collection('rate')
          .doc(isUserExist.docs[0].id)
          .update({"rate": rate});
    }
    Get.back();
  }
}
