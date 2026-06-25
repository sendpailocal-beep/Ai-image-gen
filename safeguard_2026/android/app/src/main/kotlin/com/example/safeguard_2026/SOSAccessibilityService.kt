package com.example.safeguard_2026

import android.accessibilityservice.AccessibilityService
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent
import android.content.Intent

class SOSAccessibilityService : AccessibilityService() {
    private var isUpPressed = false
    private var isDownPressed = false

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}

    override fun onKeyEvent(event: KeyEvent): Boolean {
        val keyCode = event.keyCode
        val action = event.action

        if (action == KeyEvent.ACTION_DOWN) {
            if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) isUpPressed = true
            if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) isDownPressed = true

            if (isUpPressed && isDownPressed) {
                isUpPressed = false
                isDownPressed = false
                triggerSOS()
            }
        } else if (action == KeyEvent.ACTION_UP) {
            if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) isUpPressed = false
            if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) isDownPressed = false
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
