import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/authentication_page/login_page.dart';
import 'package:untitled1/home_page/dashboard_page.dart';
import 'package:untitled1/home_page/image_picker.dart';
import 'package:untitled1/pratice.dart';
import 'package:untitled1/splash_widget/second_splash_page.dart';
import 'package:untitled1/splash_widget/splash_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user=FirebaseAuth.instance.currentUser;
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Picker',

      home:user!=null?SplashScreen(): SecondSplashPage(),
    );
  }
}
// class HomeApp extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() =>_MyAppState();
// }
// class _MyAppState extends State<HomeApp> {
//   late double latitudes;
//   late double longitudes;
//   final TextEditingController _descriptionController = TextEditingController();
//   File? image;
//   final _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }
//
//   // Check if location services are enabled, and request permission if needed
//   Future<void> _checkLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       await Geolocator.requestPermission();
//     }
//
//     bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isLocationEnabled) {
//       await Geolocator; // Open location settings to turn on GPS
//     }
//   }
//
//   // Pick image and get location
//   Future<void> pickImageAndGetLocation() async {
//     try {
//       // Ensure location is enabled
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       latitudes = position.latitude;
//       longitudes = position.longitude;
//
//       // Pick image
//       final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//       if (pickedFile != null) {
//         setState(() {
//           image = File(pickedFile.path);
//         });
//         _showDescriptionDialog(); // Prompt user to enter a description
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   // Show dialog to enter a description
//   void _showDescriptionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add Description'),
//           content: TextField(
//             controller: _descriptionController,
//             decoration: const InputDecoration(hintText: "Enter a description"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _submitReport();
//               },
//               child: const Text("Submit"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Submit report (display image, description, and location)
//   void _submitReport() {
//     if (image != null && _descriptionController.text.isNotEmpty) {
//       // Perform actions after the user picks an image and adds a description
//       // (e.g., display the details on the UI or handle it accordingly)
//       print("Image path: ${image!.path}");
//       print("Description: ${_descriptionController.text}");
//       print("Location: Latitude = $latitudes, Longitude = $longitudes");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: const Text(
//                   "Dashboard Options",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 28.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Center(
//                   child: Wrap(
//                     spacing: 20.0,
//                     runSpacing: 20.0,
//                     children: [
//                       // Report Card (Pick Image, Add Description, Get Location)
//                       SizedBox(
//                         width: 160.0,
//                         height: 160.0,
//                         child: InkWell(
//                           onTap: () {
//                             pickImageAndGetLocation();
//                           },
//                           child: Card(
//                             color: const Color.fromARGB(255, 21, 21, 21),
//                             elevation: 2.0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: const [
//                                     Text(
//                                       "Report",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 20.0,
//                                       ),
//                                     ),
//                                     SizedBox(height: 5.0),
//                                     Text(
//                                       "Report Garbage",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w100,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
