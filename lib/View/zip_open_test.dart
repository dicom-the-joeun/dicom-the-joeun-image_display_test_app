// import 'dart:io';
// import 'dart:typed_data';

// import 'package:archive/archive_io.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class webp_test extends StatefulWidget {
//   const webp_test({super.key});

//   @override
//   State<webp_test> createState() => _webp_testState();
// }

// class _webp_testState extends State<webp_test> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('webp_test'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () => zipOpen(),
//                 child: const Text('Zip decode button')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //--function--
//   zipOpen() {
//     // var zipFile = (images)
//     // final directory = await getApplicationDocumentsDirectory();
//     // final bytes = File('images/image9.zip').readAsBytesSync();
//     // Archive archive = ZipDecoder().decodeBytes(bytes);

//     // for (final file in archive){
//     //   final filename = file.name;
//     //   if(file.isFile){
//     //     final data = file.content as List<int>;
//     //     File('images/out/$filename')
//     //       ..createSync(recursive: true)
//     //       ..writeAsBytesSync(data);
//     //   }else{
//     //     Directory('images/out/$filename').create(recursive: true);
//     //   }
//     // }

//     }

// }//END


import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class webp_test extends StatefulWidget {
  const webp_test({Key? key}) : super(key: key);

  @override
  State<webp_test> createState() => _webp_testState();
}

class _webp_testState extends State<webp_test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('webp_test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => zipOpen(),
                child: const Text('Zip decode button'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--function--


  //===============추가해야할사항===================
  /*

    1. zip파일을 server에서 getLibraryDirectory 로 내려받을 수 있게끔 코드를 생성한다.
        ==> zipDown() 함수에 만들어주자.
    
    2. 받아온 zip파일을 압축해제 하는 함수는 zipOpen이다.
    


    1.13일 : test20장으로 했을 때 깜빡임 없이 괜찮았다.
   */
  // Future zipDown() async{
  //   var url = Uri.parse(
  //     'https://github.com/Rano-K/testRepo?zip='
  //   );

  // }
  

  //zipDown()한 파일 압축해제.
  zipOpen() async {
    final directory = await getApplicationDocumentsDirectory();              //server에서 받아올 zip파일이 다운될 곳
    print(directory.path);
    final zipFilePath = '${directory.path}/20.zip';         //받아온 zip파일의 이름이 들어갈 곳
    final destinationDirectory = '${directory.path}/20extracted'; //받아온 zip파일을 압축해제한 파일들이 들어갈 곳

    File zipFile = File(zipFilePath); 

    if (zipFile.existsSync()) {
      List<int> bytes = zipFile.readAsBytesSync();
      Archive archive = ZipDecoder().decodeBytes(Uint8List.fromList(bytes));

      for (ArchiveFile file in archive) {
        String fileName = '$destinationDirectory/${file.name}';
        File outFile = File(fileName);
        // outFile.createSync(recursive: true);
        outFile.parent.createSync(recursive: true); // 디렉토리가 없으면 생성


        if (file.isFile) {
          outFile.writeAsBytesSync(file.content as List<int>);
        } else {
          Directory(fileName).create(recursive: true);
        }
      }

      print('압축 파일이 성공적으로 해제되었습니다.');
    } else {
      print('지정된 압축 파일이 존재하지 않습니다.');
    }
  }
}
