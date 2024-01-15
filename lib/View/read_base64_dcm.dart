import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadBase64Dcm extends StatefulWidget {
  const ReadBase64Dcm({super.key});

  @override
  State<ReadBase64Dcm> createState() => _ReadBase64DcmState();
}

class _ReadBase64DcmState extends State<ReadBase64Dcm> {
  // Property
  String result = ''; // Json의 Image Data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base64 DCM File'),
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
                colorBlendMode: BlendMode.darken,
                
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
    var url = Uri.parse("http://localhost:5000/base64_dcm_file");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['result'];
  }
} // End
