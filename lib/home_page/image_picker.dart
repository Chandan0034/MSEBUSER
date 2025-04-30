// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:video_player/video_player.dart';
// import 'package:untitled1/live_location.dart';
//
// import 'authentication_page/auth_service.dart';
//
// class ImagePickerWithBottomSheetAndDescription extends StatefulWidget {
//   const ImagePickerWithBottomSheetAndDescription({super.key});
//
//   @override
//   _ImagePickerWithBottomSheetAndDescriptionState createState() =>
//       _ImagePickerWithBottomSheetAndDescriptionState();
// }
// class _ImagePickerWithBottomSheetAndDescriptionState
//     extends State<ImagePickerWithBottomSheetAndDescription> {
//   LiveLocation liveLocation = LiveLocation();
//   AuthService authService = AuthService();
//   File? _mediaFile;
//   String? _description;
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;
//   bool _isVideo = false;
//   bool _isUploading = false;
//   VideoPlayerController? _videoController;
//
//   @override
//   void initState() {
//     super.initState();
//     liveLocation.getLiveLocation();
//   }
//
//   Future<void> _pickImageFromCamera() async {
//     _setLoading(true);
//     _clearMedia();
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//
//     if (pickedFile != null) {
//       setState(() {
//         _mediaFile = File(pickedFile.path);
//         _isVideo = false;
//       });
//     }
//     _setLoading(false);
//   }
//
//   Future<void> _pickImageFromGallery() async {
//     _setLoading(true);
//     _clearMedia();
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _mediaFile = File(pickedFile.path);
//         _isVideo = false;
//       });
//     }
//     _setLoading(false);
//   }
//
//   Future<void> _pickVideoFromCamera() async {
//     _setLoading(true);
//     _clearMedia();
//     final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
//
//     if (pickedFile != null) {
//       setState(() {
//         _mediaFile = File(pickedFile.path);
//         _isVideo = true;
//         _initializeVideoController();
//       });
//     }
//     _setLoading(false);
//   }
//
//   Future<void> _pickVideoFromGallery() async {
//     _setLoading(true);
//     _clearMedia();
//     final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _mediaFile = File(pickedFile.path);
//         _isVideo = true;
//         _initializeVideoController();
//       });
//     }
//     _setLoading(false);
//   }
//
//   void _initializeVideoController() {
//     if (_mediaFile != null) {
//       _videoController = VideoPlayerController.file(_mediaFile!)
//         ..initialize().then((_) {
//           setState(() {});
//         });
//       _videoController!.addListener(() {
//         setState(() {});
//       });
//     }
//   }
//
//   void _clearMedia() {
//     _description = null;
//     _mediaFile = null;
//     if (_videoController != null) {
//       _videoController!.dispose();
//       _videoController = null;
//     }
//   }
//
//   Future<void> _showImageSourceSelectionDialog() async {
//     _setLoading(true);
//     try {
//       await liveLocation.getLiveLocation();
//       if (liveLocation.getLocationIsEnable()) {
//         _setLoading(false);
//         await showModalBottomSheet(
//           context: context,
//           builder: (BuildContext context) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 ListTile(
//                   leading: Icon(Icons.camera_alt),
//                   title: Text('Camera (Image)'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImageFromCamera();
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.photo),
//                   title: Text('Gallery (Image)'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImageFromGallery();
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.videocam),
//                   title: Text('Camera (Video)'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickVideoFromCamera();
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.video_library),
//                   title: Text('Gallery (Video)'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickVideoFromGallery();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         _setLoading(false);
//         _showSnackBar('Please turn on GPS to continue.', Colors.red);
//       }
//     } catch (e) {
//       _setLoading(false);
//       _showSnackBar('Error: Location services are disabled. Please enable GPS.', Colors.red);
//       print("Error: $e");
//     }
//   }
//
//   void _setLoading(bool value) {
//     setState(() {
//       _isLoading = value;
//     });
//   }
//
//   void _showSnackBar(String message, Color backgroundColor) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: backgroundColor,
//       ),
//     );
//   }
//
//   Future<void> _uploadMedia() async {
//     if (_mediaFile == null || _description == null) {
//       _showSnackBar('Please select a media file and enter a description.', Colors.red);
//       return;
//     }
//
//     _setLoading(true);
//     _isUploading = true;
//
//     // Get the user's current location
//     double latitude = liveLocation.getLatitude()!;
//     double longitude = liveLocation.getLongitude()!;
//
//     // Use AuthService to store media data
//     bool success = await authService.storeMediaData(
//       mediaFile: _mediaFile!,
//       fileType: _isVideo ? 'video' : 'image',
//       latitude: latitude,
//       longitude: longitude,
//       description: _description!,
//     );
//
//     if (success) {
//       _showSnackBar('Data successfully uploaded.', Colors.green);
//       _clearMedia();
//     } else {
//       _showSnackBar('Error uploading data.', Colors.red);
//     }
//
//     _setLoading(false);
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: Icon(Icons.arrow_back_ios),
//         title: Center(
//           child: const Text(
//             "Fault Report",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ),
//
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: (){
//                     _showImageSourceSelectionDialog();
//                   },
//
//                   child: Container(
//                     height: 60,
//                     width: 60,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.grey.shade300, width: 1), // Adding a border
//                     ),
//                     child: const Center( // Center the icon within the container
//                       child: Icon(Icons.file_copy, size: 40), // Set size to make it smaller
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 if (_isLoading) const Center(child: CircularProgressIndicator()),
//                 const SizedBox(height: 20),
//                 if (_mediaFile != null) ...[
//                   _isVideo && _videoController != null && _videoController!.value.isInitialized
//                       ? GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _videoController!.value.isPlaying
//                             ? _videoController!.pause()
//                             : _videoController!.play();
//                       });
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.all(10),
//                       child: Column(
//                         children: [
//                           AspectRatio(
//                             aspectRatio: _videoController!.value.size.width >
//                                 _videoController!.value.size.height
//                                 ? 1 / 1
//                                 : 16 / 9,
//                             child: VideoPlayer(_videoController!),
//                           ),
//                           VideoProgressIndicator(
//                             _videoController!,
//                             allowScrubbing: true,
//                             colors: VideoProgressColors(
//                               playedColor: Colors.blue,
//                               bufferedColor: Colors.grey,
//                               backgroundColor: Colors.black12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                       : Image.file(
//                     _mediaFile!,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(height: 10),
//                   // Report button
//
//                   TextField(
//                     onChanged: (value) {
//                       setState(() {
//                         _description = value;
//                       });
//                     },
//                     maxLines: 2,
//                       decoration: InputDecoration(
//                         hintText: 'Describe the issue...',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Instant Report text
//                   if(_mediaFile!=null)
//                     Center(
//                       child: GestureDetector(
//                         onTap: _uploadMedia,
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                           decoration: BoxDecoration(
//                             color: Colors.blueAccent,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Center(
//                             child: const Text(
//                               "Reports",
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                     const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.flash_on, color: Colors.teal),
//                       SizedBox(width: 8),
//                       Text(
//                         'Instant Report',
//                         style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/home_page/dashboard_page.dart';
import 'package:untitled1/home_page/home_page.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:untitled1/home_page/live_location.dart';

import '../authentication_page/auth_service.dart';
import '../local_database/local_database_class.dart';

class ImagePickerWithDescription extends StatefulWidget {
  const ImagePickerWithDescription({super.key});

  @override
  _ImagePickerWithDescriptionState createState() =>
      _ImagePickerWithDescriptionState();
}

class _ImagePickerWithDescriptionState extends State<ImagePickerWithDescription> {
  LiveLocation liveLocation = LiveLocation();
  AuthService authService = AuthService();
  File? _mediaFile;
  String? _description;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isVideo = false;
  String Id= const Uuid().v4().toString();
  bool _isUploading = false;
  bool _isReporting = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    liveLocation.getLiveLocation();
    _showMediaSourceSelectionDialog();
  }
  Future<void> _check() async{
    if(await LocalDatabase().getLocationStatus()=='off'){
      liveLocation.getLiveLocation();
    }
  }
  Future<void> _pickImageFromCamera() async {
    _setLoading(true);
    _clearMedia();
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _isVideo = false;
      });
    }
    _setLoading(false);
  }

  Future<void> _pickVideoFromCamera() async {
    _setLoading(true);
    _clearMedia();
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _isVideo = true;
        _initializeVideoController();
      });
    }
    _setLoading(false);
  }

  void _initializeVideoController() {
    if (_mediaFile != null) {
      _videoController = VideoPlayerController.file(_mediaFile!)
        ..initialize().then((_) {
          setState(() {});
        });
      _videoController!.addListener(() {
        setState(() {});
      });
    }
  }

  void _clearMedia() {
    _description = null;
    _mediaFile = null;
    if (_videoController != null) {
      _videoController!.dispose();
      _videoController = null;
    }
  }

  Future<void> _showMediaSourceSelectionDialog() async {
    _setLoading(true);
    try {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        _setLoading(false);
        _showSnackBar('Please turn on GPS to continue.', Colors.red);
        return;
      }
      _setLoading(false);
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
                    _pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text('Camera (Video)'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideoFromCamera();
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      _setLoading(false);
      _showSnackBar('Error: Unable to check location status. Please try again.', Colors.red);
      print("Error: $e");
    }
  }


  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _uploadMedia() async {
    if (_mediaFile == null || _description == null) {
      _showSnackBar('Please select a media file and enter a description.', Colors.red);
      return;
    }
    _setLoading(true);
    _isUploading = true;

    try {
      // Get the user's current location
      double? latitude = liveLocation.getLatitude();
      double? longitude = liveLocation.getLongitude();

      if (latitude == null || longitude == null) {
        throw Exception('Location not available. Please turn on GPS.');
      }

      // Generate a unique ID for this media
      if (Id.isEmpty) {
        throw Exception('Failed to generate unique ID.');
      }
      String uniqueId = Id;

      // Step 1: Upload data to the server
      bool success = await authService.storeMediaData(
        mediaFile: _mediaFile!,
        fileType: _isVideo ? 'video' : 'image',
        latitude: latitude,
        longitude: longitude,
        description: _description!,
        Id: uniqueId,
      );

      if (!success) {
        throw Exception('Server upload failed.');
      }

      // Step 2: Insert data into the local database
      await LocalDatabase().insertMedia(
        fileUrl: _mediaFile!.path,
        fileType: _isVideo ? 'video' : 'image',
        description: _description!,
        id: uniqueId,
      );

      // Show success message
      _showSnackBar('Data successfully uploaded.', Colors.green);
      _clearMedia();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardPage()));

    } catch (e) {
      print("Error during upload: ${e.toString()}");

      // Step 3: Rollback if needed (delete remote media if server upload succeeded but DB failed)
      try {
        await authService.deleteMediaData(Id); // Rollback on the server if needed
      } catch (rollbackError) {
        print("Error rolling back server data: ${rollbackError.toString()}");
      }

      _showSnackBar('Error uploading data. Rollback initiated.', Colors.red);
    } finally {
      _setLoading(false);
      _isUploading = false;
    }
  }


  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 16,top: 5,right: 16),
        child: Column(
          children: [
            SizedBox(height: 15,),
            const AppBarLayout(), // App bar is fixed
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                    if (_isLoading) const Center(child: CircularProgressIndicator()),
                    if (_mediaFile != null) ...[
                      // Handle video or image display
                      _isVideo &&
                          _videoController != null &&
                          _videoController!.value.isInitialized
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _videoController!.value.isPlaying
                                ? _videoController!.pause()
                                : _videoController!.play();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: _videoController!.value.size.width >
                                      _videoController!.value.size.height
                                      ? 1 / 1
                                      : 16 / 9,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                              VideoProgressIndicator(
                                _videoController!,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: Colors.blue,
                                  bufferedColor: Colors.grey,
                                  backgroundColor: Colors.black12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // Rounded corners

                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20), // Ensure the border radius applies to the image
                                child: Image.file(
                                  _mediaFile!,
                                    width: 300, // Explicitly set the width
                                    height: 350, // Explicitly set the height
                                    fit: BoxFit.cover, // Ensure the image covers the container dimensions
                                  ),
                                ),
                              ),

                      const SizedBox(height: 40),
                      // Description box
                      Container(
                        height: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          },
                          maxLines: 8,
                          decoration: InputDecoration(
                            hintText: 'Describe the issue...',
                            filled: true,
                            fillColor: Color(0xFFF1F9FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Report button
                      if (_mediaFile != null)
                        Center(
                          child: GestureDetector(
                            onTap: (){
                              if (_isReporting) return; // Prevent multiple taps
                              setState(() {
                                _isReporting = true; // Disable further taps
                              });

                              try {
                                 _uploadMedia(); // Perform the upload
                              } catch (e) {
                                print("Error: $e");
                              } finally {
                                setState(() {
                                  _isReporting = false; // Re-enable the button
                                });
                              }
                            },
                            child: Container(
                              width: 220,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF37718E),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  "Report",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // const SizedBox(height: 10),
                      // // Instant Report section
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Image.asset(
                      //       "assets/images/lightning.png",
                      //       height: 15,
                      //       width: 15,
                      //       fit: BoxFit.contain,
                      //     ),
                      //     const Padding(
                      //       padding: const EdgeInsets.only(bottom: 3),
                      //       child: const Text(
                      //         'Instant Report',
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 10,
                      //             fontWeight: FontWeight.w400,
                      //             fontFamily: 'Poppins'),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarLayout extends StatelessWidget {
  const AppBarLayout();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 70, // Height of the app bar
      color: Colors.white, // Background color of the app bar
      padding: const EdgeInsets.symmetric(horizontal: 20), // Padding on sides
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between icons and title
        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
        children: [
          // Back button with styled container
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                iconSize: 14,
                onPressed: () {
                  // Add your action here
                },
              ),
            ),
          ),
          // Title text in the center
          const Text(
            'Fault Report',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          // More options button with styled container
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              "assets/images/twodot.png",
              height: 10,
              width: 10,
              scale: 1,
            ),
          ),
        ],
      ),
    );
  }
}


// InkWell(
//   onTap: () {
//     _showMediaSourceSelectionDialog(); // Trigger dialog to choose media
//   },
//   child: Container(
//     height: 60,
//     width: 60,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: Colors.grey.shade300, width: 1),
//     ),
//     child: const Center(
//       child: Icon(Icons.file_copy, size: 40),
//     ),
//   ),
// ),