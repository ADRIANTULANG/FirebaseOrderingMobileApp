import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orderingapp/src/otp_screen/view/otp_screen_view.dart';

import '../../loginscreen/widget/login_screen_alertdialog.dart';

class RegistrationScreenController extends GetxController {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController contactno = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String verifIDReceived = "";

  RxBool isVerifyingNumber = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  check_if_demo_code_exist(
      {required String demoCode, required String accounttype}) async {
    var resDemo = await FirebaseFirestore.instance
        .collection('democode')
        .where('code', isEqualTo: demoCode)
        .where('isActive', isEqualTo: true)
        .get();
    Get.back();
    if (resDemo.docs.length > 0) {
      await FirebaseFirestore.instance
          .collection('democode')
          .doc(resDemo.docs[0].id)
          .update({"isActive": false});
      if (accounttype == "normal") {
        verifiyNumber();
      } else {
        print("Dre age");
        googleSignUp();
      }
    }
  }

  verifiyNumber() async {
    isVerifyingNumber(true);
    await auth.verifyPhoneNumber(
        // phoneNumber: "09367325510",
        phoneNumber: "+63${contactno.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {});
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
          isVerifyingNumber(false);
        },
        codeSent: (String verificationID, int? resendToken) {
          verifIDReceived = verificationID;

          Get.to(() => OtpScreenView(), arguments: {
            "firstname": firstname.text,
            "lastname": lastname.text,
            "email": email.text,
            "password": password.text,
            "contactno": contactno.text,
            "verifIDReceived": verifIDReceived
          });
          isVerifyingNumber(false);
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: Duration(seconds: 60));
  }

  googleSignUp() async {
    try {
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
        try {
          await FirebaseFirestore.instance.collection("users").add({
            "address": "",
            "contactno": userCredential.user?.phoneNumber == null
                ? ""
                : userCredential.user?.phoneNumber,
            "firstname": userCredential.user?.displayName == null
                ? ""
                : userCredential.user?.displayName,
            "lastname": "",
            "password": "",
            "username": userCredential.user!.email == null
                ? ""
                : userCredential.user?.email,
            "isNormalAccount": false,
            "online": true
          });
          Get.back();
          LoginAlertDialog.showSuccessCreateAccount();
        } on Exception catch (e) {
          print("something went wrong $e");
        }
      } else {
        print("null ang access token ug idtoken");
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }
}
