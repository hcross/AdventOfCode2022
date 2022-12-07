import java.io.File
import kotlin.math.max
import kotlin.math.min

const val verbose = false

class FSCommand(val command: String) {
    var values: List<String>? = null
    private fun split(): List<String> {
        if (values != null) return values!!
        values = command.split(" ")
        return values!!
    }
    fun isFile(): Boolean = command[0].isDigit()
    fun isFolder(): Boolean = command.startsWith("dir ")
    fun isCdUp(): Boolean = command.startsWith("$ cd ..")
    fun isCdDir(): Boolean = command.startsWith("$ cd ") && command[5] != '.'&& command[5] != '/'
    fun getFile(): FSFile = FSFile(split().get(1), split().get(0).toInt())
    fun getFolder(parent: FSFolder? = null): FSFolder = FSFolder(split().get(1), parent)
    fun getCdFolderName(): String = split().get(2)
}
abstract class FSNode(private val name: String) {
    fun getName(): String = name
    abstract fun getSize(): Int
}

class FSFile(name: String, private val size: Int): FSNode(name) {
    override fun getSize(): Int = size
}

class FSFolder(name: String, val parent: FSFolder? = null): FSNode(name) {
    val content = mutableSetOf<FSNode>()
    override fun getSize(): Int = content.map { it.getSize() }.reduce { sum, f -> sum + f }
    fun getNode(name: String): FSNode? = content.filter { it.getName().equals(name) } .firstOrNull()
    fun add(node: FSNode) = content.add(node)
    fun discover(command: FSCommand): FSFolder {
        var dir = this
        when {
            command.isFile() -> add(command.getFile())
            command.isFolder() -> add(command.getFolder(this))
            command.isCdDir() -> dir = getNode(command.getCdFolderName()) as FSFolder
            command.isCdUp() -> dir = parent!!
        }
        if (verbose && dir != this) println("cd " + dir.toString())
        return dir
    }
    private fun getChildrenFoldersTotalSize(constraint: (i: Int) -> Boolean): Int =
        content.filterIsInstance<FSFolder>()
            .map { it.getSize() }
            .filter(constraint)
            .sum()
    private fun getChildrenFoldersTotalClaimedDirSize(constraint: (i: Int) -> Boolean): Int =
        content.filterIsInstance<FSFolder>()
            .map { it.getTotalClaimedDirsSize(constraint) }
            .sum()
    fun getTotalClaimedDirsSize(constraint: (i: Int) -> Boolean): Int {
        return getChildrenFoldersTotalSize(constraint) + getChildrenFoldersTotalClaimedDirSize(constraint)
    }
    fun _getSmallestDirSizeToFree(needed: Int, smallest: Int): Int =
        content.filterIsInstance<FSFolder>()
            .filter { it.getSize() >= needed }
            .map { it._getSmallestDirSizeToFree(needed, min(smallest, it.getSize())) }
            .fold(smallest) { a, b -> min(a, b) }
    fun getSmallesDirSizeToFree(needed: Int): Int = _getSmallestDirSizeToFree(needed, getSize())
    override fun toString(): String = (parent?.toString() ?: "") + getName() + "/"
}

fun main() {
    println("Avent of Code - 7th day with Kotlin!")
    var root = FSFolder("")
    var curDir = root
    File("./input").forEachLine() { curDir = curDir.discover(FSCommand(it)) }
    println("Total dir size: " + root.getSize())
    println("Puzzle 1: " + root.getTotalClaimedDirsSize { i: Int -> i <= 100000 })
    println("Puzzle 2: " + root.getSmallesDirSizeToFree(30000000 - (70000000 - root.getSize())))
}