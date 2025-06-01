import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
class AppBarLayout extends StatefulWidget {
  const AppBarLayout();

  @override
  State<AppBarLayout> createState() => _AppBarLayoutState();
}

class _AppBarLayoutState extends State<AppBarLayout> {
  String selectedFilter="inProgress";
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();

              // Then close the app
              if (Platform.isAndroid) {
                SystemNavigator.pop(); // Preferred on Android
              } else if (Platform.isIOS) {
                exit(0); // Force close for iOS (not recommended by Apple)
              }
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

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
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              iconSize: 25,
              onPressed: () {

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
          // GestureDetector(
          //   onTapDown: (TapDownDetails details) async {
          //     final selected = await showMenu<String>(
          //       context: context,
          //       position: RelativeRect.fromLTRB(
          //         details.globalPosition.dx,
          //         details.globalPosition.dy,
          //         details.globalPosition.dx,
          //         details.globalPosition.dy,
          //       ),
          //       items: const [
          //         PopupMenuItem(
          //           value: 'new',
          //           child: Text('New'),
          //         ),
          //         PopupMenuItem(
          //           value: 'inProcess',
          //           child: Text('In Process'),
          //         ),
          //         PopupMenuItem(
          //           value: 'completed',
          //           child: Text('Completed'),
          //         ),
          //       ],
          //     );
          //
          //     if (selected != null) {
          //       setState(() {
          //         selectedFilter = selected;
          //       }); // update global variable
          //       print("Global filter selected: $selectedFilter");
          //       // Optionally trigger UI updates here if needed
          //     }
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.all(8.0),
          //     width: 35,
          //     height: 35,
          //     child: Image.asset("assets/images/filter.png", width: 35, height: 35),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              iconSize: 25,
              onPressed: () {
                _showLogoutDialog(context);
                // Add action for notifications
              },
            ),
          ),
        ],
      ),
    );
  }
}
