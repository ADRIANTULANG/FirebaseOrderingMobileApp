import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/address_controller.dart';
import '../widget/address_screen_alertdialog.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddressController());
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              height: 6.h,
              width: 100.w,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black45))),
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
                      "Address",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13.sp),
                    ),
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              child: Obx(
                () => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.customer_Address.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
                      child: InkWell(
                        onTap: () {
                          controller.set_Address(
                              name: controller.customer_Address[index].name,
                              contact:
                                  controller.customer_Address[index].contact,
                              address:
                                  controller.customer_Address[index].address,
                              addressID: controller.customer_Address[index].id);
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 2.w, right: 2.w),
                          height: 16.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5, color: Colors.black45)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.customer_Address[index].name
                                        .capitalizeFirst
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.sp),
                                  ),
                                  Obx(
                                    () => controller
                                                .customer_Address[index].set ==
                                            true
                                        ? Icon(
                                            Icons.check_box,
                                            size: 15.sp,
                                            color: Colors.amber,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: 15.sp,
                                            color: Colors.amber,
                                          ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: .5.h,
                              ),
                              Text(
                                controller.customer_Address[index].contact,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 11.sp),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                controller.customer_Address[index].address,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 11.sp,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar: InkWell(
        onTap: () {
          AddressAlertDialog.showAddAddressAlertDialog(controller: controller);
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
                "Add Address",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 2.w,
              ),
              Icon(
                Icons.place,
                size: 20.sp,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
