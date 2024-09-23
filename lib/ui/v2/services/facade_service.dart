import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qookit/services/system/remote_config_service.dart';
import 'package:qookit/ui/v2/services/qookit_service.dart';

class FacadeService {

  static Future<String> fetchRecipes(String ocrText, String dietaryRestrictions, String culinaryPreferences, bool isReceiptScanSelected, bool isIngredientScanSelected) async {

    String content = '';
    if (isReceiptScanSelected) {
      content = "Suggest recipes based on ingredients in this text [$ocrText]. These are my culinary preferences [$culinaryPreferences]. These are my dietary restrictions [$dietaryRestrictions].";
    } else if (isIngredientScanSelected) {
      content = "Identify ingredients in $ocrText text. Highlight if any ingredients in $dietaryRestrictions are found under dietary restrictions. For others highlight serving size and calories. Group ingredients under good and not so good sections and describe why so. Give an overall rating against 10";
    }

    return QookitService().sendCompletionsRequest(content);
  }

  static Future<String> fetchIngredients(String ocrText) async {
    String content = "Identify ingredients in this text [$ocrText] and return them as comma seperated values";
    return QookitService().sendCompletionsRequest(content);
  }

  static Future<String> loadMoreRecipes(String ocrText, String dietaryRestrictions, String culinaryPreferences) async {
    String content = "Suggest more recipes based on ingredients in this text [$ocrText]. These are my culinary preferences [$culinaryPreferences]. These are my dietary restrictions [$dietaryRestrictions].";
    return QookitService().sendCompletionsRequest(content);
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
