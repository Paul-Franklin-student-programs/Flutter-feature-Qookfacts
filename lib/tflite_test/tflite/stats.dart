/// Bundles different elapsed times
class Stats {
  /// Total time taken in the isolate where the inference runs
  int totalPredictTime;

  /// [totalPredictTime] + communication overhead time
  /// between main isolate and another isolate
  int totalElapsedTime;

  /// Time for which inference runs
  int inferenceTime;

  /// Time taken to pre-process the image
  int preProcessingTime;

  Stats(
      {
      required this.totalPredictTime,
      required this.totalElapsedTime,
      required this.inferenceTime,
      required this.preProcessingTime});

  static Stats empty() => Stats(totalPredictTime: 0, totalElapsedTime: 0, inferenceTime: 0, preProcessingTime: 0);

  @override
  String toString() {
    return 'Stats{totalPredictTime: $totalPredictTime, totalElapsedTime: $totalElapsedTime, inferenceTime: $inferenceTime, preProcessingTime: $preProcessingTime}';
  }
}
