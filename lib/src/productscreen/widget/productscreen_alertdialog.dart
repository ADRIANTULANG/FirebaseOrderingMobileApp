import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/productscreen/controller/productscreen_controller.dart';
import 'package:sizer/sizer.dart';

class ProductScreenAlertDialog {
  static showRating({required ProductScreenController controller}) async {
    RxString rate = '3.0'.obs;
    Get.dialog(AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                controller.addRating(rate: double.parse(rate.value));
              },
              child: Text("Done"))
        ],
        content: Container(
          height: 16.h,
          width: 100.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How would you rate this store?",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: Colors.black),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                width: 100.w,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.amber[800],
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.only(
                        left: 2.w, right: 2.w, top: .5.h, bottom: .5.h),
                    child: Obx(
                      () => Text(
                        rate.value,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.only(left: 1.w),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  rate.value = rating.toString();
                },
              )
            ],
          ),
        )));
  }
}
