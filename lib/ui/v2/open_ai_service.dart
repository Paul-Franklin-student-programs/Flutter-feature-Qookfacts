import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qookit/services/system/remote_config_service.dart';

class OpenAiService {
  static Future<String> fetchRecipes(String ocrText, String dietaryRestrictions, bool isReceiptScanSelected, bool isIngredientScanSelected) async {
    final String apiKey = RemoteConfigService().apiKey2OpenAI;
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    String content = '';
    if (isReceiptScanSelected) {
      content = "Identify ingredients in this text [$ocrText] and give some recipes that you can make with them after eliminating these list of ingredients [$dietaryRestrictions]";
    } else if (isIngredientScanSelected) {
      content = "identify ingredients in $ocrText text. Highlight if any ingredients in $dietaryRestrictions are found under dietary restrictions. For others ighlight serving size and calories. Group ingredients under good and not so good sections and describe why so. Give an overall rating against 10";
    }

    print(">>>$content");

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

  static Future<String> sendOCRRequest(String filePath) async {
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
}
