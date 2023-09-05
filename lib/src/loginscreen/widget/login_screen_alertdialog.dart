import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginAlertDialog {
  static showSuccessCreateAccount() async {
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
            "Success!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.amber[900]),
          ),
          SizedBox(
            height: 3.5.h,
          ),
          Text(
            "Your account was successfully created.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp),
          ),
        ],
      ),
    )));
  }

  static showAccountNotFound() async {
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
            "Sorry!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.amber[900]),
          ),
          SizedBox(
            height: 3.5.h,
          ),
          Text(
            "Account can't be found",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp),
          ),
          Text(
            "Please check your email and password",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp),
          )
        ],
      ),
    )));
  }

  static showLoadingDialog() async {
    Get.dialog(
        AlertDialog(
          content: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                  height: 8.h,
                  width: 60.w,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Center(
                        child: SpinKitThreeBounce(
                          size: 25.sp,
                          color: Colors.amber[800],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text("Loading...")
                    ],
                  )),
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
