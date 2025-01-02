use std::fs;

fn main() {
    let file = fs::read_to_string("02/input.txt").expect("");
    let lines = file.lines();

    let mut result = 0;

    for line in lines {
        let values: Vec<_> = line.split(" ").collect();
        let len = values.len();

        let mut dir = 0;

        for (index, value) in values.iter().enumerate() {
            if index == len - 1 {
                result += 1;
                break;
            }

            let value: u32 = value.parse().unwrap();
            let next_value: u32 = values[index + 1].parse().unwrap();

            if value == next_value {
                break;
            }

            if index == 0 {
                if value > next_value && value - next_value <= 3 {
                    dir = -1;
                    continue;
                } else if value < next_value && next_value - value <= 3 {
                    dir = 1;
                    continue;
                }
                break;
            } else if dir == 1 {
                if value > next_value {
                    break;
                }
                if next_value - value > 3 {
                    break;
                }
                continue;
            }
            if value < next_value {
                break;
            }
            if value - next_value > 3 {
                break;
            }
        }
    }

    println!("{}", result);
}
