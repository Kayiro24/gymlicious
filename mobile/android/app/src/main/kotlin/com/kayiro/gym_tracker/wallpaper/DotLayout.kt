package com.kayiro.gym_tracker.wallpaper

import java.time.LocalDate
import kotlin.math.ceil
import kotlin.math.min

data class DotRect(val left: Double, val top: Double, val width: Double, val height: Double)

/**
 * Port of the Dart DotLayout (ADR 0004). Both are checked against
 * shared-test-vectors/year_dots/layout_test_vectors.json, so change them together.
 */
class DotLayout private constructor(
    val cellWidth: Double,
    val cells: List<DotRect>,
    val monthLabels: List<DotRect>,
    val columns: Int = 0,
    val rows: Int = 0,
    val blockColumns: Int = 0,
    val blockRows: Int = 0,
) {
    val cellHeight: Double get() = cellWidth / ASPECT

    companion object {
        val GAP_RATIO = YearDotsTokens.GAP_RATIO.toDouble()
        val ASPECT = YearDotsTokens.ASPECT.toDouble()
        val MIN_COLUMNS = YearDotsTokens.MIN_COLUMNS
        val MAX_COLUMNS = YearDotsTokens.MAX_COLUMNS
        private const val DAYS_PER_WEEK = 7
        private const val MONTHS_PER_YEAR = 12
        private const val BLOCK_ROW_COUNT = 7
        private const val TIE_EPSILON = 1e-9

        fun compute(months: Boolean, year: Int, width: Double, height: Double): DotLayout =
            if (months) months(year, width, height)
            else continuous(LocalDate.of(year, 12, 31).dayOfYear, width, height)

        fun continuous(dayCount: Int, width: Double, height: Double): DotLayout {
            var bestWidth = -1.0
            var bestColumns = MIN_COLUMNS
            var bestRows = 0
            for (columns in MIN_COLUMNS..MAX_COLUMNS) {
                val rows = ceil(dayCount.toDouble() / columns).toInt()
                val cellWidth = min(
                    width / (columns + (columns - 1) * GAP_RATIO),
                    height / (rows + (rows - 1) * GAP_RATIO) * ASPECT,
                )
                if (cellWidth > bestWidth + TIE_EPSILON) {
                    bestWidth = cellWidth
                    bestColumns = columns
                    bestRows = rows
                }
            }
            val cellHeight = bestWidth / ASPECT
            val gap = bestWidth * GAP_RATIO
            val gridWidth = bestColumns * bestWidth + (bestColumns - 1) * gap
            val gridHeight = bestRows * cellHeight + (bestRows - 1) * gap
            val left = (width - gridWidth) / 2
            val top = (height - gridHeight) / 2
            val cells = List(dayCount) { index ->
                DotRect(
                    left = left + (index % bestColumns) * (bestWidth + gap),
                    top = top + (index / bestColumns) * (cellHeight + gap),
                    width = bestWidth,
                    height = cellHeight,
                )
            }
            return DotLayout(
                cellWidth = bestWidth,
                cells = cells,
                monthLabels = emptyList(),
                columns = bestColumns,
                rows = bestRows,
            )
        }

        fun months(year: Int, width: Double, height: Double): DotLayout {
            var bestWidth = -1.0
            var blockColumns = 3
            var blockRows = 4
            for ((columns, rows) in listOf(3 to 4, 4 to 3)) {
                val cellWidth = min(
                    width / (columns * (DAYS_PER_WEEK + 6 * GAP_RATIO) + (columns - 1)),
                    height / (rows * (BLOCK_ROW_COUNT / ASPECT + 6 * GAP_RATIO) + (rows - 1)),
                )
                if (cellWidth > bestWidth + TIE_EPSILON) {
                    bestWidth = cellWidth
                    blockColumns = columns
                    blockRows = rows
                }
            }
            val cellHeight = bestWidth / ASPECT
            val gap = bestWidth * GAP_RATIO
            val blockWidth = DAYS_PER_WEEK * bestWidth + 6 * gap
            val blockHeight = BLOCK_ROW_COUNT * cellHeight + 6 * gap
            val totalWidth = blockColumns * blockWidth + (blockColumns - 1) * bestWidth
            val totalHeight = blockRows * blockHeight + (blockRows - 1) * bestWidth
            val left = (width - totalWidth) / 2
            val top = (height - totalHeight) / 2

            val cells = mutableListOf<DotRect>()
            val labels = mutableListOf<DotRect>()
            for (month in 0 until MONTHS_PER_YEAR) {
                val blockLeft = left + (month % blockColumns) * (blockWidth + bestWidth)
                val blockTop = top + (month / blockColumns) * (blockHeight + bestWidth)
                labels += DotRect(blockLeft, blockTop, blockWidth, cellHeight)
                val first = LocalDate.of(year, month + 1, 1)
                for (day in 0 until first.lengthOfMonth()) {
                    val index = first.dayOfWeek.value - 1 + day
                    cells += DotRect(
                        left = blockLeft + (index % DAYS_PER_WEEK) * (bestWidth + gap),
                        top = blockTop + (1 + index / DAYS_PER_WEEK) * (cellHeight + gap),
                        width = bestWidth,
                        height = cellHeight,
                    )
                }
            }
            return DotLayout(
                cellWidth = bestWidth,
                cells = cells,
                monthLabels = labels,
                blockColumns = blockColumns,
                blockRows = blockRows,
            )
        }
    }
}
