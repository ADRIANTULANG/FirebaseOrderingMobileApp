import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/registration_screen_controller.dart';
import '../widget/registration_alertdialog.dart';

class RegistrationScreenView extends GetView<RegistrationScreenController> {
  const RegistrationScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegistrationScreenController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          child: Obx(
            () => controller.isVerifyingNumber.value == true
                ? Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        height: 6.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black45))),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 15.sp,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(
                              width: 2.5.w,
                            ),
                            Expanded(
                                child: Container(
                              child: Text(
                                "Registration",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.sp),
                              ),
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        height: 7.h,
                        width: 100.w,
                        child: TextField(
                          controller: controller.firstname,
                          decoration: InputDecoration(
                              fillColor: Colors.amber[100],
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 3.w),
                              alignLabelWithHint: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: "First name"),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        height: 7.h,
                        width: 100.w,
                        child: TextField(
                          controller: controller.lastname,
                          decoration: InputDecoration(
                              fillColor: Colors.amber[100],
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 3.w),
                              alignLabelWithHint: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: "Last name"),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        height: 7.h,
                        width: 100.w,
                        child: TextField(
                          controller: controller.email,
                          decoration: InputDecoration(
                              fillColor: Colors.amber[100],
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 3.w),
                              alignLabelWithHint: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: "Email"),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        height: 7.h,
                        width: 100.w,
                        child: TextField(
                          obscureText: true,
                          controller: controller.password,
                          decoration: InputDecoration(
                              fillColor: Colors.amber[100],
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 3.w),
                              alignLabelWithHint: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: "Password"),
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        height: 7.h,
                        width: 100.w,
                        child: TextField(
                          controller: controller.contactno,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            if (controller.contactno.text.length == 0) {
                            } else {
                              if (controller.contactno.text[0] != "9" ||
                                  controller.contactno.text.length > 10) {
                                controller.contactno.clear();
                              } else {}
                            }
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.amber[100],
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 3.w),
                              alignLabelWithHint: false,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: "Phone no."),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "Or ",
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: InkWell(
                          onTap: () {
                            // controller.googleSignUp();
                            RegistrationAlertDialog.showDemoCodeAlertDialog(
                                controller: controller,
                                accounttype: "not normal");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 6.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/googles.png"),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    "Sign up with Google",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.isVerifyingNumber.value == true
            ? SizedBox()
            : InkWell(
                onTap: () {
                  if (controller.firstname.text.isEmpty ||
                      controller.lastname.text.isEmpty ||
                      controller.email.text.isEmpty ||
                      controller.password.text.isEmpty ||
                      controller.contactno.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please provide all the information'),
                    ));
                  } else if (controller.email.text.isEmail == false) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter a valid email'),
                    ));
                  } else if (controller.contactno.text.length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter a valid contact number'),
                    ));
                  } else if (controller.password.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Password must be 8 character long'),
                    ));
                  } else {
                    // controller.verifiyNumber();
                    RegistrationAlertDialog.showDemoCodeAlertDialog(
                        controller: controller, accounttype: "normal");
                  }
                },
                child: Container(
                  height: 8.h,
                  width: 100.w,
                  color: Colors.amber[900],
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Icon(
                        Icons.account_box_rounded,
                        size: 20.sp,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
