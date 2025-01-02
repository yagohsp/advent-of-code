use std::fs;

fn main() {
    let file = fs::read_to_string("07/input.txt").expect("");
    let lines = file.lines();

    let mut all_values: Vec<(usize, Vec<usize>)> = Vec::new();

    for line in lines {
        let line_values: Vec<_> = line.split(": ").collect();

        let total: usize = line_values[0].parse().unwrap();

        let mut values_vec: Vec<usize> = Vec::new();

        for (_, value) in line_values[1].split(" ").enumerate() {
            let value: usize = value.parse().unwrap();

            values_vec.push(value);
        }
        all_values.push((total, values_vec));
    }

    let mut count = 0;

    for (total, values) in all_values {
        let decimal_num = values.len() - 1;

        let two: usize = 2;
        let mut size = two.pow(decimal_num as u32);

        if size == 1 {
            size = 2;
        }
        // println!("----{}----", total);
        // println!("size - {}", size);
        for x in 0..size {
            let binary = format!("{:0decimal_num$b}", x);

            // println!("binary - {}", binary);
            let mut sum = values[0];

            let b_vec = binary.chars();

            for (index, c) in b_vec.enumerate() {
                if index <= values.len() {
                    if c == '0' {
                        sum += values[index + 1];
                    } else {
                        sum *= values[index + 1];
                    }
                }
            }

            if total == sum {
                // count += 1;
                count += sum;
                break;
                // println!("::::{}", sum);
            } else {
                // println!("{}", sum);
            }
        }

        println!("");
    }
    println!("{}", count);
}
