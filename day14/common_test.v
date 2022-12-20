module day14

fn test_detect() {
	min_x, max_x, min_y, max_y := detect('./input.sample',false)
	assert min_x == 494
	assert max_x == 503
	assert min_y == 0
	assert max_y == 9
}

fn test_init_cave_map() {
	cm := init_cave_map(3,8,8,12,false)
	assert cm.start_x == 3
	assert cm.start_y == 8
	assert '......\n......\n......\n......\n......\n' == cm.to_string()
}

fn test_init_cave_map_extended() {
	cm := init_cave_map(3,8,8,12,true)
	assert cm.start_x == 3
	assert cm.start_y == 8
	assert '......\n......\n......\n......\n######\n' == cm.to_string()
}

fn test_load() {
	cm := load('./input.sample',false)
	assert '......+...\n..........\n..........\n..........\n....#...##\n....#...#.\n..###...#.\n........#.\n........#.\n#########.\n' == cm.to_string()
}

fn test_load_extended() {
	cm := load('./input.sample',true)
	assert '............+............\n.........................\n.........................\n.........................\n..........#...##.........\n..........#...#..........\n........###...#..........\n..............#..........\n..............#..........\n......#########..........\n.........................\n#########################\n' == cm.to_string()
}

fn test_spawn_sand() {
	mut cm := load('./input.sample',false)
	assert cm.spawn_sand() == false
	assert '......+...\n..........\n..........\n..........\n....#...##\n....#...#.\n..###...#.\n........#.\n......o.#.\n#########.\n' == cm.to_string()
	assert cm.spawn_sand() == false
	assert '......+...\n..........\n..........\n..........\n....#...##\n....#...#.\n..###...#.\n........#.\n.....oo.#.\n#########.\n' == cm.to_string()
	for i in 0..3 {
		assert cm.spawn_sand() == false
	}
	assert '......+...\n..........\n..........\n..........\n....#...##\n....#...#.\n..###...#.\n......o.#.\n....oooo#.\n#########.\n' == cm.to_string()
	for i in 0..17 {
		assert cm.spawn_sand() == false
	}
	assert '......+...\n..........\n......o...\n.....ooo..\n....#ooo##\n....#ooo#.\n..###ooo#.\n....oooo#.\n...ooooo#.\n#########.\n' == cm.to_string()
	assert cm.spawn_sand() == false
	assert cm.spawn_sand() == false
	assert cm.spawn_sand() == true
	assert cm.landed_sand == 24
}

fn test_spawn_sand_extended() {
	mut cm := load('./input.sample',true)
	for !cm.spawn_sand() {}
	assert '............o............\n...........ooo...........\n..........ooooo..........\n.........ooooooo.........\n........oo#ooo##o........\n.......ooo#ooo#ooo.......\n......oo###ooo#oooo......\n.....oooo.oooo#ooooo.....\n....oooooooooo#oooooo....\n...ooo#########ooooooo...\n..ooooo.......ooooooooo..\n#########################\n' == cm.to_string()
	assert cm.landed_sand == 93
}