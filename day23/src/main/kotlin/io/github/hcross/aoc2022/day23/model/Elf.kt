package io.github.hcross.aoc2022.day23.model

import kotlin.math.abs

class Elf(var x: Int, var y: Int, val map: ElfMap) {
    fun getKey(): String {
        return getPositionKey(x, y)
    }

    fun checkDirection(direction: Direction): Boolean {
        val checks = checkDirectionMoves(direction)
        for (j in checks[1]) {
            for (i in checks[0]) {
                if (map.get(x + i, y + j) != null) return false
            }
        }
        return true
    }

    fun isAlone(): Boolean {
        for (j in listOf<Int>(-1, 0, 1)) {
            for (i in listOf<Int>(-1, 0, 1)) {
                if (abs(i) + abs(j) != 0) {
                    if (map.get(x + i, y + j) != null)
                        return false
                }
            }
        }
        return true
    }

    fun getDestination(direction: Direction): Pair<Int, Int> {
        val moves = getMovesDelta(direction)
        return Pair(x + moves[0], y + moves[1])
    }

    fun move(direction: Direction) {
        val moves = getMovesDelta(direction)
        val oldKey = getKey()
        x += moves[0]
        y += moves[1]
        map.moveElf(oldKey, this)
    }
}

fun getPositionKey(p: Pair<Int, Int>): String {
    return getPositionKey(p.first, p.second)
}

fun getPositionKey(x: Int, y: Int): String {
    return "$x,$y"
}

fun getCoordinateFromKey(key: String): Pair<Int, Int> {
    val split = key.split(",")
    return Pair(split[0].toInt(), split[1].toInt())
}