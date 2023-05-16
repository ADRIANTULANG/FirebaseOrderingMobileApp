import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/cart_screen_controller.dart';

class CartScreenView extends GetView<CartScreenController> {
  const CartScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CartScreenController());
    return Scaffold(
      body: SafeArea(
          child: Container(
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
                      "Cart",
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
            Expanded(
                child: Container(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.cart.length,
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
                                          .cart[index].productImage))),
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
                                        controller.cart[index].productName,
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
                                                  .cart[index].productQuantity
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
                                            controller.cart[index].productPrice
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
                                        controller.cart[index].productPrice
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
                                                controller.increment_quantity(
                                                    id: controller
                                                        .cart[index].productId);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 1.5.w,
                                                      right: 1.5.w,
                                                      top: .5.h,
                                                      bottom: .5.h),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
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
                                                      BorderRadius.circular(5)),
                                              child: Obx(
                                                () => Text(
                                                  controller.cart[index]
                                                      .productQuantity.value
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                controller.decrement_quantity(
                                                    id: controller
                                                        .cart[index].productId);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 1.5.w,
                                                      right: 1.5.w,
                                                      top: .5.h,
                                                      bottom: .5.h),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
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
                                                (controller.cart[index]
                                                            .productPrice *
                                                        controller
                                                            .cart[index]
                                                            .productQuantity
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
            )),
          ],
        ),
      )),
      bottomNavigationBar: InkWell(
        onTap: () {
          controller.save_cart();
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
                "Save Cart",
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
