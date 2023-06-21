import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orderingapp/src/homescreen/controller/homescreen_controller.dart';
import 'package:sizer/sizer.dart';

import '../../productscreen/view/productscreen_view.dart';

class HomeScreenMap extends GetView<HomeScreenController> {
  const HomeScreenMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Obx(
            () => GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(8.24464951074821, 124.25666267215583),
                zoom: 14.4746,
              ),
              markers: controller.marker.toSet(),
              onMapCreated: (GoogleMapController g_controller) async {
                if (controller.googleMapController.isCompleted) {
                } else {
                  controller.googleMapController.complete(g_controller);
                }
                controller.camera_controller = await g_controller;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Container(
              height: 17.h,
              width: 100.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.storeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 2.w, right: 2.w),
                    child: InkWell(
                      onTap: () {
                        controller.animateToStoreLocation(
                            latlng: LatLng(
                                controller.storeList[index].location[0],
                                controller.storeList[index].location[1]));
                      },
                      child: Container(
                        height: 17.h,
                        width: 75.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all()),
                        child: Row(
                          children: [
                            Container(
                              height: 17.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          controller.storeList[index].image))),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.store,
                                          size: 18.sp,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          width: 1.w,
                                        ),
                                        Container(
                                          child: Text(
                                            controller.storeList[index].name,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 18.sp,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(
                                          width: 1.w,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              controller
                                                  .storeList[index].address,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 10.sp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => ProductScreenView(),
                                              arguments: {
                                                "store":
                                                    controller.storeList[index]
                                              });
                                        },
                                        child: Container(
                                          height: 5.h,
                                          width: 40.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all()),
                                          child: Text(
                                            "VISIT",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontSize: 10.sp),
                                          ),
                                        ),
                                      ),
                                    )),
                                    SizedBox(
                                      height: 1.h,
                                    )
                                  ],
                                ),
                              ),
                            )
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
    );
  }
}
