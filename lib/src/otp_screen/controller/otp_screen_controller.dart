import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../loginscreen/widget/login_screen_alertdialog.dart';

class OtpScreenController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxString firstname = ''.obs;
  RxString lastname = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString contact = ''.obs;
  RxString verifIDReceived = ''.obs;

  RxBool isVerifyingOTP = false.obs;
  @override
  void onInit() async {
    firstname.value = await Get.arguments['firstname'];
    lastname.value = await Get.arguments['lastname'];
    email.value = await Get.arguments['email'];
    password.value = await Get.arguments['password'];
    contact.value = await Get.arguments['contactno'];
    verifIDReceived.value = await Get.arguments['verifIDReceived'];

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, context) async {
    try {
      isVerifyingOTP(true);
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        try {
          await FirebaseFirestore.instance.collection("users").add({
            "address": "",
            "contactno": contact.value,
            "firstname": firstname.value,
            "lastname": lastname.value,
            "password": password.value,
            "username": email.value,
            "isNormalAccount": true,
            "online": true
          });
          Get.back();
          Get.back();
          LoginAlertDialog.showSuccessCreateAccount();
        } on Exception catch (e) {
          print("something went wrong $e");
        }
      }
      isVerifyingOTP(false);
    } on FirebaseAuthException catch (e) {
      print(e);
      isVerifyingOTP(false);
    }
  }
}
