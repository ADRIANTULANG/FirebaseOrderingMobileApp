import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';
import 'package:badges/badges.dart' as badges;
import '../controller/productscreen_controller.dart';

class ProductScreenView extends GetView<ProductScreenController> {
  const ProductScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductScreenController());
    return Scaffold(
      body: Obx(
        () => controller.isLoading.value == true
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        CachedNetworkImage(
                          imageUrl: controller.store.image,
                          placeholder: (context, url) => Container(
                            height: 30.h,
                            width: 100.w,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 30.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Positioned(
                            top: 3.h,
                            child: Container(
                              height: 8.h,
                              width: 100.w,
                              padding: EdgeInsets.only(left: 2.w, right: 2.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 1.w),
                                      height: 10.h,
                                      width: 10.w,
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 12.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.navigate_to_place_order();
                                    },
                                    child: Container(
                                      height: 10.h,
                                      width: 10.w,
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Obx(
                                          () => badges.Badge(
                                            badgeStyle: badges.BadgeStyle(
                                                badgeColor: Colors.white),
                                            position:
                                                badges.BadgePosition.topEnd(
                                                    top: -15, end: -12),
                                            showBadge: controller.isShow.value,
                                            badgeContent: Text(controller
                                                .item_count.value
                                                .toString()),
                                            child: Icon(
                                              Icons.storefront,
                                              size: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Text(
                        controller.store.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Text(
                        controller.store.address,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      child: Expanded(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: controller.productList.length,
                            controller: controller.scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              return AutoScrollTag(
                                index: index,
                                controller: controller.scrollController,
                                key: ValueKey(index),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 1.5.h, left: 5.w, right: 5.w),
                                  child: Container(
                                    height: 15.h,
                                    width: 100.w,
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: controller
                                              .productList[index].productImage,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 15.h,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 15.h,
                                            width: 30.w,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                        controller
                                                            .productList[index]
                                                            .productName,
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          controller
                                                              .increment_quantity(
                                                                  id: controller
                                                                      .productList[
                                                                          index]
                                                                      .productId);
                                                        },
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 1.5.w,
                                                                    right:
                                                                        1.5.w,
                                                                    top: .5.h,
                                                                    bottom:
                                                                        .5.h),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.amber,
                                                              size: 12.sp,
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 2.w,
                                                                right: 2.w,
                                                                top: .5.h,
                                                                bottom: .5.h),
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Obx(
                                                          () => Text(
                                                            controller
                                                                .productList[
                                                                    index]
                                                                .quantity
                                                                .value
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                                      .productList[
                                                                          index]
                                                                      .productId);
                                                        },
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 1.5.w,
                                                                    right:
                                                                        1.5.w,
                                                                    top: .5.h,
                                                                    bottom:
                                                                        .5.h),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.amber,
                                                              size: 12.sp,
                                                            )),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "₱ " +
                                                    controller
                                                        .productList[index]
                                                        .productPrice
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
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
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
        height: 8.h,
        width: 100.w,
        color: Colors.amber[900],
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                controller.add_to_cart();
              },
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.white))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      "Add to Cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                controller.navigate_to_place_order();
              },
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.white))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      "Checkout",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
