import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../orderdetail_screen/view/orderdetailscreen_view.dart';
import '../controller/history_screen_controller.dart';

class HistoryScreenView extends GetView<HistoryScreenController> {
  const HistoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryScreenController());
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
                        "Order History",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13.sp),
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Obx(
                () => controller.order_history_list.length == 0 &&
                        controller.isLoadingData.value == false
                    ? Expanded(
                        child: SizedBox(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 80.sp,
                                color: Colors.amber[800],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text(
                                "You currently don't have any order history.",
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                      ))
                    : Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Obx(
                            () => ListView.builder(
                              itemCount: controller.order_history_list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 1.5.h),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => OrderDetailScreeView(),
                                          arguments: {
                                            "order_id": controller
                                                .order_history_list[index].id,
                                            "order_Delivery_fee": controller
                                                .order_history_list[index]
                                                .deliveryFee
                                                .toString(),
                                            "order_subtotal": controller
                                                .order_history_list[index]
                                                .orderSubtotal
                                                .toString(),
                                            "order_total": controller
                                                .order_history_list[index]
                                                .orderTotal
                                                .toString(),
                                            "order_status": controller
                                                .order_history_list[index]
                                                .orderStatus
                                                .toString(),
                                            "store_id": controller
                                                .order_history_list[index]
                                                .orderStoreId
                                                .toString(),
                                            "hasMessage": controller
                                                .order_history_list[index]
                                                .hasMessage
                                                .value,
                                          });
                                      controller.order_history_list[index]
                                          .hasMessage.value = false;
                                    },
                                    child: Container(
                                      height: 17.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: Colors.amber[800],
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 17.h,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        controller
                                                            .order_history_list[
                                                                index]
                                                            .storeDetails
                                                            .image))),
                                          ),
                                          Expanded(
                                              child: Container(
                                            padding: EdgeInsets.only(
                                                top: 1.h,
                                                left: 2.w,
                                                right: 2.w),
                                            height: 17.h,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Order: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 10.sp),
                                                    ),
                                                    Text(
                                                      controller
                                                          .order_history_list[
                                                              index]
                                                          .id,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 10.sp),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 1.5.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Store Name: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                    Text(
                                                      controller
                                                          .order_history_list[
                                                              index]
                                                          .storeDetails
                                                          .name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Order Status: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                    Text(
                                                      controller
                                                          .order_history_list[
                                                              index]
                                                          .orderStatus
                                                          .capitalizeFirst
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Sub-total: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                    Text(
                                                      "₱ " +
                                                          controller
                                                              .order_history_list[
                                                                  index]
                                                              .orderSubtotal
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Delivery Fee: ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                    Text(
                                                      "₱ " +
                                                          controller
                                                              .order_history_list[
                                                                  index]
                                                              .deliveryFee
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontSize: 9.sp),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Total ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 12.sp),
                                                    ),
                                                    Text(
                                                      "₱ " +
                                                          controller
                                                              .order_history_list[
                                                                  index]
                                                              .orderTotal
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 12.sp),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
