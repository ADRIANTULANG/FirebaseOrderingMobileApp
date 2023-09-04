import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/placeorder_screen/widget/placeorder_widget_alertdialog.dart';
import 'package:sizer/sizer.dart';

import '../../address_screen/view/address_view.dart';
import '../controller/placeorderscreen_controller.dart';

class PlaceOrderScreenView extends GetView<PlaceOrderScreenController> {
  const PlaceOrderScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PlaceOrderScreenController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  height: 6.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black45))),
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
                          "Place Order",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13.sp),
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
                  child: InkWell(
                    onTap: () {
                      PlaceOrderAlertDialog.showAddAddressAlertDialog(
                          controller: controller);
                    },
                    child: Container(
                      height: 5.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1.5, color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 173, 170, 170),
                                blurRadius: 8,
                                spreadRadius: .1,
                                offset: Offset(0, 3))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add Address",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 13.sp),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Icon(
                            Icons.add_circle,
                            size: 15.sp,
                            color: Colors.amber,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => AddressView());
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 2.w, right: 2.w),
                      height: 16.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.5, color: Colors.black45)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Text(
                                  controller.address_name.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.sp),
                                ),
                              ),
                              Icon(
                                Icons.edit_location_alt,
                                size: 15.sp,
                                color: Colors.amber,
                              )
                            ],
                          ),
                          SizedBox(
                            height: .5.h,
                          ),
                          Obx(
                            () => Text(
                              controller.address_contact.value,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11.sp),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Obx(
                            () => Text(
                              controller.address_full.value,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11.sp,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Divider(
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  child: Obx(
                    () => ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 1.5.h, left: 5.w, right: 5.w),
                          child: Container(
                            height: 15.h,
                            width: 100.w,
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      controller.orders[index].productImage,
                                  placeholder: (context, url) => Container(
                                    height: 15.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 15.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: imageProvider)),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller
                                                .orders[index].productName,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Obx(
                                                () => Text(
                                                  controller.orders[index]
                                                      .quantity.value
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
                                                controller
                                                    .orders[index].productPrice
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
                                            controller
                                                .orders[index].productPrice
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
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controller
                                                        .increment_quantity(
                                                            id: controller
                                                                .orders[index]
                                                                .productId);
                                                  },
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 1.5.w,
                                                          right: 1.5.w,
                                                          top: .5.h,
                                                          bottom: .5.h),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.amber,
                                                        size: 12.sp,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 2.w,
                                                      right: 2.w,
                                                      top: .5.h,
                                                      bottom: .5.h),
                                                  decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Obx(
                                                    () => Text(
                                                      controller.orders[index]
                                                          .quantity.value
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    controller
                                                        .decrement_quantity(
                                                            id: controller
                                                                .orders[index]
                                                                .productId);
                                                  },
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 1.5.w,
                                                          right: 1.5.w,
                                                          top: .5.h,
                                                          bottom: .5.h),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: Colors.amber,
                                                        size: 12.sp,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Obx(
                                              () => Text(
                                                "₱ " +
                                                    (controller.orders[index]
                                                                .productPrice *
                                                            controller
                                                                .orders[index]
                                                                .quantity
                                                                .value)
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.amber[900],
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                ),
                SizedBox(
                  height: 3.h,
                ),
                Divider(
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: .5.w, right: 5.w),
                  child: Row(
                    children: [
                      Obx(
                        () => Checkbox(
                            value: controller.cod.value,
                            onChanged: (value) {
                              if (controller.cod.value == true) {
                                controller.cod.value = false;
                                controller.onlinepayment.value = true;
                              } else {
                                controller.cod.value = true;
                                controller.onlinepayment.value = false;
                              }
                            }),
                      ),
                      Text("Cash on Delivery")
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: .5.w, right: 5.w),
                  child: Row(
                    children: [
                      Obx(
                        () => Checkbox(
                            value: controller.onlinepayment.value,
                            onChanged: (value) {
                              if (controller.onlinepayment.value == true) {
                                controller.onlinepayment.value = false;
                                controller.cod.value = true;
                              } else {
                                controller.onlinepayment.value = true;
                                controller.cod.value = false;
                              }
                            }),
                      ),
                      Text("Pay Online")
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sub-Total",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 10.sp),
                      ),
                      Obx(
                        () => Text(
                          "₱ " + controller.subtotal_amount().value.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10.sp),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: .5.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Fee",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 10.sp),
                      ),
                      Text(
                        "₱ " + controller.deliveryFee.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 10.sp),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: .5.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                      Obx(
                        () => Text(
                          "₱ " + controller.total_amount().value.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.sp),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (controller.cod.value == true) {
            controller.place_order();
          } else {
            controller.makePayment(
                amount: controller.total_amount().value.toString(),
                currency: "PHP");
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
                "Place Order",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 2.w,
              ),
              Icon(
                Icons.shopping_bag_rounded,
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
