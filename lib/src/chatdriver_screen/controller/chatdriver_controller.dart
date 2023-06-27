import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/getstorage_services.dart';
import '../model/chatdriver_model.dart';

class ChatDriverController extends GetxController {
  RxString order_id = ''.obs;
  RxString driver_id = ''.obs;
  Stream? streamChats;
  RxList<ChatDriverModel> chatList = <ChatDriverModel>[].obs;
  StreamSubscription<dynamic>? listener;

  TextEditingController message = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void onInit() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read("id"))
        .update({"online": true});
    order_id.value = await Get.arguments['order_id'];
    driver_id.value = await Get.arguments['driver_id'];
    print(order_id.value);
    print(driver_id.value);
    await listenToChanges();
    await getChat();
    super.onInit();
  }

  @override
  void onClose() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read("id"))
        .update({"online": false});
    listener!.cancel();
    super.onClose();
  }

  listenToChanges() async {
    var userDocumentReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read("id"));
    var driverDocumentReference = await FirebaseFirestore.instance
        .collection('driver')
        .doc(driver_id.value);
    streamChats = await FirebaseFirestore.instance
        .collection("chattodriver")
        .where("customer", isEqualTo: userDocumentReference)
        .where("driver", isEqualTo: driverDocumentReference)
        .where("orderid", isEqualTo: order_id.value.toString())
        .limit(100)
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
        chatList.assignAll(await chatDriverModelFromJson(encodedData));
        chatList.sort((a, b) => a.date.compareTo(b.date));
        Future.delayed(Duration(seconds: 1), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
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
      var driverDocumentReference = await FirebaseFirestore.instance
          .collection('driver')
          .doc(driver_id.value);

      var driverDetails = await driverDocumentReference.get();
      await FirebaseFirestore.instance.collection('chattodriver').add({
        "customer": userDocumentReference,
        "date": Timestamp.now(),
        "message": chat,
        "orderid": order_id.value.toString(),
        "sender": "customer",
        "driver": driverDocumentReference
      });
      message.clear();
      if (driverDetails.get('online') == false) {
        sendNotificationIfOffline(
            chat: chat,
            orderid: order_id.value.toString(),
            fcmToken: driverDetails.get('fcmToken'));
      }
      Future.delayed(Duration(seconds: 1), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    } catch (e) {}
  }

  sendNotificationIfOffline(
      {required String chat,
      required String orderid,
      required String fcmToken}) async {
    var body = jsonEncode({
      "to": "$fcmToken",
      "notification": {
        "body": chat,
        "title": 'Driver',
        "subtitle": "Tracking Order: $orderid",
      },
      "data": {"notif_from": "Chat", "value": "$orderid"},
    });
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          "Authorization":
              "key=AAAAFXgQldg:APA91bH0blj9KQykFmRZ1Pjub61SPwFyaq-YjvtH1vTvsOeNQ6PTWCYm5S7pOZIuB5zuc7hrFFYsRbuxEB8vF9N5nQoW9fZckjy4bwwltxf4ATPeBDH4L4VlZ1yyVBHF3OKr3yVZ_Ioy",
          "Content-Type": "application/json"
        },
        body: body);
  }
}
