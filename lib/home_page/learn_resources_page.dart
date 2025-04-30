// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FaultReportScreen(),
//     );
//   }
// }
//
// class FaultReportScreen extends StatelessWidget {
//   const FaultReportScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//         title: const Text(
//           "Fault Report",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               height: 80,
//               width: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade300, width: 2), // Adding a border
//               ),
//               child: const Center( // Center the icon within the container
//                 child: Icon(Icons.file_copy, size: 40), // Set size to make it smaller
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Description input box
//             TextField(
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: 'Describe the issue...',
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Report button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Colors.teal,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Report',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Instant Report text
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.flash_on, color: Colors.teal),
//                 SizedBox(width: 8),
//                 Text(
//                   'Instant Report',
//                   style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  bool isVideosSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 16,top: 5,right: 16),
        child: Column(
          children: [
            SizedBox(height: 15,),
            AppBarLayout(),
            // Toggle buttons for Videos and Blogs
            SizedBox(height: 24,),
            Container(
              height: 55,
              width: 315,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF1F9FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isVideosSelected = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                          color: isVideosSelected ? const Color(0xFF37718E) :Color(0xFFF1F9FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Videos",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              color: isVideosSelected ? Colors.white : Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isVideosSelected = false;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: !isVideosSelected ? const Color(0xFF37718E) : Color(0xFFF1F9FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Blogs",

                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              color: !isVideosSelected ? Colors.white : Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Display the selected screen
            Expanded(
              child: isVideosSelected ?  VideosScreen() : const BlogsScreen(),
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
            'Resources',
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

class VideosScreen extends StatelessWidget {

  final List<Map<String, dynamic>> dummyShorts = [
    {
      "id": "1",
      "title": "Short 1",
      "thumbnailUrl":
      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Big_Buck_Bunny_thumbnail_vlc.png/1200px-Big_Buck_Bunny_thumbnail_vlc.png",
    },
    {
      "id": "2",
      "title": "Short 2",
      "thumbnailUrl":
      "https://i.ytimg.com/vi_webp/gWw23EYM9VM/maxresdefault.webp",
    },
    {
      "id": "3",
      "title": "Short 3",
      "thumbnailUrl":
      "https://img.jakpost.net/c/2019/09/03/2019_09_03_78912_1567484272._large.jpg",
    },
  ];

  final List<Map<String, dynamic>> dummyVideos = [
    {
      "id": "4",
      "title": "How to avoid burning of wire",
      "thumbnailUrl":
      "https://img.jakpost.net/c/2019/09/03/2019_09_03_78912_1567484272._large.jpg",
    },
    {
      "id": "5",
      "title": "What is transformer?",
      "thumbnailUrl":
      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Big_Buck_Bunny_thumbnail_vlc.png/1200px-Big_Buck_Bunny_thumbnail_vlc.png",
    },
    {
      "id": "6",
      "title": "When to look for meter change?",
      "thumbnailUrl":
      "https://i.ytimg.com/vi_webp/gWw23EYM9VM/maxresdefault.webp",
    },
  ];
  VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shorts Section
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dummyShorts.length,
              itemBuilder: (context, index) {
                final short = dummyShorts[index];
                return ShortsVideoCard(
                  thumbnailUrl: short["thumbnailUrl"],
                );
              },
            ),
          ),

          // Regular Videos Section
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummyVideos.length,
            itemBuilder: (context, index) {
              final video = dummyVideos[index];
              return RegularVideoCard(
                thumbnailUrl: video["thumbnailUrl"],
                title: video["title"],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ShortsVideoCard extends StatelessWidget {
  final String thumbnailUrl;

  const ShortsVideoCard({super.key, required this.thumbnailUrl});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          thumbnailUrl,
          height: 200,
          width: 150,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class RegularVideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;

  const RegularVideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              thumbnailUrl,
              height: 100,
              width: 160,

              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Video Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          color: Colors.grey[300],
        );
      },
    );
  }
}


//
// ListView.separated(
// itemCount: 3,
// separatorBuilder: (context, index) => const SizedBox(height: 16),
// itemBuilder: (context, index) {
// return Row(
// children: [
// Container(
// height: 60,
// width: 60,
// decoration: BoxDecoration(
// color: Colors.grey[300],
// borderRadius: BorderRadius.circular(8),
// ),
// child: const Center(
// child: Icon(Icons.video_file, color: Colors.black),
// ),
// ),
// const SizedBox(width: 16),
// const Expanded(
// child: Text(
// "Video title goes here",
// style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
// ),
// ),
// ],
// );
// },
// );