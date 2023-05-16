import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sizer/sizer.dart';
import '../controller/otp_screen_controller.dart';

class OtpScreenView extends GetView<OtpScreenController> {
  const OtpScreenView({super.key});
// 9199032452
  @override
  Widget build(BuildContext context) {
    Get.put(OtpScreenController());
    return Scaffold(
      body: Obx(
        () => controller.isVerifyingOTP.value == true
            ? Container(
                height: 100.h,
                width: 100.w,
                alignment: Alignment.center,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.orange,
                )),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verification Code",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 30.sp),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Please type the verification code",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
                  ),
                  Obx(() => Text(
                        "sent to +63${controller.contact.value}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12.sp),
                      )),
                  SizedBox(
                    height: 3.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: OtpTextField(
                      numberOfFields: 6,
                      borderColor: Colors.orange,
                      disabledBorderColor: Colors.black,
                      enabledBorderColor: Colors.orange,
                      fillColor: Colors.orange,
                      showFieldAsBox: true,
                      focusedBorderColor: Colors.white,
                      onCodeChanged: (String code) {},

                      onSubmit: (String verificationCode) async {
                        PhoneAuthCredential phoneAuthCredential =
                            await PhoneAuthProvider.credential(
                                verificationId:
                                    controller.verifIDReceived.value,
                                smsCode: verificationCode);

                        controller.signInWithPhoneAuthCredential(
                            phoneAuthCredential, context);
                      }, // end onSubmit
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
