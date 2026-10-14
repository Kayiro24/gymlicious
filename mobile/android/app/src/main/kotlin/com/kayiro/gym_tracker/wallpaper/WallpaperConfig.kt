package com.kayiro.gym_tracker.wallpaper

import android.content.Context
import android.content.SharedPreferences

/** The settings pushed from Flutter; defaults match YearDotsSettings. */
data class WallpaperConfig(
    val isMonths: Boolean = false,
    val colorPreset: String = "light",
    val textLine: String = "left_and_percent",
    val topMarginPercent: Int = 22,
    val padding: Int = 24,
    val summaryTemplate: String = "Day {day} of {total} · {left} left · {percent}%",
    val leftOnlyTemplate: String = "{left} days left",
    val monthInitials: List<String> = "J,F,M,A,M,J,J,A,S,O,N,D".split(","),
) {
    val palette: YearDotsPalette
        get() = YearDotsTokens.presets[colorPreset] ?: YearDotsTokens.presets.getValue("light")

    fun textFor(dayOfYear: Int, daysInYear: Int): String? {
        val left = daysInYear - dayOfYear
        val percent = Math.round(dayOfYear * 100.0 / daysInYear)
        val template = when (textLine) {
            "left_only" -> leftOnlyTemplate
            "none" -> return null
            else -> summaryTemplate
        }
        return template
            .replace("{day}", dayOfYear.toString())
            .replace("{total}", daysInYear.toString())
            .replace("{left}", left.toString())
            .replace("{percent}", percent.toString())
    }

    companion object {
        const val PREFS_NAME = "year_dots_wallpaper"

        fun prefs(context: Context): SharedPreferences =
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        fun read(prefs: SharedPreferences): WallpaperConfig {
            val defaults = WallpaperConfig()
            return WallpaperConfig(
                isMonths = prefs.getString("layout", null) == "months",
                colorPreset = prefs.getString("colorPreset", null) ?: defaults.colorPreset,
                textLine = prefs.getString("textLine", null) ?: defaults.textLine,
                topMarginPercent = prefs.getInt("topMarginPercent", defaults.topMarginPercent),
                padding = prefs.getInt("padding", defaults.padding),
                summaryTemplate = prefs.getString("summaryTemplate", null) ?: defaults.summaryTemplate,
                leftOnlyTemplate = prefs.getString("leftOnlyTemplate", null) ?: defaults.leftOnlyTemplate,
                monthInitials = prefs.getString("monthInitials", null)?.split(",")
                    ?: defaults.monthInitials,
            )
        }

        fun write(prefs: SharedPreferences, values: Map<*, *>) {
            prefs.edit().apply {
                for ((key, value) in values) {
                    val name = key as? String ?: continue
                    when (value) {
                        is String -> putString(name, value)
                        is Number -> putInt(name, value.toInt())
                    }
                }
            }.apply()
        }
    }
}
