package io.github.hcross.aoc2022.day23

import io.github.hcross.aoc2022.day23.model.ElfMap
import io.github.hcross.aoc2022.day23.model.createMap

fun main(args: Array<String>) {
    println("Day 23 with Kotlin")
    var map = createMap(ElfMap::class.java.classLoader.getResource("input").readText(Charsets.UTF_8))
    for (i in 1..10) map.moveElfs()
    println("Puzzle 1: ${map.getEmptyGroundTilesCount()}")

    map  = createMap(ElfMap::class.java.classLoader.getResource("input").readText(Charsets.UTF_8))
    var round = 1
    while (map.moveElfs() != 0) round++
    println("Puzzle 2: ${round}")
}