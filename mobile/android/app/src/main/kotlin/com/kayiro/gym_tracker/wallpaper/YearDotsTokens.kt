// GENERATED FILE. Edit design-tokens/tokens.json and run `dart design-tokens/tool/generate_theme.dart` from the repo root.
package com.kayiro.gym_tracker.wallpaper

object YearDotsTokens {
    const val GAP_RATIO = 0.3f
    const val ASPECT = 0.8f
    const val CORNER_RATIO = 0.25f
    const val MIN_COLUMNS = 10
    const val MAX_COLUMNS = 31
    const val TODAY_OUTLINE_RATIO = 0.18f

    val presets: Map<String, YearDotsPalette> = mapOf(
        "light" to YearDotsPalette(background = 0xFFFFF7EE.toInt(), done = 0xFF2A1B14.toInt(), today = 0xFFC2410C.toInt(), left = 0xFFF0E2D2.toInt(), text = 0xFF6B5446.toInt()),
        "dark" to YearDotsPalette(background = 0xFF0F0F0F.toInt(), done = 0xFFF1F1F1.toInt(), today = 0xFFFF8A4C.toInt(), left = 0xFF3F3F3F.toInt(), text = 0xFFAAAAAA.toInt()),
        "black" to YearDotsPalette(background = 0xFF000000.toInt(), done = 0xFFF2E6DA.toInt(), today = 0xFFFF8A4C.toInt(), left = 0xFF2A211C.toInt(), text = 0xFFB8A698.toInt()),
        "ember" to YearDotsPalette(background = 0xFFF26B2D.toInt(), done = 0xFF2A1B14.toInt(), today = 0xFFFFF7EE.toInt(), left = 0xFFF59A6B.toInt(), text = 0xFF2A1B14.toInt()),
    )
}

data class YearDotsPalette(
    val background: Int,
    val done: Int,
    val today: Int,
    val left: Int,
    val text: Int,
)
