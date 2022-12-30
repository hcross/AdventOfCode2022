package io.github.hcross.aoc2022.day23.model

val PLUS_ONE = arrayOf(1,1,1)
val MINUS_ONE = arrayOf(-1,-1,-1)
val ALL = arrayOf(-1,0,1)

enum class Direction {
    NORTH, SOUTH, WEST, EAST
}

fun checkDirectionMoves(direction: Direction): Array<Array<Int>> {
    return when (direction) {
        Direction.NORTH -> arrayOf(ALL, MINUS_ONE)
        Direction.SOUTH -> arrayOf(ALL, PLUS_ONE)
        Direction.WEST -> arrayOf(MINUS_ONE, ALL)
        Direction.EAST -> arrayOf(PLUS_ONE, ALL)
    }
}

fun getMovesDelta(direction: Direction): Array<Int> {
    return when (direction) {
        Direction.NORTH -> arrayOf(0, -1)
        Direction.SOUTH -> arrayOf(0, 1)
        Direction.WEST -> arrayOf(-1, 0)
        Direction.EAST -> arrayOf(1, 0)
    }
}