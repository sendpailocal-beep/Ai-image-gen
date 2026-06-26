package com.example.safeguard_2026

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.safeguard_2026/trigger"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    override fun onResume() {
        super.onResume()
        if (intent.getBooleanExtra("sos_triggered", false)) {
            methodChannel?.invokeMethod("triggerSOS", null)
            intent.putExtra("sos_triggered", false)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        if (intent.getBooleanExtra("sos_triggered", false)) {
            methodChannel?.invokeMethod("triggerSOS", null)
        }
    }
}
