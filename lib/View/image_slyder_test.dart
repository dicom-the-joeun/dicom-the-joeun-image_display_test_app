// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:archive/archive.dart';
// import 'package:archive/archive_io.dart';

// class image_slyder_test extends StatefulWidget {
//   const image_slyder_test({super.key});

//   @override
//   State<image_slyder_test> createState() => _image_slyder_testState();
// }

// class _image_slyder_testState extends State<image_slyder_test> {
//   // Property
//   String result = ''; // Json의 Image Data
//   double windowCenter = 0.0;
//   double windowWidth = 0.0;



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("image_slyder_test")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 400,
//               height: 600,
//               child: FutureBuilder(
//                 future: fetchImagesFromDirectory('${directory.path}/100extracted'),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   } else if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     // 이미지를 표시하는 위젯을 반환
//                     return SizedBox(
//                       width: 400,
//                       height: 600,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: images.length,
//                         itemBuilder: (context, index) {
//                           return Image.file(images[index]);
//                         },
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//   //           //Slide Action(windowCenter)
//   //           Slider(
//   //             value: windowCenter,
//   //             max: 10000,
//   //             min: -10000,
//   //             label: windowCenter.toString(),
//   //             onChanged: (double value) {
//   //               windowCenter = value;
//   //               fetchImageBySlider();
//   //               setState(() { });
//   //             }
//   //           ),
//   // //Slide Action(windowWidth)
//   //           Slider(
//   //             value: windowWidth,
//   //             max: 10000,
//   //             min: -10000,
//   //             label: windowCenter.toString(),
//   //             onChanged: (double value) {
//   //               windowCenter = value;
//   //               fetchImageBySlider();
//   //               setState(() { });
//   //             }
//   //           ),
//           ],
//         ),
//       ),
//     );
//   }
//   // --- Functions ---
  
  
//   zipOpen() async {
//     final directory = await getApplicationDocumentsDirectory();              //server에서 받아올 zip파일이 다운될 곳
//     print(directory.path);
//     final zipFilePath = '${directory.path}/100.zip';         //받아온 zip파일의 이름이 들어갈 곳
//     final destinationDirectory = '${directory.path}/100extracted'; //받아온 zip파일을 압축해제한 파일들이 들어갈 곳

//     File zipFile = File(zipFilePath); 

//     if (zipFile.existsSync()) {
//       List<int> bytes = zipFile.readAsBytesSync();
//       Archive archive = ZipDecoder().decodeBytes(Uint8List.fromList(bytes));

//       for (ArchiveFile file in archive) {
//         String fileName = '$destinationDirectory/${file.name}';
//         File outFile = File(fileName);
//         // outFile.createSync(recursive: true);
//         outFile.parent.createSync(recursive: true); // 디렉토리가 없으면 생성


//         if (file.isFile) {
//           outFile.writeAsBytesSync(file.content as List<int>);
//         } else {
//           Directory(fileName).create(recursive: true);
//         }
//       }

//       print('압축 파일이 성공적으로 해제되었습니다.');
//     } else {
//       print('지정된 압축 파일이 존재하지 않습니다.');
//     }
//   }

//   Future<List<File>> fetchImagesFromDirectory(String directoryPath) async {
//     Directory directory = Directory(directoryPath);
//     List<File> images = [];

//     if (directory.existsSync()) {
//       List<FileSystemEntity> files = directory.listSync();

//       for (var file in files) {
//         if (file is File && file.path.toLowerCase().endsWith('.png')) {
//           images.add(file);
//         }
//       }
//     }

//     return images;
//   }
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:photo_view/photo_view.dart';

class image_slider_test extends StatefulWidget {
  const image_slider_test({Key? key}) : super(key: key);

  @override
  State<image_slider_test> createState() => _image_slider_testState();
}

class _image_slider_testState extends State<image_slider_test> {
  List<File> images = [];
  late Directory directory;
  late double gamma;
  late bool isConverted; // 반전 눌렀는지
  int _index = 10;
  late PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    super.initState();
    // images = fetchImagesFromDirectory(); // FutureBuilder 대신 여기서 이미지를 초기에 가져옴
    print(images.length);
    gamma = 1.0;
    isConverted = false;
    scaleStateController = PhotoViewScaleStateController();
  }



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("image_slider_test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async => images = await fetchImagesFromDirectory(), 
              child: const Text('images get from directory')
            ),
            
            SizedBox(
              height: 800,
              // child: ListView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemCount: images.length,
              //   itemBuilder: (context, index) {
              //     return Image.file(images[index]);
              //   },
              // ),
              child: ColorFiltered(

                colorFilter: ColorFilter.matrix([
                  gamma,0,0,0, !isConverted ? 0 : 255, //R
                  0,gamma,0,0, !isConverted ? 0 : 255, //G
                  0,0,gamma,0, !isConverted ? 0 : 255,//B
                  0,0,0,1,0,//A
                ]),
                child: PhotoView(
                  enableRotation: true,
                  scaleStateController: scaleStateController,
                  filterQuality: FilterQuality.high,
                  imageProvider: AssetImage(
                    '/Users/msk/Library/Developer/CoreSimulator/Devices/82AA6129-900A-4E56-BA3B-9B6DDE681450/data/Containers/Data/Application/389EB078-AC4B-4ABC-8FC4-844F571B6693/Documents/20extracted/20/${(_index).toInt().toString().padLeft(3, '0')}img.png'
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 1000,
              child: CupertinoSlider(
                value: _index.toDouble(),
                max: 20.0,
                divisions: 20,
                onChanged: (double value) {
                  setState(() {
                    _index = value.toInt();
                  });
                },
              ),
            ),
            SizedBox(
              width: 1000,
              child: CupertinoSlider(
                value: gamma,
                min: -5,
                max: 5.0,
                divisions: 100,
                onChanged: (double value) {
                  setState(() {
                    gamma = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                gamma = gamma * -1;
                isConverted = !isConverted;
                setState(() {
                  
                });
              }, 
              child: Text('반전'),
            ),
          ],
        ),
      ),
    );
  }
  //function
  // 이미지를 초기에 가져오는 함수
  Future<List<File>> fetchImagesFromDirectory() async {
    List<File> images = [];
    final directory = await getApplicationDocumentsDirectory();
    Directory imagesDirectory = Directory('${directory.path}/20extracted/20');

    if (imagesDirectory.existsSync()) {
      List<FileSystemEntity> files = imagesDirectory.listSync();

      for (var file in files) {
        if (file is File && file.path.toLowerCase().endsWith('.png')) {
          images.add(file);
        }
      }

      setState(() {}); 
    }
    return images;
  }

  void goBack(){
    scaleStateController.scaleState = PhotoViewScaleState.initial;
  }

}//ENd



