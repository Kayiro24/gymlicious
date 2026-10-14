package com.kayiro.gym_tracker.wallpaper

/** Mirror of the Dart WallpaperFrame: where the grid and text line sit. */
data class WallpaperFrame(
    val gridLeft: Double,
    val gridTop: Double,
    val gridWidth: Double,
    val gridHeight: Double,
    val textSize: Double,
    val textCenterY: Double,
) {
    companion object {
        private const val TEXT_SIZE_RATIO = 0.035
        private const val TEXT_BLOCK_RATIO = 3.0

        fun compute(
            width: Double,
            height: Double,
            topMarginPercent: Int,
            padding: Double,
            hasText: Boolean,
        ): WallpaperFrame {
            val textSize = width * TEXT_SIZE_RATIO
            val textBlock = if (hasText) textSize * TEXT_BLOCK_RATIO else 0.0
            val gridTop = height * topMarginPercent / 100
            val gridBottom = height - padding - textBlock
            return WallpaperFrame(
                gridLeft = padding,
                gridTop = gridTop,
                gridWidth = (width - padding * 2).coerceIn(0.0, width),
                gridHeight = (gridBottom - gridTop).coerceIn(0.0, height),
                textSize = textSize,
                textCenterY = height - padding - textBlock / 2,
            )
        }
    }
}
