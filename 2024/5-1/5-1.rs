use std::{collections::HashMap, fs};

fn main() {
    let file = fs::read_to_string("/home/yago/w/rust/advent-of-code/2024/5-1/input.txt").expect("");
    let lines: Vec<&str> = file.lines().collect();

    let mut map: HashMap<&str, Vec<&str>> = HashMap::new();
    let mut split_index = 0;

    for (index, line) in lines.iter().enumerate() {
        if *line == "" {
            split_index = index;
            break;
        }

        let mut values = line.split('|');

        let x = values.next().unwrap();
        let y = values.next().unwrap();

        map.entry(x)
            .and_modify(|values| values.push(y))
            .or_insert(vec![y]);
    }

    let mut result = 0;

    let lines: Vec<&str> = lines.iter().skip(split_index + 1).copied().collect();

    'line_for: for line in lines.iter() {
        let line = line.split(',').rev();
        let array: Vec<&str> = line.clone().collect();

        'number_for: for (index, number) in line.enumerate() {
            match map.get(number) {
                None => continue 'number_for,
                Some(number_vec) => {
                    for i in index + 1..array.len() {
                        if number_vec.contains(&array[i]) {
                            continue 'line_for;
                        }
                    }
                }
            }
        }

        let num_index = ((array.len() - 1) / 2) + 1;
        let num: usize = array[num_index - 1].parse().unwrap();

        result += num;
    }

    println!("{}", result);
}
