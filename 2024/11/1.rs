use std::fs;

fn blink(value: String) -> Vec<String> {
    if value == "0" {
        return vec!["1".to_string()];
    }
    if value.len() % 2 == 0 {
        let (v1, v2) = value.split_at(value.len() / 2);
        let v1: usize = v1.parse().unwrap();
        let v2: usize = v2.parse().unwrap();
        return vec![v1.to_string(), v2.to_string()];
    }

    let value: usize = value.parse().unwrap();
    let value = value * 2024;

    return vec![value.to_string()];
}

fn main() {
    let file = fs::read_to_string("11/input.txt").expect("");
    let file = file.trim();

    let mut values: Vec<String> = file.split(" ").map(|v| v.to_string()).collect();

    for i in 0..25 {
        let mut temp: Vec<String> = Vec::new();

        for value in &values {
            let res = blink(value.to_string());
            temp.extend(res);
        }
        values = temp;
        println!("{}", i);
    }

    println!("{}", values.len());
}
