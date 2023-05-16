import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/search_screen/view/search_screen_view.dart';
import 'package:sizer/sizer.dart';
import '../../cart_screen/view/cart_screen_view.dart';
import '../../orderdetail_screen/view/orderdetailscreen_view.dart';
import '../../productscreen/view/productscreen_view.dart';
import '../controller/homescreen_controller.dart';
import 'package:badges/badges.dart' as badges;

import '../widget/homescreen_appdrawer.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    return Scaffold(
      drawer: HomeScreenAppDrawer.showAppDrawer(controller: controller),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6.h,
              ),
              Container(
                width: 100.w,
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(builder: (context) {
                      return InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                          FocusScope.of(context).unfocus();
                        },
                        child: Icon(
                          Icons.person_2,
                          size: 30.sp,
                          color: Colors.amber,
                        ),
                      );
                    }),
                    Container(
                      height: 5.h,
                      width: 64.w,
                      child: TextField(
                        onChanged: (value) {
                          if (controller.debounce?.isActive ?? false)
                            controller.debounce!.cancel();
                          controller.debounce =
                              Timer(const Duration(milliseconds: 1000), () {
                            if (value.isEmpty || value == "") {
                            } else {
                              Get.to(() => SearchScreenView(),
                                  arguments: {"keyword": value});
                            }
                            FocusScope.of(context).unfocus();
                          });
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.amber[100],
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 3.w),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Search'),
                      ),
                    ),
                    Obx(
                      () => badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -3, end: -3),
                        badgeContent: Obx(
                            () => Text(controller.cartCount.value.toString())),
                        showBadge:
                            controller.cartCount.value > 0 ? true : false,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => CartScreenView());
                          },
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            size: 30.sp,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Text(
                  "Popular Stores",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                height: 23.h,
                width: 100.w,
                child: Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.storeListPopular.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductScreenView(), arguments: {
                              "store": controller.storeListPopular[index]
                            });
                          },
                          child: Container(
                            height: 23.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                                color: Colors.amber[800],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black, width: .2.w)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(9),
                                        topRight: Radius.circular(9),
                                      ),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(controller
                                              .storeListPopular[index].image))),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Text(
                                    controller.storeListPopular[index].name,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Text(
                                    controller.storeListPopular[index].address,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Text(
                  "Stores",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.storeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductScreenView(), arguments: {
                              "store": controller.storeList[index]
                            });
                          },
                          child: Container(
                            height: 23.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                                color: Colors.amber[800],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black, width: .2.w)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 17.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(9),
                                        topRight: Radius.circular(9),
                                      ),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(controller
                                              .storeList[index].image))),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Text(
                                    controller.storeList[index].name,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Text(
                                    controller.storeList[index].address,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
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
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.orderList.length > 0
            ? Container(
                height: 10.h,
                width: 100.w,
                color: Colors.amber[900],
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.orderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.only(left: 3.w, top: 1.h, bottom: 1.h),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => OrderDetailScreeView(), arguments: {
                            "order_id": controller.orderList[index].id,
                            "order_Delivery_fee": controller
                                .orderList[index].deliveryFee
                                .toString(),
                            "order_subtotal": controller
                                .orderList[index].orderSubtotal
                                .toString(),
                            "order_total": controller
                                .orderList[index].orderTotal
                                .toString()
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 2.w, top: 1.5.h, right: 2.w),
                          height: 8.h,
                          width: 65.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order - ${controller.orderList[index].orderStatus.capitalizeFirst.toString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp),
                                  ),
                                  Text(
                                    "₱ " +
                                        controller.orderList[index].orderTotal
                                            .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber[900],
                                        fontSize: 11.sp),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.store,
                                        size: 15.sp,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Text(
                                        controller
                                            .orderList[index].storeDetails.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11.sp),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    controller.orderList[index]
                                            .item_count_in_order
                                            .toString() +
                                        " Item/s",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 11.sp),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
