import 'package:flutter/material.dart';
import 'package:mahilamitra/Screens/splash_intro/splash_screen.dart';


void main() {
  runApp(MeriRakshaApp());
}

class MeriRakshaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeriRaksha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SplashScreen(),
    );
  }
}

