import scala.io.Source
import scala.collection.immutable.Range
import scala.collection.immutable.List

val verbose = false

@main def hello: Unit = 
  println("Hello Advent of Code ! Day 4 Challenge in Scala !")
  
  firstPuzzle
  secondPuzzle

def firstPuzzle: Unit =
  println("First puzzle: there are " + runPuzzle(oneFullyIncluded) + " assignment pairs where one pair is fully contained in the other")

def secondPuzzle: Unit =
  println("Second puzzle: there are " + runPuzzle(overlap) + " assignment pairs where there are overlapping")

def runPuzzle(condition: (Set[Int], Set[Int]) => Boolean): Int =
  val bufferedSource = Source.fromFile("./input")
  var accumulator = 0
  var lineIndex = 1;
  for (line <- bufferedSource.getLines) {
    if verbose then println("==== [" + lineIndex + "] ========================================")
    val pairs = line.split(",")
    val range1Array = pairs(0).split("-")
    val range2Array = pairs(1).split("-")
    val range1 = Range(range1Array(0).toInt, range1Array(1).toInt + 1).toList.toSet
    val range2 = Range(range2Array(0).toInt, range2Array(1).toInt + 1).toList.toSet
    if condition.apply(range1, range2) then
      if verbose then println("Condition matched !")
      accumulator += 1
    lineIndex += 1
  }
  return accumulator

def oneFullyIncluded(first: Set[Int], second: Set[Int]): Boolean =
  if verbose then printSeq(first)
  if verbose then printSeq(second)
  val intersection = first.intersect(second)
  if verbose then printSeq(intersection)
  return !intersection.isEmpty && (intersection.equals(first) || intersection.equals(second))

def overlap(first: Set[Int], second: Set[Int]): Boolean =
  return !first.intersect(second).isEmpty

def printSeq(sequence: Iterable[Int]): Unit =
  println(sequence.toList.sorted.mkString("[", ",", "]"))