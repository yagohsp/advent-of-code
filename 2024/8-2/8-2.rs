use std::{collections::HashMap, fs};

fn print_all(map: &Vec<Vec<char>>) {
    let mut count = 0;
    for row in map.iter() {
        for c in row.iter() {
            print!("{}", c);
            if *c != '.' {
                count += 1;
            }
        }
        println!("");
    }
    println!("{}", count);
}

fn set_points(t1: (isize, isize), t2: (isize, isize), map: &mut Vec<Vec<char>>) {
    let (t1_x, t1_y) = t1;
    let (t2_x, t2_y) = t2;

    let delta_x = t2_x - t1_x;
    let delta_y = t2_y - t1_y;

    let mut point = (t1_x + delta_x, t1_y + delta_y);

    if in_bounds(point, map.len() - 1) && point != t1 && point != t2 {
        map[point.0 as usize][point.1 as usize] = '#';
    }

    loop {
        point = (point.0 + delta_x, point.1 + delta_y);
        if in_bounds(point, map.len() - 1) && point != t1 && point != t2 {
            map[point.0 as usize][point.1 as usize] = '#';
        } else {
            break;
        }
    }
}

fn in_bounds(point: (isize, isize), max_len: usize) -> bool {
    point.0 >= 0 && point.0 <= max_len as isize && point.1 >= 0 && point.1 <= max_len as isize
}

fn main() {
    let file = fs::read_to_string("8-2/input-meu.txt").expect("");
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

    for (_, locations) in towers.iter() {
        for a in locations.iter() {
            for b in locations.iter() {
                let t1 = a;
                let t1 = (t1.0 as isize, t1.1 as isize);

                let t2 = b;
                let t2 = (t2.0 as isize, t2.1 as isize);

                println!("{:?} {:?}", t1, t2);
                set_points(t1, t2, &mut map);
            }
        }
    }

    print_all(&map);
}
