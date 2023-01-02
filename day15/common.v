module day15

import os
import math { min, max, abs }
import regex
import strconv { parse_int }
import datatypes

const input_regexp_query = r'^Sensor at x=(\-?\d+), y=(\-?\d+): closest beacon is at x=(\-?\d+), y=(\-?\d+)$'
const dot = '.'[0]
const sensor = 'S'[0]
const sharp = '#'[0]
const beacon = 'B'[0]
const verbose = false

struct SensorBeaconPair {
	sx int
	sy int
	bx int
	by int
	dist int
}

/**
 * CaveMap code
 */

pub fn load(filename string) CaveMap {
	min_x, max_x, min_y, max_y := detect(filename)
	mut cm := init_cave_map(min_x, max_x, min_y, max_y)

	data := os.read_file(filename) or { panic('File not found !') }
    mut lines := data.split('\n')
	for i in 0..lines.len {
		sx, sy, bx, by := get_input_line_coordinates(lines[i])
		cm.set(sx,sy,sensor)
		cm.set(bx,by,beacon)
		cm.diamond(sx,sy,manhattan_distance(sx,sy,bx,by))
	}

	return cm
}

fn init_cave_map(min_x int, max_x int, min_y int, max_y int) CaveMap {
	mut cm := CaveMap {
		start_x: min_x
		start_y: min_y
		width: max_x - min_x + 1
		height: max_y - min_y + 1
	}
	cm.init_array()
	return cm
}

struct CaveMap {
	start_x int
	start_y int
	width int
	height int
mut:
	m [][]u8
}

fn (mut cm CaveMap) init_array() {
	cm.m = [][]u8 { len: int(cm.height), init: []u8 { len: int(cm.width) } }
	for mut line in cm.m {
		for mut c in line {
			c = dot
		}
	}
}

pub fn (cm CaveMap) crop(min_x int, max_x int, min_y int, max_y int) CaveMap {
	mut cropped := CaveMap {
		start_x: min_x
		start_y: min_y
		width: max_x - min_x + 1
		height: max_y - min_y + 1
	}
	cropped.init_array()

	mut i := 0
	start_y := min_y - cm.start_y
	start_x := min_x - cm.start_x
	for j in start_y..start_y + cropped.height {
		cropped.m[i] = cm.m[j].clone()
		cropped.m[i].delete_many(0, start_x)
		cropped.m[i].trim(cropped.width)
		i++
	}

	return cropped
}

fn (cm CaveMap) is_x_in_range(x int) bool {
	return x >= cm.start_x && x < cm.start_x + cm.width
}

fn (cm CaveMap) is_y_in_range(y int) bool {
	return y >= cm.start_y && y < cm.start_y + cm.height
}

fn (cm CaveMap) check_range(x int, y int) {
	if !cm.is_x_in_range(x) { panic('x=${x} is out of range') }
	if !cm.is_y_in_range(y) { panic('y=${y} is out of range') }
}

fn (cm CaveMap) get(x int, y int) u8 {
	cm.check_range(x,y)
	return cm.m[y-cm.start_y][x-cm.start_x]
}

fn (mut cm CaveMap) set(x int, y int, c u8) {
	cm.check_range(x,y)
	cm.m[y-cm.start_y][x-cm.start_x] = c
}

fn (mut cm VirtualCaveMap) set(x int, y int, c u8) {
	if cm.is_x_in_range(x) && cm.is_y_in_range(y) {
		cm.m[y-cm.start_y][x-cm.start_x] = c
	}
}

fn (mut cm CaveMap) diamond(x int, y int, dist int) {
	for j in y-dist..y+dist+1 {
		for i in x-dist..x+dist+1 {
			if cm.get(i,j) == dot && manhattan_distance(x,y,i,j) <= dist {
				cm.set(i,j,sharp)
			}
		}
	}
}

pub fn (cm CaveMap) excluded_beacon_pos(y int) int {
	if !cm.is_y_in_range(y) { return 0 }
	mut nb := 0
	for c in cm.m[y-cm.start_y] {
		if c == sharp { nb++ }
	}
	return nb
}

pub fn (cm CaveMap) to_string() string {
	mut str := ''
	for line in cm.m {
		str = str + line.bytestr() + '\n'
	}
	return str
}

/**
 * VirtualCaveMap code
 */

pub fn load_virtual(filename string, y int) VirtualCaveMap {
	min_x, max_x, _, _ := detect(filename)
	mut cm := init_virtual_cave_map(min_x, max_x, y)

	data := os.read_file(filename) or { panic('File not found !') }
	mut lines := data.split('\n')
	for i in 0..lines.len {
		sx, sy, bx, by := get_input_line_coordinates(lines[i])
		cm.set(sx,sy,sensor)
		cm.set(bx,by,beacon)
		cm.diamond(sx,sy,manhattan_distance(sx,sy,bx,by))
	}

	return cm
}

fn init_virtual_cave_map(min_x int, max_x int, y int) VirtualCaveMap {
	mut vcm := VirtualCaveMap {
		start_x: min_x
		start_y: y
		width: max_x - min_x + 1
		height: 1
	}
	vcm.init_array()
	return vcm
}

struct VirtualCaveMap {
	CaveMap
}

fn (mut cm VirtualCaveMap) diamond(x int, y int, dist int) {
	j := cm.start_y
	if j >= y-dist && j < y+dist {
		for i in x-dist..x+dist+1 {
			if cm.get(i,j) == dot && manhattan_distance(x,y,i,j) <= dist {
				cm.set(i,j,sharp)
			}
		}
	}
}

/**
 * RangedVirtualCaveMap code
 */

pub fn load_ranged_virtual(filename string, min_value int, max_value int) RangedVirtualCaveMap {
	mut cm := init_ranged_virtual_cave_map(min_value, max_value, min_value, max_value)

	data := os.read_file(filename) or { panic('File not found !') }
	mut lines := data.split('\n')
	for i in 0..lines.len {
		sx, sy, bx, by := get_input_line_coordinates(lines[i])
		cm.pairs << SensorBeaconPair {
			sx: sx
			sy: sy
			bx: bx
			by: by
			dist: manhattan_distance(sx,sy,bx,by)
		}
	}

	return cm
}

fn init_ranged_virtual_cave_map(min_x int, max_x int, min_y int, max_y int) RangedVirtualCaveMap {
	mut cm := RangedVirtualCaveMap {
		start_x: min_x
		start_y: min_y
		max_x: max_x
		max_y: max_y
		width: max_x - min_x + 1
		height: max_y - min_y + 1
		cur_y: min_y
	}
	cm.init_line()
	cm.pairs = []SensorBeaconPair {}
	return cm
}

struct RangedVirtualCaveMap {
	CaveMap
	max_x int
	max_y int
mut:
	cur_y int
	line [][]int
	pairs []SensorBeaconPair
}

fn (mut cm RangedVirtualCaveMap) init_line() {
	cm.line = [][]int {}
}

fn (mut cm RangedVirtualCaveMap) add_point(x int) {
	cm.add_range(x, x)
}

fn (mut cm RangedVirtualCaveMap) add_range(x1 int, x2 int) {
	if x2 >= cm.start_x && x1 <= cm.max_x {
		cm.line << [max(x1, cm.start_x), min(x2, cm.max_x)]
		cm.merge_ranges()
	}
}

fn (mut cm RangedVirtualCaveMap) merge_ranges() {
	if cm.line.len > 1 {
		cm.line.sort_with_compare(fn (mut range1 []int, mut range2 []int) int {
			return range1[0] - range2[0]
		})

		mut stack := datatypes.Stack[[]int]{}

		stack.push(cm.line[0])

		for range in cm.line {
			mut top := stack.peek() or { panic('No element in stack') }
			if top[1] < range[0] {
				if top[1]+1 == range[0] {
					top[1] = range[1]
					stack.pop() or { panic('No element in stack') }
					stack.push(top)
				} else {
					stack.push(range)
				}
			} else if top[1] < range[1] {
				top[1] = range[1]
				stack.pop() or { panic('No element in stack') }
				stack.push(top)
			}
		}

		cm.line = stack.array()
	}
}

fn (mut cm RangedVirtualCaveMap) range_sensors_and_beacons() {
	for pair in cm.pairs {
		if pair.sy == cm.cur_y {
			cm.add_point(pair.sx)
		}
		if pair.by == cm.cur_y {
			cm.add_point(pair.bx)
		}
	}
}

fn (mut cm RangedVirtualCaveMap) range_sb_distance() {
	for pair in cm.pairs {
		if cm.cur_y >= pair.sy-pair.dist && cm.cur_y <= pair.sy+pair.dist {
			sdist := pair.dist - abs(cm.cur_y-pair.sy)
			cm.add_range(pair.sx-sdist, pair.sx+sdist)
		}
	}
}

fn (cm RangedVirtualCaveMap) is_distress_beacon_here() bool {
	if cm.line.len == 2 {
		if cm.width - (cm.line[0][1]-cm.line[0][0] + cm.line[1][1]-cm.line[1][0] + 2) == 1 {
			return true
		}
	} else if cm.line.len == 1 {
		if cm.line[0][0] == cm.start_x+1 || cm.line[0][1] == cm.max_x-1 {
			return true
		}
	}
	return false
}

fn (cm RangedVirtualCaveMap) get_distress_beacon() (int,int) {
	mut x := 0
	if cm.line.len == 2 {
		x = cm.line[0][1]+1
	} else if cm.line.len == 1 {
		if cm.line[0][0] == cm.start_x+1 {
			x = cm.start_x
		} else if cm.line[0][1] == cm.max_x-1 {
			x = cm.max_x
		}
	}
	return x, cm.cur_y
}

pub fn (mut cm RangedVirtualCaveMap) search_distress_beacon() (int,int) {
	for y in cm.start_y..cm.max_y+1 {
		cm.cur_y = y
		cm.init_line()
		cm.range_sensors_and_beacons()
		cm.range_sb_distance()
		if cm.is_distress_beacon_here() {
			return cm.get_distress_beacon()
		}
	}
	panic('No distress beacon found !')
}

/**
 * Utility functions
 */

// parse the given line for the coordinates of the sensor and
// the beacon
fn get_input_line_coordinates(line string) (int,int,int,int) {
	mut re := regex.regex_opt(input_regexp_query) or { panic(err) }
	re.match_string(line)
	if re.groups.len != 8 { panic('Error during parsing line \'${line}\'')}
	sx := int(parse_int(line[re.groups[0]..re.groups[1]],0,64) or { panic(err) })
	sy := int(parse_int(line[re.groups[2]..re.groups[3]],0,64) or { panic(err) })
	bx := int(parse_int(line[re.groups[4]..re.groups[5]],0,64) or { panic(err) })
	by := int(parse_int(line[re.groups[6]..re.groups[7]],0,64) or { panic(err) })
	return sx,sy,bx,by
}

// returns the manhattan distance between two points
fn manhattan_distance(from_x int, from_y int, to_x int, to_y int) int {
	return abs(to_x - from_x) + abs(to_y - from_y)
}

pub fn get_tuning_frequency(x int, y int) string {
	oy := int(y/1_000_000)
	return '${4*x+oy}${int(y-oy*1_000_000):06}'
}

// detect the limits of the coordinates of the beacon and sensors red in the
// file which filename is given
fn detect(filename string) (int,int,int,int) {
    mut min_x := int(math.max_i64)
    mut min_y := int(math.max_i64)
    mut max_x := int(math.min_i64)
    mut max_y := int(math.min_i64)

	data := os.read_file(filename) or { panic('File not found !') }
    mut lines := data.split('\n')
	for i in 0..lines.len {
		sx, sy, bx, by := get_input_line_coordinates(lines[i])
		dist := manhattan_distance(sx,sy,bx,by)
		max_x = max(max_x,max(bx,sx+dist))
		max_y = max(max_y,max(by,sy+dist))
		min_x = min(min_x,min(bx,sx-dist))
		min_y = min(min_y,min(by,sy-dist))
	}
	return min_x, max_x, min_y, max_y
}