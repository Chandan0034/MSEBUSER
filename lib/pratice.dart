import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<void> fetchAllImages() async {
  try {
    final url = Uri.parse('https://www.mahadiscom.in/en/home/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);

      // Find the <ul> with the class "slides"
      final ulTag = document.querySelector('ul.slides');

      if (ulTag != null) {
        // Find all <img> tags within the <ul>
        final imgTags = ulTag.querySelectorAll('li img');
        for (var imgTag in imgTags) {
          final imgSrc = imgTag.attributes['src'];
          if (imgSrc != null) {
            print('Image Src: $imgSrc');
          }
        }
      } else {
        print('No <ul> with class "slides" found');
      }
    } else {
      print('Failed to load website, Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: ${e.toString()}');
  }
}

void main() async {
  print("Fetching images...");
  await fetchAllImages();
  print("Done");
}
