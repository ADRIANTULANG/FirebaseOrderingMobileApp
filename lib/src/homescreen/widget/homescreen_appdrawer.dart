import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:orderingapp/services/getstorage_services.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';
import 'package:sizer/sizer.dart';
import '../../../static/icons_class.dart';
import '../../address_screen/view/address_view.dart';
import '../../history_screen/view/history_screen_view.dart';
import '../../loginscreen/view/loginscreen_view.dart';
import '../../profile_screen/view/profile_screen_view.dart';

class HomeScreenAppDrawer {
  static showAppDrawer({required HomeScreenController controller}) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Container(
              height: 15.h,
              width: 100.w,
              child: Image.asset("assets/images/logo.png")),
          SizedBox(
            height: 3.h,
          ),
          ListTile(
            leading: SvgPicture.asset(
              CustomIcons.team,
            ),
            title: Text('Profile'),
            onTap: () {
              Get.to(() => ProfileScreenView());
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              CustomIcons.location,
              color: Colors.black,
            ),
            title: Text('Address'),
            onTap: () {
              Get.to(() => AddressView());
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              CustomIcons.todolist,
            ),
            title: Text('History'),
            onTap: () {
              Get.to(() => HistoryScreenView());
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              CustomIcons.logout,
            ),
            title: Text('Log out'),
            onTap: () {
              Get.find<StorageServices>().removeStorageCredentials();
              Get.offAll(() => LoginScreenView());
            },
          ),
        ],
      ),
    );
  }
}
