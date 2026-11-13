package com.sirodevs.roadbash

import android.hardware.input.InputManager
import android.os.Handler
import android.view.KeyEvent
import android.view.MotionEvent
import io.flutter.embedding.android.FlutterActivity
import org.flame_engine.gamepads_android.GamepadsCompatibleActivity

class MainActivity : FlutterActivity(), GamepadsCompatibleActivity {
    private var keyListener: ((KeyEvent) -> Boolean)? = null
    private var motionListener: ((MotionEvent) -> Boolean)? = null

    override fun dispatchGenericMotionEvent(motionEvent: MotionEvent): Boolean {
        if (motionListener?.invoke(motionEvent) == true) return true
        return super.dispatchGenericMotionEvent(motionEvent)
    }

    override fun dispatchKeyEvent(keyEvent: KeyEvent): Boolean {
        if (keyListener?.invoke(keyEvent) == true) return true
        return super.dispatchKeyEvent(keyEvent)
    }

    override fun registerInputDeviceListener(
        listener: InputManager.InputDeviceListener,
        handler: Handler?,
    ) {
        val inputManager = getSystemService(INPUT_SERVICE) as InputManager
        inputManager.registerInputDeviceListener(listener, null)
    }

    override fun registerKeyEventHandler(handler: (KeyEvent) -> Boolean) {
        keyListener = handler
    }

    override fun registerMotionEventHandler(handler: (MotionEvent) -> Boolean) {
        motionListener = handler
    }
}
