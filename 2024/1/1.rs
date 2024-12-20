use std::fs;

fn main() {
    let file = fs::read_to_string("1/input.txt").expect("");

    let lines = file.lines();

    let values = lines.map(|line| {
        let line_values: Vec<_> = line.split("   ").collect();

        let val1: u32 = line_values[0].parse().expect("");
        let val2: u32 = line_values[1].parse().expect("");

        [val1, val2]
    });

    let mut columns: Vec<Vec<u32>> = Vec::new();

    columns.push(Vec::new());
    columns.push(Vec::new());

    for value in values {
        columns[0].push(value[0]);
        columns[1].push(value[1]);
    }

    columns[0].sort();
    columns[1].sort();

    let mut response = 0;

    for (index, value1) in columns[0].iter().enumerate() {
        let mut result = 0;
        let value2 = columns[1][index];

        if *value1 > value2 {
            result += *value1 - value2;
        } else {
            result += value2 - *value1;
        }

        response += result;
    }

    println!("{}", response);
}
