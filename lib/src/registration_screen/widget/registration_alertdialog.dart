import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/registration_screen/controller/registration_screen_controller.dart';
import 'package:sizer/sizer.dart';

class RegistrationAlertDialog {
  static showDemoCodeAlertDialog(
      {required RegistrationScreenController controller,
      required String accounttype}) async {
    TextEditingController demoCode = TextEditingController();
    Get.dialog(AlertDialog(
        content: Container(
      height: 22.h,
      width: 100.w,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 7.h,
            width: 100.w,
            child: TextField(
              controller: demoCode,
              obscureText: false,
              decoration: InputDecoration(
                fillColor: Colors.amber[100],
                filled: true,
                contentPadding: EdgeInsets.only(left: 3.w),
                alignLabelWithHint: false,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: "Enter demo code",
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          InkWell(
            onTap: () {
              controller.check_if_demo_code_exist(
                  demoCode: demoCode.text, accounttype: accounttype);
            },
            child: Container(
              height: 6.h,
              width: 100.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.amber[900],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "DONE",
                style: TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
