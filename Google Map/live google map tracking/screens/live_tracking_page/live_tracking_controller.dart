import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_order_tracking/model/order.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class LiveTrackingController extends GetxController {
  
  String orderId = '0000';
  
  LatLng destination = const LatLng(10.2929726, 76.1645936);
  LatLng deliveryBoyLocation = const LatLng(10.3225, 76.1526);
  GoogleMapController? mapController;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  double remainingDistance = 0.0;
  final Location location = Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;

  late MyOrder myOrder;

  @override
  void onInit() {
    orderTrackingCollection = firestore.collection('orderTracking');
    addCustomMarker();
    super.onInit();
  }

  void addCustomMarker() {
    ImageConfiguration configuration = const ImageConfiguration(size: Size(0,0), devicePixelRatio: 1);

    BitmapDescriptor.fromAssetImage(configuration, 'assets/images/food_icon.png').then((value) {
      markerIcon = value;
    });
  }

  // Function to update the current location
  void updateDestinationLocation(double latitude, double longitude) {
    destination = LatLng(latitude, longitude);
    update();
  }
  
  void startTracking(String orderId) {
    try {
      orderTrackingCollection.doc(orderId).snapshots().listen((snapshot) {
        
        if(snapshot.exists) {
          var trackingData = snapshot.data() as Map<String, dynamic>;
          double latitude = trackingData['latitude'];
          double longitude = trackingData['longitude'];
          updateUIWithLocation(latitude, longitude);
          print('Latest Location: $latitude, $longitude');
        }
        else {
          print("No tracking data available for order ID; $orderId");  
        }
        
      });
    } catch (e) {
      rethrow;
    }
  }
  
  void updateUIWithLocation(double latitude, double longitude) {
    deliveryBoyLocation = LatLng(latitude, longitude);
    
    // Update the camera position to the new location
    mapController?.animateCamera(CameraUpdate.newLatLng(deliveryBoyLocation));
    calculateRemainingDistance();
  }

  // Function to calculate remaining distance
  void calculateRemainingDistance() {
      double distance = Geolocator.distanceBetween(
          deliveryBoyLocation.latitude,
          deliveryBoyLocation.longitude,
          destination.latitude,
          destination.longitude,
      );

      // Convert distance from meters to kilometers
      double distanceInKm = distance / 1000;
      remainingDistance = distanceInKm;
      print("Remaining Distance: $distanceInKm kilomenters");
      update();
  }


}