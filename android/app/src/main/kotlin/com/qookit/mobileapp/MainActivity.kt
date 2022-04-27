package com.qookit.mobileapp

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

//    private var rs: RenderScript? = null
//    protected fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        GeneratedPluginRegistrant.registerWith(this)
//        rs = RenderScript.create(this)
//        MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
//            object : MethodCallHandler() {
//                fun onMethodCall(call: MethodCall, result: Result) {
//                    if (call.method.equals("loadModel")) {
//                        val modalPath: String = call.argument("modal_path")
//                        val metaData: Map<*, *> = call.argument("meta_data")
//                        loadModel(modalPath, metaData, result)
//                    }
//                }
//            })
//    }
//
//    protected fun loadModel(modalPath: String?, metaData: Map<*, *>?, result: Result) {
//        Thread {
//            try {
//                val modalPathKey: String = getFlutterView().getLookupKeyForAsset(modalPath)
//                val modalData = loadModalFile(
//                    ApplicationProvider.getApplicationContext<Context>().getAssets()
//                        .openFd(modalPathKey)
//                )
//                detector = YoloDetector(rs, modalData, metaData)
//                modalLoaded = true
//                result.success("Modal Loaded Sucessfully")
//            } catch (e: Exception) {
//                e.printStackTrace()
//                result.error("Modal failed to loaded", e.message, null)
//            }
//        }.start()
//    }
//
//    @Throws(IOException::class)
//    fun loadModalFile(fileDescriptor: AssetFileDescriptor): ByteBuffer {
//        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
//        val fileChannel = inputStream.channel
//        val startOffset = fileDescriptor.startOffset
//        val declaredLength = fileDescriptor.declaredLength
//        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
//    }
//
//    companion object {
//        private const val CHANNEL = "ai.qookit/flutter_tflite"
//        private var detector: YoloDetector? = null
//        private var modalLoaded = false
//    }

}
