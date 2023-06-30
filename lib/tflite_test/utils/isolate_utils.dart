import 'dart:io';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imgLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../tflite/classifier.dart';
import '../utils/image_utils.dart';


/// Manages separate Isolate instance for inference
class IsolateUtils {
  static const String DEBUG_NAME = 'InferenceIsolate';

  Isolate? _isolate;
  final ReceivePort _receivePort = ReceivePort();
  SendPort? _sendPort;

  SendPort? get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      /*Classifier classifier = Classifier(
            interpreter: Interpreter.fromAddress(isolateData.interpreterAddress),
            labels: isolateData.labels,
      );*/
      Classifier classifier = Classifier(
          Interpreter.fromAddress(isolateData.interpreterAddress),
          0,
          false,
          false,
          [],
          null,
          0,
          [],
          [],
          [],
          interpreter: Interpreter.fromAddress(isolateData.interpreterAddress),
          labels: []
      );

      imgLib.Image? image =
          ImageUtils.convertCameraImage(isolateData.cameraImage!);
      if (Platform.isAndroid) {
        image = imgLib.copyRotate(image!, 90);
      }
      Map<String, dynamic>? results = classifier.predict(image!);
      isolateData.responsePort!.send(results);
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage? cameraImage;
  int interpreterAddress = 0;
  List<String> labels = [];
  SendPort? responsePort;

  IsolateData(
    this.cameraImage,
    this.interpreterAddress,
    this.labels,
  );

  static IsolateData empty() => IsolateData(
    null,
    0,
    [],
  );

}
