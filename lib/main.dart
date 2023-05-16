import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderingapp/services/notification_services.dart';
import 'package:sizer/sizer.dart';

import 'services/getstorage_services.dart';
import 'src/splashscreen/view/splashscreen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Get.put(StorageServices());
  await Get.put(NotificationServices());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
