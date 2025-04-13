import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:another_telephony/telephony.dart';

import 'package:url_launcher/url_launcher.dart';

class SmartSOSScreen extends StatefulWidget {
  const SmartSOSScreen({Key? key}) : super(key: key);

  @override
  _SmartSOSScreenState createState() => _SmartSOSScreenState();
}

class _SmartSOSScreenState extends State<SmartSOSScreen> {
  Position? _currentPosition;
  List<String> emergencyNumbers = [];
final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    await Permission.sms.request();
    await Permission.location.request();
    await Permission.phone.request();
    await Permission.contacts.request();
    _getCurrentLocation();
    _fetchEmergencyNumbers();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

 Future<void> _fetchEmergencyNumbers() async {
  setState(() {
    emergencyNumbers = ["+917536097576", "+911234567890"]; // test numbers
  });
}


  void _sendSOS() {
    if (_currentPosition == null || emergencyNumbers.isEmpty) return;

    String message = "🚨 SOS Alert! I need help!\n"
        "📍 Location: https://www.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}";

    for (var number in emergencyNumbers) {
      telephony.sendSms(
        to: number,
        message: message,
        isMultipart: true,
      );
    }

    _makePhoneCall(
        emergencyNumbers.first); // optional direct call to first contact

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("🚨 SOS Alert Sent!"), backgroundColor: Colors.red),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('⚠️ Could not launch call');
    }
  }

  void _shareLocation() {
    if (_currentPosition == null) return;

    String message = "📍 I'm here:\n"
        "https://www.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}";

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("📍 Location Shared"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart SOS"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/images/sos.png', height: 180),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.warning, size: 28),
              label: Text("Send SOS Alert", style: TextStyle(fontSize: 18)),
              onPressed: _sendSOS,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.location_on, size: 24),
              label: Text("Share Live Location"),
              onPressed: _shareLocation,
            ),
            const SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Emergency Contacts",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...emergencyNumbers.map((number) => Text("📞 $number")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
