import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qookit/services/system/remote_config_service.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/home_view.dart';
import 'package:stacked_themes/stacked_themes.dart';

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
                return MaterialPageRoute(
                     builder: (_) => HomeView(cameras: _cameras));
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
