package com.kayiro.gym_tracker.wallpaper

import java.io.File
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Test

/** Same vectors as the Dart test, so both renderers draw identical grids. */
class DotLayoutParityTest {
    private val vectors = JSONObject(
        File("../../../shared-test-vectors/year_dots/layout_test_vectors.json").readText(),
    )

    @Test
    fun matchesSharedVectors() {
        val cases = vectors.getJSONArray("cases")
        for (i in 0 until cases.length()) {
            val case = cases.getJSONObject(i)
            val name = "${case.getString("layout")} ${case.getInt("year")} " +
                "${case.getDouble("width")}x${case.getDouble("height")}"
            val layout = DotLayout.compute(
                months = case.getString("layout") == "months",
                year = case.getInt("year"),
                width = case.getDouble("width"),
                height = case.getDouble("height"),
            )
            val expected = case.getJSONObject("expected")
            assertEquals(name, expected.getDouble("cellWidth"), layout.cellWidth, TOLERANCE)
            assertEquals(name, expected.getInt("dayCount"), layout.cells.size)
            if (expected.has("columns")) {
                assertEquals(name, expected.getInt("columns"), layout.columns)
                assertEquals(name, expected.getInt("rows"), layout.rows)
            }
            if (expected.has("blockColumns")) {
                assertEquals(name, expected.getInt("blockColumns"), layout.blockColumns)
                assertEquals(name, expected.getInt("blockRows"), layout.blockRows)
            }
            val samples = expected.getJSONObject("samples")
            for (key in samples.keys()) {
                val rect = samples.getJSONArray(key)
                val cell = layout.cells[key.toInt()]
                val label = "$name day $key"
                assertEquals(label, rect.getDouble(0), cell.left, TOLERANCE)
                assertEquals(label, rect.getDouble(1), cell.top, TOLERANCE)
                assertEquals(label, rect.getDouble(2), cell.width, TOLERANCE)
                assertEquals(label, rect.getDouble(3), cell.height, TOLERANCE)
            }
        }
    }

    private companion object {
        // Vectors are rounded to six decimals.
        const val TOLERANCE = 1e-5
    }
}
