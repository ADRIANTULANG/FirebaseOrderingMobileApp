import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/comment_screen/controller/comment_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../widget/comment_alertdialog.dart';

class CommentView extends GetView<CommentController> {
  const CommentView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommentController());
    return Scaffold(
      body: Obx(
        () => controller.isLoading.value == true
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(
                child: SingleChildScrollView(
                  child: Column(
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
                                  ],
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(
                            controller.store.name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(
                            controller.store.address,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Text(
                            "Comments",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        child: Obx(
                          () => ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: controller.commentList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w, right: 5.w, top: 1.h),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 100.w,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 8.h,
                                              width: 10.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: Text(
                                                controller.commentList[index]
                                                    .userName[0].capitalizeFirst
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 9.sp),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.commentList[index]
                                                      .userName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.sp),
                                                ),
                                                Text(
                                                  DateFormat.yMMMd().format(
                                                          controller
                                                              .commentList[
                                                                  index]
                                                              .dateCreated) +
                                                      " " +
                                                      DateFormat.jm().format(
                                                          controller
                                                              .commentList[
                                                                  index]
                                                              .dateCreated),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 8.sp),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100.w,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 3.w),
                                          child: Text(controller
                                              .commentList[index].comment),
                                        ),
                                      )
                                    ]),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: Obx(
        () => controller.isLoading.value == true
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  CommentAlertDialog.showAddComment(controller: controller);
                },
                child: Icon(Icons.add_comment),
              ),
      ),
    );
  }
}
