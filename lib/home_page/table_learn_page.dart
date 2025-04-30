
import 'package:chewie/chewie.dart';
import 'package:untitled1/home_page/media_item_card_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../authentication_page/auth_service.dart';

class TableViewPage extends StatelessWidget {
  const TableViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _authService.getMediaDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          } else {
            final mediaData = snapshot.data!;
            return ListView.builder(
              itemCount: mediaData.length,
              itemBuilder: (context, index) {
                final mediaItem = mediaData[index];
                return MediaItemCardScreen(mediaItem: mediaItem,cnt: 0,);
              },
            );
          }
        },
      ),
    );
  }
}
