import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qookit/services/system/remote_config_service.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/nutrition_view.dart';
import 'package:qookit/ui/v2/recipes_view.dart';

class OCRCameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool isReceiptScanSelected; // Flag for Receipt Scanner
  final bool isIngredientScanSelected; // Flag for Ingredient Scanner

  const OCRCameraView({
    Key? key,
    required this.cameras,
    required this.isReceiptScanSelected,
    required this.isIngredientScanSelected,
  }) : super(key: key);

  @override
  State<OCRCameraView> createState() => _OCRCameraViewState();
}


class _OCRCameraViewState extends State<OCRCameraView> {
  late CameraController controller;
  File? photoFile;
  bool processing = false;
  String ocrKey = '';

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void takePhoto() async {
    try {
      XFile photo = await controller.takePicture();
      setState(() {
        photoFile = File(photo.path);
      });
    } catch (e) {
      print(e);
    }
  }

  void deletePhoto() {
    setState(() {
      photoFile = null;
    });
  }

  void processPhoto(BuildContext context) async {
    setState(() {
      processing = true;
    });

    if (photoFile != null) {
      String ocrResponse = await sendOCRRequest(await photoFile!.path);
      ocrResponse = await fetchRecipes(ocrResponse);

      setState(() {
        processing = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            if (widget.isReceiptScanSelected) {
              return RecipesView(ocrResponse);
            } else if (widget.isIngredientScanSelected) {
              return NutritionView(ocrResponse);
            }
            // Return a default view if neither is selected
            return Container();
          },
        ),
      );
    }
  }


  Future<String> fetchRecipes(String ocrText) async {
    final String apiKey = RemoteConfigService().apiKey2OpenAI;
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    String content = '';
    if(widget.isReceiptScanSelected) {
      content = "identify ingredients in this text and give some recipes that you can make with these: $ocrText";
    } else if(widget.isIngredientScanSelected) {
      content = "identify ingredients in this text. Highlight serving size and calories. Group ingredients under good and bad sections and describe why are they good or bad. Give an overall rating against 10: $ocrText";
    }


    final Map<String, dynamic> requestData = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          "role": "user",
          "content": '$content'
        }
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

  Future<String> sendOCRRequest(String filePath) async {
    List<String> parsedTextList = [];

    var url = Uri.parse('http://api.ocr.space/parse/Image');
    var request = http.MultipartRequest('POST', url);

    request.headers['apikey'] = RemoteConfigService().apiKeyOCR;
    request.fields['language'] = 'eng';
    request.fields['fileType'] = 'JPG';
    request.fields['detectOrientation'] = 'true';
    request.fields['isOverlayRequired'] = 'true';
    request.fields['isCreateSearchablePdf'] = 'false';
    request.fields['isSearchablePdfHideTextLayer'] = 'false';
    request.fields['scale'] = 'true';
    request.fields['isTable'] = 'true';
    request.fields['OCREngine'] = '1';

    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
      ),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseString);
        // Check if the response contains the "ParsedResults" key
        if (jsonResponse.containsKey('ParsedResults')) {
          // Access the "ParsedResults" list
          var parsedResults = jsonResponse['ParsedResults'];

          // Iterate through each item in the "ParsedResults" list
          for (var parsedResult in parsedResults) {
            // Check if the parsedResult contains the "ParsedText" key
            if (parsedResult.containsKey('ParsedText')) {
              // Extract the "ParsedText" value and add it to the list
              var parsedText = parsedResult['ParsedText'];
              parsedTextList.add(parsedText);
            }
          }
        }
      } else {
        parsedTextList
            .add('Request failed>>>:' + await response.stream.bytesToString());
      }
    } catch (e) {
      print('Error: $e');
    }

    return parsedTextList.join(',');
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Theme(
        data: qookitLight,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              photoFile == null
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: CameraPreview(controller),
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(photoFile!, fit: BoxFit.fill),
                    ),
              if (processing)
                Center(
                  child: Container(
                    width: 100, // Set the desired width
                    height: 100, // Set the desired height
                    child: CircularProgressIndicator(
                      strokeWidth: 10.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: photoFile == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back),
                              ),
                              Text(
                                'Go Back',
                                style: qookitLight.tabBarTheme.labelStyle,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              FloatingActionButton(
                                onPressed: takePhoto,
                                child: Icon(Icons.camera),
                              ),
                              Text(
                                widget.isReceiptScanSelected?'Capture Receipt':'Capture Nutrition Label',
                                style: qookitLight.tabBarTheme.labelStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: deletePhoto,
                              child: Icon(Icons.delete),
                            ),
                            Text(
                              'Discard and Retry',
                              style: qookitLight.tabBarTheme.labelStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                processPhoto(context);
                              },
                              child: widget.isReceiptScanSelected? Icon(Icons.restaurant) : Icon(Icons.local_grocery_store),
                            ),
                            Text(
                              widget.isReceiptScanSelected?'Qookit (~15s)': 'Qookart (~15s)',
                              style: qookitLight.tabBarTheme.labelStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
