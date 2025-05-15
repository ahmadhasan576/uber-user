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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلب تاكسي - OSM Map'),
        backgroundColor: Colors.indigo,
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
                  decoration: InputDecoration(
                    labelText: 'نقطة الانطلاق (From)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    setState(() {
                      selectingFrom = true;
                    });
                  },
                ),
                SizedBox(height: 8),
                TextField(
                  controller: toController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'الوجهة (To)',
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.local_taxi),
                    label: Text('طلب تاكسي'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _requestTaxi,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.indigo,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _getUserLocation,
                  child: Icon(Icons.my_location),
                ),
                ElevatedButton(
                  onPressed: _clearAll,
                  child: Icon(Icons.clear_all),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMapTap(LatLng point) {
    setState(() {
      if (selectingFrom) {
        fromLocation = point;
        fromController.text = "${point.latitude}, ${point.longitude}";

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
          Address(
            placeName:
                "من (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})",
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      } else {
        toLocation = point;
        toController.text = "${point.latitude}, ${point.longitude}";

        Provider.of<AppInfo>(context, listen: false).updateDropOffLocation(
          Address(
            placeName:
                "إلى (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})",
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
      }

      _updateMarkersAndRoute();
    });
  }

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
      _getRouteFromORS(fromLocation!, toLocation!);
    } else {
      routePoints = [];
    }
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        currentCenter = userLocation;
        mapController.move(userLocation, 15);
        fromLocation = userLocation;
        fromController.text =
            "${userLocation.latitude}, ${userLocation.longitude}";

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
          Address(
            placeName: "موقعي الحالي",
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

  void _requestTaxi() async {
    if (fromLocation != null && toLocation != null && routePoints.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        DatabaseReference tripsRef = FirebaseDatabase.instance.ref().child(
          "tripRequests",
        );

        String tripId = tripsRef.push().key!;

        Map<String, dynamic> tripInfo = {
          "userId": userId,
          "from": {
            "latitude": fromLocation!.latitude,
            "longitude": fromLocation!.longitude,
          },
          "to": {
            "latitude": toLocation!.latitude,
            "longitude": toLocation!.longitude,
          },
          "timestamp": DateTime.now().toIso8601String(),
          "status": "pending",
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
}
