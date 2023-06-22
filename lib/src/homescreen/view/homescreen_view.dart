import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/search_screen/view/search_screen_view.dart';
import 'package:sizer/sizer.dart';
import '../../cart_screen/view/cart_screen_view.dart';
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Builder(builder: (context) {
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
        title: Container(
          height: 5.h,
          width: 70.w,
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Search'),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 1.h, right: 2.w),
            child: Obx(
              () => badges.Badge(
                position: badges.BadgePosition.topEnd(top: -3, end: -3),
                badgeContent:
                    Obx(() => Text(controller.cartCount.value.toString())),
                showBadge: controller.cartCount.value > 0 ? true : false,
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
          ),
        ],
      ),
      body: Obx(() => controller.screens[controller.pageindex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            backgroundColor: Colors.orange,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            currentIndex: controller.pageindex.value,
            onTap: (index) {
              controller.pageindex.value = index;
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_rounded), label: "Map"),
              BottomNavigationBarItem(
                  icon: Obx(
                    () => controller.orderList.length > 0
                        ? badges.Badge(
                            badgeContent:
                                Text(controller.orderList.length.toString()),
                            child: Icon(Icons.list),
                          )
                        : Icon(Icons.list),
                  ),
                  label: "Orders"),
            ]),
      ),
    );
  }
}
