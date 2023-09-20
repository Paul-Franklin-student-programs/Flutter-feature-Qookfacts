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

  void ocrPhoto(BuildContext context) async {
    if (photoFile != null) {
      // // Read the photoFile and convert it to bytes
      // List<int> imageBytes = await photoFile!.readAsBytes();
      // // Encode the bytes to base64
      // String base64Image = base64Encode(imageBytes);
      // print(base64Image);

      String ocrResponse = await sendOCRRequest(await photoFile!.path);
      print(ocrResponse);

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

  Future<String> sendOCRRequest(String filePath) async {
    List<String> parsedTextList = [];

    var url = Uri.parse('https://api.ocr.space/parse/image');
    var apiKey = 'K89478254888957';

    var headers = {'apikey': apiKey};
    var request = http.MultipartRequest('POST', url);

    request.headers.addAll(headers);
    request.fields['language'] = 'eng';
    request.fields['isOverlayRequired'] = 'true';
    request.fields['isCreateSearchablePdf'] = 'false';
    request.fields['isSearchablePdfHideTextLayer'] = 'false';
    request.fields['scale'] = 'true';
    request.fields['isTable'] = 'true';

    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
      ),
    );

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    return responseString;
  }


  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
        home: Scaffold(
          body: photoFile == null
              ? CameraPreview(controller)
              : Image.file(photoFile!),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: photoFile == null
                ? <Widget>[
              FloatingActionButton(
                onPressed: takePhoto,
                child: const Icon(Icons.camera),
              ),
            ]
                : <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: deletePhoto,
                    child: const Icon(Icons.delete),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed: () {
                      ocrPhoto(context); // Call your function here
                    },
                    child: const Icon(Icons.adb_rounded),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}



