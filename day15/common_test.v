module day15

fn test_init_cave_map() {
	cm := init_cave_map(3,8,8,12)
	assert cm.start_x == 3
	assert cm.start_y == 8
	assert '......\n......\n......\n......\n......\n' == cm.to_string()
}

fn test_load() {
	mut cm := load('./input.sample')
	assert cm.excluded_beacon_pos(10) == 26
}

fn test_load_virtual() {
	mut cm := load_virtual('./input.sample', 10)
	assert cm.excluded_beacon_pos(10) == 26
}

fn test_load_ranged() {
	mut cm := load_ranged_virtual('./input.sample', 0, 20)
	bx, by := cm.search_distress_beacon()
	assert bx == 14
	assert by == 11
	assert get_tuning_frequency(bx, by) == "56000011"
}