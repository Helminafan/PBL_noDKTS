import 'package:banksampah/viewWarga.dart';
import 'package:flutter/material.dart';
import './splashsceen.dart';
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pendataan Data Warga Miskin NON DKTS",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
