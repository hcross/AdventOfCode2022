module day14

import os
import math { min, max }
import arrays { fold }

const arrow = ' -> '
const dot = '.'[0]
const plus = '+'[0]
const sharp = '#'[0]
const sand = 'o'[0]
const sand_flow = '~'[0]
const verbose = false

struct CaveMap {
	start_x u16
	start_y u16
	width u16
	height u16
	extended bool
mut:
	m [][]u8
pub mut:
	landed_sand int
}

fn init_cave_map(min_x u16, max_x u16, min_y u16, max_y u16, extended bool) CaveMap {
	mut cm := CaveMap {
		start_x: min_x
		start_y: min_y
		width: max_x - min_x + 1
		height: max_y - min_y + 1
		extended: extended
	}
	cm.landed_sand = 0
	cm.m = [][]u8 { len: int(cm.height), init: []u8 { len: int(cm.width) } }
	for i, mut line in cm.m {
		for mut c in line {
			if extended && i == cm.height - 1 {
				c = sharp
			} else {
				c = dot
			}
		}
	}
	return cm
}

pub fn (cm CaveMap) to_string() string {
	mut str := ''
	for line in cm.m {
		str = str + line.bytestr() + '\n'
	}
	return str
}

fn (cm CaveMap) is_x_in_range(x u16) bool {
	return x >= cm.start_x && x < cm.start_x + cm.width
}

fn (cm CaveMap) is_y_in_range(y u16) bool {
	return y >= cm.start_y && y < cm.start_y + cm.height
}

fn (cm CaveMap) check_range(x u16, y u16) {
	if !cm.is_x_in_range(x) { panic('x=${x} is out of range') }
	if !cm.is_y_in_range(y) { panic('y=${y} is out of range') }
}

fn (cm CaveMap) get(x u16, y u16) u8 {
	cm.check_range(x,y)
	return cm.m[y-cm.start_y][x-cm.start_x]
}

fn (mut cm CaveMap) set(x u16, y u16, c u8) {
	cm.check_range(x,y)
	cm.m[y-cm.start_y][x-cm.start_x] = c
}

fn is_blocking(c u8) bool {
	return c == sand || c == sharp
}

pub fn (mut cm CaveMap) spawn_sand() bool {
	mut landed := false
	mut x := u16(500)
	mut y := u16(0)
	if cm.get(x,y) == sand { return true }
	for !landed {
		if !cm.is_y_in_range(y+1) { return true }
		down_under := cm.get(x,y+1)
		if is_blocking(down_under) {
			if !cm.is_x_in_range(x-1) { return true }
			down_left := cm.get(x-1,y+1)
			if is_blocking(down_left) {
				if !cm.is_x_in_range(x+1) { return true }
				down_right := cm.get(x+1,y+1)
				if is_blocking(down_right) {
					cm.set(x,y,sand)
					cm.landed_sand++
					landed = true
				} else {
					x++
				}
			} else {
				x--
			}
		} else {
			y++
		}
	}
	return false
}

fn detect(filename string, extended bool) (u16,u16,u16,u16) {
    mut min_x := u16(math.max_u16)
    mut min_y := u16(math.max_u16)
    mut max_x := u16(0)
    mut max_y := u16(0)

	data := os.read_file(filename) or { panic('File not found !') }
    mut lines := data.split('\n')
	lines.insert(0, '500,0')
	for i in 0..lines.len {
		values := lines[i].split(arrow)
		for j in 0..values.len {
			value_pair := values[j].split(',')
			x := value_pair[0].parse_int(10,0) or { panic('Error parsing int') }
			y := value_pair[1].parse_int(10,0) or { panic('Error parsing int') }
			max_x = u16(max(max_x,u16(x)))
			max_y = u16(max(max_y,u16(y)))
			min_x = u16(min(min_x,u16(x)))
			min_y = u16(min(min_y,u16(y)))
		}
	}
	if extended {
		max_y += 2
		min_x = 500 - max_y - 1
		max_x = 500 + max_y + 1
	}
	return min_x, max_x, min_y, max_y
}

pub fn load(filename string, extended bool) CaveMap {
	min_x, max_x, min_y, max_y := detect(filename, extended)
	mut cm := init_cave_map(min_x, max_x, min_y, max_y, extended)
	cm.set(500,0,plus)

	data := os.read_file(filename) or { panic('File not found !') }
    mut lines := data.split('\n')
	for i in 0..lines.len {
		mut first := true
		mut xp := u16(0)
		mut yp := u16(0)
		values := lines[i].split(arrow)
		for j in 0..values.len {
			value_pair := values[j].split(',')
			x := u16(value_pair[0].parse_int(10,0) or { panic('Error parsing int') })
			y := u16(value_pair[1].parse_int(10,0) or { panic('Error parsing int') })
			if first {
				first = false 
			} else {
				if verbose { println('x:${xp}->${x};y:${yp}->${y}') }
				if x == xp {
					for k in min(y,yp)..max(y,yp)+1 {
						if verbose { println('cm.set(${x},${k},#)') }
						cm.set(x,k,sharp)
					}
				}
				if y == yp {
					for k in min(x,xp)..max(x,xp)+1 {
						if verbose { println('cm.set(${k},${y},#)') }
						cm.set(k,y,sharp)
					}
				}
			}
			xp = x
			yp = y
		}
	}

	return cm
}