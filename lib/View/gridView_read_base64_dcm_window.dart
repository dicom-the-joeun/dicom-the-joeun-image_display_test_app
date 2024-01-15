import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class gridViewReadBase64DcmWindow extends StatefulWidget {
  const gridViewReadBase64DcmWindow({super.key});

  @override
  State<gridViewReadBase64DcmWindow> createState() => _gridViewReadBase64DcmWindowState();
}

class _gridViewReadBase64DcmWindowState extends State<gridViewReadBase64DcmWindow> {
  //property
  String result = '';
  double windowCenter = 0.0;
  double windowWidth = 0.0;

  @override
  void initState() {
    getWindowLevel();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DCMGridView - WindowCenterList'),
      ),
      body: Expanded(
        child: GridView.builder(
          // itemCount: GirdList!.list!.length, //item갯수
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //한행에 보여줄 item갯수
            childAspectRatio: 1/2, //item의 가로1, 세로2 비율
            // mainAxisSpacing: 10 //수평패딩
            // crossAxisSpacing: 10 //수직패딩
          ), 
          itemBuilder: (BuildContext context, int index){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      // "windonw Center : ${windowCenter.toStringAsFixed(1)} / window Width : ${windowWidth.toStringAsFixed(2)}"
                      "windonw Center : ${windowCenter.toStringAsFixed(1)} \n"
                      "windonw Width : ${windowWidth.toStringAsFixed(1)} "
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: 600,
                    child: FutureBuilder(
                      future: fetchImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
            );
          }
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
    // print(">>> ${windowCenter.toStringAsFixed(1)} / ${windowWidth.toStringAsFixed(2)}");
  }
  Future<void> getWindowLevel() async {
    var url = Uri.parse("http://localhost:5000/base64_dcm_window_file?wc=$windowCenter&ww=$windowWidth");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

    // Extract 'windowCenter' and 'windowWidth' values from the JSON response
    double receivedWindowCenter = dataConvertedJSON['windowCenter'];
    double receivedWindowWidth = dataConvertedJSON['windowWidth'];

    // Now you can use receivedWindowCenter and receivedWindowWidth as needed
    print("Received Window Center: $receivedWindowCenter");
    print("Received Window Width: $receivedWindowWidth");

    windowCenter = receivedWindowCenter;
    windowWidth = receivedWindowWidth;
    print(windowCenter);
    print(windowWidth);
  }
  
}//END
