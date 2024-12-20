use std::fs;

fn print_ternary(ternary: &Vec<char>) {
    let mut result = Vec::new();
    for n in ternary.iter() {
        if *n == '0' {
            result.push('+');
        } else if *n == '1' {
            result.push('*');
        } else {
            result.push('|');
        }
    }
    println!("{:?}", result);
}

fn to_base3(mut n: usize, len: usize) -> String {
    let mut result = String::new();
    while n > 0 {
        result.push_str(&(n % 3).to_string());
        n /= 3;
    }

    while result.len() < len {
        result.push_str("0");
    }

    result.chars().rev().collect()
}

fn main() {
    let file = fs::read_to_string("7-2/input-teste.txt").expect("");
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

        let three: usize = 3;
        let mut size = three.pow(decimal_num as u32);

        if size == 1 {
            size = 3;
        }

        // println!("{:?}", values);
        for x in 0..size {
            let ternary = to_base3(x, decimal_num);
            let ternary_chars: Vec<char> = ternary.chars().collect();
            // print_ternary(&ternary_chars);

            let mut sum = values[0];

            for (index, c) in ternary_chars.iter().enumerate() {
                let values = values.clone();
                if index <= values.len() {
                    if *c == '0' {
                        println!("{} + {}", sum, values[index + 1]);
                        sum += values[index + 1];
                    } else if *c == '1' {
                        println!("{} * {}", sum, values[index + 1]);
                        sum *= values[index + 1];
                    } else {
                        if index == 0 {
                            let old = values[index + 1];
                            let a = values[index].to_string();
                            let b = old.to_string();

                            let new: usize = format!("{}{}", a, b).parse().unwrap();
                            sum = new;
                        } else {
                            let old = values[index - 1];
                            let a = values[index].to_string();
                            let b = old.to_string();

                            let new: usize = format!("{}{}", a, b).parse().unwrap();
                            if ternary_chars[index - 1] == '0' {
                                println!("{} - {} then {} + {}", sum, old, sum - old, new);
                                sum -= old;
                                sum += new;
                            } else if ternary_chars[index - 1] == '1' {
                                println!("{} / {} then {} * {}", sum, old, sum / old, new);
                                sum /= old;
                                sum *= new;
                            }
                        }
                    }
                }
            }
            println!("{:?}", values);
            print_ternary(&ternary_chars);
            println!("{}", sum);
            println!("");
            if sum == total {
                count += total;
                break;
            }
            // println!("total: {} || sum: {}", total, sum);
            // println!("");
        }
    }
    println!("{}", count);
}