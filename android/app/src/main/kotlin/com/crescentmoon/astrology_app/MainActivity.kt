package com.crescentmoon.astrology_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val plugin = NativeWebSocketPlugin(applicationContext)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "native_websocket")
            .setMethodCallHandler(plugin)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "native_websocket/events")
            .setStreamHandler(plugin.streamHandler)
    }
}
