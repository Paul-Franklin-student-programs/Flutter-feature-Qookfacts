import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qookit/services/theme/theme_service.dart';

class OCRResultView extends StatefulWidget {
  final String ocrResults;

  OCRResultView(this.ocrResults);

  @override
  State<OCRResultView> createState() => _OCRResultViewState();
}

class _OCRResultViewState extends State<OCRResultView> {
  List<String> contentData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    contentData.add(widget.ocrResults);
  }

  Future<void> loadMoreData() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final newData = await fetchRecipes();

    setState(() {
      contentData.addAll(newData.split('\n'));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: qookitLight,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Qookit Insights',style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: qookitLight.primaryColor,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: contentData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    contentData[index],
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
            if (isLoading)
              Center(
                child: Container(
                  width: 100,  // Set the desired width
                  height: 100, // Set the desired height
                  child: CircularProgressIndicator(
                    strokeWidth: 10.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
              ),
          ],
        ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: loadMoreData,
                child: Icon(Icons.add),
              ),
              Text(
                'Load More (~10s)',
                style: TextStyle(fontSize: 12, color: Colors.amber),
              ),
            ],
          )

      ),
    );
  }


// Method to make an API call.
  Future<String> fetchRecipes() async {
    final String apiKey = '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'; // Replace with your API key
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    final Map<String, dynamic> requestData = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {"role": "user", "content": "more recipes based on those ingredients"}
      ],
      'temperature': 0.7,
    };

    print(requestData);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestData),
    );

    // Check if the response status code is 200
    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = jsonDecode(response.body);

      // Extract the "text" data from the chosen choice
      final textData = jsonResponse['choices'][0]['message']['content'];

      return textData;
    } else {
      return response.body;
    }
  }
}

