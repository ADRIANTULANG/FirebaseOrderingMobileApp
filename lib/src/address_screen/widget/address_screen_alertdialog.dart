import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../googlemap_screen/view/googlemap_view.dart';
import '../controller/address_controller.dart';

class AddressAlertDialog {
  static showAddAddressAlertDialog(
      {required AddressController controller}) async {
    TextEditingController name = TextEditingController();
    TextEditingController contact = TextEditingController();

    Get.dialog(AlertDialog(
        title: Text("Add Address"),
        content: Container(
          height: 35.h,
          width: 100.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp),
              ),
              SizedBox(
                height: .5.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 1.w, right: 1.w),
                height: 6.h,
                width: 100.w,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    fillColor: Colors.amber[100],
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Contact no.",
                style:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp),
              ),
              SizedBox(
                height: .5.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 1.w, right: 1.w),
                height: 6.h,
                width: 100.w,
                child: TextField(
                  controller: contact,
                  decoration: InputDecoration(
                    fillColor: Colors.amber[100],
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 3.w),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.w, right: 1.w),
                child: InkWell(
                  onTap: () {
                    if (name.text.isNotEmpty &&
                        contact.text.isNotEmpty &&
                        contact.text.isPhoneNumber) {
                      Get.to(() => GoogleMapView(), arguments: {
                        "name": name.text,
                        "contact": contact.text,
                      });
                    }
                  },
                  child: Container(
                    height: 6.h,
                    width: 100.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
