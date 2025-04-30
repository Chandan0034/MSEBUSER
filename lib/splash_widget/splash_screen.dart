import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/authentication_page/login_page.dart';
import 'package:untitled1/home_page/dashboard_page.dart';// Import your login page

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // User is signed in, navigate to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()), // Replace with your dashboard page
        );
      } else {
        // No user is signed in, navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/mseb_icon.png'), // Your custom logo
            const SizedBox(height: 20),
            const Text(
              'MahaVitaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: "Poppins"),
            ),
          ],
        ),
      ),
    );
  }
}
