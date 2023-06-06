import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import '../../../services/getstorage_services.dart';
import '../../address_screen/controller/address_controller.dart';

class GooglemapController extends GetxController {
  String name = '';
  String contact = '';
  RxString full_Address = ''.obs;
  RxList<Marker> markers = <Marker>[].obs;
  Completer<GoogleMapController> g_controller =
      Completer<GoogleMapController>();
  LatLng tapped_location = LatLng(0.0, 0.0);
  @override
  void onInit() {
    name = Get.arguments['name'];
    contact = Get.arguments['contact'];
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  CameraPosition initialLocation = CameraPosition(
    target: LatLng(8.243772468505437, 124.25436690004767),
    // target: LatLng(Get.find<LocationServices>().locationData!.latitude!,
    //     Get.find<LocationServices>().locationData!.longitude!),
    zoom: 25.4746,
  );

  tapMap(latlng) async {
    tapped_location = latlng;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    if (placemarks.length > 0) {
      full_Address.value = placemarks[0].street! +
          " " +
          placemarks[0].locality! +
          " " +
          placemarks[0].subAdministrativeArea!;
    }

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId("1"),
      infoWindow:
          InfoWindow(title: full_Address.value, snippet: full_Address.value),
      position: latlng,
    ));
  }

  add_Address() async {
    try {
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      var newData = await FirebaseFirestore.instance.collection("address").add({
        "address": full_Address.value,
        "contact": contact,
        "name": name,
        "set": false,
        "user": userDocumentReference
      });
      setGeoPoint(documentID: newData.id);
      Get.find<AddressController>().getAddress();
      Get.back();
      Get.back();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  setGeoPoint({required String documentID}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    GeoFirestore geoFirestore = GeoFirestore(firestore.collection('address'));

    await geoFirestore.setLocation(documentID,
        GeoPoint(tapped_location.latitude, tapped_location.longitude));
  }
}
