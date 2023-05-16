import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/orderdetailscreen_controller.dart';

class OrderDetailScreeView extends GetView<OrderDetailScreenController> {
  const OrderDetailScreeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderDetailScreenController());
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: 100.h,
        width: 100.w,
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
                      "Order Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13.sp),
                    ),
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        color: Colors.amber,
                      ),
                      padding: EdgeInsets.only(
                          left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
                      child: Obx(() => Text(
                            controller.order_id.value,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 9.sp,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Expanded(
                child: Container(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.orderDetails_list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.only(bottom: 1.5.h, left: 5.w, right: 5.w),
                      child: Container(
                        height: 15.h,
                        width: 100.w,
                        child: Row(
                          children: [
                            Container(
                              height: 15.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(controller
                                          .orderDetails_list[index]
                                          .productImage))),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Expanded(
                                child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.orderDetails_list[index]
                                            .productName,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Obx(
                                            () => Text(
                                              controller
                                                  .orderDetails_list[index]
                                                  .productQty
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11.sp),
                                            ),
                                          ),
                                          Text(
                                            "x",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11.sp),
                                          ),
                                          Text(
                                            controller.orderDetails_list[index]
                                                .productPrice
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11.sp),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Text(
                                    "₱ " +
                                        controller.orderDetails_list[index]
                                            .productPrice
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.bottomRight,
                                    width: 100.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "₱ " +
                                              (controller
                                                          .orderDetails_list[
                                                              index]
                                                          .productPrice *
                                                      controller
                                                          .orderDetails_list[
                                                              index]
                                                          .productQty)
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.amber[900],
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        height: 13.h,
        width: 100.w,
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black45))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub-total",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp),
                ),
                Obx(() => Text(
                      "₱ " + controller.order_subtotal.value,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 11.sp),
                    ))
              ],
            ),
            SizedBox(
              height: .5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery Fee",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp),
                ),
                Obx(() => Text(
                      "₱ " + controller.order_Delivery_fee.value,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 11.sp),
                    ))
              ],
            ),
            SizedBox(
              height: .5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                ),
                Obx(() => Text(
                      "₱ " + controller.order_total.value,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
