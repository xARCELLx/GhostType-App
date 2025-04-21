// android/keyboard/KeyboardService.kt

package com.ghost_type // <-- match this to your real package

import android.inputmethodservice.InputMethodService
import android.view.View
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class KeyboardService : InputMethodService() {

    private lateinit var flutterEngine: FlutterEngine
    private lateinit var flutterView: FlutterView

    override fun onCreate() {
        super.onCreate()

        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        flutterView = FlutterView(this)
        flutterView.attachToFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ghost_channel")
            .setMethodCallHandler { call, _ ->
                if (call.method == "keyPress") {
                    val text = call.argument<String>("text")
                    currentInputConnection?.commitText(text, 1)
                }
            }
    }

    override fun onCreateInputView(): View {
        return flutterView
    }
}
