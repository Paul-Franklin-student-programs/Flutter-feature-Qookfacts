import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qookit/models/expiry_group.dart';
import 'package:qookit/models/pantry_item.dart';
import 'package:qookit/services/getIt.dart';
import 'package:qookit/services/ml/ml_service.dart';
import 'package:qookit/services/navigation/navigation_service.dart';
import 'package:qookit/services/services.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/tflite_test/ui/camera_view.dart';
import 'package:qookit/tflite_test/ui/home_view.dart';
import 'package:qookit/ui/signInSignUp/forgotPasswordView/forgot_password_view.dart';
import 'package:qookit/ui/signInSignUp/loginView/login_view.dart';
import 'package:qookit/ui/signInSignUp/registerView/register_view.dart';
import 'package:qookit/ui/splashscreenView/splashscreen_view.dart';
import 'package:qookit/ui/testView/OCResultView.dart';
import 'package:qookit/ui/testView/testView.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'app/app_router.dart';
import 'models/itemlist.dart';
import 'ui/signInSignUp/onboardingView/dietPreferences/diet_preferences_view.dart';
import 'ui/signInSignUp/onboardingView/recipePreferences/recipe_preferences_view.dart';
import 'ui/signInSignUp/onboardingView/recommendationPreferences/recommendation_preferences_view.dart';

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;


bool preview = false;

late List<CameraDescription> _cameras;


Future<void> main() async {
  // NavigationService().setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  configureDependencies();

  // unawaited(mlService.setupModel());

  MlService.firebasemodeldownloder();
  MlService.downloadlabelfile();

  /// Initialize hive stuff
  await Hive.initFlutter();
  Hive.registerAdapter(PantryItemAdapter());
  Hive.registerAdapter(ExpiryGroupAdapter());
  Hive.registerAdapter(ItemListAdapter());

  await Hive.openBox('master');
  await Hive.box('master').put('ready', false);

  /// Initialize stacked themes
  await ThemeManager.initialise();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
    SystemUiOverlay.top,
  ]);

  _cameras = await availableCameras();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));


  runApp(
    App(),
  );
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
                  return MaterialPageRoute(builder: (_) => TestCameraView());
              // return MaterialPageRoute(builder: (_) => SplashScreenView());
                case '/login':
                  return MaterialPageRoute(builder: (_) => LoginView());
                case '/forgot-password-view':
                  return MaterialPageRoute(
                      builder: (_) => ForgotPasswordView());
                case '/diet-preferences-view':
                  return MaterialPageRoute(
                      builder: (_) => DietPreferencesView());
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
                  return null; // Handle other routes or show a default screen
              }
            },
            showSemanticsDebugger: false,

            /*builder: (context, nativeNavigator) {
              return ExtendedNavigator.builder<AppRouter>(
                  initialRoute: '/login-view',
                  router: AppRouter(),
                  name: 'topNav',
                  builder: (context, child) {
                    return child ?? Container();
                  },
              )
                (context, nativeNavigator);
            },*/
          );
        });
  }
}






////////////////////////
//QOOKIT new app
/////////////////////


/// CameraApp is the Main Application.
class TestCameraView extends StatefulWidget {
  /// Default Constructor
  const TestCameraView({Key? key}) : super(key: key);

  @override
  State<TestCameraView> createState() => _TestCameraViewState();
}

class _TestCameraViewState extends State<TestCameraView> {
  late CameraController controller;
  File? photoFile;

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
    if (photoFile != null) {

      String ocrResponse = await sendOCRRequest(await photoFile!.path);
      ocrResponse = await fetchRecipes(ocrResponse);

      // Navigate to the new screen and pass the base64Image
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
    final String apiKey = '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'; // Replace with your API key
    final String apiUrl = 'https://api.openai.com/v1/chat/completions';

    final Map<String, dynamic> requestData = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {"role": "user", "content": "identify ingredients in this text and give some recipes that you can make with these: $ocrText"}
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

    request.headers['apikey'] = 'K89478254888957';
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
        parsedTextList.add('Request failed>>>:' + await response.stream.bytesToString());
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
          body: photoFile == null
              ? Container(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(controller),
          )
              : Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(photoFile!, fit: BoxFit.cover),
          ),
          floatingActionButton: photoFile == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.end, // Place at the bottom
            children: [
              FloatingActionButton(
                onPressed: takePhoto,
                child: Icon(Icons.camera),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.end, // Place at the bottom
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: deletePhoto,
                    child: Icon(Icons.delete),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      processPhoto(context);
                    },
                    child: Icon(Icons.restaurant),
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



