package com.kayiro.gym_tracker.channels

import android.app.Activity
import android.app.WallpaperManager
import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import com.kayiro.gym_tracker.wallpaper.WallpaperConfig
import com.kayiro.gym_tracker.wallpaper.YearDotsWallpaperService
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** `gymtracker/wallpaper`: config storage and the system live-wallpaper preview. */
class WallpaperChannel(private val activity: Activity) {
    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "isSupported" -> result.success(isSupported())
                "setConfig" -> {
                    val values = call.arguments as? Map<*, *>
                    if (values != null) {
                        WallpaperConfig.write(WallpaperConfig.prefs(activity), values)
                    }
                    result.success(null)
                }
                "openPicker" -> result.success(openPicker())
                else -> result.notImplemented()
            }
        }
    }

    private fun isSupported(): Boolean =
        activity.packageManager.hasSystemFeature(PackageManager.FEATURE_LIVE_WALLPAPER) &&
            WallpaperManager.getInstance(activity).isWallpaperSupported

    private fun openPicker(): Boolean {
        val preview = Intent(WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER).putExtra(
            WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT,
            ComponentName(activity, YearDotsWallpaperService::class.java),
        )
        val chooser = Intent(WallpaperManager.ACTION_LIVE_WALLPAPER_CHOOSER)
        for (intent in listOf(preview, chooser)) {
            try {
                activity.startActivity(intent)
                return true
            } catch (_: ActivityNotFoundException) {
                continue
            }
        }
        return false
    }

    private companion object {
        const val NAME = "gymtracker/wallpaper"
    }
}
