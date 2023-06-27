import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/orderdetail_screen_model.dart';

class OrderDetailScreenController extends GetxController {
  RxString order_id = ''.obs;
  RxString order_Delivery_fee = ''.obs;
  RxString order_subtotal = ''.obs;
  RxString order_total = ''.obs;
  RxString order_status = ''.obs;
  RxString store_id = ''.obs;
  RxString driver_id = ''.obs;
  RxBool hasMessage = false.obs;
  RxList<OrderDetailModel> orderDetails_list = <OrderDetailModel>[].obs;
  @override
  void onInit() async {
    order_id.value = await Get.arguments['order_id'];
    order_Delivery_fee.value = await Get.arguments['order_Delivery_fee'];
    store_id.value = await Get.arguments['store_id'];
    order_subtotal.value = await Get.arguments['order_subtotal'];

    order_total.value = await Get.arguments['order_total'];
    order_status.value = await Get.arguments['order_status'];
    hasMessage.value = await Get.arguments['hasMessage'];

    getOrderDetails();

    if (order_status.value == "On Delivery") {
      getOrderStatus();
    }
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getOrderStatus() async {
    try {
      var orderDetail = await FirebaseFirestore.instance
          .collection('orders')
          .doc(order_id.value)
          .get();
      order_status.value = orderDetail.get('order_status');
      driver_id.value = orderDetail.get('driver');
    } on Exception catch (e) {
      print(e);
    }
  }

  getOrderDetails() async {
    List data = [];
    try {
      await FirebaseFirestore.instance
          .collection('order_products')
          .where('order_id', isEqualTo: order_id.value)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Map elementData = {
            "id": element.id,
            "order_id": element['order_id'],
            "product_id": element['product_id'],
            "product_image": element['product_image'],
            "product_name": element['product_name'],
            "product_price": element['product_price'],
            "product_qty": element['product_qty'],
            "product_store": element['product_store'].id,
          };
          data.add(elementData);
        });
      });
      var encodedData = await jsonEncode(data);
      orderDetails_list.assignAll(await orderDetailModelFromJson(encodedData));
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
