use std::{collections::HashMap, fs};

fn blink(value: String, n: u32, dic: &mut HashMap<(u32, String), usize>) -> usize {
    let mut count = 0;
    if n == 75 {
        return 1;
    }

    match dic.get(&(n, value.clone())) {
        Some(v) => {
            return *v;
        }
        None => {}
    }

    if value == "0" {
        count += blink("1".to_string(), n + 1, dic);
    } else if value.len() % 2 == 0 {
        let (v1, v2) = value.split_at(value.len() / 2);
        let v1: usize = v1.parse().unwrap();
        let v2: usize = v2.parse().unwrap();

        count += blink(v1.to_string(), n + 1, dic);
        count += blink(v2.to_string(), n + 1, dic);
    } else {
        let value: usize = value.parse().unwrap();
        let value = value * 2024;

        count += blink(value.to_string(), n + 1, dic);
    }

    dic.insert((n, value), count);

    return count;
}

fn main() {
    let file = fs::read_to_string("10-2/input.txt").expect("");
    let file = file.trim();

    let values: Vec<String> = file.split(" ").map(|v| v.to_string()).collect();

    let mut count = 0;

    let mut dic: HashMap<(u32, String), usize> = HashMap::new();
    for value in &values {
        count += blink(value.to_string(), 0, &mut dic);
    }

    println!("{}", count);
}
