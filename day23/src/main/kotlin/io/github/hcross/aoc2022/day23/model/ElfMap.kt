package io.github.hcross.aoc2022.day23.model

class ElfMap {
    private var directions: MutableList<Direction> =
        mutableListOf(Direction.NORTH, Direction.SOUTH, Direction.WEST, Direction.EAST)
    var map: MutableMap<String, Elf> = mutableMapOf()
    private var proposals: MutableMap<String, Pair<MutableList<Elf>,Direction>> = mutableMapOf()

    private fun initProposals() {
        proposals.clear()
    }

    private fun rotateDirections() {
        val direction = directions[0]
        directions.remove(direction)
        directions.add(direction)
    }

    fun moveElfs(): Int {
        var moves = 0
        initProposals()
        for (elf in map.values)
            if (!elf.isAlone())
                for (direction in directions)
                    if (elf.checkDirection(direction)) {
                        val next = getPositionKey(elf.getDestination(direction))
                        if (!proposals.containsKey(next))
                            proposals.put(next, Pair(mutableListOf(elf),direction))
                        else
                            proposals.get(next)?.first?.add(elf)
                        break
                    }
        for (key in proposals.keys)
            if (proposals[key]?.first?.size == 1) {
                proposals[key]?.second?.let { proposals[key]?.first?.get(0)?.move(it) }
                moves++
            }
        rotateDirections()
        return moves
    }

    fun moveElf(oldKey: String, elf: Elf) {
        map.remove(oldKey)
        map[elf.getKey()] = elf
    }

    fun add(x: Int, y: Int) {
        val elf = Elf(x,y,this)
        map.put(elf.getKey(), elf)
    }

    fun get(x: Int, y: Int): Elf? {
        return map.get(getPositionKey(x,y))
    }

    fun getWidth(): Int {
        return map.values.maxOf(Elf::x) - getMinX() + 1
    }

    fun getHeight(): Int {
        return map.values.maxOf(Elf::y) - getMinY() + 1
    }

    fun getMinX(): Int {
        return map.values.minOf(Elf::x)
    }

    fun getMinY(): Int {
        return map.values.minOf(Elf::y)
    }

    fun getEmptyGroundTilesCount(): Int {
        return getWidth() * getHeight() - map.size
    }

    override fun toString(): String {
        var lines = mutableListOf<String>()
        val width = getWidth()
        val height = getHeight()
        val minX = getMinX()
        val minY = getMinY()
        for (j in 1..height)
            lines.add(".".repeat(width))
        for (elf in map.values)
            lines[elf.y - minY] = lines[elf.y - minY].replaceRange(elf.x - minX, elf.x - minX + 1, "#")
        return lines.joinToString("\n")
    }
}

fun createMap(lines: String): ElfMap {
    var map = ElfMap()
    val split = lines.split('\n')
    var x: Int
    for ((y, line) in split.withIndex()) {
        x = 0
        for (c in line) {
            if ('#' == c)
                map.add(x, y)
            x++
        }
    }
    return map
}