import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'auth_service.dart';

@injectable
class QookitService {
  String domain = 'qookit.ddns.net';
  static const String users_endpoint = '/v1/user';
  static const String recipes_endpoint = '/v1/recipes';
  static const String ingredients_endpoint = '/v1/ingredients';
  static const String completions_endpoint = '/v1/chat/completions';

  Future<String> testRequest() {
    return getList(users_endpoint);
  }

  // GET ALL ITEMS
  Future<String> getList(String endpoint) async {
    var responseJson;
    var uri = Uri.https(domain, endpoint);
    var token = await AuthService().getToken(); // Get token from AuthService


    var recipeResponse = await http.get(uri,
      headers: token != null ? {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      } : {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    responseJson = _response(recipeResponse);
    return uri.toString() + "\n" + responseJson.toString();
  }

  dynamic _response(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 201:
      case 204:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        var msg = responseJson['message'];
        return responseJson;
        throw Exception(msg);
      case 401:
        var responseJson = json.decode(response.body.toString());
        var msg = responseJson['message'];
        throw Exception(msg);
      case 403:
        throw Exception(response.body.toString());
      case 412:
        var responseJson = json.decode(response.body.toString());
        // print(responseJson);
        print(responseJson);
        return responseJson;

      case 500:
        var msg = '';
        throw Exception(msg ?? response.body.toString());
    // } else {
    //   throw BadRequestException(response.body.toString());
    // }
      case 422:
        var responseJson = json.decode(response.body.toString());
        var msg = responseJson['message'];
        throw Exception(msg);
      default:
        throw Exception(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }


  Future<String> sendCompletionsRequest(String content) async {
    var uri = Uri.https(domain, completions_endpoint);
    var token = await AuthService().getToken();

    final Map<String, dynamic> details = {
      'model': 'string',
      'temperature': 0,
      'maxTokens': 0,
      'stream': true,
      'messages': [
        {
          "role": "user",
          "content": content,
          "toolCallId": "1"
        }
      ]
    };

    var response = await http.post(
      uri,
      headers: token != null
          ? {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      }
          : {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(details),
    );

    if (response.statusCode == 200) {
      // Process streaming response if needed
      var streamedContent = _processStreamedResponse(response);
      return streamedContent;
    } else {
      return 'Request failed with status: ${response.statusCode}';
    }
  }

  String _processStreamedResponse(http.Response response) {
    // Parse and process each data chunk received in the response
    List<String> chunks = response.body.split('data:');
    String aggregatedContent = '';

    for (var chunk in chunks) {
      if (chunk.trim().isNotEmpty) {
        try {
          var decodedChunk = json.decode(chunk);
          var content = decodedChunk['choices'][0]['delta']['content'] ?? ''; // Provide default value if null
          aggregatedContent += content;
        } catch (e) {
          // Handle JSON decode or other exceptions
          print('Error processing chunk: $e');
        }
      }
    }

    return aggregatedContent;
  }
}
