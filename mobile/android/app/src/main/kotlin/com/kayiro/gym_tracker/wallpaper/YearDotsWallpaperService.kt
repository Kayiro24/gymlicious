package com.kayiro.gym_tracker.wallpaper

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.os.Handler
import android.os.Looper
import android.service.wallpaper.WallpaperService
import android.view.SurfaceHolder
import androidx.core.content.ContextCompat
import java.time.Duration
import java.time.LocalDate
import java.time.LocalDateTime

/**
 * "Year Dots" live wallpaper. Static drawing only: it redraws on visibility,
 * surface, config and date changes, with one timer to the next midnight while
 * visible. No Flutter engine runs here.
 */
class YearDotsWallpaperService : WallpaperService() {
    override fun onCreateEngine(): Engine = YearDotsEngine()

    private inner class YearDotsEngine : Engine(), SharedPreferences.OnSharedPreferenceChangeListener {
        private val handler = Handler(Looper.getMainLooper())
        private val renderer = YearDotsRenderer(assets)
        private val prefs = WallpaperConfig.prefs(this@YearDotsWallpaperService)
        private var config = WallpaperConfig.read(prefs)
        private var isVisibleNow = false
        private val midnight = Runnable {
            draw()
            scheduleMidnight()
        }
        private val dateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                draw()
                scheduleMidnight()
            }
        }

        override fun onCreate(surfaceHolder: SurfaceHolder) {
            super.onCreate(surfaceHolder)
            prefs.registerOnSharedPreferenceChangeListener(this)
            val filter = IntentFilter().apply {
                addAction(Intent.ACTION_DATE_CHANGED)
                addAction(Intent.ACTION_TIME_CHANGED)
                addAction(Intent.ACTION_TIMEZONE_CHANGED)
            }
            ContextCompat.registerReceiver(
                this@YearDotsWallpaperService,
                dateReceiver,
                filter,
                ContextCompat.RECEIVER_NOT_EXPORTED,
            )
        }

        override fun onDestroy() {
            handler.removeCallbacks(midnight)
            prefs.unregisterOnSharedPreferenceChangeListener(this)
            unregisterReceiver(dateReceiver)
            super.onDestroy()
        }

        override fun onVisibilityChanged(visible: Boolean) {
            isVisibleNow = visible
            if (visible) {
                draw()
                scheduleMidnight()
            } else {
                handler.removeCallbacks(midnight)
            }
        }

        override fun onSurfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
            super.onSurfaceChanged(holder, format, width, height)
            draw()
        }

        override fun onSharedPreferenceChanged(sharedPreferences: SharedPreferences, key: String?) {
            config = WallpaperConfig.read(sharedPreferences)
            draw()
        }

        private fun scheduleMidnight() {
            handler.removeCallbacks(midnight)
            if (!isVisibleNow) return
            val now = LocalDateTime.now()
            val next = now.toLocalDate().plusDays(1).atStartOfDay()
            // A second of slack so the clock has definitely rolled over.
            handler.postDelayed(midnight, Duration.between(now, next).toMillis() + 1000)
        }

        private fun draw() {
            val holder = surfaceHolder
            val canvas = runCatching { holder.lockCanvas() }.getOrNull() ?: return
            try {
                renderer.draw(canvas, config, LocalDate.now(), resources.displayMetrics.density)
            } finally {
                holder.unlockCanvasAndPost(canvas)
            }
        }
    }
}
