import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import '../../../services/getstorage_services.dart';
import '../../../services/location_services.dart';
import '../../address_screen/controller/address_controller.dart';
import '../../placeorder_screen/controller/placeorderscreen_controller.dart';

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
    target: LatLng(Get.find<LocationServices>().locationData!.latitude!,
        Get.find<LocationServices>().locationData!.longitude!),
    // target: LatLng(Get.find<LocationServices>().locationData!.latitude!,
    //     Get.find<LocationServices>().locationData!.longitude!),
    zoom: 17.4746,
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
      await setAlltofalse();
      bool isSet = false;
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read("id"));
      if (Get.isRegistered<PlaceOrderScreenController>() == true) {
        isSet = true;
      }
      var newData = await FirebaseFirestore.instance.collection("address").add({
        "address": full_Address.value,
        "contact": contact,
        "name": name,
        "set": isSet,
        "user": userDocumentReference
      });
      setGeoPoint(documentID: newData.id);

      if (Get.isRegistered<PlaceOrderScreenController>()) {
        await Get.find<PlaceOrderScreenController>().getAddress();
        if (Get.isRegistered<AddressController>() == true) {
          await Get.find<AddressController>().getAddress();
        }
        Future.delayed(Duration(seconds: 2), () {
          Get.back();
          Get.back();
        });
      } else {}
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

  setAlltofalse() async {
    var userDocumentReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read("id"));
    final addressBatchRef = await FirebaseFirestore.instance
        .collection('address')
        .where("user", isEqualTo: userDocumentReference)
        .get();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (final address in addressBatchRef.docs) {
      batch.update(address.reference, {'set': false});
    }
    await batch.commit();
  }
}
