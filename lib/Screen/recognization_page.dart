import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizePage extends StatefulWidget {
  final String? path;

  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  TextEditingController controller = TextEditingController();
  late RecognizedText recognizedText;

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("문자인식")),
      body: _isBusy == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                onTap: playVideo,
                readOnly: true,
                maxLines: MediaQuery.of(context).size.height.toInt(),
                controller: controller,
                decoration: const InputDecoration(
                    hintText: "글자를 인식하지 못했습니다. 다시 시도해 주세요"),
              ),
            ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    // latin대신 korea가능
    setState(() {
      _isBusy = true;
    });

    try {
      await Future.delayed(Duration(seconds: 6)).timeout(
        Duration(seconds: 5), //5초 타임아웃
        onTimeout: () {
          // Navigator.of(context).pop();
        },
      );
      recognizedText = await textRecognizer.processImage(image);
      controller.text = recognizedText.text;

      showToast('화면을 터치하면 메뉴얼 화면으로 이동합니다.');

      // Future.delayed(
      //     Duration(seconds: 5), playVideo); //5초 recognizedText를 보여준다음 동영상으로 진행
      // playVideo();
    } catch (err) {}

    log(image.filePath!);

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }

  Future<void> playVideo() async {
    // bool keyWordisContained = await recognizedText.text.contains('CSCF');
    bool keyWordisContained = true;
    log('keyWord... is ${keyWordisContained}');

    if (keyWordisContained) {
      Navigator.pushNamed(context, '/video_player');
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
