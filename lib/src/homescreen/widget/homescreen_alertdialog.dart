import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomeScreenAlertDialog {
  static showSuccessOrderPlace() async {
    Get.dialog(AlertDialog(
        content: Container(
      height: 20.h,
      width: 100.w,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Order Placed!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.amber[900]),
          ),
          SizedBox(
            height: 3.5.h,
          ),
          Text(
            "Your order was successfully placed and is being prepared for delivery",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp),
          ),
        ],
      ),
    )));
  }
}
