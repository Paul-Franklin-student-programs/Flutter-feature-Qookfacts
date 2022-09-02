import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

/// https://github.com/am15h/tflite_flutter_plugin/issues/48
// var localModelPath;

@singleton
class MlService with ReactiveServiceMixin {
  static var localModelPath;
  MlService() {
    listenToReactiveValues([modelFile]);
  }

  RxValue<File> modelFile = RxValue<File>(File(""));
  static Reference storageRef = FirebaseStorage.instance.ref();
  static String imageUrl;
  static dynamic readdata;

  static dynamic firebasemodeldownloder() {
    FirebaseModelDownloader.instance
        .getModel(
            'tflitelatestmodel',
            FirebaseModelDownloadType.localModel,
            FirebaseModelDownloadConditions(
              iosAllowsCellularAccess: true,
              iosAllowsBackgroundDownloading: false,
              androidChargingRequired: false,
              androidWifiRequired: false,
              androidDeviceIdleRequired: false,
            ))
        .then((customModel) {
      // Download complete. Depending on your app, you could enable the ML
      // feature, or switch from the local model to the remote model, etc.

      // The CustomModel object contains the local path of the model file,
      // which you can use to instantiate a TensorFlow Lite interpreter.
      // localModelPath = customModel.file;
      localModelPath = customModel.file;

      // ...
    });
  }

  static dynamic downloadlabelfile() async {
    final islandRef = storageRef.child("groceries.txt");

    try {
      final Uint8List data = await islandRef.getData();
      print(data);
      print(utf8.decode(data));

      readdata = utf8.decode(data);
    } on FirebaseException catch (e) {}

  }

  /*FirebaseCustomRemoteModel get groceryModel {
    return FirebaseCustomRemoteModel('groceries-yolov4-tflite');
  }

  FirebaseModelDownloadConditions get conditions {
    return FirebaseModelDownloadConditions(
       */ /* androidRequireWifi: false,
        androidRequireDeviceIdle: true,
        androidRequireCharging: true,
        iosAllowCellularAccess: true,
        iosAllowBackgroundDownloading: true*/ /*
    );
  }

  /// Create a FirebaseModelManager object corresponding to the default FirebaseApp instance.
  FirebaseModelManager get modelManager {
    return FirebaseModelManager.instance;
  }

  /// Initiate the download of a remote model if the download hasn't begun.
  /// If the model's download is already in progress, the current download
  /// task will continue executing. If the model is already downloaded
  /// to the device, and there is no update, the call will immediately succeed.
  /// If the model is already downloaded to the device, and there is update,
  /// a download for the updated version will be attempted.
  Future<void> downloadModel() async {
    await modelManager.download(groceryModel, conditions);
  }

  /// Return the File containing the latest model for the remote model name.
  /// This will fail if the model is not yet downloaded on the device
  /// or valid custom remote model is not provided.
  Future<void> getModelFile() async {
    modelFile.value = await modelManager.getLatestModelFile(groceryModel);
  }

  /// Assign the model to the service's model parameter
  Future<File> setupModel() async {
    if (await modelManager.isModelDownloaded(groceryModel) == true) {
      print('model is already downloaded');
    // do something with this model
      modelFile.value = await modelManager.getLatestModelFile(groceryModel);
      return modelFile.value;
    } else {
      print('model needs to be downloaded');

      try {
        // fall back on a locally-bundled model or do something else
        await downloadModel().then((value) async {
          print('model finished downloading');
          modelFile.value = await modelManager.getLatestModelFile(groceryModel);
          return modelFile.value;
        });
      } catch (e){
        print('model failed: '+ e.toString());
        return null;
      }
    }
  }*/

}
