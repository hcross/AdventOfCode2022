module main
import day15 { load_virtual, load_ranged_virtual, get_tuning_frequency }

fn puzzle1() {
	mut cm := load_virtual('./input',2_000_000)
	nb := cm.excluded_beacon_pos(2_000_000)
	println('Puzzle 1: ${nb}')
}

fn puzzle2() {
	mut cm := load_ranged_virtual('./input', 0, 4_000_000)
	bx, by := cm.search_distress_beacon()
	freq := get_tuning_frequency(bx, by)
	println('Puzzle 2: ${freq} (distress beacon at [${bx},${by}])')
}

fn main() {
	println("Day 15 challenge with V language")
	puzzle1()
	puzzle2()
}