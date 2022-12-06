import os

const verbose = false

fn is_signal(data string) bool {
	for i in 0..data.len {
		for j in 0..data.len {
			if j != i && data[i] == data[j] {
				return false
			}
		}
	}
	return true
}

fn detect(nb int) ?int {
	data := os.read_file("./input")?
	mut data_lenth := 0
	for i in nb..data.len {
		slice := data[i-nb..i]
		if verbose { println("${i}:${slice}") }
		if is_signal(slice) {
			data_lenth = i
			break
		}
	}
	return data_lenth
}

fn main() {
	println("Day 6 challenge with V language")
	mut data_lenth := detect(4)?
	println("puzzle 1: ${data_lenth}")
	data_lenth = detect(14)?
	println("puzzle 2: ${data_lenth}")
}