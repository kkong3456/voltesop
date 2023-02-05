import 'dart:developer';

import 'package:flutter/material.dart';
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

  RecognizedText? recognizedText;

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("문자인식")),
      body: _isBusy == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : InkWell(
              onTap: playVideo,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  readOnly: true,
                  maxLines: MediaQuery.of(context).size.height.toInt(),
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: "글자를 인식하지 못했습니다. 다시 시도해 주세요"),
                ),
              ),
            ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    try {
      await Future.delayed(Duration(seconds: 6)).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          // Navigator.of(context).pop();
        },
      );
      recognizedText = await textRecognizer.processImage(image);
      controller.text = recognizedText!.text;

      playVideo();
    } catch (err) {}

    log(image.filePath!);

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }

  Future<void> playVideo() async {
    bool keyWordisContained = await recognizedText!.text.contains('cscf');
    if (keyWordisContained) {
      //동영상실행
      log('동영상실행');
    }
  }
}
