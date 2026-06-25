package com.example.safeguard_2026

import android.accessibilityservice.AccessibilityService
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent
import android.content.Intent
import android.os.Handler
import android.os.Looper

class SOSAccessibilityService : AccessibilityService() {
    private var pressCount = 0
    private val handler = Handler(Looper.getMainLooper())
    private val resetTask = Runnable { pressCount = 0 }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}

    override fun onKeyEvent(event: KeyEvent): Boolean {
        val keyCode = event.keyCode
        val action = event.action

        // Trigger on ANY volume button (Up or Down)
        if (action == KeyEvent.ACTION_DOWN && (keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN)) {
            pressCount++

            handler.removeCallbacks(resetTask)
            handler.postDelayed(resetTask, 3000) // Reset if no activity for 3 seconds

            if (pressCount >= 4) {
                pressCount = 0
                triggerSOS()
            }
        }

        return super.onKeyEvent(event)
    }

    private fun triggerSOS() {
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        intent?.let {
            it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(it)
        }
    }
}
