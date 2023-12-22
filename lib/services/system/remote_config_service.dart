import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _singleton = RemoteConfigService._internal();

  factory RemoteConfigService() {
    return _singleton;
  }

  RemoteConfigService._internal();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await remoteConfig.fetchAndActivate();
  }

  String get apiKey1OpenAI => remoteConfig.getString('openAiApiKey1');
  String get apiKey2OpenAI => remoteConfig.getString('openAiApiKey2');
  String get apiKeyOCR => remoteConfig.getString('ocrApiKey');
}
