use std::fs;

struct XY {
    x: usize,
    y: usize,
}

struct Machine {
    a: XY,
    b: XY,
    prize: XY,
}

fn main() {
    let file = fs::read_to_string("13/input.txt").expect("");
    let mut lines: Vec<&str> = Vec::new();

    for line in file.lines() {
        if line != "" {
            lines.push(line);
        }
    }

    let machines_count = lines.len() / 3;
    let mut machines: Vec<Machine> = Vec::new();

    for m_index in 0..machines_count {
        let l_index = m_index * 3;

        let a: Vec<&str> = lines[l_index].split("A: X+").collect();
        let a: Vec<&str> = a[1].split(", Y+").collect();
        let (a_x, a_y) = (a[0].parse().unwrap(), a[1].parse().unwrap());

        let b: Vec<&str> = lines[l_index + 1].split("B: X+").collect();
        let b: Vec<&str> = b[1].split(", Y+").collect();
        let (b_x, b_y) = (b[0].parse().unwrap(), b[1].parse().unwrap());

        let prize: Vec<&str> = lines[l_index + 2].split("X=").collect();
        let prize: Vec<&str> = prize[1].split(", Y=").collect();
        let (prize_a, prize_b) = (prize[0].parse().unwrap(), prize[1].parse().unwrap());

        let machine = Machine {
            a: XY { x: a_x, y: a_y },
            b: XY { x: b_x, y: b_y },
            prize: XY {
                x: prize_a,
                y: prize_b,
            },
        };
        machines.push(machine);
    }

    let mut min_tokens: Vec<usize> = Vec::new();

    for machine in machines {
        let mut tokens: Vec<usize> = Vec::new();
        let button_a = (machine.a.x, machine.a.y);
        let button_b = (machine.b.x, machine.b.y);
        let (prize_x, prize_y) = (machine.prize.x, machine.prize.y);

        let mut press_a = 100;
        let mut press_b = 0;

        while press_a > 0 {
            let (total_x, total_y) = (
                press_a * button_a.0 + press_b * button_b.0,
                press_a * button_a.1 + press_b * button_b.1,
            );

            if total_x > prize_x || total_y > prize_y {
                press_a -= 1;
                continue;
            }

            if total_x == prize_x && total_y == prize_y {
                let token = 3 * press_a + press_b;
                tokens.push(token);
                break;
            }
            press_b += 1;
        }

        let min = tokens.iter().min();
        match min {
            Some(&v) => min_tokens.push(v),
            None => {}
        }
    }

    let total: usize = min_tokens.iter().sum();
    println!("{:?}", total);
}
