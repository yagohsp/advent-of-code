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

fn get_collinears(p1: (usize, usize), p2: (usize, usize)) -> ((usize, usize), (usize, usize)) {
    let mut p0 = (999, 999);
    let mut p3 = (999, 999);

    let delta = (p2.0.abs_diff(p1.0), p2.1.abs_diff(p1.1));
    (p0, p3)
}

fn set_antenna(map: &mut Vec<Vec<char>>, antenna: (usize, usize)) {
    if antenna.0 < map[0].len() && antenna.1 < map[0].len() && map[antenna.0][antenna.1] == '.' {
        map[antenna.0][antenna.1] = '#';
    }
}

fn main() {
    let file = fs::read_to_string("8-1/input-4.txt").expect("");
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

    for (_, towers_char) in towers.iter() {
        for current_tower in towers_char.iter() {
            for target_tower in towers_char.iter() {
                if target_tower == current_tower {
                    continue;
                }
                let (p0, p3) = get_collinears(*current_tower, *target_tower);

                set_antenna(&mut map, p0);
                set_antenna(&mut map, p3);
            }
        }
    }

    print_all(&map);
}
