package com.example.flutter_ec_0711

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.flutter_ec_0711")

        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "test") {
                result.success("Testing ${call.argument<String>("name")} ${call.argument<String>("password")}")
            }
        }
    }
}
