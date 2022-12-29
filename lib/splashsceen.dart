import 'dart:async';
import 'package:banksampah/Home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => login()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( 
        color: Color(0xFF1AD443),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/bwi.png',
              height: 100,
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}
