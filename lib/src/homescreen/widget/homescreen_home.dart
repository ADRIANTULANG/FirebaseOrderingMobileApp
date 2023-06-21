import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';
import 'package:sizer/sizer.dart';

import '../../productscreen/view/productscreen_view.dart';

class HomeScreenHome extends GetView<HomeScreenController> {
  const HomeScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              border:
                                  Border.all(color: Colors.black, width: .2.w)),
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
                              border:
                                  Border.all(color: Colors.black, width: .2.w)),
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
    );
  }
}
