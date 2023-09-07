import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:orderingapp/services/location_services.dart';
import 'package:orderingapp/services/notification_services.dart';
import 'package:orderingapp/src/chat_screen/controller/chat_screen_controller.dart';
import 'package:sizer/sizer.dart';

import 'services/getstorage_services.dart';
import 'src/splashscreen/view/splashscreen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(LocationServices());
  await Firebase.initializeApp();
  await Get.put(StorageServices());
  await Get.put(NotificationServices());

  Stripe.publishableKey =
      'pk_test_51NKxUxB0VnpAUEkudXpcYtqy0jz9T4SzmZh6YC3lxRCual06BcfurVJC6CCKp9BompBCQOQ6gWTKcR1QxhCE2gx500u6k2l7f7';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print("App is Detached");
    } else if (state == AppLifecycleState.paused) {
      print("App is Paused");
    } else if (state == AppLifecycleState.resumed) {
      print("App is Resumed");
      if (Get.find<StorageServices>().storage.read('id') != null) {
        try {
          if (Get.isRegistered<ChatScreenController>()) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(Get.find<StorageServices>().storage.read("id"))
                .update({"online": true});
          }
        } on Exception catch (e) {
          print("ERROR: AppLifeCycle $e");
        }
      }
    } else if (state == AppLifecycleState.inactive) {
      print("App is Inactive");
      if (Get.find<StorageServices>().storage.read('id') != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(Get.find<StorageServices>().storage.read("id"))
              .update({"online": false});
        } on Exception catch (e) {
          print("ERROR: AppLifeCycle $e");
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ordering App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: SplashScreenView(),
      );
    });
  }
}
