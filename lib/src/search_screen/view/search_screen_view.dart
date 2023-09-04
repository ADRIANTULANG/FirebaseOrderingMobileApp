import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../productscreen/view/productscreen_view.dart';
import '../controller/search_screen_controller.dart';

class SearchScreenView extends GetView<SearchScreenController> {
  const SearchScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchScreenController());
    return Scaffold(
      body: SafeArea(
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
                      "Search Store",
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
              height: 5.h,
              width: 90.w,
              child: TextField(
                onChanged: (value) {
                  if (controller.debounce?.isActive ?? false)
                    controller.debounce!.cancel();
                  controller.debounce =
                      Timer(const Duration(milliseconds: 1000), () {
                    if (value.isEmpty || value == "") {
                      Get.back();
                    } else {
                      controller.search_in_screen(keyword: value);
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
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.searched_Store.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductScreenView(), arguments: {
                              "store": controller.searched_Store[index]
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
                                CachedNetworkImage(
                                  imageUrl:
                                      controller.searched_Store[index].image,
                                  placeholder: (context, url) => Container(
                                    height: 17.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(9),
                                        topRight: Radius.circular(9),
                                      ),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  imageBuilder: (context, imageProvider) =>
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
                                                .searched_Store[index].image))),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Text(
                                    controller.searched_Store[index].name,
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
                                    controller.searched_Store[index].address,
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
            ),
          ],
        ),
      ),
    );
  }
}
