package io.github.hcross.aoc2022.day23.model

import org.junit.jupiter.api.Test

import org.junit.jupiter.api.Assertions.*

class ElfMapKtTest {

    @Test
    fun puzzle1() {
        val map = io.github.hcross.aoc2022.day23.model.createMap(
            this::class.java.classLoader.getResource("sample.input").readText(Charsets.UTF_8)
        )
        for (i in 1..10) map.moveElfs()
        assertEquals(110, map.getEmptyGroundTilesCount())
    }

    @Test
    fun smallInput() {
        val map = io.github.hcross.aoc2022.day23.model.createMap(
            this::class.java.classLoader.getResource("small.input").readText(Charsets.UTF_8)
        )
        println("== Initial State ==")
        println(map)
        var round = 1
        while (map.moveElfs() != 0) {
            println()
            println("== End of Round ${round} ==")
            println(map)
            round++
        }
        assertEquals(4, round)
    }

    @Test
    fun puzzle2() {
        val map = io.github.hcross.aoc2022.day23.model.createMap(
            this::class.java.classLoader.getResource("sample.input").readText(Charsets.UTF_8)
        )
        println("== Initial State ==")
        println(map)
        var round = 1
        while (map.moveElfs() != 0) {
            println()
            println("== End of Round ${round} ==")
            println(map)
            round++
        }
        assertEquals(20, round)
    }
}