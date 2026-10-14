package com.kayiro.gym_tracker.channels

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File

/** `gymtracker/share`: sends a file straight to WhatsApp or WhatsApp Business. */
class ShareChannel(private val activity: Activity) {
    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareToWhatsApp" -> {
                    val path = call.argument<String>("path")
                    val mimeType = call.argument<String>("mimeType") ?: "*/*"
                    result.success(path != null && shareToWhatsApp(File(path), mimeType))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun shareToWhatsApp(file: File, mimeType: String): Boolean {
        val target = WHATSAPP_PACKAGES.firstOrNull(::isInstalled) ?: return false
        val uri = FileProvider.getUriForFile(activity, "${activity.packageName}.exports", file)
        val intent = Intent(Intent.ACTION_SEND)
            .setType(mimeType)
            .setPackage(target)
            .putExtra(Intent.EXTRA_STREAM, uri)
            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        return try {
            activity.startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }

    private fun isInstalled(packageName: String): Boolean = try {
        activity.packageManager.getPackageInfo(packageName, 0)
        true
    } catch (_: PackageManager.NameNotFoundException) {
        false
    }

    private companion object {
        const val NAME = "gymtracker/share"
        val WHATSAPP_PACKAGES = listOf("com.whatsapp", "com.whatsapp.w4b")
    }
}
