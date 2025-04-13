import 'package:flutter/material.dart';
import 'package:mahilamitra/Screens/sos/sos_screen.dart';

import 'package:mahilamitra/Screens/tracking/live_tracking_screen.dart';


import 'package:mahilamitra/Screens/helplinescreen/Helpline.dart';

import 'package:mahilamitra/Screens/sos/sos_screen.dart';

import 'package:mahilamitra/Screens/sos/sos_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  HomeScreen({this.userName = "User"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mahila Mitra 💙"),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Optional background logo
          Opacity(
            opacity: 0.05,
            child: Center(
              child: Image.asset(
                "assets/images/logo.jpg",
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, $userName! 👋",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your safety is our priority. Choose an option below to get started.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 30),

                // Grid or List of features
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildFeatureTile(
                        icon: Icons.sos,
                        label: "Smart SOS",
                        color: Colors.redAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SmartSOSScreen()),
                          );
                        },
                      ),
                      _buildFeatureTile(
                        icon: Icons.location_on,
                        label: "Live Tracking",
                        color: Colors.blueAccent,
                        onTap: () {
                          // Navigate to Live Tracking
                                                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LiveTrackingScreen()),
                          );
                        },
                      ),
                      _buildFeatureTile(
                        icon: Icons.shield,
                        label: "AI Detection",
                        color: Colors.deepPurpleAccent,
                        onTap: () {
                          // Navigate to Suspicious Activity Detection
                        },
                      ),
                      _buildFeatureTile(
                        icon: Icons.message,
                        label: "Helpline Chat",
                        color: Colors.green,
                        onTap: () {
                                     Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) =>HelplineChatScreen ()),
                          );   // Navigate to Chat feature
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
