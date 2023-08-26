import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
// import 'package:object_detection/tflite/recognition.dart';
import 'package:qookit/tflite_test/tflite/recognition.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'stats.dart';

/// Classifier
class Classifier {
  /// Instance of Interpreter
  Interpreter? _interpreter;

  //Interpreter Options (Settings)
  int numThreads = 4;
  bool isNNAPI = false;
  bool isGPU = false; //true

  /// Labels file loaded as list
  List<String> _labels;

  // static const String MODEL_FILE_NAME = "tinyfood12-1.tflite";
  // static const String LABEL_FILE_NAME = "food2.txt";

  // static const String MODEL_FILE_NAME = "yolov4-416-fp32.tflite";
  // static const String LABEL_FILE_NAME = "coco.txt";

  static const String MODEL_FILE_NAME =
      'groceries-yolov4-tiny-416-08-07-22.tflite';
  static const String LABEL_FILE_NAME = 'groceries.txt';

  /// Input size of image (heixght = width = 300)
  static const int INPUT_SIZE = 416;

  /// Confidence Probabilty score threshold
  static const double THRESHOLD = 0;

  /// Non-maximum suppression threshold
  static double mNmsThresh = 0.6;

  /// [ImageProcessor] used to pre-process the image
  ImageProcessor imageProcessor;

  /// Padding the image to transform into square
  int padSize;

  /// Shapes of output tensors
  List<List<int>> _outputShapes;

  /// Types of output tensors
  List<TfLiteType> _outputTypes;

  /// Number of results to show
  static const int NUM_RESULTS = 1;

  var labelnames = [];

  Classifier(
      this.numThreads,
      this.isNNAPI,
      this.isGPU,
      this._labels,
      this.imageProcessor,
      this.padSize,
      this._outputShapes,
      this._outputTypes,{
    required Interpreter? interpreter,
    required List<String> labels,
  }) {
    loadModel(interpreter: interpreter);
    loadLabels(labels: labels);
  }

  /// Loads interpreter from asset
  void loadModel({required Interpreter? interpreter}) async {
    try {
      //Still working on it                                                                          *     *
      /*InterpreterOptions myOptions = new InterpreterOptions();                                   *    *    *
      myOptions.threads = numThreads;                                                                *     *
      if (isNNAPI) {                                                                                    *
        NnApiDelegate nnApiDelegate;
        bool androidApiThresholdMet = true;
        if (androidApiThresholdMet) {
          nnApiDelegate = new NnApiDelegate();
          myOptions.addDelegate(nnApiDelegate);
          myOptions.useNnApiForAndroid = true;
        }
      }
      if (isGPU) {
        GpuDelegateV2 gpuDelegateV2 = new GpuDelegateV2();
        myOptions.addDelegate(gpuDelegateV2);
      }*/

      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            MODEL_FILE_NAME,
            options: InterpreterOptions()..threads = numThreads, //myOptions,
          );

      var outputTensors = (_interpreter != null) ? _interpreter!.getOutputTensors() : [];
      // print("the length of the ouput Tensors is ${outputTensors.length}");
      _outputShapes = [];
      _outputTypes = [];
      outputTensors.forEach((tensor) {
        print(tensor.toString());
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      });
    } catch (e) {
      print('Error while creating interpreter: $e');
    }
  }

  /// Loads labels from assets
  void loadLabels({required List<String> labels}) async {
    try {
      _labels =
          labels ?? await FileUtil.loadLabels('assets/' + LABEL_FILE_NAME);
    } catch (e) {
      print('Error while loading labels: $e');
    }
  }

  /// Pre-process the image
  /// Only does something to the image if it doesn't meet the specified input sizes.
  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width); //padSize=320
    imageProcessor ??= ImageProcessorBuilder()
          .add(ResizeWithCropOrPadOp(padSize, padSize))
          .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
          .build();
    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  // non-maximum suppression
  List<Recognition> nms(
      List<Recognition> list) // Turned from Java's ArrayList to Dart's List.
  {
    List<Recognition> nmsList = [];
    for (int k = 0; k < _labels.length; k++) {
      // 1.find max confidence per class
      PriorityQueue<Recognition> pq = HeapPriorityQueue<Recognition>();

      for (int i = 0; i < list.length; ++i) {
        if (list[i].label == _labels[k]) {
          // Changed from comparing #th class to class to string to string
          pq.add(list[i]);
        }
      }

      // 2.do non maximum suppression
      while (pq.length > 0) {
        // insert detection with max confidence
        List<Recognition> detections = pq.toList(); //In Java: pq.toArray(a)
        Recognition max = detections[0];
        nmsList.add(max);
        pq.clear();
        for (int j = 1; j < detections.length; j++) {
          Recognition detection = detections[j];
          Rect? b = detection.location;
          if (boxIou(max.location, b) < mNmsThresh) {
            pq.add(detection);
          }
        }
      }
    }

    return nmsList;
  }

  double boxIou(Rect? a, Rect? b) {
    if(a != null && b != null){
      return boxIntersection(a, b) / boxUnion(a, b);
    }else{
      return 0.0;
    }
  }

  double boxIntersection(Rect a, Rect b) {
    double w = overlap((a.left + a.right) / 2, a.right - a.left,
        (b.left + b.right) / 2, b.right - b.left);
    double h = overlap((a.top + a.bottom) / 2, a.bottom - a.top,
        (b.top + b.bottom) / 2, b.bottom - b.top);
    if ((w < 0) || (h < 0)) {
      return 0;
    }
    double area = (w * h);
    return area;
  }

  double boxUnion(Rect a, Rect b) {
    double i = boxIntersection(a, b);
    double u = ((((a.right - a.left) * (a.bottom - a.top)) +
            ((b.right - b.left) * (b.bottom - b.top))) -
        i);
    return u;
  }

  double overlap(double x1, double w1, double x2, double w2) {
    double l1 = (x1 - (w1 / 2));
    double l2 = (x2 - (w2 / 2));
    double left = ((l1 > l2) ? l1 : l2);
    double r1 = (x1 + (w1 / 2));
    double r2 = (x2 + (w2 / 2));
    double right = ((r1 < r2) ? r1 : r2);
    return right - left;
  }

  /// Runs object detection on the input image
  Map<String, dynamic>? predict(imageLib.Image image) {
    var predictStartTime = DateTime.now().millisecondsSinceEpoch;

    if (_interpreter == null) {
      return null;
    }
    var preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Initliazing TensorImage as the needed model input type
    // of TfLiteType.float32. Then, creating TensorImage from image
    TensorImage inputImage = TensorImage(TfLiteType.float32);
    inputImage.loadImage(image);
    // TensorImage original = TensorImage(TfLiteType.float32);
    // original.loadImage(image);
    // Do not use static methods, fromImage(Image) or fromFile(File),
    // of TensorImage unless the desired input TfLiteDatasType is Uint8.
    // Create TensorImage from image
    // TensorImage inputImage = TensorImage.fromImage(image);
    // Image inputImage = Image.asset("assets/rice.jpg") ;
    // .fromFile("asstes/rice.jpg");

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);
    //getProcessedImage(inputImage);

    var preProcessElapsedTime =
        DateTime.now().millisecondsSinceEpoch - preProcessStart;

    // TensorBuffers for output tensors
    TensorBuffer outputLocations = TensorBufferFloat(
        _outputShapes[0]); // The location of each detected object

    List<List<List<double>>> outputClassScores = List.generate(
        _outputShapes[1][0],
        (_) => List.generate(_outputShapes[1][1],
            (_) => List.filled(_outputShapes[1][2], 0.0),
            growable: false),
        growable: false);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    List<Object> inputs = [inputImage.buffer];

    // Outputs map
    Map<int, Object> outputs = {
      0: outputLocations.buffer,
      1: outputClassScores,
    };

    // print(outputClassScores);

    var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;

    // run inference
    _interpreter!.runForMultipleInputs(inputs, outputs);

    var inferenceTimeElapsed =
        DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      //valueIndex: [1, 0, 3, 2], Commented out because default order is needed.
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.CENTER,
      coordinateType: CoordinateType.PIXEL,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    List<Recognition> recognitions = [];

    var gridWidth = _outputShapes[0][1];

    for (int i = 0; i < gridWidth; i++) {
      print(gridWidth);
      // Since we are given a list of scores for each class for
      // each detected Object, we are interested in finding the class
      // with the highest output score

      var maxClassScore = 0.00;
      var labelIndex = -1;

      for (int c = 0; c < _labels.length; c++) {
        // output[0][i][c] is the confidence score of c class
        print(outputClassScores[0][i][c]);

        if (outputClassScores[0][i][c] > maxClassScore) {
          print(outputClassScores[0][i][c]);

          labelIndex = c; //c=0
          maxClassScore = outputClassScores[0][i][c];
        }
      }
      // Prediction score
      var score = maxClassScore;

      var label;

      if (labelIndex != -1) {
        // Label string
        label = _labels.elementAt(labelIndex);
        // labelnames.add(label);
      } else {
        label = null;
      }
      // Makes sure the confidence is above the
      // minimum threshold score for each object.

      if (score > THRESHOLD) {
        // inverse of rect
        // [locations] corresponds to the image size 300 X 300
        // inverseTransformRect transforms it our [inputImage]
        // labelnames.add(label);
        // if(labelnames.length==0){
        if (!labelnames.contains(label)) {
          labelnames.add(label);
          Rect rectAti = Rect.fromLTRB(
              max(0, locations[i].left),
              max(0, locations[i].top),
              min(INPUT_SIZE + 0.0, locations[i].right),
              min(INPUT_SIZE + 0.0, locations[i].bottom));

          // Gets the coordinates based on the original image if anything was done to it.
          Rect transformedRect = imageProcessor.inverseTransformRect(
              rectAti, image.height, image.width);

          recognitions.add(
            Recognition(i, label, score, transformedRect),
          );
        }

        // }else{

        // for(var name in labelnames){
        //   // if(label != name){
        //     labelnames.add(label);
        //   // }
        // }

        // labelnames.add(label);
        // print(labelnames.length);
        //
        //
        //
        // }

        // print(labelnames);
        // else{
        //   //labelnames.length>0
        //   for(i=0;i<labelnames.length;i++){
        //     if (label != labelnames[i]){
        //       print("add");
        //       labelnames.add(label);
        //     }
        //   }
        //   print("end");
        // }
        // else{
        //   for(i=0;i<labelnames.length;i++){
        //     print(labelnames.length);
        //     if (label == labelnames[i]){
        //       print("samething");
        //     }else{
        //       labelnames.add(label);
        //       Rect rectAti = Rect.fromLTRB(
        //           max(0, locations[i].left),
        //           max(0, locations[i].top),
        //           min(INPUT_SIZE + 0.0, locations[i].right),
        //           min(INPUT_SIZE + 0.0, locations[i].bottom));
        //
        //       // Gets the coordinates based on the original image if anything was done to it.
        //       Rect transformedRect = imageProcessor.inverseTransformRect(
        //           rectAti, image.height, image.width);
        //
        //       recognitions.add(
        //         Recognition(i, label, score, transformedRect),
        //       );
        //     }
        //   }
        //
        // }

      }

      // print(labelnames);
    } // End of for loop and added all recognitions

    List<Recognition> recognitionsNMS = nms(recognitions);
    var predictElapsedTime =
        DateTime.now().millisecondsSinceEpoch - predictStartTime;

    return {
      'recognitions': recognitionsNMS,
      'stats': Stats(
          totalPredictTime: predictElapsedTime,
          inferenceTime: inferenceTimeElapsed,
          preProcessingTime: preProcessElapsedTime, totalElapsedTime: 0)
    };
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter!;

  /// Gets the loaded labels
  List<String> get labels => _labels;
}





// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img_lib;
// import '../tflite/recognition.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
//
// import 'stats.dart';
//
// /// Classifier
// class Classifier {
//   /// Instance of Interpreter
//   Interpreter _interpreter;
//
//   /// Labels file loaded as list
//   List<String> _labels;
//
//   static const String MODEL_FILE_NAME = 'tflite/detect-yolo4.tflite';
//   static const String LABEL_FILE_NAME = 'tflite/labelmap.txt';
//   // static const String MODEL_FILE_NAME = 'groceries-yolov4-tiny-416-01-09-21.tflite';
//   // static const String LABEL_FILE_NAME = 'groceries.txt';
//
//   /// Input size of image (height = width = 300)
//   static const int INPUT_SIZE = 300;
//
//   /// Result score threshold
//   static const double THRESHOLD = 0.5;
//
//   /// [ImageProcessor] used to pre-process the image
//   ImageProcessor imageProcessor;
//
//   /// Padding the image to transform into square
//   int padSize;
//
//   /// Shapes of output tensors
//   List<List<int>> _outputShapes;
//
//   /// Types of output tensors
//   List<TfLiteType> _outputTypes;
//
//   /// Number of results to show
//   static const int NUM_RESULTS = 10;
//
//   Classifier({
//     Interpreter interpreter,
//     List<String> labels,
//   }) {
//     loadModel(interpreter: interpreter);
//     loadLabels(labels: labels);
//   }
//
//   /// Loads interpreter from asset
//   void loadModel({Interpreter interpreter}) async {
//     try {
//       _interpreter = interpreter ??
//           await Interpreter.fromAsset(
//             MODEL_FILE_NAME,
//             options: InterpreterOptions()..threads = 4,
//           );
//
//       var outputTensors = _interpreter.getOutputTensors();
//       _outputShapes = [];
//       _outputTypes = [];
//       outputTensors.forEach((tensor) {
//         _outputShapes.add(tensor.shape);
//         _outputTypes.add(tensor.type);
//       });
//     } catch (e) {
//       print('Error while creating interpreter: $e');
//     }
//   }
//
//   /// Loads labels from assets
//   void loadLabels({List<String> labels}) async {
//     try {
//       _labels = labels ?? await FileUtil.loadLabels('assets/' + LABEL_FILE_NAME);
//     } catch (e) {
//       print('Error while loading labels: $e');
//     }
//   }
//
//   /// Pre-process the image
//   TensorImage getProcessedImage(TensorImage inputImage) {
//     padSize = max(inputImage.height, inputImage.width);
//     imageProcessor ??= ImageProcessorBuilder()
//         .add(ResizeWithCropOrPadOp(padSize, padSize))
//         .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
//         .build();
//     inputImage = imageProcessor.process(inputImage);
//     return inputImage;
//   }
//
//   /// Runs object detection on the input image
//   Map<String, dynamic> predict(img_lib.Image image) {
//     var predictStartTime = DateTime.now().millisecondsSinceEpoch;
//
//     if (_interpreter == null) {
//       print('Interpreter not initialized');
//       return null;
//     }
//
//     var preProcessStart = DateTime.now().millisecondsSinceEpoch;
//
//     // Create TensorImage from image
//     TensorImage inputImage = TensorImage.fromImage(image);
//
//     // Pre-process TensorImage
//     inputImage = getProcessedImage(inputImage);
//
//     var preProcessElapsedTime =
//         DateTime.now().millisecondsSinceEpoch - preProcessStart;
//
//     // TensorBuffers for output tensors
//     TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[0]);
//     TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[1]);
//     TensorBuffer outputScores = TensorBufferFloat(_outputShapes[2]);
//     TensorBuffer numLocations = TensorBufferFloat(_outputShapes[3]);
//
//     // Inputs object for runForMultipleInputs
//     // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
//     List<Object> inputs = [inputImage.buffer];
//
//     // Outputs map
//     Map<int, Object> outputs = {
//       0: outputLocations.buffer,
//       1: outputClasses.buffer,
//       2: outputScores.buffer,
//       3: numLocations.buffer,
//     };
//
//     var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;
//
//     // run inference
//     _interpreter.runForMultipleInputs(inputs, outputs);
//
//     var inferenceTimeElapsed =
//         DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;
//
//     // Maximum number of results to show
//     int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));
//
//     // Using labelOffset = 1 as ??? at index 0
//     int labelOffset = 1;
//
//     // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
//     List<Rect> locations = BoundingBoxUtils.convert(
//       tensor: outputLocations,
//       valueIndex: [1, 0, 3, 2],
//       boundingBoxAxis: 2,
//       boundingBoxType: BoundingBoxType.BOUNDARIES,
//       coordinateType: CoordinateType.RATIO,
//       height: INPUT_SIZE,
//       width: INPUT_SIZE,
//     );
//
//     List<Recognition> recognitions = [];
//
//     for (int i = 0; i < resultsCount; i++) {
//       // Prediction score
//       var score = outputScores.getDoubleValue(i);
//
//       // Label string
//       var labelIndex = outputClasses.getIntValue(i) + labelOffset;
//       var label = _labels.elementAt(labelIndex);
//
//       if (score > THRESHOLD) {
//         // inverse of rect
//         // [locations] corresponds to the image size 300 X 300
//         // inverseTransformRect transforms it our [inputImage]
//         Rect transformedRect = imageProcessor.inverseTransformRect(
//             locations[i], image.height, image.width);
//
//         recognitions.add(
//           Recognition(i, label, score, transformedRect),
//         );
//       }
//     }
//
//     var predictElapsedTime =
//         DateTime.now().millisecondsSinceEpoch - predictStartTime;
//
//     return {
//       'recognitions': recognitions,
//       'stats': Stats(
//           totalPredictTime: predictElapsedTime,
//           inferenceTime: inferenceTimeElapsed,
//           preProcessingTime: preProcessElapsedTime)
//     };
//   }
//
//   /// Gets the interpreter instance
//   Interpreter get interpreter => _interpreter;
//
//   /// Gets the loaded labels
//   List<String> get labels => _labels;
// }



// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img_lib;
// import '../tflite/recognition.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
//
// import 'stats.dart';
//
// /// Classifier
// class Classifier {
//   /// Instance of Interpreter
//   Interpreter _interpreter;
//
//   /// Labels file loaded as list
//   List<String> _labels;
//
//   static const String MODEL_FILE_NAME = 'tflite/detect-yolo4.tflite';
//   static const String LABEL_FILE_NAME = 'tflite/labelmap.txt';
//   // static const String MODEL_FILE_NAME = 'groceries-yolov4-tiny-416-01-09-21.tflite';
//   // static const String LABEL_FILE_NAME = 'groceries.txt';
//
//   /// Input size of image (height = width = 300)
//   static const int INPUT_SIZE = 300;
//
//   /// Result score threshold
//   static const double THRESHOLD = 0.5;
//
//   /// [ImageProcessor] used to pre-process the image
//   ImageProcessor imageProcessor;
//
//   /// Padding the image to transform into square
//   int padSize;
//
//   /// Shapes of output tensors
//   List<List<int>> _outputShapes;
//
//   /// Types of output tensors
//   List<TfLiteType> _outputTypes;
//
//   /// Number of results to show
//   static const int NUM_RESULTS = 10;
//
//   Classifier({
//     Interpreter interpreter,
//     List<String> labels,
//   }) {
//     loadModel(interpreter: interpreter);
//     loadLabels(labels: labels);
//   }
//
//   /// Loads interpreter from asset
//   void loadModel({Interpreter interpreter}) async {
//     try {
//       _interpreter = interpreter ??
//           await Interpreter.fromAsset(
//             MODEL_FILE_NAME,
//             options: InterpreterOptions()..threads = 4,
//           );
//
//       var outputTensors = _interpreter.getOutputTensors();
//       _outputShapes = [];
//       _outputTypes = [];
//       outputTensors.forEach((tensor) {
//         _outputShapes.add(tensor.shape);
//         _outputTypes.add(tensor.type);
//       });
//     } catch (e) {
//       print('Error while creating interpreter: $e');
//     }
//   }
//
//   /// Loads labels from assets
//   void loadLabels({List<String> labels}) async {
//     try {
//       _labels = labels ?? await FileUtil.loadLabels('assets/' + LABEL_FILE_NAME);
//     } catch (e) {
//       print('Error while loading labels: $e');
//     }
//   }
//
//   /// Pre-process the image
//   TensorImage getProcessedImage(TensorImage inputImage) {
//     padSize = max(inputImage.height, inputImage.width);
//     imageProcessor ??= ImageProcessorBuilder()
//         .add(ResizeWithCropOrPadOp(padSize, padSize))
//         .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
//         .build();
//     inputImage = imageProcessor.process(inputImage);
//     return inputImage;
//   }
//
//   /// Runs object detection on the input image
//   Map<String, dynamic> predict(img_lib.Image image) {
//     var predictStartTime = DateTime.now().millisecondsSinceEpoch;
//
//     if (_interpreter == null) {
//       print('Interpreter not initialized');
//       return null;
//     }
//
//     var preProcessStart = DateTime.now().millisecondsSinceEpoch;
//
//     // Create TensorImage from image
//     TensorImage inputImage = TensorImage.fromImage(image);
//
//     // Pre-process TensorImage
//     inputImage = getProcessedImage(inputImage);
//
//     var preProcessElapsedTime =
//         DateTime.now().millisecondsSinceEpoch - preProcessStart;
//
//     // TensorBuffers for output tensors
//     TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[0]);
//     TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[1]);
//     TensorBuffer outputScores = TensorBufferFloat(_outputShapes[2]);
//     TensorBuffer numLocations = TensorBufferFloat(_outputShapes[3]);
//
//     // Inputs object for runForMultipleInputs
//     // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
//     List<Object> inputs = [inputImage.buffer];
//
//     // Outputs map
//     Map<int, Object> outputs = {
//       0: outputLocations.buffer,
//       1: outputClasses.buffer,
//       2: outputScores.buffer,
//       3: numLocations.buffer,
//     };
//
//     var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;
//
//     // run inference
//     _interpreter.runForMultipleInputs(inputs, outputs);
//
//     var inferenceTimeElapsed =
//         DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;
//
//     // Maximum number of results to show
//     int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));
//
//     // Using labelOffset = 1 as ??? at index 0
//     int labelOffset = 1;
//
//     // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
//     List<Rect> locations = BoundingBoxUtils.convert(
//       tensor: outputLocations,
//       valueIndex: [1, 0, 3, 2],
//       boundingBoxAxis: 2,
//       boundingBoxType: BoundingBoxType.BOUNDARIES,
//       coordinateType: CoordinateType.RATIO,
//       height: INPUT_SIZE,
//       width: INPUT_SIZE,
//     );
//
//     List<Recognition> recognitions = [];
//
//     for (int i = 0; i < resultsCount; i++) {
//       // Prediction score
//       var score = outputScores.getDoubleValue(i);
//
//       // Label string
//       var labelIndex = outputClasses.getIntValue(i) + labelOffset;
//       var label = _labels.elementAt(labelIndex);
//
//       if (score > THRESHOLD) {
//         // inverse of rect
//         // [locations] corresponds to the image size 300 X 300
//         // inverseTransformRect transforms it our [inputImage]
//         Rect transformedRect = imageProcessor.inverseTransformRect(
//             locations[i], image.height, image.width);
//
//         recognitions.add(
//           Recognition(i, label, score, transformedRect),
//         );
//       }
//     }
//
//     var predictElapsedTime =
//         DateTime.now().millisecondsSinceEpoch - predictStartTime;
//
//     return {
//       'recognitions': recognitions,
//       'stats': Stats(
//           totalPredictTime: predictElapsedTime,
//           inferenceTime: inferenceTimeElapsed,
//           preProcessingTime: preProcessElapsedTime)
//     };
//   }
//
//   /// Gets the interpreter instance
//   Interpreter get interpreter => _interpreter;
//
//   /// Gets the loaded labels
//   List<String> get labels => _labels;
// }
