import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

import 'constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedAudio;
  String message = "Double tap to start recording";
  String mood = "Not sure";
  String statusText = "";
  bool isComplete = false;
  String recordFilePath = '';
  int i = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //recorder.closeRecorder();
    super.dispose();
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    i++;
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {
          selectedAudio = recordFilePath;
        });
      });
      print("Recording in Progressssssssssssssss");
      print(recordFilePath);
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
      setState(() {
        selectedAudio = recordFilePath;
      });
    }
    print("Recording Stopped");
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/testaudio${i}.mp3";
  }

  //File selector
  selectfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filepath = result.files.single.path!;
      setState(() {
        selectedAudio = filepath;
      });
      return filepath;
    } else {
      // User canceled the picker
    }
  }

  //File Uploader
  Future<void> sendAudioFile(String url, String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    request.headers.addAll({'Content-Type': 'audio/mp3'});
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    print(respStr);
    if (kDebugMode) {
      print(response.statusCode);
    }

    if (response.statusCode == 200) {
      setState(() {
        mood = respStr;
      });
      // var data = jsonDecode(response.body);
      if (kDebugMode) {
        print(
            "Succesfully sent file Succesfully sent file Succesfully sent file Succesfully sent file Succesfully sent file");
      }
      // Handle successful response
    } else {
      // Handle error response
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff40916C),
      appBar: AppBar(
        backgroundColor: Color(0xff2E4F4F),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/doctor.png'),
            ElevatedButton(
              onPressed: () {
                selectfile();
              },
              child: const Text('PickFile'),
            ),
            ElevatedButton(
                onPressed: () {
                  sendAudioFile("https://pythonmodelapi.pythonanywhere.com/",
                      selectedAudio!);
                },
                child: const Text('Upload a file')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Mood :'),
                Text(
                  mood,
                  style: const TextStyle(
                      fontSize: 40, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
                onDoubleTap: () async {
                  startRecord();
                  setState(() {
                    message = "Tap to stop recording";
                  });
                },
                onTap: () async {
                  stopRecord();
                  message = "Double tap to start recording";
                  print(recordFilePath);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  padding: EdgeInsets.all(10),
                  height: 50,

                  child: Text('Speak your heart'),
                )),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () async {
            //         startRecord();
            //       },
            //       child: const Text("Start"),
            //     ),
            //     ElevatedButton(
            //       onPressed: () async {
            //         stopRecord();
            //         print(recordFilePath);
            //       },
            //       child: Text("Stop"),
            //     ),
            //   ],
            // ),
            Text(message, style: h2),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
