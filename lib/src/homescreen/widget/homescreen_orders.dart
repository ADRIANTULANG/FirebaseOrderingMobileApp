import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';
import 'package:sizer/sizer.dart';

import '../../orderdetail_screen/view/orderdetailscreen_view.dart';

class HomeScreenOrders extends GetView<HomeScreenController> {
  const HomeScreenOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.orderList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 3.w, top: 1.h, bottom: 1.h),
              child: InkWell(
                onTap: () {
                  Get.to(() => OrderDetailScreeView(), arguments: {
                    "order_id": controller.orderList[index].id,
                    "order_Delivery_fee":
                        controller.orderList[index].deliveryFee.toString(),
                    "order_subtotal":
                        controller.orderList[index].orderSubtotal.toString(),
                    "order_total":
                        controller.orderList[index].orderTotal.toString(),
                    "order_status":
                        controller.orderList[index].orderStatus.toString(),
                    "store_id":
                        controller.orderList[index].orderStoreId.toString(),
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 2.w, top: 1.5.h, right: 2.w),
                  height: 8.h,
                  width: 65.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order - ${controller.orderList[index].orderStatus.capitalizeFirst.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 11.sp),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                controller.orderList[index].storeDetails.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 11.sp),
                              ),
                            ],
                          ),
                          Text(
                            controller.orderList[index].item_count_in_order
                                    .toString() +
                                " Item/s",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 11.sp),
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
      ),
    );
  }
}
