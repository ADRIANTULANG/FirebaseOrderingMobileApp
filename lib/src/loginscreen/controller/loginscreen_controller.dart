import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/services/notification_services.dart';
import 'package:orderingapp/src/homescreen/view/homescreen_view.dart';
import '../widget/login_screen_alertdialog.dart';

class LoginScreenController extends GetxController {
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  login({required String username, required String password}) async {
    List data = [];
    Map userData = {};
    LoginAlertDialog.showLoadingDialog();
    try {
      await userReference
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Map elementData = {
            "id": element.id,
            "address": element['address'],
            "firstname": element['firstname'],
            "lastname": element['lastname'],
            "username": element['username'],
            "password": element['password'],
            "isNormalAccount": element['isNormalAccount'],
            "contactno": element['contactno'],
          };
          userData = elementData;
          data.add(elementData);
        });
      });
      if (data.isNotEmpty || data.length != 0) {
        Get.find<StorageServices>().saveCredentials(
          isNormalAccount: userData['isNormalAccount'],
          contactno: userData['contactno'],
          id: userData['id'],
          username: userData['username'],
          password: userData['password'],
          firstname: userData['firstname'],
          lastname: userData['lastname'],
        );
        Get.offAll(() => HomeScreenView());
        Get.find<NotificationServices>().getToken();
        // storeList.assignAll(await storeModelFromJson(encodedData));
      } else {
        Get.back();
        LoginAlertDialog.showAccountNotFound();
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  googleSignin() async {
    try {
      LoginAlertDialog.showLoadingDialog();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        var credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        print("access token: ${googleAuth?.accessToken}");
        print("id token: ${googleAuth?.idToken}");

        UserCredential? userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        // print(userCredential.user!.email);
        // print(userCredential.user!.displayName);
        // print(userCredential.user!.phoneNumber);
        if (userCredential.user?.email != null) {
          List data = [];
          Map userData = {};
          try {
            await userReference
                .where('username', isEqualTo: userCredential.user!.email)
                .where('isNormalAccount', isEqualTo: false)
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((element) {
                Map elementData = {
                  "id": element.id,
                  "address": element['address'],
                  "firstname": element['firstname'],
                  "lastname": element['lastname'],
                  "username": element['username'],
                  "password": element['password'],
                  "isNormalAccount": element['isNormalAccount'],
                  "contactno": element['contactno'],
                };
                userData = elementData;
                data.add(elementData);
              });
            });
            if (data.isNotEmpty || data.length != 0) {
              Get.find<StorageServices>().saveCredentials(
                isNormalAccount: userData['isNormalAccount'],
                contactno: userData['contactno'],
                id: userData['id'],
                username: userData['username'],
                password: userData['password'],
                firstname: userData['firstname'],
                lastname: userData['lastname'],
              );
              Get.offAll(() => HomeScreenView());
            } else {
              Get.back();
              LoginAlertDialog.showAccountNotFound();
              FirebaseAuth auth = FirebaseAuth.instance;
              User? user = auth.currentUser;
              if (user != null) {
                await GoogleSignIn().signOut();
              } else {}
            }
          } on Exception catch (e) {
            print(e.toString());
          }
        } else {}
      } else {
        Get.back();

        print("null ang access token ug idtoken");
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
