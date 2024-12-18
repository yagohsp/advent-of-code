use std::fs;

fn blink(value: &str) -> Vec<String> {
    if value == "0" {
        return vec!["1".to_string()];
    }
    if value.len() % 2 == 0 {
        let (v1, v2) = value.split_at(value.len() / 2);
        return vec![v1.to_string(), v2.to_string()];
    }

    let value: usize = value.parse().unwrap();
    let value = value * 2024;

    return vec![value.to_string()];
}

fn main() {
    let file = fs::read_to_string("10-1/input.txt").expect("");
    let file = file.trim();

    let values: Vec<String> = file.split(" ").

    for _ in 1..6 {
        for value in values {
            let res = blink(value);
            println!("{:?}", res);
        }
    }
}
