import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';  // Import the share_plus package

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  late final MapController _mapController;
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initLocation();
  }

  Future<void> _initLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Geolocator.getCurrentPosition().then((position) {
        setState(() {
          _currentPosition = position;
        });
        _moveMapToPosition(position);
      });

      _positionStream = Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          _currentPosition = position;
        });
        _moveMapToPosition(position);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    }
  }

  void _moveMapToPosition(Position position) {
    _mapController.move(LatLng(position.latitude, position.longitude), 16);
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  void _shareLocation() {
    if (_currentPosition != null) {
      // Message containing the current location's latitude and longitude
      String message = "I am currently at latitude: ${_currentPosition!.latitude}, longitude: ${_currentPosition!.longitude}";

      // Google Maps link
      String googleMapsLink = "You can view my location on Google Maps: "
          "https://www.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}";

      // Share the location and Google Maps link via available apps
      Share.share("$message\n\n$googleMapsLink");  
    }
  }

  @override
  Widget build(BuildContext context) {
    double lat = _currentPosition?.latitude ?? 0.0;
    double lng = _currentPosition?.longitude ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Tracking"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          // Map View
          Expanded(
            flex: 3,
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(lat, lng),
                      initialZoom: 16,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.mahilamitra',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(lat, lng),
                            width: 60,
                            height: 60,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),

          // Status Section
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Status: Tracking Active ✅",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text("• Latitude: ${lat.toStringAsFixed(6)}"),
                  Text("• Longitude: ${lng.toStringAsFixed(6)}"),
                  const SizedBox(height: 10),
                  const Text("• You are being tracked in real-time."),
                  const Text("• In case of emergency, press SOS."),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _shareLocation,  // Button to share location
                    child: const Text("Share Live Location"),
                    style: ElevatedButton.styleFrom(
                 //     primary: Colors.pinkAccent,
                   //   onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
