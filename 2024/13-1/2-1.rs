use std::fs;

fn main() {
    let file = fs::read_to_string("/home/yago/w/rust/advent_of_code/2024/1-1/input.txt").expect("");
    let lines = file.lines();

    for line in lines {
        let line_values: Vec<_> = line.split("   ").collect();
    }
}
