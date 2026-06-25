package com.example.safeguard_2026

import android.accessibilityservice.AccessibilityService
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent
import android.util.Log
import android.content.Intent
import android.os.Handler
import android.os.Looper

class SOSAccessibilityService : AccessibilityService() {

    private var volumeUpCount = 0
    private val handler = Handler(Looper.getMainLooper())
    private val resetCountRunnable = Runnable { volumeUpCount = 0 }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Not used
    }

    override fun onInterrupt() {
        // Not used
    }

    override fun onKeyEvent(event: KeyEvent): Boolean {
        val keyCode = event.keyCode

        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP && event.action == KeyEvent.ACTION_DOWN) {
            volumeUpCount++
            Log.d("SOSService", "Volume Up Count: $volumeUpCount")

            handler.removeCallbacks(resetCountRunnable)
            handler.postDelayed(resetCountRunnable, 2000) // Reset count after 2 seconds

            if (volumeUpCount >= 3) {
                triggerSOS()
                volumeUpCount = 0
            }
            return true // Consume the event so volume doesn't actually change
        }

        return super.onKeyEvent(event)
    }

    private fun triggerSOS() {
        Log.d("SOSService", "SOS TRIGGERED!")
        val intent = Intent("com.example.safeguard_2026.TRIGGER_SOS")
        intent.setPackage(packageName)
        sendBroadcast(intent)
    }
}
