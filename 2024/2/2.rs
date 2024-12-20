use std::fs;

fn verify(values: &Vec<&str>) -> usize {
    let mut dir = 0;
    let len = values.len();

    for (index, value) in values.iter().enumerate() {
        if index == len - 1 {
            return 999;
        }

        let value: u32 = value.parse().unwrap();
        let next_value: u32 = values[index + 1].parse().unwrap();

        if value == next_value {
            return index;
        }

        if index == 0 {
            if value > next_value && value - next_value <= 3 {
                dir = -1;
                continue;
            } else if value < next_value && next_value - value <= 3 {
                dir = 1;
                continue;
            }
            return index;
        } else if dir == 1 {
            if value > next_value {
                return index;
            }
            if next_value - value > 3 {
                return index;
            }
            continue;
        }
        if value < next_value {
            return index;
        }
        if value - next_value > 3 {
            return index;
        }
    }

    println!("n devia");
    return 999;
}

fn main() {
    let file = fs::read_to_string("2/input.txt").expect("");
    let lines = file.lines();

    let mut result = 0;

    for line in lines {
        let values: Vec<_> = line.split(" ").collect();

        let verify_index = verify(&values);

        if verify_index == 999 {
            result += 1;
        } else {
            for (index, _) in values.iter().enumerate() {
                let mut new_values = values.clone();
                new_values.remove(index);

                let re_verify_index = verify(&new_values);
                if re_verify_index == 999 {
                    result += 1;
                    break;
                }
            }
        }
    }
    println!("{}", result);
}
