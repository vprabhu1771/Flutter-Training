// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:location/location.dart';
//
// class DeliveryBoyController extends GetxController {
//
//   TextEditingController orderIdController = TextEditingController();
//
//   final Location location = Location();
//
//   String deliveryAddress = '';
//   String phoneNumber = '';
//   String amountToCollect = '0';
//   double customerLatitude = 37.7749;
//   double customerLongitude = -122.4194;
//   bool showDeliveryInfo = false;
//   bool isDeliveryStarted = false;
//
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   late final CollectionReference orderCollection;
//   late final CollectionReference orderTrackingCollection;
//
//   // Store the stream subscription
//   StreamSubscription<LocationData>? _locationSubscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//     orderCollection = firestore.collection('order');
//     orderTrackingCollection = firestore.collection('orderTracking');
//     getLocationPermission();
//   }
//
//   @override
//   void onClose() {
//     // Cancel subscription when controller is disposed
//     _locationSubscription?.cancel();
//     super.onClose();
//   }
//
//   getOrderById() async {
//     print(orderIdController.text);
//     try {
//       // Check if order ID is not empty
//       if (orderIdController.text.isEmpty) {
//         Get.snackbar(
//           'Error',
//           'Please enter an Order ID',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       // Show loading indicator
//       Get.dialog(
//         const Center(
//           child: CircularProgressIndicator(),
//         ),
//         barrierDismissible: false,
//       );
//
//       // Query the order from Firestore
//       final QuerySnapshot querySnapshot = await orderCollection
//           .where('id', isEqualTo: orderIdController.text)
//           .get();
//
//       // Close loading dialog
//       Get.back();
//
//       // Check if order exists
//       if (querySnapshot.docs.isNotEmpty) {
//         final DocumentSnapshot orderDoc = querySnapshot.docs.first;
//         final Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;
//
//         // Extract order details
//         deliveryAddress = orderData['address'] ?? 'No address provided';
//         phoneNumber = orderData['phoneNumber'] ?? 'No phone number';
//         amountToCollect = orderData['amount']?.toString() ?? '0';
//         customerLatitude = orderData['latitude'] ?? 37.7749;
//         customerLongitude = orderData['longitude'] ?? -122.4194;
//
//         // Update UI
//         showDeliveryInfo = true;
//         update(); // Trigger UI update if using GetX
//
//         // Show success message
//         Get.snackbar(
//           'Success',
//           'Order found! Delivery details loaded.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       } else {
//         // Order not found
//         showDeliveryInfo = false;
//         update();
//
//         Get.snackbar(
//           'Not Found',
//           'No order found with ID: ${orderIdController.text}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       // Handle any errors
//       Get.back(); // Close loading dialog if open
//       showDeliveryInfo = false;
//       update();
//
//       Get.snackbar(
//         'Error',
//         'Failed to fetch order: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       print("Error fetching order: $e");
//     }
//   }
//
//   Future<void> getLocationPermission() async {
//     try {
//       bool serviceEnabled = await location.serviceEnabled();
//
//       if(!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if(!serviceEnabled) {
//           return;
//         }
//       }
//
//       PermissionStatus permissionGranted = await location.hasPermission();
//
//       if(permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           return;
//         }
//       }
//
//     }catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   void startDelivery() {
//     location.onLocationChanged.listen((LocationData currentLocation) {
//
//       print("Location Changed: ${currentLocation.latitude}, ${currentLocation.longitude}");
//
//       // Update order tracking location when location changes
//       saveOrUpdateMyOrderLocation(
//           orderIdController.text,
//           currentLocation.latitude ?? 0,
//           currentLocation.longitude ?? 0
//       );
//
//       location.enableBackgroundMode(enable: true);
//
//     });
//   }
//
//   // Method to stop delivery
//   void stopDelivery() {
//     // Cancel location subscription
//     _locationSubscription?.cancel();
//     _locationSubscription = null;
//
//     isDeliveryStarted = false;
//     update();
//
//     Get.snackbar(
//       'Info',
//       'Delivery stopped',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.blue,
//       colorText: Colors.white,
//     );
//   }
//
//   Future<void> saveOrUpdateMyOrderLocation(String orderId, double latitude, double longitude) async {
//
//     try {
//
//       final DocumentReference docRef = orderTrackingCollection.doc(orderId);
//
//       // Use a transaction to ensure atomic read and write
//       await firestore.runTransaction( (transaction) async {
//         final DocumentSnapshot snapshot = await transaction.get(docRef);
//
//         if(snapshot.exists) {
//           // Document exists, so we update it
//           transaction.update(docRef, {
//             'latitude': latitude,
//             'longitude': longitude,
//           });
//         } else {
//           // Document does not exist, we create a new one
//           transaction.set(docRef, {
//             'orderId': orderId,
//             'latitude': latitude,
//             'longitude': longitude
//           });
//         }
//
//       });
//
//     } catch (e) {
//       print("Error saving or updating order location: $e");
//     }
//
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class DeliveryBoyController extends GetxController {

  TextEditingController orderIdController = TextEditingController();

  final Location location = Location();

  String deliveryAddress = '';
  String phoneNumber = '';
  String amountToCollect = '0';
  double customerLatitude = 37.7749;
  double customerLongitude = -122.4194;
  bool showDeliveryInfo = false;
  bool isDeliveryStarted = false;
  bool isLocationServiceEnabled = false;

  // Store the stream subscription
  StreamSubscription<LocationData>? _locationSubscription;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference orderCollection;
  late final CollectionReference orderTrackingCollection;

  @override
  void onInit() {
    super.onInit();
    orderCollection = firestore.collection('order');
    orderTrackingCollection = firestore.collection('orderTracking');
    getLocationPermission();
  }

  @override
  void onClose() {
    // Cancel subscription when controller is disposed
    _locationSubscription?.cancel();
    super.onClose();
  }

  getOrderById() async {
    print("Order ID entered: ${orderIdController.text}");
    try {
      // Check if order ID is not empty
      if (orderIdController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter an Order ID',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Query the order from Firestore
      final QuerySnapshot querySnapshot = await orderCollection
          .where('id', isEqualTo: orderIdController.text)
          .get();

      // Close loading dialog
      Get.back();

      // Check if order exists
      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot orderDoc = querySnapshot.docs.first;
        final Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;

        // Extract order details
        deliveryAddress = orderData['address'] ?? 'No address provided';
        phoneNumber = orderData['phoneNumber'] ?? 'No phone number';
        amountToCollect = orderData['amount']?.toString() ?? '0';
        customerLatitude = orderData['latitude'] ?? 37.7749;
        customerLongitude = orderData['longitude'] ?? -122.4194;

        // Update UI
        showDeliveryInfo = true;
        update(); // Trigger UI update if using GetX

        // Show success message
        Get.snackbar(
          'Success',
          'Order found! Delivery details loaded.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Order not found
        showDeliveryInfo = false;
        update();

        Get.snackbar(
          'Not Found',
          'No order found with ID: ${orderIdController.text}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any errors
      if (Get.isDialogOpen == true) {
        Get.back(); // Close loading dialog if open
      }
      showDeliveryInfo = false;
      update();

      Get.snackbar(
        'Error',
        'Failed to fetch order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error fetching order: $e");
    }
  }

  Future<void> getLocationPermission() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          Get.snackbar(
            'Error',
            'Location services are disabled. Please enable them.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Check permission
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          Get.snackbar(
            'Error',
            'Location permission is required for delivery tracking.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // For Android, also request background permission
      if (GetPlatform.isAndroid) {
        // Note: For Android 10+, you need to request background permission separately
        // This is handled when starting delivery
      }

      isLocationServiceEnabled = true;
      update();

      print("Location permissions granted successfully");

    } catch (e) {
      print("Error getting location: $e");
      Get.snackbar(
        'Error',
        'Failed to get location permission: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // New method to check if we can start delivery
  Future<bool> checkLocationAvailability() async {
    try {
      // Check service
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          Get.snackbar(
            'Error',
            'Please enable location services to start delivery.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      }

      // Check permission
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          Get.snackbar(
            'Error',
            'Location permission is required to start delivery.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      }

      return true;
    } catch (e) {
      print("Error checking location: $e");
      return false;
    }
  }

  void startDelivery() async {
    // Check if order is loaded
    if (!showDeliveryInfo) {
      Get.snackbar(
        'Error',
        'Please find an order first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Check if already started
    if (isDeliveryStarted) {
      Get.snackbar(
        'Info',
        'Delivery is already in progress',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    // Check location availability
    bool locationAvailable = await checkLocationAvailability();
    if (!locationAvailable) {
      return;
    }

    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Get current location first
      LocationData currentLocation = await location.getLocation();
      print("Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}");

      // Save initial location
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        await saveOrUpdateMyOrderLocation(
            orderIdController.text,
            currentLocation.latitude!,
            currentLocation.longitude!
        );
      }

      // Close loading dialog
      Get.back();

      // Update state
      isDeliveryStarted = true;
      update();

      // Start listening to location changes
      _locationSubscription = location.onLocationChanged.listen(
              (LocationData locationData) {
            if (locationData.latitude != null && locationData.longitude != null) {
              print("Location Changed: ${locationData.latitude}, ${locationData.longitude}");

              // Update order tracking location when location changes
              saveOrUpdateMyOrderLocation(
                  orderIdController.text,
                  locationData.latitude!,
                  locationData.longitude!
              );
            }
          },
          onError: (error) {
            print("Location stream error: $error");
            Get.snackbar(
              'Warning',
              'Location tracking error: $error',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
      );

      // Enable background mode (moved after listener is set)
      try {
        await location.enableBackgroundMode(enable: true);
        print("Background mode enabled");
      } catch (e) {
        print("Background mode error: $e");
        // Continue even if background mode fails
        Get.snackbar(
          'Warning',
          'Background location may not work properly. Please check permissions.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }

      Get.snackbar(
        'Success',
        'Delivery started! Tracking your location.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      Get.back(); // Close loading dialog if open
      isDeliveryStarted = false;
      update();

      Get.snackbar(
        'Error',
        'Failed to start delivery: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error starting delivery: $e");
    }
  }

  // Method to stop delivery
  void stopDelivery() {
    // Cancel location subscription
    _locationSubscription?.cancel();
    _locationSubscription = null;

    isDeliveryStarted = false;
    update();

    Get.snackbar(
      'Info',
      'Delivery stopped',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Future<void> saveOrUpdateMyOrderLocation(String orderId, double latitude, double longitude) async {
    try {
      final DocumentReference docRef = orderTrackingCollection.doc(orderId);

      // Use a transaction to ensure atomic read and write
      await firestore.runTransaction((transaction) async {
        final DocumentSnapshot snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          // Document exists, so we update it
          transaction.update(docRef, {
            'latitude': latitude,
            'longitude': longitude,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } else {
          // Document does not exist, we create a new one
          transaction.set(docRef, {
            'orderId': orderId,
            'latitude': latitude,
            'longitude': longitude,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });

      print("Location saved successfully for order: $orderId");

    } catch (e) {
      print("Error saving or updating order location: $e");
    }
  }

  // Reset all data
  void resetAll() {
    orderIdController.clear();
    deliveryAddress = '';
    phoneNumber = '';
    amountToCollect = '0';
    customerLatitude = 37.7749;
    customerLongitude = -122.4194;
    showDeliveryInfo = false;
    isDeliveryStarted = false;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    update();
  }
}