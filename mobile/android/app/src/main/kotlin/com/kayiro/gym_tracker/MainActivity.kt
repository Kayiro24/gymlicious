package com.kayiro.gym_tracker

import com.kayiro.gym_tracker.channels.ShareChannel
import com.kayiro.gym_tracker.channels.WallpaperChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        ShareChannel(this).register(messenger)
        WallpaperChannel(this).register(messenger)
    }
}
