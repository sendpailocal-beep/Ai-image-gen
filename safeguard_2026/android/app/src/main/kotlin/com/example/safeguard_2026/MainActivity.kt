package com.example.safeguard_2026

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.safeguard_2026/trigger"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.getBooleanExtra("sos_triggered", false)) {
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("triggerSOS", null)
        }
    }

    override fun onResume() {
        super.onResume()
        if (intent.getBooleanExtra("sos_triggered", false)) {
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("triggerSOS", null)
            intent.putExtra("sos_triggered", false) // Reset
        }
    }
}
