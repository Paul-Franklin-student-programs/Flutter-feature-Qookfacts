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
  // Initialize a list to hold the data.
  List<String> contentData = [];

  // Initialize a flag to track if you're currently loading data.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add the initial content from widget.ocrResults to contentData.
    contentData.add(widget.ocrResults);
  }

  // Method to make an API call and append new data.
  Future<void> loadMoreData() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Make your API call here, e.g., using http package.
    final newData = await makeApiCall();

    // Append the new data to the existing content.
    setState(() {
      contentData.addAll(newData.split('\n'));
      isLoading = false; // Set isLoading to false when data is loaded.
    });
  }

  // Method to make an API call.
  Future<String> makeApiCall() async {
    // Replace this with your actual API call logic.
    await Future.delayed(Duration(seconds: 2));
    return 'New data from API'; // Replace with your API response.
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
          backgroundColor: qookitLight.primaryColor, // Set the app bar color to qookitLight's primary color
        ),
        body: ListView.builder(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Call the method to load more data when the button is pressed.
            loadMoreData();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
