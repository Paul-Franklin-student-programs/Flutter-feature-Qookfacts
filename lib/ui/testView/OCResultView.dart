import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OCRResultView extends StatefulWidget {
  final String ocrResults;

  OCRResultView(this.ocrResults);

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
            'OCR Results:\n\n${widget.ocrResults}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
