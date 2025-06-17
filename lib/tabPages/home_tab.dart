// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_database/firebase_database.dart';
// import 'package:provider/provider.dart';
// import 'package:user_app/provider/app_info.dart';
// import 'package:user_app/models/address.dart';
// import 'package:geocoding/geocoding.dart';

// class HomeTab extends StatefulWidget {
//   @override
//   _HomeTabState createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> {
//   final MapController mapController = MapController();
//   List<Marker> markers = [];
//   List<LatLng> routePoints = [];

//   LatLng currentCenter = LatLng(37.7749, -122.4194);
//   double currentZoom = 13.0;

//   LatLng? fromLocation;
//   LatLng? toLocation;

//   TextEditingController fromController = TextEditingController();
//   TextEditingController toController = TextEditingController();

//   bool selectingFrom = false;

//   final String apiKey =
//       '5b3ce3597851110001cf6248ae7a6b1e52694f0abf85e2f36dec49fe';

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation().then((_) {
//       _loadAvailableDrivers();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('طلب تاكسي - OSM Map'),
//         backgroundColor: Colors.indigo,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.receipt_long),
//             onPressed: () {
//               _showAcceptedTripsFromTripRequests(context);
//             },
//             tooltip: 'عرض الطلب المقبول',
//           ),
//         ],
//       ),

//       body: Column(
//         children: [
//           Expanded(
//             child: FlutterMap(
//               mapController: mapController,
//               options: MapOptions(
//                 center: currentCenter,
//                 zoom: currentZoom,
//                 onTap: (tapPosition, point) {
//                   _handleMapTap(point);
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 PolylineLayer(
//                   polylines: [
//                     if (routePoints.isNotEmpty)
//                       Polyline(
//                         points: routePoints,
//                         strokeWidth: 4.0,
//                         color: Colors.indigo,
//                       ),
//                   ],
//                 ),
//                 MarkerLayer(markers: markers),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: fromController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'نقطة الانطلاق (From)',
//                     border: OutlineInputBorder(),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       selectingFrom = true;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 8),
//                 TextField(
//                   controller: toController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     labelText: 'الوجهة (To)',
//                     border: OutlineInputBorder(),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       selectingFrom = false;
//                     });
//                   },
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ElevatedButton.icon(
//                     icon: Icon(Icons.local_taxi),
//                     label: Text('طلب تاكسي'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     onPressed: _requestTaxi,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(8),
//             color: Colors.indigo,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: _getUserLocation,
//                   child: Icon(Icons.my_location),
//                 ),
//                 ElevatedButton(
//                   onPressed: _clearAll,
//                   child: Icon(Icons.clear_all),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAcceptedTripsFromTripRequests(BuildContext context) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final tripRequestsRef = FirebaseDatabase.instance.ref().child(
//       "tripRequests",
//     );

//     final tripRequestsSnapshot = await tripRequestsRef.get();

//     if (!tripRequestsSnapshot.exists) {
//       showDialog(
//         context: context,
//         builder:
//             (_) => AlertDialog(
//               title: Text("لا توجد طلبات"),
//               content: Text("لا توجد أي بيانات رحلات حالياً."),
//               actions: [
//                 TextButton(
//                   child: Text("إغلاق"),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//       );
//       return;
//     }

//     final tripsMap = Map<String, dynamic>.from(
//       tripRequestsSnapshot.value as Map,
//     );
//     List<Map<String, dynamic>> acceptedTrips = [];

//     for (var entry in tripsMap.entries) {
//       final tripData = Map<String, dynamic>.from(entry.value);
//       final tripUserId = tripData["userId"];
//       final status = tripData["status"];

//       if (tripUserId == userId && status == "accepted") {
//         acceptedTrips.add({
//           "tripId": entry.key,
//           "driverName": tripData["driverName"] ?? "غير معروف",
//           "driverPhone": tripData["driverPhone"] ?? "غير متوفر",
//           "from": tripData["from"],
//           "to": tripData["to"],
//         });
//       }
//     }

//     if (acceptedTrips.isEmpty) {
//       showDialog(
//         context: context,
//         builder:
//             (_) => AlertDialog(
//               title: Text("لا توجد رحلات مقبولة"),
//               content: Text("لم يتم قبول أي طلب من قِبل السائق حتى الآن."),
//               actions: [
//                 TextButton(
//                   child: Text("إغلاق"),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             title: Text("الرحلات المقبولة"),
//             content: SingleChildScrollView(
//               child: Column(
//                 children:
//                     acceptedTrips.map((trip) {
//                       final from = trip["from"];
//                       final to = trip["to"];

//                       return Card(
//                         margin: EdgeInsets.symmetric(vertical: 6),
//                         child: ListTile(
//                           title: Text("السائق: ${trip["driverName"]}"),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("الهاتف: ${trip["driverPhone"]}"),
//                               if (from != null && to != null) ...[
//                                 Text(
//                                   "من: (${from['latitude']}, ${from['longitude']})",
//                                 ),
//                                 Text(
//                                   "إلى: (${to['latitude']}, ${to['longitude']})",
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 child: Text("إغلاق"),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//     );
//   }

//   void _handleMapTap(LatLng point) async {
//     String address = await getAddressFromLatLng(
//       point.latitude,
//       point.longitude,
//     );

//     setState(() {
//       if (selectingFrom) {
//         fromLocation = point;
//         fromController.text = address;

//         Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
//           Address(
//             placeName: address,
//             latitude: point.latitude,
//             longitude: point.longitude,
//           ),
//         );
//       } else {
//         toLocation = point;
//         toController.text = address;

//         Provider.of<AppInfo>(context, listen: false).updateDropOffLocation(
//           Address(
//             placeName: address,
//             latitude: point.latitude,
//             longitude: point.longitude,
//           ),
//         );
//       }

//       _updateMarkersAndRoute();
//     });
//   }

//   void _updateMarkersAndRoute() {
//     markers.removeWhere(
//       (m) =>
//           m.builder(context).toString().contains('Icon(Icons.circle)') ||
//           m.builder(context).toString().contains('Icon(Icons.flag)'),
//     );

//     if (fromLocation != null) {
//       markers.add(
//         Marker(
//           point: fromLocation!,
//           builder: (ctx) => Icon(Icons.circle, color: Colors.green, size: 30),
//         ),
//       );
//     }

//     if (toLocation != null) {
//       markers.add(
//         Marker(
//           point: toLocation!,
//           builder: (ctx) => Icon(Icons.flag, color: Colors.red, size: 30),
//         ),
//       );
//     }

//     if (fromLocation != null && toLocation != null) {
//       _getRouteFromORS(fromLocation!, toLocation!);
//     } else {
//       routePoints = [];
//     }
//   }

//   Future<void> _getUserLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition();
//       LatLng userLocation = LatLng(position.latitude, position.longitude);

//       // احصل على العنوان قبل استدعاء setState
//       String address = await getAddressFromLatLng(
//         userLocation.latitude,
//         userLocation.longitude,
//       );

//       setState(() {
//         currentCenter = userLocation;
//         mapController.move(userLocation, 15);
//         fromLocation = userLocation;
//         fromController.text = address;

//         Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
//           Address(
//             placeName: address,
//             latitude: userLocation.latitude,
//             longitude: userLocation.longitude,
//           ),
//         );

//         _updateMarkersAndRoute();
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//   void _clearAll() {
//     setState(() {
//       markers.clear();
//       routePoints.clear();
//       fromLocation = null;
//       toLocation = null;
//       fromController.clear();
//       toController.clear();
//       _loadAvailableDrivers();
//     });
//   }

//   Future<void> _getRouteFromORS(LatLng from, LatLng to) async {
//     final url =
//         'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey'
//         '&start=${from.longitude},${from.latitude}&end=${to.longitude},${to.latitude}';

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final List<dynamic> coordinates =
//             data["features"][0]["geometry"]["coordinates"];

//         setState(() {
//           routePoints =
//               coordinates
//                   .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
//                   .toList();
//         });
//       } else {
//         print("Route API error: ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching route: $e");
//     }
//   }

//   Future<String> getAddressFromLatLng(double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latitude,
//         longitude,
//       );
//       if (placemarks.isNotEmpty) {
//         final placemark = placemarks.first;

//         String street = placemark.street ?? '';
//         String subLocality = placemark.subLocality ?? '';
//         String locality = placemark.locality ?? '';
//         String country = placemark.country ?? '';

//         String address = [
//           street,
//           subLocality,
//           locality,
//           country,
//         ].where((part) => part.isNotEmpty).join(', ');

//         return address.isNotEmpty ? address : "عنوان غير معروف";
//       }
//       return "عنوان غير معروف";
//     } catch (e) {
//       print("خطأ في تحويل الإحداثيات إلى عنوان: $e");
//       return "خطأ في تحديد العنوان";
//     }
//   }

//   // void _requestTaxi() async {
//   //   if (fromLocation != null && toLocation != null && routePoints.isNotEmpty) {
//   //     final userId = FirebaseAuth.instance.currentUser?.uid;

//   //     if (userId != null) {
//   //       DatabaseReference tripsRef = FirebaseDatabase.instance.ref().child(
//   //         "tripRequests",
//   //       );
//   //       String tripId = tripsRef.push().key!;

//   //       // الحصول على العناوين
//   //       String fromAddress = await getAddressFromLatLng(
//   //         fromLocation!.latitude,
//   //         fromLocation!.longitude,
//   //       );
//   //       String toAddress = await getAddressFromLatLng(
//   //         toLocation!.latitude,
//   //         toLocation!.longitude,
//   //       );

//   //       Map<String, dynamic> tripInfo = {
//   //         "userId": userId,
//   //         "from": {
//   //           "latitude": fromLocation!.latitude,
//   //           "longitude": fromLocation!.longitude,
//   //           "address": fromAddress, // ← إضافة العنوان
//   //         },
//   //         "to": {
//   //           "latitude": toLocation!.latitude,
//   //           "longitude": toLocation!.longitude,
//   //           "address": toAddress, // ← إضافة العنوان
//   //         },
//   //         "timestamp": DateTime.now().toIso8601String(),
//   //         "status": "pending",
//   //       };

//   //       await tripsRef.child(tripId).set(tripInfo);

//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text("تم إرسال طلب التاكسي بنجاح!"),
//   //           backgroundColor: Colors.green,
//   //         ),
//   //       );
//   //     }
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text("يرجى تحديد نقطة الانطلاق والوجهة أولاً."),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //   }
//   // }
//   void _requestTaxi() async {
//     if (fromLocation != null && toLocation != null && routePoints.isNotEmpty) {
//       final userId = FirebaseAuth.instance.currentUser?.uid;

//       if (userId != null) {
//         DatabaseReference tripsRef = FirebaseDatabase.instance.ref().child(
//           "tripRequests",
//         );
//         String tripId = tripsRef.push().key!;

//         // الحصول على العناوين
//         String fromAddress = await getAddressFromLatLng(
//           fromLocation!.latitude,
//           fromLocation!.longitude,
//         );
//         String toAddress = await getAddressFromLatLng(
//           toLocation!.latitude,
//           toLocation!.longitude,
//         );

//         // حساب المسافة بالكيلومتر
//         double distanceInMeters = Geolocator.distanceBetween(
//           fromLocation!.latitude,
//           fromLocation!.longitude,
//           toLocation!.latitude,
//           toLocation!.longitude,
//         );
//         double distanceInKm = distanceInMeters / 1000;
//         double fare = distanceInKm * 1; // كل كم = 1 دولار

//         Map<String, dynamic> tripInfo = {
//           "userId": userId,
//           "from": {
//             "latitude": fromLocation!.latitude,
//             "longitude": fromLocation!.longitude,
//             "address": fromAddress,
//           },
//           "to": {
//             "latitude": toLocation!.latitude,
//             "longitude": toLocation!.longitude,
//             "address": toAddress,
//           },
//           "timestamp": DateTime.now().toIso8601String(),
//           "status": "pending",
//           "distance_km": distanceInKm.toStringAsFixed(2), // حفظ المسافة
//           "fare_usd": fare.toStringAsFixed(2), // حفظ السعر
//         };

//         await tripsRef.child(tripId).set(tripInfo);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("تم إرسال طلب التاكسي بنجاح!"),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("يرجى تحديد نقطة الانطلاق والوجهة أولاً."),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _loadAvailableDrivers() async {
//     DatabaseReference driversRef = FirebaseDatabase.instance.ref().child(
//       "drivers",
//     );

//     final snapshot = await driversRef.get();

//     if (snapshot.exists) {
//       final driversData = snapshot.value as Map;

//       List<Marker> driverMarkers = [];

//       driversData.forEach((key, value) {
//         final driver = value as Map;

//         if (driver.containsKey("location")) {
//           final lat = driver["location"]["latitude"];
//           final lng = driver["location"]["longitude"];

//           driverMarkers.add(
//             Marker(
//               point: LatLng(lat, lng),
//               builder:
//                   (ctx) => const Icon(
//                     Icons.local_taxi,
//                     color: Colors.orange,
//                     size: 35,
//                   ),
//             ),
//           );
//         }
//       });

//       setState(() {
//         markers.addAll(driverMarkers);
//       });
//     }
//   }
// }

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:user_app/provider/app_info.dart';
import 'package:user_app/models/address.dart';
import 'package:geocoding/geocoding.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final MapController mapController = MapController();
  List<Marker> markers = [];
  List<LatLng> routePoints = [];

  LatLng currentCenter = LatLng(37.7749, -122.4194);
  double currentZoom = 13.0;

  LatLng? fromLocation;
  LatLng? toLocation;

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  bool selectingFrom = false;

  final String apiKey =
      '5b3ce3597851110001cf6248ae7a6b1e52694f0abf85e2f36dec49fe';

  @override
  void initState() {
    super.initState();
    _getUserLocation().then((_) {
      _loadAvailableDrivers();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('طلب تاكسي - OSM Map'),
  //       backgroundColor: Colors.indigo,
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.receipt_long),
  //           onPressed: () {
  //             _showAcceptedTripsFromTripRequests(context);
  //           },
  //           tooltip: 'عرض الطلب المقبول',
  //         ),
  //       ],
  //     ),
  //     body: Column(
  //       children: [
  //         Expanded(
  //           child: FlutterMap(
  //             mapController: mapController,
  //             options: MapOptions(
  //               center: currentCenter,
  //               zoom: currentZoom,
  //               onTap: (tapPosition, point) {
  //                 _handleMapTap(point);
  //               },
  //             ),
  //             children: [
  //               TileLayer(
  //                 urlTemplate:
  //                     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  //                 subdomains: ['a', 'b', 'c'],
  //               ),
  //               PolylineLayer(
  //                 polylines: [
  //                   if (routePoints.isNotEmpty)
  //                     Polyline(
  //                       points: routePoints,
  //                       strokeWidth: 4.0,
  //                       color: Colors.indigo,
  //                     ),
  //                 ],
  //               ),
  //               MarkerLayer(markers: markers),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             children: [
  //               TextField(
  //                 controller: fromController,
  //                 readOnly: true,
  //                 decoration: InputDecoration(
  //                   labelText: 'نقطة الانطلاق (From)',
  //                   border: OutlineInputBorder(),
  //                 ),
  //                 onTap: () {
  //                   setState(() {
  //                     selectingFrom = true;
  //                   });
  //                 },
  //               ),
  //               SizedBox(height: 8),
  //               TextField(
  //                 controller: toController,
  //                 readOnly: true,
  //                 decoration: InputDecoration(
  //                   labelText: 'الوجهة (To)',
  //                   border: OutlineInputBorder(),
  //                 ),
  //                 onTap: () {
  //                   setState(() {
  //                     selectingFrom = false;
  //                   });
  //                 },
  //               ),
  //               Container(
  //                 width: double.infinity,
  //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //                 child: ElevatedButton.icon(
  //                   icon: Icon(Icons.local_taxi),
  //                   label: Text('طلب تاكسي'),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.green,
  //                     padding: EdgeInsets.symmetric(vertical: 12),
  //                   ),
  //                   onPressed: _requestTaxi,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           padding: EdgeInsets.all(8),
  //           color: Colors.indigo,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               ElevatedButton(
  //                 onPressed: _getUserLocation,
  //                 child: Icon(Icons.my_location),
  //               ),
  //               ElevatedButton(
  //                 onPressed: _clearAll,
  //                 child: Icon(Icons.clear_all),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // ← لإجبار الاتجاه من اليمين لليسار
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلب تاكسي - خريطة OSM'),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
              icon: const Icon(Icons.receipt_long),
              onPressed: () {
                _showAcceptedTripsFromTripRequests(context);
              },
              tooltip: 'عرض الرحلة المقبولة',
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: currentCenter,
                  zoom: currentZoom,
                  onTap: (tapPosition, point) {
                    _handleMapTap(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  PolylineLayer(
                    polylines: [
                      if (routePoints.isNotEmpty)
                        Polyline(
                          points: routePoints,
                          strokeWidth: 4.0,
                          color: Colors.indigo,
                        ),
                    ],
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: fromController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'نقطة الانطلاق',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      setState(() {
                        selectingFrom = true;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: toController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'الوجهة',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () {
                      setState(() {
                        selectingFrom = false;
                      });
                    },
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.local_taxi),
                      label: const Text('طلب تاكسي'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _requestTaxi,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.indigo,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _getUserLocation,
                    child: const Icon(Icons.my_location),
                  ),
                  ElevatedButton(
                    onPressed: _clearAll,
                    child: const Icon(Icons.clear_all),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _requestTaxi() async {
    if (fromLocation != null && toLocation != null && routePoints.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        DatabaseReference tripsRef = FirebaseDatabase.instance.ref().child(
          "tripRequests",
        );
        String tripId = tripsRef.push().key!;

        // الحصول على العناوين
        String fromAddress = await getAddressFromLatLng(
          fromLocation!.latitude,
          fromLocation!.longitude,
        );
        String toAddress = await getAddressFromLatLng(
          toLocation!.latitude,
          toLocation!.longitude,
        );

        // حساب المسافة بالكيلومتر
        double distanceInMeters = Geolocator.distanceBetween(
          fromLocation!.latitude,
          fromLocation!.longitude,
          toLocation!.latitude,
          toLocation!.longitude,
        );
        double distanceInKm = distanceInMeters / 1000;
        double fare = distanceInKm * 1; // كل كم = 1 دولار

        Map<String, dynamic> tripInfo = {
          "userId": userId,
          "from": {
            "latitude": fromLocation!.latitude,
            "longitude": fromLocation!.longitude,
            "address": fromAddress,
          },
          "to": {
            "latitude": toLocation!.latitude,
            "longitude": toLocation!.longitude,
            "address": toAddress,
          },
          "timestamp": DateTime.now().toIso8601String(),
          "status": "pending",
          "distance_km": distanceInKm.toStringAsFixed(2), // حفظ المسافة
          "fare_usd": fare.toStringAsFixed(2), // حفظ السعر
        };

        await tripsRef.child(tripId).set(tripInfo);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم إرسال طلب التاكسي بنجاح!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("يرجى تحديد نقطة الانطلاق والوجهة أولاً."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadAvailableDrivers() async {
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child(
      "drivers",
    );

    final snapshot = await driversRef.get();

    if (snapshot.exists) {
      final driversData = snapshot.value as Map;

      List<Marker> driverMarkers = [];

      driversData.forEach((key, value) {
        final driver = value as Map;

        if (driver.containsKey("location")) {
          final lat = driver["location"]["latitude"];
          final lng = driver["location"]["longitude"];

          driverMarkers.add(
            Marker(
              point: LatLng(lat, lng),
              builder:
                  (ctx) => const Icon(
                    Icons.local_taxi,
                    color: Colors.orange,
                    size: 35,
                  ),
            ),
          );
        }
      });

      setState(() {
        markers.addAll(driverMarkers);
      });
    }
  }

  void _handleMapTap(LatLng point) async {
    String address = await getAddressFromLatLng(
      point.latitude,
      point.longitude,
    );

    setState(() {
      if (selectingFrom) {
        fromLocation = point;
        fromController.text = address;

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
          Address(
            placeName: address,
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      } else {
        toLocation = point;
        toController.text = address;

        Provider.of<AppInfo>(context, listen: false).updateDropOffLocation(
          Address(
            placeName: address,
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      }

      _updateMarkersAndRoute();
    });
  }

  // void _updateMarkersAndRoute() {
  //   markers.removeWhere(
  //     (m) =>
  //         m.builder(context).toString().contains('Icon(Icons.circle)') ||
  //         m.builder(context).toString().contains('Icon(Icons.flag)'),
  //   );

  //   if (fromLocation != null) {
  //     markers.add(
  //       Marker(
  //         point: fromLocation!,
  //         builder: (ctx) => Icon(Icons.circle, color: Colors.green, size: 30),
  //       ),
  //     );
  //   }

  //   if (toLocation != null) {
  //     markers.add(
  //       Marker(
  //         point: toLocation!,
  //         builder: (ctx) => Icon(Icons.flag, color: Colors.red, size: 30),
  //       ),
  //     );
  //   }

  //   if (fromLocation != null && toLocation != null) {
  //     _getRouteFromORS(fromLocation!, toLocation!);
  //   } else {
  //     routePoints = [];
  //   }
  // }

  // ... بداية الكود بدون تغيير

  void _updateMarkersAndRoute() {
    markers.removeWhere(
      (m) =>
          m.builder(context).toString().contains('Icon(Icons.circle)') ||
          m.builder(context).toString().contains('Icon(Icons.flag)'),
    );

    if (fromLocation != null) {
      markers.add(
        Marker(
          point: fromLocation!,
          builder: (ctx) => Icon(Icons.circle, color: Colors.green, size: 30),
        ),
      );
    }

    if (toLocation != null) {
      markers.add(
        Marker(
          point: toLocation!,
          builder: (ctx) => Icon(Icons.flag, color: Colors.red, size: 30),
        ),
      );
    }

    if (fromLocation != null && toLocation != null) {
      _getRouteFromORS(fromLocation!, toLocation!).then((_) {
        _showFareEstimate();
      });
    } else {
      routePoints = [];
    }
  }

  void _showFareEstimate() {
    if (fromLocation != null && toLocation != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        fromLocation!.latitude,
        fromLocation!.longitude,
        toLocation!.latitude,
        toLocation!.longitude,
      );
      double distanceInKm = distanceInMeters / 1000;
      double fare = distanceInKm * 1; // التسعيرة: 1 دولار لكل كيلومتر

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'المسافة: ${distanceInKm.toStringAsFixed(2)} كم - السعر التقريبي: ${fare.toStringAsFixed(2)} \$',
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  // ... بقية الكود كما هو بدون تغيير

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      // احصل على العنوان قبل استدعاء setState
      String address = await getAddressFromLatLng(
        userLocation.latitude,
        userLocation.longitude,
      );

      setState(() {
        currentCenter = userLocation;
        mapController.move(userLocation, 15);
        fromLocation = userLocation;
        fromController.text = address;

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
          Address(
            placeName: address,
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
          ),
        );

        _updateMarkersAndRoute();
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _clearAll() {
    setState(() {
      markers.clear();
      routePoints.clear();
      fromLocation = null;
      toLocation = null;
      fromController.clear();
      toController.clear();
      _loadAvailableDrivers();
    });
  }

  Future<void> _getRouteFromORS(LatLng from, LatLng to) async {
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey'
        '&start=${from.longitude},${from.latitude}&end=${to.longitude},${to.latitude}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> coordinates =
            data["features"][0]["geometry"]["coordinates"];

        setState(() {
          routePoints =
              coordinates
                  .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
                  .toList();
        });
      } else {
        print("Route API error: ${response.body}");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

        String street = placemark.street ?? '';
        String subLocality = placemark.subLocality ?? '';
        String locality = placemark.locality ?? '';
        String country = placemark.country ?? '';

        String address = [
          street,
          subLocality,
          locality,
          country,
        ].where((part) => part.isNotEmpty).join(', ');

        return address.isNotEmpty ? address : "عنوان غير معروف";
      }
      return "عنوان غير معروف";
    } catch (e) {
      print("خطأ في تحويل الإحداثيات إلى عنوان: $e");
      return "خطأ في تحديد العنوان";
    }
  }

  void _showAcceptedTripsFromTripRequests(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final tripRequestsRef = FirebaseDatabase.instance.ref().child(
      "tripRequests",
    );

    final tripRequestsSnapshot = await tripRequestsRef.get();

    if (!tripRequestsSnapshot.exists) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("لا توجد طلبات"),
              content: Text("لا توجد أي بيانات رحلات حالياً."),
              actions: [
                TextButton(
                  child: Text("إغلاق"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
      return;
    }

    final tripsMap = Map<String, dynamic>.from(
      tripRequestsSnapshot.value as Map,
    );
    List<Map<String, dynamic>> acceptedTrips = [];

    for (var entry in tripsMap.entries) {
      final tripData = Map<String, dynamic>.from(entry.value);
      final tripUserId = tripData["userId"];
      final status = tripData["status"];

      if (tripUserId == userId && status == "accepted") {
        acceptedTrips.add({
          "tripId": entry.key,
          "driverName": tripData["driverName"] ?? "غير معروف",
          "driverPhone": tripData["driverPhone"] ?? "غير متوفر",
          "from": tripData["from"],
          "to": tripData["to"],
        });
      }
    }

    if (acceptedTrips.isEmpty) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("لا توجد رحلات مقبولة"),
              content: Text("لم يتم قبول أي طلب من قِبل السائق حتى الآن."),
              actions: [
                TextButton(
                  child: Text("إغلاق"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("الرحلات المقبولة"),
            content: SingleChildScrollView(
              child: Column(
                children:
                    acceptedTrips.map((trip) {
                      final from = trip["from"];
                      final to = trip["to"];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text("السائق: ${trip["driverName"]}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("الهاتف: ${trip["driverPhone"]}"),
                              if (from != null && to != null) ...[
                                Text(
                                  "من: (${from['latitude']}, ${from['longitude']})",
                                ),
                                Text(
                                  "إلى: (${to['latitude']}, ${to['longitude']})",
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: Text("إغلاق"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}
