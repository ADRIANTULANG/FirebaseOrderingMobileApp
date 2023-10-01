import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/src/comment_screen/controller/comment_controller.dart';
import 'package:sizer/sizer.dart';

class CommentAlertDialog {
  static showAddComment({required CommentController controller}) async {
    TextEditingController comment = TextEditingController();
    Get.dialog(AlertDialog(
        content: Container(
      height: 27.h,
      width: 100.w,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comment",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.amber[900]),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            height: 13.h,
            width: 100.w,
            child: TextField(
              maxLines: 15,
              controller: comment,
              decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 3.w, top: 2.h),
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintStyle: TextStyle(fontSize: 11.sp),
                  hintText: 'Say something about this store.'),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          InkWell(
            onTap: () {
              if (comment.text.isNotEmpty) {
                controller.addComment(comment: comment.text);
              }
            },
            child: Container(
              height: 7.h,
              width: 100.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.amber[900],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "DONE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
