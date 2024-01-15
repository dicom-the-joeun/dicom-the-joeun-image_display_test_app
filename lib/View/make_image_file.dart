import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MakeImageFile extends StatelessWidget {
  const MakeImageFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Image File'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // 이미지를 표시하는 위젯을 반환
              return Image.memory(snapshot.data!.bodyBytes);
            }
          },
        ),
      ),
    );
  }

  // --- Functions ---
  Future fetchImage() async {
    var url = Uri.parse("http://localhost:5000/make_image_file");
    return await http.get(url);
  }
} // End
