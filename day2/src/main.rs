use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::HashMap;
use std::fmt;

#[derive(Debug, Clone, Copy)]
enum RoundResult {
    Win,
    Draw,
    Loss
}

#[derive(Debug, Clone, Copy)]
enum HandMove {
    Rock,
    Paper,
    Scissors
}

impl fmt::Display for HandMove {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
       write!(f, "{:?}", self)
    }
}

impl HandMove {
    fn win(&self, other: &HandMove) -> bool {
        match self {
            HandMove::Rock => {
                match other {
                    HandMove::Scissors => true,
                    _ => false
                }
            },
            HandMove::Paper => {
                match other {
                    HandMove::Rock => true,
                    _ => false
                }
            },
            HandMove::Scissors => {
                match other {
                    HandMove::Paper => true,
                    _ => false
                }
            }
        }
    }

    fn point(&self) -> u32 {
        match self {
            HandMove::Rock => 1,
            HandMove::Paper => 2,
            HandMove::Scissors => 3
        }
    }

    fn points(&self, other: &HandMove) -> u32 {
        self.point() + if self.win(other) { 6 } else { 0 } + if std::mem::discriminant(self) == std::mem::discriminant(other) { 3 } else { 0 }
    }

    fn move_for_end_result(&self, result: &RoundResult) -> &HandMove {
        match result {
            RoundResult::Draw => &self,
            RoundResult::Win => {
                match self {
                    HandMove::Paper => &HandMove::Scissors,
                    HandMove::Rock => &HandMove::Paper,
                    HandMove::Scissors => &HandMove::Rock
                }
            },
            RoundResult::Loss => {
                match self {
                    HandMove::Paper => &HandMove::Rock,
                    HandMove::Rock => &HandMove::Scissors,
                    HandMove::Scissors => &HandMove::Paper
                }
            }
        }
    } 
}

fn main() {
    println!("Advent of code day 2 ! in Rust !");

    let mut move_matches = HashMap::new();
    move_matches.insert('A', HandMove::Rock);
    move_matches.insert('B', HandMove::Paper);
    move_matches.insert('C', HandMove::Scissors);

    let mut round_result_matches = HashMap::new();
    round_result_matches.insert('X', RoundResult::Loss);
    round_result_matches.insert('Y', RoundResult::Draw);
    round_result_matches.insert('Z', RoundResult::Win);

    let mut total = 0;
    if let Ok(lines) = read_lines("./input") {
        for line in lines {
            if let Ok(data) = line {
                let char_vec: Vec<char> = data.chars().collect();
                let ch0 = char_vec[0];
                let ch2 = char_vec[2];
                match move_matches.get(&ch0) {
                    Some(&other_move) => {
                        match round_result_matches.get(&ch2) {
                            Some(&round_result) => {
                                let my_move = &other_move.move_for_end_result(&round_result);
                                total += my_move.points(&other_move);
                            },
                            None => {}
                        }
                    },
                    None => {}
                }
            }
        }
    }

    println!("Total of points {total}");
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}