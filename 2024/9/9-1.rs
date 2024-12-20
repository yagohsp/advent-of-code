
use std::{collections::HashSet, fs};

const OFFSETS: [(isize, isize); 4] = [(-1, 0), (0, -1), (0, 1), (1, 0)];

fn look_around(
    map: &Vec<Vec<char>>,
    location: &(usize, usize),
    target: char,
) -> Vec<(usize, usize)> {
    let (x, y) = location;
    let mut founds: Vec<(usize, usize)> = Vec::new();

    for (offset_x, offset_y) in &OFFSETS {
        let target_x = *x as isize + offset_x;
        let target_y = *y as isize + offset_y;

        if target_x < 0 && target_y < 0 {
            continue;
        }

        let target_x = target_x as usize;
        let target_y = target_y as usize;

        if target_x < map.len() && target_y < map.len() && map[target_x][target_y] == target {
            founds.push((target_x, target_y));
        }
    }

    founds
}

fn remove_duplicates<T: std::hash::Hash + Eq + Clone>(vec: Vec<T>) -> Vec<T> {
    let set: HashSet<T> = vec.into_iter().collect();
    set.into_iter().collect()
}

fn count_paths(
    map: &Vec<Vec<char>>,
    location: &(usize, usize),
    target: char,
) -> Vec<(usize, usize)> {
    let nexts = look_around(map, location, target);

    if target == '9' {
        return nexts;
    }

    let next_target: u32 = target.to_digit(10).unwrap() + 1;
    let next_target = (next_target as u8 + b'0') as char;

    let mut finals: Vec<(usize, usize)> = Vec::new();
    for next in nexts {
        let founds = count_paths(map, &next, next_target);
        for found in founds {
            finals.push(found);
        }
    }

    finals
}

fn main() {
    let file = fs::read_to_string("9-1/input.txt").expect("");
    let lines = file.lines();

    let mut map: Vec<Vec<char>> = Vec::new();

    for line in lines {
        map.push(line.chars().collect());
    }

    let mut trails: Vec<(usize, usize)> = Vec::new();

    for (x, line) in map.iter().enumerate() {
        for (y, char) in line.iter().enumerate() {
            if *char == '0' {
                trails.push((x, y))
            }
        }
    }

    let mut count = 0;
    for trail in trails {
        // println!("trail - {:?}", trail);
        let paths = count_paths(&map, &trail, '1');
        let uniques = remove_duplicates(paths);
        count += uniques.len();
        // println!("count: {:?}", uniques);
        // println!("");
    }
    println!("{}", count);
}
