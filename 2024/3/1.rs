use std::fs;

fn get_mul(str: &str) -> (bool, usize, usize) {
    let mut n1 = String::new();
    let mut n2 = String::new();
    let mut has_comma = false;

    for c in str.chars() {
        if c.is_numeric() {
            if has_comma {
                if n2.len() <= 2 {
                    n2.push(c);
                    continue;
                }
            } else {
                if n1.len() <= 2 {
                    n1.push(c);
                    continue;
                }
            }
        } else if c == ',' {
            has_comma = true;
            continue;
        } else if c == ')' && n1.len() > 0 && n2.len() > 0 {
            let n1: usize = n1.parse().expect("");
            let n2: usize = n2.parse().expect("");

            return (true, n1, n2);
        }
        return (false, 0, 0);
    }
    return (false, 0, 0);
}

fn main() {
    let file = fs::read_to_string("3/input.txt").unwrap();

    let mut puzzle = String::new();

    for line in file.lines() {
        puzzle.push_str(line);
    }

    let mut result = 0;

    loop {
        let mul = puzzle.find("mul(");

        match mul {
            Some(x) => {
                puzzle = puzzle.split_off(x + 4);

                let (valid, n1, n2) = get_mul(&puzzle);

                if valid {
                    result += n1 * n2;
                }
                continue;
            }
            None => {
                break;
            }
        }
    }

    println!("{}", result);
}
