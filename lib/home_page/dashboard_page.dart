import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/home_page/learn_resources_page.dart';
import 'package:untitled1/home_page/image_picker.dart';
import 'package:untitled1/home_page/live_location.dart';
import 'home_page.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage> {
  LiveLocation liveLocation= LiveLocation();
  int _selectedIndex=0;
  final List<Widget> _pages =const [
    HomePage(),
    ImagePickerWithDescription(),
    ResourcesScreen(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _showMediaSourceSelectionDialog() async {
    try {
      await liveLocation.getLiveLocation();
      if (liveLocation.getLocationIsEnable()) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Choose Media Type'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera (Image)'),
                    onTap: () {
                      Navigator.pop(context);
                      // _pickImageFromCamera();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.videocam),
                    title: Text('Camera (Video)'),
                    onTap: () {
                      Navigator.pop(context);
                      // _pickVideoFromCamera();
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // _setLoading(false);
        // _showSnackBar('Please turn on GPS to continue.', Colors.red);
      }
    } catch (e) {
      // _setLoading(false);
      // _showSnackBar('Error: Location services are disabled. Please enable GPS.', Colors.red);
      print("Error: $e");
    }
  }
  Widget _buildIcon(String iconData, int index, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10,right: 10,top: 1),
            margin: EdgeInsets.only(top: 5),

            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 214, 245, 249)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              iconData,
              height: 28, // Icon size
              width: 30,  // Icon size
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show dialog when the user tries to go back
        return await _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        bottomNavigationBar:  Container(
          height: 62,
          padding: EdgeInsets.only(left: 14,right: 14,top: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              )
            ],
          ),
          child: Center(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIcon("assets/images/Icon_home.png", 0,"Home"),
                    _buildIcon("assets/images/Camera_icon.png", 1,"Camera"),
                    _buildIcon("assets/images/learn_icon.png", 2,"Learn",),

                  ],
                ),
                // Floating action ico
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // Do not exit
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Exit
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }
}
