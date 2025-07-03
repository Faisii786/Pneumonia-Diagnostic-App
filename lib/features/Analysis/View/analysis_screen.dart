import 'package:flutter/material.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/button.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalysisScreen extends StatefulWidget {
  final String? imagePath;
  const AnalysisScreen({
    super.key,
    this.imagePath,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String? detectionResult;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("AnalysisScreen initState called, imagePath: ${widget.imagePath}");
    if (widget.imagePath != null) {
      sendImage(File(widget.imagePath!));
    }
  }

  Future<void> sendImage(File imageFile) async {
    print("Sending image: ${imageFile.path}");
    setState(() {
      isLoading = true;
    });
    try {
      var url = Uri.parse("https://31a8-35-229-211-190.ngrok-free.app/predict");
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        var resBody = await http.Response.fromStream(response);
        var data = jsonDecode(resBody.body);
        setState(() {
          detectionResult = data['detections'].toString();
          isLoading = false;
        });
        print("Detection result: ${detectionResult}");
      } else {
        setState(() {
          detectionResult = "Error: ${response.statusCode}";
          isLoading = false;
        });
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        detectionResult = "Error: ${e.toString()}";
        isLoading = false;
      });
      print("Exception: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text('Analysis')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.imagePath != null)
              Image.file(
                File(widget.imagePath!),
                height: 200,
              ),
            SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator()
                : CustomText(
                    text: detectionResult ?? 'No result yet',
                  ),
            SizedBox(height: 24),
            CustomButton(
              ontap: () {},
              btnName: 'View Detailed Report',
              width: .6,
              borderRadius: 100,
            )
          ],
        ),
      ),
    );
  }
}
