use std::{collections::HashMap, fs};

fn main() {
    let file = fs::read_to_string("/home/yago/w/rust/advent-of-code/2024/5-1/input.txt").expect("");
    let lines = file.lines();

    let map: HashMap<&str, Vec<&str>> = HashMap::new();

    for line in lines {
        for num in line.split('|') {
            map.0 = Vec::new();
        }
        if line == "" {
            break;
        }
    }
}
