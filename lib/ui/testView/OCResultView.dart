import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OCRResultView extends StatefulWidget {
  final String base64Image;

  OCRResultView(this.base64Image);

  @override
  State<OCRResultView> createState() => _OCRResultViewState();
}

class _OCRResultViewState extends State<OCRResultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR Result'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(
            'Base64 Encoded Image:\n\n${widget.base64Image}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
