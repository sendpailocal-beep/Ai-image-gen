package com.example.safeguard_2026

import android.accessibilityservice.AccessibilityService
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent
import android.content.Intent
import android.os.Handler
import android.os.Looper

class SOSAccessibilityService : AccessibilityService() {

    private var volumeUpCount = 0
    private val handler = Handler(Looper.getMainLooper())
    private val resetCountRunnable = Runnable { volumeUpCount = 0 }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}

    override fun onInterrupt() {}

    override fun onKeyEvent(event: KeyEvent): Boolean {
        if (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP && event.action == KeyEvent.ACTION_DOWN) {
            volumeUpCount++

            handler.removeCallbacks(resetCountRunnable)
            handler.postDelayed(resetCountRunnable, 3000) // Reset if no press for 3 seconds

            if (volumeUpCount >= 4) {
                triggerSOS()
                volumeUpCount = 0
            }
            return false // Allow the OS to still process the volume change if needed
        }
        return super.onKeyEvent(event)
    }

    private fun triggerSOS() {
        // Bring the app to foreground and start SOS logic
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        intent?.let {
            it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            it.putExtra("trigger_sos", true)
            startActivity(it)
        }
    }
}
