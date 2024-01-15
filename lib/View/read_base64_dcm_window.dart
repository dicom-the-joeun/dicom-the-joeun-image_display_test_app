import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadBase64DcmWindow extends StatefulWidget {
  const ReadBase64DcmWindow({super.key});

  @override
  State<ReadBase64DcmWindow> createState() => _ReadBase64DcmWindowState();
}

class _ReadBase64DcmWindowState extends State<ReadBase64DcmWindow> {
  // Property
  String result = ''; // Json의 Image Data
  double windowCenter = 0.0;
  double windowWidth = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    getWindowLevel();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DCM File - Window Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Window Center: ${windowCenter.toStringAsFixed(1)} / Window Width: ${windowWidth.toStringAsFixed(2)}"
              ),
            ),
            Row( // Window Center
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    windowCenter -= 100;
                    fetchImage();
                    setState(() {});
                  }, 
                  child: const Text('WC: -100'),
                ),
                ElevatedButton(
                  onPressed: () {
                    windowCenter += 100;
                    fetchImage();
                    setState(() {});
                  }, 
                  child: const Text('WC: +100'),
                ),
              ],
            ),
            Row( // Window Width
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    windowWidth -= 0.05;
                    fetchImage();
                    setState(() {});
                  }, 
                  child: const Text('WW: -0.05'),
                ),
                ElevatedButton(
                  onPressed: () {
                    windowWidth += 0.05;
                    fetchImage();
                    setState(() {});
                  }, 
                  child: const Text('WW: +0.05'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                windowCenter = 0;
                windowWidth = 0;
                fetchImage();
                setState(() {});                
              }, 
              child: const Text('Reset'),
            ),
// 강사님 코드 END
//내코드 Start
  //Slide Action(windowCenter)
            Slider(
              value: windowCenter,
              max: 10000,
              min: -10000,
              label: windowCenter.toString(),
              onChanged: (double value) {
                windowCenter = value;
                fetchImageBySlider();
                setState(() { });
              }
            ),
  //Slide Action(windowWidth)
            Slider(
              value: windowWidth,
              max: 10000,
              min: -10000,
              label: windowCenter.toString(),
              onChanged: (double value) {
                windowCenter = value;
                fetchImageBySlider();
                setState(() { });
              }
            ),

            SizedBox(
              width: 400,
              height: 600,
              child: FutureBuilder(
                future: fetchImage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return const CircularProgressIndicator();
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // 이미지를 표시하는 위젯을 반환
                    return SizedBox(
                      width: 4200,
                      height: 600,
                      child: Image.memory(
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
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Functions ---
  Future fetchImage() async {
    var url = Uri.parse("http://localhost:5000/base64_dcm_window_file?wc=$windowCenter&ww=$windowWidth");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['result'];
    print(">>> ${windowCenter.toStringAsFixed(1)} / ${windowWidth.toStringAsFixed(2)}");
  }

  Future fetchImageBySlider() async {
    var url = Uri.parse("http://localhost:5000/base64_dcm_window_file?wc=$windowCenter&ww=$windowWidth");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['result'];
  }

  Future<void> getWindowLevel() async {
  var url = Uri.parse("http://localhost:5000/base64_dcm_window_file?wc=$windowCenter&ww=$windowWidth");
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var dataConvertedJSON = json.decode(response.body);

    double receivedWindowCenter = dataConvertedJSON['windowCenter'];
    double receivedWindowWidth = dataConvertedJSON['windowWidth'];

    print("Received Window Center: $receivedWindowCenter");
    print("Received Window Width: $receivedWindowWidth");

    windowCenter = receivedWindowCenter;
    windowWidth = receivedWindowWidth;
    print(windowCenter);
    print(windowWidth);
    setState(() {
      
    });
  } else {
    print("Failed to get window level. Status code: ${response.statusCode}");
  }
}


} // End
