import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qookit/services/system/remote_config_service.dart';

class OpenAiService {
  static Future<String> fetchRecipes(String ocrText, bool isReceiptScanSelected, bool isIngredientScanSelected) async {
    final String apiKey = RemoteConfigService().apiKey2OpenAI;
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    String content = '';
    if (isReceiptScanSelected) {
      content = "identify ingredients in this text and give some recipes that you can make with these: $ocrText";
    } else if (isIngredientScanSelected) {
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
