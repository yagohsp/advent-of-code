use std::{collections::HashMap, fs};

fn print_all(map: &Vec<Vec<char>>) {
    let mut count = 0;
    for row in map.iter() {
        for c in row.iter() {
            if *c == '#' {
                count += 1;
            }
        }
    }
    println!("{}", count);
}

fn get_points(t1: (isize, isize), t2: (isize, isize)) -> ((isize, isize), (isize, isize)) {
    let (t1_x, t1_y) = t1;
    let (t2_x, t2_y) = t2;

    let delta_x = t2_x - t1_x;
    let delta_y = t2_y - t1_y;

    let a = (t1_x - delta_x, t1_y - delta_y);
    let b = (t2_x + delta_x, t2_y + delta_y);

    (a, b)
}

fn in_bounds(point: (isize, isize), max_len: usize) -> bool {
    point.0 >= 0 && point.0 <= max_len as isize && point.1 >= 0 && point.1 <= max_len as isize
}

fn main() {
    let file = fs::read_to_string("08/input.txt").expect("");
    let lines = file.lines();

    let mut map: Vec<Vec<char>> = lines.map(|line| line.chars().collect()).collect();
    let max_len = map.len() - 1;

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

    let mut tested: Vec<((isize, isize), (isize, isize))> = Vec::new();

    for (_, locations) in towers.iter() {
        for a in locations.iter() {
            for b in locations.iter() {
                let t1 = a;
                let t1 = (t1.0 as isize, t1.1 as isize);

                let t2 = b;
                let t2 = (t2.0 as isize, t2.1 as isize);

                if tested.contains(&(t1, t2)) {
                    continue;
                }

                let (a, b) = get_points(t1, t2);

                if in_bounds(a, max_len) && a != t1 && a != t2 {
                    map[a.0 as usize][a.1 as usize] = '#';
                }
                if in_bounds(b, max_len) && b != t1 && b != t2 {
                    map[b.0 as usize][b.1 as usize] = '#';
                }

                tested.push((a, b));
            }
        }
    }

    print_all(&map);
}
