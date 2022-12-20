module main
import day14 { load }

fn puzzle1() {
	mut cm := load("./input", false)
	for !cm.spawn_sand() {}
	println('Puzzle 1: ${cm.landed_sand}')
}

fn puzzle2() {
	mut cm := load("./input", true)
	for !cm.spawn_sand() {}
	println('Puzzle 2: ${cm.landed_sand}')
}

fn main() {
	println("Day 14 challenge with V language")
	puzzle1()
	puzzle2()
}