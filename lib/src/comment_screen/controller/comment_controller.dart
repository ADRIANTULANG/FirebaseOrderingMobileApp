import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../services/getstorage_services.dart';
import '../../homescreen/model/homescreen_model.dart';
import '../model/comment_model.dart';

class CommentController extends GetxController {
  StoreModel store = StoreModel(
      rate: [],
      address: "",
      image: "",
      name: "",
      id: "",
      geopointid: "",
      location: []);
  RxBool isLoading = true.obs;

  RxList<Comments> commentList = <Comments>[].obs;

  @override
  void onInit() async {
    store = await Get.arguments['store'];
    await getComments();
    isLoading(false);

    super.onInit();
  }

  getComments() async {
    try {
      List data = [];
      var res = await FirebaseFirestore.instance
          .collection('comments')
          .where('storeID', isEqualTo: store.id)
          .orderBy('dateCreated', descending: true)
          .get();
      var commentResults = res.docs;
      for (var i = 0; i < commentResults.length; i++) {
        Map comment = commentResults[i].data();
        comment['id'] = commentResults[i].id;
        comment['dateCreated'] = comment['dateCreated'].toDate().toString();
        comment.remove('userRef');
        comment.remove('storeDocID');
        data.add(comment);
      }
      var jsonEncodedData = await jsonEncode(data);
      commentList.assignAll(await commentsFromJson(jsonEncodedData));
    } catch (e) {
      print(e);
    }
  }

  addComment({required String comment}) async {
    try {
      Get.back();
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      var storeDocumentReference =
          await FirebaseFirestore.instance.collection('store').doc(store.id);
      await FirebaseFirestore.instance.collection('comments').add({
        "userRef": userDocumentReference,
        "userDocID": Get.find<StorageServices>().storage.read("id"),
        "storeID": store.id,
        "storeDocID": storeDocumentReference,
        "userName":
            Get.find<StorageServices>().storage.read("firstname").toString() +
                " " +
                Get.find<StorageServices>().storage.read("lastname").toString(),
        "comment": comment,
        "dateCreated": Timestamp.now(),
      });
      getComments();
    } catch (e) {
      print(e);
    }
  }
}
