package com.example.safeguard_2026

import android.accessibilityservice.AccessibilityService
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent
import android.content.Intent

class SOSAccessibilityService : AccessibilityService() {
    private var count = 0
    private var lastTime: Long = 0

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}

    override fun onKeyEvent(event: KeyEvent): Boolean {
        if (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP && event.action == KeyEvent.ACTION_DOWN) {
            val now = System.currentTimeMillis()
            if (now - lastTime > 2000) count = 0 // Reset if too slow

            lastTime = now
            count++

            if (count >= 4) {
                count = 0
                val intent = packageManager.getLaunchIntentForPackage(packageName)
                intent?.let {
                    it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(it)
                }
            }
        }
        return super.onKeyEvent(event)
    }
}
