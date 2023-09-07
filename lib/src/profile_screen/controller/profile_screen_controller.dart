import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../services/getstorage_services.dart';
import '../widget/profile_screen_alertdialog.dart';

class ProfileScreenController extends GetxController {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController contactno = TextEditingController();
  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getUserDetails() async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"))
          .get();
      print(userData.data());
      var element = userData.data()!;

      if (Get.find<StorageServices>().storage.read("isNormalAccount") == true) {
        firstname.text = element['firstname'];
        lastname.text = element['lastname'];
        email.text = element['username'];
        password.text = element['password'];
        contactno.text = element['contactno'];
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  updateAccount() async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocumentReference.id)
          .update({
        "address": "",
        "contactno": contactno.text,
        "firstname": firstname.text,
        "lastname": lastname.text,
        "password": password.text,
        "username": email.text,
        "isNormalAccount": true
      });
      Get.find<StorageServices>().saveCredentials(
        isNormalAccount: true,
        contactno: contactno.text,
        id: userDocumentReference.id,
        username: email.text,
        password: password.text,
        firstname: firstname.text,
        lastname: lastname.text,
      );
      ProfileScreenAlertDialog.showSuccessUpdateAccount();
    } on Exception catch (e) {
      print("ERROR $e");
    }
  }

  googleUpdateAccount() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        await GoogleSignIn().signOut();
      } else {}
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

        if (userCredential.user?.email != null) {
          try {
            var userDocumentReference = await FirebaseFirestore.instance
                .collection('users')
                .doc(Get.find<StorageServices>().storage.read("id"));

            var resEmail = await FirebaseFirestore.instance
                .collection('users')
                .where('username', isEqualTo: userCredential.user?.email)
                .get();

            if (resEmail.docChanges.length == 0) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userDocumentReference.id)
                  .update({
                "address": "",
                "contactno": userCredential.user?.phoneNumber == null
                    ? ""
                    : userCredential.user?.phoneNumber,
                "firstname": userCredential.user?.displayName == null
                    ? ""
                    : userCredential.user?.displayName,
                "lastname": "",
                "password": "",
                "username": userCredential.user?.email == null
                    ? ""
                    : userCredential.user?.email,
                "isNormalAccount": false
              });

              Get.find<StorageServices>().saveCredentials(
                isNormalAccount: false,
                contactno: userCredential.user?.phoneNumber == null
                    ? ""
                    : userCredential.user!.phoneNumber!,
                id: userDocumentReference.id,
                username: userCredential.user?.email == null
                    ? ""
                    : userCredential.user!.email.toString(),
                password: "",
                firstname: userCredential.user?.displayName == null
                    ? ""
                    : userCredential.user!.displayName!,
                lastname: "",
              );
              ProfileScreenAlertDialog.showSuccessUpdateAccount();
            } else {
              ProfileScreenAlertDialog.showEmailAlreadyExist();
            }
          } on Exception catch (e) {
            print(e.toString());
          }
        } else {}
      } else {
        print("null ang access token ug idtoken");
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
