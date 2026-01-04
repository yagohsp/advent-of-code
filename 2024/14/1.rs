use std::fs;

const SIZE_X: usize = 101;
const SIZE_Y: usize = 103;

const MID_X: usize = (SIZE_X - 1) / 2;
const MID_Y: usize = (SIZE_Y - 1) / 2;

fn main() {
    let file = fs::read_to_string("./puzzle.txt").expect("");
    let lines = file.lines();

    let mut quadrants: [usize; 4] = [0; 4];

    for line in lines {
        let values: Vec<&str> = line.split(" ").collect();

        let position = values[0].split_at(2).1;
        let position: Vec<&str> = position.split(",").collect();
        let position_x = position[0].parse::<isize>().unwrap();
        let position_y = position[1].parse::<isize>().unwrap();

        let direction = values[1].split_at(2).1;
        let direction: Vec<&str> = direction.split(",").collect();
        let direction_x = direction[0].parse::<isize>().unwrap();
        let direction_y = direction[1].parse::<isize>().unwrap();

        let mut final_x = (position_x + direction_x * 100) % SIZE_X as isize;
        let mut final_y = (position_y + direction_y * 100) % SIZE_Y as isize;

        if final_x < 0 {
            final_x = SIZE_X as isize + final_x;
        }

        if final_y < 0 {
            final_y = SIZE_Y as isize + final_y;
        }

        let final_x = final_x as usize;
        let final_y = final_y as usize;

        if final_x < MID_X && final_y < MID_Y {
            quadrants[0] += 1;
            continue;
        }
        if final_x > MID_X && final_y < MID_Y {
            quadrants[1] += 1;
            continue;
        }
        if final_x < MID_X && final_y > MID_Y {
            quadrants[2] += 1;
            continue;
        }
        if final_x > MID_X && final_y > MID_Y {
            quadrants[3] += 1;
            continue;
        }
    }

    let res = quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3];
    println!("{}", res)
}
