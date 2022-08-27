import 'dart:io';

// import 'package:firebase_ml_custom/firebase_ml_custom.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

/// https://github.com/am15h/tflite_flutter_plugin/issues/48



@singleton
class MlService with ReactiveServiceMixin {

 static var localModelPath;

  MlService() {
    listenToReactiveValues([modelFile]);
  }

  RxValue<File> modelFile = RxValue<File>(File(""));

  static dynamic firebasemodeldownloder() {
    FirebaseModelDownloader.instance
        .getModel(
            'tflitemodel',
            FirebaseModelDownloadType.localModel,
            FirebaseModelDownloadConditions(
              iosAllowsCellularAccess: true,
              iosAllowsBackgroundDownloading: true,
              androidChargingRequired: true,
              androidWifiRequired: true,
              androidDeviceIdleRequired: true,
            ))
        .then((customModel) {
      // Download complete. Depending on your app, you could enable the ML
      // feature, or switch from the local model to the remote model, etc.

      // The CustomModel object contains the local path of the model file,
      // which you can use to instantiate a TensorFlow Lite interpreter.
      localModelPath = customModel.file;

      // ...
    });
  }

  /*FirebaseCustomRemoteModel get groceryModel {
    return FirebaseCustomRemoteModel('groceries-yolov4-tflite');
  }

  FirebaseModelDownloadConditions get conditions {
<<<<<<< HEAD
    return FirebaseModelDownloadConditions(*/


/* androidRequireWifi: false,
        androidRequireDeviceIdle: true,
        androidRequireCharging: true,
        iosAllowCellularAccess: true,
        iosAllowBackgroundDownloading: true*/

/*
=======
    return FirebaseModelDownloadConditions(
       */ /* androidRequireWifi: false,
        androidRequireDeviceIdle: true,
        androidRequireCharging: true,
        iosAllowCellularAccess: true,
        iosAllowBackgroundDownloading: true*/ /*
>>>>>>> 7f2fd745eff6b77b82a50f02e0510a9004a4711f
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
