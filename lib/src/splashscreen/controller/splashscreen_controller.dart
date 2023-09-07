import 'dart:async';

import 'package:get/get.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/src/homescreen/view/homescreen_view.dart';
import 'package:orderingapp/src/loginscreen/view/loginscreen_view.dart';

import '../../../services/notification_services.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    navigate_to_homescreen();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  navigate_to_homescreen() async {
    Timer(Duration(seconds: 3), () {
      if (Get.find<StorageServices>().storage.read('id') == null) {
        Get.offAll(() => LoginScreenView());
      } else {
        Get.offAll(() => HomeScreenView());
        Get.find<NotificationServices>().getToken();
      }
    });
  }
}
