import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../controller/googlemap_controller.dart';

class GoogleMapView extends GetView<GooglemapController> {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GooglemapController());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Obx(
              () => GoogleMap(
                mapType: MapType.normal,
                markers: controller.markers.toSet(),
                initialCameraPosition: controller.initialLocation,
                onTap: (latlng) async {
                  controller.tapMap(latlng);
                },
                onMapCreated: (GoogleMapController mapController) {
                  controller.g_controller.complete(mapController);
                },
              ),
            ),
            Positioned(
                top: 1.5.h,
                child: Container(
                  height: 7.h,
                  width: 90.w,
                  padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Obx(() => Text(
                                controller.full_Address.value,
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              ))),
                      Icon(
                        Icons.location_on,
                        color: Colors.orange,
                      )
                    ],
                  ),
                )),
            Positioned(
                top: 85.h,
                child: InkWell(
                  onTap: () {
                    if (controller.full_Address.value != "" ||
                        controller.tapped_location == LatLng(0.0, 0.0)) {
                      controller.add_Address();
                    }
                  },
                  child: Container(
                    height: 7.h,
                    width: 90.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "Set",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
