import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qookit/services/system/remote_config_service.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/tflite_test/ui/home_view.dart';
import 'package:qookit/ui/signInSignUp/forgotPasswordView/forgot_password_view.dart';
import 'package:qookit/ui/signInSignUp/loginView/login_view.dart';
import 'package:qookit/ui/signInSignUp/registerView/register_view.dart';
import 'package:qookit/ui/testView/OCResultView.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'ui/signInSignUp/onboardingView/dietPreferences/diet_preferences_view.dart';
import 'ui/signInSignUp/onboardingView/recipePreferences/recipe_preferences_view.dart';
import 'ui/signInSignUp/onboardingView/recommendationPreferences/recommendation_preferences_view.dart';

bool preview = false;

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await RemoteConfigService().initialize();
  await ThemeManager.initialise();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
    SystemUiOverlay.top,
  ]);

  _cameras = await availableCameras();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      darkTheme: qookitDark,
      lightTheme: qookitLight,
      defaultThemeMode: ThemeMode.light,
      builder: (context, regularTheme, darkTheme, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: regularTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          color: (kIsWeb) ? Colors.green : Colors.red,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => OCRCameraView());
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginView());
              case '/forgot-password-view':
                return MaterialPageRoute(builder: (_) => ForgotPasswordView());
              case '/diet-preferences-view':
                return MaterialPageRoute(builder: (_) => DietPreferencesView());
              case '/recipe-preferences-view':
                return MaterialPageRoute(
                    builder: (_) => RecipePreferencesView());
              case '/recommendation-preferences-view':
                return MaterialPageRoute(
                    builder: (_) => RecommendationPreferences());
              case '/register':
                return MaterialPageRoute(builder: (_) => RegisterView());
              case '/home-view':
                return MaterialPageRoute(builder: (_) => HomeView());
              default:
                return null;
            }
          },
          showSemanticsDebugger: false,
        );
      },
    );
  }
}

class OCRCameraView extends StatefulWidget {
  const OCRCameraView({Key? key}) : super(key: key);

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

    controller = CameraController(_cameras[0], ResolutionPreset.medium);
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

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return OCRResultView(ocrResponse);
          },
        ),
      );
    }
  }

  Future<String> fetchRecipes(String ocrText) async {
    final String apiKey = RemoteConfigService().apiKey2OpenAI;
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    final Map<String, dynamic> requestData = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          "role": "user",
          "content":
              "identify ingredients in this text and give some recipes that you can make with these: $ocrText"
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
                    Column(
                      children: [
                        FloatingActionButton(
                          onPressed: takePhoto,
                          child: Icon(Icons.camera),
                        ),
                        Text(
                          'Capture Receipt',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber,
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                processPhoto(context);
                              },
                              child: Icon(Icons.restaurant),
                            ),
                            Text(
                              'Qookit (~15s)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber,
                              ),
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
