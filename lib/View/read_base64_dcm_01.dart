import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ReadBase64Dcm01 extends StatefulWidget {
  const ReadBase64Dcm01({super.key});

  @override
  State<ReadBase64Dcm01> createState() => _ReadBase64Dcm01State();
}

class _ReadBase64Dcm01State extends State<ReadBase64Dcm01> {
  // Property
  String result = ''; // Json의 Image Data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base64 DCM01 File'),
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
              return Image.memory(
                base64Decode(result),
                // 이미지의 포맷을 명시적으로 지정
                semanticLabel: 'Image',
                excludeFromSemantics: true,
                filterQuality: FilterQuality.high,
                alignment: Alignment.center,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Text('Invalid image data');
                },
              );
            }
          },
        ),
      ),
    );
  }

  // --- Functions ---
  Future fetchImage() async {
    var url = Uri.parse("http://localhost:5000/base64_dcm01_file");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['result'];
  }
} // End
