use std::{collections::HashMap, fs};

fn print_all(map: &Vec<Vec<char>>) {
    for row in map.iter() {
        for c in row.iter() {
            print!("{}", c);
        }
        println!("");
    }
    println!("");
}

fn is_collinear(a: (usize, usize), b: (usize, usize), c: (usize, usize)) -> bool {
    (b.1 - a.1) / (b.0 - a.1) == (c.1 - b.1) / (c.0 - b.0)
}

fn main() {
    let file = fs::read_to_string("8-1/input.txt").expect("");
    let lines = file.lines();

    let mut map: Vec<Vec<char>> = lines.map(|line| line.chars().collect()).collect();

    let mut towers: HashMap<char, Vec<(usize, usize)>> = HashMap::new();

    for (row_index, row) in map.iter().enumerate() {
        for (char_index, char) in row.iter().enumerate() {
            if *char != '.' {
                towers
                    .entry(*char)
                    .and_modify(|tower| tower.push((row_index, char_index)))
                    .or_insert(vec![(row_index, char_index)]);
            }
        }
    }

    println!("{:?}", towers);

    let v1 = map.get('a').unwrap()[0];

    println!("{}", is_collinear(map.get("a")[1], (1, 3)));

    print_all(&map);
}
