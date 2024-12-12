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

////distancia entre dois pontos
//fn get_distance(a: (usize, usize), b: (usize, usize)) -> f64 {
//    let x = ((b.0.abs_diff(a.0)).pow(2) + (b.1.abs_diff(a.1)).pow(2)) as f64;
//    x.sqrt()
//}

//fn is_collinear(a: (usize, usize), b: (usize, usize), c: (usize, usize)) -> bool {
//    let a = (a.1.abs_diff(b.1)) / (a.0.abs_diff(b.0));
//    let b = (c.1.abs_diff(b.1)) / (c.0.abs_diff(b.0));

//    a == b
//}

fn get_next_collinear(p1: (usize, usize), p2: (usize, usize)) -> (usize, usize) {
    let p1_x = p1.0;
    let p1_y = p1.1;
    let p2_x = p2.0;
    let p2_y = p2.1;

    let x = p1_x + 2 * p1_x.abs_diff(p2_x);
    let y = p1_y + 2 * p1_y.abs_diff(p2_y);

    (x, y)
}

fn get_previous_collinear(p1: (usize, usize), p2: (usize, usize)) -> Option<(usize, usize)> {
    let p1_x = p1.0 as f64;
    let p1_y = p1.1 as f64;
    let p2_x = p2.0 as f64;
    let p2_y = p2.1 as f64;

    let x = p1_x + (p1_x - p2_x);
    let y = p1_y + (p1_y - p2_y);

    if x < 0.0 || y < 0.0 {
        return None;
    }

    return Some((x as usize, y as usize));
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

    for (_, locations) in towers.iter() {
        for index in 0..locations.len() - 1 {
            let next = get_next_collinear(locations[index], locations[index + 1]);
            map[next.0][next.1] = '#';

            match get_previous_collinear(locations[index], next){
                Some(previous) => {
            map[previous.0][previous.1] = '#';

                }, 
                None => {}
            }
        }
    }

    print_all(&map);
}
