import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/home_page/report_update_screen.dart';
import 'package:untitled1/home_page/live_location.dart';
import 'package:untitled1/local_database/local_database_class.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user=FirebaseAuth.instance.currentUser;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    LiveLocation().getLiveLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children: [
          SizedBox(height: 25),
          AppBarLayout(),

          Expanded(child: const ReportUpdateScreen()),
        ]
      )
    );
  }
}
class AppBarLayout extends StatelessWidget {
  const AppBarLayout();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      // Height of the custom app bar
      color: Colors.white,
      // Background color
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // Side padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Spacing between elements
        crossAxisAlignment: CrossAxisAlignment.center,
        // Vertical alignment
        children: [
          // Leading icon (e.g., a globe icon for language)
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.language, color: Colors.black),
              iconSize: 25,
              onPressed: () {
                // Add action for leading icon
              },
            ),
          ),
          // Title (Image + Text)
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/mseb_icon.png',
                  height: 22,
                  width: 40,
                  fit: BoxFit.contain,
                ),
                const Text(
                  "MahaVitaran",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Action icon (e.g., notification button)
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              iconSize: 25,
              onPressed: () {
                // Add action for notifications
              },
            ),
          ),
        ],
      ),
    );
  }
}
