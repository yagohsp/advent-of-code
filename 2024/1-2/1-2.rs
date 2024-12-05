use std::{collections::HashMap, fs};


fn main() {
    let file = fs::read_to_string("/home/yago/w/rust/advent_of_code/2024/1-1/input.txt").expect("");
    let lines = file.lines();

    let mut map: HashMap<u32, [u32; 2]> = HashMap::new();

    for line in lines {
        let line_values: Vec<_> = line.split("   ").collect();

        let val1: u32 = line_values[0].parse().expect("");
        let val2: u32 = line_values[1].parse().expect("");

        map.entry(val1)
            .and_modify(|values| values[0] += 1)
            .or_insert([1, 0]);

        map.entry(val2)
            .and_modify(|values| values[1] += 1)
            .or_insert([0, 1]);
    }

    let mut result = 0;

    for (value, counts) in map {
       result += value * counts[0] * counts[1];
    }

    println!("{}", result);
}
