import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/getstorage_services.dart';
import '../model/chat_model.dart';

class ChatScreenController extends GetxController {
  RxString order_id = ''.obs;
  RxString store_id = ''.obs;
  Stream? streamChats;
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  StreamSubscription<dynamic>? listener;

  TextEditingController message = TextEditingController();
  @override
  void onInit() async {
    order_id.value = await Get.arguments['order_id'];
    store_id.value = await Get.arguments['store_id'];
    print(order_id.value);
    print(store_id.value);
    await listenToChanges();
    await getChat();
    super.onInit();
  }

  @override
  void onClose() {
    listener!.cancel();
    super.onClose();
  }

  listenToChanges() async {
    var userDocumentReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read("id"));
    var storeDocumentReference = await FirebaseFirestore.instance
        .collection('store')
        .doc(store_id.value);
    streamChats = await FirebaseFirestore.instance
        .collection("chat")
        .where("customer", isEqualTo: userDocumentReference)
        .where("store", isEqualTo: storeDocumentReference)
        .where("orderid", isEqualTo: order_id.value.toString())
        .snapshots();
  }

  getChat() async {
    try {
      listener = streamChats!.listen((event) async {
        List data = [];
        for (var chats in event.docs) {
          Map elementData = {
            "id": chats.id,
            "sender": chats['sender'],
            "message": chats['message'],
            "date": chats['date'].toDate().toString()
          };
          data.add(elementData);
        }
        var encodedData = await jsonEncode(data);
        chatList.assignAll(await chatModelFromJson(encodedData));
        chatList.sort((a, b) => a.date.compareTo(b.date));
      });
    } catch (e) {
      print(e.toString() + " eRROR");
    }
  }

  sendMessage({required String chat}) async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      var storeDocumentReference = await FirebaseFirestore.instance
          .collection('store')
          .doc(store_id.value);
      await FirebaseFirestore.instance.collection('chat').add({
        "customer": userDocumentReference,
        "date": Timestamp.now(),
        "message": chat,
        "orderid": order_id.value.toString(),
        "sender": "customer",
        "store": storeDocumentReference
      });
      message.clear();
    } catch (e) {}
  }
}
