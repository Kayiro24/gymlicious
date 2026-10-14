package com.kayiro.gym_tracker.wallpaper

import android.content.res.AssetManager
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.graphics.Typeface
import java.time.LocalDate

/** Draws the same picture as the Dart WallpaperImageRenderer. */
class YearDotsRenderer(assets: AssetManager) {
    private val regular = loadFont(assets, "PlusJakartaSans-Regular.ttf")
    private val semiBold = loadFont(assets, "PlusJakartaSans-SemiBold.ttf")
    private val fill = Paint(Paint.ANTI_ALIAS_FLAG)
    private val ring = Paint(Paint.ANTI_ALIAS_FLAG).apply { style = Paint.Style.STROKE }
    private val text = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        textAlign = Paint.Align.CENTER
        fontFeatureSettings = "'tnum'"
    }
    private val label = Paint(Paint.ANTI_ALIAS_FLAG)
    private val rect = RectF()

    fun draw(canvas: Canvas, config: WallpaperConfig, today: LocalDate, density: Float) {
        val width = canvas.width.toDouble()
        val height = canvas.height.toDouble()
        val palette = config.palette
        canvas.drawColor(palette.background)

        val dayOfYear = today.dayOfYear
        val daysInYear = today.lengthOfYear()
        val line = config.textFor(dayOfYear, daysInYear)
        val frame = WallpaperFrame.compute(
            width = width,
            height = height,
            topMarginPercent = config.topMarginPercent,
            padding = config.padding * density.toDouble(),
            hasText = line != null,
        )
        val layout = DotLayout.compute(config.isMonths, today.year, frame.gridWidth, frame.gridHeight)
        val radius = (layout.cellWidth * YearDotsTokens.CORNER_RATIO).toFloat()
        val ringWidth = (layout.cellWidth * YearDotsTokens.TODAY_OUTLINE_RATIO).toFloat()

        layout.cells.forEachIndexed { index, cell ->
            val day = index + 1
            fill.color = when {
                day < dayOfYear -> palette.done
                day == dayOfYear -> palette.today
                else -> palette.left
            }
            setRect(frame, cell)
            canvas.drawRoundRect(rect, radius, radius, fill)
            if (day == dayOfYear) {
                ring.color = palette.today
                ring.strokeWidth = ringWidth
                rect.inset(-ringWidth * 1.5f, -ringWidth * 1.5f)
                canvas.drawRoundRect(rect, radius, radius, ring)
            }
        }

        if (layout.monthLabels.size == config.monthInitials.size) {
            label.color = palette.text
            label.typeface = semiBold
            layout.monthLabels.forEachIndexed { index, slot ->
                setRect(frame, slot)
                label.textSize = rect.height() * LABEL_SIZE_RATIO
                val baseline = rect.centerY() - (label.descent() + label.ascent()) / 2
                canvas.drawText(config.monthInitials[index], rect.left, baseline, label)
            }
        }

        if (line != null) {
            text.color = palette.text
            text.typeface = regular
            text.textSize = frame.textSize.toFloat()
            val baseline = frame.textCenterY.toFloat() - (text.descent() + text.ascent()) / 2
            canvas.drawText(line, (width / 2).toFloat(), baseline, text)
        }
    }

    private fun setRect(frame: WallpaperFrame, cell: DotRect) {
        val left = (frame.gridLeft + cell.left).toFloat()
        val top = (frame.gridTop + cell.top).toFloat()
        rect.set(left, top, left + cell.width.toFloat(), top + cell.height.toFloat())
    }

    private companion object {
        const val LABEL_SIZE_RATIO = 0.8f

        // Flutter packs pubspec font assets under flutter_assets/.
        fun loadFont(assets: AssetManager, file: String): Typeface =
            runCatching { Typeface.createFromAsset(assets, "flutter_assets/assets/fonts/$file") }
                .getOrDefault(Typeface.SANS_SERIF)
    }
}
