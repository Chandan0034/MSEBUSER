// import 'dart:io';
//
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:untitled1/home_page/work_show_page.dart';
// import 'package:untitled1/local_database/local_database_class.dart';
// import 'package:video_player/video_player.dart';
//
// class MediaItemCardScreen extends StatefulWidget {
//   final Map<String, dynamic> mediaItem;
//   final int cnt;
//
//   const MediaItemCardScreen({Key? key, required this.mediaItem, required this.cnt}) : super(key: key);
//
//   @override
//   _MediaItemCardScreenState createState() => _MediaItemCardScreenState();
// }
//
// class _MediaItemCardScreenState extends State<MediaItemCardScreen>
//     with AutomaticKeepAliveClientMixin {
//   VideoPlayerController? _videoPlayerController;
//   ChewieController? _chewieController;
//   int currentStatus = 0;
//   bool isMediaReady = false;
//   String downloadURL="";
//   final List<String> statuses = [
//     "Report confirmed",
//     "Admin has seen your report.",
//     "Admin reported to workers.",
//     "Work has been started on this issue.",
//     "Issue has been solved."
//   ];
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() async{
//     super.initState();
//     final item  = await LocalDatabase().fetchMediaById(widget.mediaItem['id']);
//     for(Map<String,dynamic> map in item){
//       if(map['id']==widget.mediaItem['id']){
//         downloadURL=map['id'];
//         print("Download Url  ${downloadURL}");
//       }
//     }
//     // print(widget.cnt);
//     // currentStatus = widget.cnt;
//     // if (widget.mediaItem['fileType'] == 'video') {
//     //   _checkMediaAvailability(widget.mediaItem['downloadURL'], isVideo: true);
//     // } else {
//     //   _checkMediaAvailability(widget.mediaItem['downloadURL']);
//     // }
//   }
//
//   // Check if the media is available (status code 200)
//   // Future<void> _checkMediaAvailability(String mediaUrl, {bool isVideo = false}) async {
//   //   try {
//   //     final response = await http.get(Uri.parse(mediaUrl));
//   //     if (response.statusCode == 200) {
//   //       if (isVideo) {
//   //         _initializeVideoPlayer(mediaUrl);
//   //       } else {
//   //         setState(() {
//   //           isMediaReady = true;
//   //         });
//   //       }
//   //     } else {
//   //       setState(() {
//   //         isMediaReady = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       isMediaReady = false;
//   //     });
//   //   }
//   // }
//
//   Future<void> _initializeVideoPlayer(String videoUrl) async {
//     _videoPlayerController = VideoPlayerController.network(videoUrl);
//     await _videoPlayerController!.initialize();
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController!,
//       autoPlay: false,
//       looping: false,
//       allowFullScreen: true,
//     );
//     setState(() {}); // Update the widget after initialization.
//   }
//
//   @override
//   void dispose() {
//     _chewieController?.dispose();
//     _videoPlayerController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // Required for AutomaticKeepAliveClientMixin.
//     final isImage = widget.mediaItem['fileType'] == 'image';
//     currentStatus = widget.cnt;
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.all(12),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display the media file at the top (Image or Video)
//             if (isImage)
//               Row(
//                 children: [
//                   Container(
//                     alignment: Alignment.topLeft,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: Image.file(
//                         downloadURL as File,
//                         fit: BoxFit.fill,
//                         height: 300,
//                         width: 180,
//                         // loadingBuilder: (context, child, loadingProgress) {
//                         //   if (loadingProgress == null) return child;
//                         //   return Center(
//                         //     child: CircularProgressIndicator(
//                         //       value: loadingProgress.expectedTotalBytes != null
//                         //           ? loadingProgress.cumulativeBytesLoaded /
//                         //           (loadingProgress.expectedTotalBytes ?? 1)
//                         //           : null,
//                         //     ),
//                         //   );
//                         // },
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: statuses.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         String status = entry.value;
//
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               children: [
//                                 AnimatedContainer(
//                                   duration: Duration(milliseconds: 500),
//                                   width: 24,
//                                   height: 24,
//                                   decoration: BoxDecoration(
//                                     color: index <= currentStatus
//                                         ? Colors.blue
//                                         : Colors.white,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(color: Colors.blue),
//                                   ),
//                                   child: Center(
//                                       child: Icon(
//                                         Icons.check,
//                                         color: Colors.white,
//                                         size: 15,
//                                       )),
//                                 ),
//                                 if (index < statuses.length - 1) ...[
//                                   AnimatedContainer(
//                                     duration: Duration(seconds: 1),
//                                     width: 4,
//                                     height: 40,
//                                     color: index < currentStatus + 1
//                                         ? Colors.blue
//                                         : Colors.grey,
//                                   ),
//                                 ],
//                               ],
//                             ),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: AnimatedDefaultTextStyle(
//                                 duration: Duration(milliseconds: 500),
//                                 style: TextStyle(
//                                     color: index <= currentStatus
//                                         ? Colors.black
//                                         : Colors.grey,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: "Poppins"),
//                                 child: Text(status),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               )
//
//             else if (_chewieController != null &&
//                 _videoPlayerController!.value.isInitialized)
//               AspectRatio(
//                 aspectRatio: _videoPlayerController!.value.aspectRatio,
//                 child: Chewie(controller: _chewieController!),
//               )
//             else
//               const Center(child: CircularProgressIndicator()),
//
//             const SizedBox(height: 10),
//
//             // Display description below the media file
//             Text(
//               "Date : ${widget.mediaItem['date']}",
//               style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                   fontFamily: "Poppins"),
//             ),
//             const SizedBox(height: 2),
//             Text("Time : ${widget.mediaItem['time']}",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                     fontFamily: "Poppins")),
//             const SizedBox(height: 8),
//
//             // Display location information below the description
//             const SizedBox(height: 8),
//             GestureDetector(
//               onTap: () {
//                 widget.cnt == 4
//                     ? Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => WorkShowPage(
//                           mediaItem: widget.mediaItem,
//                           cnt: widget.cnt,
//                         )))
//                     : ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('processing wait...'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               },
//               child: Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
//                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: widget.cnt == 4
//                       ? Colors.white
//                       : Colors.white.withOpacity(.3),
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: widget.cnt == 4
//                           ? Colors.grey.withOpacity(0.5)
//                           : Colors.white,
//                       blurRadius: 5,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     "View Final Work",
//                     style: TextStyle(
//                       fontFamily: "Poppins",
//                       color: widget.cnt == 4 ? Colors.black : Colors.black.withOpacity(.1),
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/home_page/work_show_page.dart';
import 'package:untitled1/local_database/local_database_class.dart';
import 'package:video_player/video_player.dart';

class MediaItemCardScreen extends StatefulWidget {
  final Map<String, dynamic> mediaItem;
  final int cnt;


  const MediaItemCardScreen({Key? key, required this.mediaItem, required this.cnt}) : super(key: key);

  @override
  _MediaItemCardScreenState createState() => _MediaItemCardScreenState();
}

class _MediaItemCardScreenState extends State<MediaItemCardScreen>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String downloadURL = "";
  bool isMediaReady = false;


  final List<String> statuses = [
    "Report confirmed",
    "Admin reported to workers.",
    "Work has been started on this issue.",
    "Issue has been solved."
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print("Idx");
    print(widget.mediaItem['id']);
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    try {
      final its=await LocalDatabase().fetchAllMedia();
      print("List of item");
      print(its);
      final List<Map<String, dynamic>> items =
      await LocalDatabase().fetchMediaById(widget.mediaItem['id']);
      if (items.isNotEmpty) {
        for (Map<String, dynamic> map in items) {
          if (map['id'] == widget.mediaItem['id']) {
            downloadURL = map['file_url'] ?? ""; // Fallback to an empty string if `file_url` is null.
            print("Fetched file URL: ${map['file_url']}");
            break;
          }
        }
      } else {
        debugPrint("No media found for ID: ${widget.mediaItem['id']}");
      }
      setState(() {}); // Update the UI with the fetched data.
    } catch (e) {
      debugPrint("Error fetching media: $e");
    }
  }


  Future<void> _initializeVideoPlayer(String videoUrl) async {
    try {
      _videoPlayerController = VideoPlayerController.network(videoUrl);
      await _videoPlayerController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
      );
      setState(() {
        isMediaReady = true;
      });
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isImage = widget.mediaItem['fileType'] == 'image';
    downloadURL=widget.mediaItem['downloadURL']??'';
    final currentStatus = widget.cnt;
    final workiscompleted=widget.mediaItem['isCompleted'];
    return Card(
      color: Color(0xFFECECEC),
      elevation: 0,
      margin: const EdgeInsets.only(left: 20 , right: 20, bottom: 25),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the media file at the top (Image or Video)
            if (isImage)

               Row(
      children: [
      Container(
        alignment: Alignment.topLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: downloadURL,
            fit: BoxFit.fill,
            height: 300,
            width: 180,
            placeholder: (context, url) => Container(
              height: 300,
              width: 180,
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 300,
              width: 180,
              color: Colors.white,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: statuses.asMap().entries.map((entry) {
            int index = entry.key;
            String status = entry.value;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: index <= currentStatus ? Colors.blue : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    if (index < statuses.length - 1)
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: 4,
                        height: 40,
                        color: index < currentStatus + 1 ? Colors.blue : Colors.grey,
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                      color: index <= currentStatus ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                    ),
                    child: Text(status),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      ],
    )

    else if (_chewieController != null &&
                _videoPlayerController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
            else
              const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 10),

            // Display description below the media file
            Text(
              "Date : ${widget.mediaItem['date']}",
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: "Poppins"),
            ),
            const SizedBox(height: 2),
            Text("Time : ${widget.mediaItem['time']}",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: "Poppins")),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () {
                widget.cnt == 4
                    ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkShowPage(
                      mediaItem: widget.mediaItem,
                      cnt: widget.cnt,
                    ),
                  ),
                )
                    : ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait issue is being solved'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: widget.cnt == 4
                      ? Colors.white
                      : Colors.white.withOpacity(.3),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: widget.cnt == 4
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.transparent,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "View Final Work",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: widget.cnt == 4
                          ? Colors.black
                          : Colors.black.withOpacity(.1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
