import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/authentication_page/auth_service.dart';
import 'media_item_card_screen.dart';

class ReportUpdateScreen extends StatefulWidget {
  const ReportUpdateScreen({super.key});

  @override
  State<ReportUpdateScreen> createState() => _ReportUpdateScreenState();
}

class _ReportUpdateScreenState extends State<ReportUpdateScreen> {
  final AuthService _authService = AuthService();
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  List<String> _imageUrls = [
    "https://www.mahadiscom.in/wp-content/uploads/2024/12/small-Slider-design-1.png",
    "https://www.mahadiscom.in/wp-content/uploads/2024/09/Creative-500x714.jpg",
    "https://www.mahadiscom.in/wp-content/uploads/2024/08/design-1.png",
    "https://www.mahadiscom.in/wp-content/uploads/2025/01/Untitled-design-41_new-fff-min-500x714.png",
    "https://www.mahadiscom.in/wp-content/uploads/2024/05/Untitled-design-66.png",
    "https://www.mahadiscom.in/wp-content/uploads/2023/10/Untitled-design.png",
    "https://www.mahadiscom.in/wp-content/uploads/2020/10/IMG-20201021-WA0002-500x714.jpg",
    "https://www.mahadiscom.in/wp-content/uploads/2022/09/Untitled-design-4.jpg",
    "https://www.mahadiscom.in/wp-content/uploads/2021/03/advertisement4.jpg"
    "https://www.mahadiscom.in/wp-content/uploads/2018/07/MahavitaranWebsiteAdEng-500x714.jpg",
    "https://www.mahadiscom.in/wp-content/uploads/2023/01/ELECTRIC-PROMO.png",
    "https://www.mahadiscom.in/wp-content/uploads/2023/01/slider_banner_fraud1-500x714.jpg",
    "https://www.mahadiscom.in/wp-content/uploads/2024/05/3.png",
    "https://www.mahadiscom.in/wp-content/uploads/2024/05/4.png",
    "https://www.mahadiscom.in/wp-content/uploads/2024/05/WhatsApp-Image-2024-05-30-at-4.32.35-PM.jpeg",
    "https://www.mahadiscom.in/wp-content/uploads/2023/01/slider_banner_fraud2-500x714.jpg"

  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _fetchImages();
    _startAutoSlide();
  }
  Future<void> _fetchImages() async {
    try {
      final url = Uri.parse('https://www.mahadiscom.in/en/home/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        final ulTag = document.querySelector('ul.slides');
        if (ulTag != null) {
          final imgTags = ulTag.querySelectorAll('li img');
          final imgUrls = imgTags
              .map((imgTag) => imgTag.attributes['src'])
              .whereType<String>()
              .map((src) =>
          src.startsWith('http') ? src : url.origin + src) // Handle relative URLs
              .toList();
          setState(() {
            _imageUrls = imgUrls;
          });
        }
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_imageUrls.isNotEmpty) {
        _currentPage = (_currentPage + 1) % _imageUrls.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Collapsible AppBar with an image
          SliverAppBar(
            expandedHeight: 180,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: _imageUrls.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: _imageUrls[index],
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  );
                },
              ),
            ),
          ),

          // Fixed header below the collapsible image
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 15, top: 15), // Add bottom margin for spacing
              child: const Text(
                "Report Updates",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          // Scrollable content with StreamBuilder
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _authService.fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      );
                    } else {
                      final mediaData = snapshot.data!.docs;

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
                        shrinkWrap: true, // Wrap content size
                        itemCount: mediaData.length,
                        itemBuilder: (context, index) {
                          final mediaItem = mediaData[index].data();

                          // Calculate the count of completed statuses
                          int completedCount = 0;
                          for (var status in mediaItem['statusList']) {
                            if (status['completed'] == true) {
                              completedCount++;
                            }
                          }

                          return MediaItemCardScreen(
                              mediaItem: mediaItem,
                              cnt: completedCount -2, // Adjusted count
                          );
                        },
                      );
                    }
                  },
                );
              },
              childCount: 1, // Since StreamBuilder outputs one list
            ),
          ),
        ],
      ),
    );
  }
}


// return ListView.builder(
//   itemCount: 2,
//     itemBuilder: (context,index){
//       return Container(
//         margin: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(.4),
//           borderRadius: BorderRadius.circular(10)
//         ),
//         child: Column(
//           children: [
//             Container(
//               margin: EdgeInsets.all(10),
//               alignment: Alignment.topLeft,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20), // Apply border radius here
//                 child: Image.network(
//                   "https://firebasestorage.googleapis.com/v0/b/garbage-c3c93.appspot.com/o/media%2FSeDqRCnuiZT4kT2VGW2Y93tovBC2%2F1731524386045.jpg?alt=media&token=440544fb-d29b-4450-a9ae-ec6a8a822e94",
//                   fit: BoxFit.contain,
//                   height: 300,
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }
// );
//}
