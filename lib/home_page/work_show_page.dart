import 'package:flutter/material.dart';
class WorkShowPage extends StatefulWidget {
  final Map<String, dynamic> mediaItem;
  final int cnt;
  const WorkShowPage({super.key,required this.mediaItem,required this.cnt});

  @override
  State<WorkShowPage> createState() => _WorkShowPageState();
}

class _WorkShowPageState extends State<WorkShowPage> {
  final List<String> statuses = [
    "Report confirmed",
    "Admin has seen your report.",
    "Admin reported to workers.",
    "Work has been started on this issue.",
    "Issue has been solved."
  ];
  int currentStatus = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStatus=widget.cnt;
  }
  @override
  Widget build(BuildContext context) {
    final downloadURL = widget.mediaItem['completedURL'] ?? '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              margin: EdgeInsets.only(top: 60, left: 10, right: 10),
              alignment: Alignment.topLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15), // Apply border radius here
                child: Image.network(
                  downloadURL,
                  fit: BoxFit.fill,
                  height: 400,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),

            // Status Timeline
            Padding(
              padding: const EdgeInsets.only(left: 20),
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
                          // Animated Icon
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: index <= currentStatus ? Colors.blue : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: index <= currentStatus ? Colors.white : Colors.transparent,
                                size: 15,
                              ),
                            ),
                          ),
                          // Animated Pipe (Vertical line)
                          if (index < statuses.length - 1)
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              width: 4,
                              height: 40,
                              color: index < currentStatus + 1 ? Colors.blue : Colors.grey,
                            ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 500),
                          style: TextStyle(
                            color: index <= currentStatus ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.bold,
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
      )
    );
  }
}
